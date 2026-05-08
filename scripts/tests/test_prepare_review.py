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

import prepare_review as prepare_review

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
    """Symbol referenced in Signal: but not present in CSV → WARN, not failure (when fields complete)."""
    # Build an in-memory test: Signal: block for 'Baz' (not in usage.csv), all 6 fields present
    import tempfile
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write("""# Test
### 4.1 `Baz` (class)
**Signal:** prod_usage_count=99, confidence=high, churn_12m=0, workflows_direct=1, collision=false, uniqueness=unique
""")
        path = f.name
    try:
        rc, out = prepare_review.check_counters(path, str(FIXTURES / 'usage.csv'))
        # Not in CSV → warning (categorical), all fields present → no field-warn → rc=0
        assert 'Baz' in out
        assert 'not found in usage.csv' in out
        assert rc == 0  # warns are non-fatal per design
    finally:
        os.unlink(path)


def test_counter_signal_missing_fields_warns():
    """Bug D fix: Signal block missing mandated fields → field-presence WARN → rc=1.

    QRC v0.5.4 §2.6 mandates 6 fields in every Signal block. Cycle-4 CONV-ξ found
    a Signal block with only 3 fields and prefilter v1.2 said PASS. v1.3 must FAIL
    or WARN this case.
    """
    import tempfile
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write("""# Test
### 4.1 `Foo` (class)
**Signal:** prod_usage_count=10, workflows_direct=2, churn_12m=0
""")
        path = f.name
    try:
        rc, out = prepare_review.check_counters(path, str(FIXTURES / 'usage.csv'))
        assert 'FIELD-PRESENCE WARN' in out, f"Expected FIELD-PRESENCE WARN, got:\n{out}"
        assert 'confidence' in out
        assert 'collision' in out
        assert 'uniqueness' in out
        assert rc == 1, f"Expected FAIL on incomplete Signal block, got rc={rc}"
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
# Bug A: bare-name fabrication detection (cycle-4 L521 class)
# -----------------------------------------------------------------------------

def test_prose_fabrication_bare_name_detected():
    """Bug A fix: bare-name annotation fabrication ([CODE|CCDB|RT|RTF|CCDBPRIO|EXIM])
    in main body must FAIL the prose check.

    Reproduces cycle-4 L521 fabrication: artifact prose claims bare-name annotations
    RTF, CCDBPRIO, EXIM exist as runtime annotation states. Source has only 3.
    Prefilter v1.2 missed this because it searched only k-prefixed forms.
    v1.3 must catch it via word-boundary-matched bare-name terms.
    """
    import tempfile
    with tempfile.TemporaryDirectory() as empty_source:
        rc, out = prepare_review.check_prose_fabric(
            str(FIXTURES / 'bare_name_fabrication.md'),
            empty_source
        )
    assert rc == 1, f"Expected FAIL on bare-name fabrication fixture, got rc={rc}\n{out}"
    assert 'BODY OCCURRENCES' in out
    # Must name at least one of the bare-name terms (CCDBPRIO, RTF, or EXIM)
    assert any(t in out for t in ['CCDBPRIO', 'RTF', 'EXIM']), \
        f"Expected one of CCDBPRIO/RTF/EXIM in output:\n{out}"


def test_prose_fabrication_word_boundary_no_false_positive():
    """Word boundary matching: 'RTF' must NOT trigger false-positive when found
    inside larger words or as substrings of legitimate identifiers.

    Edge case: artifact contains 'kRTF' once in front-matter (disclosure). The
    bare term 'RTF' regex must use \\b word boundaries so 'RTF' inside 'kRTF'
    only matches the k-prefix term, not the bare term — preventing double-count.
    """
    import tempfile
    fixture = """---
revision_history:
  - summary: "kRTF removed from main body."
---

# Test artifact

The class is well-behaved with no fabrications.
"""
    with tempfile.NamedTemporaryFile('w', suffix='.md', delete=False) as f:
        f.write(fixture)
        path = f.name
    try:
        with tempfile.TemporaryDirectory() as empty_source:
            rc, out = prepare_review.check_prose_fabric(path, empty_source)
        # kRTF in front-matter → 1 hit total; rc=0 (PASS) because front-matter is disclosure.
        # No body hit because body is clean.
        assert rc == 0, f"Expected PASS (front-matter disclosure only), got rc={rc}\n{out}"
        assert 'FRONT-MATTER OCCURRENCES' in out
        # Should be 1, not 2 (no double-counting of kRTF as both kRTF and RTF)
        assert ': 1' in out or 'OCCURRENCES (acceptable — disclosure context): 1' in out
    finally:
        os.unlink(path)


# -----------------------------------------------------------------------------
# Bug B: VERBATIM character-exact diff (cycle-4 CONV-δ / CONV-ζ / CONV-ν class)
# -----------------------------------------------------------------------------

def test_verbatim_paraphrased_block_fails():
    """Bug B fix: VERBATIM block whose content paraphrases (does not exactly match)
    the cited source range must FAIL.

    Reproduces cycle-4 CONV-δ (EParamProvenance), CONV-ζ (S8 cross-file substitution),
    CONV-ν (getValueAs lambda omission). Prefilter v1.2 only checked path+range
    existence; v1.3 must diff block content against source character-by-character.
    """
    rc, out = prepare_review.check_verbatim(
        str(FIXTURES / 'verbatim_paraphrased.md'),
        str(FIXTURES / 'mock_source')
    )
    assert rc == 1, f"Expected FAIL on paraphrased VERBATIM block, got rc={rc}\n{out}"
    assert 'does NOT match source character-exact' in out, \
        f"Expected character-exact diff failure message in output:\n{out}"


# -----------------------------------------------------------------------------
# Bug C: label-discipline (informal forms instead of QRC bracket tags)
# -----------------------------------------------------------------------------

def test_verbatim_informal_forms_warned():
    """Bug C fix: artifact body using ONLY informal '// VERBATIM from' code-comments
    or '(verbatim from ...)' prose forms (zero QRC-compliant [VERBATIM <path>:L<a>-L<b>]
    bracket tags) must WARN about label discipline regression.

    Reproduces cycle-4 CONV-γ: v0.4 artifact dropped 35 [VERBATIM] tags, replaced
    with code-comment forms. Prefilter v1.2 counted 4 occurrences (all front-matter
    prose) and PASSed. v1.3 must distinguish QRC-compliant brackets from informal
    forms and WARN when body has fenced blocks but no QRC brackets.
    """
    rc, out = prepare_review.check_verbatim(
        str(FIXTURES / 'informal_verbatim_only.md'),
        str(FIXTURES / 'mock_source')
    )
    # Must contain label-discipline warning
    assert 'ZERO QRC-compliant' in out or 'label-discipline' in out.lower(), \
        f"Expected label-discipline warning in output:\n{out}"
    # rc should be 1 (FAIL) — body has fenced blocks but no QRC bracket tags
    assert rc == 1, f"Expected FAIL on informal-forms-only artifact, got rc={rc}\n{out}"


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


# v1.4 Enhancement 1 tests: single-line :L<n> citations (cycle-5 coverage gap closed)

def test_verbatim_singleline_correct_passes(tmp_path):
    """v1.4 Enh-1: [VERBATIM <path>:L<n>] (single-line) with char-exact match PASSes.

    v1.3 had no coverage for single-line citations — they fell through the regex
    and never reached char-exact diff. v1.4 brings them into the coverage envelope
    by making the lend regex group optional.
    """
    src_dir = tmp_path / "src"
    src_dir.mkdir()
    src_file = src_dir / "single.h"
    src_file.write_text("hello\nworld\nthird\n")  # L1=hello

    artifact = tmp_path / "artifact.md"
    artifact.write_text(
        "---\nversion: 0.1\n---\n\n"
        "## Section\n\n"
        "[VERBATIM single.h:L1]\n"
        "```cpp\n"
        "hello\n"
        "```\n"
    )

    rc, out = prepare_review.check_verbatim(str(artifact), str(src_dir))
    assert rc == 0, f"single-line :L<n> with correct content should PASS, got rc={rc}\n{out}"


def test_verbatim_singleline_fabricated_fails(tmp_path):
    """v1.4 Enh-1: [VERBATIM <path>:L<n>] (single-line) with fabricated content FAILs.

    This is the cycle-5 cxx:L498 scenario in miniature — Coder cited L498 (single
    line) and inserted a fabricated continuation phrase. v1.3 missed it because
    the regex required L<a>-L<b> range form. v1.4 must catch it.

    Per cycle-5 §3.5 measurement: closes the 1 confirmed False PASS / 5 bracket
    tags = 20% Tier-1 FN rate observed on Common_utilities_API.md v0.5.
    """
    src_dir = tmp_path / "src"
    src_dir.mkdir()
    src_file = src_dir / "param.cxx"
    src_file.write_text(
        "// Take a vector of strings, and\n"
        "// return a vector of pairs\n"
        "auto fn = [](){};\n"
    )

    artifact = tmp_path / "artifact.md"
    artifact.write_text(
        "---\nversion: 0.1\n---\n\n"
        "## Section\n\n"
        "[VERBATIM param.cxx:L1]\n"
        "```cpp\n"
        "// Take a vector of strings, and propagate to registry\n"
        "```\n"
    )

    rc, out = prepare_review.check_verbatim(str(artifact), str(src_dir))
    assert rc == 1, f"single-line :L<n> with fabricated content should FAIL, got rc={rc}\n{out}"
    assert 'does NOT match' in out or 'mismatch' in out.lower() or 'FAIL' in out, \
        f"Expected character-exact diff failure message in output:\n{out}"


