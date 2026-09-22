---
doc_id: TPC_MCHitCreation_SourceOfTruth
doc_type: source-of-truth
project: MIWikiAI
originating_team: O2MCAI
maintainer: MIWikiAI
technical_owner: O2MCAI
version: v1.2
date: 2026-09-22
status: REVIEWED_EXTERNAL_TEAM_VERIFIED__MIWIKIAI_ADAPTED
provenance_class: EXTERNAL_TEAM_VERIFIED
canonical_format: Markdown
source_scope: ALICE_O2_Run3_TPC_MC_hit_creation
upstream:
  repository: https://github.com/AliceO2Group/AliceO2
  primary_reviewed_commit: 86a1ec8dcb984ace1443ce82fe19c76bb6321c8a
  earlier_equivalent_tpc_audit_commit: 5b009ee93bd75b0d03183b79ca8388b5b7b6e479
  open_monopole_pr_head_review_evidence: 26f3cee935d09843131d091bd9bca402d85797dd
source_status:
  master_dev_tpc_model: SOURCE_CERTIFIED
  open_monopole_pr: REVIEWER_VERIFIED_OPEN_PR_SNAPSHOT__NOT_MERGED
  monopole_production_configuration: OPEN
  aliroot_run2_monopole_model: NOT_YET_SOURCE_AUDITED
known_verify_flags:
  - current monopole production SHA/configuration
  - actual TVirtualMC::TrackCharge() for monopole production
  - actual TPCDetParam.UseGeant4Edep for monopole production
  - historical AliRoot monopole implementation
  - physics validation of open PR monopole Edep path against ALICE reference
cross_references:
  - ./MonteCarlo_v0_1.md
  - ./DataFormats_AO2D_v0_5_1.md
  - ../../TPC_SourceOfTruth_v0_3.md
review_lineage:
  source_panel: O2MCAI four-reviewer source review
  cross_team_review: MIWikiAI + O2MCAI
  publication_note: not an official ALICE Collaboration document unless separately adopted
---

# TPC MC Hit Creation — Source of Truth

This page is the MIWikiAI publication adaptation of the detailed O2MCAI source review.
O2MCAI remains the technical/source-model owner; MIWikiAI maintains the publication form,
provenance grammar, and cross-references.

**Authority rule.** Normative source claims in this page are anchored to the exact AliceO2 commits
listed in the front matter. Public Doxygen checks are corroborating evidence only, not the primary
source identity. The open monopole pull-request snapshot is recorded as review evidence and is
explicitly **not** the merged/canonical AliceO2 baseline.

Related MIWikiAI pages:

- [`MonteCarlo_v0_1.md`](./MonteCarlo_v0_1.md) — general O2 MC truth/data model.
- [`DataFormats_AO2D_v0_5_1.md`](./DataFormats_AO2D_v0_5_1.md) — AO2D data model and MC table relations.
- [`TPC_SourceOfTruth_v0_3.md`](../../TPC_SourceOfTruth_v0_3.md) — TPC detector source-of-truth baseline.

## 0. Executive summary

This document reconstructs, from the reviewed AliceO2 source, how a particle transported through the ALICE Run-3
simulation becomes:

1. a transport step;
2. optionally a `TrackReference`;
3. a detector-specific MC hit;
4. a persisted `MCTrack`;
5. a TPC ionisation-electron hit;
6. and finally a TPC digit / ADC response.

The most important conclusion for the present magnetic-monopole work is:

> **The default Run-3 TPC hit-ionisation path does not use Geant4 `Edep()` directly.**
> It uses an ALICE/O2 implementation attributed in the source to
> **GEANT3 ILOSS model 5 / `gfluct.F` / the NA49 single-collision model**.

A second, opt-in branch exists:

```text
TPCDetParam.UseGeant4Edep = true
```

and this branch converts the transport-engine energy deposit into an electron count.

The default TPC ionisation model is explicitly based on ordinary electric charge:

```text
meanNcoll ∝ stepSize × TrackCharge()² × primaryElectronsPerCM
```

and a track for which:

```text
static_cast<int>(TrackCharge()) == 0
```

is rejected from the normal TPC hit-electron path before ionisation is generated.

Therefore the standard default TPC hit-ionisation model must **not** be assumed correct for a magnetic monopole.

The second major conclusion is semantic:

> The historical TPC hit quantity exposed as `mELoss` / `GetEnergyLoss()` is, in the reviewed O2 path,
> actually the **number of ionisation electrons** passed to the TPC digitizer.

For O2MCAI analysis this quantity should therefore be represented as:

```text
nElectrons
```

rather than as an energy in GeV.

---

## 1. Reviewed source versions

Two exact AliceO2 source snapshots were independently reviewed.

### 1.1 Detailed TPC ionisation audit

```text
repository  https://github.com/AliceO2Group/AliceO2
commit      5b009ee93bd75b0d03183b79ca8388b5b7b6e479
date        2026-09-20T00:18:52+02:00
message     fix int/uint comparison (#15819)
```

Primary files read:

```text
Detectors/TPC/simulation/src/Detector.cxx
Detectors/TPC/simulation/include/TPCSimulation/Detector.h
Detectors/TPC/simulation/include/TPCSimulation/Point.h
Detectors/TPC/simulation/src/Digitizer.cxx
Detectors/TPC/base/include/TPCBase/ParameterGas.h
Detectors/TPC/base/include/TPCBase/ParameterDetector.h
Detectors/TPC/simulation/data/simcuts.dat
Detectors/TPC/simulation/README.md
```

### 1.2 Newer end-to-end hit-chain audit

```text
repository  https://github.com/AliceO2Group/AliceO2
commit      86a1ec8dcb984ace1443ce82fe19c76bb6321c8a
date        2026-09-22T20:01:27+02:00
message     GPUTracking: drop static from the function-scope constants
```

Additional source read:

```text
Steer/src/O2MCApplication.cxx
Steer/include/Steer/O2MCApplicationBase.h
Detectors/Base/src/Stack.cxx
Detectors/Base/include/DetectorsBase/Stack.h
Detectors/Base/include/DetectorsBase/Detector.h
DataFormats/simulation/include/SimulationDataFormat/BaseHits.h
Steer/include/Steer/HitProcessingManager.h
Common/SimConfig/include/SimConfig/SimParams.h
Common/SimConfig/include/SimConfig/GlobalProcessCutSimParam.h
Detectors/TPC/simulation/src/Detector.cxx
Detectors/gconfig/*
```

The newer review independently re-verified all load-bearing TPC anchors from the earlier review.

A later source reviewer additionally executed a direct tree comparison over the reviewed TPC source scope:

```text
git diff 5b009ee93bd75b0d03183b79ca8388b5b7b6e479 86a1ec8dcb984ace1443ce82fe19c76bb6321c8a \
    -- Detectors/TPC/simulation/ \
       Detectors/TPC/base/include/TPCBase/ParameterGas.h \
       Detectors/TPC/base/include/TPCBase/ParameterDetector.h
```

and reported an empty diff. For that reviewed TPC scope, the source bytes are therefore identical at
the two pinned commits. This is stronger than a line-number comparison: the earlier detailed TPC audit
transfers to the newer pinned snapshot for those files.

### 1.3 Current-source consistency check

Two reviewers also checked the public AliceO2 Doxygen rendering on 2026-09-22 and found the same
relevant TPC logic. These Doxygen checks are **corroborating but non-reproducible** because they were
not tied to immutable source bytes. They are not used as the primary source identity for this page.

---

## 2. General O2 simulation architecture

The O2 simulation separates:

```text
transport
detector hit creation
track bookkeeping
persistence
digitisation
```

These are related but distinct layers.

The high-level chain is:

```text
generator
   |
   v
Stack receives primaries
   |
   v
TVirtualMC transport engine
(typically Geant4, but the interface also supports Geant3 / FLUKA)
   |
   v
O2MCApplicationBase::Stepping()
   |
   +--> global time / geometry / optional custom step cuts
   |
   v
FairMCApplication::Stepping()
   |
   v
detector-specific ProcessHits(FairVolume*)
   |
   +--> detector-defined hit object
   +--> Stack::addHit(detID)
   +--> optional TrackReference
   |
   +------------------------+
   |                        |
   v                        v
o2sim_Hits<DET>.root     Stack::selectTracks()
                            |
                            v
                     MCTrack + TrackReferences
                       in o2sim_Kine.root

later:
o2sim_Hits<DET>.root
   |
   v
HitProcessingManager / DigitizationContext
   |
   v
per-detector digitizer
   |
   v
digits
```

The important architectural rule is:

> **The framework dispatches the step; the detector decides what a hit means.**

There is no universal O2 rule saying that every detector hit must be an energy deposit.

---

## 3. What happens before a detector sees the step

At the newer reviewed source, the general O2 stepping path is handled in:

```text
O2MCApplicationBase::Stepping()
```

before control is forwarded to FairRoot and the detector.

The reviewed source applies several global checks.

### 3.1 Time-of-flight cut

A track step is stopped if its time of flight exceeds the configured limit.

Reviewed default:

```text
TOFMAX = 0.1 s
```

This cut is independent of detector-specific physics.

### 3.2 Geometry step filtering

Geometry-dependent filtering can kill a track step before a detector sees it.

This includes z/r-dependent acceptance logic and a wider tunnel region for the ZDC.

### 3.3 Optional user step filter

A user-configurable step-filter macro may kill arbitrary steps.

This is important for provenance: a missing hit can be due to configuration, not detector physics.

### 3.4 Optional general TrackReference hook

O2 also supports a configurable stepping hook that may add TrackReferences independently of detector-specific
`ProcessHits()` code.

Therefore a TrackReference is not necessarily evidence that the detector hit path was executed.

---

## 4. Detector-specific hit semantics

The detector base classes define interfaces for hit collection and persistence, but they do not impose one physical
meaning on the hit payload.

Common helper hit types include position/time plus one stored quantity, for example:

```text
energy-like quantity
charge-like quantity
```

but detectors are free to use their own hit objects.

The TPC is a particularly important example because the historically energy-like field actually stores an
ionisation-electron count.

---

## 5. TPC `ProcessHits()` entry point

The central TPC hit-creation implementation is:

```text
Detectors/TPC/simulation/src/Detector.cxx
o2::tpc::Detector::ProcessHits(FairVolume*)
```

At the audited source this function starts around:

```text
Detector.cxx:112
```

and is called for sensitive TPC volumes.

Conceptually, one invocation corresponds to the current transport step inside a TPC-sensitive volume.

---

## 6. Early electric-charge gate

Before the TPC ionisation model is evaluated, the reviewed code obtains:

```cpp
const double trackCharge = fMC->TrackCharge();
```

and applies:

```cpp
if (static_cast<int>(trackCharge) == 0) {
    fMC->SetMaxStep(1.e10);
    return kFALSE;
}
```

The detailed review anchored this at approximately:

```text
Detector.cxx:122-128
```

This means:

```text
TrackCharge interpreted as zero
        |
        v
normal TPC hit path exits
        |
        +--> no ionisation-electron hit from this path
```

This condition is one of the most important facts for magnetic-monopole simulation.

Because the condition casts to `int`, any non-zero `TrackCharge()` with magnitude below one is also truncated to zero by this gate. This is relevant to fractionally charged particles and to any hypothetical monopole workaround using a small effective electric charge.

### 6.1 Field-cage gap suppression

[DIRECT — reviewed source at `86a1ec8dcb984ace1443ce82fe19c76bb6321c8a`]

The same `ProcessHits()` path contains a second early hit-suppression gate controlled by:

```text
TPCDetParam.ExcludeFCGap
```

with reviewed default `true`. The gate rejects TPC hits in the field-cage gap / rod region using
radial and local-sector geometry cuts. The reviewed source reports representative constants including
`rodRin = 83.7 cm`, `fcLxIn = 82.428409 cm`, and `fcLxOut = 252.55395 cm`.

Therefore a charged track inside the broad TPC volume can legitimately have no TPC hit for a geometric
reason, independently of the electric-charge/monopole issue. This distinction is important when
diagnosing missing hits close to field-cage boundaries.

---

## 7. TPC transport-step control

The TPC hit code also limits the maximum transport step to roughly:

```text
0.2 cm ± 0.05 cm
```

i.e.

```text
2 mm ± 0.5 mm
```

The reviewed source does this with a random jitter.

The source comment attributes the tuning to Geant4-related step control, while the randomisation avoids regular
binning artifacts.

This step size is part of the sampling granularity of the TPC ionisation model.

---

## 8. TPC TrackReferences

The TPC hit code also creates TrackReferences.

The reviewed source defines the compile-time constant:

```text
kMaxDistRef = 15 cm
```

The comparison is exact in the reviewed source; the physical sampling remains sparse because references
are emitted only when the relevant boundary/path-length conditions are satisfied.

and adds references:

- on entering;
- on exiting;
- and after sufficient accumulated path-length advance.

Thus the TPC TrackReference stream is not a step-by-step record of the TPC hit-ionisation model.

A simplified picture is:

```text
transport steps every ~mm scale
     |
     +--> TPC hit ionisation evaluated repeatedly
     |
     +--> TrackReference only at sparse conditions (~15 cm + boundaries)
```

This distinction is essential when comparing:

```text
TrackReference-derived dE/dx
```

against:

```text
TPC hit nElectrons
```

---

## 9. Default TPC ionisation mode

The source-controlled switch is:

```text
TPCDetParam.UseGeant4Edep
```

with reviewed default:

```text
false
```

When false, O2 executes its own ionisation model.

The source explicitly attributes the implementation to:

```text
GEANT3 ILOSS model 5
gfluct.F
NA49 model
```

The detailed review anchors the attribution comment around:

```text
Detector.cxx:194-199
```

and the main default-model code around:

```text
Detector.cxx:213-250
```

---

## 10. Default ionisation algorithm in detail

The reviewed algorithm can be represented as follows.

### 10.1 Compute beta-gamma

```text
betaGamma = |p| / mass
```

with a lower floor near:

```text
7 × 10^-3
```

### 10.2 Compute primary-ionisation density

The primary-collision density is parameterised as:

```text
primaryElectronsPerCM =
    Nprim × BetheBlochAleph(betaGamma, kp1..kp5)
```

The velocity dependence enters primarily through this Bethe-Bloch-like term.

### 10.3 Compute expected collision count

```text
meanNcoll =
    stepSize
    × trackCharge²
    × primaryElectronsPerCM
```

The charge scaling is therefore:

```text
q²
```

with `q` taken from VMC `TrackCharge()`.

### 10.4 Sample actual number of collisions

```text
nColl ~ Poisson(meanNcoll)
```

This introduces step-to-step primary-ionisation fluctuations.

### 10.5 Sample a single-collision energy loss

For each collision, the energy transfer is sampled from a power-law distribution:

```text
P(E) ∝ E^(-Exp)
```

bounded between:

```text
Ipot
Eend
```

The source structure is approximately:

```text
kMin = Ipot^(1-Exp)
kMax = Eend^(1-Exp)

eDep =
    [(kMax-kMin)*rndm + kMin]^(1/(1-Exp))
```

### 10.6 Convert sampled collision loss to electrons

For each sampled collision:

```text
nElectrons_collision =
    int((eDep - Ipot)/Wion + 1)
```

then cap by:

```text
MaxElePerStep
```

and accumulate:

```text
nElectrons_total += nElectrons_collision
```

The resulting total is what enters the TPC hit.

---

## 11. Relevant reviewed TPC gas defaults

From `ParameterGas.h`:

| Parameter | Reviewed default | Meaning |
|---|---:|---|
| `Wion` | 37.3 eV | effective ionisation energy scale |
| `Ipot` | 20.77 eV | first-ionisation potential / lower energy bound |
| `Eend` | 10 keV | upper sampled single-collision energy |
| `Exp` | 2.2 | power-law exponent |
| `Nprim` | 14 /cm | primary-ionisation normalisation |
| `MaxElePerStep` | 300 | cap on electrons per sampled collision |
| `ScaleFactorG4` | 0.85 | Geant4-Edep branch correction factor |
| `FanoFactorG4` | 0.7 | Geant4-Edep branch fluctuation parameter |

Reviewed Bethe-Bloch parameters:

```text
0.0820172
9.94795
8.97292e-5
2.05873
1.65272
```

These values are configurable and must not be assumed to match an arbitrary production without provenance checks.

---

## 12. Important property of the default model

The reviewed implementation separates two aspects:

### 12.1 Velocity dependence

The primary collision density depends on:

```text
BetheBlochAleph(betaGamma)
```

### 12.2 Single-collision spectrum

The single-collision energy spectrum is sampled from the configured power law and does not acquire a separate
explicit beta dependence in the reviewed code.

Thus the default model is not simply:

```text
Geant4 Edep / Wion
```

It is a stochastic detector-specific ionisation model.

---

## 13. Alternate mode: `UseGeant4Edep = true`

When enabled:

```text
TPCDetParam.UseGeant4Edep = true
```

the code instead reads the transport-engine deposited energy:

```cpp
fMC->Edep()
```

and computes:

```text
meanIon =
    Edep / (Wion × ScaleFactorG4)
```

The detailed review anchors this branch around:

```text
Detector.cxx:204-212
```

The resulting electron count is then fluctuated using a gamma distribution controlled by:

```text
FanoFactorG4
```

Conceptually:

```text
transport-engine Edep
       |
       v
divide by effective ionisation scale
       |
       v
mean number of electrons
       |
       v
gamma fluctuation
       |
       v
nElectrons
```

---

## 14. Special physics cuts for the Geant4-Edep mode

Enabling `UseGeant4Edep` also changes low-energy cuts through:

```text
Detector::SetSpecialPhysicsCuts()
```

The reviewed source lowers several cut values on TPC gas media to approximately:

```text
1 keV
```

for quantities such as electron/photon cuts.

This behavior is associated in the source/documentation with:

```text
Kr-83m calibration simulation
```

where the low-energy decay structure must be resolved.

Therefore the Geant4-Edep branch is not just a local arithmetic switch; it changes transport conditions as well.

---

## 15. What gets written into the TPC hit

The TPC point/hit class retains historical naming such as:

```text
mELoss
GetEnergyLoss()
```

but the actual TPC hit-creation call supplies:

```text
numberOfElectrons
```

The detailed review anchors the write call around:

```text
Detector.cxx:276
```

Conceptually:

```cpp
currentgroup->addHit(
    x,
    y,
    z,
    time,
    numberOfElectrons
);
```

Thus the physical semantic meaning is:

```text
TPC hit stored value = ionisation-electron count
```

not:

```text
TPC hit stored value = energy loss in GeV
```

---

## 16. Digitizer confirms the hit semantics

The TPC digitizer reads the same historically named quantity and explicitly treats it as:

```text
number of primary electrons
```

The reviewed source includes a comment around:

```text
Digitizer.cxx:95-96
```

equivalent to:

```cpp
// The energy loss stored corresponds to nElectrons
const int nPrimaryElectrons =
    static_cast<int>(eh.GetEnergyLoss());
```

This confirms that the energy-to-electron conversion has already happened at hit creation.

---

## 17. Downstream TPC digitisation chain

After hit creation, the digitizer performs detector-response simulation.

The chain is approximately:

```text
TPC hit nElectrons
      |
      v
electron drift
      |
      +--> transverse diffusion
      +--> longitudinal diffusion
      +--> attachment / survival
      |
      v
GEM amplification
      |
      +--> gain fluctuations
      |
      v
pad assignment (one pad selected per surviving electron)
      |
      v
SAMPA / electronics processing
      |
      v
TPC digit / ADC
```

The hit electron count is therefore the input to detector-response simulation, not the final detector amplitude.

[DIRECT — digitizer source review] Before a primary electron reaches a pad, the reviewed digitizer may
change its position through configured space-charge distortions and may drop it because of sector-boundary
checks, readout-window timing, attachment, active-volume/sector exits, or an invalid pad position. The
reviewed implementation maps each surviving electron to one pad; the panel did not identify an implemented
one-electron-to-neighbouring-pads response-spread stage in this source path. Consequently, `nElectrons`
at hit creation is not identical to the number of electrons that eventually contribute to digits.

---

## 18. Three distinct quantities in O2MCAI analysis

For monopole studies, these three levels must be kept distinct:

### 18.1 TrackReference-derived energy loss

```text
TrackReference dE/dx
```

Derived from momentum/energy differences between sparse transport references.

This is a transport-level observable.

### 18.2 TPC hit ionisation electrons

```text
TPC hit nElectrons
```

Generated by the TPC ionisation model for a transport step.

This is a detector-ionisation observable.

### 18.3 Digit / ADC response

```text
TPC digit / ADC
```

Generated after drift, diffusion, electron-loss cuts, GEM amplification, pad assignment and electronics simulation.

This is an electronics-level observable.

These quantities should never be given the same semantic label.

---

## 19. MCTrack persistence and hit bookkeeping

The general O2 Stack records detector activity with:

```text
Stack::addHit(detID)
```

This sets detector-related status/hit bookkeeping for the transported particle.

Later:

```text
Stack::selectTracks()
```

decides which transported particles are written to the persistent `MCTrack` collection.

Reviewed behavior includes:

- primaries are always stored;
- secondaries may be dropped depending on configuration;
- hit/activity conditions affect secondary retention;
- additional energy/physics retention rules may keep tracks;
- mother chains can be preserved depending on configuration.

Therefore:

```text
transported particle
```

is not automatically equivalent to:

```text
persisted MCTrack row
```

This distinction matters whenever hit data are joined back to `MCTrack`.

---

## 20. Track hit mask is not a hit count

The detector hit mask attached to a simulated track is a detector-presence bit field.

It answers approximately:

```text
did this track leave detector activity in detector X?
```

It does not answer:

```text
how many hits did this track create?
```

For quantitative TPC-hit studies the hit tree itself must be used.

---

## 21. TrackReferences are detector-specific

TrackReferences are not generated uniformly by the O2 framework.

Individual detectors add them according to detector-specific rules.

At the newer reviewed commit, call sites were identified in several detectors, including:

```text
TPC
ITS
TRD
EMCAL
HMPID
FOCAL
MID
MCH
ALICE3 upgrade detectors
```

A detector absent from the reference-generating set may have no TrackReferences even if the particle traversed it.

Therefore:

> A TrackReference gap is not necessarily a physical trajectory gap.

---

## 22. TPC references versus TPC hits

The TPC provides a useful concrete example.

#### TrackReferences

Sparse, approximately:

```text
entering / exiting / every ~15 cm
```

#### Hit ionisation

Sampled at transport-step granularity, controlled near:

```text
~2 mm
```

These operate at very different spatial frequencies.

This is why TrackReference-derived `dE/dx` should not be expected to match a single TPC hit one-to-one.

---

## 23. Magnetic monopole: the central problem

For a pure magnetic monopole:

```text
electric charge q = 0
magnetic charge g ≠ 0
```

the current default TPC model raises two separate concerns.

---

## 24. Monopole case A: `TrackCharge() == 0`

If VMC reports:

```text
TrackCharge() == 0
```

then the current TPC hit path returns before ionisation-electron generation.

A possible simulation state is therefore:

```text
monopole transported correctly
     |
     +--> MCTrack exists
     +--> TrackReferences exist
     |
     +--> no standard TPC hit electrons
     +--> no normal downstream TPC digits from this path
```

This is particularly dangerous because the kinematics/TrackReference analysis can look healthy while the detector
response is absent.

---

## 25. Monopole case B: effective non-zero electric TrackCharge

A production might assign some effective non-zero `TrackCharge()` so that the TPC hit code executes.

In that case the standard model still uses:

```text
trackCharge² × BetheBlochAleph(betaGamma)
```

which is an electric-particle ionisation model.

A non-zero TPC hit response therefore does **not** prove that the monopole dE/dx is physically correct.

---

## 26. Why monopole energy loss is conceptually different

The reviewed default model assumes an ordinary electric-charge dependence.

For magnetic monopoles the energy-loss law depends on magnetic charge and has a different effective coupling and
velocity structure.

Therefore the relevant physics parameter is not simply:

```text
q/e
```

but the magnetic charge:

```text
g
or
gD
```

with an explicit convention.

Any O2 implementation must therefore persist and consume at least:

```text
monopole PDG
monopole mass
monopole magnetic charge gD
magnetic-charge convention
```

---

## 27. Monopole treatment: reviewed master/dev versus open pull request

The source-certified baseline described above is AliceO2 master/dev at the pinned commits in §1. In that
baseline, no monopole-specific TPC ionisation branch is present, and a monopole represented with zero
ordinary electric `TrackCharge()` is rejected before normal TPC ionisation generation.

A later O2MCAI reviewer identified and source-inspected an **open, not-yet-merged** AliceO2 pull-request
snapshot for monopole support:

```text
pull request: #15602
branch:       monopoles
reviewed head: 26f3cee935d09843131d091bd9bca402d85797dd
snapshot time reported by reviewer: 2026-09-22T18:38:15+02:00
status in this document: REVIEW EVIDENCE — NOT CANONICAL / NOT MERGED
```

The reviewer reported the following changes in that PR snapshot:

- a Geant4 monopole physics implementation using `G4mplIonisation`;
- monopole particle definitions for PDG `±4110000` and `±4120000`;
- `G4Params` entries including `monopole`, `monopoleMagneticCharge`, and `monopoleMass`;
- explicit zero ordinary electric charge for the monopole species;
- a third TPC ionisation branch for recognised monopoles, based on Geant4 `Edep` converted to electrons.

The full 554-line monopole physics implementation was **not** source-audited by that reviewer, so this page
does not promote its detailed physics content to the same source-certified status as the master/dev TPC
model. The PR is recorded because it materially changes the engineering question: a candidate Run-3
implementation already exists and must be evaluated rather than independently reinvented.

## 28. Open-PR TPC branch reported by the source review

[REVIEW-EVIDENCE — open PR head `26f3cee935d09843131d091bd9bca402d85797dd`]

The reviewer reports a three-way TPC branch structure in the PR snapshot:

```cpp
if (detParam.UseGeant4Edep) {
    // Kr-83m-style Edep conversion with ScaleFactorG4 / fluctuation treatment
} else if (isMonopole) {
    // monopole path: numberOfElectrons = Edep / Wion
} else {
    // standard GEANT3/NA49-derived electric-particle model
}
```

The reported monopole path is active only under the PR's monopole configuration and recognised monopole
PDGs. A particularly important configuration interaction is that `UseGeant4Edep=true` selects the existing
first branch before the dedicated monopole branch. Therefore `UseGeant4Edep` must be recorded explicitly
in any monopole production provenance.

This is an open-PR behavior, not the source-certified master/dev behavior documented in §§5–16.

## 29. Required comparison with the historical AliRoot model

The historical AliRoot Run-1/Run-2 monopole implementation has still **not** been source-audited by this
panel. The next physics question is therefore not "which architecture should we invent?" but:

```text
Does the open-PR Geant4 monopole energy-loss / ionisation path
agree with the validated historical ALICE monopole model
over the relevant beta, mass and magnetic-charge range?
```

Required work:

- identify and pin the exact AliRoot implementation;
- document its equations and magnetic-charge convention;
- run controlled single-monopole comparisons;
- compare transport `Edep`, TPC primary-electron yield, and downstream digit response;
- preserve standard charged-particle behavior.

No further TPC source redesign should be proposed before this comparison.

## 30. Architecture principle for any accepted Run-3 solution

Do not duplicate downstream detector-response simulation unnecessarily.

The preferred separation remains:

```text
validated monopole energy-loss authority
        |
        v
correct primary nElectrons at TPC-hit level
        |
        v
reuse standard O2:
    drift
    diffusion
    attachment / survival
    GEM amplification
    pad assignment
    SAMPA / electronics
```

The monopole-specific part is expected primarily at the particle-energy-loss / primary-ionisation boundary;
the later TPC drift/amplification/electronics chain should be reused unless validation demonstrates a need
for further changes.

---

## 31. Required provenance for the current monopole production

Before interpreting existing monopole hits quantitatively, record:

```text
AliceO2 repository SHA
O2 release / build
transport engine
transport-engine version
Geant4 physics list / monopole process
G4.monopole
G4.monopoleMagneticCharge
G4.monopoleMass
generator configuration
PDG ±4110000 and ±4120000 definitions
monopole mass
magnetic charge g or gD
magnetic-charge convention
TVirtualMC::TrackCharge() result
TPCDetParam.UseGeant4Edep
TPCDetParam overrides
TPCGasParam overrides
GlobalProcessCutSimParam overrides
SimCutParams overrides
custom step-filter macros
HepMC attributes / generator metadata
MCEventHeader metadata
```

This should become part of the reproducible simulation record.

---

## 32. Concrete runtime checks

For the current sample, the following checks should be made directly.

### 32.1 Determine `UseGeant4Edep`

Search simulation logs for:

```text
TPC SetSpecialPhysicsCuts: UseGeant4Edep=
```

and inspect configuration overrides.

### 32.2 Determine monopole `TrackCharge()`

Instrument or log:

```cpp
fMC->TrackCharge()
```

for:

```text
PDG +4110000
PDG -4110000
```

Do not infer this from the PDG sign alone.

### 32.3 Confirm actual TPC hit population

For selected monopole tracks:

```text
MCTrack
→ TrackReferences
→ TPCHits
```

check whether TPC hits exist.

### 32.4 Check hit semantics

Interpret the TPC hit scalar as:

```text
nElectrons
```

and not as energy.

---

## 33. Recommended validation dataset

A minimal controlled validation production should contain:

```text
single monopole
fixed mass
fixed gD
fixed initial momentum
known trajectory through TPC gas
minimal pileup / no embedding
```

Prefer several controlled beta values and both magnetic-charge signs.

The purpose is to remove ambiguity from event mixing and reconstruction.

---

## 34. Required monopole validation plots / oracles

For each controlled monopole sample, produce:

1. `TrackReference dE/dx` vs `beta`;
2. TPC `nElectrons / stepLength` vs `beta`;
3. integrated TPC `nElectrons` vs traversed gas length;
4. digit charge / ADC vs `nElectrons`;
5. positive vs negative monopole comparison;
6. scaling versus `gD`;
7. comparison with Run-2/AliRoot reference;
8. comparison with Geant4 monopole `Edep`.

A double-ratio style comparison would be useful later:

```text
(data/model or Run3/Run2)
------------------------
(reference particle ratio)
```

but only after the basic source-model closure.

---

## 35. Minimal regression tests for a monopole implementation

A future code change should include deterministic tests for:

### 35.1 Charge-gate behavior

```text
ordinary neutral particle:
    unchanged behavior

monopole:
    enters intended dedicated path
```

### 35.2 Monopole mass

Change mass while keeping momentum fixed and verify the expected model response.

### 35.3 Magnetic charge

Change:

```text
gD = 1 -> 2
```

and check the scaling predicted by the chosen monopole model.

### 35.4 Charge sign

Positive and negative monopoles should differ only where the model/transport predicts sign dependence.

### 35.5 Standard-particle invariance

Normal pion/proton/electron TPC response must remain unchanged.

---

## 36. Documentation drift in current TPC README

The reviewed TPC simulation README describes the simulation approximately as converting each GEANT hit's energy
loss into electrons using the effective ionisation potential.

That wording is not an accurate description of the default source path.

On the reviewed default path:

```text
UseGeant4Edep = false
```

the TPC code does not simply read GEANT `Edep()` and divide by `Wion`.

Instead it performs its own Poisson + single-collision power-law ionisation sampling.

This is a useful candidate for an O2 documentation / MIWikiAI correction.

---

## 37. Recommended O2MCAI data-model naming

For analysis code, use explicit semantic names.

Recommended:

```text
TrackReference:
    dE
    dl
    dEdx_transport

TPC Hit:
    nElectrons

TPC Digit:
    adc
    charge
```

Avoid:

```text
e
mELoss
dEdx
```

without context, because these names can refer to different layers.

---

## 38. Relation to O2MCAI Phase 0.2

Phase 0.2 currently derives energy changes from TrackReferences.

That analysis should be viewed as:

```text
transport-level trajectory / energy-change analysis
```

not as a direct measurement of TPC detector ionisation response.

The TPC hit analysis adds the next layer:

```text
transport
    ↓
TrackReference observables
    ↓
TPC ionisation electrons
    ↓
digits
```

This is the correct hierarchy for future monopole studies.

---

## 39. Current source-certified conclusions

At the newest exact reviewed AliceO2 snapshot:

```text
86a1ec8dcb984ace1443ce82fe19c76bb6321c8a
```

the four-reviewer panel accepts the following as source-supported:

1. TPC hit creation is detector-specific and occurs in `TPC::Detector::ProcessHits()`.
2. `static_cast<int>(TrackCharge()) == 0` is rejected from the normal TPC ionisation-hit path; this also rejects fractional `|TrackCharge()| < 1`.
3. The TPC step is constrained to roughly 2 mm ± 0.5 mm.
4. TPC TrackReferences are sparse and have different semantics from hits.
5. Default `UseGeant4Edep=false` uses the O2 GEANT3-ILOSS-5/NA49-derived model.
6. Default collision rate scales with ordinary `trackCharge²`.
7. `UseGeant4Edep=true` is a separate transport-`Edep` branch.
8. The hit payload passed downstream is the number of ionisation electrons.
9. The TPC digitizer interprets the historical hit `GetEnergyLoss()` value as a primary-electron count.
10. The default master/dev ionisation model must not be assumed correct for a magnetic monopole.
11. The source-certified conclusions above describe the pinned master/dev baseline; the open PR snapshot in §§27–28 is separate review evidence and is not merged/canonical.

---

## 40. Open items

The following are **not yet source-certified**:

1. exact AliRoot Run-2 monopole implementation;
2. exact O2 SHA used for the current monopole production;
3. whether that production uses master/dev or an open-PR/derived monopole implementation;
4. exact current production `UseGeant4Edep`;
5. actual `TrackCharge()` value returned for the monopole PDG used;
6. exact monopole PDG family (`±4110000` or `±4120000`) and magnetic-charge convention;
7. any TPC parameter overrides in the current production;
8. exact Geant4 monopole process/configuration used in the production;
9. whether the current sample contains valid monopole TPC hits;
10. whether the open-PR/current-production Geant4 monopole `Edep` agrees with the historical ALICE model.

---

## 41. Recommended next phase

A focused follow-up phase should be:

```text
PHASE_0_3_O2MCAI_MONOPOLE_TPC_HIT_MODEL
```

with objectives:

1. source-audit Run-2 AliRoot monopole dE/dx code;
2. freeze current Run-3 monopole production provenance;
3. determine whether the production uses master/dev or the open monopole PR/derived code;
4. measure `TrackCharge()` and `UseGeant4Edep`;
5. fully source-audit the open-PR monopole physics and TPC branch;
6. compare the Run-2 model against the Geant4 monopole `Edep` / primary-electron result;
7. decide whether the existing PR implementation is acceptable or needs a minimal correction;
8. validate against controlled injected monopoles;
9. preserve the normal standard-particle TPC path.

---

## 42. Final disposition

**General O2 hit-production chain:** APPROVED  
**TPC default ionisation-model interpretation:** APPROVED  
**TPC hit payload = ionisation-electron count:** APPROVED  
**Opt-in Geant4-Edep interpretation:** APPROVED  
**TrackReference / hit semantic distinction:** APPROVED  
**Default TPC model as monopole simulation:** NOT APPROVED  
**Current monopole production interpretation:** HOLD pending provenance checks  
**Open monopole PR:** REVIEW-EVIDENCE RECORDED — NOT MERGED / PHYSICS VALIDATION PENDING  
**Run-2/AliRoot monopole-model comparison:** REQUIRED NEXT STEP

**Originating main reviewer/editor:** `GPT1:O2MCAI`  
**MIWikiAI adaptation:** `GPT5:MIWikiAI`  
**Technical ownership:** O2MCAI  
**Publication/maintenance ownership:** MIWikiAI

---

## Appendix A. Review lineage and publication disposition

The underlying source-model conclusions were established by the O2MCAI source panel and independently
accepted by MIWikiAI reviewers. The later publication review identified bounded corrections rather than a
failure of the central model.

Applied in this MIWikiAI adaptation:

- normalized YAML/front matter and heading hierarchy;
- pinned commits treated as primary source identity; Doxygen retained only as corroboration;
- direct empty-diff evidence recorded for the reviewed TPC scope between the two pinned commits;
- exact `kMaxDistRef = 15 cm` wording;
- `ExcludeFCGap` field-cage hit-suppression gate;
- fractional-charge consequence of `static_cast<int>(trackCharge) == 0`;
- unsupported generic `pad response` stage replaced by source-supported pad assignment and electron-loss handling;
- open monopole PR recorded explicitly as non-merged review evidence;
- provenance checklist extended to both monopole PDG families and PR configuration keys;
- analysis-facing terminology kept as `nElectrons` / **primary ionisation electrons**; no upstream persisted-field rename is implied.

Still intentionally open:

- exact current monopole-production provenance;
- historical AliRoot monopole implementation;
- full source audit and physics validation of the open monopole PR;
- quantitative Run-2/AliRoot ↔ Geant4/Run-3 validation.

No broad re-review is required for these content-neutral/publication corrections. A focused O2MCAI source confirmation
plus MIWikiAI formal confirmation is sufficient for freeze.
