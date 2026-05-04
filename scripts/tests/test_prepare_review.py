"""
Unit tests for prepare_review.py v1.0

Run with:
    cd <repo-root>
    pytest scripts/tests/

What each test proves:

    test_anchor_clean             — anchor check passes on clean artifact
    test_anchor_broken            — anchor check FAILS when a link points to a non-existent heading
    test_counter_clean            — counter check passes when all Signal: claims match CSV
    test_counter_mismatch         — counter check FAILS when a Signal: claim disagrees with CSV
    test_counter_scope_table_ignored — scope-table cells with prod_usage_count are NOT phantom-flagged
                                       (this is the v0.4 false-positive bug we fixed)
    test_counter_symbol_not_in_csv — warning emitted (not failure) when symbol missing from CSV
    test_counter_signal_block_count — AST correctly identifies the Signal: paragraphs (not regex)
    test_prose_fabrication_clean  — prose-fabrication check passes when no fabricated terms present
    test_prose_fabrication_detected — prose-fabrication check FAILS when kCCDBPRIO etc appear in artifact
    test_verbatim_no_source_root  — verbatim check skips (rc=2) when source root unavailable
    test_detect_needs_clean       — auto-detect correctly identifies counter need
    test_detect_needs_fabrication — auto-detect for artifact with VERBATIM citations
"""

import os
import sys
from pathlib import Path

# Ensure scripts/ is on path
sys.path.insert(0, str(Path(__file__).parent.parent))

import prepare_review

FIXTURES = Path(__file__).parent / 'fixtures'


# -----------------------------------------------------------------------------
# CHECK 1: anchor validation
# -----------------------------------------------------------------------------

def test_anchor_clean():
    """Anchor check passes on clean artifact (no broken links)."""
    rc, out = prepare_review.check_anchors(str(FIXTURES / 'clean.md'))
    assert rc == 0, f"Expected PASS, got rc={rc}\n{out}"
    assert 'OK: all anchor links resolve' in out


def test_anchor_broken():
    """Anchor check FAILS when artifact has a broken anchor link."""
    rc, out = prepare_review.check_anchors(str(FIXTURES / 'broken_anchor.md'))
    assert rc == 1, f"Expected FAIL, got rc={rc}\n{out}"
    assert 'BROKEN ANCHORS' in out
    assert 'nonexistent-heading-here' in out


# -----------------------------------------------------------------------------
# CHECK 2: VERBATIM citation accuracy
# -----------------------------------------------------------------------------

def test_verbatim_no_source_root():
    """VERBATIM check skips (rc=2) when source root does not exist."""
    rc, out = prepare_review.check_verbatim(
        str(FIXTURES / 'clean.md'),
        '/nonexistent/source/root'
    )
    assert rc == 2, f"Expected SKIP, got rc={rc}\n{out}"
    assert 'SKIPPED' in out


# -----------------------------------------------------------------------------
# CHECK 3: counter signals
# -----------------------------------------------------------------------------

def test_counter_clean():
    """Counter check passes when all Signal: claims match usage.csv."""
    rc, out = prepare_review.check_counters(
        str(FIXTURES / 'clean.md'),
        str(FIXTURES / 'usage.csv')
    )
    assert rc == 0, f"Expected PASS, got rc={rc}\n{out}"
    assert 'OK: all Signal-block counter claims match' in out


def test_counter_mismatch():
    """Counter check FAILS when a Signal: claim disagrees with CSV.

    Reproduces the Sonnet2 cycle-3 S12 finding (workflows_direct=99 in artifact,
    but 2 in usage.csv). The check function must emit a MISMATCH line citing
    the symbol, metric, claimed value, and actual value.
    """
    rc, out = prepare_review.check_counters(
        str(FIXTURES / 'counter_mismatch.md'),
        str(FIXTURES / 'usage.csv')
    )
    assert rc == 1, f"Expected FAIL, got rc={rc}\n{out}"
    assert 'MISMATCH' in out
    assert 'Foo' in out
    assert 'workflows_direct' in out
    assert '99' in out  # claimed
    assert '2' in out   # actual


def test_counter_scope_table_ignored():
    """Scope-table cells with prod_usage_count are NOT counted as Signal claims.

    This is the v0.4 false-positive bug: line 106-style table cells like
    `| Foo | description, prod_usage_count=10 |` should be IGNORED. Only
    Signal: paragraphs are authoritative. clean.md has both forms and
    matching CSV; if the AST-based check correctly distinguishes them,
    no phantom mismatch is emitted.
    """
    rc, out = prepare_review.check_counters(
        str(FIXTURES / 'clean.md'),
        str(FIXTURES / 'usage.csv')
    )
    assert rc == 0, f"Scope-table cells leaked into counter check (false-positive bug). rc={rc}\n{out}"
    # Verify scope-table value (10 in clean.md table cell) did NOT trigger
    # a "claims 10" finding for any other symbol than the legitimate Signal
    assert 'MISMATCH' not in out


def test_counter_symbol_not_in_csv():
    """Symbol referenced in Signal: but not present in CSV → WARN, not failure."""
    # Build an in-memory test: Signal: block for 'Baz' (not in usage.csv)
    import tempfile
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write("""# Test
### 4.1 `Baz` (class)
**Signal:** prod_usage_count=99
""")
        path = f.name
    try:
        rc, out = prepare_review.check_counters(path, str(FIXTURES / 'usage.csv'))
        # Not in CSV → warning, but not failure (rc=0)
        assert 'Baz' in out
        assert 'not found in usage.csv' in out
        assert rc == 0  # warns are non-fatal per design
    finally:
        os.unlink(path)


def test_counter_signal_block_count():
    """AST correctly identifies the Signal: paragraphs.

    Verifies the check parses 2 Signal blocks from clean.md (Foo + Bar)
    and performs 2*3=6 metric checks (3 metrics per Signal block).
    """
    rc, out = prepare_review.check_counters(
        str(FIXTURES / 'clean.md'),
        str(FIXTURES / 'usage.csv')
    )
    assert 'Signal: blocks scanned: 2' in out, f"Expected 2 Signal blocks scanned\n{out}"
    assert 'Metric checks performed: 6' in out, f"Expected 6 metric checks (2 syms × 3 metrics)\n{out}"


# -----------------------------------------------------------------------------
# CHECK 4: prose-fabrication
# -----------------------------------------------------------------------------

def test_prose_fabrication_clean():
    """Prose-fabrication check passes when no fabricated terms present."""
    import tempfile
    with tempfile.TemporaryDirectory() as empty_source:
        rc, out = prepare_review.check_prose_fabric(
            str(FIXTURES / 'clean.md'),
            empty_source
        )
    assert rc == 0, f"Expected PASS on clean fixture, got rc={rc}\n{out}"
    assert 'RESULT: clean.' in out


def test_prose_fabrication_detected():
    """Prose-fabrication check FAILS when fabricated terms appear in artifact MAIN BODY.

    Reproduces the cycle-2 EParamProvenance fabrication: kCCDBPRIO, kRTF, kEXIM
    in artifact prose with no occurrence in source.
    """
    import tempfile
    # Use empty temp dir as source — guarantees no kCCDBPRIO/kRTF/kEXIM in source
    with tempfile.TemporaryDirectory() as empty_source:
        rc, out = prepare_review.check_prose_fabric(
            str(FIXTURES / 'with_fabrication.md'),
            empty_source
        )
    assert rc == 1, f"Expected FAIL on body-fabrication fixture, got rc={rc}\n{out}"
    assert 'kCCDBPRIO' in out
    assert 'kRTF' in out
    assert 'kEXIM' in out
    assert 'BODY OCCURRENCES' in out


def test_prose_fabrication_front_matter_only_passes():
    """Prose-fabrication check PASSES when fabricated terms appear ONLY in front-matter.

    This is the v1.1 distinction: occurrences in revision_history / changelog /
    known_verify_flags are documentation of the prior fabrication and acceptable.
    Only main-body occurrences asserting the identifier exists in source are P0.
    """
    import tempfile
    # Build a fixture: terms mentioned only in revision_history front-matter block
    fixture = """---
wiki_id: O2_TestSymbol_FrontMatterDisclosure
title: "Test artifact — disclosure in front-matter"
revision_history:
  - version: "0.3"
    summary: "Corrected EParamProvenance enum from 6 invented values (kCODE, kCCDB, kRT, kRTF, kCCDBPRIO, kEXIM) to 3 real values (kCODE, kCCDB, kRT)."
---

# Test artifact (front-matter disclosure only)

## 4. Per-symbol API

### 4.1 `Foo` (class)

**Signal:** prod_usage_count=10, workflows_direct=2, churn_12m=0

The class is well-defined with no fabricated identifiers in the body.
"""
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write(fixture)
        path = f.name
    try:
        with tempfile.TemporaryDirectory() as empty_source:
            rc, out = prepare_review.check_prose_fabric(path, empty_source)
        assert rc == 0, f"Expected PASS for front-matter-only disclosure, got rc={rc}\n{out}"
        assert 'FRONT-MATTER OCCURRENCES' in out
        assert 'PASS' in out or 'acceptable disclosure' in out
        assert 'BODY OCCURRENCES' not in out
    finally:
        os.unlink(path)


def test_prose_fabrication_body_AND_front_matter_fails():
    """Prose-fabrication check FAILS when terms in body, even if also in front-matter.

    A v0.3 artifact with both a revision_history disclosure AND an unfixed body
    occurrence must FAIL. Front-matter disclosure does not absolve body assertions.
    """
    import tempfile
    fixture = """---
revision_history:
  - summary: "kCCDBPRIO removed from main prose."
---

# Test artifact (incomplete fix)

The enum has values including kCCDBPRIO which controls priority.
"""
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write(fixture)
        path = f.name
    try:
        with tempfile.TemporaryDirectory() as empty_source:
            rc, out = prepare_review.check_prose_fabric(path, empty_source)
        assert rc == 1, f"Expected FAIL when body still has fabrication, got rc={rc}\n{out}"
        assert 'BODY OCCURRENCES' in out
    finally:
        os.unlink(path)


# -----------------------------------------------------------------------------
# Auto-detection logic
# -----------------------------------------------------------------------------

def test_detect_needs_clean():
    """Auto-detect: clean.md cites prod_usage_count → needs counter, no VERBATIM citations → no source needed."""
    needs_source, needs_counter = prepare_review.detect_needs(str(FIXTURES / 'clean.md'))
    assert needs_counter is True
    assert needs_source is False


def test_detect_needs_fabrication():
    """Auto-detect: with_fabrication.md has Signal: claims → needs counter."""
    needs_source, needs_counter = prepare_review.detect_needs(str(FIXTURES / 'with_fabrication.md'))
    assert needs_counter is True


# -----------------------------------------------------------------------------
# Upstream front-matter detection (v1.2 — for source.zip auto-scoping)
# -----------------------------------------------------------------------------

def test_extract_upstream_paths_basic():
    """_extract_upstream_paths reads title: fields from upstream: block of front-matter."""
    import tempfile
    fixture = """---
wiki_id: test
upstream:
  - id: file1
    title: "Common/Utils/include/CommonUtils/Foo.h"
  - id: file2
    title: "Common/Utils/src/Foo.cxx"
counter_baseline:
  pipeline_version: v0.5
---

# Test
"""
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write(fixture)
        path = f.name
    try:
        paths = prepare_review._extract_upstream_paths(path)
        assert len(paths) == 2
        assert "Common/Utils/include/CommonUtils/Foo.h" in paths
        assert "Common/Utils/src/Foo.cxx" in paths
    finally:
        os.unlink(path)


def test_extract_upstream_paths_no_block():
    """Returns empty list when no upstream block is present."""
    import tempfile
    fixture = """---
wiki_id: test
title: "no upstream"
---

# Test
"""
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write(fixture)
        path = f.name
    try:
        paths = prepare_review._extract_upstream_paths(path)
        assert paths == []
    finally:
        os.unlink(path)


def test_common_ancestor_subtree_basic():
    """Common ancestor returns the deepest path covering majority of inputs.

    Two of three paths share Common/Utils/include/CommonUtils — that's the
    longest directory shared by ≥majority. Bundling this subtree captures
    2 of 3 files plus everything else under that directory, which is the
    correct behavior for review preparation.
    """
    paths = [
        "Common/Utils/include/CommonUtils/Foo.h",
        "Common/Utils/src/Foo.cxx",
        "Common/Utils/include/CommonUtils/Bar.h",
    ]
    result = prepare_review._common_ancestor_subtree(paths)
    # Either Common/Utils (covers all 3) or deeper (covers majority) — both valid
    # Specifically: Common/Utils is shared by 3/3, Common/Utils/include/CommonUtils by 2/3
    # We want the deepest that meets the threshold; threshold = 3//2 + 1 = 2
    # So Common/Utils/include/CommonUtils (2/3) wins as "deeper and meets threshold"
    assert result == 'Common/Utils/include/CommonUtils' or result == 'Common/Utils', \
        f"Expected Common/Utils or deeper, got '{result}'"


def test_common_ancestor_subtree_full_majority():
    """When all paths share a single subtree at one level, that's the chosen ancestor."""
    paths = [
        "Common/Utils/Foo.h",
        "Common/Utils/Bar.h",
        "Common/Utils/Baz.cxx",
    ]
    # All 3 paths share Common/Utils — that's the answer
    result = prepare_review._common_ancestor_subtree(paths)
    assert result == 'Common/Utils', f"Expected 'Common/Utils', got '{result}'"


def test_common_ancestor_subtree_unrelated():
    """Common ancestor returns '' when paths don't share a 2+-component prefix."""
    paths = [
        "Common/Utils/Foo.h",
        "DataFormats/Reconstruction/Bar.h",
    ]
    assert prepare_review._common_ancestor_subtree(paths) == ''


def test_common_ancestor_subtree_strips_filename():
    """If the only common path includes a filename, drop it."""
    paths = [
        "Common/Utils/include/CommonUtils/Foo.h",
        "Common/Utils/include/CommonUtils/Foo.h",
    ]
    # Both same file → common is the file itself, but we want the directory
    result = prepare_review._common_ancestor_subtree(paths)
    assert result == 'Common/Utils/include/CommonUtils'
    assert '.h' not in result


def test_common_ancestor_subtree_real_artifact():
    """Run against the real v0.4 artifact format — should find 'Common/Utils' or deeper."""
    import tempfile
    # Mimic real artifact upstream block
    fixture = """---
wiki_id: O2_Common_utilities_API
upstream:
  - id: file1
    title: "Common/Utils/include/CommonUtils/ConfigurableParam.h"
  - id: file2
    title: "Common/Utils/include/CommonUtils/ConfigurableParamHelper.h"
  - id: file3
    title: "Common/Utils/src/ConfigurableParam.cxx"
  - id: file4
    title: "Common/Utils/src/ConfigurableParamHelper.cxx"
---

# Test
"""
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write(fixture)
        path = f.name
    try:
        paths = prepare_review._extract_upstream_paths(path)
        assert len(paths) == 4
        common = prepare_review._common_ancestor_subtree(paths)
        assert common == 'Common/Utils', f"Expected 'Common/Utils', got '{common}'"
    finally:
        os.unlink(path)
