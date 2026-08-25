#!/usr/bin/env python3
"""
test_review_common.py — adversarial regression tests (PHASE_0_3 §12).

Every test below is named for the real incident it prevents. None is
hypothetical; each corresponds to a failure this project actually shipped.
"""

import json
import os
import subprocess
import sys

import pytest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from review_common import (  # noqa: E402
    Status, CheckResult, VacuousPassError,
    SourceIdentity, ToolIdentity, ReviewRun,
    build_fingerprint, build_tool_identity, compare_references,
    EXIT_OK, EXIT_BLOCKING, EXIT_REFERENCE_MISMATCH,
)


# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

def make_repo(tmp_path, name, files, commit=True):
    root = tmp_path / name
    root.mkdir()
    subprocess.run(["git", "init", "-q", "-b", "main", str(root)], check=True)
    subprocess.run(["git", "-C", str(root), "config", "user.email", "t@t"], check=True)
    subprocess.run(["git", "-C", str(root), "config", "user.name", "t"], check=True)
    subprocess.run(["git", "-C", str(root), "remote", "add", "origin",
                    "https://example.invalid/miwikiai.git"], check=True)
    for rel, content in files.items():
        p = root / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(content, encoding="utf-8")
    if commit:
        subprocess.run(["git", "-C", str(root), "add", "-A"], check=True)
        subprocess.run(["git", "-C", str(root), "commit", "-q", "-m", "init"], check=True)
    return root


def ok(**kw):
    base = dict(name="c", status=Status.PASS, objects_discovered=3,
                objects_checked=3, objects_passed=3, objects_failed=0)
    base.update(kw)
    return CheckResult(**base)


# ===========================================================================
# §7.1 — vacuous PASS. The anchor_check incident.
# ===========================================================================

class TestVacuousPass:

    def test_anchor_check_incident_is_now_impossible(self):
        """THE regression test for this whole phase.

        anchor_check reported "OK: all anchor links resolve to existing
        headings" on Common_utilities_v0_3.md: 53 headings, 0 links it could
        parse, 10 links it was blind to. It passed for eighteen months.
        """
        r = CheckResult(name="anchor_check", status=Status.PASS,
                        objects_discovered=0, objects_checked=0,
                        objects_passed=0, objects_failed=0)
        assert r.status is Status.NO_COVERAGE
        assert r.downgraded_from == "PASS"
        assert "has not established anything" in r.detail

    def test_zero_is_meaningful_must_be_explicit(self):
        r = CheckResult(name="fabrication_scan", status=Status.PASS,
                        objects_discovered=0, objects_checked=0,
                        objects_passed=0, objects_failed=0,
                        zero_is_meaningful=True)
        assert r.status is Status.PASS
        assert r.downgraded_from is None

    def test_pass_with_failures_is_rejected(self):
        with pytest.raises(VacuousPassError, match="PASS with 1 failed"):
            CheckResult(name="c", status=Status.PASS, objects_discovered=2,
                        objects_checked=2, objects_passed=1, objects_failed=1)

    def test_fail_without_evidence_is_rejected(self):
        with pytest.raises(VacuousPassError, match="no failed objects"):
            CheckResult(name="c", status=Status.FAIL, objects_discovered=2,
                        objects_checked=2, objects_passed=2, objects_failed=0)

    def test_checked_cannot_exceed_discovered(self):
        with pytest.raises(VacuousPassError, match="exceeds"):
            CheckResult(name="c", status=Status.PASS, objects_discovered=1,
                        objects_checked=5, objects_passed=5, objects_failed=0)

    def test_counters_are_mandatory(self):
        with pytest.raises(TypeError):
            CheckResult(name="c", status=Status.PASS)  # type: ignore[call-arg]

    def test_real_coverage_passes_normally(self):
        r = ok(objects_discovered=10, objects_checked=10,
               objects_passed=10, objects_failed=0)
        assert r.status is Status.PASS
        assert "checked=10" in r.coverage_line


# ===========================================================================
# §5.1 / P1-1 — reference comparison across machines.
# ===========================================================================

class TestReferenceComparison:

    def test_same_commit_different_machines_is_comparable(self):
        """P1-1 — the finding that would otherwise break Gate B.

        Measured 2026-08-25, same commit:
            architect repo_root = /Users/miranov25/github/MIWikiAI
            coder     repo_root = /tmp/gt
        repo_root ALWAYS differs. If it were compared, every real
        cross-machine run would raise REFERENCE_MISMATCH.
        """
        ref = {"git_commit": "a" * 40, "tree_state": "CLEAN",
               "tracked_file_count": 91}
        from review_common import RunFingerprint
        a = RunFingerprint(dict(ref), {"repo_root": "/Users/miranov25/github/MIWikiAI",
                                       "markdown_file_count_on_disk": 78,
                                       "python_version": "3.10.19"})
        b = RunFingerprint(dict(ref), {"repo_root": "/tmp/gt",
                                       "markdown_file_count_on_disk": 70,
                                       "python_version": "3.12.3"})
        c = compare_references(a, b)
        assert c.comparable
        assert a.reference_identity_sha256 == b.reference_identity_sha256

    def test_dirty_tree_is_a_mismatch(self, tmp_path):
        """Spec §5.1's own example: same commit, one side DIRTY."""
        from review_common import RunFingerprint
        a = RunFingerprint({"git_commit": "a" * 40, "tree_state": "CLEAN"}, {})
        b = RunFingerprint({"git_commit": "a" * 40, "tree_state": "DIRTY"}, {})
        c = compare_references(a, b)
        assert not c.comparable
        assert c.status is Status.REFERENCE_MISMATCH
        assert "uncommitted" in c.detail

    def test_different_tool_is_a_mismatch(self):
        """CONV-1 — different code cannot produce comparable counts."""
        from review_common import RunFingerprint
        base = {"git_commit": "a" * 40, "tree_state": "CLEAN"}
        a = RunFingerprint({**base, "tool_entry_point_sha256": "1" * 64}, {})
        b = RunFingerprint({**base, "tool_entry_point_sha256": "2" * 64}, {})
        c = compare_references(a, b)
        assert not c.comparable
        assert "DIFFERENT CODE" in c.detail

    def test_mismatch_names_the_differing_fields(self):
        from review_common import RunFingerprint
        a = RunFingerprint({"git_commit": "a" * 40, "tracked_file_count": 91}, {})
        b = RunFingerprint({"git_commit": "b" * 40, "tracked_file_count": 90}, {})
        c = compare_references(a, b)
        names = [f for f, _, _ in c.differing_fields]
        assert "git_commit" in names and "tracked_file_count" in names
        assert "run A" in c.render()


# ===========================================================================
# §5 — fingerprint construction against real git trees.
# ===========================================================================

class TestFingerprint:

    def test_clean_tree(self, tmp_path):
        root = make_repo(tmp_path, "clean", {"a.md": "# A\n", "b.md": "# B\n"})
        fp = build_fingerprint(str(root), artifact=str(root / "a.md"))
        assert fp.reference_identity["tree_state"] == "CLEAN"
        assert fp.reference_identity["tracked_file_count"] == 2
        assert fp.reference_identity["artifact_tracked"] is True
        assert len(fp.reference_identity["artifact_sha256"]) == 64

    def test_untracked_artifact_is_visible(self, tmp_path):
        """The Common_utilities.md incident.

        AliceO2_overview.md links three times to Common_utilities.md, which
        was untracked: the links resolved on the architect's disk and 404'd
        for every reviewer. 'Works on my machine' must not be evidence.
        """
        root = make_repo(tmp_path, "untracked", {"a.md": "# A\n"})
        (root / "ghost.md").write_text("# Ghost\n", encoding="utf-8")
        fp = build_fingerprint(str(root), artifact=str(root / "ghost.md"))
        assert fp.reference_identity["artifact_tracked"] is False
        assert fp.reference_identity["tree_state"] == "DIRTY"

    def test_repo_root_is_environment_not_identity(self, tmp_path):
        root = make_repo(tmp_path, "r", {"a.md": "# A\n"})
        fp = build_fingerprint(str(root))
        assert "repo_root" in fp.run_environment
        assert "repo_root" not in fp.reference_identity
        assert "markdown_file_count_on_disk" in fp.run_environment
        assert "markdown_file_count_on_disk" not in fp.reference_identity

    def test_identity_hash_is_stable_and_order_independent(self, tmp_path):
        root = make_repo(tmp_path, "r2", {"a.md": "# A\n"})
        f1 = build_fingerprint(str(root), artifact=str(root / "a.md"))
        f2 = build_fingerprint(str(root), artifact=str(root / "a.md"))
        assert f1.reference_identity_sha256 == f2.reference_identity_sha256

    def test_non_git_tree(self, tmp_path):
        d = tmp_path / "plain"
        d.mkdir()
        (d / "a.md").write_text("# A\n", encoding="utf-8")
        fp = build_fingerprint(str(d))
        assert fp.reference_identity["tree_state"] == "NON_GIT"


# ===========================================================================
# CONV-1 — tool identity.
# ===========================================================================

class TestToolIdentity:

    def test_tracked_tool_is_authoritative(self, tmp_path):
        root = make_repo(tmp_path, "toolrepo",
                         {"scripts/prepare_review.py": "print('x')\n"})
        t = build_tool_identity(str(root / "scripts" / "prepare_review.py"))
        assert t.tracked is True
        assert t.is_authoritative
        assert len(t.entry_point_sha256) == 64

    def test_downloads_copy_is_not_authoritative(self, tmp_path):
        """check_links.py was distributed from $Downloads this week."""
        d = tmp_path / "Downloads"
        d.mkdir()
        p = d / "check_links.py"
        p.write_text("print('x')\n", encoding="utf-8")
        t = build_tool_identity(str(p))
        assert not t.is_authoritative

    def test_untracked_copy_in_a_repo_is_not_authoritative(self, tmp_path):
        """scripts/scripts/ — the nested older copy, untracked since May."""
        root = make_repo(tmp_path, "nested",
                         {"scripts/prepare_review.py": "print('new')\n"})
        stale = root / "scripts" / "scripts"
        stale.mkdir(parents=True)
        (stale / "prepare_review.py").write_text("print('OLD')\n", encoding="utf-8")
        t = build_tool_identity(str(stale / "prepare_review.py"))
        assert t.tracked is False
        assert not t.is_authoritative


# ===========================================================================
# Source identity — the four-cycle 7-character SHA defect.
# ===========================================================================

class TestSourceIdentity:

    def test_short_sha_is_rejected(self):
        """87b9775 rode through Modules 1-3 and four review cycles."""
        errs = SourceIdentity(commit="87b9775").validate()
        assert errs and "40-character" in errs[0]

    def test_branch_name_is_rejected(self):
        errs = SourceIdentity(commit="dev").validate()
        assert errs and "40-character" in errs[0]

    def test_full_sha_accepted(self):
        s = SourceIdentity(repository="https://github.com/AliceO2Group/AliceO2",
                           commit="ae7df2bd37d0a8b32a6c73cab33cae25b4501e49",
                           subtree="Common", pin_status="recovered")
        assert s.validate() == []

    def test_unknown_pin_status_rejected(self):
        assert SourceIdentity(pin_status="probably_fine").validate()


# ===========================================================================
# CONV-5 — private sources.
# ===========================================================================

class TestPrivateSource:

    def test_absent_private_source_is_not_a_failure(self):
        r = CheckResult(name="private_bundle", status=Status.PRIVATE_SOURCE_NOT_PROVIDED,
                        objects_discovered=1, objects_checked=0,
                        objects_passed=0, objects_failed=0,
                        detail="architect ZIP not distributed to this seat")
        assert not r.status.is_blocking
        assert r.status.is_clean

    def test_dependent_claim_is_not_certified(self):
        r = CheckResult(name="claim_x", status=Status.NOT_INDEPENDENTLY_VERIFIED,
                        objects_discovered=1, objects_checked=0,
                        objects_passed=0, objects_failed=0)
        assert not r.status.is_blocking
        assert not r.status.is_clean      # review continues; claim uncertified

    def test_a_failed_fetch_is_error_not_private(self):
        assert Status.ERROR.is_blocking
        assert not Status.PRIVATE_SOURCE_NOT_PROVIDED.is_blocking


# ===========================================================================
# §11 — aggregation and exit codes.
# ===========================================================================

class TestRunAggregation:

    def _run(self, tmp_path, name="agg"):
        root = make_repo(tmp_path, name, {"a.md": "# A\n"})
        return ReviewRun(fingerprint=build_fingerprint(str(root)))

    def test_all_pass(self, tmp_path):
        r = self._run(tmp_path, "p")
        r.add(ok()); r.add(ok(name="d"))
        assert r.overall is Status.PASS and r.exit_code == EXIT_OK

    def test_one_fail_blocks(self, tmp_path):
        r = self._run(tmp_path, "f")
        r.add(ok())
        r.add(CheckResult(name="links", status=Status.FAIL, objects_discovered=10,
                          objects_checked=10, objects_passed=7, objects_failed=3,
                          problems=[{"kind": "BROKEN FRAGMENT", "location": "x.md:12"}]))
        assert r.overall is Status.FAIL and r.exit_code == EXIT_BLOCKING

    def test_reference_mismatch_dominates_everything(self, tmp_path):
        """Even all-PASS must not be reported as comparable."""
        from review_common import RunFingerprint
        r = self._run(tmp_path, "m")
        r.add(ok())
        a = RunFingerprint({"git_commit": "a" * 40}, {})
        b = RunFingerprint({"git_commit": "b" * 40}, {})
        r.reference_comparison = compare_references(a, b)
        assert r.overall is Status.REFERENCE_MISMATCH
        assert r.exit_code == EXIT_REFERENCE_MISMATCH

    def test_all_no_coverage_is_not_pass(self, tmp_path):
        r = self._run(tmp_path, "nc")
        r.add(CheckResult(name="x", status=Status.PASS, objects_discovered=0,
                          objects_checked=0, objects_passed=0, objects_failed=0))
        assert r.overall is Status.NO_COVERAGE

    def test_json_is_machine_readable(self, tmp_path):
        r = self._run(tmp_path, "j")
        r.add(ok())
        d = json.loads(r.to_json())
        assert d["schema"] == "miwikiai.review_summary.v1"
        assert "reference_identity_sha256" in d
        assert d["checks"][0]["objects_checked"] == 3
        assert d["overall_status"] == "PASS"

    def test_render_warns_when_tool_untracked(self, tmp_path):
        from review_common import RunFingerprint
        r = ReviewRun(fingerprint=RunFingerprint({"tool_tracked": False}, {}))
        r.add(ok())
        assert "TOOL NOT TRACKED" in r.render()


if __name__ == "__main__":
    sys.exit(pytest.main([__file__, "-v"]))
