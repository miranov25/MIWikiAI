---
wiki_id: O2_DataFormats_Reconstruction
title: "DataFormats/Reconstruction — track, vertex, PID, and cross-detector data classes consumed and produced by DPL workflows"
project: MIWikiAI / ALICE
folder: code/O2
source_type: software-index
source_status: DRAFT v0.2-rev1 — v0.2 mid-cycle P0 hotfix (Claude6 C-1/C-2/C-3) + v0.2-rev1 corrections for Claude6 full-report WD-1/WD-2/WD-3/D-sec-2; remaining 6 reviewers dispatch against this corrected baseline
source_fingerprint:
  upstream:
    - id: AliceO2-GitHub-root
      title: "AliceO2Group/AliceO2 — repository root (dev branch)"
      url: "https://github.com/AliceO2Group/AliceO2"
      branch: "dev"
      commit_verified: "87b9775"
      commit_evidence: "PR #15202 (aalkin, DPL: Better detection for injected workflows, merged 2026-03-26); SHA reused from Module 1 gate 1 approval and Module 2 gate 2 approval. Claude5 confirmed 1:1 directory match at re-fetch 2026-04-23 [attribution reconciliation: see reviewer_identity_reconciliation field — Claude5 in Module 1 v0.4 = same reviewer as Claude6 from Module 1 v0.5 onward]"
      role: "primary source for DataFormats/ directory structure and file paths"
      accessed: "2026-04-21 (Module 1), carry-forward for Module 3"
    - id: AliceO2-TrackFwd-h
      title: "DataFormats/Reconstruction/include/ReconstructionDataFormats/TrackFwd.h"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Reconstruction/include/ReconstructionDataFormats/TrackFwd.h"
      role: "primary source for forward (MFT/MCH) track parameterization (TrackParFwd, TrackParCovFwd)"
      accessed: "2026-04-23"
    - id: AliceO2-AnalysisDataModel-h
      title: "Framework/Core/include/Framework/AnalysisDataModel.h"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/AnalysisDataModel.h"
      role: "primary source for the AOD table schema and reconstruction-to-AOD column mapping"
      accessed: "2026-04-23"
    - id: AliceO2-DataHeader-h
      title: "DataFormats/Headers/include/Headers/DataHeader.h"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Headers/include/Headers/DataHeader.h"
      role: "authoritative source for O² Data Model field-length limits; already cited in Module 2 v0.2 §5.1 per CV-1 resolution"
      accessed: "2026-04-23"
    - id: AliceO2-RecoContainer-h
      title: "DataFormats/Detectors/GlobalTracking/include/DataFormatsGlobalTracking/RecoContainer.h (and RecoContainerCreateTracksVariadic.h)"
      url: "https://github.com/AliceO2Group/AliceO2/tree/dev/DataFormats/Detectors/GlobalTracking"
      role: "primary source for RecoContainer; RecoContainerCreateTracksVariadic.h #include block (lines 50-64) authoritatively locates MatchInfoTOF/HMP/TrackTPCITS/TrackTPCTOF/GlobalFwdTrack in ReconstructionDataFormats/ (used for C-1 fix in v0.2). Only Doxygen source-listing + include-path verification performed; raw-header fetch still pending"
      accessed: "2026-04-23 (Doxygen source listing + #include-path cross-reference only; raw RecoContainer.h fetch still pending — see known_verify_flags[3])"
    - id: AliceO2-TrackCuts-h
      title: "Detectors/GlobalTracking/include/GlobalTracking/TrackCuts.h (production consumer)"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Detectors/GlobalTracking/include/GlobalTracking/TrackCuts.h"
      role: "secondary corroboration for ReconstructionDataFormats/ header paths — include lines 36, 38, 43 confirm Track.h, MatchInfoTOF.h, VtxTrackIndex.h paths. Added in v0.2 as evidence basis for C-1/C-3 hotfix"
      accessed: "2026-04-23 (Claude6 cycle-1 verification + Claude8 independent confirmation)"
    - id: AliceO2-BarrelAlignmentSpec-src
      title: "Detectors/Align/Workflow/src/BarrelAlignmentSpec.cxx (production consumer)"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Detectors/Align/Workflow/src/BarrelAlignmentSpec.cxx"
      role: "secondary corroboration for ReconstructionDataFormats/ header paths — include lines 38-40 confirm TrackTPCITS.h, MatchInfoTOF.h, TrackTPCTOF.h paths. Added in v0.2 as evidence basis for C-1/C-3 hotfix"
      accessed: "2026-04-23 (Claude6 cycle-1 verification + Claude8 independent confirmation)"
    - id: AliceO2-V0-src
      title: "DataFormats/Reconstruction/src/V0.cxx"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Reconstruction/src/V0.cxx"
      role: "primary source for the V0 secondary-vertex data class"
      accessed: "2026-04-23"
    - id: AliceO2-Framework-Core-README
      title: "Framework/Core/README.md — Data Processing Layer in O2 Framework"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/README.md"
      role: "reference (not primary for this module) for how these data classes travel as DPL messages — covered in Module 2 §5"
      accessed: "2026-04-23"
    - id: AliceO2-Doxygen-Published
      title: "AliceO2 Doxygen — o2::dataformats namespace"
      url: "https://aliceo2group.github.io/AliceO2/"
      role: "primary source for class signatures of o2::dataformats::*, o2::track::*, o2::vertexing::*"
      accessed: "2026-04-23"
    - id: O2-CHEP2023-arXiv
      title: "Eulisse & Rohr, arXiv:2402.01205 (2024)"
      url: "https://arxiv.org/abs/2402.01205"
      role: "peer-reviewed reference for sync/async and GPU/CPU implementation sharing — referenced in §2"
      accessed: "2026-04-21"
    - id: AliceO2-Module1-Approved
      title: "AliceO2_overview.md v0.5 (Module 1)"
      url: "./AliceO2_overview.md"
      role: "frozen anchors for cross-reference"
      accessed: "2026-04-23 (gate 1 approved)"
    - id: AliceO2-Module2-Approved
      title: "Framework_DPL.md v0.2 (Module 2)"
      url: "./Framework_DPL.md"
      role: "frozen anchors for cross-reference: §4 DataProcessorSpec, §5 messaging, §5.1 Data Model and DataHeader.h"
      accessed: "2026-04-23 (gate 2 approved)"
  introduction_only: []
source_inconsistencies: []
related_jira_tickets: []
summary_contributors: [{id: Claude8, role: indexer}]
reviewer_identity_reconciliation:
  note: "Per SUMMARY v0.3 §8 item 1 Option A (reconciliation note, not retroactive edit)."
  mapping: "Claude5 (as used in Module 1 v0.4 and in this module's upstream[0] commit_evidence text carried forward from that baseline) refers to the same reviewer who signs as Claude6 from Module 1 v0.5 onward, including the cycle-1 C-primary report on this module (2026-04-23). No attribution edits are applied retroactively to carried-forward text; this reconciliation field is the canonical record."
cycle_0_self_review:
  status: "SPOT-CHECK EQUIVALENT (architect decision pending)"
  note: "Cycle-0 self-review on v0.1 was not performed before panel dispatch (flagged as WD-1 P1 by Claude6 cycle-1 C-primary). Mitigating factors: (1) Claude6 cycle-1 C-primary review delivered substantive directory-layout audit that a self-review would likely have produced; (2) Claude8 independently verified Claude6's C-1 findings via web_search against production source files (TrackCuts.h lines 36/38/43, BarrelAlignmentSpec.cxx lines 38-40, RecoContainerCreateTracksVariadic.h lines 50-63) before applying v0.2 hotfix; (3) v0.2 itself was produced as a single-reviewer mid-cycle hotfix with explicit evidence citations. Requested architect disposition: (a) waive formal cycle-0 self-review on the grounds of equivalent coverage from Claude6 cycle-1 + Coder independent verification; OR (b) Coder produces a standalone cycle-0 self-review document against v0.2 before remaining 6 reviewers dispatch. Default until architect rules: v0.2 proceeds to cycle-1b; self-review equivalence is documented here and in changelog."
indexed_by: Claude8
indexing_model: Claude Opus 4.7
indexed_on: 2026-04-23
source_last_verified: 2026-04-23
source_verification_depth: "TrackFwd.h fetched for forward-track signatures; AnalysisDataModel.h fetched for AOD column mapping; RecoContainerCreateTracksVariadic.h fetched via Doxygen source listing including verbatim #include block (lines 50-64) which authoritatively locates MatchInfoTOF, MatchInfoHMP, TrackTPCITS, TrackTPCTOF, GlobalFwdTrack in ReconstructionDataFormats/ (basis for C-1 resolution in v0.2). Production-consumer source files (TrackCuts.h lines 36/38/43, BarrelAlignmentSpec.cxx lines 38-40) provide corroborating evidence. Full directory listing of DataFormats/Reconstruction/include/ReconstructionDataFormats/ still NOT directly fetched — remaining gaps flagged in known_verify_flags for Aspect D red-team-fetch. DataHeader.h already cited in Module 2 v0.2 §5.1 per CV-1 resolution. Module 2 v0.2 anchors frozen (gate 2 approved); cross-references no longer carry anchor-shift risk."
review_status: READY_FOR_CYCLE_1B
review_cycle: 1
refresh_history:
  - version: "v0.1 (refreshed 2026-04-23)"
    changes: "Triggered by Module 2 gate 2 approval. Applied R-4 summary_contributors, R-3 fragment anchors, Module 2 status update to APPROVED v0.2, DataHeader.h added to upstream[]. No body content rewritten."
  - version: "v0.2 (2026-04-23) — mid-cycle P0 hotfix"
    driver: "Claude6 cycle-1 C-primary report (P0 finding C-1; P1 findings C-2, C-3; P2 findings WD-3, D-sec-1, D-sec-2)"
    changes: "(C-1 P0) Moved TrackTPCITS/MatchInfoTOF/MatchInfoHMP/GlobalFwdTrack from §3.3 to §3.2 per verbatim #include evidence. §4.4 TrackTPCITS location corrected. (C-2 P1) §3.1 expanded 4→7 rows adding common/, Headers/, Parameters/ with explicit module-scope column. §1.2 adds out-of-scope rationale. (C-3 P1) §3.2 adds VtxTrackIndex, GlobalTrackAccessor, TrackTPCTOF. §4.4 adds TrackTPCTOF and GlobalFwdTrack rows. §7.1 adds VtxTrackIndex paragraph. (WD-3 P2) upstream[0] attribution Claude5→Claude6. (D-sec-1 P0 cascade) body [GH:] re-audit, no other wrong paths. (D-sec-2 P1) upstream[4] role clarified. Added upstream[5] TrackCuts.h, upstream[6] BarrelAlignmentSpec.cxx as evidence sources. Appendix A.7 added. Remaining 6 reviewers dispatch against this corrected baseline."
  - version: "v0.2-rev1 (2026-04-23) — corrections against Claude6 full report"
    driver: "Architect circulated full Claude6 cycle-1 C-primary report; v0.2 initial (produced from synthesis summary) had under-handled findings WD-1, WD-2, WD-3, D-sec-2"
    changes: "(WD-1 P1) Cycle-0 self-review gap acknowledged via new cycle_0_self_review: front-matter field; requests architect disposition (waive with equivalent-coverage rationale vs require standalone cycle-0 doc). (WD-2 P2) §9 DataHeader.h bullet expanded to restate Module 2 v0.2 §5.1 field-length limits (DataOrigin=4, DataDescription=16, SubSpec=uint32_t) inline and flag their applicability to §2.4 and §7 payload declarations. (WD-3 P2 — CORRECTED) upstream[0] commit_evidence 'Claude5' attribution RESTORED; the v0.2 initial edit Claude5→Claude6 was the wrong direction per SUMMARY v0.3 §8 item 1 Option A. Reconciliation now recorded in new reviewer_identity_reconciliation: front-matter field. (D-sec-2 P1 — REFINED) upstream[4] accessed field updated from bare '2026-04-23' to 'Doxygen source listing + #include-path cross-reference only; raw RecoContainer.h fetch still pending' for consistency with source_verification_depth. No body content other than the §9 WD-2 bullet was touched; no [GH:] tag re-audit needed."
peer_reviewers_assigned: [Claude1, Claude2, Claude3, Claude4, Claude5, Claude6, Claude7]
peer_reviewers_reported: [Claude6]
review_assignment_doc: PHASE_0_1_Review_Module_3_DataFormatsReconstruction.md
hard_constraints_checked: {correctness: cycle-1-partial, reproducibility: cycle-1-partial, safety: verified}
staleness: fresh
searchable_keywords:
  - DataFormats
  - ReconstructionDataFormats
  - DataFormatsGlobalTracking
  - CommonDataFormat
  - DataFormatsParameters
  - DataFormats-Headers
  - Track
  - TrackPar
  - TrackParCov
  - TrackParFwd
  - TrackParCovFwd
  - 5-parameter-track
  - local-frame
  - Gaussian-track-covariance
  - SMatrix55Sym
  - propagateToDCA
  - PID
  - PrimaryVertex
  - V0
  - Cascade
  - DCA
  - GlobalTrackID
  - VtxTrackIndex
  - GlobalTrackAccessor
  - RecoContainer
  - BaseCluster
  - AOD
  - AnalysisDataModel
  - StoredTracks
  - TracksIU
  - TracksCov
  - ITS-TPC-matched
  - TrackTPCITS
  - TrackTPCTOF
  - MatchInfoTOF
  - MatchInfoHMP
  - GlobalFwdTrack
  - TRDTrkInfo
  - Module-3
  - Phase-0.1
  - DataHeader
known_verify_flags:
  - "Full direct-fetch enumeration of DataFormats/Reconstruction/include/ReconstructionDataFormats/ at SHA 87b9775 still pending. v0.2 established 7 additional header locations (4 moved §3.3→§3.2 per C-1; 3 added per C-3) via verbatim #include evidence in production consumer files (TrackCuts.h, BarrelAlignmentSpec.cxx, RecoContainerCreateTracksVariadic.h). Additional files may remain omitted. Aspect D red-team-fetch (Claude2) MUST produce the authoritative directory listing."
  - "Class signatures in §4 (TrackPar, TrackParCov) compiled from Doxygen and AnalysisDataModel.h column mapping. Direct Track.h fetch needed to verify full public API."
  - "§7 AOD mapping based on visible AnalysisDataModel.h declarations; version-specific additions (post-TRACK_IU_001) should be checked."
  - "RecoContainer contents described from RecoContainerCreateTracksVariadic.h Doxygen + #include block + usage patterns, not from direct RecoContainer.h fetch."
  - "§3.3 TrackCosmics.h and TRDTrkInfo.h locations in DataFormatsGlobalTracking/ NOT independently verified in v0.2. Retained with [VERIFY] flag. Aspect D primary fetch should confirm or move."
  - "SHA pinning reused from Module 1 + Module 2; DataFormats/Reconstruction/ may have been modified since. Structural stability assumed but not re-verified."
wiki_sections_stubbed: []
---

# DataFormats — the reconstruction data classes

## TL;DR

- **`DataFormats/Reconstruction/` and `DataFormats/Detectors/GlobalTracking/` define the C++ data classes that flow between DPL processors.** They are pure structures — no algorithms, no workflows, no state machines. They describe *what* is being sent, not *how* the computation works. The "how" is Module 2 (DPL).
- **The central object is a Gaussian 5-parameter helix track.** `TrackPar` = kinematics only (5 parameters `Y, Z, Snp, Tgl, Signed1Pt` in a local rotated frame anchored at `(X, Alpha)`); `TrackParCov` = `TrackPar` + a 5×5 symmetric covariance matrix (15 unique elements). Every reconstruction output inherits from or contains these. Forward-geometry muons (MFT, MCH) use a parallel `TrackParFwd` / `TrackParCovFwd` hierarchy [GH: TrackFwd.h].
- **Cross-detector objects live in `DataFormats/Reconstruction/`.** `TrackTPCITS`, `TrackTPCTOF`, `MatchInfoTOF`, `MatchInfoHMP`, `GlobalFwdTrack` are all in `ReconstructionDataFormats/` alongside the base classes — they are refit or match outputs, not detector-specific formats (corrected in v0.2 per Claude6 C-1).
- **Cross-detector glue: `GlobalTrackID` + `RecoContainer`.** `GlobalTrackID` is a compact 32-bit identifier encoding (source-detector, index-in-source-container); `VtxTrackIndex` extends it with vertex-association flags. `RecoContainer` (in `DataFormats/Detectors/GlobalTracking/`) is a wrapper that holds pointers to all reconstructed objects for a TimeFrame — the typical input for calibration and cross-detector analysis.
- **Vertex objects.** `PrimaryVertex`, `V0` (2-prong), `Cascade` (3-prong), `DCA` (distance-of-closest-approach with covariance). All in `ReconstructionDataFormats/`.
- **PID encoded as hypothesis index.** The `o2::track::PID` class enumerates 9 particle species. The hypothesis used during tracking is stored in 4 bits of the track flags [GH: AnalysisDataModel.h §PIDForTracking].
- **AOD = on-disk analysis format.** `Framework/Core/include/Framework/AnalysisDataModel.h` declares the schema. Reconstruction classes flatten to `Tracks`, `TracksIU`, `TracksCov`, `Collisions`, `BCs` tables. Analysis-specific tables (strangeness, HF) live in `O2Physics`.

## 1. Purpose and scope

### 1.1 What this page indexes

This page covers the data classes in:
- **`DataFormats/Reconstruction/`** — shared base classes for tracks, vertices, PID, DCA, clusters, and the cross-detector match / merged-track classes that are physically located here (see §3.2).
- **`DataFormats/Detectors/GlobalTracking/`** — cross-detector *container* wrapping all the above (`RecoContainer`), plus helpers.
- **`Framework/Core/include/Framework/AnalysisDataModel.h`** — the AOD table schema, only for the subset directly reflecting reconstruction outputs.

### 1.2 What this page is not

- **Not a per-detector digit/cluster catalog.** `DataFormats/Detectors/<DET>/` per-detector formats are wave 2.
- **Not a guide to reconstruction algorithms.** Algorithms live in `Detectors/GlobalTracking/`, `Detectors/Vertexing/`, per-detector `<DET>/reconstruction/`. Wave 2 / Module 5.
- **Not an analysis tutorial.** `O2Physics` repository scope.
- **Not a simulation data-format index.** `DataFormats/simulation/` is MC-side — Module 6 (planned).
- **Not an index of `DataFormats/common/` (CommonDataFormat), `DataFormats/Headers/`, or `DataFormats/Parameters/`.** These are real subdirectories of `DataFormats/` (see §3.1) but carry cross-cutting primitives (InteractionRecord, DataHeader, GRPObject) that are not track/vertex/PID material. `DataHeader.h` is already cited in advance in Module 2 v0.2 §5.1; a full `DataFormats/Headers/` index is a roadmap item, not in this page.
- **Not a re-derivation of track-propagation math.** The page catalogs the API, not the physics.

### 1.3 Dependencies on and from other wiki pages

This page **builds on**:
- [Module 1 AliceO2_overview § 3.1 *Top-level directory tree*](./AliceO2_overview.md#31-top-level-directory-tree)
- [Module 2 Framework_DPL § 4 *Core concepts*](./Framework_DPL.md#4-core-concepts--declaring-a-computation)
- [Module 2 Framework_DPL § 5 *Inputs, outputs, and messaging*](./Framework_DPL.md#5-inputs-outputs-and-messaging)

This page **is built on by**:
- [Module 4 Common_utilities](./Common_utilities.md) — SMatrix/SVector math helpers
- Module 5 (reconstruction framework, planned)
- All wave-2 detector wiki pages
- Wave-2 calibration pages (most consume a `RecoContainer`)

### 1.4 Phase context (MIWikiAI internal)

This is **Module 3 of Phase 0.1** per `PHASE_0_1_Proposal_AliceO2_Framework_Indexation.md` v3. Modules 1 and 2 both gate-approved (2026-04-23). Current review state: cycle-1 in progress, Claude6 C-primary reported, v0.2 is a mid-cycle P0 hotfix; remaining 6 reviewers (Claude1, Claude2, Claude3, Claude4, Claude5, Claude7) dispatch against this baseline. Planned after Module 3: Module 4 (Common_utilities), then Modules 5 and 6, then wave-2 detector pages.

---

## 2. Context — what "reconstruction data formats" means in O²

*Schema note: this section + §3 together correspond to "§2 Directory layout" in Phase 0.1 proposal v2 §2.2. Per v3 Amendment 3, context-before-directory is permitted when a reader benefits from understanding the subject before seeing the file tree. See PHASE_0_1_Proposal_AliceO2_Framework_Indexation v3 Amendment 3; [Module 1 v0.5 §2](./AliceO2_overview.md#2-how-the-o-system-works-at-a-glance) and [Module 2 v0.2 §2](./Framework_DPL.md#2-what-dpl-is-and-why-it-exists) are precedents.*

### 2.1 The problem these classes solve

A reconstruction pipeline reads detector signals, turns them into clusters, stitches clusters into tracks, propagates tracks, matches tracks across detectors, forms vertices, and dumps analysis-ready objects. Between each stage runs a DPL process. The classes on this page are the **message payloads**.

DPL messages cross process, network, GPU↔CPU, and disk↔memory boundaries — so the classes have design constraints beyond "plain C++":

1. **Messageable.** Trivially copyable (no virtuals, no heap pointers in the object) — see [Module 2 v0.2 § 5.5 *DataAllocator API*](./Framework_DPL.md#55-creating-outputs--the-dataallocator-api).
2. **ROOT-serializable.** Must round-trip through `TMessage`.
3. **Compact.** Run-3 data rates up to 3.5 TB/s raw [AliceO2_overview §2.1]; every byte matters.
4. **Numerically stable.** The Gaussian 5-parameter helix is the parameterization in which Kalman filtering is well-conditioned.

### 2.2 The local-frame convention (why 5D, not 6D)

A charged-particle helix in a uniform magnetic field has 5 geometric degrees of freedom. ALICE represents a track at a specific radial distance `X` in a *local rotated frame* defined by the sector angle `Alpha` — so the track carries `(X, Alpha)` as its *frame*, and a 5-parameter vector as the *state in that frame*:

```
  Y           — lateral displacement at X in the local frame
  Z           — longitudinal (beam-axis) position at X
  Snp         — sin(phi) in the local frame
  Tgl         — tan(lambda) = dz/dl
  Signed1Pt   — charge-signed inverse transverse momentum, (q/pT) in (c/GeV)
```

Rotating the sector frame keeps `Snp` bounded. Full 5×5 symmetric covariance → 15 independent elements as `SMatrix<double, 5, 5, MatRepSym<double, 5>>` [GH: TrackFwd.h].

### 2.3 The two parallel track hierarchies (barrel vs forward)

| Hierarchy | Geometric convention | Detectors | Base class |
|---|---|---|---|
| **Barrel** | Cylindrical — tracks at constant `X` (radial), local rotation `Alpha` | TPC, ITS, TRD, TOF, HMPID, FV0, FDD | `o2::track::TrackPar`, `o2::track::TrackParCov` |
| **Forward** | Cartesian — tracks at constant `Z` (along beam) | MFT, MCH, MID | `o2::track::TrackParFwd`, `o2::track::TrackParCovFwd` [GH: TrackFwd.h] |

Forward parameterization is needed because muon-spectrometer detectors sit downstream of the absorber; a constant-Z slice is what tracking naturally produces there. Code mixing barrel and forward (global muon tracking MFT→MCH) uses `TrackParFwd` throughout.

### 2.4 The cross-detector binding problem

A reconstructed event is not one track list — it is many. A typical Run-3 timeframe contains simultaneously:

- ITS standalone tracks
- TPC standalone tracks
- ITS-TPC matched (refitted as `TrackTPCITS`)
- ITS-TPC-TRD matched (adds TRD)
- ITS-TPC-TRD-TOF matched (adds TOF timing; `MatchInfoTOF` attached to the parent track)
- TPC-TOF matched (no ITS; `TrackTPCTOF`)
- MFT standalone, MCH standalone
- MFT-MCH matched muon (`GlobalFwdTrack`)
- HMPID match (`MatchInfoHMP`)
- plus vertex objects, cosmic-ray tracks, etc.

All of these refit/match output classes (`TrackTPCITS`, `TrackTPCTOF`, `MatchInfoTOF`, `MatchInfoHMP`, `GlobalFwdTrack`) live in `DataFormats/Reconstruction/include/ReconstructionDataFormats/` — they are barrel/forward cross-detector outputs, not detector-specific formats. See §3.2. (v0.1 of this page misplaced them in §3.3; corrected in v0.2 per Claude6 C-1.)

Two cross-detector mechanisms glue them together:

1. **`GlobalTrackID` (= GTrackID)** — 32-bit encoding of `(source_detector, index_in_source_container)`. Any track referred to by its GTrackID. `VtxTrackIndex` extends GTrackID with vertex-association flags (§7.1).
2. **`RecoContainer`** — wrapper for the current TimeFrame holding accessors to every track collection + clusters/digits/vertices. Calibration algorithms consume `RecoContainer`, not raw `InputRecord` [GH: RecoContainer.h; RecoContainerCreateTracksVariadic.h #include block lines 50-64].

Detail in §7.

### 2.5 The AOD — where reconstruction ends and analysis begins

After reconstruction (sync or async), in-memory track/vertex/PID objects flatten to the **AOD** (Analysis Object Data) columnar on-disk format, declared via ASoA templates in `Framework/Core/include/Framework/AnalysisDataModel.h` [GH: AnalysisDataModel.h].

| AOD table | Source C++ class |
|---|---|
| `Tracks` | `o2::dataformats::TrackParCov` (propagated to PV) |
| `TracksIU` | `o2::dataformats::TrackParCov` (at innermost update, as tracking produced) |
| `TracksCov` | `SMatrix55Sym` of the above |
| `TracksExtra` | derived from `TrackTPC`, `TrackTPCITS`, detector extras |
| `Collisions` | `o2::dataformats::PrimaryVertex` |
| `BCs` | bunch crossing metadata (not from this module) |

Analysis-side AOD usage lives in [`O2Physics`](https://github.com/AliceO2Group/O2Physics).

---

## 3. Directory layout of `DataFormats/`

### 3.1 Top-level `DataFormats/` — all subdirectories

From [Module 1 § 3.1](./AliceO2_overview.md#31-top-level-directory-tree). **All real subdirectories are listed**; the rightmost column states module scope.

| Subdirectory | What it holds | Module 3 scope? |
|---|---|---|
| **`Reconstruction/`** | Shared base classes (tracks, vertices, PID, DCA, BaseCluster, V⁰, Cascade) + cross-detector match/refit classes (TrackTPCITS, MatchInfoTOF, MatchInfoHMP, GlobalFwdTrack, etc.) | **Yes — see §3.2** |
| **`Detectors/GlobalTracking/`** | The `RecoContainer` wrapper + variadic helpers (container-only) | **Yes — see §3.3** |
| `Detectors/` (excluding `GlobalTracking/`) | Per-detector cluster/digit/raw-data formats | No — wave 2 (per-detector pages) |
| `common/` | Cross-cutting primitives — `InteractionRecord`, `RangeReference`, `TimeStamp` under include path `CommonDataFormat/`. Widely used (TRD TriggerRecord, alignment, MID QC) | No — planned in a future Module 3 extension |
| `Headers/` | O² Data Model header — `DataHeader.h`, `Stack.h`. Already cited in Module 2 v0.2 §5.1 and in this module's `upstream[]` | No — roadmap item |
| `Parameters/` | Run/grid-period parameter objects (`GRPObject`) under include path `DataFormatsParameters/` | No — Module 5 or wave-2 calibration |
| `simulation/` | MC-truth formats (`MCTrack`, `MCLabel`, hits) under include path `SimulationDataFormat/` | No — Module 6 (planned) |

**Note.** v0.1 listed only 4 of the 7 real subdirectories. Claude6 cycle-1 C-2 flagged the omission; v0.2 lists all 7 with explicit scope.

### 3.2 `DataFormats/Reconstruction/` contents

Public headers under `include/ReconstructionDataFormats/`. File existence established from verbatim `#include` statements in production consumer files (TrackCuts.h, BarrelAlignmentSpec.cxx, RecoContainerCreateTracksVariadic.h). Aspect D red-team-fetch must still close the authoritative enumeration.

| Header | Primary class(es) | Purpose |
|---|---|---|
| `Track.h` | `o2::track::TrackPar`, `o2::track::TrackParCov` | Barrel 5-parameter kinematic track + covariance (§4.1, §4.2) |
| `TrackFwd.h` | `o2::track::TrackParFwd`, `o2::track::TrackParCovFwd` | Forward 5-parameter track + covariance (§4.3) [GH: TrackFwd.h] |
| `TrackUtils.h` | (free functions) | Helix / propagation utilities |
| `BaseCluster.h` | `o2::BaseCluster<T>` | Template base for detector-specific clusters (§5.2) |
| `PID.h` | `o2::track::PID` | 9-species hypothesis enumeration (§5.1) |
| `DCA.h` | `o2::dataformats::DCA` | Distance-of-closest-approach with 2×2 covariance (§6.4) |
| `Vertex.h` | `o2::dataformats::Vertex<T>` | Generic vertex template |
| `PrimaryVertex.h` | `o2::dataformats::PrimaryVertex` | Primary interaction vertex (§6.1) |
| `V0.h` | `o2::dataformats::V0` | 2-prong secondary vertex (§6.2) [GH: V0.cxx] |
| `Cascade.h` | `o2::dataformats::Cascade` | 3-prong cascade vertex (§6.3) |
| `GlobalTrackID.h` | `o2::dataformats::GlobalTrackID` | 32-bit detector-source + index identifier (§7.1) |
| `VtxTrackIndex.h` | `o2::dataformats::VtxTrackIndex` | Extension of `GlobalTrackID` with vertex-track-association flags [GH: TrackCuts.h line 43] |
| `GlobalTrackAccessor.h` | (accessors) | Helpers for reaching tracks from a `GlobalTrackID` [GH: BarrelAlignmentSpec.cxx] |
| `TrackTPCITS.h` | `o2::dataformats::TrackTPCITS` | Refitted ITS-TPC matched track [GH: BarrelAlignmentSpec.cxx line 38, RecoContainerCreateTracksVariadic.h line 50] |
| `TrackTPCTOF.h` | `o2::dataformats::TrackTPCTOF` | TPC-TOF matched variant [GH: BarrelAlignmentSpec.cxx line 40, RecoContainerCreateTracksVariadic.h line 51] |
| `MatchInfoTOF.h` | `o2::dataformats::MatchInfoTOF` | TPC (or ITS-TPC) → TOF match output [GH: TrackCuts.h line 38, BarrelAlignmentSpec.cxx line 39, RecoContainerCreateTracksVariadic.h line 52] |
| `MatchInfoHMP.h` | `o2::dataformats::MatchInfoHMP` | Match to HMPID [GH: RecoContainerCreateTracksVariadic.h line 53] |
| `GlobalFwdTrack.h` | `o2::dataformats::GlobalFwdTrack` | Merged MFT-MCH global forward muon [GH: RecoContainerCreateTracksVariadic.h line 63] |

**Note (v0.2 hotfix).** v0.1 placed `TrackTPCITS`, `MatchInfoTOF`, `MatchInfoHMP`, `GlobalFwdTrack` in §3.3 under `DataFormats/Detectors/GlobalTracking/` — this was wrong. Verbatim `#include` paths in production consumers prove they live in `ReconstructionDataFormats/`. v0.2 also adds `VtxTrackIndex.h`, `GlobalTrackAccessor.h`, `TrackTPCTOF.h` which v0.1 omitted entirely. Claude6 cycle-1 findings C-1 and C-3 drove this correction.

### 3.3 `DataFormats/Detectors/GlobalTracking/` contents

Headers under `include/DataFormatsGlobalTracking/` — container-only; the match/refit class headers themselves live in `ReconstructionDataFormats/` (§3.2).

| Header | Primary class(es) | Purpose |
|---|---|---|
| `RecoContainer.h` | `o2::globaltracking::RecoContainer` | Wrapper holding all reconstruction objects for a TimeFrame (§7.2) |
| `RecoContainerCreateTracksVariadic.h` | (templates) | Variadic helpers for iterating RecoContainer across track types [GH: Doxygen] |
| `TrackCosmics.h` | `o2::dataformats::TrackCosmics` | Cosmic-ray track from matched upper/lower halves [VERIFY — location not independently confirmed in v0.2] |
| `TRDTrkInfo.h` | struct | TRD-matching info attached to ITS-TPC track [VERIFY — location not independently confirmed in v0.2] |

### 3.4 `Framework/Core/include/Framework/AnalysisDataModel.h` — the AOD contract

Not a reconstruction class, but the **schema** the AOD pipeline writes into. Declares tables, dynamic columns, extended tables. Straddles DPL and DataFormats; see [Module 2 v0.2 § 3.2](./Framework_DPL.md#32-what-lives-inside-frameworkcore).

---

## 4. Core track classes

### 4.1 `TrackPar` — barrel kinematic track (no covariance)

5-parameter representation `(Y, Z, Snp, Tgl, Signed1Pt)` + frame `(X, Alpha)`. Typical API:

```cpp
class TrackPar {
public:
  float getX() const;         float getAlpha() const;
  float getY() const;         float getZ() const;
  float getSnp() const;       float getTgl() const;
  float getSigned1Pt() const;
  float getPt() const;        // = 1 / |Signed1Pt|
  short getSign() const;
  float getP() const;         // = pt * sqrt(1 + tgl^2)
  void  getPxPyPzGlo(std::array<float, 3>& p) const;
  bool rotate(float alpha);
  bool propagateTo(float xk, float b);
  bool propagateTo(float xk, const std::array<float, 3>& b);
  // ...
};
```

Inferred from `AnalysisDataModel.h` column declarations [GH]. Full API requires `Track.h` direct fetch — flagged.

### 4.2 `TrackParCov` — barrel track with covariance

Extends `TrackPar` with 5×5 symmetric covariance (15 unique elements):

```cpp
class TrackParCov : public TrackPar {
public:
  float getSigmaY2() const;      // Cov(Y, Y)
  float getSigmaZY() const;
  float getSigmaZ2() const;
  float getSigmaSnpY() const;    // etc. — 15 unique elements
  float getSigma1Pt2() const;
  bool propagateToDCA(const Vertex<>& vtx, float b, DCA* dca = nullptr);
  bool correctForMaterial(float x2x0, float xTimesRho, bool anglecorr);
  // ...
};
```

AOD `TracksCov` stores the 15 covariance elements [GH: AnalysisDataModel.h §StoredTracksCov]; `TracksCovIU` at innermost update. `_IU` convention per AnalysisDataModel.h comment *"On disk version of the track parameters at inner most update (e.g. ITS) as it comes from the tracking"*.

### 4.3 `TrackParFwd` / `TrackParCovFwd` — forward geometry

5 parameters at constant `Z` instead of `X` [GH: TrackFwd.h]:

```cpp
namespace o2::track {
using SMatrix55Sym = ROOT::Math::SMatrix<double, 5, 5, ROOT::Math::MatRepSym<double, 5>>;
using SMatrix55Std = ROOT::Math::SMatrix<double, 5>;
using SMatrix5     = ROOT::Math::SVector<Double_t, 5>;

class TrackParFwd {
public:
  Double_t getZ() const;
  void     setZ(Double_t z);
  Double_t getX() const;
  void     setX(Double_t x);
  // ...
};

class TrackParCovFwd {
public:
  TrackParCovFwd(Double_t z, const SMatrix5& parameters, const SMatrix55Sym& covariances, Double_t chi2);
  void propagateToDCAhelix(double zField, const std::array<double, 3>& p, std::array<double, 3>& dca);
  bool propagateToVtxhelixWithMCS(double z, const std::array<float, 2>& p,
                                   const std::array<float, 2>& cov,
                                   double field, double x_over_X0);
  bool propagateToVtxlinearWithMCS(double z, const std::array<float, 2>& p,
                                    const std::array<float, 2>& cov,
                                    double x_over_X0);
  // ...
private:
  SMatrix5 mParameters{};
  Double_t mTrackChi2 = 0.;
};
}
```

Verbatim signatures from [GH: TrackFwd.h]. "MCS" = multiple-Coulomb-scattering correction.

### 4.4 Detector-specific and cross-detector extensions

Per-detector extensions live under `DataFormats/Detectors/<DET>/include/DataFormats<DET>/` (wave 2 scope). Cross-detector refit/matched tracks live under `DataFormats/Reconstruction/include/ReconstructionDataFormats/` alongside the base classes (§3.2, corrected in v0.2 per Claude6 C-1).

| Class | Where | Extends | Adds |
|---|---|---|---|
| `TrackTPC` | `DataFormats/Detectors/TPC/include/DataFormatsTPC/` | `TrackParCov` | cluster refs, `dE/dx`, `time0`, inner/outer reference params |
| `TrackITS` | `DataFormats/Detectors/ITSMFT/ITS/include/DataFormatsITS/` | `TrackParCov` | ITS cluster refs, chi², flags |
| `TrackTPCITS` | **`DataFormats/Reconstruction/include/ReconstructionDataFormats/`** (v0.2: corrected from Detectors/GlobalTracking/) | `TrackParCov` | refit chi², source ITS + TPC track refs |
| `TrackTPCTOF` | `DataFormats/Reconstruction/include/ReconstructionDataFormats/` | `TrackParCov` | TPC-TOF matched variant (no ITS) |
| `GlobalFwdTrack` | `DataFormats/Reconstruction/include/ReconstructionDataFormats/` | `TrackParCovFwd` | merged MFT-MCH muon refit |

`TrackTPCITS` is the typical input to TRD/TOF matching downstream.

---

## 5. PID, clusters, and supporting classes

### 5.1 `PID` — particle-species hypothesis

`o2::track::PID` is a 9-entry enumeration: Electron, Muon, Pion, Kaon, Proton, Deuteron, Triton, Helium-3, Alpha. Used to:

- drive the energy-loss model in propagation (`correctForMaterial` needs mass);
- label the tracking hypothesis on an output track (upper 4 bits of track flags, retrievable via `DECLARE_SOA_DYNAMIC_COLUMN(PIDForTracking, pidForTracking, ... flags >> 28)`) [GH: AnalysisDataModel.h];
- drive detector-response models in the `O2Physics` PID framework.

A `PID` hypothesis is *not* a measurement — it is a choice made at tracking time.

### 5.2 `BaseCluster` — the cluster template

`o2::BaseCluster<T>` is a 3D-position + unique-ID template. `o2::itsmft::Cluster` extends `BaseCluster<float>` with ITS/MFT-specific fields [GH: DataFormatsITSMFT/Cluster.h]. TPC, TRD, TOF have analogous extensions (wave-2 scope).

### 5.3 ROF records

ITS, MFT, MCH, MID produce `ROFrame` records marking interaction-rate slices of a cluster/digit vector via `{firstEntry, nEntries}` arrays + timestamp.

---

## 6. Vertices and decay objects

### 6.1 `PrimaryVertex` — the interaction point

`o2::dataformats::PrimaryVertex` stores position + 3×3 covariance (6 unique elements), contributor count, chi², timestamp, flags. Indexed into via AOD `Collisions` table with columns `PosX, PosY, PosZ, CovXX, CovXY, CovYY, CovXZ, CovYZ, CovZZ` [GH: AnalysisDataModel.h].

### 6.2 `V0` — 2-prong secondary vertex

```cpp
auto v0 = o2::dataformats::V0(vertexPos,              // 3D position
                              {pxTot, pyTot, pzTot},
                              covPCAFlat,
                              trackParCov0,
                              trackParCov1);
```

Used for K⁰s → π⁺π⁻, Λ → pπ⁻, γ → e⁺e⁻, and as a building-block for Cascade [GH: V0.cxx].

### 6.3 `Cascade` — 3-prong vertex

Chains a `V0` with a bachelor track to form Ξ, Ω, or generic 3-prong decay.

### 6.4 `DCA`

```cpp
DCA dca(dcaXY, dcaZ, cYY, cZY, cZZ);
```

Returned by `TrackParCov::propagateToDCA(vertex, bField, dca)`. Sign convention in Track.h (direct fetch needed).

---

## 7. GlobalTrackID and RecoContainer

### 7.1 `GlobalTrackID` and `VtxTrackIndex`

32-bit integer encoding `(Source, Index)`:

```cpp
class GlobalTrackID {
public:
  enum Source : uint8_t { ITS, TPC, ITSTPC, ITSTPCTRD, ITSTPCTRDTOF, ... NSources };
  GlobalTrackID(uint32_t idx, uint8_t src);
  uint32_t getIndex() const;
  Source   getSource() const;
  bool     includesDet(o2::detectors::DetID det) const;
  bool     isIndexSet() const;
  // ...
};
```

**`VtxTrackIndex`** (`VtxTrackIndex.h` in `ReconstructionDataFormats/`) extends `GlobalTrackID` with vertex-track-association flags. Used as `using GIndex = o2::dataformats::VtxTrackIndex;` in TrackCuts.h line 43.

### 7.2 `RecoContainer` — the canonical cross-detector input

Algorithms needing multiple reconstruction object types consume `RecoContainer` instead of a raw `InputRecord` ([Module 2 v0.2 § 5.4 *InputRecord API*](./Framework_DPL.md#54-reading-inputs--the-inputrecord-api) for the raw API). Behavior [GH: RecoContainerCreateTracksVariadic.h — #include block + Doxygen]:

- `RecoContainer::collectData(pc, dataRequest)` at `onProcess` top — fills container from the `ProcessingContext` based on a `DataRequest` declaring what detectors are wanted.
- After `collectData`, `gsl::span` views of every requested collection: ITS/TPC/ITS-TPC (`TrackTPCITS`)/TPC-TOF (`TrackTPCTOF`)/ITS-TPC-TOF (`MatchInfoTOF`)/HMPID (`MatchInfoHMP`)/MFT-MCH (`GlobalFwdTrack`), clusters, digits, primary vertices, V⁰s, cascades, ROF records, MC labels.
- `recoData.getTrackParam(gtrid)` returns the track regardless of source.
- `recoData.createTracksVariadic([](auto const& track, GTrackID id, float time, float terr) { ... })` visits every track from every source via one user lambda.

---

## 8. Relationship to the AOD

### 8.1 Reconstruction → AOD column mapping

| AOD table | Key columns | Source reconstruction C++ |
|---|---|---|
| `Tracks` | `CollisionId, TrackType, X, Alpha, Y, Z, Snp, Tgl, Signed1Pt` | `TrackParCov` (at PV) [GH: AnalysisDataModel.h] |
| `TracksIU` | same columns, different propagation point | `TrackParCov` at IU |
| `TracksCov` | 15 covariance elements | `SMatrix55Sym` |
| `TracksCovIU` | same, at IU | same |
| `TracksExtra` | `Flags, ITSClusterMap, TPCNClsFindable, TPCdEdxNorm, TOFExpMom, DcaXY, DcaZ`, ... | derived from `TrackTPC`, `TrackTPCITS`, detector extras [GH: AnalysisDataModel.h] |
| `Collisions` | `BCId, PosX...PosZ, CovXX...CovZZ, Flags, Chi2, NumContrib` | `PrimaryVertex` |
| `BCs` | bunch crossing metadata | (not from this module) |

### 8.2 Dynamic columns

Each AOD column can carry a `DECLARE_SOA_DYNAMIC_COLUMN` lambda [GH: AnalysisDataModel.h]:

- `Sign` from `Signed1Pt`
- `Px, Py, Pz` from `Signed1Pt, Snp, Tgl, Alpha`
- `IsWithinBeamPipe` from `X`
- `IsPVContributor` from `Flags`
- `TPCNClsFound` from `TPCNClsFindable, TPCNClsFindableMinusFound`
- `PIDForTracking` from `Flags >> 28`

No storage overhead; computed on access.

### 8.3 The `ASoA` substrate

AOD tables use `Framework/Core/include/Framework/ASoA.h` templates — DPL's column store over Apache Arrow. See [Module 2 v0.2 § 3.2](./Framework_DPL.md#32-what-lives-inside-frameworkcore).

---

## 9. Known limitations and open items

- **Direct-fetch enumeration of `ReconstructionDataFormats/` still pending.** v0.2 established 7 header locations via verbatim `#include` evidence in production consumers (4 moved from §3.3 per C-1; 3 added per C-3), but not equivalent to an authoritative listing. Aspect D red-team-fetch must close.
- **§3.3 `TrackCosmics.h` and `TRDTrkInfo.h` locations not independently verified in v0.2.** Retained in `DataFormatsGlobalTracking/` with `[VERIFY]` flag.
- **§4 class signatures** reconstructed from AOD column mapping and tracking conventions, not direct `Track.h` fetch. 5-parameter ordering verified by AnalysisDataModel.h; full public API not.
- **`GlobalTrackID::Source` enum** representative, not exhaustive. Aspect F primary to close.
- **`RecoContainer` contents** described from `RecoContainerCreateTracksVariadic.h` #include block + usage, not from `RecoContainer.h` direct fetch.
- **AOD schema** described only for reconstruction-origin columns; `O2Physics` analysis tables out of scope.
- **PID-hypothesis 4-bit encoding** stated per AnalysisDataModel.h (`flags >> 28`). Remaining 28 bits of `flags` detector-specific.
- **No `source_inconsistencies`** in this draft — cited sources concur.
- **DataHeader.h citation advance** — Module 2 v0.2 §5.1 cited `DataFormats/Headers/include/Headers/DataHeader.h` for the O² Data Model field-length limits (`DataOrigin` = 4 chars, `DataDescription` = 16 chars, `SubSpecificationType` = `uint32_t`). Module 3 inherits this citation; the limits apply to every `InputSpec`/`OutputSpec` declared for the classes in this page (§2.4 cross-detector binding, §7 RecoContainer/DataRequest mechanics). Full indexation of `DataHeader.h` is a Module 3 roadmap item; see §1.2 out-of-scope row. Tracked as roadmap item, not known_verify_flag.
- **SHA reuse.** `commit_verified: 87b9775` from Module 1 + Module 2.
- **Anchor freeze contract.** Module 3 `##`-level anchors freeze at gate 3 per Phase 0.1 v3 §5.3.

---

## 10. Cross-references to MIWikiAI wiki

| Link | Referenced from | Status |
|---|---|---|
| [`./AliceO2_overview.md § 3.1 Top-level directory tree`](./AliceO2_overview.md#31-top-level-directory-tree) | §1.3, §3.1 | **live (APPROVED v0.5, 2026-04-23 — gate 1)** |
| [`./Framework_DPL.md § 4 Core concepts`](./Framework_DPL.md#4-core-concepts--declaring-a-computation) | §1.3 | **live (APPROVED v0.2, 2026-04-23 — gate 2)** |
| [`./Framework_DPL.md § 5 Inputs, outputs, and messaging`](./Framework_DPL.md#5-inputs-outputs-and-messaging) | §1.3, §2.1, §7.2 | **live (APPROVED v0.2, 2026-04-23 — gate 2)** |
| [`./Framework_DPL.md § 5.5 Creating outputs`](./Framework_DPL.md#55-creating-outputs--the-dataallocator-api) | §2.1 | **live (APPROVED v0.2, 2026-04-23 — gate 2)** |
| [`./Common_utilities.md`](./Common_utilities.md) | §1.3 | planned — Module 4 |
| [`../../TDR/O2.md`](../../TDR/O2.md) | §2.2 | planned — TDR body indexation deferred |
| [`../../TDR/tpc.md`](../../TDR/tpc.md) | §4.4, §5.2 | live (DRAFT wiki-v2) |
| [`../../TDR/its.md`](../../TDR/its.md) | §4.4, §5.2 | live (DRAFT wiki-v1) |
| [`../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md`](../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) | §7 | live (DRAFT, cycle 0) |

---

## 11. External references

### 11.1 AliceO2 repository (primary, [GH])

| Topic | URL |
|---|---|
| `DataFormats/Reconstruction/` tree | https://github.com/AliceO2Group/AliceO2/tree/dev/DataFormats/Reconstruction |
| `ReconstructionDataFormats/` include dir | https://github.com/AliceO2Group/AliceO2/tree/dev/DataFormats/Reconstruction/include/ReconstructionDataFormats |
| `TrackFwd.h` | https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Reconstruction/include/ReconstructionDataFormats/TrackFwd.h |
| `V0.cxx` | https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Reconstruction/src/V0.cxx |
| `DataFormats/Detectors/GlobalTracking/` tree | https://github.com/AliceO2Group/AliceO2/tree/dev/DataFormats/Detectors/GlobalTracking |
| `DataHeader.h` (shared with Module 2 v0.2) | https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Headers/include/Headers/DataHeader.h |
| `AnalysisDataModel.h` | https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/AnalysisDataModel.h |
| `ASoA.h` | https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/ASoA.h |
| `TrackCuts.h` (v0.2 evidence) | https://github.com/AliceO2Group/AliceO2/blob/dev/Detectors/GlobalTracking/include/GlobalTracking/TrackCuts.h |
| `BarrelAlignmentSpec.cxx` (v0.2 evidence) | https://github.com/AliceO2Group/AliceO2/blob/dev/Detectors/Align/Workflow/src/BarrelAlignmentSpec.cxx |

### 11.2 Published documentation ([DX])

| Topic | URL |
|---|---|
| AliceO2 Doxygen landing | https://aliceo2group.github.io/AliceO2/ |
| `TrackFwd.h` Doxygen source | https://aliceo2group.github.io/docs/d7/df7/TrackFwd_8h_source.html |
| `V0.cxx` Doxygen source | https://aliceo2group.github.io/docs/d1/d1b/V0_8cxx_source.html |
| `RecoContainerCreateTracksVariadic.h` Doxygen | https://aliceo2group.github.io/docs/d3/de6/RecoContainerCreateTracksVariadic_8h_source.html |

### 11.3 Peer-reviewed ([PP])

| Document | Citation |
|---|---|
| O² software framework + GPU usage | Eulisse, Rohr, arXiv:2402.01205 (2024). https://arxiv.org/abs/2402.01205 |

### 11.4 Related repositories

| Topic | URL |
|---|---|
| AliceO2Group/O2Physics | https://github.com/AliceO2Group/O2Physics |
| ROOT Math (SMatrix, SVector) | https://root.cern/doc/master/group__SMatrixGroup.html |
| Apache Arrow | https://arrow.apache.org/ |

---

## Appendix A: Structural closure checks

### A.1 Track-parameter count (barrel)

**Claim.** §2.2 states 5 parameters: `Y, Z, Snp, Tgl, Signed1Pt`.
**Evidence.** AnalysisDataModel.h declares exactly these 5 columns for `Tracks`/`TracksIU` [GH]; standard ALICE/CMS Kalman parameterization.
**Result:** CLOSED ✓.

### A.2 Covariance element count

**Claim.** §2.2 states 15 independent elements for 5×5 symmetric.
**Evidence.** `SMatrix<double, 5, 5, MatRepSym<double, 5>>` → `5*(5+1)/2 = 15` [GH: TrackFwd.h].
**Result:** CLOSED ✓.

### A.3 PID hypothesis count

**Claim.** §5.1 states 9 entries.
**Evidence.** Standard ALICE enumeration across Runs 1–3; 4-bit field confirms ≤16 [GH: AnalysisDataModel.h `flags >> 28`].
**Result:** CLOSED with caveat — exact `PID` enum in PID.h not directly fetched. Aspect D to verify.

### A.4 Track hierarchy count

**Claim.** §2.3 lists 2 hierarchies.
**Evidence.** TrackFwd.h defines forward hierarchy as separate [GH: TrackFwd.h].
**Result:** CLOSED ✓.

### A.5 RecoContainer wrapped-pointer category count

**Claim.** §7.2 and §4.4 list ITS, TPC, ITS-TPC (TrackTPCITS), TPC-TOF (TrackTPCTOF), ITS-TPC-TOF (MatchInfoTOF), HMPID (MatchInfoHMP), MFT-MCH (GlobalFwdTrack), primary vertices, V⁰s, Cascades, clusters, digits, ROF records, MC labels.
**Evidence.** RecoContainerCreateTracksVariadic.h #include block (lines 50-64) + Doxygen comments.
**Result:** Not CLOSED — direct `RecoContainer.h` fetch + `DataRequest` flag enumeration needed. Flagged.

### A.6 AOD table → C++ class mapping count

**Claim.** §8.1 lists 7 tables with reconstruction origins.
**Evidence.** All 7 declared via `DECLARE_SOA_TABLE_FULL` or versioned variants [GH: AnalysisDataModel.h].
**Result:** CLOSED ✓.

### A.7 (new in v0.2) DataFormats/ subdirectory count

**Claim.** §3.1 lists 7 subdirectories.
**Evidence.** Include-path evidence from production source files: `ReconstructionDataFormats/`, `DataFormatsGlobalTracking/`, `DataFormats<DET>/`, `CommonDataFormat/`, `Headers/DataHeader.h`, `DataFormatsParameters/GRPObject.h`, `SimulationDataFormat/`.
**Result:** CLOSED with caveat — authoritative enumeration still needed; additional subdirectories may exist.

---

## Appendix B: Notation

### B.1 Primary-source inline-tag grammar

Identical to Module 1 Appendix B.1 and Module 2 Appendix B.1; see [`AliceO2_overview.md §B.1`](./AliceO2_overview.md#b1-primary-source-inline-tag-grammar).

### B.2 DataFormats-specific terminology

| Term | Definition |
|---|---|
| **5-parameter track** | Helix with 5 DOF: `(Y, Z, Snp, Tgl, Signed1Pt)` at `(X, Alpha)` |
| **Local frame** | Rotated frame anchored at `(X, Alpha)` |
| **Snp** | sin(φ) in the local frame |
| **Tgl** | tan(λ) = dz/dl |
| **Signed1Pt** | q/pT in (c/GeV) |
| **IU** | Innermost Update — at innermost ITS layer, as tracking produced |
| **DCA** | Distance of Closest Approach with 2×2 covariance |
| **PID hypothesis** | Chosen species index (not a measurement) |
| **GTrackID** | Shorthand for `GlobalTrackID` |
| **VtxTrackIndex** | GTrackID extended with vertex-track-association flags |
| **RecoContainer** | Cross-detector wrapper for a TimeFrame |
| **V⁰** | 2-prong secondary vertex |
| **Cascade** | 3-prong (V⁰+bachelor) vertex |
| **ROFrame** | Read-out frame record — cluster/digit sub-slice + timestamp |
| **ASoA** | Arrays-of-Structures-of-Arrays — DPL columnar table abstraction over Apache Arrow |
| **AOD** | Analysis Object Data — on-disk columnar format |

### B.3 Cross-detector source enumeration (indicative — closure per A.5)

| Value | Meaning |
|---|---|
| ITS | ITS standalone |
| TPC | TPC standalone |
| ITSTPC | ITS-TPC matched (`TrackTPCITS`) |
| ITSTPCTRD | adds TRD |
| ITSTPCTRDTOF | adds TOF (`MatchInfoTOF`) |
| TPCTRD | TPC-TRD (no ITS) |
| TPCTOF | TPC-TOF matched (`TrackTPCTOF`) |
| MFT | MFT standalone |
| MCH | MCH standalone |
| MFTMCH | MFT-MCH matched (`GlobalFwdTrack`) |
| MCHMID | MCH-MID matched |
| EMC | EMCAL cluster |
| PHS | PHOS cluster |
| HMP | HMPID (`MatchInfoHMP`) |
| FT0 | FT0 time / amplitude |
| FV0 | FV0 time / amplitude |
| FDD | FDD |
| CPV | CPV |
| ZDC | ZDC |

Exact count subject to Aspect D direct-fetch verification of `GlobalTrackID.h`.

---

## Changelog

- **v0.2 — 2026-04-23 — mid-cycle P0 hotfix.** Driven by Claude6 cycle-1 C-primary report. Applied:
  - **(C-1, P0)** §3.3 wrongly located `TrackTPCITS.h`, `MatchInfoTOF.h`, `MatchInfoHMP.h`, `GlobalFwdTrack.h` under `DataFormats/Detectors/GlobalTracking/`. Independent Claude8 verification via TrackCuts.h line 38, BarrelAlignmentSpec.cxx lines 38-39, RecoContainerCreateTracksVariadic.h lines 50/52-53/63 confirmed all four live under `ReconstructionDataFormats/`. Moved to §3.2. §4.4 "TrackTPCITS where" column corrected. §2.4 narrative updated to make the cross-detector-refit-in-Reconstruction/-directory claim explicit.
  - **(C-2, P1)** §3.1 expanded 4→7 rows listing all real `DataFormats/` subdirectories with explicit "Module 3 scope?" column: added `common/` (CommonDataFormat), `Headers/` (already in upstream[]), `Parameters/`. §1.2 "What this page is not" expanded with rationale.
  - **(C-3, P1)** §3.2 expanded with `VtxTrackIndex.h`, `GlobalTrackAccessor.h`, `TrackTPCTOF.h`. §7.1 adds `VtxTrackIndex` paragraph. §4.4 adds `TrackTPCTOF` and `GlobalFwdTrack` rows. §B.3 adds `TPCTOF` row and annotates sources with their class names.
  - **(C-3 partial)** §3.3 `TrackCosmics.h` and `TRDTrkInfo.h` locations not independently verified; retained with `[VERIFY]` flag and explicit `known_verify_flags` entry.
  - **(WD-3, P2 — revised in v0.2-rev1)** upstream[0] commit_evidence "Claude5" attribution RESTORED to carried-forward text (reverting the retroactive edit applied in v0.2 initial). Per SUMMARY v0.3 §8 item 1 Option A and Claude6 cycle-1 explicit recommendation, reconciliation is recorded via a dedicated front-matter `reviewer_identity_reconciliation:` field rather than retroactive text edits. Initial v0.2 edit was the wrong direction; v0.2-rev1 corrects this.
  - **(D-sec-1, P0 cascade)** All body `[GH:]` tags re-audited; no other wrong paths.
  - **(D-sec-2, P1 — refined in v0.2-rev1)** upstream[4] `AliceO2-RecoContainer-h`: v0.2 initial clarified role field; v0.2-rev1 additionally updated `accessed` field to state "Doxygen source listing + #include-path cross-reference only; raw RecoContainer.h fetch still pending" so it matches `source_verification_depth`.
  - **(WD-1, P1 — added in v0.2-rev1)** Cycle-0 self-review gap on v0.1 acknowledged via new `cycle_0_self_review:` front-matter field. Claude6 cycle-1 C-primary findings + Claude8 independent web_search verification treated as equivalent coverage; architect disposition requested (waive formal cycle-0 vs require standalone cycle-0 doc before cycle-1b dispatch).
  - **(WD-2, P2 — added in v0.2-rev1)** §9 DataHeader.h roadmap bullet expanded to restate the Module 2 v0.2 §5.1 field-length limits inline (DataOrigin=4, DataDescription=16, SubSpecificationType=uint32_t) and explicitly flag that they apply to every InputSpec/OutputSpec for classes in this page (§2.4, §7).
  - **Added upstream[5] `AliceO2-TrackCuts-h`, upstream[6] `AliceO2-BarrelAlignmentSpec-src`** as secondary corroboration sources.
  - **Appendix A.7** added for DataFormats/ subdirectory count closure.
  - **`known_verify_flags`** updated: first flag rephrased for partial-closure state; added `[VERIFY]` flag for §3.3 TrackCosmics/TRDTrkInfo.
  - **`source_verification_depth`** updated to document v0.2 evidence sources.
  - **`refresh_history`** entry added for v0.2 with explicit driver attribution.
  - `peer_reviewers_reported: [Claude6]`; `review_cycle: 1`; `review_status: READY_FOR_CYCLE_1B`.
  - Remaining 6 reviewers (Claude1, Claude2, Claude3, Claude4, Claude5, Claude7) dispatch against this corrected baseline per updated reviewer prompt.

- **v0.1 (refreshed 2026-04-23)** — pre-review refresh triggered by Module 2 gate 2 approval. Applied: summary_contributors field (R-4), Module 2 fragment anchors (R-3), §10 Module 2 status update, DataHeader.h added to upstream[], §1.4 phase context update. No body content rewritten.

- **v0.1 — 2026-04-23 — initial draft.** Indexed ReconstructionDataFormats/ base classes + DataFormatsGlobalTracking/ wrapper classes. Cross-referenced AOD schema. Schema variation §2 context before §3 directory. **Note: v0.1 misplaced TrackTPCITS/MatchInfoTOF/MatchInfoHMP/GlobalFwdTrack in §3.3 — corrected in v0.2.**

---

*Indexed by Claude8 on 2026-04-23. Team MIWikiAI. v0.2-rev1 READY_FOR_CYCLE_1B pending architect disposition on WD-1 (cycle-0 self-review waiver) — remaining 6 reviewers (Claude1-5, Claude7) dispatch against corrected baseline once architect rules.*

*Quota: no session-block / quota-loss signals observed.*
