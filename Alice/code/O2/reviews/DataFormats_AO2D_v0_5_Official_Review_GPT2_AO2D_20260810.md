[GPT2:AO2D] [AO2DAI] [Reviewer] [DataFormats_AO2D_v0.5] [!]

# Official Review — `DataFormats_AO2D` v0.5 DRAFT

**Reviewer:** `GPT2:AO2D`  
**Project:** AO2DAI / MIWikiAI  
**Artifact:** `DataFormats_AO2D_v0_5.md` + generated HTML companion  
**Canonical Markdown SHA-256:** `f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19`  
**Generated HTML SHA-256:** `41aea8de7322e82569d5a33384ef5665b5a6cbec7078614d35b31319afea1180`  
**Canonical Markdown size:** 59,350 bytes / 1,588 lines  
**Date:** 2026-08-10  
**Review type:** AO2DAI source-semantic / architecture / registry-contract review  
**Verdict:** **`[!] APPROVED_WITH_COMMENTS`**  
**Architecture:** **APPROVED**  
**Standard/base-model-first restructuring:** **APPROVED**  
**AO2DAI technical ownership:** **APPROVED**  
**ADF ownership boundary:** **APPROVED**  
**Final ratification/freeze:** **NOT YET — §24 evidence gates remain open**  
**Architecture restart required:** **NO**

---

## 1. Executive decision

`DataFormats_AO2D` v0.5 is a substantial improvement and is the correct first AO2DAI-authored semantic expansion after the v0.4.x documentation stabilization.

The central restructuring is approved:

> **`Framework/Core/include/Framework/AnalysisDataModel.h` is now the primary concrete teaching spine, and LF V0/cascade is correctly repositioned as a downstream O2Physics worked example/stress test.**

This directly addresses the earlier panel concern that the generic AO2D reference was teaching special LF formats before the standard BC/collision/track/MC/index machinery on which the extensions depend.

The new standard-model material is technically useful and, in the current upstream source read performed for this review, is supported in all high-risk areas checked:

- BC/collision/track versioning and current aliases;
- the `McCaloLabels` counterexample to “highest numeric version = current alias”;
- `TracksQA` resolving to an iterator;
- scalar/self-array/self-slice MC relations;
- description/version-keyed `_NG` index equivalence;
- standard `DECLARE_SOA_INDEX_TABLE*` matching tables;
- separate join compatibility paths;
- `soa::Concat` common/intersection-schema behavior;
- output tree/version naming infrastructure.

There is **no P0** and no reason to redesign or split the document.

I do, however, identify two closely related **P1 code-driving registry-schema corrections** around `DECLARE_SOA_INDEX_TABLE*`, plus one **P1 ratification-scope correction** for the standard registry. These should be fixed before the generated registry becomes implementation authority. They do not invalidate the v0.5 DRAFT architecture.

---

## 2. Source-Read declaration

**Source-Read: AO2DAI source-semantic review.**

I read the complete canonical Markdown and supplied HTML companion.

I also directly inspected the official current upstream AliceO2/O2Physics source relevant to the new v0.5 claims:

### AliceO2 current `dev`

- `Framework/Core/include/Framework/AnalysisDataModel.h`
  - BC/collision/track backbone;
  - version/current-alias patterns;
  - `McCaloLabels` alias counterexample;
  - `TracksQA` alias-to-iterator pattern;
  - MC scalar/self-array/self-slice indices;
  - `_NG` index-equivalence declarations;
  - standard `indices` namespace and `DECLARE_SOA_INDEX_TABLE*` declarations;
  - `Origins::DataframeID`.
- `Framework/Core/include/Framework/ASoA.h`
  - external/self index macro families;
  - self scalar/slice/array label rules;
  - `DECLARE_SOA_INDEX_TABLE_NG` / exclusive metadata.
- `Framework/Core/src/ASoA.cxx`
  - row-count and range-compatible join paths;
  - `soa::Concat` schema intersection.
- `Framework/Core/include/Framework/IndexBuilderHelpers.h`
- `Framework/Core/src/IndexBuilderHelpers.cxx`
- `Framework/Core/include/Framework/DataOutputDirector.h`
- `Framework/Core/src/DataOutputDirector.cxx`
- `Framework/AnalysisSupport/include/Framework/TableTreeHelpers.h`
- `Framework/AnalysisSupport/src/AODWriterHelpers.h`

### O2Physics current `master`

- `PWGLF/DataModel/LFStrangenessTables.h`
  - current V0/cascade joins and the eight LF index-equivalence pairs.

### Evidence qualification

These current `dev` / `master` reads are **not** the final ratification source identities. v0.5 correctly keeps the architect-selected 40-character AliceO2 and O2Physics commits pending. I therefore use these reads to review current-source correctness and architecture, not to certify final commit-pinned line numbers or historical snapshot provenance.

I do **not** independently certify the historical `[VERBATIM]` blocks here because the exact historical snapshot bytes are a declared §24.5/§24.2 gate.

---

# 3. Artifact and publication checks

## 3.1 Canonical Markdown identity — PASS

The supplied canonical Markdown hashes to:

```text
f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19
```

The generated HTML identifies the same Markdown SHA-256 in its header/footer.

## 3.2 Front matter — PASS

The YAML front matter is structurally valid and clearly states:

- version `v0.5`;
- technical owner = AO2DAI;
- formal/publication owner = MIWikiAI;
- ADF integration owner = ADF;
- explicit pending source/file/registry/ADF/publication gates.

## 3.3 Version-marker consistency — PASS

The active artifact is consistently identified as `v0.5`. References to v0.4.2/v0.4.x/v0.2 are historical/revision-basis references rather than current-artifact marker leakage.

## 3.4 HTML structural consistency — PASS

The supplied HTML:

- uses a correct UTF-8 `O²` title;
- carries the correct canonical Markdown hash;
- contains a generated TOC;
- has internally resolving TOC/section anchors in the structural check;
- preserves the standard-model-first section order.

Final rendered visual inspection remains correctly assigned to the MIWikiAI publication gate.

---

# 4. Closure of the v0.4.2 → v0.5 handoff

| v0.4.2 next-work item | v0.5 status | GPT2 decision |
|---|---|---|
| Make standard/base `AnalysisDataModel.h` primary | §10 is now the main concrete teaching spine before LF | **CLOSED** |
| Keep LF as specialized worked example | §§11–12 follow standard model | **CLOSED** |
| Current alias ≠ highest version | `McCaloLabels` counterexample added | **CLOSED** |
| Self-index semantics | external/self naming separated; standard MC self examples added | **CLOSED** |
| `_NG` equivalence | §5.8 distinguishes description/version keyed compatibility and non-version-only edges | **CLOSED** |
| Index tables | §5.9 makes them first class | **CLOSED IN CONCEPT; P1 registry-schema correction below** |
| `TracksQA` extractor hazard | `entity_kind` resolution rule added | **CLOSED** |
| Join evidence bases | snapshot row-count and current range paths remain separated | **CLOSED** |
| Standard/base fixture | explicit §14.4 / §18.4 / §24.3 requirement | **CLOSED AS SPECIFICATION; EXECUTION PENDING** |
| Stronger slicing fixtures | §19.7 expanded to 11 fixtures incl. positional family, partitions and index table | **CLOSED AS SPECIFICATION; EXECUTION PENDING** |
| Generated registry broadened to standard + LF worked scope | §15 / §20 expanded | **PARTIALLY CLOSED; P1-3 below** |

---

# 5. P0 findings

**None.**

I found no defect that invalidates the semantic architecture or makes the document unsafe as a DRAFT review/coding reference.

---

# 6. P1 findings — required before registry freeze / ratification

## P1-1 — `DECLARE_SOA_INDEX_TABLE*` generic mode is modeled too narrowly as `exclusive | sparse`

### Location

- §5.9 proposed record:
  ```text
  index_table_mode: exclusive | sparse
  ```
- §15.6:
  ```text
  mode: exclusive | sparse
  ```

### Source evidence

The generic ASoA source mechanism carries an **`exclusive` boolean/property** in `DECLARE_SOA_INDEX_TABLE_NG`. The ordinary macro creates a non-exclusive table; the `_EXCLUSIVE` macro creates an exclusive one.

In the current standard `AnalysisDataModel.h`, many concrete non-exclusive tables happen to have names containing `Sparse`, but “sparse” is not the generic framework property paired with `exclusive`.

### Impact

A code-driving registry that encodes:

```text
mode = sparse
```

as the inverse of `exclusive` risks promoting a naming convention from current standard examples into generic ASoA semantics.

This is the exact class of over-generalization the document otherwise warns against.

### Required correction

Prefer one of:

```text
exclusive: true | false
```

or:

```text
mode: exclusive | nonexclusive
```

Then, if a particular source declaration/table has independently established sparse semantics, record that separately, e.g.:

```text
semantic_variant: sparse | multi | other
```

or preserve the source symbol/declaration without inventing a generic enum.

**Severity:** P1 because this field is intended to drive generated registry/code behavior.

---

## P1-2 — `index_table` is simultaneously treated as a table-level entity and an ordinary relation/index kind

### Location

§5.9 correctly states:

> do not force an index table into the ordinary relation-column enumeration.

§15.6 then defines:

```text
entity_kind: index_table
```

which is correct.

But §15.5 also includes:

```text
relation_kind:
...
index_table
```

inside the ordinary relation/index record taxonomy.

### Impact

This creates an internal schema ambiguity:

- is an index table itself a table/entity?
- or is it a relation column kind?

In ASoA it is a generated matching table built from a key table and index columns. Its constituent index columns have their own relation kinds.

### Required correction

Remove `index_table` from the ordinary index-column `relation_kind` enumeration.

Keep:

```text
entity_kind: index_table
```

in its dedicated record.

If the registry needs explicit graph edges around an index table, define them separately, for example:

```text
index_table_key_relation
index_table_member_index
index_table_consumer_join
```

rather than overloading the relation-column type.

**Severity:** P1 because an ambiguous canonical schema will propagate directly into the loader and generator.

---

## P1-3 — Final standard/base registry scope should be complete for the pinned `AnalysisDataModel.h`, not only complete for selected worked examples

### Location

§15.1 and §20 require the generated registry to be complete for:

- normative standard/base worked examples;
- relation mechanisms;
- LF worked examples;
- slicing rules.

That is a major improvement, but it is still weaker than the role claimed by the artifact:

> single authoritative AO2DAI semantic reference for AO2D code writing.

### Reason

The user/architect explicitly elevated the standard/basic data formats above LF-specific formats. v0.5 correctly makes `AnalysisDataModel.h` the teaching spine. For the **generated code-driving registry**, selective worked-example coverage is not enough to make the standard AO2D model authoritative.

The human prose should remain selective. The generated standard registry should not.

### Required ratification scope

For the pinned `AnalysisDataModel.h`, require complete generated coverage of at least:

- table declarations and versions;
- current/source aliases and resolved entity kinds;
- persistent columns and exact types;
- expression/dynamic column inventory metadata;
- ordinary external and self indices;
- slice/array/self variants;
- index tables;
- classic and `_NG` equivalence declarations;
- declared joins/concats;
- stored/extended/view relationships.

O2Physics can remain bounded to the selected LF/V0/cascade scope for v0.5.

Recommended top-level registry split:

```text
standard_aod
o2physics_extensions
```

with `standard_aod` complete for the pinned standard header.

**Severity:** P1 for final ratification/freeze, but **not** a blocker to approving the v0.5 DRAFT or beginning implementation.

---

# 7. P2 / advisory improvements

## P2-1 — Make the two registry namespaces explicit

The prose already separates standard/base from PWG extensions. Reflect that directly in the generated registry:

```text
standard_aod
o2physics_extensions
```

This will make ownership, completeness and future all-PWG expansion clearer.

## P2-2 — Promote the physical tree naming rule after source pinning

Current `DataOutputDirector.cxx` provides a concrete default tree-name/version rule. Once the AliceO2 commit is fixed, §9.2 should record the exact pinned rule rather than leaving it only as a future writer/output mapping task.

## P2-3 — Keep `[VERBATIM]` snapshot certification separate

The current historical snapshot labels are appropriately marked as snapshot-exact and commit reconciliation pending. Do not convert current-upstream line positions into replacements until the architect selects the source baseline and exact bytes are mechanically compared.

## P2-4 — Retain LF as a stress test, not a secondary authority

The new order is correct. LF is still unusually valuable because it exercises multiple relation/view mechanisms and real derived-file behavior. Keep it as the first PWG stress-test after the standard spine.

---

# 8. Source-semantic validation matrix

| v0.5 claim / mechanism | Current-source review result |
|---|---|
| BC versions/current alias | **PASS** |
| Collision→BC relation | **PASS** |
| Track→Collision relation | **PASS** |
| Stored/extended/full TrackExtra distinction | **PASS** |
| `McCaloLabels` current alias can select lower numeric version | **PASS** |
| `TracksQA` plural alias resolves to iterator | **PASS** |
| Scalar self + self-array + self-slice examples | **PASS** |
| `_NG` equivalence includes non-version-only compatibility such as TRACK↔TRACK_IU | **PASS** |
| Standard model contains 11 `DECLARE_SOA_INDEX_TABLE*` declarations | **PASS** |
| Index-table source mechanism carries generic `exclusive` property | **PASS — leads to P1-1** |
| Join has multiple compatibility paths in current source | **PASS** |
| Concat derives common/intersection schema | **PASS** |
| `Origins::DataframeID` relates to DF directory identity | **PASS** |
| LF V0/cascade current source still contains corresponding join/equivalence concepts | **PASS** |
| Historical snapshot-exact VERBATIM | **NOT RE-CERTIFIED HERE — gate remains correctly open** |

---

# 9. Human / AI / coder suitability

## Human readability — PASS

v0.5 is materially easier to understand than the LF-first versions because it now teaches:

```text
BC
↓
Collision
↓
Track
↓
detector / MC / matching
↓
PWG extensions
```

before the V0/cascade details.

The document remains long, but the reader paths and generated-registry split make the length defensible for a source-of-truth candidate.

## AI reviewer initialization — PASS

The anti-heuristic invariants are strong, and v0.5 adds several realistic parser traps:

- current alias is not “highest version”;
- plural name is not necessarily a table;
- self-index macro family differs from external indices;
- index tables are not ordinary relation columns;
- equal rows remain discovery evidence only.

These are exactly the kinds of errors an AI/code generator would otherwise make plausibly and silently.

## AO2DAI coder initialization — PASS AS DRAFT

The architecture is sufficiently explicit to begin generator/registry implementation, **provided P1-1 and P1-2 are corrected before freezing the registry schema**.

---

# 10. Ownership decision

The v0.5 ownership split is correct:

### AO2DAI

Owns:

- source semantics;
- standard/base registry;
- O2Physics bounded extension registry;
- physical reconciliation;
- producer/task closure;
- slicing/remapping;
- code-driving registry.

### ADF

Owns only:

- selected ADF version/API;
- relation/subframe behavior;
- normalized-key adapter;
- dtype/partition/provenance preservation;
- executable integration/oracle checks.

### MIWikiAI

Owns:

- front matter/document class;
- provenance/verbatim grammar;
- canonical-byte/publication checks;
- Markdown/HTML generation and inspection;
- readability/navigation.

No ownership change is needed.

---

# 11. Ratification gates

This review **does not waive** the explicit §24 gates.

Before final freeze:

1. architect-selected 40-character AliceO2 commit;
2. architect-selected 40-character O2Physics commit;
3. exact source-byte/fingerprint reconciliation;
4. historical `[VERBATIM]` byte verification;
5. complete standard/base generated registry for pinned `AnalysisDataModel.h` per P1-3;
6. bounded LF/O2Physics registry;
7. representative standard/base AO2D fixture;
8. fingerprinted LF pilot reconciliation;
9. producer/task positional closure;
10. all §19.7 slicing/remapping fixtures executed;
11. P1-1/P1-2 registry taxonomy corrections;
12. ADF public-API/integration validation;
13. MIWikiAI final Markdown/HTML/publication validation.

---

# 12. Final verdict

## `[!] APPROVED_WITH_COMMENTS`

**`DataFormats_AO2D` v0.5 DRAFT:** **APPROVED**

**Standard/base-model-first architecture:** **APPROVED**

**Source-semantic direction:** **APPROVED**

**LF repositioning as PWG worked example:** **APPROVED**

**AO2DAI substantive ownership:** **APPROVED**

**ADF ownership boundary:** **APPROVED**

**MIWikiAI formal/publication ownership:** **APPROVED**

**P0 blockers:** **0**

**Required before registry freeze:** **P1-1 and P1-2**

**Required before final ratification:** **P1-3 + explicit §24 evidence gates**

**Architecture rewrite / broad panel:** **NOT REQUIRED**

**Recommended next action:** correct the index-table registry taxonomy, pin the standard source baseline, generate the complete `standard_aod` registry and bounded LF extension registry, then execute physical/slicing/ADF validation.

**Reviewer:** `GPT2:AO2D`  
**Date:** 2026-08-10
