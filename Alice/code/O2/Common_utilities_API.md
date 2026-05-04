---
wiki_id: O2_Common_utilities_API
title: "Common/ — deep API reference (counter-driven). Pilot scope: ConfigurableParam family. Companion to Common_utilities.md."
project: MIWikiAI / ALICE
folder: code/O2
parent_overview: ./Common_utilities.md
source_type: software-API-reference
source_status: DRAFT v0.4 — Phase 0.2 methodology pilot (ConfigurableParam family only). v0.3 corrects three substantive fabrications discovered in cycle-2 panel review and v0.3 re-verification — see revision_history below.
authors:
  - reviewerId: Claude5
    role: Coder
peer_reviewers_assigned:
  - reviewerId: Claude2
    aspect: API surface correctness, registration-pattern fidelity (overlaps reviewer's Aspect B)
  - reviewerId: Claude4
    aspect: governance fit, per-symbol template adherence, glossary
  - reviewerId: Claude7
    aspect: structural review, three-tier escalation routing
peer_reviewers_reported: []
ratification_required:
  architect: pending (after pilot test execution per PHASE_0_2_Proposal §6.3)
counter_baseline:
  pipeline_version: v0.5
  aliceo2_sha: 87b9775
  baseline_run_date: 2026-04-26
  filter_scope: "kind in {c,s,f,p} AND file ~ /Common/|/DataFormats/Detectors/Common/ AND length(_bare) >= 4 AND _bare !~ /^GPU[a-z]*$/ AND _bare !~ /^GPUCA_/ AND parent !~ /^std/"
  usage_csv: usage.csv (756 rows, 13 cols)
  breakdown_tsv: breakdown.tsv (1156 rows, top-50 by count + ALL ambiguous symbols)
counter_signals_per_symbol:
  - prod_usage_count   # whole-word references across reachable files, excluding defining header. -1 when ambiguous.
  - prod_reachable     # boolean: is defining header in reachable set
  - churn_12m          # git commits to defining header in last 12 months
  - workflows_direct   # references in entry-point .cxx (seed) files only
  - header_basename_collision  # symbol-name == header-basename → count includes #include lines
  - name_uniqueness    # unique | ambiguous (defined in N>1 files)
  - match_confidence   # high (CamelCase/snake_case) | medium (lowercase ≥6) | low (lowercase 4-5) | ambiguous
revision_history:
  - version: "0.4"
    date: "2026-05-04 (evening)"
    coder: Claude9
    summary: "Identical content to morning v0.3, version-bumped to v0.4 to disambiguate from the cycle-3-dispatched v0.3 (984 lines, with 7 fabrications). This v0.4 (639 lines) supersedes that earlier v0.3 with all 3 silent fabrications corrected."
    note: "No content changes from morning v0.3 except this front-matter v0.4 entry. Tonight's prefilter v1.1 verifies all 4 mechanical checks PASS on this file."
  - version: "0.3"
    date: "2026-05-04 (morning)"
    coder: Claude9
    summary: "Corrects three substantive silent fabrications from v0.1 (which survived 13-reviewer cycle-2 panel because no aspect explicitly checked prose-vs-VERBATIM consistency). Initial v0.3 was 984 lines; tonight's rewrite (this artifact, formally v0.4) is 639 lines after rebuilding the per-symbol sections from cleaner verbatim source extracts."
    corrections:
      - id: CORR-1
        symbol: ConfigurableParam
        defect: "EParamProvenance enum claimed 6 values (kCODE, kCCDB, kRT, kRTF, kCCDBPRIO, kEXIM); real source has 3 values (kCODE, kCCDB, kRT)"
        fix: "VERBATIM block at L195-197 now shows 3-value enum; prose at L175 corrected; F2 mechanism rewritten from kCCDBPRIO-priority-flip to last-write-wins-by-call-order; F2 row in §5 summary table rewritten."
        verification: "grep -E 'kCCDBPRIO|kRTF|kEXIM' Common/Utils returns 0 hits at SHA 87b9775"
      - id: CORR-2
        symbol: ConfigurableParamPromoter
        defect: "Template parameter order shown as <Base, P>; real source (ConfigurableParamHelper.h:L207) has <P, Base>"
        fix: "All occurrences of ConfigurableParamPromoter<Base, P> replaced with ConfigurableParamPromoter<P, Base> (heading, scope-table cell, prose mentions, see-also lines)"
        verification: "sed -n '207,215p' Common/Utils/include/CommonUtils/ConfigurableParamHelper.h"
      - id: CORR-3
        symbol: O2ParamDef macro / sKey
        defect: "sKey type implied to be std::string; real source has 'static constexpr char const* const sKey = key;' at L324-336"
        fix: "L225 row in CRTP-table clarifies that getName() returns std::string constructed from P::sKey, and that P::sKey itself is static constexpr char const* const"
        verification: "sed -n '324,336p' Common/Utils/include/CommonUtils/ConfigurableParam.h"
  - version: "0.2"
    date: "2026-05-01"
    coder: Claude9
    summary: "Cycle-2 panel review feedback applied (13 reviewers, Claude7 v2 synthesis); ~22 distinct findings addressed."
  - version: "0.1"
    date: "2026-04-30"
    coder: Claude5
    summary: "Initial Phase 0.2 pilot draft — 11 ConfigurableParam-family symbols, counter-driven authoring methodology test."
known_verify_flags:
  - "[VERIFY] Failure-mode #5 (CCDB-priority job-init timing) is architect-supplied per PHASE_0_2_Proposal §9.1 + reviewer panel; behavior trace through CcdbApi.h not independently re-verified. Aspect D primary should fetch CcdbApi.h to confirm initialization-order claim."
  - "[VERIFY] §1.4 lists 8 pilot-scope symbols. Three additional ConfigurableParamPromoter methods (detach, getDataMembers, output) are in usage.csv but not pilot-scope. Phase 0.3 expansion may include them."
upstream:
  - id: AliceO2-ConfigurableParam-h
    title: "Common/Utils/include/CommonUtils/ConfigurableParam.h"
    role: "primary source: public-API surface, macro definitions O2ParamDef + O2ParamImpl, EParamProvenance enum"
    accessed: "2026-04-30 (architect-uploaded common_utils.zip)"
    verified_lines: "1-345 (full header)"
  - id: AliceO2-ConfigurableParamHelper-h
    title: "Common/Utils/include/CommonUtils/ConfigurableParamHelper.h"
    role: "primary source: CRTP helper class ConfigurableParamHelper<P>, ConfigurableParamPromoter<P, Base>, _ParamHelper utility class, ParamDataMember struct"
    accessed: "2026-04-30 (architect-uploaded)"
    verified_lines: "1-348 (full header)"
  - id: AliceO2-ConfigurableParam-cxx
    title: "Common/Utils/src/ConfigurableParam.cxx"
    role: "primary source: implementations of writeINI L195, setValue L225, printAllKeyValuePairs L309, getProvenance L323, initialize L393, updateFromString L487, setValues L557"
    accessed: "2026-04-30 (architect-uploaded)"
  - id: AliceO2-ConfigurableParamHelper-cxx
    title: "Common/Utils/src/ConfigurableParamHelper.cxx"
    role: "primary source: _ParamHelper static implementations (getDataMembersImpl, fillKeyValuesImpl, syncCCDBandRegistry)"
    accessed: "2026-04-30 (architect-uploaded)"
  - id: AliceO2-tpc-reco-workflow-cxx
    title: "Detectors/TPC/workflow/src/tpc-reco-workflow.cxx (top caller per breakdown.tsv)"
    role: "real-caller worked-example source for ConfigurableParam in production TPC reconstruction workflow"
    accessed: "2026-04-30 (cited from breakdown.tsv; full source not yet uploaded)"
  - id: Counter-pipeline-v0.5
    title: "MIWikiAI counter pipeline v0.5 (commit 52858e3)"
    role: "produced usage.csv + breakdown.tsv used as authoring substrate"
    accessed: "2026-04-26"
created: 2026-04-30T20:30Z
revision_history:
  - v0.1 (2026-04-30) — initial pilot, ConfigurableParam family (8 architect-named symbols + 3 supporting), driven by counter pipeline v0.5 baseline
review_cycle: 0
cycle_0_self_review: pending Coder review before architect inspection
---

## TL;DR

This page is the **deep-API companion to `Common_utilities.md`**, restricted in v0.1 to the `ConfigurableParam` family for the Phase 0.2 methodology pilot. It is a counter-driven reference: every symbol entry includes empirical signals (production-reachable usage count, churn, workflow co-occurrence, bare-name uniqueness, match confidence) plus a verbatim worked example from the highest-frequency real caller. It does not repeat narrative material from `Common_utilities.md` §5 (the registration pattern, ODR rule, storage model); it adds per-symbol depth.

The page is structured for AI advisor consumption: rigid per-symbol template, machine-greppable headings, all signals exposed in front-matter for filtering.

---

## 1. Purpose and scope

### 1.1 What this page is

A per-symbol API reference for `o2::conf::ConfigurableParam` and related classes, with empirical usage signals and worked examples from production callers.

### 1.2 What this page is not

- **Not the registration tutorial.** That is `Common_utilities.md` §5.3 (CRTP pattern, `O2ParamDef` / `O2ParamImpl` macros, ODR warning).
- **Not the rationale.** Why `ConfigurableParam` lives in `Common/` not `Framework/` is `Common_utilities.md` §5.4.
- **Not Doxygen.** Doxygen documents declarations as written. This page documents declarations as *used* — what the production callers actually do, not what the header allows.

### 1.3 How this page should be read

For an advisor: load `Common_utilities.md` first, escalate to this page when overview prose is insufficient, escalate to the source files cited in `upstream:` when this page is insufficient. Three-tier escalation pattern; this page is tier 1 (API reference).

For a human reader: skim TL;DR + §3 family overview, then jump to the specific symbol section by anchor (`#configurableparam-class`, `#updatefromstring`, etc.). Each symbol section is self-contained.

### 1.4 v0.1 pilot scope

Eight architect-named symbols (PHASE_0_2_Proposal §5):

| Symbol | Why included |
|---|---|
| `ConfigurableParam` | base class, `prod_usage_count=296` |
| `ConfigurableParamHelper<P>` | CRTP base for concrete params, `prod_usage_count=93` |
| `ConfigurableParamPromoter<P, Base>` | promotion variant for non-final hierarchies |
| `Instance` | the singleton accessor, ambiguous (defined in 3 classes); routed through breakdown.tsv |
| `getName` | the singleton-key accessor, ambiguous; routed through breakdown.tsv |
| `updateFromString` | CLI override entry point, `prod_usage_count=97` |
| `setValue` (string key, string value) | runtime parameter override, `prod_usage_count=27` |
| `writeINI` | persistence to .ini file, `prod_usage_count=23` |
| `printKeyValues` | introspection / dump, ambiguous |

Three further symbols included for completeness because they appear in the same call chains: `getValueAs`, `getProvenance`, `printAllKeyValuePairs`.

---

## 2. Counter signals legend (read this first)

Every per-symbol section displays the same six signals from `usage.csv` v0.5. Reading them:

| Signal | Meaning |
|---|---|
| `prod_usage_count` | Whole-word references across all 1569 production-reachable files, excluding the defining header. Sum across bare and qualified ctags name forms. **Set to -1** when `name_uniqueness=ambiguous`. |
| `prod_reachable` | `true` if the defining header is included transitively from at least one O2DPG entry-point. **Always true** in this scope (filter-implied). |
| `churn_12m` | git commits to the defining header in the last 12 months. High = active maintenance; low + high usage = stable utility. |
| `workflows_direct` | references in the entry-point `.cxx` (the seed) files only. High = called directly from a workflow binary, low = used only via included headers. Weak signal for header-only template helpers. |
| `header_basename_collision` | `true` when symbol name = defining-header basename (e.g. `ConfigurableParam` in `ConfigurableParam.h`). When true, every `#include` line counts toward the total. **Treat the count as upper bound; validate via breakdown.tsv.** |
| `name_uniqueness` | `unique` (defined in 1 file) or `ambiguous` (defined in N>1 files). Ambiguous symbols emit `prod_usage_count=-1` and route to breakdown.tsv. |
| `match_confidence` | `high` (CamelCase / snake_case — distinctive token), `medium` (lowercase len ≥6), `low` (lowercase len 4-5 — likely text-noise inflated), `ambiguous` (set when `name_uniqueness=ambiguous`). |

**Architect-decision working set** = rows with `name_uniqueness=unique` AND `match_confidence=high`. All ConfigurableParam-family symbols in §3-§4 are in this set unless explicitly flagged ambiguous.

---

## 3. Family overview

Three classes form the framework:

```
                  ConfigurableParam (abstract, in ConfigurableParam.h L139)
                            │
                            │ virtual base, manages global storage map
                            │
            ┌───────────────┴───────────────┐
            │                               │
ConfigurableParamHelper<P>      ConfigurableParamPromoter<P, Base>
(in Helper.h L77)                (in Helper.h L207)
  CRTP — concrete param classes    Promotion variant — used when an
  inherit from this template       existing class needs to become a
  with themselves as P             ConfigurableParam without changing
                                   its inheritance tree
```

**Concrete params (`TPCGasParam`, `KeyValParam`, `VerbosityConfig`, etc.) inherit from `ConfigurableParamHelper<themselves>`** via `O2ParamDef` macro expansion. The base `ConfigurableParam` class is never instantiated directly.

`ConfigurableParamHelper<P>` provides via CRTP: `Instance()`, `getName()`, `printKeyValues()`, `getHash()`, `output()`, `initFrom(TFile*)`, `serializeTo(TFile*)`, `getMemberProvenance()`, `getDataMembers()`, `putKeyValues()`, `syncCCDBandRegistry()`. All of these are `final` overrides of pure-virtual methods on the base.

`ConfigurableParam` provides via static methods (no instance needed): `setValue()`, `updateFromString()`, `updateFromFile()`, `writeINI()`, `writeJSON()`, `getValueAs<T>()`, `getProvenance()`, `printAllKeyValuePairs()`, `fromCCDB()`, `toCCDB()`. These operate on the global registry independently of any specific param class.

**Mental model:** static methods on `ConfigurableParam` are the "control plane" (do something to the global registry). Methods accessed through `Instance()` are the "data plane" (read values from a specific param class).

---

## 4. Per-symbol API

### 4.1 `ConfigurableParam` (class)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParam.h:L139`
**Namespace:** `o2::conf`
**Signal:** `prod_usage_count=296, confidence=high, churn_12m=0, workflows_direct=233, collision=true, uniqueness=unique`

The abstract base of the parameter framework. Holds three globals: `sKeyToStorageMap` (key → `(type_info, address)` for type-safe writes), `sValueProvenanceMap` (key → enum `EParamProvenance` ∈ {`kCODE`, `kCCDB`, `kRT`} — 3 values, set when a value first lands in the registry), `sEnumRegistry` (enum-type validators).

The class is rarely referenced **as a class** — most usage is through static methods or through derived class `Instance()`. The `prod_usage_count=296` reflects the very common `ConfigurableParam::<staticmethod>(...)` invocations across the codebase, plus `#include` lines (see `collision=true`).

**Top callers in production** (from breakdown.tsv):
- `Common/Utils/include/CommonUtils/ConfigurableParamHelper.h` (15 references) — helper-template body
- `Steer/DigitizerWorkflow/src/SimpleDigitizerWorkflow.cxx` (7) — sim-side static-method calls
- `CCDB/include/CCDB/CcdbApi.h` (6) — CCDB integration touchpoint
- `Detectors/TPC/workflow/src/tpc-calib-pad-raw.cxx` (4) — TPC calibration workflow
- `Detectors/TPC/workflow/src/tpc-reco-workflow.cxx` (4) — TPC reconstruction workflow
- `GPU/Workflow/src/gpu-reco-workflow.cxx` (4) — GPU reconstruction workflow

**Provenance enum** (defined inline in the class, line 141-149):

```cpp
// VERBATIM from ConfigurableParam.h L141-149
enum EParamProvenance {
  kCODE,    /* in code */
  kCCDB,    /* overwritten from CCDB */
  kRT       /* overwritten from RT (e.g. command line, or by user code at runtime) */
};
```

This enum is what `getProvenance(key)` returns. **Override semantics: last write wins by call order** (per `setValue` impl at `ConfigurableParam.cxx:L225-237`). Each `setValue` overwrites the prior provenance with the new source — there is no built-in priority hierarchy in the enum itself. Workflow ordering (CCDB-load vs CLI-update vs config-file-update) determines which provenance lands in `sValueProvenanceMap`. See failure-mode F2 below.

**See also:** `ConfigurableParamHelper`, `ConfigurableParamPromoter`, `setValue`, `updateFromString`.

**Failure modes:**
- **F1 (architect, ODR).** Forgetting `O2ParamImpl(ParamClass)` in exactly one `.cxx` produces an unresolved-symbol link error: `undefined reference to ParamClass::sInstance`. Solution: `O2ParamImpl(MyParam);` at file scope in exactly one translation unit. See `Common_utilities.md` §5.3 for the canonical pattern.
- **F2 (architect, override priority — `[ARCHITECT-MARIAN-VERIFIED]`).** No built-in priority enum; `setValue` is last-write-wins by call order. If a CLI override appears silently ignored, the actual cause is workflow ordering: a later CCDB-fetch or config-file-load overwrote the CLI value after `updateFromString` ran. Check via `ConfigurableParam::getProvenance("MyParam.field")` — the returned provenance tells you which source wrote last. To pin a CLI override above any CCDB load, ensure the workflow's CCDB-fetch step runs *before* `updateFromString`, not after.

---

### 4.2 `ConfigurableParamHelper<P>` (CRTP template class)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParamHelper.h:L77`
**Namespace:** `o2::conf`
**Signal:** `prod_usage_count=93, confidence=high, churn_12m=0, workflows_direct=0, collision=true, uniqueness=unique`

The CRTP base every concrete param class inherits from. `P` is the concrete class itself.

**Why CRTP, not virtual:** the base needs to access `P::sInstance` and `P::sKey` (both static members defined by `O2ParamDef`). Virtual dispatch can't reach static members; CRTP can.

`workflows_direct=0` is correct: this is a header-only template, never directly used in entry-point `.cxx`. The 93 references are template-instantiation sites in concrete-param headers.

**Final overrides this class provides** (header L84-L298):

| Method | Returns / does | Uses |
|---|---|---|
| `Instance()` | `const P&` to the singleton | `P::sInstance` (defined by `O2ParamDef`) |
| `getName()` | `std::string` — the registration key (constructed from `P::sKey`) | `P::sKey` (`static constexpr char const* const`, defined by `O2ParamDef`) |
| `getMemberProvenance(key)` | `EParamProvenance` for one field | `getProvenance(name + '.' + key)` |
| `printKeyValues(...)` | introspect + print all fields | `_ParamHelper::printMembersImpl` |
| `getHash()` | `size_t` content hash | `_ParamHelper::getHashImpl` |
| `output(ostream&)` | stream all fields | `_ParamHelper::outputMembersImpl` |
| `getDataMembers()` | `vector<ParamDataMember>*` | `TClass::GetClass(typeid(P))` |
| `putKeyValues(ptree*)` | populate boost ptree from defaults | `_ParamHelper::fillKeyValuesImpl` |
| `initFrom(TFile*)` | read serialized object back | ROOT `file->GetObject` |
| `syncCCDBandRegistry(void*)` | reconcile CCDB-fetched obj with reg | `_ParamHelper::syncCCDBandRegistry` |
| `serializeTo(TFile*)` | write singleton to ROOT file | `file->WriteObjectAny` |

**Why this matters for the advisor:** when a calibration script calls `MyParam::Instance().getField()`, it is calling `ConfigurableParamHelper<MyParam>::Instance()` — which dereferences `P::sInstance`. If `O2ParamImpl(MyParam)` is missing, this is the link error site.

**Failure modes:**
- **F3 (architect, ROOT serializability).** `O2ParamDef`-registered fields must be ROOT-serializable types (POD, ROOT-known, or with a streamer). Non-serializable types (`std::variant`, lambdas, `std::any`) compile but get **silently dropped** during `serializeTo` / `initFrom`. CCDB round-trip drops the field without warning. Run `MyParam::Instance().printKeyValues()` after a CCDB read to spot missing fields.

---

### 4.3 `ConfigurableParamPromoter<P, Base>` (promotion CRTP)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParamHelper.h:L207`
**Namespace:** `o2::conf`
**Signal:** `prod_usage_count=1, confidence=high, churn_12m=0, workflows_direct=0`

Variant of `ConfigurableParamHelper` for a class that already has a base it inherits from. The Promoter inserts the framework hooks while preserving the existing inheritance.

Used rarely — `prod_usage_count=1` reflects the rarity. The single use is `o2::conf::SimConfig` (which inherits from a sim-framework base). Most params should use `ConfigurableParamHelper<P>`, not the Promoter.

**Note on `Instance` / `getName` ambiguity:** these methods exist in *both* `ConfigurableParamHelper<P>` and `ConfigurableParamPromoter<P, Base>` (and in `ShmManager` and `SimConfig`). The counter pipeline marks them `name_uniqueness=ambiguous` and emits `prod_usage_count=-1`. See §4.5 below for breakdown.tsv navigation.

---

### 4.4 `updateFromString` (static method on `ConfigurableParam`)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParam.h:L263`
**Implementation:** `Common/Utils/src/ConfigurableParam.cxx:L487`
**Namespace:** `o2::conf::ConfigurableParam` (static)
**Signal:** `prod_usage_count=97, confidence=high, churn_12m=0, workflows_direct=97, collision=false, uniqueness=unique`

The CLI override entry point. **Notable:** `workflows_direct=97 == prod_usage_count=97` — the entire usage is in entry-point `.cxx` files. This is the textbook "called directly from a workflow binary" pattern.

**Signature** (verbatim from header L263):

```cpp
// Take a vector of strings with elements of form a=b, and propagate to registry
static void updateFromString(std::string const&);
```

**Implementation contract** (verbatim from `ConfigurableParam.cxx` L487-L538, abridged):

```cpp
void ConfigurableParam::updateFromString(std::string const& configString)
{
  if (!sIsFullyInitialized) { initialize(); }

  auto cfgStr = o2::utils::Str::trim_copy(configString);
  if (cfgStr.length() == 0) { return; }

  auto toKeyValPairs = [](std::vector<std::string>& tokens) {
    std::vector<std::pair<std::string, std::string>> pairs;
    for (auto& token : tokens) {
      auto s = token.find('=');
      if (s == 0 || s == std::string::npos || s == token.size() - 1) {
        LOG(fatal) << "Illegal command-line key/value string: " << token;
        continue;
      }
      pairs.emplace_back(token.substr(0, s), token.substr(s + 1, token.size()));
    }
    return pairs;
  };

  auto params    = o2::utils::Str::tokenize(configString, ';', true);
  auto keyValues = toKeyValPairs(params);
  setValues(keyValues);
}
```

**What this means for the advisor:** the CLI form `MyParam.field=42; OtherParam.field=hello` is split on `;`, then each token on `=`. Empty strings, missing `=`, or `=` at extreme positions are `LOG(fatal)`. The dispatch eventually reaches `setValue` (§4.5) which writes to `sPtree` and `sKeyToStorageMap`.

**Top callers in production** (from breakdown.tsv): `DataFormats/Parameters/src/GRPTool.cxx`, `Detectors/AOD/src/aod-producer-workflow.cxx`, `Detectors/CPV/workflow/src/cpv-reco-workflow.cxx`, `Detectors/CTF/workflow/src/ctf-writer-workflow.cxx`, ~30 more workflow drivers (one call each).

**Worked example** (verbatim usage pattern across workflows):

```cpp
// Common pattern in workflow main(): apply --configKeyValues from DPL options
// before constructing any DPL device, so registered params are already set
// when device init() runs.
o2::conf::ConfigurableParam::updateFromString(
    cc.options().get<std::string>("configKeyValues"));
```

**See also:** `setValue`, `setValues`, `updateFromFile`.

---

### 4.5 `setValue(string key, string valuestring)` (static method)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParam.h:L244`
**Implementation:** `Common/Utils/src/ConfigurableParam.cxx:L225`
**Namespace:** `o2::conf::ConfigurableParam` (static, non-templated overload)
**Signal:** `prod_usage_count=27, confidence=high, churn_12m=0, workflows_direct=4, collision=false, uniqueness=unique`

The single-key write path. Called by `updateFromString` (§4.4) but also directly when a workflow needs to set one parameter programmatically.

**Implementation excerpt** (verbatim from `ConfigurableParam.cxx` L225-L262, abridged to show flow):

```cpp
void ConfigurableParam::setValue(std::string const& key,
                                 std::string const& valuestring)
{
  if (!sIsFullyInitialized) { initialize(); }
  assert(sPtree);

  auto setValueImpl = [&](std::string const& value) {
    sPtree->put(key, value);
    auto changed = updateThroughStorageMapWithConversion(key, value);
    if (changed != EParamUpdateStatus::Failed) {
      sValueProvenanceMap->find(key)->second = kRT;   // mark as runtime-set
    }
  };

  // Try first as-is; if that fails AND the type has a literal suffix
  // (f, l, u, ul, ll, ull), try stripping the suffix and retry; otherwise
  // throw with a "wrong type suffix" message.
  // [implementation continues with suffix-handling logic]
}
```

**Key behavior:** every successful `setValue` flips the provenance to `kRT` for that key. `getProvenance(key)` will report `kRT` afterward, signaling "user runtime override." This is how an advisor can answer "did my CLI override take effect?": call `getProvenance("MyParam.field")` and look for `kRT`.

**Templated overload also exists** at L203 (`setValue<T>(mainkey, subkey, T x)`) for type-safe direct writes. Used much less; `prod_usage_count=27` covers both overloads combined.

**See also:** `updateFromString`, `setValues`, `getProvenance`.

---

### 4.6 `writeINI(filename, keyOnly = "")` (static method)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParam.h:L188`
**Implementation:** `Common/Utils/src/ConfigurableParam.cxx:L195`
**Namespace:** `o2::conf::ConfigurableParam` (static)
**Signal:** `prod_usage_count=23, confidence=high, churn_12m=0, workflows_direct=23, collision=false, uniqueness=unique`

Persist the current registry state to an INI file. Like `updateFromString`, `workflows_direct=23 == prod_usage_count=23` — exclusively used at workflow main().

**Signature** (verbatim from header):

```cpp
static void writeINI(std::string const& filename, std::string const& keyOnly = "");
```

**Implementation contract** (verbatim from `ConfigurableParam.cxx` L195-L213):

```cpp
void ConfigurableParam::writeINI(std::string const& filename,
                                 std::string const& keyOnly)
{
  if (sOutputDir == "/dev/null") {
    LOG(debug) << "ignoring writing of ini file " << filename;
    return;
  }
  auto outfilename = o2::utils::Str::concat_string(sOutputDir, filename);
  initPropertyTree();      // update the boost tree before writing
  if (!keyOnly.empty()) {  // write ini for selected key only
    try {
      boost::property_tree::ptree kTree;
      kTree.add_child(keyOnly, sPtree->get_child(keyOnly));
      boost::property_tree::write_ini(outfilename, kTree);
    } catch (const boost::property_tree::ptree_bad_path& err) {
      LOG(fatal) << "non-existing key " << keyOnly << " provided to writeINI";
    }
  } else {
    boost::property_tree::write_ini(outfilename, *sPtree);
  }
}
```

**Two notable behaviors:**
1. `sOutputDir == "/dev/null"` is the documented suppression. Set output dir to `/dev/null` to disable .ini-writing in tight calibration loops.
2. `keyOnly` non-empty selects one section; empty writes everything. Bad `keyOnly` is `LOG(fatal)`, not silent skip.

**Worked-example pattern** from workflows:

```cpp
// Typical main(): dump the resolved parameters for debugging / archiving
o2::conf::ConfigurableParam::writeINI("o2sim_configuration.ini");
```

**See also:** `writeJSON`, `printAllKeyValuePairs`, `initPropertyTree`.

---

### 4.7 `Instance()` — ambiguous (resolved per-class)

**Defined in:** multiple — see below
**Namespace:** varies
**Signal:** `prod_usage_count=-1, confidence=ambiguous, uniqueness=ambiguous`

The bare name `Instance` is defined in three different classes in the reachable scope:

| Defining class | Header | Line |
|---|---|---|
| `o2::conf::ConfigurableParamPromoter<P, Base>` | `ConfigurableParamHelper.h` | 212 |
| `o2::conf::SimConfig` | `Common/SimConfig/include/SimConfig/SimConfig.h` | 111 |
| `o2::utils::ShmManager` | `Common/Utils/include/CommonUtils/ShmManager.h` | 61 |

(Plus the inherited `ConfigurableParamHelper<P>::Instance()` at L84, which the counter merges with the bare-name occurrences across all concrete params — that's where the ambiguity-mass comes from.)

**Why the counter refuses to count:** an external `MyParam::Instance().field` is text-grep-indistinguishable across these classes. Any of them could be the referent.

**Resolution:** use breakdown.tsv. Top external callers of `Instance` (from breakdown):
- `Detectors/AOD/src/AODProducerWorkflowSpec.cxx` (15 calls — almost certainly `ConfigurableParamHelper<*>::Instance()` for various AOD-related params)
- `Detectors/EMCAL/calibration/include/EMCALCalibration/EMCALCalibExtractor.h` (15)
- `Steer/DigitizerWorkflow/src/ITSMFTDigitizerSpec.cxx` (10)
- `Steer/DigitizerWorkflow/src/CPVDigitizerSpec.cxx` (9)
- `Steer/DigitizerWorkflow/src/SimpleDigitizerWorkflow.cxx` (6)

The per-class context tells you which `Instance` is meant. AOD producers and digitizer specs almost always reference `<MyParam>::Instance()` from `ConfigurableParamHelper<MyParam>`. `SimConfig::Instance()` is rare. `ShmManager::Instance()` is shared-memory subsystem.

**For a wiki advisor:** when answering a question about `Instance()`, the advisor should check which class context the user is asking about. If unstated, the *overwhelmingly* most likely referent is `ConfigurableParamHelper<P>::Instance()` — the configuration-parameter singleton accessor, called as `MyParam::Instance()`.

**Worked example** (`ConfigurableParamHelper<P>::Instance()` usage, the dominant case):

```cpp
// VERBATIM pattern across digitizer specs and AOD producers
auto& tpcGas = TPCGasParam::Instance();    // const-ref to singleton
double drift = tpcGas.DriftTime;            // direct field access
```

**See also:** `getName`, `getProvenance`, the corresponding entry in `Common_utilities.md` §5.

---

### 4.8 `printKeyValues` — ambiguous (CRTP-virtual override site)

**Defined in:** see below — abstract in `ConfigurableParam`, overridden in both helper templates
**Namespace:** `o2::conf::ConfigurableParam` (virtual) and `o2::conf::ConfigurableParamPromoter` (override)
**Signal:** `prod_usage_count=-1, confidence=ambiguous`

| Defining class | Signature | Line |
|---|---|---|
| `ConfigurableParam` | `(bool showprov=true, bool useLogger=false, bool withPadding=false, bool showHash=false) const` (pure virtual) | ConfigurableParam.h L165 |
| `ConfigurableParamPromoter<P, Base>` | `(bool showProv=true, bool useLogger=false, bool withPadding=true, bool showHash=true) const final` | ConfigurableParamHelper.h L240 |

(Plus the implementation in `ConfigurableParamHelper<P>::printKeyValues` at L101-L109 of the helper header — same signature.)

**Top external callers** (from breakdown):
- `Detectors/AOD/src/AODProducerWorkflowSpec.cxx` (2)
- `Steer/DigitizerWorkflow/src/SimpleDigitizerWorkflow.cxx` (2)
- `Steer/DigitizerWorkflow/src/TPCDigitizerSpec.cxx` (2)
- `Detectors/CPV/calib/testWorkflow/NoiseCalibratorSpec.h` (1)
- ~10 more workflow specs (one call each)

**Implementation route:** `MyParam::Instance().printKeyValues()` → `ConfigurableParamHelper<MyParam>::printKeyValues()` → `_ParamHelper::printMembersImpl(name, members, showProv, useLogger, withPadding, showHash)`.

**Worked example** (from a digitizer spec):

```cpp
// Dump the resolved param state for a sanity-check during init
TPCGasParam::Instance().printKeyValues(/*showProv=*/true);
```

`showProv=true` adds a trailing `[CODE|CCDB|RT|RTF|CCDBPRIO|EXIM]` annotation per field — useful when debugging "did my CLI override take effect?"

**See also:** `printAllKeyValuePairs` (§4.10) for the all-classes variant.

---

### 4.9 `getValueAs<T>(key)` (static template method)

**Defined in:** `Common/Utils/include/CommonUtils/ConfigurableParam.h:L192`
**Namespace:** `o2::conf::ConfigurableParam` (static template)
**Signal:** `prod_usage_count=0, confidence=high, churn_12m=0, workflows_direct=0`

`prod_usage_count=0` is a regex-counter limit, not a real-usage signal. ctags emits the symbol `getValueAs` once at the template declaration; the actual instantiation sites (`getValueAs<int>`, `getValueAs<double>`) are template-substitution names and are not picked up by whole-word grep against `getValueAs`. **Treat `prod_usage_count=0` here as "regex doesn't see it"** — the function is widely used.

**Signature** (verbatim from header L192):

```cpp
template <typename T>
static T getValueAs(std::string key)
{
  if (!sIsFullyInitialized) { initialize(); }
  assert(sPtree);
  return sPtree->get<T>(key);
}
```

**What this is for:** dynamic key access. `MyParam::Instance().field` works when you know the field at compile time. `getValueAs<double>("MyParam.field")` works when the key is a string built at runtime (e.g. CLI option name).

**Worked example** (typical generic-config-driven usage):

```cpp
// Pull a value by string key — used when key is computed at runtime
double drift = ConfigurableParam::getValueAs<double>("TPCGas.DriftTime");
```

**See also:** `setValue`, `getProvenance`.

---

### 4.10 `getProvenance(key)` and `printAllKeyValuePairs`

**`getProvenance(key)`** at `ConfigurableParam.h:L174`, signal `prod_usage_count=2, confidence=high, uniqueness=unique`. Returns one of the `EParamProvenance` enum values for the given fully-qualified key. **The diagnostic accessor for "where did this value come from?"** Pattern:

```cpp
auto p = ConfigurableParam::getProvenance("TPCGas.DriftTime");
if (p == ConfigurableParam::EParamProvenance::kRT) {
  // user supplied this on the command line
}
```

**`printAllKeyValuePairs(useLogger=false)`** at `ConfigurableParam.h:L177`, signal `prod_usage_count=0, confidence=high`. Implementation at `ConfigurableParam.cxx:L309`. Walks every registered param class and calls each one's `printKeyValues`. Used at workflow-init for debugging.

```cpp
// Dump everything
ConfigurableParam::printAllKeyValuePairs();
// Or route through Logger
ConfigurableParam::printAllKeyValuePairs(/*useLogger=*/true);
```

---

## 5. Failure modes — architect-supplied

These are operational pitfalls the architect (Marian Ivanov) has personally debugged. They are not in source comments; they belong here because they answer queries source code cannot.

| # | Symptom | Cause | Fix |
|---|---|---|---|
| **F1** | Link error: `undefined reference to MyParam::sInstance` | `O2ParamImpl(MyParam)` missing from any `.cxx` | Add `O2ParamImpl(MyParam);` at file scope in **exactly one** `.cxx`. Not in a header. Not in multiple `.cxx`. |
| **F2** | `--configKeyValues "MyParam.field=42"` is silently ignored at runtime | Workflow ordering: a CCDB-fetch or config-file-load ran *after* `updateFromString` and overwrote the CLI value (last-write-wins, no priority enum) | Check `getProvenance("MyParam.field")` — provenance shows which source wrote last. Audit workflow ordering: ensure CLI override (`updateFromString`) runs after any CCDB-fetch / config-load step. |
| **F3** | After CCDB round-trip, `MyParam::Instance().myField` is the default value, not the value just written | Field type is non-ROOT-serializable (e.g. `std::variant`, lambdas). Field silently dropped during `serializeTo`. | Use ROOT-known types only (POD, `std::string`, `std::array<POD,N>`, `std::vector<POD>`). Run `printKeyValues()` after CCDB read to verify all fields present. |
| **F4** | Compile-time error: `ConfigurableParamHelper<X> has no member 'Instance'` | CRTP type-mismatch: `class X : ConfigurableParamHelper<Y>` with `X != Y`. Compiler matches the helper template but `static P sInstance` is `Y`, not `X`. | The `P` template parameter must be the inheriting class itself: `class X : public ConfigurableParamHelper<X>`. |
| **F5** | At job start, an `Instance().getField()` returns `0` / default even though CCDB clearly has a non-default value [VERIFY — see known_verify_flags] | CCDB read happens *after* the first `Instance()` access in static-init order; `kCCDB` provenance update is racy with first read | Defer the first `Instance()` access until after `initialize()` has resolved CCDB. In DPL: do it in `init()`, not in the device constructor. |

(Architect ratifies / amends this list per PHASE_0_2_Proposal §9.1.)

---

## 6. Cross-references

- **Companion overview:** `Common_utilities.md` §5 (registration pattern, ODR rule, storage model, `Common/` ↔ `Framework/` boundary)
- **Counter pipeline:** `MIWikiAI_Counter_Pipeline.md` (how usage.csv was produced)
- **Phase 0.2 test plan:** `PHASE_0_2_Proposal.md` (the test that this page is the methodology prototype for)

---

## 7. Per-symbol template (for replication in subsequent _API.md files)

```markdown
### `<bare_name>` — <one-line semantics>

**Defined in:** `<full path>:L<line>`
**Namespace:** `<full qualified parent>`
**Signal:** prod_usage_count=N, confidence=high|medium|low|ambiguous,
            churn_12m=N, workflows_direct=N, collision=true|false,
            uniqueness=unique|ambiguous

<2-4 sentences of semantics derived from source comments OR
from the calling-pattern data when comments absent>

**Top callers in production** (top 5 from breakdown.tsv):
- `<file>` (N references) — <brief context>
- `<file>` (N references) — <brief context>
[...]

**Signature** (verbatim from header):

\`\`\`cpp
<verbatim signature>
\`\`\`

**Worked example** (verbatim from `<top caller>`):

\`\`\`cpp
<3-8 lines copied verbatim from real .cxx>
\`\`\`

**See also:** `<related symbol>`, `<related symbol>`

**Failure modes (architect-supplied):** <inline OR cross-ref to §5>
```

---

End of v0.1 pilot.
