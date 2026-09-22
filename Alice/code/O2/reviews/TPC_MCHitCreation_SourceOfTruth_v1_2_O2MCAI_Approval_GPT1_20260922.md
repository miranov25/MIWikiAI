[GPT1:O2MCAI] [O2MCAI] [Reviewer] [TPC_MCHitCreation_SourceOfTruth_v1_2] [OK]

# O2MCAI Focused Source/Provenance Confirmation — TPC_MCHitCreation_SourceOfTruth_v1_2

**Reviewer ID:** `GPT1:O2MCAI`  
**Group:** O2MCAI  
**Role:** focused source/provenance confirmation reviewer  
**Date:** 2026-09-22  
**Document reviewed:** `TPC_MCHitCreation_SourceOfTruth_v1_2.md`  
**MIWikiAI review reviewed:** `TPC_MCHitCreation_SourceOfTruth_v1_2_Official_Review_Summary_GPT5_MIWIKIAI_20260922.md`  
**Verdict:** **[OK] APPROVED FOR VERSIONED COMMIT AND CURRENT MIWikiAI SOURCE-OF-TRUTH BASELINE**

## Artifact fingerprints

`TPC_MCHitCreation_SourceOfTruth_v1_2.md`

```text
MD5     f14dbe50b33927750e54de1b36661c8e
SHA256  fb3e867e898d060306326721accbca303a4769ba695b6247702cd1965cb4459a
bytes   38727
```

`TPC_MCHitCreation_SourceOfTruth_v1_2_Official_Review_Summary_GPT5_MIWIKIAI_20260922.md`

```text
MD5     9c8f7be7a61af26af17e444296daa471
SHA256  fb44f61987009d8ded7a4be3493f8faa5a3482e3abacb1787bca07c79d3f272d
bytes   9922
```

## Source-Read declaration

I reviewed the full v1.2 MIWikiAI adaptation and the accompanying GPT5:MIWikiAI review summary as a focused
cross-team source/provenance confirmation.

The technical baseline remains anchored to the two immutable AliceO2 source snapshots:

```text
5b009ee93bd75b0d03183b79ca8388b5b7b6e479
86a1ec8dcb984ace1443ce82fe19c76bb6321c8a
```

The open monopole pull-request snapshot is recorded separately as review evidence:

```text
26f3cee935d09843131d091bd9bca402d85797dd
```

and is explicitly not promoted to merged/canonical AliceO2 source status.

## Focused confirmation of the four bounded P1 corrections

### P1-A — Field-cage gap suppression

**CLOSED.**

v1.2 explicitly documents the second early `ProcessHits()` suppression gate controlled by
`TPCDetParam.ExcludeFCGap`, including the distinction between geometric hit suppression and the electric-charge
gate.

### P1-B — Unsupported generic pad-response wording

**CLOSED.**

v1.2 no longer presents an unsupported generic neighbouring-pad response stage. The downstream chain now uses
the source-supported description `pad assignment`, with the relevant electron-loss/position-changing stages
documented separately.

### P1-C — Open monopole PR provenance

**CLOSED.**

v1.2 records the reviewed PR snapshot and its reported monopole/TPC branch, while explicitly classifying it as:

```text
REVIEW-EVIDENCE — OPEN / NOT MERGED / NOT CANONICAL
```

The canonical source baseline remains the pinned master/dev snapshots.

### P1-D — Doxygen reproducibility classification

**CLOSED.**

v1.2 explicitly states that public Doxygen checks are corroborating evidence only. Immutable pinned Git commits
are the normative source anchors.

## Technical-model confirmation

The following central conclusions remain correct and are preserved in v1.2:

1. detector `ProcessHits()` defines detector-hit semantics;
2. the default TPC ionisation path is the O2 GEANT3-ILOSS-5 / NA49-derived model;
3. `UseGeant4Edep=true` is a separate opt-in transport-`Edep` path;
4. the historical TPC `mELoss` / `GetEnergyLoss()` payload carries primary ionisation-electron count for
   digitisation in the reviewed path;
5. TrackReference-derived transport quantities, TPC hit `nElectrons`, and TPC digit/ADC are distinct layers;
6. the default electric-charge model must not be assumed valid for magnetic monopoles;
7. current monopole-production provenance and physics validation remain explicitly open rather than being
   presented as established facts.

## Open items correctly retained

The following remain open by design and do not block committing this source-of-truth baseline:

- exact historical AliRoot Run-2 monopole implementation;
- exact current monopole-production SHA/release/configuration;
- whether the production uses master/dev or PR-derived monopole code;
- actual `TrackCharge()` and `UseGeant4Edep` values in that production;
- full source audit and physics validation of the open monopole PR;
- quantitative Run-2/AliRoot versus Run-3/Geant4 monopole validation.

These are correctly labelled as unresolved technical work rather than silently resolved by documentation.

## Publication / authority classification

The document may be committed as:

```text
Alice/code/O2/TPC_MCHitCreation_SourceOfTruth_v1_2.md
```

with its present front-matter classification:

```text
source-of-truth
EXTERNAL_TEAM_VERIFIED
O2MCAI technical ownership
MIWikiAI publication/maintenance ownership
```

This means **current MIWikiAI source-of-truth baseline**, not an official ALICE Collaboration document and not a
claim that monopole physics has been validated.

The open PR remains noncanonical until merged/adopted and separately reviewed.

## Final disposition

**Technical/source semantics:** APPROVED  
**Provenance structure:** APPROVED  
**Four bounded MIWikiAI corrections:** CLOSED  
**Versioned commit:** APPROVED  
**Current MIWikiAI source-of-truth baseline:** APPROVED  
**Official ALICE Collaboration status:** NOT CLAIMED  
**Monopole physics validation:** OPEN / NOT CLAIMED  

### Verdict

**[OK] APPROVED FOR COMMIT.**

With the existing `GPT5:MIWikiAI` formal publication review and this `GPT1:O2MCAI` focused source/provenance
confirmation, the stated two-sided freeze gate is satisfied for v1.2.

**Reviewer:** `GPT1:O2MCAI`
