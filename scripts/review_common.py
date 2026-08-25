#!/usr/bin/env python3
"""
review_common.py — MIWikiAI review-tooling foundation (PHASE_0_3, T3 + T5).

Implements the parts of PHASE_0_3_REVIEW_TOOLING v0.1 that everything else
depends on, with the amendments carried by the v0.1 consolidated review
(Claude5:MIWikiAI, 2026-08-25, 5 artifacts / 4 identities, unanimous [!]):

  spec  §5    run fingerprint contract
  spec  §5.1  reference comparison rule -> REFERENCE_MISMATCH
  spec  §7    check-result status vocabulary
  spec  §7.1  vacuous-PASS prohibition
  spec  §11   exit-code contract
  CONV-1      tool identity must be Git-addressable            (4/4 reviewers)
  CONV-2      explicit source-acquisition layer                (3/4)
  CONV-5      private-source status vocabulary                 (4/4)
  P1-1        reference_identity vs run_environment split      (Claude5)

DESIGN NOTES
------------

1. Vacuous PASS is made STRUCTURALLY IMPOSSIBLE, not merely forbidden.

   `anchor_check` reported "OK: all anchor links resolve" on a document with
   53 headings and zero links it could parse. It was not lying; it had
   genuinely checked everything it could see, which was nothing.

   Here, CheckResult REQUIRES the four coverage counters, and PASS with
   objects_checked == 0 is auto-downgraded to NO_COVERAGE unless the check
   explicitly declares `zero_is_meaningful=True`. A check cannot emit a
   vacuous PASS by omission — only by an explicit, reviewable declaration.

2. reference_identity and run_environment are SEPARATE.

   Spec §5 places `repo_root` (an absolute path) in the same block as
   `git_commit`. Measured 2026-08-25, same commit, two machines:

       architect  repo_root = /Users/miranov25/github/MIWikiAI
       coder      repo_root = /tmp/gt

   repo_root ALWAYS differs; markdown_file_count_on_disk differs whenever
   either party has any untracked file. A naive field-by-field comparison
   makes Gate B fail on every real cross-machine run, and REFERENCE_MISMATCH
   becomes noise people learn to ignore — worse than no check at all.

   So: reference_identity is compared and hashed; run_environment is
   recorded and never compared. Two parties compare ONE string,
   reference_identity_sha256, not twelve fields.

3. Acquisition is not authority (CONV-2).

   "The acquisition method is not authority. The resolved immutable source
   identity is authority."  -- GPT3:MIWikiAI

   A byte read from cache is worth exactly as much as a byte fetched live,
   PROVIDED both resolve to the same immutable identity. Hence `acquisition`
   lives in run_environment, while the resolved source identity lives in
   reference_identity.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone
from enum import Enum
from typing import Any, Optional

TOOL_SUITE_VERSION = "0.1.0"

FULL_SHA_RE = re.compile(r'^[0-9a-f]{40}$')


# --------------------------------------------------------------------------
# §7 status vocabulary
# --------------------------------------------------------------------------

class Status(str, Enum):
    """Every deterministic check returns exactly one of these."""

    PASS = "PASS"
    FAIL = "FAIL"
    WARN = "WARN"
    SKIP = "SKIP"
    NO_COVERAGE = "NO_COVERAGE"
    ERROR = "ERROR"
    REFERENCE_MISMATCH = "REFERENCE_MISMATCH"

    # CONV-5 — private sources. Two values, because they describe two
    # different objects and conflating them loses the distinction that
    # matters.
    #
    #   PRIVATE_SOURCE_NOT_PROVIDED  — an INPUT was declared unavailable to
    #                                  this seat by design. Not a failure.
    #   NOT_INDEPENDENTLY_VERIFIED   — a CLAIM depends on bytes this seat
    #                                  could not read. The review continues;
    #                                  the claim is not certified.
    #
    # Neither may be used for a fetch that simply failed. That is ERROR.
    PRIVATE_SOURCE_NOT_PROVIDED = "PRIVATE_SOURCE_NOT_PROVIDED"
    NOT_INDEPENDENTLY_VERIFIED = "NOT_INDEPENDENTLY_VERIFIED"

    @property
    def is_blocking(self) -> bool:
        return self in (Status.FAIL, Status.ERROR, Status.REFERENCE_MISMATCH)

    @property
    def is_clean(self) -> bool:
        """True when this status represents 'nothing to act on'."""
        return self in (Status.PASS, Status.SKIP,
                        Status.PRIVATE_SOURCE_NOT_PROVIDED)


# §11 exit-code contract
EXIT_OK = 0
EXIT_BLOCKING = 1
EXIT_USAGE = 2
EXIT_REFERENCE_MISMATCH = 3
EXIT_INTERNAL = 4


# --------------------------------------------------------------------------
# §7.1 check results — vacuous PASS is structurally impossible
# --------------------------------------------------------------------------

class VacuousPassError(RuntimeError):
    """Raised when a check tries to claim success it cannot support."""


@dataclass
class CheckResult:
    """Result of one deterministic check.

    The four coverage counters are REQUIRED. A check that cannot say how many
    objects it discovered cannot claim to have checked them.
    """

    name: str
    status: Status
    objects_discovered: int
    objects_checked: int
    objects_passed: int
    objects_failed: int
    problems: list[dict[str, Any]] = field(default_factory=list)
    detail: str = ""
    zero_is_meaningful: bool = False
    downgraded_from: Optional[str] = None

    def __post_init__(self):
        if isinstance(self.status, str):
            self.status = Status(self.status)

        for n in ("objects_discovered", "objects_checked",
                  "objects_passed", "objects_failed"):
            v = getattr(self, n)
            if not isinstance(v, int) or v < 0:
                raise VacuousPassError(
                    f"{self.name}: {n} must be a non-negative int, got {v!r}")

        if self.objects_checked > self.objects_discovered:
            raise VacuousPassError(
                f"{self.name}: checked ({self.objects_checked}) exceeds "
                f"discovered ({self.objects_discovered})")

        if self.objects_passed + self.objects_failed > self.objects_checked:
            raise VacuousPassError(
                f"{self.name}: passed+failed ({self.objects_passed}+"
                f"{self.objects_failed}) exceeds checked ({self.objects_checked})")

        # ---- the rule that exists because of anchor_check ----
        if self.status is Status.PASS and self.objects_checked == 0:
            if not self.zero_is_meaningful:
                self.downgraded_from = Status.PASS.value
                self.status = Status.NO_COVERAGE
                self.detail = (self.detail + " " if self.detail else "") + (
                    "auto-downgraded PASS -> NO_COVERAGE: zero objects checked. "
                    "A check that examined nothing has not established anything. "
                    "If zero genuinely means success for this check, declare "
                    "zero_is_meaningful=True explicitly.")

        if self.status is Status.PASS and self.objects_failed:
            raise VacuousPassError(
                f"{self.name}: PASS with {self.objects_failed} failed object(s)")

        if self.status is Status.FAIL and not self.objects_failed and not self.problems:
            raise VacuousPassError(
                f"{self.name}: FAIL with no failed objects and no problems recorded")

    @property
    def coverage_line(self) -> str:
        return (f"discovered={self.objects_discovered} "
                f"checked={self.objects_checked} "
                f"passed={self.objects_passed} "
                f"failed={self.objects_failed}")

    def to_dict(self) -> dict:
        d = asdict(self)
        d["status"] = self.status.value
        return d


# --------------------------------------------------------------------------
# git helpers
# --------------------------------------------------------------------------

def _git(root: str, *args: str) -> Optional[str]:
    try:
        r = subprocess.run(["git", "-C", root, *args],
                           capture_output=True, text=True, timeout=30)
        return r.stdout.strip() if r.returncode == 0 else None
    except Exception:
        return None


def sha256_file(path: str) -> Optional[str]:
    try:
        h = hashlib.sha256()
        with open(path, "rb") as fh:
            for chunk in iter(lambda: fh.read(1 << 16), b""):
                h.update(chunk)
        return h.hexdigest()
    except OSError:
        return None


# --------------------------------------------------------------------------
# §5 fingerprint — CONV-1 tool identity, P1-1 identity/environment split
# --------------------------------------------------------------------------

@dataclass
class ToolIdentity:
    """CONV-1 (4/4 reviewers) — the tool must be Git-addressable.

    'No coder-only $Downloads/check_links.py, architect-local patch, or
     reviewer-local variant may be accepted as the canonical check.'
        -- GPT3:MIWikiAI

    A semantic version string cannot express WHICH COPY ran. The entry-point
    SHA-256 can, and the repo commit says where it came from.
    """
    repository: Optional[str]
    commit: Optional[str]
    entry_point: str
    entry_point_sha256: Optional[str]
    suite_version: str = TOOL_SUITE_VERSION
    tracked: bool = False

    @property
    def is_authoritative(self) -> bool:
        """True only when the running tool is a committed, tracked artifact."""
        return bool(self.tracked and self.commit and FULL_SHA_RE.match(self.commit))


@dataclass
class SourceIdentity:
    """CONV-2 — the RESOLVED immutable identity, not how it was obtained."""
    repository: Optional[str] = None
    commit: Optional[str] = None
    subtree: Optional[str] = None
    source_manifest_sha256: Optional[str] = None
    bundle_sha256: Optional[str] = None
    pin_status: str = "not_applicable"   # recovered|new_baseline|snapshot_only|not_applicable

    def validate(self) -> list[str]:
        errs = []
        if self.commit and not FULL_SHA_RE.match(self.commit):
            errs.append(
                f"source commit {self.commit!r} is not a 40-character SHA. "
                "A branch name or short SHA is not a source identity "
                "(Source Identity Convention v0.3 §2, §7.4).")
        if self.pin_status not in ("recovered", "new_baseline",
                                   "snapshot_only", "not_applicable"):
            errs.append(f"unknown pin_status {self.pin_status!r}")
        return errs


def build_tool_identity(entry_point: str) -> ToolIdentity:
    entry_point = os.path.abspath(entry_point)
    tool_root = os.path.dirname(entry_point)
    top = _git(tool_root, "rev-parse", "--show-toplevel")
    repo = _git(tool_root, "config", "--get", "remote.origin.url") if top else None
    commit = _git(tool_root, "rev-parse", "HEAD") if top else None

    tracked = False
    rel = entry_point
    if top:
        rel = os.path.relpath(entry_point, top)
        # NOTE: `rel` is relative to the repository TOP, so the query must run
        # from `top`. Running it from the tool's own directory resolves `rel`
        # against that directory instead and silently reports every tracked
        # tool as untracked. Caught by
        # TestToolIdentity::test_tracked_tool_is_authoritative.
        tracked = _git(top, "ls-files", "--error-unmatch", rel) is not None

    return ToolIdentity(
        repository=repo,
        commit=commit,
        entry_point=rel,
        entry_point_sha256=sha256_file(entry_point),
        tracked=tracked,
    )


@dataclass
class RunFingerprint:
    """§5, with the P1-1 split.

    reference_identity  -> compared between runs; hashed into one string
    run_environment     -> recorded, displayed, NEVER compared
    """
    reference_identity: dict[str, Any]
    run_environment: dict[str, Any]

    @property
    def reference_identity_sha256(self) -> str:
        blob = json.dumps(self.reference_identity, sort_keys=True,
                          separators=(",", ":"), default=str)
        return hashlib.sha256(blob.encode()).hexdigest()

    def to_dict(self) -> dict:
        return {
            "reference_identity": self.reference_identity,
            "reference_identity_sha256": self.reference_identity_sha256,
            "run_environment": self.run_environment,
        }

    def render(self) -> str:
        L = ["--- RUN FINGERPRINT ---",
             "  reference_identity (COMPARED between runs):"]
        for k, v in sorted(self.reference_identity.items()):
            L.append(f"      {k:<28} {v}")
        L.append(f"  reference_identity_sha256    {self.reference_identity_sha256}")
        L.append("  run_environment (recorded, NEVER compared):")
        for k, v in sorted(self.run_environment.items()):
            L.append(f"      {k:<28} {v}")
        return "\n".join(L)


def build_fingerprint(repo_root: str,
                      artifact: Optional[str] = None,
                      source: Optional[SourceIdentity] = None,
                      tool: Optional[ToolIdentity] = None,
                      acquisition: str = "local_git") -> RunFingerprint:
    repo_root = os.path.abspath(repo_root)
    top = _git(repo_root, "rev-parse", "--show-toplevel")
    commit = _git(repo_root, "rev-parse", "HEAD") if top else None
    branch = _git(repo_root, "rev-parse", "--abbrev-ref", "HEAD") if top else None
    porcelain = _git(repo_root, "status", "--porcelain") if top else None
    tree_state = "NON_GIT" if not top else ("DIRTY" if porcelain else "CLEAN")

    tracked_list = (_git(repo_root, "ls-files") or "").splitlines() if top else []
    tracked_set = {os.path.normpath(os.path.join(top, r)) for r in tracked_list if r} if top else set()

    md_on_disk = 0
    for dirpath, dirnames, files in os.walk(repo_root):
        dirnames[:] = [d for d in dirnames if d != ".git"]
        md_on_disk += sum(1 for f in files if f.endswith(".md"))

    ref: dict[str, Any] = {
        "git_repository": _git(repo_root, "config", "--get", "remote.origin.url"),
        "git_commit": commit,
        "tree_state": tree_state,
        "tracked_file_count": len(tracked_set),
    }

    if artifact:
        ap = os.path.abspath(artifact)
        ref["artifact_path"] = os.path.relpath(ap, top or repo_root)
        ref["artifact_sha256"] = sha256_file(ap)
        ref["artifact_tracked"] = ap in tracked_set

    if source:
        ref["source_repository"] = source.repository
        ref["source_commit"] = source.commit
        ref["source_subtree"] = source.subtree
        ref["source_manifest_sha256"] = source.source_manifest_sha256
        ref["source_bundle_sha256"] = source.bundle_sha256
        ref["source_pin_status"] = source.pin_status

    if tool:
        ref["tool_repository"] = tool.repository
        ref["tool_commit"] = tool.commit
        ref["tool_entry_point"] = tool.entry_point
        ref["tool_entry_point_sha256"] = tool.entry_point_sha256
        ref["tool_tracked"] = tool.tracked

    env: dict[str, Any] = {
        # These differ between machines BY DESIGN. Comparing them makes
        # REFERENCE_MISMATCH fire on every cross-machine run.
        "repo_root": repo_root,
        "git_branch": branch,
        "markdown_file_count_on_disk": md_on_disk,
        "run_timestamp_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "python_version": sys.version.split()[0],
        "platform": sys.platform,
        "tool_suite_version": TOOL_SUITE_VERSION,
        "acquisition": acquisition,      # CONV-2: method is not authority
    }
    return RunFingerprint(reference_identity=ref, run_environment=env)


# --------------------------------------------------------------------------
# §5.1 reference comparison — compare identity BEFORE counts
# --------------------------------------------------------------------------

@dataclass
class ReferenceComparison:
    status: Status
    differing_fields: list[tuple[str, Any, Any]]
    detail: str

    @property
    def comparable(self) -> bool:
        return self.status is not Status.REFERENCE_MISMATCH

    def render(self) -> str:
        if self.comparable:
            return ("REFERENCE MATCH — the two runs used the same reference; "
                    "their counts are comparable.")
        L = ["REFERENCE_MISMATCH — the two runs did NOT use the same reference.",
             "  Do not compare result counts until this is resolved.",
             "  Differing identity fields:"]
        for name, a, b in self.differing_fields:
            L.append(f"      {name}")
            L.append(f"        run A: {a}")
            L.append(f"        run B: {b}")
        if self.detail:
            L.append(f"  {self.detail}")
        return "\n".join(L)


def compare_references(a: RunFingerprint, b: RunFingerprint) -> ReferenceComparison:
    """§5.1 — compare fingerprints BEFORE comparing counts.

    Only reference_identity participates. run_environment is ignored on
    purpose: repo_root and markdown_file_count_on_disk differ between any
    two machines, and letting them fire REFERENCE_MISMATCH would make the
    signal useless.
    """
    if a.reference_identity_sha256 == b.reference_identity_sha256:
        return ReferenceComparison(Status.PASS, [],
                                   "identity hashes match")

    diffs = []
    for k in sorted(set(a.reference_identity) | set(b.reference_identity)):
        va = a.reference_identity.get(k, "<absent>")
        vb = b.reference_identity.get(k, "<absent>")
        if va != vb:
            diffs.append((k, va, vb))

    hints = []
    if any(k == "tree_state" for k, _, _ in diffs):
        hints.append("tree_state differs: one side has uncommitted changes. "
                     "A DIRTY tree is not a shareable reference.")
    if any(k == "tracked_file_count" for k, _, _ in diffs):
        hints.append("tracked_file_count differs: the two sides are not at "
                     "the same commit, or one is a partial checkout.")
    if any(k.startswith("tool_") for k, _, _ in diffs):
        hints.append("tool identity differs: the two sides ran DIFFERENT CODE. "
                     "Result counts cannot be compared at all (CONV-1).")

    return ReferenceComparison(Status.REFERENCE_MISMATCH, diffs, " ".join(hints))


# --------------------------------------------------------------------------
# aggregation and reporting
# --------------------------------------------------------------------------

@dataclass
class ReviewRun:
    fingerprint: RunFingerprint
    results: list[CheckResult] = field(default_factory=list)
    reference_comparison: Optional[ReferenceComparison] = None

    def add(self, r: CheckResult) -> CheckResult:
        self.results.append(r)
        return r

    @property
    def overall(self) -> Status:
        if self.reference_comparison and not self.reference_comparison.comparable:
            return Status.REFERENCE_MISMATCH
        if any(r.status is Status.ERROR for r in self.results):
            return Status.ERROR
        if any(r.status is Status.FAIL for r in self.results):
            return Status.FAIL
        if any(r.status is Status.WARN for r in self.results):
            return Status.WARN
        if self.results and all(r.status is Status.NO_COVERAGE for r in self.results):
            return Status.NO_COVERAGE
        return Status.PASS

    @property
    def exit_code(self) -> int:
        o = self.overall
        if o is Status.REFERENCE_MISMATCH:
            return EXIT_REFERENCE_MISMATCH
        if o is Status.ERROR:
            return EXIT_INTERNAL
        if o is Status.FAIL:
            return EXIT_BLOCKING
        return EXIT_OK

    def to_json(self, indent: int = 2) -> str:
        return json.dumps({
            "schema": "miwikiai.review_summary.v1",
            "tool_suite_version": TOOL_SUITE_VERSION,
            **self.fingerprint.to_dict(),
            "reference_comparison": (
                {"status": self.reference_comparison.status.value,
                 "differing_fields": [
                     {"field": f, "run_a": a, "run_b": b}
                     for f, a, b in self.reference_comparison.differing_fields]}
                if self.reference_comparison else None),
            "checks": [r.to_dict() for r in self.results],
            "overall_status": self.overall.value,
            "exit_code": self.exit_code,
        }, indent=indent, default=str)

    def render(self) -> str:
        L = [self.fingerprint.render(), "-" * 74]

        tool_tracked = self.fingerprint.reference_identity.get("tool_tracked")
        if tool_tracked is False:
            L += ["!!! TOOL NOT TRACKED — the running tool is not a committed artifact.",
                  "    Its results are not reproducible by another party and must not",
                  "    be used as normative review evidence (CONV-1).", "-" * 74]

        if self.reference_comparison:
            L += [self.reference_comparison.render(), "-" * 74]

        for r in self.results:
            flag = ("FAIL" if r.status is Status.FAIL else
                    " ok " if r.status is Status.PASS else
                    r.status.value[:4])
            L.append(f"[{flag}] {r.name:<28} {r.status.value:<28} {r.coverage_line}")
            if r.downgraded_from:
                L.append(f"        note: downgraded from {r.downgraded_from} — {r.detail}")
            elif r.detail:
                L.append(f"        {r.detail}")
            for p in r.problems[:20]:
                loc = p.get("location", "")
                L.append(f"        - {p.get('kind','problem')}: {loc} {p.get('detail','')}")
            if len(r.problems) > 20:
                L.append(f"        ... {len(r.problems) - 20} more")

        L += ["-" * 74, f"OVERALL: {self.overall.value}   exit={self.exit_code}"]
        return "\n".join(L)


__all__ = [
    "Status", "CheckResult", "VacuousPassError",
    "ToolIdentity", "SourceIdentity", "RunFingerprint", "ReviewRun",
    "ReferenceComparison", "compare_references",
    "build_fingerprint", "build_tool_identity", "sha256_file",
    "EXIT_OK", "EXIT_BLOCKING", "EXIT_USAGE",
    "EXIT_REFERENCE_MISMATCH", "EXIT_INTERNAL",
    "TOOL_SUITE_VERSION", "FULL_SHA_RE",
]
