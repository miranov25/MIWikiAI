# PHASE_0_4_O2MCAI — TrackReference Source Audit

**Version:** v1.1 — source-audit result for formal confirmation  
**Date:** 2026-10-03  
**Project:** O2MCAI  
**Architect:** Marian Ivanov  
**Main Reviewer:** `GPT1:O2MCAI`  
**Reviewer architecture/model:** GPT-5.6 Sol  
**Status:** audit result; implementation not yet approved  
**Supersedes:** `PHASE_0_4_O2MCAI_TrackReference_Source_Audit_v1_0_20261003.md`

---

# 0. Frozen Architect requirements

These requirements are controlling for PHASE_0_4:

```text
TrackReference schema unchanged.
Use existing mStatus mechanism.
Add missing detector entry/exit TrackReferences.
Catch all termination/disappearance mechanisms.
Minimal localized O2 modification.
No alternative persistent data model unless explicitly requested by the Architect.
```

The original physics requirement also explicitly applies to **all particles**, including charged and neutral particles. This v1.1 therefore does **not** silently narrow the scope to charged tracks.

If source evidence appears incompatible with the frozen architecture:

```text
STOP.
Record the exact source conflict.
Ask the Architect.
Do not invent a new persistent object or data model.
```

---

# 1. The central audit question

> **For every transported particle whose trajectory terminates, disappears, or leaves transport — independent of detector, volume, or termination mechanism — does O2 persist exactly one final `TrackReference` from which the final transport state and the termination reason can be recovered, while avoiding false final records for non-terminal suspended/interrupted tracks?**

This includes, at minimum:

```text
normal physical stop / range-out
world exit
decay / annihilation / absorption / inelastic parent termination
O2 TOFMAX
O2 geometry / r-z filtering
O2 user step filter
Geant4-VMC MaxNofSteps → grace counter → kill
tracking-region kill
transport looper kill
monopole-specific looper / world exit
pair-cut / special-cut paths where a transported trajectory is ended
detector-local StopTrack paths where relevant
```

Particles that are **never transported** are recorded separately; they do not have a transported trajectory for which a final TrackReference can be written.

## 1.1 Current answer

**NO. Current O2 does not catch all transported-particle terminations in persistent TrackReferences.**

The source audit establishes that:

```text
- the standard final TrackReference hook is disabled by default;
- it is narrower than the historical AliRoot disappeared-reference mechanism;
- O2 TOFMAX / geometry / user-filter paths return before the hook;
- Geant4-VMC MaxNofSteps/region termination is decided after the normal application Stepping callback;
- the current mStatus word records transport state, not a complete termination-cause taxonomy;
- several detector producers are missing entry/exit references;
- several existing producers either suppress neutrals or write mStatus=0.
```

A common `PostTrack()` finalization path is the strongest source-backed minimal candidate for complete transported-track finalization, but two small runtime/backend checks remain before code is frozen (§9).

---

# 2. Source provenance used for this audit

| Component | Repository | Source identity | Audit status |
|---|---|---|---|
| AliceO2 common simulation / TrackReference | `AliceO2Group/AliceO2` | `5b009ee93bd75b0d03183b79ca8388b5b7b6e479` | validated by multiple reviewers |
| AliceO2 TPC | `AliceO2Group/AliceO2` | `86a1ec8dcb984ace1443ce82fe19c76bb6321c8a` | validated |
| Geant4-VMC | `vmc-project/geant4_vmc` | `024fccb9fec1154338164c1fc9c31e2ecbbc089c` | validated by multiple reviewers |
| AliRoot orientation baseline | `alisw/AliRoot` | `46f8b62b1c76705c6c03768972a83b3b43e07789` | validated as source precedent; production-era tag still to pin |
| Geant4 kernel | reviewer orientation pin `v11.4.3` / `2ee379e6843e55b9c6bbb835d2a2b03cc998fef0` | not yet tied to production | source semantics only |

Production/runtime values are not inferred from defaults. The actual monopole production still needs its effective O2/Geant4 configuration pinned separately.

---

# 3. TrackReference data-model result

## 3.1 `mStatus`

Source:

https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/DataFormats/simulation/include/SimulationDataFormat/TrackReference.h

`SimTrackStatus::mStatus` is an `unsigned char` with seven defined bits:

```text
bit 0  Entering
bit 1  Inside
bit 2  Exiting
bit 3  Out
bit 4  Stopped
bit 5  Alive
bit 6  New
bit 7  unused
```

**Audit result:** exactly one bit is unused. The existing bits describe transport state; they do not by themselves encode a multi-valued termination cause.

## 3.2 Constructor semantics

The VMC constructor initializes `mStatus` from `SimTrackStatus(vmc)`.

The explicit-value constructor does **not** initialize `mStatus` from VMC. The default status therefore remains zero.

**Consequence:** a producer may create an entry/exit TrackReference while persisting no entry/exit status bit.

This is the current situation for the audited TPC boundary/internal references and for the existing EMCAL/FOCAL superparent references.

## 3.3 `mUserId`

`TrackReference` contains `Int_t mUserId = 0`.

Source-wide usage shows detector-local meanings, including ITS layer and MCH/MID detection element IDs. Existing readers at the pinned source first select detector identity before interpreting these values.

**Audit result:** detector-local `mUserId` meanings must not be overwritten.

A termination reason code in `mUserId` **only on a global final reference with `mDetectorId == -1`** is technically available at the audited source and does not collide with the audited detector-specific readers. It remains an Architect choice, not a source fact (§8).

## 3.4 TrackReference persistence affects MCTrack storage

Source:

https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/Base/include/DetectorsBase/Stack.h

`Stack::addTrackReference()` marks secondaries for persistent storage and appends the reference.

**Consequence:** satisfying the literal all-particles requirement can increase the number of stored MCTracks and ROOT output size. This impact must be measured; it is not a reason to silently narrow the physics requirement.

---

# 4. Repository-wide detector producer audit

Repository-wide searches used by independent reviewers included:

```bash
git grep -n -E 'addTrackReference|AddTrackReference' \
  5b009ee93bd75b0d03183b79ca8388b5b7b6e479 -- .

git grep -n -E 'TrackReference\(|TrackReference tr|TrackReference trackref|mTrackRefs' \
  5b009ee93bd75b0d03183b79ca8388b5b7b6e479 -- \
  Detectors Steer run DataFormats Generators Common
```

Positive controls found the known ITS, TPC, TRD, HMPID, EMCAL, FOCAL, MCH, MID and upgrade producers plus the global hook.

For the Run-3 detector trees below, the same source search found no TrackReference producer in:

```text
TOF
MFT
PHOS
CPV
FIT (FT0/FV0/FDD)
ZDC
```

The Run-3 audit scope is the ALICE2 transport/hit detector set. FOCAL, ITS3 and ALICE3 upgrade producers are retained as comparison patterns but are not part of the Run-3 patch unless the Architect broadens scope. CTP has no normal detector `ProcessHits` transport role and is not an entry/exit TrackReference target.

---

# 5. Detector result table

"Gap" below means a mismatch with the frozen PHASE_0_4 requirement, not necessarily a bug under the previous production contract.

| Detector | Current TrackReference behavior | Status / gate behavior | PHASE_0_4 gap | Minimal source area |
|---|---|---|---|---|
| **ITS** | exit reference on sensitive sensor layers | charged gate; VMC ctor; `mUserId=layer` | detector-core entry missing; neutral particles excluded; existing exit is per-layer rather than explicitly defined core boundary | `Detectors/ITSMFT/ITS/simulation/src/Detector.cxx` |
| **MFT** | no producer found | charge-gated hit path | detector-core entry + exit missing; neutral particles excluded by current hit gate if producer is inserted after it | `Detectors/ITSMFT/MFT/simulation/src/Detector.cxx` |
| **TPC** | entry + exit + periodic reference every ~15 cm track length | charge gate; explicit-value ctor → **`mStatus=0`** | status bits missing on existing refs; neutral/fractional-charge tracks rejected before refs | `Detectors/TPC/simulation/src/Detector.cxx` |
| **TRD** | drift-region entry + amplification-region exit | charged gate; VMC ctor; **returns early on `IsTrackDisappeared()` before reference block** | neutral particles excluded; disappearing track can miss normal detector exit reference | `Detectors/TRD/simulation/src/Detector.cxx` |
| **TOF** | no producer found | charge + Edep gates | detector-core entry + exit missing; producer must be placed so Edep gate does not erase boundary refs | `Detectors/TOF/simulation/src/Detector.cxx` |
| **HMPID** | entry reference at pad volumes | charged gate; VMC ctor | exit missing; neutral particles excluded; exact core boundary should be confirmed | `Detectors/HMPID/simulation/src/Detector.cxx` |
| **EMCAL/DCAL** | one superparent reference at first energy deposit, not a boundary pair | explicit-value ctor → **`mStatus=0`** | true detector-core entry + exit missing; preserve superparent semantics; avoid per-tile shower refs | `Detectors/EMCAL/simulation/src/Detector.cxx` |
| **PHOS** | no producer found | energy-deposit/shower logic | detector-core entry + exit missing; boundary must be envelope/core, not per crystal | `Detectors/PHOS/simulation/src/Detector.cxx` |
| **CPV** | no producer found | charged hit path; entering-only control flow exists | entry + exit missing; exit producer must be placed before entering-only return can suppress it | `Detectors/CPV/simulation/src/Detector.cxx` |
| **MCH** | entry + exit per detection element | charged gate; VMC ctor; `mUserId=detElemId` | literal all-particles goal requires neutral coverage without changing local ID meaning | `Detectors/MUON/MCH/Simulation/src/Stepper.cxx` |
| **MID** | entry + exit per detection element | charged gate; VMC ctor; `mUserId=detElemId` | same all-particles qualification as MCH | `Detectors/MUON/MID/Simulation/src/Stepper.cxx` |
| **ZDC** | no producer found | envelope/sensitive substructure | detector-core entry + exit missing; choose envelope/core boundary, not fibre/cell boundary | `Detectors/ZDC/simulation/src/Detector.cxx` |
| **FT0** | no producer found | charged/optical-photon handling | detector-core entry + exit missing | `Detectors/FIT/FT0/simulation/src/Detector.cxx` |
| **FV0** | no producer found | charged-or-photon path already tests entering/exiting for hits | TrackReference entry + exit missing | `Detectors/FIT/FV0/simulation/src/Detector.cxx` |
| **FDD** | no producer found | charged gate | detector-core entry + exit missing; neutral population currently excluded | `Detectors/FIT/FDD/simulation/src/Detector.cxx` |

## 5.1 Key source links

TPC:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/TPC/simulation/src/Detector.cxx#L112-L170

ITS:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/ITSMFT/ITS/simulation/src/Detector.cxx#L318-L344

TRD:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/TRD/simulation/src/Detector.cxx#L117-L203

TOF:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/TOF/simulation/src/Detector.cxx#L75-L90

HMPID:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/HMPID/simulation/src/Detector.cxx#L115-L140

EMCAL:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/EMCAL/simulation/src/Detector.cxx#L170-L289

PHOS:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/PHOS/simulation/src/Detector.cxx#L130-L170

CPV:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/CPV/simulation/src/Detector.cxx#L113-L133

ZDC:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/ZDC/simulation/src/Detector.cxx#L394-L426

FT0:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FIT/FT0/simulation/src/Detector.cxx#L1101-L1138

FV0:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FIT/FV0/simulation/src/Detector.cxx#L79-L97

FDD:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/FIT/FDD/simulation/src/Detector.cxx#L103-L108

---

# 6. Termination / disappearance result table

## 6.1 Current global hook

Source:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Detectors/gconfig/src/StandardSteppingTrackRefHook.macro

Configuration:
https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Common/SimConfig/include/SimConfig/SimParams.h

Current behavior:

```text
if IsTrackStop()
and currentTrackLeftTrackRef()
    add TrackReference(*vmc, -1)
```

`stepTrackRefHook` is default-off in the audited source.

Important qualifications:

```text
- currentTrackLeftTrackRef() narrows the population and does not satisfy the literal all-particles goal;
- IsTrackStop() includes some non-terminal states in Geant4-VMC;
- the hook is called from O2 application Stepping() before FairRoot detector dispatch.
```

## 6.2 Complete mechanism table

| Mechanism | Current source behavior | Final TrackReference today | Reason/state quality | Audit disposition |
|---|---|---|---|---|
| **O2 TOFMAX** | `StopTrack(); return;` before hook | none through current hook | no persisted final reason | **gap confirmed** |
| **O2 geometry / r-z filter** | `StopTrack(); return;` before hook | none through current hook | no persisted final reason | **gap confirmed** |
| **O2 user step filter** | `StopTrack(); return;` before hook | none through current hook | no persisted final reason | **gap confirmed** |
| **MaxNofSteps** | exceeding max steps starts grace counter; kill occurs after additional loop steps | current Stepping hook does not provide reliable catch-all | no distinct persisted reason | **gap confirmed; one MaxNofSteps → grace-counter → kill mechanism** |
| **tracking-region kill** | Geant4-VMC user stepping action can set `fStopAndKill` | no complete common final record | no distinct reason | **gap confirmed** |
| **PPCUTM / pair-cut suppression** | special control can suppress/stop low-energy pair products | no general termination record | not represented as requested reason | **classify separately in implementation** |
| **world exit** | transport marks world-boundary / out state | state can be distinguishable via `Out` when captured | cause world exit can be recognized from state | **final record still required for complete population** |
| **physical stop / range-out** | may pass through `fStopButAlive` then terminal state after at-rest processing | current state bits do not encode physical cause | stopped state only | **final record + reason required** |
| **decay / annihilation / absorption / inelastic parent termination** | physics process terminates parent | state may become stopped/disappeared | current `mStatus` does not encode which process caused termination | **final record + reason required** |
| **Geant4 transportation looper kill** | transport-level looper protection can kill charged tracks | no distinct persistent final reason | stopped state only if captured | **separate from MaxNofSteps grace counter** |
| **monopole transportation looper / world exit** | monopole transport contains its own looper/world-exit paths in Geant4-VMC | no distinct persistent reason today | especially relevant to current monopole study | **explicit audit row; production activation must be pinned** |
| **suspend / postpone** | `IsTrackStop()` can be true although transport is not permanently finished | current hook can misclassify as final | false-terminal risk | **must not generate final termination record** |
| **detector-local `StopTrack()` paths** | detector-specific cases exist | not systematically represented | mechanism-specific | **classify when in PHASE population** |
| **never-transported particles** | stacking/generator logic can suppress before trajectory starts | no final ref possible because no trajectory existed | use transport/population metadata | **outside transported-trajectory finalization** |
| **Geant3 equivalents** | not fully source-closed in this round | unknown | unknown | **required only if Geant3 remains in scope** |

## 6.3 MaxNofSteps source ordering

Source:
https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4SteppingAction.cxx

The audited source shows:

```text
step exceeds fMaxNofSteps
→ start fLoopStepCounter
→ after kMaxNofLoopSteps additional steps
→ set fStopAndKill
```

Transport-looper protection and monopole-specific looper protection remain separate mechanisms.

---

# 7. Historical Run-1/2 precedent

AliRoot source:

https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/STEER/STEER/AliMC.cxx#L1507-L1520

https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/STEER/STEERBase/AliTrackReference.h#L20-L38

At the audited AliRoot commit:

```cpp
if (fMC->IsTrackDisappeared() && !(fMC->IsTrackAlive())) {
  if (fMC->Etot() > 0.05) {
    AddTrackReference(currentTrackNumber,
                      AliTrackReference::kDisappeared);
  }
}
```

with `kDisappeared = -1`.

This confirms a historical global disappeared-reference precedent.

Differences from current O2 include:

```text
AliRoot used IsTrackDisappeared rather than IsTrackStop;
AliRoot did not require the track to have an earlier TrackReference;
current O2 hook is default-off;
several detector producers present historically have no Run-3 equivalent.
```

A production-era AliRoot tag should still be pinned before publication as the exact Run-1/2 production reference.

---

# 8. Architect decision exposed by the source audit

## AQ1 — termination reason encoding

Requirement:

```text
TrackReference schema unchanged.
Use the existing TrackReference/status mechanism.
Persist a reliable termination reason.
```

Source fact:

```text
mStatus has 8 bits total;
7 are already defined as transport-state bits;
1 is unused;
the requested termination taxonomy has more than two values.
```

Therefore `mStatus` alone cannot encode all named termination causes without changing its semantics.

A source-compatible schema-neutral candidate is:

```text
global final TrackReference:
    mDetectorId = -1
    mStatus     = existing transport-state snapshot
    mUserId     = termination-reason code
```

At the pinned source, audited `mUserId` readers are detector-specific and do not interpret `mUserId` on detector ID `-1`.

**Architect action required before implementation:** confirm this use, or identify the intended existing second bitmask/mechanism.

This is the only persistent-encoding decision. It must not reopen a new-data-model discussion.

---

# 9. Minimal implementation direction derived from the audit

This section records code areas implied by the source audit. It is **not implementation approval**.

## 9.1 Detector entry/exit changes

Expected localized modifications:

```text
ITS         add detector-core entry handling
MFT         add entry + exit
TPC         preserve existing refs but populate mStatus correctly
TRD         preserve entry/exit and close disappeared-track/final gap
TOF         add entry + exit before Edep gating erases boundary information
HMPID       add exit
EMCAL       keep superparent ref; add true core entry + exit
PHOS        add core entry + exit
CPV         add entry + exit before entering-only control flow suppresses exit
MCH/MID     preserve local mUserId; extend population to satisfy all-particles requirement
ZDC         add entry + exit at core/envelope boundary
FT0/FV0/FDD add entry + exit
```

For segmented detectors, insertion must be at the **detector-core/envelope boundary**, not blindly in every sensitive crystal/pad/cell.

## 9.2 TPC status correction

Because the explicit-value constructor leaves `mStatus=0`, the minimal source-compatible pattern is:

```text
construct from VMC so mStatus is populated
then restore the existing TPC-specific time convention with setTime(...)
```

This avoids silently changing the existing TPC time representation.

## 9.3 Common final TrackReference candidate: `PostTrack()`

Geant4-VMC source:

https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4TrackingAction.cxx

For finished, non-suspended, non-interrupted tracks, Geant4-VMC calls `fMCApplication->PostTrack()`.

AliceO2 currently overrides `PreTrack()` but not `PostTrack()`:

https://github.com/AliceO2Group/AliceO2/blob/5b009ee93bd75b0d03183b79ca8388b5b7b6e479/Steer/include/Steer/O2MCApplicationBase.h

This is the strongest current minimal common finalization site because it is tied to track completion rather than to one particular stepping cut.

A correct PHASE_0_4 implementation must **not** silently retain the old `currentTrackLeftTrackRef()` population guard if the contract is all transported particles. If every transported track receives a final reference, output-size impact must be measured.

## 9.4 Two checks required before freezing `PostTrack()` implementation

### CHECK-1 — final VMC state validity

In a controlled simulation, verify that within `PostTrack()`:

```text
TrackPosition
TrackMomentum
TrackLength
TrackTime
IsTrackOut
IsTrackStop / disappeared semantics
```

still describe the final state needed for the persistent final TrackReference.

### CHECK-2 — backend equivalence

Verify the same finalization contract for every transport backend that remains in scope.

For current monopole/Run-3 work, Geant4/Geant4-VMC is primary. If Geant3 compatibility is required by PHASE_0_4, verify its `PostTrack()` equivalent before implementation approval.

---

# 10. What is answered versus what remains

## Source questions answered

```text
YES — current TrackReference schema/status behavior is known.
YES — existing detector producers have been enumerated.
YES — missing Run-3 producers have been identified by repository-wide search.
YES — TPC/EMCAL/FOCAL zero-status constructor behavior is identified.
YES — O2 early-return termination gaps are identified.
YES — MaxNofSteps grace-counter semantics are identified.
YES — additional termination classes omitted from v1.0 are now listed.
YES — historical AliRoot disappeared-reference behavior is source-confirmed at the orientation commit.
YES — a minimal common finalization candidate exists: PostTrack().
```

## Remaining before implementation approval

```text
1. Architect chooses/identifies the existing termination-reason encoding mechanism.
2. CHECK-1 validates last-state access in PostTrack().
3. CHECK-2 validates every transport backend that remains in scope.
4. Detector-core/envelope volume is fixed for segmented detectors.
5. Output-size / stored-MCTrack growth is measured in a focused prototype.
6. Production/runtime configuration is pinned for the monopole sample.
```

These are **not another audit-question round**. They are bounded implementation-gate items derived from the completed source investigation.

---

# 11. Formal review target for v1.1

The formal v1.1 review should answer:

```text
A. Are the detector observations source-correct and complete for Run-3 scope?
B. Are the termination/disappearance mechanisms source-correct and complete?
C. Does the audit correctly answer the central question:
   "Do we currently catch every transported-particle termination?"
D. Are all gaps and minimal code sites derived from source rather than speculative design?
E. Are remaining Architect/runtime decisions correctly separated from source facts?
F. Has the earlier architecture drift stayed removed?
```

Required verdict:

```text
[OK]  v1.1 source audit approved; source investigation complete enough to proceed to bounded implementation design
[!]   source audit approved with P2/advisory corrections only
[X]   material source observation remains wrong/incomplete
```

Implementation is **not** approved by approval of this audit.

---

# 12. v1.1 conclusion

```text
Current O2 does NOT persist a complete final TrackReference for every transported
particle termination/disappearance, and several Run-3 detectors do not provide the
requested detector-core entry/exit TrackReferences.

The missing behavior can be repaired using the existing TrackReference object and
existing Stack persistence path. The strongest common finalization candidate is an
O2MCApplicationBase::PostTrack() override, with localized detector producer additions.

No alternative persistent data model is needed.
```

The next gate is **formal source-audit approval**, followed by the two bounded `PostTrack()` checks and the Architect's termination-reason encoding decision.
