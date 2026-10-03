---
doc_id: MonteCarlo_MaxNStep_Run1Run2_Run3
doc_type: software-source-investigation
title: "ALICE Monte Carlo transport: maximum number of steps in Run 1/2 and Run 3"
version: "0.2"
date: "2026-10-03"
status: "SOURCE-HARDENED CANDIDATE — focused confirmation pending"
technical_owner: O2MCAI
publication_owner: MIWikiAI
architect: Marian Ivanov
supersedes: MonteCarlo_MaxNStep_Run1Run2_Run3_v0_1
review_basis: MonteCarlo_MaxNStep_Run1Run2_Run3_v0_1_Official_Review_Summary_GPT1_MIWikiAI_20261003
---

# ALICE Monte Carlo transport — maximum number of steps in Run 1/2 and Run 3

## 1. Short answer

ALICE has **explicitly changed the maximum number of transport steps before**.

For Run 1 / Run 2, the AliRoot TPC code increased `SetMaxNStep()` above the Geant3 default. The reviewed source contains:

```text
AliTPCv2: SetMaxNStep(-120000)
AliTPCv4: SetMaxNStep(-30000)
```

These values are visible directly in the pinned AliRoot source:

- [AliTPCv2.cxx — `SetMaxNStep(-120000)` @ AliRoot `46f8b62b...`](https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/TPC/TPCsim/AliTPCv2.cxx#L2315)
- [AliTPCv4.cxx — `SetMaxNStep(-30000)` @ AliRoot `46f8b62b...`](https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/TPC/TPCsim/AliTPCv4.cxx#L1936)

For Run 3 the answer depends on the transport engine:

- **Run-3 Geant3:** AliceO2 explicitly sets `SetMaxNStep(1E5)`, i.e. `100000`.
  [AliceO2 `g3Config.C` @ `0db6a662...`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g3Config.C#L49-L52)
- **Run-3 Geant4:** the reviewed standard O2 Geant4 macro contains **no explicit `maxNofSteps` override**.
  [AliceO2 standard `g4config.in` @ `0db6a662...`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g4config.in)
- **Geant4-VMC backend default:** `30000` steps.
  [Geant4-VMC `TG4SteppingAction.h` @ `024fccb9...`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/include/TG4SteppingAction.h#L45-L48)

The **actual value used by the monopole production is still not proven**. O2 can replace the standard Geant4 macro with a custom one, so the production configuration and logs must be checked before we conclude that the run used `30000`.

That is the main result of this document.

---

## 2. Why this matters for the monopole study

In the monopole simulation, many tracks produce TPC information up to the outer TPC boundary, but another population appears to stop inside the TPC.

A maximum-step-count limit is a plausible explanation because it acts on the **whole transported track**, not just on the part of the trajectory inside the TPC gas.

Before reaching the active TPC volume, the monopole passes through material such as:

```text
beam pipe
ITS
support and services
TPC entrance / service material
```

The material budget is much larger there than in the TPC gas. Transport steps can become considerably shorter because of energy-loss and discrete processes, including δ-ray production. A track can therefore consume many transport steps before it reaches the active TPC gas.

The key question is consequently not simply:

> What is the mean spacing between TPC hits?

but:

> How many Geant4 transport steps has the monopole accumulated by the time it reaches a given radius?

---

## 3. Two different parameters: `SetMaxStep` and `SetMaxNStep`

These controls are easy to confuse, but they answer different questions.

```text
SetMaxStep(x)
    maximum length of one transport step

SetMaxNStep(N)
    maximum number of transport steps allowed for the track
```

A particle can therefore take very short steps and hit the step-count limit even though every individual step satisfies `SetMaxStep()`.

For the present investigation, **`SetMaxNStep` / `maxNofSteps` is the relevant global counter**.

---

## 4. Run 1 / Run 2 — what AliRoot actually did

### 4.1 AliRoot TPC explicitly increased the limit

The reviewed AliRoot source contains two TPC implementations with explicit overrides.

`AliTPCv2`:

```cpp
mc->SetMaxNStep(-120000); // max. number of steps increased
```

[Open the exact line in AliRoot @ `46f8b62b...`](https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/TPC/TPCsim/AliTPCv2.cxx#L2315)

`AliTPCv4`:

```cpp
TVirtualMC::GetMC()->SetMaxNStep(-30000); // max. number of steps increased
```

[Open the exact line in AliRoot @ `46f8b62b...`](https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/TPC/TPCsim/AliTPCv4.cxx#L1936)

So for the historical TPC simulation the answer is unambiguous:

> **ALICE deliberately increased the permitted number of transport steps.**

### 4.2 Geant3 default

The reviewed Geant3 source initializes:

```text
MAXNST = 10000
```

[Geant3 `ginit.F` @ `347fc680...`](https://github.com/vmc-project/geant3/blob/347fc6804dd116c66c2695df5d2c03d166a0364c/gbase/ginit.F#L341)

The magnitudes used by the AliRoot TPC code—`30000` and `120000`—were therefore above the Geant3 default.

### 4.3 Why were the AliRoot values negative?

This point is now source-resolved.

Geant3 compares the current step count to:

```text
ABS(MAXNST)
```

The track is stopped when the magnitude is exceeded **regardless of the sign**. The sign controls whether the warning is printed: the warning is emitted only for positive `MAXNST`.

See the exact Geant3 logic:

[Geant3 `gtrack.F` lines 270–276 @ `347fc680...`](https://github.com/vmc-project/geant3/blob/347fc6804dd116c66c2695df5d2c03d166a0364c/gtrak/gtrack.F#L270-L276)

Therefore, historically:

```text
-120000
```

means, in effect:

```text
allow up to 120000 steps
and suppress the usual positive-MAXNST warning
```

and similarly for `-30000`.

This is stronger evidence than the older mailing-list interpretation and should be treated as the canonical explanation for the reviewed Geant3 source.

---

## 5. Run 3 must be split by transport engine

A major correction from v0.1 is that “Run 3” cannot be described with one answer.

### 5.1 Run-3 Geant3

AliceO2 contains an explicit Geant3 configuration:

```cpp
geant3->SetMaxNStep(1E5);
```

which means:

```text
100000 steps
```

[Open `Detectors/gconfig/g3Config.C` @ AliceO2 `0db6a662...`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g3Config.C#L49-L52)

So the Run-3 Geant3 case is already configured explicitly by O2.

### 5.2 Run-3 Geant4

For the standard Geant4 configuration, the reviewed O2 `g4config.in` does not contain a `maxNofSteps` command:

[Open the full standard `g4config.in` @ AliceO2 `0db6a662...`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g4config.in)

If that standard macro is used unchanged, the Geant4-VMC backend default is the relevant limit.

The current reviewed Geant4-VMC source defines:

```text
default maxNofSteps = 30000
```

together with five diagnostic loop steps:

[Geant4-VMC `TG4SteppingAction.h` @ `024fccb9...`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/include/TG4SteppingAction.h#L45-L48)

However, this still does **not** prove that the monopole production used `30000`, because O2 supports replacing the standard Geant4 configuration macro.

---

## 6. How Geant4 VMC enforces the limit

Geant4 VMC uses the Geant4 track's current step number.

The reviewed implementation checks the step count and, after the limit plus a short diagnostic period, kills the track.

The relevant source is here:

[Geant4-VMC `TG4SteppingAction.cxx` lines 75–107 @ `024fccb9...`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4SteppingAction.cxx#L75-L107)

Conceptually:

```text
track->GetCurrentStepNumber()
        ↓
compare with fMaxNofSteps
        ↓
diagnostic loop steps
        ↓
track->SetTrackStatus(fStopAndKill)
```

Therefore this is a **real transport termination mechanism**, not just a diagnostic warning.

### 6.1 Runtime command

Geant4 VMC exposes the command:

```text
/mcTracking/maxNofSteps <value>
```

The command is created in:

[Geant4-VMC `TG4SteppingActionMessenger.cxx` lines 35–40 @ `024fccb9...`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4SteppingActionMessenger.cxx#L35-L40)

### 6.2 `SetMaxNStep` sign handling in Geant4 VMC

Current Geant4 VMC forwards the absolute value:

```cpp
SetMaxNofSteps(TMath::Abs(maxNofSteps))
```

[Geant4-VMC `TG4StepManager.cxx` @ `024fccb9...`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/digits%2Bhits/src/TG4StepManager.cxx#L314-L319)

So unlike the historical Geant3 warning convention, the sign does not preserve a separate warning mode at this interface.

---

## 7. Why the exact monopole-production value is still unknown

The absence of `/mcTracking/maxNofSteps` from the standard `g4config.in` is not enough to prove that a production used the default.

AliceO2 exposes:

```text
G4.configMacroFile
```

which allows a custom Geant4 configuration macro.

The parameter is defined here:

[AliceO2 `G4Params.h` @ `0db6a662...`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Common/SimConfig/include/SimConfig/G4Params.h#L45-L48)

The important implementation detail is that a custom macro **replaces the standard macro rather than being appended to it**:

[AliceO2 `g4Config.C` lines 147–157 @ `0db6a662...`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g4Config.C#L147-L157)

Therefore the active value for the monopole production can only be established from the **exact production configuration and generated files/logs**.

Current status:

```text
Run-3 Geant3 O2 value:                  100000 — source verified
Run-3 standard Geant4 macro override:   none found — source verified
Geant4-VMC backend default:             30000 — source verified
actual monopole-production value:       UNKNOWN — production evidence required
```

---

## 8. The current monopole observation

The architect reports a mean distance between consecutive TPC hits of approximately:

```text
0.025 cm
```

This is an **empirical analysis result**, not a source-code constant.

It should therefore not be treated as source-certified until the corresponding sample, selection, script/notebook and plot identity are recorded.

For now the correct status is:

```text
0.025 cm mean TPC hit spacing
    = architect-reported measurement
    = provenance pending
```

It is also important that:

```text
TPC hit spacing
!= necessarily Geant4 transport-step length
```

especially in the material-rich ITS/services region where transport steps can be much shorter than in the TPC gas.

---

## 9. What should be checked before requesting a new simulation

Before attributing the efficiency loss to `maxNofSteps`, first inspect the exact production.

### 9.1 Search the exact O2 / O2DPG checkout

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S %Z') Step 1 — Search max-step-count configuration"

git -C "$O2_ROOT" grep -n -E \
  'SetMaxNStep|GetMaxNStep|maxNofSteps|mcTracking/maxNofSteps|configMacroFile' \
  || true

git -C "$O2DPG_ROOT" grep -n -E \
  'SetMaxNStep|GetMaxNStep|maxNofSteps|mcTracking/maxNofSteps|configMacroFile' \
  || true

git -C "$O2_ROOT" rev-parse HEAD
git -C "$O2DPG_ROOT" rev-parse HEAD
```

### 9.2 Search generated production configuration

From the actual job directory:

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S %Z') Step 2 — Search generated Geant4 configuration"

grep -RIn \
  -e 'maxNofSteps' \
  -e 'mcTracking/maxNofSteps' \
  -e 'configMacroFile' \
  . \
  --include='*.C' \
  --include='*.mac' \
  --include='*.ini' \
  --include='*.cfg' \
  --include='*.json' \
  --include='*.sh'
```

### 9.3 Search simulation logs

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S %Z') Step 3 — Search max-step diagnostics"

grep -RIn \
  -e 'Particle reached max step number' \
  -e 'max step number' \
  -e 'looping' \
  . \
  --include='*.log' \
  --include='*.out' \
  --include='*.err'
```

A max-step diagnostic is much stronger evidence than inferring the mechanism from the disappearance radius alone.

---

## 10. Can we increase the Run-3 Geant4 limit?

At the Geant4-VMC level, **yes**.

The supported runtime command is:

```text
/mcTracking/maxNofSteps 1000000
```

for a diagnostic test.

However, the O2 configuration detail matters.

Because `G4.configMacroFile` **replaces** the standard `g4config.in`, do not create a one-line macro containing only the new `maxNofSteps` command. That would no longer be an otherwise-identical production.

Instead:

1. identify the exact full Geant4 macro used by the baseline production;
2. copy that entire file;
3. append only the new `maxNofSteps` setting;
4. configure `G4.configMacroFile` to use the copied full file.

For example:

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S %Z') Step 4 — Prepare controlled high-MaxNStep Geant4 macro"

cp "<exact-production-g4config.in>" \
   g4config_maxNofSteps_1000000.in

printf '\n/mcTracking/maxNofSteps 1000000\n' \
  >> g4config_maxNofSteps_1000000.in
```

Then point the production's existing O2 configuration mechanism for:

```text
G4.configMacroFile
```

to:

```text
g4config_maxNofSteps_1000000.in
```

The only intended physics/configuration delta should be:

```text
maxNofSteps: baseline value → 1000000
```

---

## 11. Controlled monopole test

If the production inspection does not already explain the losses, run a controlled comparison:

```text
baseline
vs.
same production with maxNofSteps = 1,000,000
```

Keep fixed:

```text
software revisions
generator seed
number of monopoles
mass
magnetic charge
momentum / pT spectrum
geometry
physics list
TPC configuration
all other Geant4 macro settings
```

Compare:

```text
TPC efficiency vs pT
last TPC hit radius
last TrackReference radius
number of TPC hits
number of TrackReferences
fraction reaching outer TPC
fraction reaching TOF / outer detectors
CPU/runtime cost
```

If possible, also record:

```text
Geant4 current step number at termination
termination process / reason
transport status
```

A shift or disappearance of the internal-TPC endpoint population when only `maxNofSteps` changes would be strong causal evidence.

---

## 12. Do not confuse `maxNofSteps` with every disappearance mechanism

Even if the spatial pattern is suggestive, a disappearing track does not prove that the step-count limit was reached.

Other possibilities include:

```text
another Geant4 process stops or kills the track
production-specific monopole physics
geometry / region effects
O2 detector recording stops while transport continues
TrackReference sampling misses the true terminal point
```

Therefore the investigation order should be:

```text
production configuration
        ↓
runtime logs / step-count evidence
        ↓
controlled high-limit test if still needed
        ↓
causal conclusion
```

---

## 13. TrackReferences do not guarantee the termination point

A `TrackReference` stream is not a universal transport endpoint log.

A possible sequence is:

```text
last stored TrackReference
        ↓
additional Geant4 transport steps
        ↓
maxNofSteps reached
        ↓
fStopAndKill
```

There is no general guarantee that a detector-specific terminal `TrackReference` is written exactly at the kill point.

Therefore:

```text
last TrackReference position
```

must not automatically be interpreted as:

```text
exact transport termination position
```

For future endpoint studies it would be useful to record the termination status/reason explicitly.

---

## 14. Run 1/2 versus Run 3 at a glance

| Configuration | Maximum-step-count behavior |
|---|---|
| Run 1/2 AliRoot TPC (`AliTPCv2`) | explicit `SetMaxNStep(-120000)` |
| Run 1/2 AliRoot TPC (`AliTPCv4`) | explicit `SetMaxNStep(-30000)` |
| Geant3 backend default | `MAXNST = 10000` |
| Run-3 AliceO2 + Geant3 | explicit `SetMaxNStep(1E5)` = `100000` |
| Geant4-VMC backend default | `30000` |
| Run-3 standard O2 Geant4 macro | no explicit `maxNofSteps` override found |
| Exact monopole production | **must be established from production config/logs** |

The important conceptual point is:

> **Run-3 Geant3 and Run-3 Geant4 do not currently have the same documented step-count configuration.**

---

## 15. Current conclusions

### Source-verified

- Run 1/2 AliRoot TPC explicitly increased `SetMaxNStep`.
- AliTPCv2 uses `-120000`.
- AliTPCv4 uses `-30000`.
- Geant3 initializes `MAXNST=10000`.
- Geant3 compares against `ABS(MAXNST)`; the sign controls warning emission, not whether the track is stopped.
- Run-3 AliceO2 Geant3 explicitly sets `SetMaxNStep(1E5)`.
- Geant4-VMC defaults to `30000`.
- Geant4-VMC eventually kills an over-limit track with `fStopAndKill`.
- Geant4-VMC exposes `/mcTracking/maxNofSteps`.
- Geant4-VMC `SetMaxNStep` uses the absolute magnitude.
- AliceO2 supports a replacement Geant4 macro through `G4.configMacroFile`.

### Still open

- The exact Geant4 macro/configuration used for the monopole production.
- The active `maxNofSteps` value in that production.
- Whether the observed monopole efficiency loss is actually caused by the step-count limit.
- Provenance for the measured `~0.025 cm` TPC hit spacing.

---

## 16. Recommended next action

The shortest evidence path is:

```text
inspect exact monopole-production configuration
        ↓
grep logs for max-step diagnostics
        ↓
if still unresolved:
run otherwise-identical production with maxNofSteps = 1,000,000
        ↓
compare disappearance radius and efficiency
```

Only after that should a production default be changed.

---

## 17. MIWikiAI placement

This belongs in the MC transport section as a separate reference page:

```text
Alice/code/O2/MonteCarlo_MaxNStep_Run1Run2_Run3_v0_2.md
```

It should be cross-linked from:

```text
Alice/code/O2/MonteCarlo_v0_1.md
```

and remain separate from the TPC hit-creation Source-of-Truth because `MaxNStep` is a **transport-level Monte Carlo control**, not a TPC detector-response parameter.

---

## 18. Immutable source evidence

The links below are deliberately commit-pinned. They are intended both for human readers and for AI reviewers.

### AliRoot

- [`AliTPCv2.cxx`: `SetMaxNStep(-120000)`](https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/TPC/TPCsim/AliTPCv2.cxx#L2315)
- [`AliTPCv4.cxx`: `SetMaxNStep(-30000)`](https://github.com/alisw/AliRoot/blob/46f8b62b1c76705c6c03768972a83b3b43e07789/TPC/TPCsim/AliTPCv4.cxx#L1936)

### Geant3

- [`ginit.F`: default `MAXNST=10000`](https://github.com/vmc-project/geant3/blob/347fc6804dd116c66c2695df5d2c03d166a0364c/gbase/ginit.F#L341)
- [`gtrack.F`: `ABS(MAXNST)` and sign-dependent warning](https://github.com/vmc-project/geant3/blob/347fc6804dd116c66c2695df5d2c03d166a0364c/gtrak/gtrack.F#L270-L276)

### Geant4 VMC

- [`TG4StepManager.cxx`: `SetMaxNStep` forwards `abs(maxNofSteps)`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/digits%2Bhits/src/TG4StepManager.cxx#L314-L319)
- [`TG4SteppingAction.h`: default `30000` and diagnostic-loop count](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/include/TG4SteppingAction.h#L45-L48)
- [`TG4SteppingAction.cxx`: step-count check and kill path](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4SteppingAction.cxx#L75-L107)
- [`TG4SteppingActionMessenger.cxx`: `/mcTracking/maxNofSteps`](https://github.com/vmc-project/geant4_vmc/blob/024fccb9fec1154338164c1fc9c31e2ecbbc089c/source/event/src/TG4SteppingActionMessenger.cxx#L35-L40)

### AliceO2

- [`g3Config.C`: Run-3 Geant3 `SetMaxNStep(1E5)`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g3Config.C#L49-L52)
- [standard `g4config.in`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g4config.in)
- [`G4Params.h`: `G4.configMacroFile`](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Common/SimConfig/include/SimConfig/G4Params.h#L45-L48)
- [`g4Config.C`: custom macro replaces the standard macro](https://github.com/AliceO2Group/AliceO2/blob/0db6a662920908047ecf08ad999194d5be8003e1/Detectors/gconfig/g4Config.C#L147-L157)

---

## 19. Review status

v0.2 implements the source-hardening actions from the v0.1 consolidated review:

```text
Run-3 Geant3 / Geant4 split                     implemented
AliceO2 Geant3 override                         implemented
Geant3 negative-value semantics                 source-resolved
immutable public GitHub permalinks              implemented
G4.configMacroFile replacement semantics        implemented
controlled-test instructions                    corrected
production-specific Geant4 value                intentionally left open
0.025 cm measurement provenance                 explicitly marked pending
causal maxNofSteps attribution                   explicitly left unproven
```

A focused confirmation review is sufficient; no broad review panel is required.
