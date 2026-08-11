[GPT1] [MIWikiAI] [Reviewer] [DataFormats_AO2D_v0.5.1] [OK]

# [GPT1] Official Review — `DataFormats_AO2D` v0.5.1

**Reviewer:** GPT1  
**Team:** MIWikiAI  
**Project:** MIWikiAI / AO2DAI  
**Artifact:** `DataFormats_AO2D_v0_5_1.md`  
**Artifact fingerprint reviewed:** SHA-256 `cde55f12047363328611adc6ac2c7c90fb65698c037e153e396d001bfa99cd7e`; MD5 `4099c40c9b0299364169b3c0148b6990`; 1734 lines  
**Date:** 2026-08-10  
**Verdict:** **[OK] APPROVED as the v0.5.1 DRAFT closure candidate**  
**Final ratification:** **PENDING by design** — source pins, generated `standard_aod` registry evidence, physical-file reconciliation, fixture execution, final ADF pin/oracles, and MIWikiAI publication validation remain explicit §24 gates.

**Source-Read:** This is not a documentation-only review. For the v0.5.1 closure claims I directly inspected the current public AliceO2 source surfaces relevant to F-1/F-3/F-5, including `Framework/Core/include/Framework/AnalysisDataModel.h` and `Framework/Core/include/Framework/ASoA.h`, and rechecked the current O2Physics V0/cascade source surface in `PWGLF/DataModel/LFStrangenessTables.h`. I also cross-checked the ADF asymmetric-key/public-API claim against the supplied ADF technical/source-review evidence for candidate bundle SHA-256 `27c190153090115e9b3e8cc26a616382702c7611f9ca84c9a67547f3885c4147`, including the recorded `right_index_columns` implementation history. Mutable AliceO2 `dev` / O2Physics `master` and the candidate ADF checkpoint are supporting review evidence only; they do not replace the still-pending architect-selected ratification pins.

---

## [GPT1] 1. Executive decision

I approve `DataFormats_AO2D` v0.5.1 as the current **DRAFT authoritative-human-semantic-reference candidate**.

The v0.5 consolidated review required one bounded closure revision for five finding groups. v0.5.1 implements those groups without reopening the approved architecture:

1. **F-1:** default AliceO2 V0/cascade/3-body layer added before the O2Physics/LF extension layer;
2. **F-2:** standard/base table coverage strengthened with a compact family map and an explicit exhaustive generated `standard_aod` obligation;
3. **F-3:** registry taxonomy corrected for `_NG` equivalence, alias/entity resolution and index tables;
4. **F-4:** ADF section corrected to the actual public asymmetric-key API shape and to the correct representation of `soa::Join`;
5. **F-5:** parser/extractor and fixture hazards added.

I find **no P0 and no P1 requiring another semantic/documentation revision before the focused closure gate**.

The remaining work named in §24 is genuine validation/execution work, not hidden incompleteness.

---

## [GPT1] 2. F-1 — standard/default O2 V0/cascade layer — PASS

v0.5.1 now teaches the two layers explicitly:

```text
AliceO2 / AnalysisDataModel.h
    aod::V0s, aod::Cascades, Decay3Bodys, tracked variants
          ↑ base/default objects
O2Physics / LFStrangenessTables.h
    V0Indices + V0TrackXs + V0Cores -> V0Datas
    CascIndices + CascBBs + CascCores -> CascDatas
```

This is the correct conceptual ordering.

Current `AnalysisDataModel.h` supports the new standard-layer statements:

- `V0s = V0s_002`;
- `Cascades = Cascades_001`;
- `Decay3Bodys`;
- `TrackedV0s`;
- `TrackedCascades`;
- `Tracked3Bodys`.

It also contains the standard cascade relation from `Cascades` to `V0s` plus bachelor-track/collision structure.

The new warning that `aod::V0s` and LF `V0Datas` are **not synonyms** is load-bearing and should remain.

**Disposition:** F-1 CLOSED in-document; commit-pinned revalidation remains §24 work.

---

## [GPT1] 3. F-2 — overview/inventory sufficiency — PASS for DRAFT

v0.5.1 resolves the previous disagreement correctly by separating human teaching from generated exhaustive evidence.

The document now provides a compact standard-family map covering:

- BC/event;
- collisions;
- tracks;
- ambiguity;
- detectors/forward;
- standard strangeness;
- Monte Carlo;
- matching/index tables;
- provenance/Run-2 compatibility.

It also states that the reviewed 82-symbol census is evidence to reproduce, **not a hand-written constant**, and requires:

> `standard_aod` — exhaustive for the complete pinned `AnalysisDataModel.h` source identity.

That is the correct architecture.

The exact reviewer-delivered 82-row appendix is honestly declared unavailable in this drafting workspace. v0.5.1 does not fabricate it. Instead, §24 requires the generated inventory to be attached and mechanically reconciled.

**Disposition:** F-2 CLOSED as a documentation/schema contract; generated inventory remains a ratification artifact.

---

## [GPT1] 4. F-3 — registry-schema precision — PASS

The v0.5.1 corrections are technically appropriate.

### [GPT1] 4.1 `_NG` equivalence key model

The registry now separates:

```text
declaration_form: classic_cpp_type | ng_string_key
key_form: cpp_type | description_version | label_version
left_declared / right_declared
left_resolved_key / right_resolved_key
key_case_policy: byte_exact
```

This addresses the `MFTTracks/0 ↔ MFTTracks/1` exception, where the source string is label-oriented rather than recoverable by assuming a physical description string.

Current ASoA defines `_NG` equivalence directly from literal source hashes, so preserving the literal key byte-for-byte is the safe rule.

### [GPT1] 4.2 Index-table taxonomy

v0.5.1 correctly removes `index_table` from ordinary relation-column kinds.

Current ASoA defines index tables as generated **entities/tables** with metadata including:

```text
exclusive: bool
Key
index_pack_t
```

and the ordinary/exclusive macros expand the boolean to `false` / `true`.

The current standard model contains the named Run-2/Run-3 matching/index tables.

The new record:

```text
entity_kind: index_table
exclusive: true | false
...
```

is therefore the correct registry shape.

### [GPT1] 4.3 Alias/entity resolution

The registry keeps `declared_target_text`, `resolved_target`, `entity_kind`, `alias_resolution`, and `resolution_method` separately.

That preserves the earlier `TracksQA` lesson and adds the self-alias cycle guard.

**Disposition:** F-3 CLOSED in the document design.

---

## [GPT1] 5. F-4 — ADF integration corrections — PASS for DRAFT

The v0.5.1 ADF section is materially better than the earlier pseudocode.

The candidate ADF evidence supports the public eager API shape:

```python
parent.register_subframe(
    "Child",
    child,
    index_columns=[...],
    right_index_columns=[...],
)
```

and the implementation history explicitly records `right_index_columns` as asymmetric parent/child join-key support.

v0.5.1 correctly draws three important conclusions:

1. **asymmetric key names are natively representable by the reviewed eager public API**;
2. a symmetric normalized key is therefore an **AO2DAI adapter choice**, not an ADF requirement;
3. a source-declared `soa::Join` should become **one row-aligned logical frame/view**, not be represented by `register_subframe` between its positional members.

The capability matrix is also appropriate: final acceptance requires oracles for `eval`, draw expressions, `selection=`, `group_by=` and `facet_by=` at the selected ADF pin.

**Disposition:** F-4 CLOSED as the documented integration contract; final ADF execution/oracles remain correctly gated.

---

## [GPT1] 6. F-5 — parser/extractor and fixture hazards — PASS

v0.5.1 incorporates the important bounded hazards from the v0.5 review:

- `Decay3Bodys` self-alias → cycle guard / explicit `self_alias`;
- source spelling/case preserved (`Run2OTFV0`, `MFTTracks`);
- `INDEX_LIST_*` macro indirection → compiler-resolution candidate when text extraction cannot prove expansion;
- source/file physical dtype kept separate from optional Python/ADF user conversion;
- `_FULL` / `_FULL_VERSIONED` macro argument-order hazard explicitly named;
- two independent extraction routes required to agree or fail closed.

These are exactly the classes of issue a code-generating registry must make explicit.

**Disposition:** F-5 CLOSED in the documentation contract.

---

## [GPT1] 7. Current-source spot checks — PASS

The source-read performed for this review supports the new standard-model statements used by v0.5.1.

### [GPT1] 7.1 Standard backbone

Current `AnalysisDataModel.h` directly contains:

- BC versions and current alias;
- collision versions and BC relation;
- track → collision relation;
- persistent/expression/dynamic track columns;
- stored and extended track families;
- standard V0/cascade/3-body families;
- MC self relations;
- matching/index-table declarations;
- `Origins::DataframeID`;
- mixed-case `Run2OTFV0`;
- current alias counterexample `McCaloLabels = McCaloLabels_000`.

### [GPT1] 7.2 ASoA machinery

Current `ASoA.h` directly supports:

- classic and `_NG` index equivalence;
- self-slice / self-array macro families;
- `DECLARE_SOA_INDEX_TABLE_NG` with explicit `exclusive`;
- ordinary and `_EXCLUSIVE` wrappers mapping to `false` / `true`.

### [GPT1] 7.3 LF extension layer

Current O2Physics source continues to use the standard model as a dependency and contains the LF V0/cascade analysis layer used by the document's downstream worked examples.

**Disposition:** no source-semantic contradiction found in the v0.5.1 closure delta.

---

## [GPT1] 8. Canonical-file/formal checks — PASS with two non-blocking publication notes

The uploaded Markdown bytes were directly inspected.

### [GPT1] 8.1 Canonical fingerprint

Reviewed artifact:

- SHA-256: `cde55f12047363328611adc6ac2c7c90fb65698c037e153e396d001bfa99cd7e`
- MD5: `4099c40c9b0299364169b3c0148b6990`
- line count: `1734`

The YAML front matter parses successfully.

Current v0.5.1 markers are internally consistent; residual plain `v0.5` references are historical references to the prior review/draft, not stale current-artifact markers.

### [GPT1] 8.2 `[VERBATIM]` syntax

The canonical file contains the required line-bearing forms for the three concrete exact source blocks:

- `ASoA.h:L2896-L2899`;
- `LFStrangenessTables.h:L1078`;
- `LFStrangenessTables.h:L1745-L1747`.

The document now explicitly states that those line references are snapshot-relative until commit pinning.

I did not independently re-hash the historical source snapshot bytes in this review because those bytes were not attached with v0.5.1. Their exactness was previously source-reviewed and remains subject to §24.5 re-verification at publication.

### [GPT1] 8.3 P2 publication note — mixed source/example code labels

Two source-like examples deserve a final MIWikiAI provenance-label sweep before publication:

- the exact-looking `using McCaloLabels = McCaloLabels_000;` excerpt in §4.6;
- the ADF `register_subframe(...)` invocation in §17.2, whose API shape is source-verified but whose concrete key names are explicitly illustrative.

For maximal QRC consistency, the former should either receive a proper exact-source label when pinned, or remain clearly paraphrased; the latter should be marked `[FABRICATED — illustrative only]` unless replaced by a literal source/test excerpt.

This is **P2 / final-publication hygiene**, not a DRAFT approval blocker, because §24.5 already assigns MIWikiAI the final provenance-label validation.

---

## [GPT1] 9. Ratification gates — correctly still open

I agree that v0.5.1 is **not yet ratified**.

The following are explicit and legitimate gates rather than document defects:

1. architect-selected 40-character AliceO2 and O2Physics commits;
2. decision whether those pins represent snapshot provenance or a new reference baseline;
3. canonical source bytes/fingerprints;
4. exhaustive generated `standard_aod` registry;
5. reproduced/cross-validated standard inventory;
6. standard/base AO2D fixture;
7. LF pilot reconciliation;
8. producer/task positional closure;
9. execution of all eleven slicing fixtures;
10. final ADF pin;
11. full ADF expression-surface oracles;
12. final MIWikiAI canonical Markdown/HTML publication pass.

The document's DRAFT status accurately reflects this.

---

## [GPT1] 10. Suitability assessment

### [GPT1] 10.1 Human readability — APPROVED

The standard/base model now precedes the LF specialization, which makes the conceptual progression substantially clearer.

The family map is compact enough to teach without turning the narrative into a generated catalogue.

### [GPT1] 10.2 AI reviewer initialization — APPROVED

The document now provides clear anti-inference rules for:

- names;
- aliases;
- versions;
- index classes;
- equivalence;
- index tables;
- joins;
- physical-file evidence;
- dtype;
- partition identity.

### [GPT1] 10.3 AO2DAI coder initialization — APPROVED as DRAFT

The source → registry → physical reconciliation → Python/ADF contract is sufficiently explicit for the next implementation stage.

Code-generating work must still respect the §24 gates and may not treat the missing generated registry/fixture evidence as already complete.

### [GPT1] 10.4 ADF integration initialization — APPROVED as DRAFT

The ADF-facing section now reflects the reviewed public asymmetric-key API rather than the earlier invented requirement for symmetric keys.

---

## [GPT1] 11. Main Reviewer handoff

### [GPT1] 11.1 Consolidated closure status

| v0.5 finding | GPT1 v0.5.1 disposition |
|---|---|
| F-1 default O2 + O2Physics layers | **CLOSED** |
| F-2 overview/inventory | **CLOSED as contract; generated artifact pending ratification** |
| F-3 registry schema precision | **CLOSED** |
| F-4 ADF contract | **CLOSED as DRAFT contract; execution/pin pending** |
| F-5 parser/fixture hazards | **CLOSED** |

### [GPT1] 11.2 New findings

No new P0/P1 semantic finding.

One **P2 final-publication provenance note** is recorded in §8.3.

---

## [GPT1] 12. Recommendation to the architect

Approve v0.5.1 as the closure DRAFT.

Do **not** request another broad documentation revision.

Proceed with:

1. focused delta review if governance requires it;
2. architect source-pin decision;
3. AO2DAI generated registry + standard fixture + reconciliation + fixtures;
4. ADF final pin and full-surface oracle;
5. MIWikiAI final provenance/HTML/publication pass;
6. ratification review.

The substantive authoring ownership should remain with **AO2DAI**, ADF should validate its own integration surface, and MIWikiAI should return at the final formal/publication gate.

---

## [GPT1] 13. Final verdict

# [GPT1] `[OK] APPROVED`

`DataFormats_AO2D` v0.5.1 is approved as the current **DRAFT closure candidate**.

The v0.5 consolidated F-1–F-5 findings are adequately incorporated, the standard/base AO2D teaching spine is now materially stronger, and the registry/ADF contracts are substantially clearer.

**No further semantic rewrite is requested before the validation/execution gates.**

This approval does **not** waive §24. Final ratification remains pending until the declared source, registry, physical-file, slicing, ADF and publication evidence is attached and reviewed.

**Signature: GPT1**
