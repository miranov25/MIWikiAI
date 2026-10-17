[GPT3:O2MCAI] [O2MCAI] [MainReviewer] [PHASE_0_4_O2MCAI] [!]

# PHASE_0_4_O2MCAI TrackReference Source Audit v1.1 — Official Review Summary

**Main Reviewer / consolidator:** `GPT3:O2MCAI`
**Reviewer architecture/model:** GPT-5.6 Sol
**Date:** 2026-10-03
**Document reviewed:** `PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003.md`
**Reviewed-document fingerprint:** MD5 `0995d3b8372cb3fee03acca6be5b1997`; SHA256 `7a17ffc0ecc2a4e956c9aa2660b6b6eda2163ddc3450bf37fd54f017735e556c`; 534 lines
**Reviews synthesized:** 5 unique confirmations; duplicate uploads excluded
**Review type:** own-team documentation/source-audit confirmation
**Implementation approval:** **NOT GRANTED**

**Revision note:** this revision supersedes the earlier draft Review Summary. It adds the Organization Main-Reviewer decision interface, explicit Source-Read accounting, Main-Reviewer source-link verification, and MIWikiAI-readiness disposition. The technical source-audit verdict is unchanged.

---

# 1. First-page decision summary

## Verdict: `[!] APPROVED WITH P2 / ADVISORY COMMENTS`

The v1.1 source audit is technically approved: no material source conclusion was invalidated, P0=0 and P1=0. The audit is suitable for human ALICE circulation and bounded implementation design. It is **not yet ideal as a standalone MIWikiAI canonical source-of-truth document** because several normative rows rely on source paths/search evidence without carrying direct immutable permalinks in the primary audit itself; this summary supplies the missing verification ledger.

Formal disposition:

```text
PHASE_0_4_O2MCAI TrackReference Source Audit v1.1 APPROVED
SOURCE-SEMANTIC AUDIT MAY PROCEED TO BOUNDED IMPLEMENTATION DESIGN
IMPLEMENTATION ITSELF IS NOT APPROVED
```

## Answers to the Seven Architect Questions

### Q1 — Please rank reviewer

Ranking is for this **specific source-audit confirmation**, weighted by independent source coverage and useful correction signal. No TP/FP/FN benchmark was pre-defined, so numerical TP/FP/FN counts are intentionally not invented.

| Rank | Reviewer | Source coverage | Main contribution | Signal |
|---:|---|---|---|---|
| 1 | `Opus5_1:O2MCAI` | AliceO2 + TPC + Geant4-VMC + Geant4 kernel + AliRoot orientation | independently pinned the Geant4 kernel ordering and closed the strongest ordering qualification | very high |
| 2 | `GPT4:O2MCAI` | broad AliceO2 detector set + Geant4-VMC + AliRoot orientation | broadest single confirmation of detector/global source claims; `[OK]` | very high |
| 3 | `Opus5_2:O2MCAI` | all 16 detector rows + Geant4-VMC | explicitly opened all detector rows including previously under-read rows; strong insertion-order observations | very high |
| 4 | `ClaudeEaxtra3:O2MCAI` | full AliceO2 checkout + Geant4-VMC + Geant4 orientation + AliRoot orientation | strong repository-wide producer search and reason-capture / engine-cut advisories | high |
| 5 | `GPT3:O2MCAI` | load-bearing AliceO2 + TPC + Geant4-VMC + AliRoot orientation | independent confirmation and provenance/readability findings; less exhaustive than the top four | high |

### Q2 / Q5 — Did reviewers agree; are they consistent?

**CONSISTENT on the audit decision and all load-bearing conclusions. MIXED only on P2 implementation/documentation details.**

All five unique reviewers agree:

```text
current O2 final TrackReference coverage is incomplete;
Run-3 detector entry/exit coverage is incomplete;
the existing TrackReference object remains the persistent object;
no MCTrack/new-object redesign is required;
PostTrack() is the strongest current common-finalization candidate;
implementation is not approved yet;
P0 = 0;
P1 = 0.
```

Non-blocking differences were reconciled as follows:

```text
TRD:
    keep true detector entry/exit semantics;
    a track dying inside TRD belongs to the common final-reference path;
    do not invent a fake detector exit.

final-reference population:
    frozen Architect requirement remains all transported particles;
    reviewer suggestions to silently add Etot/optical-photon exclusions are not adopted.

Geant4 ordering:
    kernel ordering is now independently source-pinned;
    the earlier qualification is closed.

termination reason:
    PostTrack() may need transient cause bookkeeping from kill sites;
    this is implementation design, not a new persistent data model.
```

### Q3 — Indicate which reviewer checked the source code

All five unique reviewers performed own-team source reading. The individual depth differs.

| Reviewer | Source-Read declaration / scope |
|---|---|
| `Opus5_1:O2MCAI` | AliceO2 `5b009ee93bd75b0d03183b79ca8388b5b7b6e479`; TPC orientation `86a1ec8dcb984ace1443ce82fe19c76bb6321c8a`; Geant4-VMC `024fccb9fec1154338164c1fc9c31e2ecbbc089c`; Geant4 `2ee379e6843e55b9c6bbb835d2a2b03cc998fef0`; AliRoot orientation `46f8b62b1c76705c6c03768972a83b3b43e07789` |
| `GPT4:O2MCAI` | broad AliceO2 detector/common source at `5b009ee...`; TPC cross-check; Geant4-VMC `024fcc...`; AliRoot orientation `46f8b62...` |
| `Opus5_2:O2MCAI` | all 16 detector rows at AliceO2 `5b009ee...`; TPC `86a1ec...`; Geant4-VMC `024fcc...`; explicitly did not claim AliRoot/kernel validation |
| `ClaudeEaxtra3:O2MCAI` | full AliceO2 checkout `5b009ee...`; Geant4-VMC `024fcc...`; Geant4 orientation; AliRoot orientation; exact v1.1 audit fingerprint explicitly recorded |
| `GPT3:O2MCAI` | load-bearing AliceO2 `5b009ee...`; TPC orientation; Geant4-VMC `024fcc...`; AliRoot orientation |

### Main-Reviewer Source-Read and link verification

For this revised consolidation I independently reopened:

```text
AliceO2 @ 5b009ee93bd75b0d03183b79ca8388b5b7b6e479
Geant4-VMC @ 024fccb9fec1154338164c1fc9c31e2ecbbc089c
Geant4 @ 2ee379e6843e55b9c6bbb835d2a2b03cc998fef0
AliRoot @ 46f8b62b1c76705c6c03768972a83b3b43e07789
```

I opened **every immutable GitHub link embedded in v1.1** and checked that the repository, commit, path and cited behavior are consistent with the audit claim. No broken or wrong embedded source link was found.

I additionally opened source that v1.1 discusses but does not directly permalink in every row, including:

```text
MFT ProcessHits
MCH Stepper
MID Stepper
O2MCApplication early StopTrack()/return paths
FOCAL comparison producer
SetCuts special-cut configuration
TG4VSpecialCuts
TG4SensitiveDetector
TG4SDConstruction
Geant4 G4SteppingManager kernel ordering
```

The exact v1.1 audit bytes were independently fingerprinted:

```text
MD5     0995d3b8372cb3fee03acca6be5b1997
SHA256  7a17ffc0ecc2a4e956c9aa2660b6b6eda2163ddc3450bf37fd54f017735e556c
lines   534
```

Four individual reviews do not carry a formal audit-fingerprint verification line even though they identify the exact v1.1 target and source commits. That is a governance/provenance P2, not a source-semantic blocker; the Main Reviewer fingerprint reconciliation above closes the target-byte ambiguity for this consolidation.

### Q4 — Are the changes straightforward?

**Audit-document corrections: STRAIGHTFORWARD. Implementation: MODERATE.**

The source-audit cleanup consists of link/provenance hardening and a few wording refinements.

The eventual implementation remains bounded but is not entirely mechanical because it still requires:

```text
detector-core/envelope choices;
termination-reason encoding decision within existing TrackReference;
CHECK-1 of PostTrack final-state access;
transient reason capture where a cause cannot be recovered later;
TPC time-unit compatibility decision;
output-growth measurement.
```

### Q6 — Is there any risk, so I should visually inspect the results immediately?

**YES — inspect four items before freezing code, not before banking the source audit:**

```text
1. termination-reason encoding on the global final TrackReference;
2. detector-core/envelope choices for segmented detectors;
3. TPC TrackReference time-unit inconsistency;
4. all-transported-particles output-growth measurement.
```

No immediate visual inspection is required to decide whether the **source audit** itself is technically valid.

### Q7 — Are the tests sufficient?

**NOT APPLICABLE for source-audit approval; INSUFFICIENT for implementation approval.**

This is a source-semantic audit, not an implementation review. No code candidate exists yet.

Before implementation approval, the bounded validation must include:

```text
CHECK-1: final position/momentum/length/time/status/identity at PostTrack();
no duplicate final reference;
suspend/postpone/resume safety;
detector boundary regression tests;
charged + neutral transported-particle coverage;
termination-class coverage;
identity/remapping preservation;
output-size / stored-MCTrack growth;
backend parity for every transport backend kept in scope.
```

## Convergent Issues

| ID | Pri | Issue | Raised by | Main disposition |
|---|---|---|---|---|
| P2-A | P2 | primary v1.1 audit is not fully permalink-complete on every normative row | GPT3, Claude, Opus5_2 + Main Reviewer | source semantics approved; strict standalone MIWikiAI handoff needs link hardening or this summary as companion evidence ledger |
| P2-B | P2 | TRD wording can imply a detector-exit fix for an internal death | Claude + synthesis | accepted clarification: common final record, no fake TRD exit |
| P2-C | P2 | engine-level special cuts should be explicit in termination inventory | Claude | accepted for implementation design |
| P2-D | P2 | PostTrack may need transient cause bookkeeping; duplicate-final guard required | Claude, Opus5_1 | accepted for implementation design |
| P2-E | P2 | TPC `mTof` convention differs from VMC-constructor references | Opus5_2, Claude | explicit Architect compatibility decision required before code freeze |
| P2-F | P2 | AliRoot orientation / Geant4-specific claims need prominent labels for external readers | multiple | accepted human/MIWikiAI packaging clarification |
| P2-G | P2 | several individual reviews omit formal fingerprint-verification line | Main Reviewer | target bytes reconciled here; governance hardening for future rounds |

## Recommendation to Main Architect

**Bank v1.1 as the approved O2MCAI source-audit result and send it to human ALICE reviewers with this Review Summary. For MIWikiAI, treat the pair as reviewable now, but do not call the primary audit alone publication-grade/canonical until every normative row has its own immutable source permalink or MIWikiAI explicitly accepts this summary as the companion evidence ledger.**

---

# 2. Source-link verification ledger

This section records the Main Reviewer's independent source-link check.

## 2.1 Links embedded directly in the v1.1 audit

All links below were opened at the exact commit named in the URL.

| Audit claim/source | Immutable source | Result |
|---|---|---|
| TrackReference status/layout/constructors | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/DataFormats/simulation/include/SimulationDataFormat/TrackReference.h | VALIDATED |
| `Stack::addTrackReference()` persistence effect | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/Base/include/DetectorsBase/Stack.h | VALIDATED |
| TPC producer | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/TPC/simulation/src/Detector.cxx#L112-L170 | VALIDATED |
| ITS producer | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/ITSMFT/ITS/simulation/src/Detector.cxx#L318-L344 | VALIDATED |
| TRD producer | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/TRD/simulation/src/Detector.cxx#L117-L203 | VALIDATED; wording qualification P2-B |
| TOF hit gates / no local producer in shown path | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/TOF/simulation/src/Detector.cxx#L75-L90 | VALIDATED |
| HMPID producer | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/HMPID/simulation/src/Detector.cxx#L115-L140 | VALIDATED |
| EMCAL superparent reference | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/EMCAL/simulation/src/Detector.cxx#L170-L289 | VALIDATED |
| PHOS superparent/hit logic | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/PHOS/simulation/src/Detector.cxx#L130-L170 | VALIDATED |
| CPV early-return ordering | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/CPV/simulation/src/Detector.cxx#L113-L133 | VALIDATED |
| ZDC envelope/sensitive logic | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/ZDC/simulation/src/Detector.cxx#L394-L426 | VALIDATED |
| FT0 entering/optical-photon logic | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FIT/FT0/simulation/src/Detector.cxx#L1101-L1138 | VALIDATED |
| FV0 entering/exiting hit state | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FIT/FV0/simulation/src/Detector.cxx#L79-L97 | VALIDATED |
| FDD charged gate | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FIT/FDD/simulation/src/Detector.cxx#L103-L108 | VALIDATED |
| standard final-reference hook | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/gconfig/src/StandardSteppingTrackRefHook.macro | VALIDATED |
| hook default configuration | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Common/SimConfig/include/SimConfig/SimParams.h | VALIDATED |
| MaxNofSteps / tracking-region / PPCUTM logic | https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4SteppingAction.cxx | VALIDATED |
| AliRoot disappeared-reference precedent | https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/STEER/STEER/AliMC.cxx#L1507-L1520 | VALIDATED as orientation source |
| AliRoot `kDisappeared` ID | https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/STEER/STEERBase/AliTrackReference.h#L20-L38 | VALIDATED as orientation source |
| Geant4-VMC `PostTrack()` call | https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4TrackingAction.cxx | VALIDATED |
| O2 lacks a `PostTrack()` override in the audited header | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Steer/include/Steer/O2MCApplicationBase.h | VALIDATED |

**Result:** no embedded immutable GitHub link was found to be broken, wrong-repository, wrong-commit, or inconsistent with its associated v1.1 source observation.

## 2.2 Important source anchors missing from the primary audit but checked here

These are useful for MIWikiAI/human traceability because the audit discusses the behavior without always providing a direct permalink on the normative row.

| Observation | Immutable source | Result |
|---|---|---|
| MFT charge/sensor early returns | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/ITSMFT/MFT/simulation/src/Detector.cxx#L95-L115 | VALIDATED |
| MCH entry/exit + detector-local `mUserId` | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/MUON/MCH/Simulation/src/Stepper.cxx#L40-L60 | VALIDATED |
| MID entry/exit + detector-local `mUserId` | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/MUON/MID/Simulation/src/Stepper.cxx#L35-L60 | VALIDATED |
| O2 TOFMAX / geometry / user-filter early returns | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Steer/src/O2MCApplication.cxx#L79-L131 | VALIDATED |
| FOCAL comparison/superparent explicit-reference pattern | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FOCAL/simulation/src/Detector.cxx | VALIDATED |
| O2 engine cut configuration | https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/gconfig/src/SetCuts.cxx#L50-L75 | VALIDATED |
| Geant4-VMC special-cut termination | https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/physics/src/TG4VSpecialCuts.cxx#L70-L137 | VALIDATED |
| VMC application `Stepping()` dispatch through sensitive detector | https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/digits%2Bhits/src/TG4SensitiveDetector.cxx | VALIDATED |
| Geant4 kernel order: sensitive detector before user stepping action | https://github.com/Geant4/geant4/blob/2ee379e6843e55b9c6bbb835d2a2b03cc998fef0/source/tracking/src/G4SteppingManager.cc#L120-L256 | VALIDATED as orientation semantics |
| monopole looper/world-exit paths | https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/physics_monopole/src/G4MonopoleTransportation.cxx#L462-L563 | VALIDATED |

---

# 3. Source-semantic adjudication

## 3.1 Central answer

**CONFIRMED.**

Current O2 does not provide the requested combination of:

```text
complete detector-core entry/exit TrackReferences
+
exactly one persistent final TrackReference for every transported-particle terminal trajectory
+
recoverable final state and termination reason
+
protection against false finalization of resumable suspended/interrupted tracks
```

This conclusion is supported by the pinned source.

## 3.2 TrackReference representation

**CONFIRMED.**

At the audited AliceO2 source:

```text
mStatus is an unsigned char;
seven transport-state bits are defined;
the VMC constructor snapshots transport state;
the explicit-value constructor leaves mStatus at its default zero;
mUserId exists and has detector-local uses;
mDetectorId defaults to -1.
```

No source evidence requires a new persistent class.

The final termination-reason encoding remains an Architect decision inside the frozen existing-TrackReference contract.

## 3.3 Detector inventory

**CONFIRMED for the audited Run-3 scope.**

Existing producers are correctly identified in ITS, TPC, TRD, HMPID, EMCAL, MCH and MID, with FOCAL retained as a comparison pattern.

The independent reviewers repeatedly reran repository-wide producer searches at the pinned AliceO2 source and found no Run-3 producer in:

```text
TOF
MFT
PHOS
CPV
FT0
FV0
FDD
ZDC
```

The Main Reviewer also reopened the relevant ProcessHits/Stepper source paths. No contradictory producer was found.

## 3.4 Important detector qualification: TRD

The source line:

```cpp
if ((!fMC->TrackCharge()) || fMC->IsTrackDisappeared()) {
  return false;
}
```

is real and occurs before the normal entry/exit reference block.

However, the implementation requirement should be phrased carefully:

```text
A track that genuinely dies inside TRD has not "exited" TRD.
The required persistent record is the common final TrackReference,
not a fabricated TRD exit reference.
```

Therefore no TRD-specific fake-exit modification is authorized by this audit.

## 3.5 Termination mechanisms and ordering

**CONFIRMED.**

Three O2 application cuts:

```text
TOFMAX
geometry/r-z filtering
user step filter
```

execute `StopTrack(); return;` before the optional current hook.

Geant4-VMC MaxNofSteps and tracking-region kills occur in the user stepping action.

At the audited Geant4 orientation source, the kernel calls the sensitive detector before the user stepping action in the same step. Therefore those VMC user-stepping kills are not reliably observed by the existing O2 stepping hook.

Physical/transport kills and world-exit semantics are separate mechanisms and can be visible earlier in the step.

`PostTrack()` remains the strongest common finalization candidate, but this audit does not approve a particular implementation.

## 3.6 Special cuts and termination reason

The source confirms configured engine cuts including:

```text
CUTGAM
CUTELE
CUTNEU
CUTHAD
CUTMUO
PPCUTM
TOFMAX
```

and Geant4-VMC special-cut handling.

The implementation design must therefore include these in the reason taxonomy/derivation discussion.

Some O2 and VMC kill sites lose the distinct reason by the time only a terminal track status remains. A minimal transient per-track reason set at the kill site is allowed for design consideration because it changes no persistent schema.

## 3.7 Historical AliRoot precedent

**CONFIRMED as orientation source, not production-era pin.**

The cited AliRoot commit writes `kDisappeared=-1` references for disappearing, non-alive tracks above the historical energy threshold.

This is valid evidence that a global disappeared-reference concept existed historically.

It is **not** yet evidence that the cited master commit exactly equals every Run-1/2 production configuration.

---

# 4. MIWikiAI readiness

## 4.1 Technical correctness

**YES — the source-audit conclusions are sufficiently source-confirmed for MIWikiAI technical review.**

No material source error was found in the v1.1 central conclusions.

## 4.2 Source-link strictness

**The primary v1.1 audit alone is not yet ideal as a strict MIWikiAI canonical/source-of-truth document.**

Reason: some normative rows name source paths or rely on repository-wide negative searches without carrying a direct immutable permalink on that row. In particular, direct links should be made explicit for:

```text
MFT
MCH
MID
O2MCApplication early-return paths
engine special cuts
Geant4 kernel ordering
monopole-specific termination anchors
```

The evidence is source-validated and is now recorded in this Review Summary, so the **pair**

```text
PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003.md
PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_1_20261003_Review_Summary.md
```

is suitable to send to MIWikiAI for review.

If MIWikiAI requires every normative source link to reside in the primary audit document itself, make one **documentation-only link-hardening revision**. That revision must not reopen the semantic audit or architecture.

## 4.3 Recommended MIWikiAI statement

```text
The source-semantic audit is approved in O2MCAI.
All immutable GitHub links embedded in v1.1 were independently re-opened at their
pinned commits by the Main Reviewer, and no wrong/broken link was found.
The companion Review Summary adds immutable anchors for normative rows that the
primary audit currently expresses only as paths/search evidence.
Implementation is not approved; bounded implementation design follows.
```

---

# 5. Carried P2 / advisory items for implementation design

## P2-1 — source-link hardening

Add direct immutable links to every normative row if the primary audit is promoted to MIWikiAI canonical/source-of-truth status.

## P2-2 — detector-core/envelope choices

For segmented detectors, choose a physics-meaningful detector-core/envelope boundary; do not create one pair per crystal/pad/tile/fibre.

## P2-3 — termination-reason encoding

Architect must confirm the intended existing TrackReference mechanism. No new persistent object is authorized.

## P2-4 — `PostTrack()` CHECK-1

Before code freeze, verify final:

```text
position
momentum
length
time
status
track identity
```

and ensure no duplicate final record and no false finalization of resumable states.

## P2-5 — TPC TrackReference time units

Current source stores:

```text
VMC-constructor TrackReference time: TrackTime() directly
TPC explicit-value TrackReference time: TrackTime() * 1e9
```

Do not silently normalize or perpetuate this inconsistency. Record an explicit compatibility decision before modifying TPC references.

## P2-6 — all-transported-particles requirement

Do not silently add an energy threshold or optical-photon exclusion merely to control output size.

Measure output growth and return to the Architect if the literal population requirement has unacceptable cost.

## P2-7 — provenance labels

For external/human readers:

```text
AliRoot source = orientation precedent unless production tag is pinned;
Geant4 kernel pin = semantic orientation unless production Geant4 is pinned;
runtime production settings = must be measured/pinned, not inferred from defaults.
```

---

# 6. Next gate

Do not run another broad source audit.

Proceed with a short bounded implementation-design/prototype document that cites this audit and resolves:

```text
1. detector-core/envelope boundary for each new producer;
2. exact existing-field termination-reason encoding;
3. CHECK-1 PostTrack final-state validity;
4. transient reason capture at kill sites if required;
5. no-duplicate final-reference rule;
6. TPC time-unit compatibility;
7. output-size / stored-MCTrack growth;
8. production/runtime configuration pin;
9. backend scope/parity.
```

Then review the exact code candidate separately.

---

# 7. Final Main Reviewer decision

```text
Source-audit correctness:              APPROVED
Embedded immutable GitHub links:       ALL RE-OPENED / NO BAD LINK FOUND
Supplemental missing source anchors:    CHECKED AND LISTED HERE
P0:                                    0
P1:                                    0
P2/advisory:                           carried above
Architecture drift:                    NONE
New persistent data model:             NOT AUTHORIZED / NOT REQUIRED
Human ALICE circulation:               APPROVED
MIWikiAI technical review package:      READY AS AUDIT + THIS SUMMARY
MIWikiAI standalone-primary-doc status: LINK HARDENING ADVISED
Implementation:                        NOT APPROVED
Next step:                             BOUNDED IMPLEMENTATION DESIGN / PROTOTYPE
```

Formal statement:

```text
PHASE_0_4_O2MCAI TrackReference Source Audit v1.1 APPROVED
SOURCE-SEMANTIC AUDIT MAY PROCEED TO BOUNDED IMPLEMENTATION DESIGN
```

**Signed:**
`GPT3:O2MCAI`
Main Reviewer
GPT-5.6 Sol
2026-10-03
