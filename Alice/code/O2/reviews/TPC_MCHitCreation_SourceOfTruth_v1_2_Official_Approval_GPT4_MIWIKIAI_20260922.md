[reviewerID=GPT4:MIWikiAI] [groupID=MIWikiAI] [compositeIdentity=MIWikiAI::GPT4:MIWikiAI] [Reviewer] [TPC_MCHitCreation_SourceOfTruth_v1.2] [OK]

# GPT4:MIWikiAI [MIWikiAI] — Official Focused Approval
## `TPC_MCHitCreation_SourceOfTruth_v1.2`

**Verdict:** `[OK] APPROVED FOR VERSIONED COMMIT AS THE CURRENT MIWikiAI SOURCE-OF-TRUTH BASELINE`

**Reviewer ID:** `GPT4:MIWikiAI`  
**Group ID:** `MIWikiAI`  
**Composite identity:** `MIWikiAI::GPT4:MIWikiAI`  
**Review date:** 2026-09-22  
**Originating technical team:** O2MCAI  
**Technical owner:** O2MCAI  
**Publication/maintenance owner:** MIWikiAI  

## Scope of approval

This approval covers the MIWikiAI v1.2 publication adaptation as the current project Source-of-Truth baseline for the reviewed ALICE O2 Run-3 TPC MC hit-creation model.

It does **not** mean:

- official adoption by the ALICE Collaboration;
- validation of the standard TPC ionisation model for magnetic monopoles;
- closure of the current monopole-production provenance;
- full source/physics validation of the open monopole PR;
- closure of the historical AliRoot Run-2 monopole comparison.

Those limits are correctly retained in v1.2.

## Focused confirmation of the v1.2 gate

The four publication-relevant P1 corrections identified by the consolidated review are present:

1. **Field-cage gap suppression** — included as §6.1 with `TPCDetParam.ExcludeFCGap`.
2. **Unsupported generic pad-response claim removed** — downstream chain now states source-supported pad assignment and documents electron-loss/position-changing stages.
3. **Open monopole PR represented explicitly** — recorded as review evidence, open/not merged/not canonical, with reviewed head `26f3cee935d09843131d091bd9bca402d85797dd`.
4. **Doxygen classified correctly** — immutable pinned Git commits are primary authority; Doxygen is corroboration only.

The important P2 publication/provenance fixes are also present:

- normalized front matter and ownership;
- exact source commits;
- exact `kMaxDistRef = 15 cm` wording;
- fractional-charge consequence of `static_cast<int>(TrackCharge()) == 0`;
- primary-ionisation-electron semantics;
- no upstream persisted-field rename implied;
- both monopole PDG families represented in provenance;
- source-certified facts separated from open design/review evidence;
- MIWikiAI cross-references included.

## Technical model

The approved current-source conclusions remain:

- TPC hit creation is detector-specific in `TPC::Detector::ProcessHits()`;
- normal TPC ionisation rejects `static_cast<int>(TrackCharge()) == 0`;
- default `UseGeant4Edep=false` uses the O2 GEANT3-ILOSS-5 / NA49-derived stochastic model;
- collision rate contains ordinary electric `trackCharge^2`;
- `UseGeant4Edep=true` is a separate transport-`Edep` branch;
- the historical hit `mELoss` / `GetEnergyLoss()` payload is a primary-ionisation-electron count for digitisation;
- TrackReference, TPC-hit `nElectrons`, and digit/ADC are distinct layers;
- the standard master/dev TPC model is **not validated for magnetic monopoles**.

## Open items

The v1.2 document correctly keeps the following open rather than presenting them as defects or frozen facts:

- exact current monopole production SHA/configuration;
- master/dev versus PR-derived production state;
- actual production `TrackCharge()` and `UseGeant4Edep`;
- historical AliRoot monopole implementation;
- full source audit and physics validation of the open monopole PR;
- controlled Run-2/AliRoot ↔ Geant4/Run-3 validation.

These open items do **not** block committing v1.2 as the current Source-of-Truth baseline because the document clearly marks their status and does not overclaim them.

## Final decision

**YES — commit v1.2 now as the current MIWikiAI Source-of-Truth baseline.**

Recommended path:

```text
Alice/code/O2/TPC_MCHitCreation_SourceOfTruth_v1_2.md
```

Retain the official review summary under:

```text
Alice/code/O2/reviews/
```

Recommended status wording:

```text
current MIWikiAI Source-of-Truth baseline
O2MCAI source semantics / MIWikiAI publication maintenance
not an official ALICE Collaboration document unless separately adopted
```

No broad re-review is required.

**Signed:**  
`reviewerID=GPT4:MIWikiAI`  
`groupID=MIWikiAI`  
`compositeIdentity=MIWikiAI::GPT4:MIWikiAI`  
`verdict=[OK] APPROVED FOR VERSIONED COMMIT AS CURRENT MIWikiAI SOURCE-OF-TRUTH BASELINE`
