# [GPT5:MIWikiAI] [MIWikiAI] [Reviewer] [PHASE_0_4_O2MCAI TrackReference Source Audit v1.1] [OK]

# Official MIWikiAI Review — TrackReference Source Audit v1.1

**Reviewer identity:** `GPT5:MIWikiAI`  
**Reviewer architecture/model:** `GPT-5.6 Sol`  
**Review date:** 2026-10-04  
**Review type:** MIWikiAI source-of-truth / documentation acceptance review  
**Primary target:** `PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003.md`  
**Companion target:** `PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003_Review_Summary.md`  
**O2MCAI commit requested:** `e17723e44db2dc7cd554a0ba88511fc12b28035`  
**Reviewed primary fingerprint (from O2MCAI consolidated review):** MD5 `0995d3b8372cb3fee03acca6be5b1997`; SHA256 `7a17ffc0ecc2a4e956c9aa2660b6b6eda2163ddc3450bf37fd54f017735e556c`; 534 lines  
**Implementation approval:** **NOT GRANTED**

## Source-Read

- primary v1.1 audit read: **YES**
- O2MCAI official Review Summary read: **YES**
- reviewer prompt read: **YES**
- independent source-link/source-semantic re-check: **YES**

The MIWikiAI review independently reopened the load-bearing immutable sources at the pins used by the audit, including:

- AliceO2 `5b009ee93bd75b0d03183b79ca8388b5b7b6e479`
- Geant4-VMC `024fccb9fec1154338164c1fc9c31e2ecbbc089c`
- Geant4 `2ee379e6843e55b9c6bbb835d2a2b03cc998fef0`
- AliRoot `46f8b62b1c76705c6c03768972a83b3b43e07789`

Checked source areas include TrackReference layout/constructors, Stack persistence, detector producers and negative producer cases, O2MCApplication early-return cuts, the standard stepping TrackReference hook, Geant4-VMC MaxNofSteps/region termination, PostTrack dispatch, special cuts, Geant4 sensitive-detector/user-stepping ordering, monopole transportation looper/world-exit paths, and the AliRoot `kDisappeared` precedent.

## 1. Verdict

**[OK] APPROVED FOR MIWikiAI ARCHIVAL AS A PAIRED SOURCE-AUDIT UNIT.**

No P0 or P1 source-semantic defect was found.

The central audit conclusion is source-supported:

```text
Current O2 does not persist exactly one complete final TrackReference
for every transported-particle terminal trajectory, and detector-core
entry/exit TrackReference coverage is incomplete for the audited Run-3 scope.
```

The audit correctly keeps the existing `TrackReference` persistent representation and does not justify reopening the frozen architecture.

## 2. Independent factual confirmation

### TrackReference representation

Confirmed from the pinned AliceO2 source:

- `SimTrackStatus::mStatus` is an `unsigned char`;
- seven transport-state bits are defined;
- the VMC constructor snapshots those state bits;
- the explicit-value constructor leaves `mStatus` at its default zero value;
- `mUserId` and `mDetectorId` exist with the semantics described by the audit.

The audit's distinction between transport state and termination cause is therefore correct.

### Persistence effect

Confirmed: `Stack::addTrackReference()` sets the secondary track's store flag, marks the current particle as having TrackReferences, and appends the reference. The warning that an all-transported-particles final-reference policy can increase stored MCTrack/output volume is valid.

### Detector inventory

The reviewed detector statements are consistent with the pinned source.

Existing producer behavior was independently confirmed for the key positive-control cases including ITS, TPC, TRD, HMPID, EMCAL, MCH and MID.

The reviewed negative/missing-coverage cases are consistent with the source/readout paths inspected for TOF, MFT, PHOS, CPV, FT0, FV0, FDD and ZDC.

The TRD qualification in the companion Review Summary is important and correct: a track that terminates inside TRD needs the common final record; it must not be represented as a fabricated detector exit.

### O2 early termination

Confirmed: O2 TOFMAX, geometry/r-z filtering and user step filtering execute `StopTrack(); return;` before the optional stepping TrackReference hook. The existing hook therefore cannot be a complete catch-all finalization mechanism.

### Geant4-VMC ordering and termination

Confirmed:

- MaxNofSteps starts the loop/grace counter and later produces `fStopAndKill`;
- tracking-region termination can produce `fStopAndKill`;
- Geant4 invokes the sensitive-detector hit path before the user stepping action for the same step;
- `PostTrack()` is invoked for completed tracks but not suspended/interrupted tracks;
- monopole transportation contains separate looper/world-exit termination paths.

This supports `PostTrack()` as the strongest current common-finalization candidate, while preserving the audit's requirement for the bounded runtime/backend checks before implementation freeze.

### Historical precedent

Confirmed at the cited AliRoot orientation commit: disappearing non-alive tracks above the historical energy threshold receive a `kDisappeared=-1` TrackReference.

The audit correctly labels this as historical/orientation evidence rather than claiming the cited master commit is the exact production-era Run-1/2 pin.

## 3. Source-link traceability

All immutable GitHub links embedded in the primary audit that were checked in this MIWikiAI pass resolve to the intended repository, commit and source behavior.

The O2MCAI companion Review Summary additionally supplies immutable source anchors for several normative observations that the primary audit currently expresses as source paths/search evidence rather than direct links.

This yields one remaining documentation observation:

**P2 — standalone-primary permalink completeness.**

The primary v1.1 document is not fully self-contained as a standalone source-of-truth page because several normative rows rely on the companion evidence ledger for direct immutable permalinks.

This is **not a blocker** if MIWikiAI archives the primary audit and its O2MCAI Review Summary together as one source-audit unit.

## 4. Terminology and scope

Terminology is acceptable for MIWikiAI.

The document correctly distinguishes:

- detector entry/exit TrackReferences from a global final TrackReference;
- transport-state bits from termination-reason taxonomy;
- stopped/disappeared/final transport state from the physical cause of termination;
- suspended/interrupted trajectories from genuinely terminal trajectories;
- source facts from Architect/runtime implementation decisions;
- AliRoot and Geant4 pins used for orientation semantics from production-runtime identity.

The original all-particles requirement, including charged and neutral transported particles, remains explicit and is not silently narrowed.

## 5. MIWikiAI source-of-truth disposition

### Approved archival form

Commit **both** files together:

```text
Alice/code/O2/PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003.md

Alice/code/O2/reviews/
PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003_Review_Summary.md
```

In this paired form, the package is suitable as MIWikiAI source-of-truth material for:

- the audited current TrackReference data model;
- the Run-3 detector producer/gap inventory at the pinned source;
- the audited termination/disappearance gaps;
- the historical AliRoot orientation precedent;
- the conclusion that `PostTrack()` is the strongest bounded common-finalization candidate.

### No pre-commit rewrite required

**Do not modify the already reviewed v1.1 bytes before the MIWikiAI commit.**

A documentation-only successor may later move the supplemental immutable links from the Review Summary into the primary page if MIWikiAI decides that every canonical primary document must be independently self-contained.

That cleanup is not required to bank the reviewed source-audit pair.

## 6. Explicit boundary

This approval is documentation/source-semantic approval only.

It does **not** approve:

- a termination-reason encoding choice;
- any `PostTrack()` implementation;
- detector-core/envelope selections;
- TPC time-unit changes;
- output-growth consequences;
- transport-backend parity;
- production/runtime configuration.

Those remain the bounded implementation-design/prototype gate.

## Final decision

```text
P0: 0
P1: 0
P2: 1 documentation advisory — standalone-primary permalink completeness

Source-link traceability: PASS for paired audit + Review Summary
Factual accuracy: PASS
Terminology: PASS
Frozen architecture preserved: YES
MIWikiAI paired source-of-truth archival: APPROVED
Implementation: NOT APPROVED
```

**PHASE_0_4_O2MCAI TrackReference Source Audit v1.1 APPROVED FOR MIWikiAI ARCHIVAL.**

**No modification is required before committing the reviewed audit and its companion Review Summary together to `Alice/code/O2/`.**

[OK] APPROVED

---

**Signed:** `GPT5:MIWikiAI`  
**Reviewer architecture/model:** `GPT-5.6 Sol`  
**Date:** 2026-10-04
