# `run_test.sh` — MIWikiAI link validation

Quick link + cross-reference consistency check for the MIWikiAI wiki. Zero dependencies beyond bash, grep, sed, awk, find — all standard on macOS and Linux. `curl` only needed for the optional external-URL check.

## Install

Drop `run_test.sh` at the repo root, alongside the `Alice/` directory:

```
MIWikiAI/
├── Alice/
│   ├── TDR/
│   ├── presentations/
│   └── …
└── run_test.sh        ← here
```

Make it executable:

```bash
chmod +x run_test.sh
```

## Run

```bash
./run_test.sh                    # fast, internal only (recommended for every commit)
./run_test.sh --verbose          # also print every passed check
./run_test.sh --external         # add external URL reachability (slow, ~1 sec/URL)
./run_test.sh some/other/path    # validate a non-default root
```

Exit codes: `0` pass (possibly with warnings), `1` errors found, `2` preflight failure.

## What it checks

| # | Test | Severity | What it catches |
|---|---|---|---|
| 1 | Version duplication | warning | `ITS_source_of_truth.md` + `ITS_SourceOfTruth_v0_2.md` + `TDR/its.md` — the exact mess in your current tree |
| 2 | Internal file links | **error** | `](./its.md)` when `./its.md` doesn't exist |
| 3 | §N.M anchor references | warning | `§7.2` referenced when no `## 7.2` heading exists |
| 4 | `[VERIFY]` body/front-matter sync | warning | `[VERIFY]` in body but no `known_verify_flags:` field |
| 5 | `[computed]` derivation proximity | warning | `[computed]` tag without arithmetic nearby |
| 6 | Required front-matter fields | warning | Missing `wiki_id:` or `review_status:` |
| 7 | External URL reachability (opt-in) | error/warning | 4xx/5xx/timeout on DOI, CDS, arXiv links |

Skipped by test 7: `docs.google.com`, `indico.cern.ch` (auth-gated; 401/403 are expected).

## Expected output on your current tree

Based on `git ls-files`, you have ~14 markdown files with heavy version duplication. Running this script as-is should produce roughly:

- **Test 1 warnings:** ~5 groups (ITS has 3 copies, TPC has 3, TRD has 4, FIT has 2)
- **Test 2 errors:** likely some, depending on which version cross-references which
- **Test 3 warnings:** §-references that broke between versions

After you consolidate ITS / TPC / TRD to single canonical copies in `Alice/TDR/`, test 1 should drop to zero warnings. Test 2 errors should drop as well, since there'll be no ambiguity about which `its.md` a link means.

## Notes

- The script is bash, not Python. Easier to audit, no install step, runs anywhere.
- Tests 1–6 finish in under 1 second on 50 files. Test 7 takes ~10 seconds per URL not-skipped.
- Use `--verbose` occasionally to confirm passed checks; default output shows only warnings + errors to stay scannable.
- Can be wired into pre-commit hook if desired — put `./run_test.sh` in `.git/hooks/pre-commit` with `exit 1` on failure.

## Extending

Rules 8–12 (bidirectional-link completeness, status-annotation consistency, arithmetic-closure evaluation, cross-detector dependency staleness, DOI canonical-form check) are scoped for a future Python port. Bash is sufficient for the current sprint.
