# Testing — `prepare_review.py` v1.0

This document explains what each unit test proves, how to run them, and what the testing strategy guarantees.

---

## How to run the tests

```bash
# From repository root:
cd /Users/miranov25/github/MIWikiAI

# Option 1: direct pytest invocation
python3 -m pytest scripts/tests/ -v

# Option 2: via the bash wrapper
bash scripts/prepare_review.sh --test
```

Expected output: **12 tests passed in <1 second**.

If any test fails, the output points at the failing assertion and reproduces the input — no debugging cycle of bash → re-run → cat-output. The unit test is the bug report.

---

## Dependencies

```bash
pip install mistletoe pytest
# (or, on some Linux distros with PEP 668:)
pip install --break-system-packages mistletoe pytest
```

`mistletoe` is a CommonMark-compliant Python markdown parser. It replaces v0.x's regex-based hand-rolled parsing.
`pytest` is the test runner.

---

## What each test proves

### Anchor check (2 tests)

| Test | What it proves |
|---|---|
| `test_anchor_clean` | Anchor check **passes** on a clean artifact (all `[label](#anchor)` links resolve to existing headings). Uses `clean.md` fixture. |
| `test_anchor_broken` | Anchor check **FAILS** when an artifact contains `[link](#nonexistent-heading-here)` that does not match any heading. Uses `broken_anchor.md` fixture. Verifies the broken anchor is named in the output. |

### VERBATIM check (1 test — full coverage requires real source tree)

| Test | What it proves |
|---|---|
| `test_verbatim_no_source_root` | VERBATIM check correctly **SKIPs** (rc=2) when source root is unavailable, rather than crashing or false-reporting PASS. |

VERBATIM check against real source files is verified by end-to-end run against the architect's repo (not unit-testable without bundling a real AliceO2 source tree).

### Counter check (5 tests — most thorough coverage)

| Test | What it proves |
|---|---|
| `test_counter_clean` | Counter check **passes** when all `**Signal:**` paragraph claims match `usage.csv` for the owning symbol heading. Uses `clean.md` + `usage.csv` fixtures. |
| `test_counter_mismatch` | Counter check **FAILS** when a Signal claim disagrees with CSV. Reproduces the **Sonnet2 cycle-3 S12 finding** (artifact says `workflows_direct=99`, CSV says `2`). Verifies the MISMATCH line names symbol, metric, claimed value, and actual value. Uses `counter_mismatch.md` fixture. |
| `test_counter_scope_table_ignored` | Scope-table cells like `\| Foo \| ..., prod_usage_count=10 \|` are **NOT** flagged as Signal claims. This is the **v0.4 false-positive bug we fixed**. The fixture `clean.md` has both a scope-table cell AND an authoritative Signal block for the same symbol; if the AST-based check correctly distinguishes them, only the Signal block matters and no phantom mismatch is emitted. |
| `test_counter_symbol_not_in_csv` | Symbol referenced in Signal: paragraph but missing from `usage.csv` triggers a **WARN** (not a failure). Verifies graceful handling of ambiguous-merge cases. |
| `test_counter_signal_block_count` | Verifies the AST-based parser identifies exactly 2 Signal: paragraphs in `clean.md` and performs 6 metric checks (2 symbols × 3 metrics each). Catches regressions where the AST traversal misses Signal: blocks. |

### Prose-fabrication check (2 tests)

| Test | What it proves |
|---|---|
| `test_prose_fabrication_clean` | Prose-fabrication check **passes** when no fabricated terms (kCCDBPRIO, kRTF, kEXIM) are present in the artifact. Uses `clean.md` fixture and an empty source root. |
| `test_prose_fabrication_detected` | Prose-fabrication check **FAILS** when the cycle-2 EParamProvenance fabrication terms appear in the artifact. Uses `with_fabrication.md` fixture (mimics the v0.1 artifact's defective enum listing). Verifies all three terms (kCCDBPRIO, kRTF, kEXIM) are named in the output and OCCURRENCES are listed. |

### Auto-detection (2 tests)

| Test | What it proves |
|---|---|
| `test_detect_needs_clean` | `detect_needs()` correctly identifies that an artifact citing `prod_usage_count` needs counter files but no VERBATIM citations means no source.zip needed. |
| `test_detect_needs_fabrication` | `detect_needs()` correctly identifies counter need for an artifact with Signal: claims. |

---

## What the testing strategy guarantees

### What WILL be caught

- **Counter check regressions** — if anyone refactors the AST traversal and breaks Signal: detection, `test_counter_signal_block_count` fails.
- **False-positive returns** — if anyone re-introduces the regex 200-char-window bug in counter check, `test_counter_scope_table_ignored` fails.
- **Real defects (Sonnet2 S12 class)** — `test_counter_mismatch` reproduces the kind of cycle-3 finding the prefilter must catch.
- **EParamProvenance class fabrications** — `test_prose_fabrication_detected` reproduces cycle-2 silent fabrication.
- **Anchor link breakage** — `test_anchor_broken` catches missing-heading references.

### What WON'T be caught (residual panel work)

- **Cross-file VERBATIM substitution (CONV-A2 class)**. Tests verify path-and-range-validity only. Character-level diff against quoted code blocks remains panel work. Documented in `prepare_review_DESIGN.md` §3.1.
- **Novel fabrications not in the term list**. The prose-fabrication check only catches *known* fabricated identifiers (currently kCCDBPRIO, kRTF, kEXIM). New cycles surface new fabrications via panel review; once caught, the term list grows. This is by design (incident-by-incident, per QRC v0.5.4 §2.7).
- **Aspect-C semantic prose-vs-VERBATIM judgment**. The full Aspect-C check (does prose paragraph contradict adjacent VERBATIM block?) is judgment work for Opus reviewers, not mechanical.
- **Aspect-E example plausibility**. FABRICATED examples are not parsed for syntactic/semantic validity. Panel work.

These limits are documented in `prepare_review_DESIGN.md` § Known false-negatives.

### Adding new tests

When a new defect class is found in panel review:

1. Add a fixture file demonstrating the defect to `scripts/tests/fixtures/`
2. Add a test asserting the prefilter detects it: `def test_<defect_class>_detected(): ...`
3. Verify the test fails before the prefilter is updated
4. Update the prefilter to catch it
5. Verify the test passes after the update
6. Commit fixture + test + prefilter change in one commit

This is standard test-driven development. The prefilter only needs to catch defect classes it has been told about; the unit test prevents regression once they're added.

---

## Self-test: 12/12 expected output

```
$ python3 -m pytest scripts/tests/ -v
============================= test session starts ==============================
collected 12 items

scripts/tests/test_prepare_review.py::test_anchor_clean PASSED           [  8%]
scripts/tests/test_prepare_review.py::test_anchor_broken PASSED          [ 16%]
scripts/tests/test_prepare_review.py::test_verbatim_no_source_root PASSED [ 25%]
scripts/tests/test_prepare_review.py::test_counter_clean PASSED          [ 33%]
scripts/tests/test_prepare_review.py::test_counter_mismatch PASSED       [ 41%]
scripts/tests/test_prepare_review.py::test_counter_scope_table_ignored PASSED [ 50%]
scripts/tests/test_prepare_review.py::test_counter_symbol_not_in_csv PASSED [ 58%]
scripts/tests/test_prepare_review.py::test_counter_signal_block_count PASSED [ 66%]
scripts/tests/test_prepare_review.py::test_prose_fabrication_clean PASSED [ 75%]
scripts/tests/test_prepare_review.py::test_prose_fabrication_detected PASSED [ 83%]
scripts/tests/test_prepare_review.py::test_detect_needs_clean PASSED     [ 91%]
scripts/tests/test_prepare_review.py::test_detect_needs_fabrication PASSED [100%]

============================== 12 passed in 0.30s ==============================
```

If your local run produces different output, the prefilter has regressed. Bisect to the offending commit.
