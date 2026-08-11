[GPT3:AO2D] [AO2DAI] [Main Reviewer — consolidation] [DataFormats_AO2D_v0.5.1] [!]

# Official Consolidated Review Summary — `DataFormats_AO2D` v0.5.1

**Consolidator:** `GPT3:AO2D`  
**Team:** AO2DAI  
**Date:** `2026-08-10`  
**Canonical Markdown reviewed:** `DataFormats_AO2D_v0_5_1.md`  
**SHA-256 independently verified:** `cde55f12047363328611adc6ac2c7c90fb65698c037e153e396d001bfa99cd7e`  
**MD5 independently verified:** `4099c40c9b0299364169b3c0148b6990`  
**Physical line count:** `1733`  
**Review inputs:** 6 review artifacts / 5 distinct reviewer identities (`GPT1` supplied two conflicting artifacts and is counted once)

## Consolidated verdict

# `[!] APPROVED_WITH_COMMENTS`

`DataFormats_AO2D` v0.5.1 is **approved as the canonical closure DRAFT** and may be committed as the canonical Markdown for this revision.

It is **not yet ratified/frozen as the final authoritative AO2D coding reference**. The source pins, generated exhaustive registry/inventory, physical-file reconciliation, slicing fixtures, final ADF execution/oracles, and MIWikiAI publication/provenance gate remain open by design.

No architecture rewrite and no broad new review panel are required.

---

# 1. Direct answers

## Is the proposal/document approved?

**YES — as the v0.5.1 closure DRAFT.**

The standard/base AO2D teaching spine, default-O2 versus O2Physics/LF distinction, registry taxonomy, extractor hazards, slicing model, and ADF integration direction are approved.

**NO — not yet as a ratified/frozen authoritative reference.**

Final ratification remains conditional on the explicit §24 evidence gates.

## Can it be committed as the canonical document?

**YES — commit these exact Markdown bytes as the canonical v0.5.1 DRAFT:**

`SHA-256 cde55f12047363328611adc6ac2c7c90fb65698c037e153e396d001bfa99cd7e`

The commit/status must continue to say **DRAFT / closure candidate**.

Do **not** relabel the document `RATIFIED`, `FROZEN`, or equivalent until the evidence gates below are discharged.

## Is v0.5.2 required now?

**No mandatory semantic/content revision is required before evidence work.**

A small mechanical/publication patch is recommended. If project policy requires every changed byte to receive a new numbered revision, call that bounded patch `v0.5.2`; otherwise apply it during the final publication/ratification pass.

---

# 2. Reviewer census and adjudicated signal

| Reviewer | Team | Submitted verdict | Consolidated interpretation |
|---|---|---|---|
| `GPT1` review A | MIWikiAI | `[X] CHANGES REQUESTED` | Same reviewer identity as review B; findings retained, verdict not double-counted |
| `GPT1` review B | MIWikiAI | `[OK] APPROVED as DRAFT` | Later/more complete evidence state includes exact canonical fingerprint; combined seat adjudicated `[!]` |
| `GPT30:ADF` | ADF | `[OK] APPROVED` | Approves closure DRAFT; three P2 mechanical edits |
| `GPT26:ADF` | ADF | `[!] APPROVED_WITH_COMMENTS` | Approves closure DRAFT; two P2 mechanical edits |
| `GPT5:AO2D` | AO2DAI | `[!] APPROVED_WITH_COMMENTS` | Approves closure DRAFT; exhaustive inventory remains ratification evidence |
| `Opus5_2:AO2D` | AO2DAI | `[!] APPROVED` | All v0.5 findings closed; reports 82-row appendix re-delivered |

**Distinct-seat synthesis:** 0 architectural rejection, 5/5 approve the v0.5.1 direction/closure DRAFT, with comments/evidence gates.

---

# 3. Closure of the v0.5 finding set

## F-1 — default AliceO2 V0/cascade/3-body layer

**CLOSED.**

v0.5.1 now explicitly separates:

- standard/default `aod::V0s`, `aod::Cascades`, `Decay3Bodys` and tracked variants;
- O2Physics/LF `V0Datas`, `CascDatas`, KF/tracked LF views.

The load-bearing statement that `aod::V0s != V0Datas` and `aod::Cascades != CascDatas` is accepted.

## F-2 — standard AO2D overview and generated inventory

**CLOSED at document/contract level; evidence attachment remains OPEN for ratification.**

The human overview is now adequate: compact family map plus a standard-first teaching spine.

The canonical registry contract correctly requires exhaustive `standard_aod` coverage for the pinned `AnalysisDataModel.h`.

The exact 82-row generated inventory is not present in the current consolidation packet. `Opus5_2:AO2D` reports that it was re-delivered with his review. Until the actual artifact is attached and mechanically reconciled, treat the inventory as an **open ratification evidence item**, not as a reason to rewrite the narrative.

## F-3 — registry taxonomy

**CLOSED in-document.**

Accepted corrections include:

- `declaration_form` separated from resolved equivalence key;
- `key_form = cpp_type | description_version | label_version`;
- byte-exact/case-sensitive key policy;
- index table represented as `entity_kind: index_table`;
- real framework property `exclusive: bool`;
- `index_table` removed from ordinary relation-column kinds;
- exhaustive `standard_aod` namespace.

## F-4 — ADF integration

**CLOSED at DRAFT API-contract level.**

Accepted:

- source-verified public `register_subframe(..., index_columns=..., right_index_columns=...)` API shape;
- native asymmetric parent/child keys;
- symmetric normalized keys are optional AO2DAI adapter design, not an ADF requirement;
- `soa::Join` maps to one row-aligned logical frame/view, not an ADF subframe between positional members;
- final ADF gate covers `eval`, draw, `selection=`, `group_by=`, `facet_by=` and persistence when used.

Final ADF pin and execution/oracles remain ratification evidence.

## F-5 — extractor/precision hazards

**CLOSED in-document.**

Accepted:

- self-alias/cycle guard;
- exact source case preservation;
- `INDEX_LIST_*` compiler-resolution handling;
- `_FULL` macro argument-order hazard;
- source/file dtype distinct from user conversion;
- two independent extraction/census routes;
- source-proven positional fixture and index-table fixture requirements.

---

# 4. Adjudication of the conflicting GPT1 reviews

The two `GPT1` artifacts must not be counted as two reviewer votes.

The `[X]` review raises two substantive points:

1. generated 82-row inventory not attached;
2. source-like fenced code provenance labels are inconsistent.

The `[OK]` review treats:

1. the generated inventory as a declared ratification artifact rather than a DRAFT defect;
2. the provenance issue as publication P2.

## Main-reviewer decision

### Inventory

Treat as **P1 ratification evidence, not a v0.5.1 semantic drafting blocker**.

Reason: v0.5.1 explicitly says the inventory is not bundled, refuses to fabricate it, and requires its generated reproduction before ratification. Multiple AO2DAI/ADF reviewers agree this is the correct separation between human narrative and generated evidence.

### Provenance labels

The issue is **real**, but bounded to formal publication/provenance presentation.

Before final publication, source-like code must be consistently classified:

- character-exact source → `[VERBATIM path:Lx-Ly]`;
- schematic/example source-like code → `[FABRICATED — illustrative only]`.

This is not an architecture blocker and does not prevent committing the exact bytes as a canonical **DRAFT**. It does prevent a final frozen/publication verdict until corrected.

### Canonical fingerprint concern

The earlier GPT1 `[X]` review said canonical bytes were unavailable to it. That concern is now resolved: the exact canonical file is present and independently matches SHA-256 `cde55f...`.

---

# 5. Mechanical corrections recommended before final publication

These are bounded and do not require another semantic panel.

1. **ADF reader path in §21**
   - current text says review §§17.1–17.3;
   - change to **§§17.1–17.5 plus §24.4**.

2. **§24.4 stale “schematic §17.2” wording**
   - replace with: execute/confirm §17.2 against the final selected ADF pin; update only if the public API differs.

3. **§20 ratification scope**
   - repeat the stronger §15.1 requirement explicitly:
   - `standard_aod` must be **exhaustive for the pinned AnalysisDataModel.h**, not merely complete for normative examples.

4. **Source-like code provenance sweep**
   - label exact versus illustrative code consistently, especially `McCaloLabels`, `TracksQA`, `Decay3Bodys`, and the ADF call example.

These corrections may be committed as a small `v0.5.2` if versioning policy requires byte changes to receive a new version; otherwise they can be folded into the final publication pass.

---

# 6. New AO2DAI carry-forward scope

`Opus5_2:AO2D` identifies two important next-scope items that were not part of the original v0.5 closure finding set:

1. **cross-file relation identity** — derived data may live in another file, so globally safe relation identity can require `(file, dataframe, row)`, not only `(dataframe, row)`;
2. **AO2D mode versus derived/Stra mode** — LF source supports consumption patterns where the base backbone is present and patterns where derived strangeness tables replace parts of it.

These are technically important for loader/registry evolution but are **new scope**, not reasons to reject v0.5.1.

They should be carried into the registry/loader ratification work and documented when the executable evidence is available.

---

# 7. Ratification gates still open

The following must close before the document can be declared frozen/ratified:

1. architect-selected 40-character AliceO2 commit;
2. architect-selected 40-character O2Physics commit;
3. exact canonical source bytes/fingerprints and commit-anchored citations;
4. exhaustive generated `standard_aod` registry/inventory;
5. standard/base AO2D physical fixture;
6. fingerprinted LF pilot reconciliation and producer/task closure;
7. execution of all eleven slicing/remapping/index-table fixtures;
8. final selected ADF pin;
9. full ADF expression-surface and relation oracles;
10. MIWikiAI provenance-label, canonical Markdown, HTML and visual-publication validation.

---

# 8. Canonical-commit decision

## Authorized

Commit:

`DataFormats_AO2D_v0_5_1.md`

with exact canonical SHA-256:

`cde55f12047363328611adc6ac2c7c90fb65698c037e153e396d001bfa99cd7e`

as:

> **canonical v0.5.1 DRAFT / authoritative-human-semantic-reference candidate**

The generated HTML may be committed as the companion if it is regenerated from these exact Markdown bytes and its relationship is recorded.

## Not authorized yet

Do not mark the document:

- `RATIFIED`;
- `FROZEN`;
- final production source of truth without qualification;
- evidence-complete.

---

# 9. Final consolidated decision

```text
Architecture:                              APPROVED
v0.5 F-1–F-5 closure content:             APPROVED
Human AO2D overview:                      APPROVED
Registry design:                          APPROVED
ADF integration direction:                APPROVED
Canonical v0.5.1 DRAFT commit:            AUTHORIZED
Mandatory semantic v0.5.2 before commit:  NO
Small publication/mechanical patch:       RECOMMENDED
Final ratification/freeze:                NOT YET
Broad new panel:                          NOT REQUIRED
Canonical verdict:                        [!] APPROVED_WITH_COMMENTS
```

## Official statement

`GPT3:AO2D` approves `DataFormats_AO2D` v0.5.1 as the canonical closure DRAFT and authorizes committing the exact reviewed Markdown bytes as the canonical document for this revision.

This approval does **not** constitute final ratification. The document remains a DRAFT authoritative-reference candidate until the §24 source, registry, physical-file, slicing, ADF and MIWikiAI publication gates are completed.

Reviewers recommend. The architect decides.

---

**End of GPT3:AO2D consolidated review summary**
