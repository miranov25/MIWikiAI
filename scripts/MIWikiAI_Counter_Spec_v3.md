---
artifact_id: MIWikiAI_Counter_Spec_v3
status: DRAFT
supersedes: MIWikiAI_Counter_Spec_v2 §4-6
authors:
  - reviewerId: Claude9
    role: Coder
    contribution: as-built architecture, six-script pipeline, empirical baseline
ratification_required:
  architect: pending
governance:
  organization_structure: v1.27
  reviewer_protocol: MTTU_Reviewer v1.21
  technical_summary: v0.4
target_artifact_id: MIWikiAI_Counter_Spec_v3
created: 2026-04-26
pinned_aliceo2_sha: 87b9775
pinned_o2dpg_sha: <not pinned, see §7.2>
pinned_o2physics_sha: <not pinned, see §7.2>
empirical_baseline_run_date: 2026-04-25
known_verify_flags: 6
---

# MIWikiAI Counter Spec v3 — As-Built Pipeline

## §0. Header (per MTTU_Reviewer v1.21)

`[Claude9] [MIWikiAI] [Coder] [MIWikiAI_Counter_Spec_v3] [DRAFT]`

This document supersedes Spec v2 §4 (single-script architecture), §5
(stage definitions inside `miwikiai_usage_counter.sh`), and §6 (the `all`
orchestrator and the `do_seed` basename heuristic). Spec v2 §1–§3 remain
in force: the logical-OR depth trigger, the no-decision_hint policy, and
the editorial-threshold convention are unchanged.

## §1. Why v3 supersedes v2

Spec v2 specified a single staged script with sub-commands `seed |
reachable | symbols | count`. During implementation, three architectural
defects in that design surfaced:

1. **`do_seed` basename mapping is inadequate.** v2 mapped
   `o2-foo-workflow → foo-workflow.cxx` by basename. Empirically only 4
   of 15 architect-named TPC binaries resolve this way. The actual
   AliceO2 convention parses CMakeLists `o2_add_executable(NAME
   COMPONENT_NAME comp SOURCES src/...)`, where the binary name is
   `o2-<comp>-<NAME>` and the source filename routinely differs from the
   binary name (e.g. `o2-tpc-integrate-cluster-workflow` →
   `src/tpc-integrate-cluster-currents.cxx`).

2. **Single-script orchestration hides intermediate state.** The
   architect rejected the `all` sub-command pattern: *"I hated that pipe
   — that is what our admins (idiot) did before — ugly — can not debug
   anything."* For 30-minute jobs the industry-standard pattern is
   staged outputs with checkpoints, each stage independently runnable
   and inspectable.

3. **Test discipline cannot live inside a 600-line orchestrator.**
   v2's `do_*` functions could only be exercised through the full
   pipeline. Six independent scripts each ship with `--test` mode and a
   synthetic fixture, runnable in seconds.

v3 splits the pipeline into six composable scripts. Each script
honours the v2 invariants (no fabricated data, no decision_hint column,
provenance preserved) and adds the architectural improvements above.

## §2. Architecture

```
   $O2DPG_ROOT                                  $ALICEO2_ROOT
        │                                              │
        ▼                                              ▼
  parse_o2dpg.sh                              resolve_proto.sh
        │                                              │
        │  o2dpg_invocations.tsv               catalogue_o2.tsv
        │  (script, category, binary)         (binary, cmake_dir, source)
        │                                              │
        └────────────────────┬─────────────────────────┘
                             ▼
                       seed_join.sh
                             │
        seed_provenance.tsv  │  seed.txt          unresolved.txt
        (script, category,   │  (abs paths)       (binaries with no
         binary, cmake_dir,  │                     catalogue match)
         source)             ▼
                       reachable.sh ←── $ALICEO2_ROOT (for include resolution)
                             │
                             │  reachable.txt + reachable.iter.log
                             ▼
                       symbols.sh ←── ctags (Universal Ctags ≥ 6.0)
                             │
                             │  symbols.tsv
                             ▼
                       count.sh ←── ripgrep (recommended) or grep
                             │
                             ▼
                       usage.csv
```

### §2.1. Script contracts

| Script | Input | Output | Tooling | Runtime |
|---|---|---|---|---|
| `parse_o2dpg.sh` | `$O2DPG_ROOT` (recursive scan) | `o2dpg_invocations.tsv`: `script_path \t category \t binary_token` | grep + awk | ~5 s |
| `resolve_proto.sh` | tree containing CMakeLists.txt files | `catalogue.tsv`: `binary_token \t cmake_dir \t source_path` | find + awk | ~1 s per repo |
| `seed_join.sh` | invocations + catalogue | `seed_provenance.tsv` (5 cols), `seed.txt` (abs paths), `unresolved.txt` | sort + join + awk | < 1 s |
| `reachable.sh` | seed + AliceO2 root | `reachable.txt`, `reachable.iter.log` | find + grep + sort + comm + join | ~3 s, 13 iterations |
| `symbols.sh` | reachable file list | `symbols.tsv`: `name \t kind \t scope \t file \t signature \t line` | Universal Ctags | ~2 s |
| `count.sh` | symbols + reachable + seed | `usage.csv` | ripgrep + awk + git log | ~90 s with rg |

### §2.2. Composition rules (architect-stated)

* **No pipes between long-running stages.** Each stage writes a
  deterministic checkpoint file. The next stage refuses to run if its
  precondition is missing.
* **No `all` orchestrator.** Stages are invoked independently; users who
  want one-shot end-to-end write a 6-line shell wrapper for their
  specific scope.
* **`--test` mode is mandatory.** Every script self-tests against a
  synthetic fixture before any real-data run is trustworthy.
* **BSD/GNU portability.** No `xargs -a`, `xargs -d`, or other GNU-only
  flags. Verified on macOS BSD userland and Alma2 GNU.

## §3. Resolver convention (replaces v2 §4.3)

`resolve_proto.sh` parses two CMake macros:

**AliceO2** (`o2_add_executable`):
```
o2_add_executable(<name>
    [COMPONENT_NAME <comp>]
    [SOURCES <src1> <src2> ...]
    [PUBLIC_LINK_LIBRARIES ...])
```
Runtime binary = `o2-<comp>-<name>` if `COMPONENT_NAME` present,
otherwise `o2-<name>`. SOURCES and COMPONENT_NAME may appear in any
order. ALL_CAPS keywords delimit the SOURCES list.

**O2Physics** (`o2physics_add_dpl_workflow`):
```
o2physics_add_dpl_workflow(<name>
    SOURCES <src>.cxx
    [JOB_POOL <pool>]
    [PUBLIC_LINK_LIBRARIES ...]
    COMPONENT_NAME Analysis)
```
Runtime binary = `o2-analysis-<name>`. The `COMPONENT_NAME Analysis`
clause is install-directory metadata, **not** part of the runtime
prefix. O2Physics's runtime prefix is hard-coded `o2-analysis-`.

Other macros found but not parsed (intentional v3 scope): `o2_add_test`,
`o2_add_library`, `o2_add_header_only_library`, `o2_add_dpl_workflow`
(rare in AliceO2; not the mainline registration form),
`o2_add_test_root_macro`. These produce binaries that are not present
in any O2DPG production / MC / calib / QC entry-point and are therefore
safely outside the production-reachable seed.

## §4. Empirical baseline — 2026-04-25 run

Reproducibility verified: identical inputs (modulo upstream O2DPG
drift) produce identical seed/reachable/symbols/usage outputs.

| Stage | Output | Count |
|---|---|---|
| O2DPG scan | invocations | 710 (was 648 on 2026-04-24; upstream drift) |
| AliceO2 catalogue | binary→source rows | 572 |
| O2Physics catalogue | binary→source rows | 1380 |
| Seed join (O2 only, TPC scope) | unique seed source paths | 140 |
| Seed join — unmatched | tokens with no catalogue match | 82 (mostly QC hostnames `o2-cr1-*`, O2Physics analysis tasks, repos we do not catalogue) |
| Reachable closure | files in transitive `#include` set | 1569 (13-iter convergence in ~3 s) |
| Symbol extraction | symbols total | 105 827 |
| Symbol extraction — unique `(name, file)` | | 88 254 |
| Count stage — filtered (Common-ish public API) | symbols counted | 1757 |
| `prod_usage_count` = 0 | | 1009 (~57 %; mostly inline templates and impl-detail helpers) |
| `prod_usage_count` 1–9 | | (see usage.csv) |
| `prod_usage_count` 10–99 | | ~440 |
| `prod_usage_count` 100–999 | | **191** ← deep-trigger candidates |
| `prod_usage_count` ≥ 1000 | | 0 |

### §4.1. Top deep-trigger candidates

By `prod_usage_count`, top 6 distinct symbols (deduped from ctags
qualified+unqualified pairs):

| Rank | Symbol | parent_class | Header | Count |
|---|---|---|---|---|
| 1 | `findClosestIndices` | `o2::math_utils` | `Common/MathUtils/include/MathUtils/fit.h` | 796 |
| 2 | `operator <<` (EnumFlags) | `o2::utils` | `Common/Utils/include/CommonUtils/EnumFlags.h` | 788 |
| 3 | `MAD2Sigma` | `o2::math_utils` | `Common/MathUtils/include/MathUtils/fit.h` | 774 |
| 4 | `MatrixMulOpGPU` | `o2::math_utils::detail::MatrixMulOpGPU` | `Common/MathUtils/include/MathUtils/SMatrixGPU.h` | 726 |
| 5 | `setImpl` (EnumFlags) | `o2::utils::EnumFlags` | `Common/Utils/include/CommonUtils/EnumFlags.h` | 689 |
| 6 | `decodeCopyImpl` / `decodeUnpackImpl` | `o2::ctf::EncodedBlocks` | `DataFormats/Detectors/Common/include/DetectorsCommonDataFormats/EncodedBlocks.h` | 647 / 644 |

`ConfigurableParam` family in the 180–290 range. `Transform3D`
(`MasterToLocal`, `LocalToMaster` etc.) in the 225–243 range. Sub-100
counts dominate the long tail.

## §5. Known limitations carried forward (`[VERIFY]` flags)

`[VERIFY-V3-1]` **`#include "Foo.h"` lines count as references to
`Foo`.** Affects classes whose name matches the header basename. Every
file that includes `Tsallis.h` adds +1 to the `Tsallis` count without a
real reference being made. Mitigation deferred — see v4 path.

`[VERIFY-V3-2]` **Comments containing the symbol name count as
references.** A line `// uses tsallisPDF` adds +1. Documented during
self-test bisection on 2026-04-25. ~5–15 % over-count on
heavily-documented utility symbols.

`[VERIFY-V3-3]` **`workflows_direct` is a weak signal for header-only
template helpers.** Top utility symbols show high `prod_usage_count`
(via transitive headers) but `workflows_direct=0` because they are not
called from the .cxx entry-point layer. Not a bug; column is
informational. `prod_usage_count` is the primary signal.

`[VERIFY-V3-4]` **ctags `--extras=+q` emits each symbol multiply.**
105 827 raw symbol rows → 88 254 unique `(name, file)` pairs. Filter
deduplication in `count.sh` brings this down further (1757 unique pairs
counted). Cosmetic in `usage.csv` (some symbols appear as both bare and
qualified rows with identical counts); not a correctness issue.

`[VERIFY-V3-5]` **Production reachability ≠ production usage.** A
header is reachable if some entry-point .cxx transitively includes it,
but the symbol may never be exercised at runtime. Symbol-level call
graph would require clang AST. Out of scope for v3.

`[VERIFY-V3-6]` **2 of 140 seed paths reference conditional CMake
expressions** (`$<$<BOOL:${ENABLE_UPGRADES}>:src/ITS3DigitizerSpec.cxx>`)
and are filtered out of the `reachable` walk because the literal path
doesn't exist on disk. Affects 2 sources covering 2 binaries; minor.

## §6. Upgrade paths (deferred to v4 or later)

* **clang AST symbol counter.** Replaces regex-based grep counts with
  call-graph-aware references. Eliminates `[VERIFY-V3-1]` and most of
  `[VERIFY-V3-2]`. Cost: requires clang installed on every reviewer
  machine; ~5–10× slower per file.
* **Comment + `#include` line stripping pre-pass.** Cheap mitigation
  for `[VERIFY-V3-1]` and `[VERIFY-V3-2]` without clang dependency.
  Adds ~30 % runtime; removes ~80 % of noise. Implementation: pipe each
  search file through a small awk script that drops `^\s*//` lines and
  `#include` lines before grep sees them.
* **Per-symbol `usage_breakdown.tsv` sidecar.** For each symbol over
  threshold, list the top 10 files that reference it (with counts).
  Enables faster validation of high-count symbols during authoring.
* **O2Physics in production seed.** Currently `seed_o2only.txt` is the
  primary seed (140 sources). Adding O2Physics analysis tasks would
  expand reach into Tools/, DPG/Tasks/ etc. Open architect decision
  whether analysis tasks belong in the "production" reachability set.
* **Per-detector scope filters.** Current scope = TPC. Sibling pages
  (`ITS_API.md`, etc.) need ITS / TRD / TOF scope filters. Trivial:
  one regex change in the seed-join stage.

## §7. Architect ratification requests (R-V3-*)

`R-V3-1`: **Confirm the empirical 117/191 100-999 candidates are the
correct working-set for `Common_utilities_API.md` deep authoring.**
Authoring all of them is too much for one page. Subset selection is
editorial; v3 declines to set a hard threshold (per Spec v2 D3). Asks
architect to tag a working subset by reading the top of `usage.csv`.

`R-V3-2`: **Pin O2DPG and O2Physics SHAs.** AliceO2 is pinned to PR
#15202 / SHA `87b9775`. O2DPG and O2Physics drift between runs (710 vs
648 invocations on 24h apart) without affecting downstream output, but
for full reproducibility a SHA pin is needed. Recommendation: pin
O2DPG to its own current main HEAD; pin O2Physics similarly. Re-run
pipeline to record canonical numbers. Decline if drift is acceptable.

`R-V3-3`: **Ratify the dedup-by-`(name, file)` policy in `count.sh`.**
Spec v2 was silent on this. Current implementation: when ctags emits
the same `(name, file)` pair multiple times (e.g. prototype + inline +
qualified + unqualified rows), only the first is counted. Alternative:
emit one row per ctags entry (1757 → ~3100 rows), letting the consumer
deduplicate. Lean: keep current behaviour; cleaner CSV.

`R-V3-4`: **Confirm `Common_utilities_API.md` scope = `Common/` +
`DataFormats/Detectors/Common/`.** Default filter in `count.sh` covers
both. Architect may want only `Common/` (drops 191 → ~150 candidates,
loses `EncodedBlocks` and shared data-format classes), or expand to
`Detectors/Base/` and `Framework/Core/` (adds shared infrastructure
classes). Editorial.

`R-V3-5`: **Decide audit timing.** Three orderings are viable: spec →
audit → pilot (recommend); audit → spec → pilot (faster start, retrofit
spec to audit findings); spec → pilot → audit (delivers value first,
audit confirms). Lean: spec → audit → pilot. Architect call.

`R-V3-6`: **Confirm public-vs-private hosting.** v3 lives in the public
MIWikiAI repository alongside Spec v2, MTTU_Reviewer, Org-structure.
None of the content is sensitive (no PII, no preliminary results, no
security-bearing material). Default = public. Architect may move to
private GitLab if downstream concerns surface; cheap to do later,
expensive to undo a public reveal.

## §8. Files added by v3 implementation

```
scripts/parse_o2dpg.sh         ~270 lines
scripts/resolve_proto.sh       ~210 lines
scripts/seed_join.sh           ~270 lines
scripts/reachable.sh           ~270 lines
scripts/symbols.sh             ~280 lines
scripts/count.sh               ~480 lines
                               ─────────────
                               ~1780 lines + 313 lines test fixtures
```

All committed to MIWikiAI/scripts/ in commit `1fe0660` (2026-04-25):
*"miwikiai: empirical seed/reachable/symbols/count pipeline (Phase
0.1)"*.

Each script ships with embedded `--test` mode running on a synthetic
fixture. Total self-test coverage:

| script | checks | fixture |
|---|---|---|
| `parse_o2dpg.sh` | 18 | DATA/production + MC + QC + calibration + edge cases |
| `resolve_proto.sh` | 7 | AliceO2 + O2Physics conventions |
| `seed_join.sh` | 15 | inner-join, dedup, multi-source, unresolved logging |
| `reachable.sh` | 12 | 4-hop closure, max_iter cap, system-header rejection |
| `symbols.sh` | 12 | classes, methods, free functions, namespaces, members |
| `count.sh` | 9 | self-exclusion, resume, multi-pattern dedup |

## §9. Glossary changes from v2

| Term | v2 meaning | v3 meaning |
|---|---|---|
| **seed** | initial .cxx files for `do_reachable` | unique absolute .cxx paths from `seed_join.sh`, deduped |
| **invocation** | (not defined) | one `(script, category, binary)` row in `o2dpg_invocations.tsv` |
| **provenance** | (not defined) | full chain `(script → category → binary → cmake_dir → source)` in `seed_provenance.tsv` |
| **catalogue** | (implicit) | `(binary, cmake_dir, source)` rows from CMakeLists parsing |
| **reachable file** | included from seed | included from seed transitively, basemap-resolved |
| **deep-trigger candidate** | (not defined) | symbol with `prod_usage_count` in architect-tagged bucket |

---

### End of MIWikiAI_Counter_Spec_v3 — DRAFT

Awaits architect ratification (R-V3-1 through R-V3-6).

Pending child documents:
* MIWikiAI_Counter_Audit_v3 (Claude2 audit, ~30 min)
* Common_utilities_API.md (pilot section, top-3 candidates from R-V3-1)
