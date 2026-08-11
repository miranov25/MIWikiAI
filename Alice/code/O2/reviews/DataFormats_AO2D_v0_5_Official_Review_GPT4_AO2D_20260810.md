# [GPT4:AO2D] [AO2DAI] [Reviewer] [DataFormats_AO2D_v0.5] [X]

# Official Review — `DataFormats_AO2D` v0.5 DRAFT

**Reviewer ID:** `GPT4:AO2D`  
**Team:** AO2DAI  
**Project:** MIWikiAI / AO2DAI  
**Canonical artifact reviewed:** `DataFormats_AO2D_v0_5.md`  
**Generated companion reviewed:** `DataFormats_AO2D_v0_5.html`  
**Canonical Markdown SHA-256:** `f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19`  
**Date:** 2026-08-10  
**Review stage:** AO2DAI source-semantic + standard/base-model + publication-structure review  
**Canonical verdict for final ratification:** **`[X] CHANGES REQUESTED`**  
**Use as the current DRAFT reviewer/coder baseline:** **APPROVED**  
**Proceed with focused source/file/ADF validation:** **APPROVED**  
**Architecture restart required:** **NO**

---

## 1. Executive Decision

`DataFormats_AO2D` v0.5 is a **major improvement** over v0.4.x and has the correct architecture.

The most important requested restructuring has been implemented correctly:

> **The standard/base `Framework/Core/include/Framework/AnalysisDataModel.h` model is now the primary concrete AO2D teaching spine, and LF V0/cascade is a downstream PWG worked example.**

That is the correct hierarchy for a document intended to become the single human-facing AO2DAI semantic reference for code writing.

The new standard-model content is technically strong. In particular, v0.5 correctly adds:

- BC/timestamp → collision → track topology;
- current-alias versus version distinction;
- a real counterexample proving that “current alias = highest numeric version” is unsafe;
- stored/extended/full-view separation;
- external versus self-index macro/naming distinctions;
- scalar/self-array/self-slice examples from the standard MC model;
- type-form and description/version-form index-equivalence declarations;
- `DECLARE_SOA_INDEX_TABLE*` as a first-class matching-table mechanism;
- `TracksQA = ...::iterator` as a real extractor entity-kind hazard;
- standard ambiguity, detector, MC, provenance and Run-2 compatibility orientation;
- an explicit standard/base physical fixture requirement;
- additional slicing fixtures for source-proven positional families, multi-partition identity and index tables.

I found **no P0 architecture or silent-corruption defect in the document**.

However, I do **not** approve final ratification yet. There are two source-of-truth issues that should be corrected before the document is frozen:

1. the generated registry's v0.5 ratifiable scope is still narrower than the document's claimed standard/base authoritative scope;
2. the two index-equivalence declaration forms should be represented more precisely in the generator/registry contract.

These are bounded corrections, not a redesign.

---

# 2. Source-Read Declaration

For this review I read the supplied v0.5 Markdown and HTML in full and source-checked the load-bearing new standard/base claims against current upstream source.

## AliceO2 — current `dev` source checked

- `Framework/Core/include/Framework/AnalysisDataModel.h`
- `Framework/Core/include/Framework/ASoA.h`
- `Framework/Core/src/ASoA.cxx`
- `Framework/Core/include/Framework/DataOutputDirector.h`
- `Framework/Core/src/DataOutputDirector.cxx`
- `Framework/Core/include/Framework/IndexBuilderHelpers.h`
- `Framework/Core/src/IndexBuilderHelpers.cxx`
- `Framework/AnalysisSupport/include/Framework/TableTreeHelpers.h`
- `Framework/AnalysisSupport/src/AODWriterHelpers.h`
- `Framework/AnalysisSupport/src/AODReaderHelpers.h`

## O2Physics — current `master` source checked

- `PWGLF/DataModel/LFStrangenessTables.h`

## Evidence boundary

The review above is a **current-upstream source check**, not commit certification.

The architect-selected immutable 40-character AliceO2/O2Physics reference commits remain pending in the artifact. Therefore:

- current-upstream semantic claims can be assessed for correctness now;
- mutable line locations are not frozen;
- the snapshot-labelled `[VERBATIM]` blocks are **not re-certified by this review** because the exact SHA-256 snapshot files themselves were not supplied in this v0.5 review package;
- the document correctly keeps source-pin and exact-byte verification as ratification gates.

This distinction must remain explicit.

---

# 3. Artifact / Publication Integrity

## 3.1 Canonical Markdown fingerprint — PASS

The actual SHA-256 of the supplied Markdown is:

```text
f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19
```

The supplied HTML reports the same canonical Markdown SHA-256 in both its header metadata and footer.

**Disposition:** PASS.

## 3.2 Markdown ↔ HTML structural consistency — PASS

Static inspection of the supplied HTML found:

- UTF-8 title renders `O²` correctly;
- no replacement-character / `O??` mojibake;
- 132 TOC links;
- 132 heading IDs;
- zero missing TOC targets;
- zero duplicate heading IDs;
- no Markdown heading-level jumps;
- code/table blocks are structurally present;
- the apparent `# Pseudocode only` line is correctly inside a code fence and is not emitted as a heading.

**Disposition:** PASS for structural generation.

A final rendered-browser visual inspection remains correctly assigned to MIWikiAI under §24.5. This AO2DAI review does not replace that publication gate.

---

# 4. Standard/Base AO2D Teaching Spine

## 4.1 Overall hierarchy — APPROVED

The v0.4.x concern is closed in the human narrative.

The document now teaches:

```text
standard/base AnalysisDataModel.h
        ↓
BCs / timestamps
        ↓
Collisions
        ↓
Tracks and companion views
        ↓
detector / MC / matching / provenance families
        ↓
PWG extension example: LF V0/cascade
```

This is much better for both humans and AI coders than beginning from the LF-specific model.

**Disposition:** APPROVED and must be preserved.

---

## 4.2 BC / timestamp / collision backbone — SOURCE-SUPPORTED

Current `AnalysisDataModel.h` contains:

- `BCs_000`;
- `BCs_001`;
- `using BCs = BCs_001`;
- `Timestamps`;
- `BCsWithTimestamps = soa::Join<aod::BCs, aod::Timestamps>`;
- `collision::BCId`;
- versioned Collisions and current collision alias.

The document's conceptual topology is correct.

**Disposition:** APPROVED, subject only to final commit pin.

---

## 4.3 Track backbone and stored/extended/full distinction — SOURCE-SUPPORTED

The current source supports the central distinction v0.5 is trying to teach:

- persistent/stored track-family identities;
- extended track/extra views;
- current aliases;
- convenience joins;
- expression/dynamic columns;
- collision relation;
- covariance / IU / QA companion families.

This is a strong standard example for the registry's `entity_kind` and physical-versus-logical identity rules.

**Disposition:** APPROVED.

---

## 4.4 `TracksQA` entity-kind hazard — SOURCE-SUPPORTED

Current source explicitly contains:

```cpp
using TracksQAVersion = TracksQA_003;
using TracksQA = TracksQAVersion::iterator;
```

Therefore this v0.5 rule is important and correct:

> alias spelling must not determine whether a symbol is a table, iterator, view or another entity.

The proposed `cpp_symbol`, `resolved_target`, `entity_kind` and `resolution_method` metadata are justified.

**Disposition:** APPROVED.

---

## 4.5 Current alias is not highest numeric version — SOURCE-SUPPORTED

Current source declares both `McCaloLabels_000` and `McCaloLabels_001`, but selects:

```cpp
using McCaloLabels = McCaloLabels_000;
```

This is an excellent counterexample and should remain prominent.

**Disposition:** APPROVED.

---

# 5. Relation Mechanisms

## 5.1 External scalar indices — APPROVED

The sign-based normal scalar applicability rule remains correct:

```text
value >= 0 → live/reference candidate
value < 0  → not dereferenced by normal scalar-index access
```

Preserving raw negative values as physical provenance while deriving logical applicability separately remains the correct AO2DAI policy.

**Disposition:** APPROVED.

---

## 5.2 External versus self-index naming — APPROVED

The current ASoA macro families support the important v0.5 distinction:

- external scalar uses label plus a separate suffix slot;
- external slice/array have their corresponding external label structures;
- self scalar/slice/array use self-specific label macro forms;
- short self forms do not use the external short-macro token-pasted target-type pattern.

This is exactly the sort of distinction a textual extractor must not flatten.

**Disposition:** APPROVED.

---

## 5.3 Self scalar / array / slice semantics — APPROVED

Current `AnalysisDataModel.h` provides standard MC examples of:

- scalar self mother/daughter indices;
- self-array `Mothers`;
- self-slice `Daughters`.

The old→new remapping rules in §19 are appropriately generalized to self relations.

**Disposition:** APPROVED.

---

# 6. Index Equivalence

## 6.1 Classic/type-form declarations — CONTENT APPROVED

The LF V0/cascade eight-pair set remains a valid worked example of classic `DECLARE_EQUIVALENT_FOR_INDEX(...)` use.

The document is also correct that index equivalence does not create a positional join.

**Disposition:** APPROVED.

---

## 6.2 `_NG` declarations — CONTENT APPROVED

Current standard source contains 14 `DECLARE_EQUIVALENT_FOR_INDEX_NG(...)` declarations.

The document correctly highlights that these are not all merely “same family, different numeric version”. For example:

```text
TRACK/0 ↔ TRACK_IU/0
```

is a compatibility statement across differently described table forms.

**Disposition:** APPROVED.

---

## P1-1 — Registry must distinguish declaration form from resolved equivalence key

This is the main source-model precision issue I found.

The document currently proposes:

```text
key_form: cpp_type | description_version
```

This is useful as a description of **how the equivalence was declared**, but current `ASoA.h` implements both macros through the same `EquivalentIndexNG` mechanism:

- `DECLARE_EQUIVALENT_FOR_INDEX(Base, Equiv)` takes C++ table types at the call site and resolves their `ref.desc_hash`;
- `DECLARE_EQUIVALENT_FOR_INDEX_NG("DESC/0", "DESC/1")` hashes explicit description/version strings.

Thus `cpp_type` and `description_version` are two **declaration/input forms**, not necessarily two independent semantic equivalence engines.

### Risk

An AI coder can read `key_form` as the runtime/semantic equivalence key and implement two incompatible registries:

```text
type-identity equivalence graph
versus
description/version equivalence graph
```

when the current framework ultimately compares equivalent description hashes.

### Required correction

Prefer:

```text
relation_kind: index_equivalence
declaration_form: cpp_type | description_version
left_declared_key
right_declared_key
resolved_left_description
resolved_right_description
resolved_left_desc_hash
resolved_right_desc_hash
source_macro
source_identity
validation_status
```

or an equivalent schema that clearly separates:

```text
source declaration syntax
        from
resolved framework equivalence identity
```

The exact field names are not mandatory; the distinction is.

### Acceptance

At the pinned source commit:

1. generated classic and `_NG` equivalences resolve to the same framework compatibility semantics;
2. source declaration provenance remains recoverable;
3. no code path assumes that `cpp_type` is itself the ultimate persistent equivalence key.

**Severity:** P1 because this is code-generation metadata in the authoritative registry contract.

---

# 7. `DECLARE_SOA_INDEX_TABLE*`

## 7.1 First-class treatment — APPROVED

Current `AnalysisDataModel.h` contains eleven matching/index tables in the standard `indices` section, including:

- exclusive variants;
- sparse variants;
- BC/collision/detector combinations;
- a multi-collision array variant.

The document is correct that this is a distinct table mechanism and should not be flattened into the ordinary scalar/slice/array/self relation-column enumeration.

The new `entity_kind: index_table` registry concept is appropriate.

**Disposition:** APPROVED.

---

# 8. Join / Concat Semantics

## 8.1 Join evidence separation — APPROVED

Current ASoA contains:

- a row-count rejection path using `canNotJoin()`;
- `ArrowTableRef` paths using `IncompatibleRanges()`.

v0.5 correctly keeps the old snapshot evidence and current-upstream evidence separate until the architect chooses the source commit.

Semantic membership still comes from source declarations/producer evidence, not from runtime compatibility.

**Disposition:** APPROVED.

---

## 8.2 `soa::Concat` — APPROVED

Current implementation constructs common fields using repeated set intersection.

The document correctly warns that `Concat` is not union-of-columns semantics.

**Disposition:** APPROVED.

---

# 9. Standard Detector / MC / Ambiguity Content

## 9.1 AmbiguousTracks — APPROVED

The standard source explicitly documents tracks with no unique collision association and stores compatible BCs via a slice relation.

This is a good standard-model precedent for two reasons:

- slice semantics are core AO2D semantics, not LF-specific;
- unexplained negative scalar indices must trigger source/auxiliary-table investigation rather than invented numeric semantics.

**Disposition:** APPROVED.

---

## 9.2 MC backbone — APPROVED

The standard MC model is a strong teaching example because it combines:

- external MC-collision relation;
- scalar self relations;
- self array;
- self slice;
- reconstructed-to-MC label tables;
- derived particle quantities.

**Disposition:** APPROVED.

---

## P2-1 — Qualify FV0C as Run-2 compatibility content

Section 10.5 lists “FV0 A/C” together as representative standard detector families.

Current source explicitly marks `FV0C` as:

```text
Only for RUN 2 converted data
```

while FV0A is the normal standard table family.

The section is not factually wrong because §10.9 separately discusses Run-2 compatibility, but the standard/base teaching spine would be clearer if §10.5 says, for example:

```text
FV0A; FV0C for Run-2 converted data
```

**Severity:** P2 precision/readability.

---

# 10. Physical I/O and Source Inventory

The current-upstream paths listed in §14.1 are consistent with the source inventory checked in this review, including:

- `DataOutputDirector`;
- `TableTreeHelpers`;
- `AODWriterHelpers`;
- `AODReaderHelpers`;
- `IndexBuilderHelpers`.

`DataOutputDirector.cxx` supports the documented direction that default physical tree naming is built from `O2` + lower-cased table description plus a zero-padded positive version suffix.

**Disposition:** APPROVED as current-upstream evidence; final paths and behavior remain commit-pinning work.

---

# 11. Generated Registry Scope

## P1-2 — v0.5 final registry scope is still too narrow for the claimed standard/base authority

This is the most important scope issue remaining.

The human narrative now correctly says that the standard/base `AnalysisDataModel.h` model is the primary AO2D teaching spine.

However §15.1 and §20 require `DataFormats_AO2D.json` to cover:

> every **normative worked example** in the standard/base section,

rather than requiring complete generated coverage of the pinned standard/base model.

That is weaker than the source-of-truth goal and weaker than the conclusion of the v0.4.1 review.

### Why it matters

The document is meant to initialize coders for **AO2D code writing**, not only for the examples chosen in the prose.

A standard table omitted from the hand-picked narrative is still a standard AO2D table. If the generated code-driving registry is allowed to omit it while the human document is ratified as the authoritative AO2D reference, a coder can legitimately encounter a base AO2D table for which the supposed source of truth has no record.

The correct split is:

```text
human Markdown:
    family-level explanation, selected worked examples

generated registry:
    exhaustive standard/base source inventory at the pinned AnalysisDataModel.h commit
```

There is no need to hand-write every column into the Markdown.

### Required correction

For v0.5 final ratification, require generated coverage of the complete **standard/base `AnalysisDataModel.h` declaration inventory**, including at minimum:

- all declared persisted table/version identities;
- current aliases;
- stored/extended/view entity relationships;
- persistent column names/types;
- ordinary external indices;
- self scalar/slice/array indices;
- both equivalence declaration forms;
- all `DECLARE_SOA_INDEX_TABLE*` instances;
- source-declared joins/concats relevant to the standard model;
- source identity/location;
- validation/reconciliation status.

Dynamic/expression columns can be indexed as declarations/dependencies without requiring Python ports for all of them.

The LF/O2Physics registry may remain bounded to the V0/cascade scope for v0.5.

### Acceptance

A generator run on the pinned `AnalysisDataModel.h` produces a complete source inventory with no silently omitted standard table/relation mechanism, and the document's worked examples are verified as views into that generated inventory.

**Severity:** P1 for final ratification; not a blocker to using v0.5 as the current DRAFT.

---

# 12. Slicing Contract

The v0.5 slicing section is stronger than v0.4.x.

In particular, I approve the explicit fixture additions for:

- source-proven positional-family shared mask/order;
- unresolved positional candidate union-mask behavior;
- scalar self remapping;
- self-array remapping;
- multi-partition collision prevention;
- index-table handling.

The document correctly retains:

- fixed-point dependency closure;
- post-compaction old→new remapping;
- fail-loudly behavior for unresolved live positive references;
- slice contiguity constraints;
- exact row/remap manifests.

**Disposition:** APPROVED as the test contract. Execution remains a ratification gate.

---

# 13. ADF Boundary

The responsibility boundary remains correct:

- AO2DAI resolves O² semantics;
- ADF validates its own public API / adapter behavior;
- ADF is not allowed to infer O² semantics from names.

The executable relation call remains intentionally unfrozen and fabricated/pseudocode.

**Disposition:** APPROVED; ADF validation remains open by design.

---

# 14. P0 / P1 / P2 Summary

## P0

**None.**

## P1 — required before final ratification

### P1-1
Clarify equivalence registry semantics: declaration form (`cpp_type` vs explicit description/version) must be separate from the resolved framework equivalence key / description hash.

### P1-2
Make generated `DataFormats_AO2D.json` exhaustive for the pinned **standard/base `AnalysisDataModel.h` inventory**, while keeping the Markdown human-readable and the O2Physics scope bounded to LF V0/cascade.

## P2

### P2-1
Qualify `FV0C` in §10.5 as Run-2 converted/compatibility content.

No P2 item requires broad re-review.

---

# 15. Ratification Gates Correctly Still Open

The document itself correctly keeps the following open:

1. architect-selected 40-character AliceO2 source commit;
2. architect-selected 40-character O2Physics source commit;
3. canonical source bytes/fingerprints;
4. exact `[VERBATIM]` byte verification;
5. generated canonical registry;
6. standard/base AO2D fixture;
7. LF pilot file fingerprint/reconciliation;
8. producer/task positional closure;
9. execution of all slicing/remapping fixtures;
10. pinned ADF source/public API;
11. ADF oracle/integration validation;
12. MIWikiAI rendered publication inspection.

These are genuine gates, not defects in the DRAFT.

P1-1 and P1-2 above are different: they are corrections to **what the generated evidence model must mean/cover** before those gates can close.

---

# 16. Suitability Assessment

| Intended use | Decision |
|---|---|
| Human AO2D introduction | **APPROVED** |
| Standard/base AO2D teaching spine | **APPROVED** |
| AO2DAI reviewer initialization | **APPROVED as DRAFT** |
| AO2DAI coder initialization | **APPROVED as DRAFT** |
| C++ → Python / ADF brainstorming | **APPROVED** |
| Basis for registry/loader/slicer implementation | **APPROVED with P1 corrections above** |
| Focused AO2DAI / ADF validation dispatch | **APPROVED** |
| Final authoritative source-of-truth ratification | **CHANGES REQUESTED / NOT YET** |

---

# 17. Ownership Decision

The ownership model in v0.5 is correct and should remain:

## AO2DAI

Owns substantive source/registry evolution:

- AliceO2/O2Physics semantics;
- standard/base coverage;
- source extractor / compiler resolver;
- physical source→ROOT mapping;
- source/file reconciliation;
- producer/task closure;
- slicing/remapping;
- generated registry.

## ADF

Owns only the ADF-facing integration surface:

- pinned ADF version;
- public relation/subframe API;
- normalized-key behavior;
- adapter provenance/dtype/partition preservation;
- executable ADF oracle tests.

## MIWikiAI

Retains formal/publication responsibility:

- document class/front matter;
- provenance grammar;
- source identity/fingerprint discipline;
- Markdown/HTML generation and publication;
- final rendered navigation/encoding checks.

This division is appropriate.

---

# 18. Final Verdict

## `[X] CHANGES REQUESTED` before final ratification

This verdict does **not** reject v0.5.

It means:

- **Architecture:** APPROVED.
- **Standard/base teaching-spine restructure:** APPROVED.
- **New source semantics:** APPROVED in substance.
- **Use as current DRAFT baseline:** APPROVED.
- **Proceed to focused validation and implementation:** APPROVED.
- **Architecture restart:** NOT REQUIRED.
- **Final freeze:** wait for P1-1, P1-2 and the already-declared §24 evidence gates.

The most important direction is now correct:

> **Human prose teaches the standard/base AO2D architecture first; generated source evidence should make the complete pinned standard data model executable; LF V0/cascade remains the specialized downstream stress test.**

No broad rewrite is needed. Apply the two bounded P1 corrections to the registry contract, then continue with source pinning, generated-registry production, physical fixtures, slicing execution and ADF validation.

---

# 19. Reviewer Signal Summary

| Reviewer | Signal | Assessment |
|---|---|---|
| `GPT4:AO2D` | Direct source-read of standard-model additions; registry/generator semantics; Markdown↔HTML integrity; AO2DAI handoff scope | **High-value source/code-writing review** |

**Reviewer health:** no issue observed.

---

**Signed:** `GPT4:AO2D`  
**Team:** AO2DAI  
**Date:** 2026-08-10  
**Verdict:** `[X] CHANGES REQUESTED before ratification; DRAFT/validation use approved`
