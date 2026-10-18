---
doc_id: TOF_TRD_Readout_Availability
doc_type: investigation-proposal / discussion-baseline
project: MIWikiAI / TOF / timeSeriesAI
version: v0.3-combined
date: 2026-10-18
status: REVIEW CANDIDATE — combined document for focused cross-review; NOT YET SOURCE-OF-TRUTH
canonical_role: dedicated long-form discussion and validation document
home_document: TOF_Matching_Performance_Debugging
related_documents:
  - TOF_SourceOfTruth
  - TOF_Reconstruction_SourceIndex
  - TOF_Matching_Performance_Debugging
source_pin:
  repository: AliceO2Group/O2Physics
  commit: 143192ab91704504598720ba12d65373d2d1e1e7
review_basis:
  - TOF_TRD_Readout_Availability_Official_Review_Summary_GPT1_MIWikiAI_20261018.md
  - TOF_TRD_Readout_Availability_Canonical_Text_Official_Review_GPT3_MIWikiAI_20261018.md
  - TOF_TRD_Readout_Availability_Official_Review_GPT4_MIWIKIAI_20261018.md
  - Review_TOF_TRD_Readout_Availability_Drafts_Claude5_MIWikiAI_20261018.md
  - TOF_TRD_Readout_Availability_Consolidated_Review_Summary_GPT1_MIWikiAI_20261018.md
supersedes_for_review:
  - TOF_TRD_Readout_Availability_Observation_Proposal_v0_1_20261018.md
  - TOF_TRD_Readout_Availability_QA_Mattermost_Draft_20261018.md
  - TOF_TRD_Readout_Availability_Proposal_v0_2_20261018.md
scope:
  - distinguish reconstructed track-level TRD information from collision-level TRD readout availability
  - audit existing O2Physics event-level information relevant to TRD readout
  - define a deterministic source-based TRD-availability state
  - define an empirical probabilistic fTRD estimator
  - define TOF QA and MC/TrackReference validation strategy
  - define a 2025-versus-2026 diagnostic programme
out_of_scope:
  - final statement of kTVXinTRD semantics
  - final AO2D schema change
  - final explanation of 2025/2026 TOF matching-efficiency differences
  - final numerical TRD loss or recovery efficiency
  - final Mattermost wording
---

# TRD readout availability as a hidden variable in TOF matching efficiency

## Combined review candidate v0.3

> **Purpose**
>
> Build one dedicated, source-grounded discussion document that can be reviewed and approved before implementation.
>
> This document is **not yet a Source-of-Truth freeze**. Its central open question is whether the existing event-level information in O2Physics can be interpreted as authoritative TRD readout availability for a collision.

---

## 0. Executive summary

The current TOF matching-efficiency QA can select tracks with or without reconstructed TRD information using `track.hasTRD()`. That answers:

> **Does this reconstructed track carry TRD information?**

It does **not** by itself answer:

> **Was TRD information expected to be available for this collision?**

This distinction matters because a track can lack TRD information for several different reasons:

- the TRD was not read out for that interaction;
- the particle was outside the relevant TRD acceptance;
- the track was not successfully matched/reconstructed in TRD;
- the particle decayed;
- the trajectory was strongly affected by multiple scattering or interactions;
- only partial or neighbouring-interaction TRD information was available.

O2Physics already contains an event-level trigger alias, `kTVXinTRD`, and existing tasks use it at collision level. However, the reviewed source does **not yet establish** that this alias is equivalent to:

> “TRD information was available to reconstruction for this collision.”

Therefore the proposed strategy is:

1. establish an authoritative per-collision TRD-readout state, ideally from existing source/readout information;
2. in parallel define an empirical per-event TRD estimator `fTRD`;
3. compare both quantities in data and MC;
4. condition TOF matching-efficiency QA on these quantities;
5. use MC TrackReferences to decompose the remaining efficiency losses;
6. only after validation decide whether a new persistent/shared event-level quantity is needed.

---

# 1. The distinction that must be preserved

Three concepts must remain separate:

```text
track.hasTRD()
    = reconstructed track-level property

kTVXinTRD
    = existing event-level trigger alias / TRD-triggered-event information

TRD readout available to reconstruction
    = desired collision-level physical/readout state
      NOT YET SOURCE-CLOSED by this document
```

The first two are existing software/data-model quantities.

The third is the quantity we ultimately want for interpretation of TOF matching-efficiency differences.

No review or implementation should silently equate these three concepts.

---

# 2. Current TOF QA behavior — verified source facts

All source references in this section are tied to:

```text
AliceO2Group/O2Physics
commit 143192ab91704504598720ba12d65373d2d1e1e7
```

## 2.1 Track-level selector in `qaMatchEff.cxx`

`DPG/Tasks/AOTTrack/qaMatchEff.cxx` defines the configurable:

```text
isTRDThere
```

and uses it to select on:

```cpp
track.hasTRD()
```

The track-level selector was added on 2022-10-21 in commit:

```text
736b61214a43...
```

with the change description:

```text
Added configurable to select TRD presence (#1382)
```

The task does not use `kTVXinTRD` or another event-level TRD condition.

## 2.2 Existing event-level candidate: `kTVXinTRD`

`kTVXinTRD` exists in:

```text
Common/CCDB/TriggerAliases.h
```

and was added on 2022-10-31 in commit:

```text
7c49a39558c6...
```

It is already used in:

```text
DPG/Tasks/AOTEvent/rofBorderQa.cxx
```

through event-level logic based on:

```cpp
collision.alias_bit(kTVXinTRD)
```

The event-selection machinery constructs trigger aliases from BC trigger masks using the CCDB trigger-alias configuration.

### Important boundary

The existence of `kTVXinTRD` proves that relevant event-level TRD-trigger information exists.

It does **not**, by itself, prove that:

```text
kTVXinTRD == TRD data available to reconstruction
```

That semantic step requires expert/source validation.

## 2.3 Chronology

The reviewed chronology is:

```text
2022-10-21    qaMatchEff track-level TRD selector added
2022-10-31    kTVXinTRD alias added
```

It is plausible that event-level information became available after the original track-level QA logic and was never propagated into `qaMatchEff`.

This is an **inference**, not a documented fact.

---

# 3. Open source/readout questions

Before implementation, the following must be answered.

1. What exactly does `kTVXinTRD` mean for Run-3 Pb–Pb?
2. Does it indicate:
   - a TRD-related trigger class;
   - TRD being part of the trigger cluster;
   - complete TRD readout availability;
   - partial TRD readout;
   - or something else?
3. Is `collision.alias_bit(kTVXinTRD)` populated and semantically comparable in the relevant 2025 and 2026 productions?
4. Is it meaningful and populated consistently in MC?
5. How are previous/next-interaction contributions represented?
6. How is partial TRD readout represented?
7. If `kTVXinTRD` is not sufficient, can the desired state be derived from:
   - interaction record;
   - associated BC/global BC;
   - TRD trigger/readout timing;
   - run configuration;
   - detector/readout conditions?

These questions are load-bearing. They must be closed before `kTVXinTRD` is promoted from “candidate” to “authoritative per-collision TRD-readout state”.

---

# 4. Proposal: two complementary TRD-availability estimators

## 4.1 Deterministic/source-based collision state

Target representation:

```text
trdReadoutExpected = YES / NO / UNKNOWN
trdReadoutSource   = exact table / column / configuration / rule
```

Requirements:

- derived from authoritative source/readout information;
- independent of reconstructed track success;
- source identity and derivation rule recorded;
- `UNKNOWN` retained when the information is insufficient;
- no inference from `track.hasTRD()`.

Candidate first input:

```cpp
collision.alias_bit(kTVXinTRD)
```

but only after its exact semantics are validated.

If the alias is only a trigger-class condition, derive the state instead from the interaction record and TRD readout/timing configuration.

---

## 4.2 Empirical probabilistic estimator

Define:

```text
fTRD = N(eligible tracks with reconstructed TRD information)
       -----------------------------------------------------
                    N(eligible tracks)
```

This is deliberately **not** a binary readout flag.

It is a probability-like event observable and is affected by:

- finite tracking efficiency;
- fake tracks;
- partial TRD tracks;
- species and momentum dependence;
- detector acceptance;
- inactive TRD regions;
- neighbouring-interaction contributions;
- centrality/multiplicity.

### Eligible-track definition

The denominator must be explicit and validated.

Candidate requirements include:

- momentum above a TRD/TOF reachability threshold;
- `|eta|` inside the relevant TRD acceptance;
- `phi` treatment that accounts for inactive/unsupported TRD regions;
- track quality requirements;
- TPC row / crossed-row requirements if needed;
- primary/PV-contributor status if appropriate;
- multiplicity high enough for the estimator to be statistically meaningful.

No single universal threshold or denominator is assumed at this stage.

---

# 5. Use both estimators together

The deterministic and empirical variables should be compared rather than collapsed immediately.

| Source-derived state | Empirical `fTRD` | Interpretation to investigate |
|---|---:|---|
| expected | high | nominal TRD-available event |
| expected | low | reconstruction, acceptance, detector-loss, or classification problem |
| not expected | low | nominal no-readout case |
| not expected | non-zero | neighbouring interaction, overlap, partial readout, or misclassification |
| unknown | any | empirical estimator only; keep unresolved |

The off-diagonal cells are particularly valuable because they test the deterministic classification itself.

---

# 6. First implementation — no canonical AO2D change

A new canonical AO2D field is **not** proposed at this stage.

First implement and validate a small derived/helper collision table or analysis output such as:

```text
collisionId
trdReadoutExpected
trdReadoutSource
nEligibleTracks
nTracksHasTRD
fTRD
```

Possible later additions:

```text
fTRD uncertainty / confidence
TRD overlap category
TRD acceptance-corrected denominator
source-quality/status flag
```

Only after data and MC validation should we consider promotion to a standard shared event-level quantity.

---

# 7. Required TOF QA matrix

The TOF QA should eventually expose at least:

```text
event-level TRD state
        ×
track.hasTRD()
        ×
TOF matching outcome
```

At minimum, plot:

```text
epsilon_TOF(pT)
```

for:

```text
TRD expected
TRD not expected
TRD unknown
```

and separately as a function of / in bins of `fTRD`.

Useful differential variables:

- `pT`;
- `eta`;
- `phi` / TRD sector boundaries;
- centrality / multiplicity;
- run / time;
- track quality / crossed rows;
- particle species in MC.

Every efficiency curve must state:

```text
numerator
denominator
track/event selection
TRD event class
TRD track class
production / pass
```

This is essential because different historical TOF efficiencies use different denominators.

---

# 8. MC validation with TrackReferences

TrackReferences are now available for TOF in the Tuba MC workflow, with first production available at GSI.

The MC decomposition should separate:

```text
true particle reaches TRD region
        ↓
TRD readout expected
        ↓
TRD information produced / available
        ↓
reconstructed track has TRD
        ↓
true particle reaches TOF
        ↓
TOF hit exists
        ↓
reconstructed TOF match
        ↓
correct / wrong match
```

This should allow us to distinguish:

- geometrical reachability;
- detector/readout availability;
- interactions in material/TRD;
- weak decays;
- multiple scattering;
- partial TRD trajectories;
- tracking/reconstruction inefficiency;
- TOF matching inefficiency;
- fake/wrong TOF matches;
- potentially recoverable trajectories.

A specific hypothesis to test is whether TRD information can confirm the existence/continuation of difficult trajectories between TPC and TOF, including some decay or high-multiple-scattering cases.

No numerical recovery efficiency is assumed here.

---

# 9. 2025 versus 2026 diagnostic programme

The immediate question is:

> Are the 2025 and 2026 TOF matching-efficiency samples being compared with the same distribution of TRD readout availability?

Before attributing differences to alignment, magnetic field, TOF matching windows, or detector performance, check:

1. fraction of collisions with source-derived `TRD expected`;
2. fraction with `TRD not expected`;
3. fraction with `UNKNOWN`;
4. `fTRD` distribution versus run and centrality;
5. track-level `hasTRD` fraction;
6. TOF matching efficiency conditional on the event-level TRD state;
7. TOF matching efficiency conditional on `fTRD`;
8. 2026/2025 ratios for the same selections;
9. MC/data agreement for all above observables.

Samples mentioned in the current discussion include:

```text
apass2 2025 Pb–Pb
apass1 2026 Pb–Pb
and selected apass2-versus-apass1 2025 comparisons
```

Exact production identities should be frozen in the dedicated debugging study.

This section is a diagnostic plan, **not** an explanation of the observed difference.

---

# 10. Expert inputs from the Mattermost discussion

The following are preserved as **discussion inputs**, not frozen source-of-truth facts.

## 10.1 Gauthier Legras

The current Run-3 TOF efficiency plot was produced from an official 2026 apass1 AO2D using `qaMatchEff.cxx`.

Gauthier also raised the question of fake TOF matches and noted that the observed TOF efficiency drop appears smaller than the TRD efficiency drop.

## 10.2 Ruben Shahoyan

Ruben recalled an asymptotic Run-2 TOF matching efficiency of approximately 70% in standard QA and asked which selections lead to values around 85%.

This reinforces the need to attach every quoted efficiency to its exact denominator and selections.

## 10.3 Francesco Noferini

Francesco provided a factorised expert estimate:

```text
MRPC efficiency including pad-border effects = 0.96
PHOS holes                                  = 0.94
dead space                                  = 0.90
TRD loss                                    = 0.85
```

giving approximately:

```text
0.96 * 0.94 * 0.90 * 0.85 ≈ 0.70
```

This is an expert decomposition hypothesis, not yet a universal TOF efficiency formula.

## 10.4 Marian Ivanov

Historical TOF-tracking recollection motivating the new MC study:

- dead space of order 10%;
- TRD losses strongly momentum- and PID-dependent;
- many tracks tagged as TOF “fakes” in the old study were decay products of the original particle;
- strongly multiple-scattered / weak-decay trajectories could still carry physically meaningful timing;
- TRD information could potentially confirm continuation between TPC and TOF.

The explicit proposal is to **repeat the old TrackReference-style study with current MC**, rather than rely on historical recollection.

---

# 11. Relation to the historical PPR baseline

The TOF SourceOfTruth records the PPR Vol. II simulation as a pre-data baseline.

The central Pb–Pb simulation gives, approximately:

- about 60% of primary pions leave a TOF hit;
- about 55% are correctly matched;
- significant losses come from dead space and material, much of it associated with TRD/material in front of TOF.

These PPR values use a specific simulation and efficiency definition and must not be mixed directly with current `qaMatchEff` values without denominator/selection matching.

The TrackReference programme proposed here is intended to reproduce and modernize that type of decomposition.

---

# 12. Questions for expert approval

Reviewers / detector experts are asked to answer:

1. What exactly does `kTVXinTRD` mean for Run-3 Pb–Pb?
2. Does `collision.alias_bit(kTVXinTRD)` identify collisions where usable TRD information was available to reconstruction?
3. Is its population and meaning stable across the relevant 2025 and 2026 productions?
4. Is it meaningful and populated equivalently in MC?
5. If not, what interaction-record/readout information should define `trdReadoutExpected`?
6. How are partial TRD readout and previous/next-interaction contributions represented?
7. Is `fTRD` a useful empirical estimator in Pb–Pb?
8. What exact eligible-track denominator should be used?
9. Should `fTRD` be corrected for TRD geometrical acceptance?
10. Is there already QA splitting TOF matching efficiency by an event-level TRD condition?
11. If not, should this be added to `qaMatchEff.cxx` or implemented in a dedicated related task?
12. What is the minimal source/data/MC test required before comparing 2025 and 2026?

---

# 13. Statements that must NOT be promoted to source-of-truth yet

The following remain intentionally unresolved:

- `kTVXinTRD` means complete TRD readout availability;
- `kTVXinTRD == false` means no usable TRD information existed;
- `kTVXinTRD` has identical semantics/population in 2025 and 2026;
- the alias is equivalent in MC and data;
- one fixed `fTRD` threshold classifies all collision systems / centralities;
- the historical approximately 15% TRD loss transfers directly to Run-3 reconstruction;
- the 2025/2026 TOF efficiency difference is caused by TRD readout availability;
- TRD-assisted recovery has a known numerical efficiency.

Any later revision promoting one of these statements must attach explicit source/validation evidence.

---

# 14. Implementation decision requested from the review panel

The proposed staged decision is:

1. **Audit existing event-level TRD/readout information.**
2. **Validate the exact semantics of `kTVXinTRD`.**
3. **Define `trdReadoutExpected = YES / NO / UNKNOWN`.**
4. **Define and validate empirical `fTRD`.**
5. **Add the event/track TRD matrix to TOF matching QA.**
6. **Compare data and MC.**
7. **Run the TrackReference truth decomposition.**
8. **Only then decide whether a persistent/shared AO2D quantity is justified.**

No production AO2D change is requested by this review candidate.

---

# 15. MIWikiAI document placement

This document family should remain separated:

```text
TOF_SourceOfTruth
    stable detector, literature, definitions, expected/measured performance

TOF_Reconstruction_SourceIndex
    authoritative AliRoot/AliceO2/O2Physics implementation mapping,
    including the source audit of TRD event/readout information

TOF_Matching_Performance_Debugging
    this TRD-readout-availability investigation,
    2025/2026 comparison,
    MC truth decomposition,
    parameter studies
```

The present combined document belongs primarily to `TOF_Matching_Performance_Debugging`.

Source conclusions established during the audit should also be recorded in `TOF_Reconstruction_SourceIndex`.

---

# 16. Pinned source references

All repository references below are tied to:

```text
O2Physics commit:
143192ab91704504598720ba12d65373d2d1e1e7
```

### R1 — TOF/TRD matching QA

`DPG/Tasks/AOTTrack/qaMatchEff.cxx`

https://github.com/AliceO2Group/O2Physics/blob/143192ab91704504598720ba12d65373d2d1e1e7/DPG/Tasks/AOTTrack/qaMatchEff.cxx

### R2 — track-level TRD selector introduction

commit `736b61214a43...` — 2022-10-21

https://github.com/AliceO2Group/O2Physics/commit/736b61214a43

### R3 — trigger aliases

`Common/CCDB/TriggerAliases.h`

https://github.com/AliceO2Group/O2Physics/blob/143192ab91704504598720ba12d65373d2d1e1e7/Common/CCDB/TriggerAliases.h

### R4 — `kTVXinTRD` introduction

commit `7c49a39558c6...` — 2022-10-31

https://github.com/AliceO2Group/O2Physics/commit/7c49a39558c6

### R5 — event-level use of `kTVXinTRD`

`DPG/Tasks/AOTEvent/rofBorderQa.cxx`

https://github.com/AliceO2Group/O2Physics/blob/143192ab91704504598720ba12d65373d2d1e1e7/DPG/Tasks/AOTEvent/rofBorderQa.cxx

### R6 — event-selection alias machinery

`Common/Tools/EventSelectionModule.h`

https://github.com/AliceO2Group/O2Physics/blob/143192ab91704504598720ba12d65373d2d1e1e7/Common/Tools/EventSelectionModule.h

### R7 — historical Run-2 TOF performance reference

F. Carnesecchi, JINST 14 (2019) C06023, arXiv:1806.03825

---

# 17. Mattermost strategy after approval

This long document is the technical discussion baseline.

The final Mattermost post should be written **after approval** and should be much shorter.

It should contain only:

1. the track-level versus event-level distinction;
2. the `kTVXinTRD` question;
3. the deterministic + empirical proposal;
4. the request for expert confirmation;
5. a link to this approved Markdown document.

The Mattermost post should remain a discussion trigger, not a second competing technical document.

---

# 18. Review request

Reviewers are asked to return one of:

```text
[OK] APPROVED
[!] APPROVED_WITH_COMMENTS
[X] CHANGES_REQUIRED
```

Please focus on:

- source correctness;
- `kTVXinTRD` semantics;
- 2025/2026 and MC applicability;
- empirical `fTRD` definition;
- proposed helper-table strategy;
- TOF QA matrix;
- MC / TrackReference validation chain.

Do not reopen unrelated TOF SourceOfTruth content unless a direct inconsistency is found.

---

# 19. Proposed post-review path

```text
combined v0.3 review candidate
        ↓
focused approval by all reviewers
        ↓
architect/expert dispositions on open TRD semantics
        ↓
short Mattermost message
        ↓
source audit + QA implementation
        ↓
MC TrackReference decomposition
        ↓
validated revision / possible promotion of selected facts
```

# End of `TOF_TRD_Readout_Availability_Combined_v0_3_20261018.md`
