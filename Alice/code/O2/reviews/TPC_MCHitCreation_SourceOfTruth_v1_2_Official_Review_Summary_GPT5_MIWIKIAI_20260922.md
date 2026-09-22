[GPT5:MIWikiAI] [MIWikiAI] [MAIN_REVIEWER] [TPC_MCHitCreation_SourceOfTruth_v1.1→v1.2] [!]

# Official MIWikiAI Review Summary — TPC MC Hit Creation Source of Truth

**Reviewer ID:** `GPT5:MIWikiAI`  
**Group ID:** `MIWikiAI`  
**Role:** Main Reviewer / cross-team consolidation  
**Originating technical team:** O2MCAI  
**Input technical revision:** `O2MCAI_ALICEO2_Run3_TPC_MC_Hit_Creation_SourceOfTruth_v1_1_DETAILED_20260922.md`  
**MIWikiAI adaptation produced:** `TPC_MCHitCreation_SourceOfTruth_v1_2.md`  
**Date:** 2026-09-22  
**Verdict on technical model:** **[OK] APPROVED**  
**Verdict on v1.1 as canonical MIWikiAI publication:** **[!] BOUNDED REVISION REQUIRED**  
**Verdict on v1.2 adaptation:** **APPROVED FOR FOCUSED CONFIRMATION AND VERSIONED COMMIT**

## GPT5:MIWikiAI — 1. Executive decision

The O2MCAI source investigation is technically strong and convergent.

The central source-model conclusions are approved:

1. detector `ProcessHits()` defines detector-hit semantics;
2. the default TPC ionisation path is the O2 GEANT3-ILOSS-5 / NA49-derived model;
3. `UseGeant4Edep=true` is a distinct opt-in transport-`Edep` path;
4. the historical TPC hit `mELoss` / `GetEnergyLoss()` payload is a primary-ionisation-electron count for digitisation;
5. `TrackReference`, TPC hit `nElectrons`, and TPC digit/ADC are distinct data/physics layers;
6. the default electric-charge model must not be assumed valid for magnetic monopoles.

The new v1.1 detailed document is more complete and readable than v1.0 and should be retained as the substantive basis.

However, **v1.1 should not be committed as the final MIWikiAI-format page unchanged**, because the supplied review set contains four publication-relevant P1 corrections that v1.1 did not yet absorb:

- field-cage-gap hit suppression;
- removal/correction of an unsupported generic `pad response` stage;
- explicit treatment of the open monopole pull-request snapshot;
- reproducibility classification of Doxygen-only reviewer checks.

These are bounded corrections, not a redesign.

## GPT5:MIWikiAI — 2. Reviewer coverage

The consolidation uses six identified reviewer artifacts in addition to the original O2MCAI four-reviewer source summary.

| Reviewer | Group | Verdict | Main signal |
|---|---|---|---|
| `GPT2:O2MCAI` | O2MCAI | `[OK]` | source-model and monopole caution approved |
| `Opus5_2` | O2MCAI | `[!]` | 2 P1 + 4 P2; direct pinned-source audit |
| `Opus5_1` | O2MCAI | `[X]` | 2 P1 + 4 P2; open-PR/source-provenance red team |
| `Claude5:MIWikiAI` | MIWikiAI | `[OK]` | 0 P0 / 0 P1 / 4 P2; 13 quantitative claims rechecked |
| `GPT4:MIWikiAI` | MIWikiAI | `[OK]` | exact-source spot checks; 3 P2 adaptation items |
| `GPT5:MIWikiAI` | MIWikiAI | `[OK]` on v1.0 handoff | source-model handoff approved; formal adaptation deferred |

The verdict split is not a substantive disagreement on the TPC model. The two stricter reviews identify publication/provenance omissions after independently confirming the central source claims.

## GPT5:MIWikiAI — 3. What the panel agrees on

All supplied reviews converge on the load-bearing source model.

### Confirmed current master/dev behavior

- TPC hit creation is detector-specific.
- The early gate uses `static_cast<int>(trackCharge) == 0`.
- Default `UseGeant4Edep=false` runs the O2 GEANT3-ILOSS-5 / NA49-derived stochastic ionisation model.
- The collision-rate term contains `trackCharge * trackCharge`.
- `UseGeant4Edep=true` uses transport `Edep()` converted to electrons with the branch-specific parameters.
- TPC hit payload semantics are primary ionisation electrons, despite historical energy-loss naming.
- TPC TrackReferences are sparse and semantically distinct from hit sampling.
- The default electric-particle model cannot be promoted to a validated monopole model.

No supplied reviewer reports a P0 error in these conclusions.

## GPT5:MIWikiAI — 4. Required v1.1 corrections

### P1-A — Field-cage hit-suppression gate

`Opus5_2` identified a second early `ProcessHits()` rejection controlled by
`TPCDetParam.ExcludeFCGap`, default `true`.

This matters because a charged track can legitimately produce no TPC hit for a geometric reason.

**Disposition:** applied in v1.2 as §6.1.

### P1-B — Unsupported generic `pad response` stage

The v1.1 digitiser chain still says `pad response / induced signal`. The direct review found one-pad assignment for each surviving electron and did not find the advertised signal-spread stage implemented in the reviewed path.

**Disposition:** v1.2 changes this to `pad assignment`, documents relevant electron-loss/position-changing stages, and explicitly avoids claiming a neighbouring-pad spread implementation.

### P1-C — Open monopole pull request must be represented

`Opus5_1` identified open AliceO2 PR #15602, reviewed at head:

```text
26f3cee935d09843131d091bd9bca402d85797dd
```

The PR reportedly contains an actual monopole implementation, including a Geant4 monopole process, monopole PDGs/configuration and a third TPC ionisation branch.

Therefore a page that only says "no monopole implementation exists; choose strategy A or B" is incomplete for the state of work reviewed on 2026-09-22.

**Disposition:** v1.2 keeps the pinned master/dev model as the canonical source baseline and records the PR separately as:

```text
REVIEW-EVIDENCE — OPEN / NOT MERGED / NOT CANONICAL
```

It does not promote the PR to the same source-certified status as the reviewed master/dev TPC model.

### P1-D — Doxygen reviews are corroboration, not reproducible source anchors

Two original reviewer seats used public Doxygen. Those checks are useful corroboration but cannot be replayed against immutable bytes.

**Disposition:** v1.2 states explicitly that the two pinned Git commits are the primary authority; Doxygen is corroborating evidence only.

## GPT5:MIWikiAI — 5. Important P2 items applied

The MIWikiAI adaptation also applies the useful non-blocking findings:

- YAML/front matter and explicit ownership/provenance class;
- one H1 title with H2/H3 section hierarchy;
- exact `kMaxDistRef = 15 cm` wording;
- empty-diff evidence that the reviewed TPC scope is byte-identical between the two pinned commits;
- fractional-charge consequence of `static_cast<int>(trackCharge) == 0`;
- `nElectrons` clarified as **primary ionisation electrons**;
- no upstream persisted-field rename is implied;
- both monopole PDG families `±4110000` and `±4120000` appear in the provenance checklist;
- PR configuration keys `G4.monopole`, `G4.monopoleMagneticCharge`, `G4.monopoleMass` are included;
- open design alternatives are separated from source-certified facts;
- cross-links added to MIWikiAI MC/AO2D/TPC reference pages.

## GPT5:MIWikiAI — 6. One review item intentionally not followed literally

One review suggested merging the technical page and full review summary into one artifact.

For MIWikiAI I do **not** recommend embedding the full review record in the human-facing source-of-truth page.

Reason: the repository already has a dedicated `Alice/code/O2/reviews/` convention. The technical page should carry a compact review lineage and provenance status; the full review synthesis should remain an immutable companion under `reviews/`.

This avoids document bloat and prevents review-management material from obscuring the technical reference.

## GPT5:MIWikiAI — 7. Open technical items retained

The following remain intentionally open and are **not documentation defects**:

- exact historical AliRoot Run-2 monopole implementation;
- exact current monopole production SHA/release/configuration;
- whether current production uses master/dev or PR-derived monopole code;
- actual `TrackCharge()` and `UseGeant4Edep` values in the production;
- full source audit of the open PR monopole physics implementation;
- validation of the PR/Geant4 monopole energy-loss result against the historical ALICE reference;
- quantitative controlled-monopole validation.

The adapted page must continue to say that the standard TPC model is **not validated for monopoles**.

## GPT5:MIWikiAI — 8. Publication ownership and location

Recommended MIWikiAI location:

```text
Alice/code/O2/TPC_MCHitCreation_SourceOfTruth_v1_2.md
```

Official review summary:

```text
Alice/code/O2/reviews/
  TPC_MCHitCreation_SourceOfTruth_v1_2_Official_Review_Summary_GPT5_MIWIKIAI_20260922.md
```

Ownership:

```text
technical/source semantics: O2MCAI
publication/formal maintenance: MIWikiAI
architectural/freeze decisions: Marian Ivanov
```

The page should be described as an **O2MCAI source-of-truth investigation accepted and maintained in MIWikiAI**, not as an official ALICE Collaboration document unless separately adopted.

## GPT5:MIWikiAI — 9. Review requirement for v1.2

No new broad panel is needed.

The v1.2 changes are primarily:

```text
review-finding incorporation
+
provenance normalization
+
MIWikiAI formatting/cross-links
```

Recommended freeze gate:

```text
1 O2MCAI source/provenance confirmation
+
1 MIWikiAI formal/publication confirmation
```

If both report no new P0/P1, v1.2 can be treated as the current MIWikiAI baseline.

It is reasonable to **commit the versioned v1.2 candidate before final freeze** because its front matter records its provenance/status explicitly; do not present it as an ALICE-official or monopole-physics-validated document.

## GPT5:MIWikiAI — 10. Final verdict

### Technical model

**[OK] APPROVED.**

### O2MCAI v1.1 detailed document

**[!] APPROVED AS SUBSTANTIVE BASIS, BOUNDED REVISION REQUIRED FOR MIWikiAI PUBLICATION.**

### MIWikiAI v1.2 adaptation

**APPROVED FOR FOCUSED CONFIRMATION AND VERSIONED COMMIT.**

### Broad re-review

**NOT REQUIRED.**

---

**Signed:** `GPT5:MIWikiAI`  
**Group:** `MIWikiAI`  
**Role:** Main Reviewer / cross-team consolidation  
**Date:** 2026-09-22  
**Verdict:** `[!] APPROVED_WITH_BOUNDED_REVISION`
