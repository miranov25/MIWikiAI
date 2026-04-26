---
artifact_id: MIWikiAI_Counter_Pipeline
status: DRAFT
authors:
  - reviewerId: Claude9
    role: Coder
peer_reviewers_assigned:
  - reviewerId: Claude2
    aspect: algorithmic correctness, BSD/GNU portability, edge cases
  - reviewerId: Claude4
    aspect: governance fit, QuickRef alignment, glossary
  - reviewerId: Claude5
    aspect: wiki-fitness, terminology consistency with active modules
peer_reviewers_reported: []
ratification_required:
  architect: pending (after peer-review consolidation)
governance:
  organization_structure: v1.27
  reviewer_protocol: MTTU_Reviewer v1.21
  technical_summary: v0.4
created: 2026-04-26
---

# MIWikiAI Counter Pipeline

A six-script pipeline that measures how often each AliceO2 symbol
(class, method, function) is referenced from code paths actually
exercised in production reconstruction, simulation, calibration, and
QC workflows. The output is `usage.csv`, one row per symbol, with a
production-usage count, a churn count, and provenance back to the
O2DPG entry-point script that pulled the symbol into the production
graph.

The pipeline exists to provide empirical evidence for one of three
depth triggers in the MIWikiAI logical-OR rule for deep-vs-thin wiki
page authoring. It does not decide what gets authored deep; it only
provides the data on which a human (the architect) decides.

## 1. Why this exists

MIWikiAI builds wiki pages at two depths: **thin** (a couple of
paragraphs plus a pointer to primary sources) and **deep** (full
narrative coverage of the symbols, with explained parameter lists and
worked examples). The architect ruled (Spec v2) that a symbol qualifies
for deep coverage if **any** of three triggers fires:

1. **Production-reachable** — the symbol is reachable, via the
   `#include` graph, from some O2DPG production / MC / calibration / QC
   entry-point. Empirical, measurable.
2. **Architect-declared** — the architect has tagged the symbol as
   important regardless of empirical reachability. Subjective,
   authoritative.
3. **Short-enough-to-include-all** — the relevant header is short
   enough that authoring all of its public surface costs little.
   Pragmatic.

Without trigger #1, MIWikiAI authoring becomes guesswork. The Counter
Pipeline is the production-reachability measurement. Triggers #2 and
#3 remain editorial.

The other purpose of the pipeline is **documentation governance**.
Every wiki page that decides to author a symbol deeply can cite a
specific row in `usage.csv` — a quantitative reachability count, the
defining header path, and the entry-point scripts that pulled it in.
This grounds wiki content in measurable facts rather than impression.

## 2. What the pipeline produces

Final output:

```
usage.csv
  symbol, kind, parent_class, header, signature, line,
  prod_usage_count, prod_reachable, churn_12m, workflows_direct
```

* **`prod_usage_count`** — number of whole-word references to the
  symbol across all production-reachable files, **excluding** the
  defining header itself.
* **`prod_reachable`** — boolean: is the defining header in the
  reachable set at all? (Sanity check; should be `true` for everything
  in the filtered output.)
* **`churn_12m`** — number of git commits to the defining header in
  the last 12 months. Recently-touched headers are typically more
  important to document.
* **`workflows_direct`** — references in the **entry-point .cxx files
  only** (the seed). High when the symbol is called directly from a
  workflow binary; low when used only via included headers. Weak
  signal for header-only template helpers; useful for identifying
  workflow-API symbols.

A symbol with a high `prod_usage_count` and non-zero `churn_12m` is a
strong deep-authoring candidate. A symbol with `prod_usage_count = 0`
is unreachable from production and probably shouldn't be authored
deep at all.

The architect sets the threshold editorially. The pipeline does not
emit a "decision_hint" column (Spec v2 D3).

## 3. How the pipeline works

Six stages, each its own script, each writing a checkpoint file. No
pipes between long-running stages — every intermediate is inspectable.

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
                             │  seed.txt + seed_provenance.tsv
                             │  + unresolved.txt
                             ▼
                       reachable.sh ←── $ALICEO2_ROOT
                             │
                             │  reachable.txt + reachable.iter.log
                             ▼
                       symbols.sh ←── ctags (Universal Ctags ≥ 6.0)
                             │
                             │  symbols.tsv
                             ▼
                       count.sh ←── ripgrep (recommended)
                             │
                             ▼
                       usage.csv
```

Each script has an embedded `--test` mode that runs a synthetic fixture
and asserts expected output. Run `./<script>.sh --test` before trusting
real-data output.

### 3.1. Stage 1 — `parse_o2dpg.sh`

Input: `$O2DPG_ROOT` (recursive scan of all text files).

Extracts every `o2-[a-z][a-z0-9-]*` token from every text file and
emits one row per `(script, binary)` pair:

```
script_path  TAB  category  TAB  binary_token
```

Category is derived from the path: `MC` for files under `MC/`, `QC`
for `QC/`, `calibration` for `*/calib/` or `*/Calib*/`, `production`
for `*/production/`, `other` for everything else (testing, tools,
private branches).

The scan is intentionally aggressive: every text file in O2DPG that
mentions an `o2-...` token is captured. This produces noise (hostnames
like `o2-cr1-hv-aliecs` in QC JSON files, references in README files,
log artefacts) but the noise is filtered out cleanly at the join stage.

Empirical baseline: ~700 invocation rows, ~200 distinct tokens,
~570-row time on a fresh O2DPG checkout.

### 3.2. Stage 2 — `resolve_proto.sh`

Input: a tree containing CMakeLists.txt files (AliceO2, O2Physics, or
any other repo using these CMake macros).

Walks every CMakeLists.txt and parses two macros:

**AliceO2** (`o2_add_executable`):
```cmake
o2_add_executable(<n>
    [COMPONENT_NAME <comp>]
    [SOURCES <src1> <src2> ...]
    [PUBLIC_LINK_LIBRARIES ...])
```
Runtime binary name = `o2-<comp>-<n>` if `COMPONENT_NAME` is present,
otherwise `o2-<n>`. The basename of the source file routinely differs
from the binary name (e.g. `o2-tpc-integrate-cluster-workflow` is
declared in `Detectors/TPC/workflow/CMakeLists.txt` with
`SOURCES src/tpc-integrate-cluster-currents.cxx`); this is why a
basename heuristic does not work and the resolver parses the actual
CMake call.

**O2Physics** (`o2physics_add_dpl_workflow`):
```cmake
o2physics_add_dpl_workflow(<n>
    SOURCES <src>.cxx
    [JOB_POOL <pool>]
    [PUBLIC_LINK_LIBRARIES ...]
    COMPONENT_NAME Analysis)
```
Runtime binary name = `o2-analysis-<n>`. The `COMPONENT_NAME Analysis`
clause is install-directory metadata; it is **not** part of the runtime
binary prefix. The runtime prefix is hard-coded `o2-analysis-`.

Output: one row per source file in the executable definition (multi-
source executables produce multiple rows):
```
binary_token  TAB  cmake_dir  TAB  source_path
```

Empirical: ~570 rows from AliceO2, ~1380 from O2Physics. Other
registration macros found in the trees (`o2_add_test`,
`o2_add_library`, etc.) are intentionally **not** parsed because they
produce binaries that do not appear in any O2DPG entry-point and are
therefore outside the production-reachable set.

### 3.3. Stage 3 — `seed_join.sh`

Inner-joins the invocation TSV from stage 1 against the catalogue TSV
from stage 2 on `binary_token`. Emits three files:

* **`seed_provenance.tsv`** — five columns: `script, category, binary,
  cmake_dir, source`. The full audit chain. For any symbol later
  authored in a wiki page, this file answers "which O2DPG script(s)
  pulled this binary into production?"
* **`seed.txt`** — unique absolute source paths (concatenation of
  `cmake_dir` and `source`). The starting set for the include-graph
  walk.
* **`unresolved.txt`** — invocation tokens with no catalogue match.
  Inspectable; expected to contain mostly hostnames, analysis tasks
  (when O2Physics is excluded from the catalogue), and references to
  binaries from repositories the catalogue does not cover (Quality
  Control, Data Distribution).

Empirical: 145 of 197 distinct invocation tokens match the combined
AliceO2+O2Physics catalogue; 52 unresolved (mostly noise). With AliceO2
only: 115 matched, 82 unresolved (the additional 30 are O2Physics
analysis tasks). 140 unique seed source paths after join.

### 3.4. Stage 4 — `reachable.sh`

Input: `seed.txt` and `$ALICEO2_ROOT`.

Performs an iterative `#include`-graph closure starting from the seed
sources. Each iteration:

1. From the current frontier (set of files), extract every
   `#include "..."` and `#include <...>` directive.
2. Resolve each include's basename against a basemap of all
   `.h`/`.hpp`/`.cxx`/`.cpp` files in `$ALICEO2_ROOT`. System headers
   (`<vector>`, `<string>`) are not in the basemap and so are
   discarded automatically. Multiple paths sharing a basename are all
   kept; conservative over-inclusion is the correct error here.
3. New paths become the next iteration's frontier; old paths join the
   reachable set.

Stops when the frontier is empty (converged) or `--max-iter` (default
30) is hit. Writes `reachable.txt` (sorted unique absolute paths) and
`reachable.iter.log` (per-iteration trace for debugging).

Empirical: TPC scope seed of 138 sources converges in 13 iterations
(~3 seconds) to 1569 reachable files, including 78 files in `Common/`
and 192 in `DataFormats/Detectors/`.

### 3.5. Stage 5 — `symbols.sh`

Input: `reachable.txt`, Universal Ctags binary.

Runs Universal Ctags with a curated flag set on every reachable file
and post-processes to a stable TSV with one row per symbol:

```
name  TAB  kind  TAB  parent_class  TAB  file  TAB  signature  TAB  line
```

`kind` is a single ctags letter: `c` (class), `s` (struct), `f`
(function), `p` (prototype), `m` (member), `e` (enumerator), `n`
(namespace), `t` (typedef), `d` (macro), `u` (union), `g` (enum), `v`
(variable). `parent_class` is the fully-qualified scope (e.g.
`o2::math_utils::Tsallis`) when applicable, empty otherwise.
`signature` is the parameter list including default arguments,
preserved verbatim from ctags.

ctags `--extras=+q` emits each symbol multiple times (bare name,
fully-qualified name, prototype + inline definition rows for inline
functions). The downstream count stage deduplicates by `(name, file)`.

Empirical: ~106 000 raw symbol rows from 1569 files, ~88 000 unique
`(name, file)` pairs. Runtime ~2 seconds.

**Universal Ctags is required.** macOS ships BSD ctags by default,
which is unsuitable. Install Universal Ctags via Homebrew
(`brew install universal-ctags`) or from source. On Linux RHEL/Alma 9,
the `ctags` package in the EPEL repository is Universal Ctags.

### 3.6. Stage 6 — `count.sh`

Input: `symbols.tsv`, `reachable.txt`, `seed.txt`.

For each symbol passing the filter (default: classes, structs,
functions, and prototypes whose defining file is under `Common/` or
`DataFormats/Detectors/Common/`, excluding compiler-generated anonymous
lambdas), computes the four columns of `usage.csv`.

The implementation uses an **inverted-loop** algorithm: build a single
patterns file containing all symbol names of interest, then run
ripgrep (or grep) once across every reachable file with `-f patterns
-wFo`. The output is one match per line, format `file:matched_token`.
Aggregate in awk: total matches per token, minus matches in the
defining header, equals `prod_usage_count`.

This is one big grep for `prod_usage_count` and one big grep for
`workflows_direct`, instead of one grep per symbol. The complexity
goes from O(symbols × files) fork-execs to O(1) fork-execs with the
matching done in a single Aho-Corasick automaton (ripgrep) or single
GNU/BSD grep pass.

Runtime: ~90 seconds for 3100 filtered symbols × 1569 reachable files
with ripgrep. With BSD grep, **slower by 10–20×**; install ripgrep if
the count stage is not finishing in a reasonable time.

The count stage is **resumable**. If `usage.csv` already exists, rows
already present are skipped on a subsequent run. Same `(name, file)`
pair appearing twice in the input (e.g. ctags duplicate emits) is also
deduplicated; the summary line `skipped_duplicate_key=N` counts these.

## 4. How to use the pipeline

### 4.1. Quick start

Set up environment:

```bash
export ALICEO2_ROOT=/path/to/AliceO2
export O2DPG_ROOT=/path/to/O2DPG
# Optional, for O2Physics analysis tasks:
export O2PHYSICS_ROOT=/path/to/O2Physics

# On macOS, brew installs to /opt/homebrew/bin/ctags by default
# but BSD /Applications/Xcode.app/.../bin/ctags wins the PATH race.
# Pass the right binary explicitly to symbols.sh or fix PATH.
```

Run the pipeline end-to-end (current TPC scope):

```bash
./parse_o2dpg.sh   "$O2DPG_ROOT"   > o2dpg_invocations.tsv
./resolve_proto.sh "$ALICEO2_ROOT" > catalogue_o2.tsv

./seed_join.sh \
    --invocations o2dpg_invocations.tsv \
    --catalogue   catalogue_o2.tsv \
    --unresolved  unresolved.txt \
    --seed        seed.txt \
    > seed_provenance.tsv

./reachable.sh \
    --seed     seed.txt \
    --root     "$ALICEO2_ROOT" \
    --out      reachable.txt \
    --iter-log reachable.iter.log

./symbols.sh \
    --files reachable.txt \
    --out   symbols.tsv \
    --ctags /opt/homebrew/bin/ctags

./count.sh \
    --symbols   symbols.tsv \
    --reachable reachable.txt \
    --seed      seed.txt \
    --out       usage.csv \
    --git-root  "$ALICEO2_ROOT" \
    --grep      rg
```

Inspect:

```bash
echo "==== top 30 by prod_usage_count ===="
sort -t, -k7 -n -r usage.csv | head -30

echo "==== usage distribution ===="
awk -F, 'NR>1{
    c=$7+0
    if (c==0) b="0"
    else if (c<10) b="1-9"
    else if (c<100) b="10-99"
    else if (c<1000) b="100-999"
    else b="1000+"
    h[b]++
} END{ for(k in h) print k"\t"h[k] }' usage.csv | sort
```

### 4.2. Including O2Physics analysis tasks in the seed

By default the seed is built against the AliceO2 catalogue only.
O2Physics analysis tasks (the `o2-analysis-*` family) are flagged as
unresolved. To include them, build a combined catalogue:

```bash
./resolve_proto.sh /path/to/O2Physics > catalogue_o2physics.tsv
cat catalogue_o2.tsv catalogue_o2physics.tsv > catalogue_all.tsv

./seed_join.sh \
    --invocations o2dpg_invocations.tsv \
    --catalogue   catalogue_all.tsv \
    --unresolved  unresolved.txt \
    --seed        seed.txt \
    > seed_provenance.tsv
```

Whether O2Physics analysis tasks belong in the production-reachable
set is an architect decision (open item; see §6).

### 4.3. Changing scope

The default `count.sh` filter selects symbols defined under `Common/`
or `DataFormats/Detectors/Common/`. To author a different wiki page,
override the filter with an awk expression on the symbol fields
`(name, kind, parent, file, sig, line)`:

```bash
# All TPC detector symbols
./count.sh ... --filter \
    'kind ~ /^[csfp]$/ && file ~ /\/Detectors\/TPC\// && name !~ /^__anon/'

# Just one specific class's methods
./count.sh ... --filter \
    'parent ~ /::ConfigurableParam$/'

# Everything reachable, no scope limit
./count.sh ... --filter \
    'kind ~ /^[csfp]$/ && name !~ /^__anon/ && length(name) > 2'
```

### 4.4. Re-running after upstream changes

The pipeline is deterministic from `(O2DPG_SHA, ALICEO2_SHA,
O2PHYSICS_SHA)`. After `git pull` in any of the input trees, re-run
the affected stages. `count.sh` is resumable: if `usage.csv` already
exists, only new symbols are counted.

For a clean baseline, delete intermediates and re-run from stage 1:

```bash
rm -f *.tsv *.csv *.txt *.iter.log
# ... run all six stages ...
```

### 4.5. Inspecting provenance for a specific symbol

For a wiki page citing a symbol, the provenance chain answers
"which workflow uses this?":

```bash
# Which entry-point scripts pulled the defining header into production?
SYMBOL=findClosestIndices
HEADER=$(awk -F, -v s="$SYMBOL" '$1==s{print $4; exit}' usage.csv)
awk -F'\t' -v h="$HEADER" '$5 ~ h' seed_provenance.tsv | cut -f1 | sort -u

# Where in the source tree is it defined?
grep "^${SYMBOL}\\b" symbols.tsv | head -1
```

## 5. Implementation notes

### 5.1. Portability

The scripts are tested on macOS (BSD userland: `bash 3.2`, BSD
`grep`/`xargs`/`find`/`awk`) and on RHEL/Alma 9 (GNU userland: `bash
4+`, GNU coreutils). Three GNU-only constructs were avoided:

* `xargs -a FILE` — replaced with `xargs ... < FILE`
* `xargs -d '\n'` — replaced with `while IFS= read -r f`
* `xargs -r` — replaced with explicit empty-input checks

Awk variable assignment uses `-v VAR=value` (BEGIN-time) rather than
inline `VAR=value` between file arguments (which BSD awk processes
during file iteration, leaving the variable empty at BEGIN).

### 5.2. Self-tests

Every script has a `--test` mode using `mktemp -d` and synthetic
fixtures. Coverage:

| Script | Checks |
|---|---|
| `parse_o2dpg.sh` | 18 — categorisation, dedup, binary-file skip, trailing-dash strip, directory exclusions, file-extension overrides |
| `resolve_proto.sh` | 7 — `o2_add_executable` with COMPONENT_NAME and SOURCES in either order, `o2physics_add_dpl_workflow` with `JOB_POOL` between SOURCES and link libraries, no leakage of `Analysis` as runtime prefix |
| `seed_join.sh` | 15 — inner join, multi-source binaries, unresolved logging, dedup |
| `reachable.sh` | 12 — multi-hop closure, isolated subgraph rejection, system header rejection, max_iter cap |
| `symbols.sh` | 12 — class with methods, namespace scope, struct + members, free functions, signature with default arg |
| `count.sh` | 9 — self-exclusion of defining header, namespace-aware patterns, resume, dedup-by-(name, file) |

### 5.3. Output file conventions

* `*.tsv` — tab-separated, no header. One stage's output is the next
  stage's input.
* `usage.csv` — comma-separated, with header. CSV-escaped: signatures
  containing commas are wrapped in double quotes, embedded quotes are
  doubled.
* `*.iter.log` — per-iteration trace lines for debugging long-running
  walks.
* `unresolved.txt` — one binary token per line, no metadata. For
  inspection / triage; not used downstream.

### 5.4. Where to go for what

| Task | File |
|---|---|
| Add a CMake macro to the resolver | `resolve_proto.sh`, `process_block` function |
| Change the production-reachable scope (which O2DPG categories) | `parse_o2dpg.sh` is intentionally non-selective; filter at `seed_join.sh` instead |
| Add a column to `usage.csv` | `count.sh`, `count_symbols` function — add column to header line, compute value in main loop, append to `printf` line |
| Change ctags flags | `symbols.sh`, the `"$ct" ... \` invocation block |
| Change directory exclusions | `parse_o2dpg.sh`, `O2DPG_EXCLUDE_DIRS` env var |

## 6. Limitations

The counter is regex-based. It uses ripgrep (or grep) with whole-word
matching against fixed patterns. This produces three known noise
classes:

**`#include "Foo.h"` lines count as references to the class `Foo`**
when the class name matches the header basename. Every file that
includes `Tsallis.h` adds `+1` to the `Tsallis` count without a real
reference being made. Affects ~10–30% of class symbols whose name
matches their header. Not a bug; documented limitation.

**Comments mentioning the symbol count.** A line `// uses
tsallisPDF()` adds `+1`. ~5–15% over-count on heavily-documented
utility symbols.

**`prod_reachable = true` does not imply runtime reachability.** A
header is reachable if some entry-point .cxx transitively includes it,
but the symbol may never be exercised at runtime (e.g. inside a
preprocessor branch that's not active in the production build, or a
template that's never instantiated). Symbol-level call-graph
reachability would require clang AST integration.

**`workflows_direct` is a weak signal for header-only template
helpers.** High-utility symbols typically show high `prod_usage_count`
(via transitive includes) but `workflows_direct = 0` because they are
not called directly from the .cxx entry-point layer. Use
`prod_usage_count` as the primary signal.

**ctags emits each symbol multiple times.** A class with both a
prototype and an inline definition produces two ctags entries, and
`--extras=+q` doubles each by emitting both bare and qualified names.
The count stage deduplicates by `(name, file)` and reports the
collapse in its summary.

**O2DPG conditional CMake source expressions are not resolved.**
About 2 of 140 seed paths reference `$<$<BOOL:${ENABLE_UPGRADES}>:...>`
generator expressions; these literal paths don't exist on disk and
are dropped by the reachable walk. Affects 2 binaries in the upgrades
subtree.

The clear upgrade path for the first three limitations is a clang AST
counter — see §7.4.

## 7. Open items

### 7.1. Pilot wiki page subject

The first deep-authored wiki page driven by `usage.csv` is pending
architect selection. Top candidates from the current data:

| Symbol family | prod_usage_count | Notes |
|---|---|---|
| `o2::conf::ConfigurableParam` (setValue, getValueAs, writeINI, ...) | 180–290 | Workhorse configuration class, well-known to architect, single self-contained header |
| `o2::math_utils::Transform3D` (MasterToLocal, LocalToMaster, ...) | 225–243 | Detector geometry, directly relevant to TPC alignment workflow |
| `o2::math_utils` free functions in `fit.h` (findClosestIndices, MAD2Sigma, Reorder, SortData) | 540–796 | High count, but mostly internal helpers; needs review |
| `o2::utils::EnumFlags` (operator <<, setImpl, ...) | 277–788 | High count partly inflated by header-basename effect; investigate before authoring |

Architect call.

### 7.2. SHA pinning

AliceO2 is pinned to SHA `87b9775` (PR #15202, merged 2026-03-26).
O2DPG and O2Physics are not pinned. Drift between runs has been small
(~10% invocation count change over 24h, no downstream impact), but
for full reproducibility a SHA pin is recommended.

### 7.3. O2Physics in the production seed

By default the production seed excludes O2Physics. The 30 unresolved
`o2-analysis-*` tokens become matched if O2Physics catalogue is
included. Whether analysis tasks belong in "production" reachability
is an architect decision; arguments both ways:

* Include: analysis is part of the production data pipeline; people
  authoring `Common_utilities_API.md` should know if a symbol is used
  by analysis tasks too.
* Exclude: analysis tasks are downstream of reconstruction; including
  them inflates counts for symbols actually only relevant to reco.

### 7.4. clang AST upgrade

Replacing ripgrep with a clang-based AST visitor would eliminate the
`#include` and comment over-counts and add real call-graph
reachability. Cost: clang on every reviewer's machine, ~5–10× slower
per file, and significant new code. Probably worth doing once
`usage.csv` is integrated into wiki authoring and the regex noise
becomes an actual problem.

### 7.5. Per-detector scope filters

Current filter is TPC-centric. Sister wiki pages (ITS_API.md, etc.)
need their own filters. The change is one regex in the seed-join
stage.

### 7.6. `usage_breakdown.tsv` sidecar

For each high-count symbol, list the top 10 files that reference it.
Would let a Reviewer or architect validate counts ("is this really
what TPC reco uses?") without re-grepping. Easy to add as a stage 7.

## 8. Provenance

This pipeline supersedes the design described in
`MIWikiAI_Counter_Spec_v2.md` §4–6, which specified a single staged
script with sub-commands. The single-script design was abandoned during
implementation in favour of the six independent scripts because:

1. The original `do_seed` basename heuristic resolved only 4 of 15
   architect-named TPC binaries; CMakeLists parsing is required.
2. The architect rejected the `all` orchestrator pattern in favour of
   independently-runnable, inspectable stages.
3. Embedding `--test` modes inside a single 600-line orchestrator was
   impractical.

Spec v2 §1–3 (the logical-OR depth trigger, the no-decision_hint
policy, the editorial-threshold convention) are unchanged.

The pipeline implementation was committed to MIWikiAI/scripts/ in
commit `1fe0660` (2026-04-25): *"miwikiai: empirical
seed/reachable/symbols/count pipeline (Phase 0.1)"*.

### Authorship and review

* **Coder:** Claude9 (this document and the six scripts).
* **Architect:** Marian Ivanov (final ratification authority).
* **Peer reviewers (assigned):** Claude2 (algorithmic correctness),
  Claude4 (governance fit), Claude5 (wiki-fitness).
* **Pinned dependencies:** AliceO2 SHA `87b9775`. O2DPG and O2Physics
  unpinned (see §7.2).

### Empirical baseline (2026-04-25)

| Stage | Output | Count |
|---|---|---|
| O2DPG scan | invocations | 710 |
| AliceO2 catalogue | binary→source rows | 572 |
| O2Physics catalogue | binary→source rows | 1380 |
| Seed join (O2 only, TPC scope) | unique seed source paths | 140 |
| Reachable closure | files in include set | 1569 (13-iter, 3 s) |
| Symbol extraction | symbols total | 105 827 |
| Symbol extraction unique `(name, file)` | | 88 254 |
| Count stage filtered (Common-ish public API) | symbols counted | 1757 |
| `prod_usage_count` ≥ 100 | deep-trigger candidates | 191 |
| Total runtime | end-to-end | ~100 seconds |

End of document.
