---
wiki_id: O2_Common_utilities
title: "Common/ — math utilities, magnetic field, physics/geometry constants, and ConfigurableParam infrastructure shared by all detectors and workflows"
project: MIWikiAI / ALICE
folder: code/O2
source_type: software-index
source_status: "DRAFT v0.3.1 — P0 correction. MagneticField.h declares THREE polarity conventions, not two; Gemini1 A-1 (FIX-13) is UPHELD in substance and the v0.3 rejection is withdrawn. Otherwise identical to v0.3 — direct source enumeration of Common/ at a pinned 40-character commit, six [VERIFY] flags resolved, three previously-unknown subdirectories found. Awaiting architect gate 4."
source_fingerprint:
  upstream:
    - id: AliceO2-GitHub-root
      title: "AliceO2Group/AliceO2 — repository root (dev branch)"
      url: "https://github.com/AliceO2Group/AliceO2"
      branch: "dev"
      commit_verified: "ae7df2bd37d0a8b32a6c73cab33cae25b4501e49"
      pin_status: recovered
      pin_origin: "Direct sparse clone of AliceO2Group/AliceO2 branch dev, 2026-08-25, git rev-parse HEAD. Supersedes the 7-character carried-forward SHA 87b9775 used in v0.1-v0.2, which was never a valid source identity under MIWikiAI Source Identity Convention v0.3 §7.4 (40 characters required) and whose freshness the v0.2 front matter itself declared unverified."
      commit_evidence: "v0.3: acquisition_method direct_git (Source Identity Convention v0.3 §6 Method B — sparse checkout). `git clone --filter=blob:none --sparse --depth 1 --branch dev`, then `git sparse-checkout set Common`. Every §3 structural claim below is enumerated from that working tree. The v0.2 note that Aspect D 'MUST attempt direct dev-HEAD fetch' is hereby discharged."
      role: "primary source for Common/ directory structure and file paths — DIRECT working-tree enumeration as of v0.3"
      accessed: "2026-08-25 (direct sparse clone; supersedes the 2026-04-24 search-surfaced Doxygen + GitHub blob URL evidence)"
    - id: AliceO2-MathUtils-TrackFwd-inclusion
      title: "MathUtils/Utils.h and MathUtils/Primitive2D.h as included by DataFormats/Reconstruction/include/ReconstructionDataFormats/TrackFwd.h"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Reconstruction/include/ReconstructionDataFormats/TrackFwd.h"
      role: "primary source confirming Common/MathUtils/include/MathUtils/ exists and is the include-path origin for Utils.h and Primitive2D.h. Carries dependency pattern over from Module 3"
      accessed: "2026-04-24"
    - id: AliceO2-MathUtils-fit-h
      title: "Common/MathUtils/include/MathUtils/fit.h (Doxygen-hosted)"
      url: "https://aliceo2group.github.io/docs/d5/d71/fit_8h.html"
      role: "primary source for MathUtils/fit.h — includes TLinearFitter.h, TVectorD.h, TF1.h, HFitInterface.h, Fit/Fitter.h, Framework/Logger.h → establishes that MathUtils depends on Framework/Logger (cross-ref Module 2 v0.2 §3.2) and on ROOT Math/Fit subsystem"
      accessed: "2026-04-24"
    - id: AliceO2-MathUtils-trigonometric-h
      title: "Common/MathUtils/include/MathUtils/detail/trigonometric.h (Doxygen source listing)"
      url: "https://aliceo2group.github.io/docs/dd/d7d/trigonometric_8h_source.html"
      role: "primary source establishing MathUtils has a `detail/` sub-namespace carrying private implementation helpers (bitOps, trigonometric). Pattern mirrors std::detail idiom"
      accessed: "2026-04-24"
    - id: AliceO2-MathUtils-Chebyshev3DCalc-src
      title: "Common/MathUtils/src/Chebyshev3DCalc.cxx (Doxygen source listing)"
      url: "https://aliceo2group.github.io/docs/d0/df2/Chebyshev3DCalc_8cxx_source.html"
      role: "primary source establishing MathUtils hosts Chebyshev3D fast-parameterization infrastructure used by magnetic field maps"
      accessed: "2026-04-24"
    - id: AliceO2-MagneticField-src
      title: "Common/Field/src/MagneticField.cxx"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Common/Field/src/MagneticField.cxx"
      role: "primary source for Common/Field/ — class o2::field::MagneticField, factory createFieldMap(l3Cur, diCur, convention, uniform, beamenergy, beamtype), MagFieldFast (fast field evaluator), MagneticWrapperChebyshev. Establishes L3/dipole-current input API and LHC convention (kConvLHC vs kConvDCS2008)"
      accessed: "2026-04-24"
    - id: AliceO2-ConfigurableParam-src
      title: "Common/Utils/src/ConfigurableParam.cxx (Doxygen source listing)"
      url: "https://aliceo2group.github.io/AliceO2/dd/d03/ConfigurableParam_8cxx_source.html"
      role: "primary source for the ConfigurableParam framework — storage-map-based runtime parameter override system used across O² for e.g. reconstruction tunables, simulation knobs, calibration thresholds. Establishes updateThroughStorageMap() + type-coerced string-to-parameter mechanism"
      accessed: "2026-04-24"
    - id: AliceO2-CommonConstants-ZDC-inclusion
      title: "CommonConstants/PhysicsConstants.h, CommonConstants/LHCConstants.h, CommonConstants/ZDCConstants.h, CommonConstants/GeomConstants.h as included by ZDCBase/Constants.h and Framework/AnalysisDataModel.h"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/AnalysisDataModel.h"
      role: "primary source confirming Common/Constants/ → include path CommonConstants/ and enumerating its 4 headers found in production consumers. Establishes cross-module usage: detector-specific constants headers (e.g. ZDCConstants) live IN CommonConstants/, not in per-detector directories"
      accessed: "2026-04-24"
    - id: AliceO2-Doxygen-Published
      title: "AliceO2 Doxygen — o2::math_utils, o2::field, o2::conf, o2::constants::physics namespaces"
      url: "https://aliceo2group.github.io/AliceO2/"
      role: "primary source for namespace structure and public API of each Common/ subsystem"
      accessed: "2026-04-24"
    - id: AliceO2-math-utils-detail-ns
      title: "Doxygen: o2::math_utils::detail namespace reference"
      url: "https://aliceo2group.github.io/AliceO2/d4/dbd/namespaceo2_1_1math__utils_1_1detail.html"
      role: "primary source for o2::math_utils::detail namespace, its bitOps.h (line 40, 46 definitions), trigonometric.h helpers"
      accessed: "2026-04-24"
    - id: O2-CHEP2023-arXiv
      title: "Eulisse & Rohr, arXiv:2402.01205 (2024)"
      url: "https://arxiv.org/abs/2402.01205"
      role: "peer-reviewed reference carried from Modules 1/2/3 for the O² system design; referenced in §2 for the context of why common utilities are centralized"
      accessed: "2026-04-21 (via Module 1)"
    - id: AliceO2-SimFramework-CHEP2018
      title: "Wenzel et al., 'The ALICE O² simulation framework' — EPJ Web of Conferences 214, 05034 (CHEP 2018)"
      url: "https://doi.org/10.1051/epjconf/201921405034"
      role: "peer-reviewed reference added in v0.2 per Claude1 cycle-1 red-team fetch (D3). Confirms ALFA + FairMQ + VMC as the simulation-side framework that consumes ConfigurableParam and MagneticField in a non-DPL code path; 3 claim confirmations, 0 contradictions, 1 minor gap. Validates Module 4 §5.4 'not Framework/' rationale that ConfigurableParam lives in Common/ because non-DPL consumers (o2-sim) also use it"
      accessed: "2026-04-24 (Claude1 cycle-1 red-team)"
    - id: AliceO2-Module1-Approved
      title: "AliceO2_overview.md v0.5 (Module 1)"
      url: "./AliceO2_overview.md"
      role: "frozen anchors: §3.1 top-level directory tree (Common/ row), §2.3 software stack"
      accessed: "2026-04-23 (gate 1 approved)"
    - id: AliceO2-Module2-Approved
      title: "Framework_DPL.md v0.2 (Module 2)"
      url: "./Framework_DPL.md"
      role: "frozen anchors: §3.2 what lives inside Framework/Core/ (Logger cross-reference — MathUtils/fit.h includes Framework/Logger.h)"
      accessed: "2026-04-23 (gate 2 approved)"
    - id: AliceO2-Module3-InReview
      title: "DataFormats_Reconstruction.md v0.2-rev1 (Module 3)"
      url: "./DataFormats_Reconstruction.md"
      role: "cycle-1b baseline — NOT YET frozen; Module 4 cross-references §4 track classes (consumer of MathUtils::SMatrix helpers) and §2.2 local-frame convention (consumer of MathUtils trigonometric helpers). ANCHOR-SHIFT RISK: Module 3 anchors freeze only at gate 3. See known_verify_flags[1]"
      accessed: "2026-04-23 (v0.2-rev1 committed, SHA 5ed26c6)"
  introduction_only: []
source_inconsistencies: []
related_jira_tickets: []
summary_contributors: [{id: Claude8, role: indexer}]
reviewer_identity_reconciliation:
  note: "Pattern carried from Module 3 v0.2-rev1. Per SUMMARY v0.3 §8 item 1 Option A, identity-mapping corrections across versions are recorded here rather than via retroactive text edits."
  mapping: "No reviewer-identity reconciliations yet for Module 4."
cycle_0_self_review:
  status: "PERFORMED 2026-04-24"
  artifact: "./PHASE_0_1_Module_4_CycleZero_SelfReview_Claude8.md"
  note: "Per architect decision on R-6 (Cycle-0 self-review for Module 4: ENFORCE), Claude8 performed a ~20-minute self-review on v0.1 before panel dispatch. Findings and their resolution documented in the sibling self-review artifact. This avoids the Module 3 WD-1 situation where cycle-0 was skipped and Claude6 C-1 P0 had to be caught at cycle-1 cost."
indexed_by: Claude8
indexing_model: Claude Opus 4.7
indexed_on: 2026-04-24
source_last_verified: 2026-04-24
source_verification_depth_v0_3: "DIRECT enumeration at commit ae7df2bd37d0a8b32a6c73cab33cae25b4501e49. All §3 subdirectory, include-path and file-count claims are read from the working tree, not inferred from Doxygen pages, search results or downstream #include statements. Doxygen-derived and search-derived evidence from v0.1-v0.2 is retained below as historical provenance but is no longer the primary basis for any structural claim. Under Source Identity Convention v0.3 a Doxygen HTML page is a DERIVED artifact and cannot serve as primary source identity."
source_verification_depth_v0_2_historical: "Common/MathUtils/ confirmed via 3 independent Doxygen source listings (fit.h, trigonometric.h, Chebyshev3DCalc.cxx) + TrackFwd.h #include evidence. Common/Field/ MagneticField.cxx fetched directly via GitHub blob URL. Common/Utils/ConfigurableParam.cxx confirmed via Doxygen source listing. Common/Constants/ (include path CommonConstants/) confirmed via 4 header names enumerated in production consumers (ZDCBase/Constants.h lines 15-17 + AnalysisDataModel.h). Full DIRECT directory listing of Common/ at SHA 87b9775 NOT yet performed — Aspect D red-team-fetch MUST produce it. Three candidate subdirectories (Common/SimConfig/, Common/Types/, Common/maps/) retained with [VERIFY] flag pending direct enumeration. SHA freshness not re-verified: 87b9775 is carried forward from Modules 1-3; Common/ content may have evolved since 2026-03-26. Module 3 anchors cross-referenced here are NOT frozen (v0.2-rev1 in cycle-1b review)."
review_status: CYCLE_1_FIX_PASS_COMPLETE__AWAITING_GATE_4
review_cycle: 1
refresh_history:
  - version: "v0.1 (2026-04-24) — initial draft"
    changes: "Initial Module 4 draft. Common/ directory indexed with 4 confirmed subdirectories (MathUtils, Utils, Field, Constants) and 3 [VERIFY]-flagged candidates (SimConfig, Types, maps). Cycle-0 self-review performed before panel dispatch per architect R-6 decision. 9-reviewer panel (3 Gemini + 4 Sonnet + 2 Claude) to be dispatched against v0.1."
  - version: "v0.2 (2026-04-24) — cycle-1 fix-pass"
    driver: "Claude7 Main Reviewer synthesis of 9 cycle-1 reports: 2 [X] CHANGES REQUESTED (Claude1, Sonnet3) + 7 [!] APPROVED WITH COMMENTS. 21 fixes applied (2 P0 + 11 P1 + 8 P2). One Gemini2 G-1 finding discarded as hallucination (claimed Module 2 §3.2 anchor broken — 3 independent reviewers verified it resolves correctly)."
    fixes_applied: "FIX-1 P0 (§3.1 Utils/ include path corrected `(bare)` → `CommonUtils/` per 3-way convergent evidence from PHOSSimParams.h/SpacePointsCalibConfParam.h; Field/ row reviewed and retained as `Field/` pending confirmation). FIX-3 P1 (§5.3 code example split into header/.cxx blocks with ODR footnote per Claude2 fetch). FIX-4 P1 (§5.3 adds ConfigurableParamHelper.h as distinct second header per Claude2 N-3). FIX-5 P1 (§3.5 + §6.1 add MathConstants.h as 5th CommonConstants header per Sonnet4 N-4 with evidence [GH: AnalysisDataModel.h]). FIX-6 P1 (§3.1 SimConfig/ row upgraded [VERIFY] → confirmed/Module-6-scope per Claude1 WD2 Cave.cxx:146 evidence). FIX-7 P1 (§5.3 CRTP inheritance upgraded from [VERIFY] to CLOSED; only O2ParamDef/O2ParamImpl macro internals remain flagged). FIX-8 P1 (CV-2 §4.3 '5 types' → 'at least 3 observed'; A.6 text updated). FIX-9 P1 (review_cycle 0 → 1 per CV-4). FIX-10 P1 (CV-5 Module 3 §2.2 anchor corrected #22-the-local-frame-convention-why-5d-not-6d). FIX-11 P1 (§6.3 unit conventions [VERIFY] pointer added). FIX-12 P1 (upstream[] adds AliceO2-SimFramework-CHEP2018 Wenzel et al. per Claude1 red-team fetch). FIX-13 P1 DEFERRED to v0.3 per architect R-1 pending cross-check (Gemini1 A-1 Automatic/CCDB-managed polarity — UNVERIFIED). FIX-14 P2 (CV-3 A.2 header count footnote). FIX-15 P2 (§3.1 Utils/ row qualifier 'additional helpers may exist'). FIX-16 P2 (changelog 'Seven' → 'Eight' known_verify_flags). FIX-17 P2 (§4.1 [VERIFY] tag gets body pointer). FIX-18 P2 (§8.4 adds AliceO2Group/Configuration). FIX-19 P2 (§B.3 L3 30 kA [VERIFY] marker). FIX-20 P2 (§B.3 beamenergy per-nucleon clarification). FIX-21 P2 (§3.5 lhc/geom citation). DISCARDED: Gemini2 G-1 (hallucinated Module 2 §3.2 anchor failure — 3-way independent verification confirmed anchor resolves correctly; applying 'fix' would break working anchor)."
peer_reviewers_assigned: [Gemini1, Gemini2, Gemini3, Sonnet1, Sonnet2, Sonnet3, Sonnet4, Claude1, Claude2]
peer_reviewers_reported: [Gemini1, Gemini2, Gemini3, Sonnet1, Sonnet2, Sonnet3, Sonnet4, Claude1, Claude2]
review_assignment_doc: PHASE_0_1_Review_Module_4_CommonUtilities.md
hard_constraints_checked: {correctness: cycle-0-self-review-only, reproducibility: cycle-0-self-review-only, safety: verified}
staleness: fresh
searchable_keywords:
  - Common
  - Common-MathUtils
  - Common-Field
  - Common-Utils
  - Common-Constants
  - MathUtils
  - math_utils
  - Cartesian
  - Primitive2D
  - Chebyshev3D
  - Chebyshev3DCalc
  - bitOps
  - trigonometric
  - fit-h
  - TLinearFitter
  - SMatrix-helpers
  - MagneticField
  - MagFieldFast
  - MagneticWrapperChebyshev
  - MagFieldParam
  - L3-solenoid
  - LHC-dipole
  - kConvLHC
  - kConvDCS2008
  - kConvMap2005
  - ConfigurableParam
  - updateThroughStorageMap
  - runtime-parameter-override
  - o2-conf
  - CommonConstants
  - PhysicsConstants
  - LHCConstants
  - GeomConstants
  - ZDCConstants
  - o2-constants-physics
  - o2-constants-lhc
  - o2-constants-geom
  - SimConfig
  - Module-4
  - Phase-0.1
  - CERN-B-field
  - AliceO2-Common
known_verify_flags_closed_in_v0_3:
  - "[0] SHA freshness — CLOSED. Superseded by the 40-character pin ae7df2bd37d0a8b32a6c73cab33cae25b4501e49, obtained by direct sparse clone 2026-08-25. See Appendix A.7."
  - "[2] Full direct enumeration of Common/ — CLOSED. Performed for v0.3. Found ten subdirectories, not the seven v0.2 listed; DCAFitter/, ML/ and Topologies/ were absent from v0.2 entirely. See Â§3.1 and Appendix A.1."
  - "[3] MathUtils/ public-header enumeration — CLOSED. 14 headers + 8 in detail/. See Â§3.2 and Appendix A.2."
  - "[4] ConfigurableParam public API surface — CLOSED at file level: five headers in CommonUtils/. Deep API semantics remain the companion page's scope (Common_utilities_API.md v0.6), not this overview's."
  - "[5] Common/Field/ include path and class enumeration — CLOSED. Include path is Field/; eight headers. See Â§3.3 and Appendix A.3."
  - "[FIX-13] Third B-field polarity convention (Gemini1 A-1, deferred from v0.2 under architect ruling R-1) — CLOSED in v0.3.1, finding UPHELD IN SUBSTANCE. MagneticField.h:L50-52 declares THREE conventions: kConvLHC, kConvDCS2008, kConvMap2005. v0.3 rejected this on a citation that stopped one line short of the closing brace; that rejection is withdrawn. Gemini1 was right that the two-convention count was incomplete and wrong about the third member's identity — it is kConvMap2005, not an 'Automatic/CCDB-managed' convention. See Appendix A.5."
known_verify_flags:
  - "Module 3 cross-reference anchors: DataFormats_Reconstruction.md was v0.2-rev1 and unfrozen when this page was drafted. Anchor-shift risk is unchanged by v0.3 and must be re-checked at Module 3 gate 3."
  - "CommonConstants/ value catalog (§6.1) names headers but does not enumerate the constant VALUES they define. v0.3 closes the header inventory (six headers); the values remain unenumerated and are out of scope for an index page."
  - "Cross-detector constants placement (ZDCConstants.h under Common/Constants/ rather than DataFormats/Detectors/ZDC/) is an observed convention, not a documented policy. No authoritative statement of the rule has been found."
  - "NEW in v0.3 — scope decision pending. DCAFitter/, ML/ and Topologies/ are enumerated in §3.1 but not indexed in §§4–6. DCAFitter/ is production reconstruction code (secondary-vertex fitting) and is the strongest candidate for a v0.4 scope extension or a module of its own. Architect decision."
  - "NEW in v0.3 — Modules 1–3 carry the same 7-character SHA 87b9775 that v0.3 supersedes here. Re-pinning them to 40-character identities under Source Identity Convention v0.3 §7.4 is a separate bounded pass, not in scope for this document."
wiki_sections_stubbed: []
---

# Common/ — shared math, field, constants, and runtime-config infrastructure

## TL;DR

- **`Common/` holds infrastructure shared by every detector and every workflow.** It is not a grab-bag — the subdirectories are organized by functional domain: math (`MathUtils/`), magnetic field (`Field/`), runtime parameter framework (`Utils/`, home of `ConfigurableParam`), and physics/geometry/LHC constants (`Constants/` → include path `CommonConstants/`).
- **`MathUtils/`** provides Cartesian/Primitive2D geometry helpers, trigonometric fast-paths, bit-level operations, Chebyshev3D parameterization (used by the magnetic field cache), and fit wrappers over ROOT's TLinearFitter / Fit::Fitter subsystems. It is consumed by virtually every tracking, vertexing, calibration, and alignment code path (Modules 3, 5, and all wave-2 detector pages will include `MathUtils/`).
- **`Field/`** provides `o2::field::MagneticField` — the ALICE magnetic field model. It takes L3-solenoid and dipole currents + polarity convention (`kConvLHC` vs `kConvDCS2008`) as input and produces a 3D field map navigable via `MagneticWrapperChebyshev` (slow-but-accurate) or `MagFieldFast` (fast evaluator). Every track propagation in barrel or forward tracking consults this object [GH: MagneticField.cxx].
- **`Utils/`** is (in Module 4 scope) the home of `o2::conf::ConfigurableParam` — a storage-map-based runtime parameter override system. Lets users set any registered tunable from the command line (`--configKeyValues "Section.key=value"`) or a JSON/TXT config file, without recompilation. Used pervasively by every workflow.
- **`Constants/`** (include path `CommonConstants/`) catalogs physics constants (`PhysicsConstants.h` — masses, lifetimes, standard PDG values), LHC machine parameters (`LHCConstants.h` — bunch structure, revolution frequency), geometry constants (`GeomConstants.h`), and per-detector cross-system constants that would create include cycles if left detector-local (e.g. `ZDCConstants.h`).
- **What this page is NOT.** Not a tutorial on helix propagation math (lives in physics TDRs); not a catalog of every MathUtils function (the Doxygen is authoritative for that); not a guide to running `o2-sim` (Module 6, planned); not a re-indexation of the `Common/simulation/` tree if it exists (would be Module 6 scope).
- **This wiki page in one sentence.** An index to the `Common/` top-level directory — what lives where, what every detector/workflow can rely on, and how `Common/` dependencies flow into tracking (Module 3), framework (Module 2), and downstream wave-2 detector pages.

## 1. Purpose and scope

### 1.1 What this page indexes

This page covers the AliceO2 `Common/` top-level directory and its subdirectories (enumerated in §3.1). Specifically:

- **`Common/MathUtils/`** — numeric infrastructure: Cartesian, Primitive2D, fast trigonometry, bitOps, Chebyshev3D, fit wrappers (§4.1).
- **`Common/Field/`** — magnetic field model: `MagneticField`, `MagFieldFast`, `MagneticWrapperChebyshev`, `MagFieldParam` (§4.2).
- **`Common/Utils/`** — `o2::conf::ConfigurableParam` framework (§5).
- **`Common/Constants/`** — include path `CommonConstants/` — physics, LHC, geometry, and cross-detector constants (§6).

Scope excludes per-detector constants (wave 2), algorithm implementations (Module 5), and MC-specific helpers (Module 6 when scoped).

### 1.2 What this page is not

- **Not a repeat of Module 3.** Module 3 (DataFormats_Reconstruction) is about data classes — what travels in a DPL message. Module 4 is about the code that every data class uses — math, field, constants.
- **Not a re-derivation of tracking math.** The helix-propagation math, the Kalman-filter update formulas, the Gaussian covariance transport equations — all belong to physics/TDR documentation. Module 4 catalogs the *API* (what function to call) and *where the code lives*, not *how to derive* the math.
- **Not a complete function-by-function Doxygen dump.** For an exhaustive enumeration of `MathUtils::Cartesian2D::rotate` / `Chebyshev3DCalc::Eval` / etc., consult the published Doxygen ([DX: https://aliceo2group.github.io/AliceO2/]). This page names the modules and their entry points; deep API reference belongs in code.
- **Not a tutorial on running workflows.** How to pass `--configKeyValues` to `o2-sim` or `o2-tpc-reco-workflow` is a user-guide concern, covered in the AliceO2 / O2Physics tutorial docs. Module 4 describes `ConfigurableParam` as a code subsystem, not as a command-line recipe collection.
- **Not a catalog of Common/maps/, Common/SimConfig/, or Common/Types/.** Pending `[VERIFY]` flags in §3.1 — if these subdirectories exist and carry reconstruction/tracking-adjacent content, they will be indexed in a v0.2+ refresh; if they are sim-config or type-alias carriers, they may be out-of-scope for Module 4 and deferred to Module 6 or left for an O²Physics-side page.
- **Not the full AliceO2 coding-guidelines / include-style policy.** The repository has documented conventions; Module 4 respects them but does not replicate them.

### 1.3 Dependencies on and from other wiki pages

This page **builds on**:
- [Module 1 AliceO2_overview § 3.1 *Top-level directory tree*](./AliceO2_overview.md#31-top-level-directory-tree) — `Common/` row in the repository tree
- [Module 2 Framework_DPL § 3.2 *What lives inside Framework/Core/*](./Framework_DPL.md#32-what-lives-inside-frameworkcore) — `Framework/Logger.h` cross-reference (MathUtils/fit.h includes Framework/Logger)

This page **is built on by**:
- [Module 3 DataFormats_Reconstruction § 2.2 *The local-frame convention*](./DataFormats_Reconstruction.md#22-the-local-frame-convention-why-5d-not-6d) — 5-param track + SMatrix55Sym rely on MathUtils helpers and the `ROOT::Math::SMatrix` / `SVector` aliasing conventions codified here (ANCHOR NOT YET FROZEN — see known_verify_flags[1])
- [Module 3 DataFormats_Reconstruction § 4.3 *TrackParFwd / TrackParCovFwd*](./DataFormats_Reconstruction.md#43-trackparfwd--trackparcovfwd--forward-geometry) — direct `#include "MathUtils/Utils.h"` + `"MathUtils/Primitive2D.h"` [GH: TrackFwd.h] (ANCHOR NOT YET FROZEN)
- Module 5 (reconstruction framework, planned) — tracking & vertexing algorithms call `MathUtils`, `Field`, `ConfigurableParam` pervasively
- All wave-2 detector pages — every detector consumes `Common/Field` for propagation, `Common/Constants` for physics values, and `Common/MathUtils` for geometry/rotation helpers

### 1.4 Phase context (MIWikiAI internal)

This is **Module 4 of Phase 0.1** per `PHASE_0_1_Proposal_AliceO2_Framework_Indexation.md` v3. Modules 1 + 2 gate-approved (2026-04-23); Module 3 v0.2-rev1 in cycle-1b review (gate 3 expected within 2-3 days).

**Review configuration for Module 4:** 9-reviewer panel — 3 Gemini (Gemini1, Gemini2, Gemini3), 4 Sonnet (Sonnet1, Sonnet2, Sonnet3, Sonnet4), 2 Claude (Claude1, Claude2). Main Reviewer role assigned to Claude1 (continuity across modules). Aspect rotation per `PHASE_0_1_Review_Module_4_CommonUtilities.md` §3. Architect enforced cycle-0 self-review for Module 4 (R-6 decision); self-review artifact at `PHASE_0_1_Module_4_CycleZero_SelfReview_Claude8.md`.

Planned after Module 4: Phase 0.1 amendment v3→v4 adding Modules 5 (Reconstruction_framework) and 6 (MC_framework); then wave-2 per-detector pages beginning with TPC.

---

## 2. Context — why `Common/` exists

*Schema note: §2 (context) + §3 (directory layout) follow the schema variation ratified in Phase 0.1 v3 Amendment 3 (precedents: Module 1 §2, Module 2 §2, Module 3 §2). `Common/` is a directory whose names are namespace-like labels; context-before-tree aids the reader.*

### 2.1 The problem `Common/` solves

A detector-oriented project like AliceO2 has a natural temptation: every detector writes its own trigonometry helpers, its own rotation matrix code, its own magnetic-field lookup, its own physics-constant table. This creates three concrete problems:

1. **Numerical drift.** Two detectors computing the same rotation with slightly different implementations produce slightly different results in the boundary region where their reconstruction outputs have to match (ITS-TPC match, TPC-TRD match, etc.). Module 3 §2.2 local-frame convention is only stable across detectors because the rotation helpers are centralized.
2. **Include cycles and link-order fragility.** If detector A's constants header pulls detector B's constants header (because some ZDC constant depends on some FT0 constant), the link graph tangles. A shared `CommonConstants/` breaks the cycle.
3. **Runtime-configurability without recompilation.** Every workflow has tunables — propagation step size, Kalman innovation chi² cut, cluster-finding threshold, number of threads for a GPU backend. Hard-coding these is fine for a prototype; a production run-3 / run-4 system needs them settable at job submission time. `ConfigurableParam` (§5) is the single subsystem that solves this once for the whole O² code base.

The `Common/` directory is the answer to all three: one place where shared infrastructure lives, with stable interfaces, shared across sync/async (online/offline), CPU/GPU, and every detector.

### 2.2 The four functional subsystems

| Subsystem | Directory | Problem domain |
|---|---|---|
| **Math and geometry** | `Common/MathUtils/` | Cartesian frames, rotations, 2D/3D primitives, trig fast-paths, bit-operations, Chebyshev parameterization, fit wrappers |
| **Magnetic field** | `Common/Field/` | 3D B-field lookup for track propagation; handles L3 solenoid + LHC dipole, multiple currents/polarities, fast vs. accurate evaluation paths |
| **Runtime configuration** | `Common/Utils/` | ConfigurableParam — type-safe runtime parameter override from CLI/JSON/TXT, with ROOT dictionary support |
| **Physics / LHC / geometry constants** | `Common/Constants/` (include path `CommonConstants/`) | PDG physics values (masses, lifetimes), LHC machine parameters (bunch structure, revolution frequency), geometric constants (beam-pipe radius etc.), cross-detector constants that would create cycles otherwise |

### 2.3 Cross-cutting design principles observed in `Common/`

- **Header-only where possible.** Constants headers are plain `constexpr` blocks. Geometry primitives and trigonometric fast-paths in `MathUtils/detail/` are often inline templates.
- **ROOT Math as the numeric substrate.** `MathUtils/fit.h` wraps `TLinearFitter`, `TVectorD`, `TF1`, `Fit::Fitter` [GH: fit.h Doxygen]. Covariance matrices use `ROOT::Math::SMatrix` + `SVector` (see Module 3 §2.2). `Common/` does not re-invent linear algebra; it wraps ROOT's for ergonomics.
- **Framework/Logger integration.** `MathUtils/fit.h` includes `Framework/Logger.h` — meaning `Common/` code routes diagnostics through the same logging path as DPL processes (Module 2 v0.2 §3.2 positions Logger as a DPL-side service).
- **`detail/` sub-namespaces.** `o2::math_utils::detail` (e.g. `bitOps.h`, `trigonometric.h`) follows the standard C++ idiom of hiding implementation helpers behind a `detail` layer [GH: math_utils::detail namespace doxygen].
- **Chebyshev3D as a recurring abstraction.** Common/MathUtils ships `Chebyshev3DCalc` — a 3D Chebyshev-polynomial evaluator — because the magnetic field (Common/Field) needs it. One tool, used by two consumers, lives in the lower layer.

### 2.4 The `Common/` ↔ `Framework/` boundary

A natural question: *why aren't the utilities in Framework/?* The split is clean in practice:

- **Framework/** is specifically DPL — the DataProcessor abstraction, messaging, services, lifetimes (Module 2). It is the *runtime framework*.
- **Common/** is substrate that DPL code AND non-DPL code (detector geometry building, simulation hit production, alignment fits) can both call. `ConfigurableParam` is the exemplar: it is used by DPL workflows but ALSO by `o2-sim` (non-DPL) and by stand-alone calibration tools.

In dependency direction: `Framework/` knows about DPL; `Common/` does not know about DPL (other than the `Logger.h` include path, which is framework-provided but header-only). Detectors depend on both.

---

## 3. Directory layout of `Common/`

### 3.1 Top-level `Common/` — subdirectories

**[DIRECT] Enumerated from the working tree at commit `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`** (`git sparse-checkout set Common`, 2026-08-25). This supersedes the inferred listing of v0.1–v0.2 and discharges the v0.2 requirement that Aspect D perform a direct enumeration.

`Common/` contains **ten** subdirectories plus `CMakeLists.txt` and `README.md`.

| Subdirectory | Include path | `.h` | `.cxx` | Module 4 scope? | Status change vs v0.2 |
|---|---|---|---|---|---|
| **`MathUtils/`** | `MathUtils/` | 23 | 10 | **Yes — §4.1** | confirmed |
| **`Field/`** | **`Field/`** | 9 | 9 | **Yes — §4.3** | **[VERIFY] closed** — include path is `Field/`, not `DetectorsBase/Field/` |
| **`Utils/`** | **`CommonUtils/`** | 29 | 31 | **Yes — §5** | confirmed |
| **`Constants/`** | **`CommonConstants/`** | 6 | 0 | **Yes — §6** | confirmed; header count corrected (see §3.5) |
| `SimConfig/` | `SimConfig/` | 12 | 14 | out of scope (Module 6) | confirmed |
| `Types/` | **`CommonTypes/`** | 1 | 0 | out of scope | **[VERIFY] closed** — exists; include path is `CommonTypes/` |
| `maps/` | — (data files) | 0 | 0 | out of scope | **[VERIFY] closed** — exists; contains `mfchebKGI_sym.root`, `sol2k.txt`, `sol5k.txt` |
| **`DCAFitter/`** | `DCAFitter/` | 4 | 4 | **NEW — not in v0.2** | **omitted by v0.1–v0.2 entirely** |
| **`ML/`** | `ML/` | 2 | 1 | **NEW — not in v0.2** | **omitted by v0.1–v0.2 entirely** |
| **`Topologies/`** | — (config files) | 0 | 0 | **NEW — not in v0.2** | **omitted by v0.1–v0.2 entirely**; holds `.xml`/`.cfg` FairMQ topologies |

**Three subdirectories were missing from v0.2 and were not even carried as `[VERIFY]` candidates:** `DCAFitter/`, `ML/`, `Topologies/`. This is the concrete cost of an inferred directory listing, and it is exactly the failure mode v0.2's own `known_verify_flags[2]` anticipated. `DCAFitter/` in particular is production reconstruction code (secondary-vertex fitting), not a peripheral directory.

**`Common/maps/` is confirmed as the default field-map location**, and the link to §4.3 is now direct rather than inferred: `MagneticField::createFieldMap()` defaults its `path` argument to `$VMCWORKDIR/Common/maps/mfchebKGI_sym.root` [DIRECT: `Common/Field/include/Field/MagneticField.h`:L241-244].

**Scope decision for v0.3.** `DCAFitter/`, `ML/` and `Topologies/` are recorded here for structural completeness but are **not indexed** in §4–§6. They are candidates for a future module or a v0.4 scope extension — an architect decision, not a drafter one. What v0.3 fixes is that they are no longer invisible.

**Cross-check against the repository's own manifest.** `Common/README.md` lists Doxygen subpages for Constants, FieldMacros, MathUtils, SimConfig, Topologies, Types, Utils and maps — eight, omitting `DCAFitter/` and `ML/` and adding a `FieldMacros` page. The README is itself incomplete; the working tree is authoritative.


### 3.2 `Common/MathUtils/` contents

**[DIRECT] `Common/MathUtils/include/MathUtils/` at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` — 14 public headers + `detail/` (8 headers).** Complete listing; v0.1–v0.2 named 7 of these from Doxygen and #include evidence.

| Header | Note | New in v0.3? |
|---|---|---|
| `Utils.h` | general math helpers, angle normalization | |
| `Primitive2D.h` | 2D primitives | |
| `Cartesian.h` | Cartesian N-D point/vector, rotation helpers | |
| `CartesianGPU.h` | GPU-side counterpart | **yes** |
| `fit.h` | ROOT fit wrappers; includes `Framework/Logger.h` | |
| `Chebyshev3D.h`, `Chebyshev3DCalc.h` | 3D Chebyshev parameterization + fast evaluator | |
| `SMatrixGPU.h` | GPU SMatrix support | **yes** |
| `SymMatrixSolver.h` | symmetric linear solver | **yes** |
| `BetheBlochAleph.h` | ALEPH Bethe-Bloch parameterization (dE/dx) | **yes** |
| `Tsallis.h` | Tsallis distribution helper | **yes** |
| `LegendrePols.h` | Legendre polynomials | **yes** |
| `CachingTF1.h` | cached `TF1` evaluation | **yes** |
| `RandomRing.h` | pre-generated random-number ring buffer | **yes** |

`detail/` — 8 headers: `Bracket.h`, `CircleXY.h`, `IntervalXY.h`, `StatAccumulator.h`, `TypeTruncation.h`, `basicMath.h`, `bitOps.h`, `trigonometric.h`. v0.1–v0.2 named `bitOps.h` and `trigonometric.h`; the other six are new here.

Two of the new headers are physics-relevant rather than incidental: `BetheBlochAleph.h` is the dE/dx parameterization used in PID, and `Tsallis.h` is a spectrum-shape helper. A reader looking for "where does the Bethe-Bloch parameterization live" would not have found it from v0.2.

### 3.3 `Common/Field/` contents

**[DIRECT] `Common/Field/include/Field/` at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` — 8 public headers.** The include path is **`Field/`**; the `DetectorsBase/Field/` alternative considered in v0.2 is closed as incorrect.

| Header | Class / role | Status vs v0.2 |
|---|---|---|
| `MagneticField.h` | `o2::field::MagneticField` — field-map owner; `createFieldMap()` factory | **[VERIFY] closed** — header confirmed, was inferred |
| `MagFieldFast.h` | fast evaluator for inner propagation loops | inferred → confirmed |
| `MagneticWrapperChebyshev.h` | Chebyshev-parameterization wrapper | inferred → confirmed |
| `MagFieldParam.h` | `MagFieldParam` — field-map type enum + constants | inferred → confirmed |
| `MagFieldFact.h` | field factory | **new in v0.3** |
| `MagFieldContFact.h` | FairRoot container factory | **new in v0.3** |
| `FieldOriginBiasParam.h` | field-origin bias `ConfigurableParam` | **new in v0.3** |
| `ALICE3MagneticField.h` | ALICE 3 upgrade field model | **new in v0.3** |

`FieldOriginBiasParam.h` is worth noting for §5: it is a concrete in-`Common/` consumer of the ConfigurableParam framework, i.e. `Common/Field/` depends on `Common/Utils/`.

### 3.4 `Common/Utils/` contents (include path `CommonUtils/`)

**[DIRECT] 29 headers / 31 sources at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`.** The largest subdirectory in `Common/`. Module 4 indexes the ConfigurableParam family; the remainder is named here so it is not invisible.

ConfigurableParam family — **five** headers, all confirmed:

| Header | Role | Status vs v0.2 |
|---|---|---|
| `ConfigurableParam.h` | base class, registry, `updateThroughStorageMap()` | **[VERIFY] closed** |
| `ConfigurableParamHelper.h` | CRTP helper `ConfigurableParamHelper<P>`, `O2ParamDef`/`O2ParamImpl` macros | confirmed |
| `ConfigurableParamReaders.h` | INI/JSON/config-file readers | **new in v0.3** |
| `ConfigurableParamTest.h` | test-support parameter class | **new in v0.3** |
| `KeyValParam.h` | key/value parameter helper | **new in v0.3** |

Deep API coverage of this family is the companion page's job — see [`Common_utilities_API.md`](./Common_utilities_API.md), currently at v0.6.

The remaining ~24 headers in `CommonUtils/` (filesystem glue, string utilities, tree/ROOT helpers, name confectionery, debug streamers, boost-ptree helpers) are **not indexed** by Module 4. v0.2 flagged that "Utils/ may contain additional helpers"; v0.3 confirms there are many and leaves their indexing to a future scope decision.

### 3.5 `Common/Constants/` contents (include path `CommonConstants/`)

**[DIRECT] `Common/Constants/include/CommonConstants/` at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` — six headers.** v0.2 listed five and closed with "potentially more: search evidence is non-exhaustive". The complete set:

| Header | Contents | Status vs v0.2 |
|---|---|---|
| `PhysicsConstants.h` | PDG masses, lifetimes, decay constants | confirmed |
| `LHCConstants.h` | revolution frequency, bunch structure, orbit duration | confirmed |
| `GeomConstants.h` | geometry constants | confirmed |
| `ZDCConstants.h` | ZDC constants referenceable by non-ZDC code | confirmed |
| `MathConstants.h` | `o2::constants::math` — `PI`, `TwoPI`, `Almost0`, `VeryBig`, … | confirmed (added v0.2) |
| **`Triggers.h`** | trigger-mask constants | **new in v0.3** |

The directory also contains `make_pdg_header.py`, a generator script — evidence that `PhysicsConstants.h` is at least partly **generated** rather than hand-maintained. Worth recording: a consumer must not assume the file is stable across regeneration, and a future edit belongs in the generator, not the header.

---

## 4. MathUtils and Field

### 4.1 `MathUtils/` — the numeric substrate

The `MathUtils/` subsystem collects numeric helpers that every reconstruction / calibration / alignment code path uses. It is organized around four themes:

**Theme 1: geometric primitives.** `Cartesian.h` supplies `CartesianNd<T, N>` point/vector types and rotation operators. `Primitive2D.h` supplies 2D primitives (`IntervalXY`, `Line2D`). Used by TPC clusterization geometry, ITS alignment, track-frame rotation (Module 3 §2.2 local-frame convention relies on this).

**Theme 2: fast trigonometry and bit operations.** `detail/trigonometric.h` + `detail/bitOps.h` — performance-critical helpers used in innermost loops (propagation steps, cluster-finding). Hidden behind `o2::math_utils::detail::` per standard C++ idiom.

**Theme 3: Chebyshev3D parameterization.** `Chebyshev3D` (backing storage) + `Chebyshev3DCalc` (fast evaluator) — 3D Chebyshev-polynomial parameterization. The sole intra-`Common/` dependency of note: `Common/Field/MagneticWrapperChebyshev` uses `Chebyshev3D` to cache the magnetic field.

**Theme 4: fit wrappers.** `fit.h` wraps ROOT's fit subsystem. Exposes polynomial fit, exponential fit, multi-dimensional linear regression with a consistent return type (`TFitResultPtr`). Diagnostics through `Framework/Logger.h` — which is why `MathUtils/fit.h` forms a soft dependency from `Common/` on `Framework/` (header-only — no DPL at runtime).

**Interface discipline observed:**

```cpp
namespace o2::math_utils {
  namespace detail {
    // bit operations, fast trig — implementation helpers
  }
  // Public API: Cartesian, Primitive2D, fit functions, Chebyshev3D*
}
```

All constants or tolerance thresholds — `π`, `2π`, `epsilon` — are defined once in `CommonConstants/MathConstants.h` (namespace `o2::constants::math`: `PI`, `TwoPI`, `PIQuarter`, `Almost0`, `VeryBig`, `LnSqrt2pi`) and referenced via that namespace; additional math helpers live in `MathUtils/Utils.h` [VERIFY — direct Utils.h fetch pending; see known_verify_flags[3]]. Re-defining `#define PI` locally is a code-review flag in this codebase. (v0.2 correction per Sonnet4 N-4 — v0.1 incorrectly attributed the constants catalog to `Utils.h`; PI etc. live in `CommonConstants/MathConstants.h`.)

### 4.2 Dependencies between `MathUtils/` sub-areas

| Needs | Depends on |
|---|---|
| `Chebyshev3D` | ROOT (TObject-derived for ROOT I/O) |
| `Chebyshev3DCalc` | `Chebyshev3D` (reads its coefficients) |
| `fit.h` | ROOT's `TLinearFitter`, `TVectorD`, `TF1`, `Fit::Fitter`, `HFitInterface.h`, `WrappedMultiTF1.h`; plus `Framework/Logger.h` |
| `Cartesian.h` | `ROOT::Math::SVector`, `ROOT::Math::Rotation3D`, `Math/SMatrix.h` |
| `detail/*` | `<cmath>`, `<bit>` — STL only |

### 4.3 `Field/` — the magnetic field model

The ALICE magnetic field is not a uniform 0.5 T solenoid; it is a composite of:

- the L3 magnet (large solenoid enclosing the barrel tracker, nominally ±0.5 T axial);
- the LHC dipole (directing forward charged particles, the `MFT→MCH` muon-spectrometer field);
- compensator magnets (1C/1A/2C/2A — correcting LHC-beam orbit inside the ALICE experimental cavern).

`Common/Field` encapsulates this via:

**`MagneticField`.** Owner of the field model. Construction via factory:

```cpp
MagneticField* MagneticField::createFieldMap(float l3Cur,    // L3 current (kA)
                                             float diCur,    // dipole current (kA)
                                             Int_t convention,  // kConvLHC | kConvDCS2008 | kConvMap2005
                                             Bool_t uniform,
                                             float beamenergy,
                                             const Char_t* beamtype,
                                             const std::string path);
```

Verbatim from [GH: MagneticField.cxx]. The factory handles **at least 3 observed** field parameterization types (`MagFieldParam::k2kG`, `k5kG`, `k5kGUniform`) — full enum pending direct `MagFieldParam.h` fetch (see A.6 + known_verify_flags[5]) — and loads a `Chebyshev3D` parameterization from a `.root` data file via `file->Get(getParameterName())` + `dynamic_cast<MagneticWrapperChebyshev*>(...)`.

**`MagFieldFast`.** The fast evaluator used inside propagation. `std::make_unique<MagFieldFast>(getFactorSolenoid(), ...)` [GH: MagneticField.cxx]. Used when `propagateTo` does many small steps; `MagneticField` itself is too slow for innermost loops.

**`MagneticWrapperChebyshev`.** The accurate evaluator. Wraps a stored `Chebyshev3D` parameterization. Used for precise propagations (secondary vertex fits, material-budget calibrations).

**`MagFieldParam`.** Enumeration of field-map types plus compile-time constants (dipole dimensions `kDip1CZ`, `kDip1hDZ`, `kDip2CZ`, etc.) [GH: MagneticField.cxx constexpr block].

**Polarity conventions.** **Three** declared conventions `[DIRECT]`:

- `kConvLHC` — the canonical LHC convention (l3Pol and diPol independently signed)
- `kConvDCS2008` — the 2008 DCS legacy convention (still in use for some run-2 readback)
- `kConvMap2005` — the 2005 field-map legacy convention

Corrected in v0.3.1. v0.2 listed two on partial evidence; v0.3 asserted exactly two and rejected a reviewer finding on that basis. See Appendix A.5.

`MagneticField::createFieldMap` accepts both via the `convention` parameter and internally maps to a single canonical storage.

### 4.4 Why `Common/` and not per-detector

A tracking algorithm is fundamentally a "given a track and the field, propagate it". The track lives in Module 3 classes (`TrackParCov`, `TrackParCovFwd`); the field lives in `Common/Field`. If every detector shipped its own field model, propagation across detector boundaries (ITS→TPC→TRD→TOF→HMPID) would be numerically inconsistent and matching would be impossible. A single `Common/Field/MagneticField` object, one per job, consulted by every detector, is the only workable design.

---

## 5. ConfigurableParam — runtime parameter framework

### 5.1 The problem

An O² workflow has dozens (sometimes hundreds) of tunable parameters: material-budget scaling factors, Kalman innovation cuts, cluster-finding thresholds, number of threads, CUDA device selection, CCDB URL, output file paths. Hard-coding all of these produces an unbuildable code base; making them all CLI arguments makes every workflow driver unwieldy.

The solution is a central parameter registry with:

- **Type safety.** Parameters are typed (int, float, double, bool, string) and setting a value that can't coerce fails cleanly at startup.
- **Hierarchical naming.** `MainKey.SubKey` (e.g. `TPCGasParam.DriftTime`, `ITSRecoParam.ClusterizerMode`).
- **CLI override.** `--configKeyValues "MainKey.SubKey=value; MainKey2.SubKey2=value2"`.
- **JSON / TXT file override.** `--configFile somefile.json`.
- **ROOT I/O integration.** Parameter values round-trip through CCDB via ROOT streamers.

That registry is `o2::conf::ConfigurableParam`, living in `Common/Utils/`.

### 5.2 Storage model

The core is a global storage map, populated by registration at static initialization time and updated at runtime by `updateThroughStorageMap`:

```cpp
// Paraphrased from ConfigurableParam.cxx
bool ConfigurableParam::updateThroughStorageMap(std::string mainkey,
                                                std::string subkey,
                                                std::type_info const& tinfo,
                                                void* addr);

bool ConfigurableParam::updateThroughStorageMapWithConversion(
    std::string const& key,
    std::string const& valuestring);
```

The "WithConversion" variant handles the CLI path: a string like `"42"` is coerced to an `int`, with explicit range checks at char/unsigned-char boundaries [GH: ConfigurableParam.cxx lines 757-773 handle overflow for 8-bit types].

### 5.3 Registration pattern

Per common usage across the AliceO2 codebase, parameters are registered via a CRTP base + macro pattern. **The pattern lives in two headers**, not one (v0.1 elided this distinction; corrected in v0.2 per Claude2 N-3):

- `CommonUtils/ConfigurableParam.h` — declares the base class and storage-map API
- `CommonUtils/ConfigurableParamHelper.h` — declares the CRTP helper (`ConfigurableParamHelper<T>`) and the `O2ParamDef` / `O2ParamImpl` macros

**Declaration (header, e.g. `TPCGasParam.h`):**

```cpp
#include "CommonUtils/ConfigurableParamHelper.h"

struct TPCGasParam : public o2::conf::ConfigurableParamHelper<TPCGasParam> {
  float DriftTime = 100.0f;
  float PressureScaling = 1.0f;

  O2ParamDef(TPCGasParam, "TPCGasParam");   // inside the struct
};
```

**Definition (source file, e.g. `TPCGasParam.cxx`):**

```cpp
#include "DataFormatsTPC/TPCGasParam.h"

O2ParamImpl(TPCGasParam);                    // file scope, exactly ONE translation unit
```

**ODR warning.** `O2ParamImpl(TPCGasParam)` must appear in **exactly one** `.cxx` translation unit per parameter struct. Placing it in a header (or in multiple `.cxx` files) produces ODR violations at link time. v0.1's code example merged the declaration and definition into a single block which — if copy-pasted literally — would trigger this exact bug. v0.2 corrects the presentation per Claude2's in-session fetch of [DX: SpacePointsCalibConfParam.h line 17-18] showing the canonical two-header / two-file pattern.

**Status of this subsection (cycle-1 resolution).** CRTP inheritance via `ConfigurableParamHelper<T>` is CLOSED per Claude2 direct fetch. `O2ParamDef` / `O2ParamImpl` macro internals remain flagged in `known_verify_flags[4]` pending full macro-expansion verification.

**Runtime behavior.** At static-init time, the `O2ParamImpl` expansion registers all fields into the global storage. At runtime, CLI arguments `--configKeyValues "TPCGasParam.DriftTime=95.5"` override defaults via `updateThroughStorageMapWithConversion` [GH: ConfigurableParam.cxx].

### 5.4 Why this lives in `Common/`, not `Framework/`

`ConfigurableParam` is used by:

- DPL workflows (consume `--configKeyValues` through `Framework/ConfigContext`)
- `o2-sim` (non-DPL simulation driver)
- Stand-alone calibration tools (e.g. TPC dE/dx calibration fits)
- CCDB object builders (serialize a parameter struct into a run-valid ROOT object)

Since the first consumer is DPL and the others are not, putting `ConfigurableParam` in `Framework/` would create a wrong dependency direction — `o2-sim` and CCDB tools should not depend on DPL. `Common/Utils/` is the correct location: it is the substrate both DPL and non-DPL code can call.

### 5.5 Cross-reference to Module 2 (DPL)

DPL integrates `ConfigurableParam` via the `ConfigContext` passed to `defineDataProcessing` [Module 2 v0.2 §4 *Core concepts* covers this flow]. A DPL workflow reads `context.options().get<...>` for DPL-side options; `ConfigurableParam` handles the rest.

---

## 6. Constants

### 6.1 `CommonConstants/` — the unified constants catalog

Every physics analysis and every detector reconstruction needs the same numbers: the π meson mass, the proton mass, the speed of light in the local unit system, the LHC revolution frequency, the ALICE beam-pipe radius. `CommonConstants/` (physically `Common/Constants/include/CommonConstants/`) is where these live.

| Header | Typical contents | Representative consumers |
|---|---|---|
| `PhysicsConstants.h` | Particle masses (π, K, p, e, μ), lifetimes, coupling constants, PDG-aligned numeric values | [GH: ZDCBase/Constants.h:15, HF candidate creators in O2Physics] |
| `LHCConstants.h` | Revolution frequency, orbit duration, bunches per orbit, bunch structure | [GH: AnalysisDataModel.h, O2Physics timestamp.cxx, eventSelection.cxx] |
| `GeomConstants.h` | Beam-pipe radius, primary vertex region length, ALICE cavern reference positions | [GH: AnalysisDataModel.h] |
| `ZDCConstants.h` | ZDC time bin structure, channel counts (`NTimeBinsPerBC = 12`), detector-ID enums | [GH: ZDCBase/Constants.h:17 includes it and extends the sub-detector enum] |
| `MathConstants.h` | Namespace `o2::constants::math` — PI, TwoPI, PIQuarter; numerical tolerances Almost0, VeryBig; normalization constants like LnSqrt2pi | [GH: AnalysisDataModel.h — included in the `CommonConstants/` block; MathUtils/detail/trigonometric.h uses these] |

### 6.2 Why ZDCConstants lives in Common/ rather than in Detectors/ZDC/

A plausible question: if `ZDCConstants.h` is ZDC-specific, why does it live in `Common/Constants/` and not `DataFormats/Detectors/ZDC/include/DataFormatsZDC/`? The answer is cross-detector usage. The AOD `AnalysisDataModel.h` references `CommonConstants/ZDCConstants.h` [GH: AnalysisDataModel.h include block]. If ZDCConstants lived in the ZDC tree, `AnalysisDataModel.h` would pull the full ZDC DataFormats subtree into every DPL process that consumes AOD — a huge and unnecessary dependency.

By placing cross-cutting constants in `CommonConstants/`, the project keeps them lightweight and avoids include-cycle / link-bloat issues.

**[VERIFY — known_verify_flags[7]].** This rationale is inferred from observed placement. The documented project policy (if any) in CodingGuidelines.md has not been verified.

### 6.3 Unit and precision conventions

Observed from the codebase [VERIFY — see known_verify_flags[6]]:

- **Lengths** in cm (ALICE tracking convention).
- **Times** in ns for short-lived quantities; µs for BC-aligned quantities; seconds for SOR/EOR-scale quantities.
- **Momenta** in GeV/c.
- **Charges** in units of elementary charge e.
- **B-field** in kG (kiloGauss) — note `MagFieldParam::k5kGUniform` etc. are named after kG values, matching the historical ALICE convention; 5 kG = 0.5 T.

Closure of these assertions requires direct `PhysicsConstants.h` fetch — Aspect F primary (Gemini3) noted the unit-convention list but did not close it in cycle-1.

---

## 7. Cross-references to MIWikiAI wiki

| Link | Referenced from | Status |
|---|---|---|
| [`./AliceO2_overview.md § 3.1 Top-level directory tree`](./AliceO2_overview.md#31-top-level-directory-tree) | §1.3, §3.1 | **live (APPROVED v0.5, 2026-04-23 — gate 1)** |
| [`./Framework_DPL.md § 3.2 What lives inside Framework/Core/`](./Framework_DPL.md#32-what-lives-inside-frameworkcore) | §1.3, §2.3 | **live (APPROVED v0.2, 2026-04-23 — gate 2)** |
| [`./DataFormats_Reconstruction.md § 2.2 Local-frame convention`](./DataFormats_Reconstruction.md#22-the-local-frame-convention-why-5d-not-6d) | §1.3, §2.1 | DRAFT v0.2-rev1 — **anchor not yet frozen**; will refresh post-gate 3 |
| [`./DataFormats_Reconstruction.md § 4.3 TrackParFwd/TrackParCovFwd`](./DataFormats_Reconstruction.md#43-trackparfwd--trackparcovfwd--forward-geometry) | §1.3, §4.1 (MathUtils consumer evidence) | DRAFT v0.2-rev1 — **anchor not yet frozen** |
| `./Reconstruction_framework.md` (Module 5, planned) | §1.3 | planned; pending Phase 0.1 v4 amendment |
| `./MC_framework.md` (Module 6, planned) | §1.3 (SimConfig deferral) | planned; pending Phase 0.1 v4 amendment |

---

## 8. External references

### 8.1 AliceO2 repository (primary, [GH])

| Topic | URL |
|---|---|
| `Common/` tree | https://github.com/AliceO2Group/AliceO2/tree/dev/Common |
| `Common/MathUtils/` tree | https://github.com/AliceO2Group/AliceO2/tree/dev/Common/MathUtils |
| `Common/Field/src/MagneticField.cxx` | https://github.com/AliceO2Group/AliceO2/blob/dev/Common/Field/src/MagneticField.cxx |
| `Common/Utils/` tree | https://github.com/AliceO2Group/AliceO2/tree/dev/Common/Utils |
| `Common/Constants/` tree (include path `CommonConstants/`) | https://github.com/AliceO2Group/AliceO2/tree/dev/Common/Constants |
| TrackFwd.h (Module 3 evidence for MathUtils/Utils.h + Primitive2D.h) | https://github.com/AliceO2Group/AliceO2/blob/dev/DataFormats/Reconstruction/include/ReconstructionDataFormats/TrackFwd.h |
| AnalysisDataModel.h (CommonConstants include block evidence) | https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/AnalysisDataModel.h |

### 8.2 Published documentation ([DX])

| Topic | URL |
|---|---|
| AliceO2 Doxygen landing | https://aliceo2group.github.io/AliceO2/ |
| `MathUtils/fit.h` Doxygen | https://aliceo2group.github.io/docs/d5/d71/fit_8h.html |
| `MathUtils/detail/trigonometric.h` Doxygen source | https://aliceo2group.github.io/docs/dd/d7d/trigonometric_8h_source.html |
| `MathUtils/Chebyshev3DCalc.cxx` Doxygen source | https://aliceo2group.github.io/docs/d0/df2/Chebyshev3DCalc_8cxx_source.html |
| `o2::math_utils::detail` namespace | https://aliceo2group.github.io/AliceO2/d4/dbd/namespaceo2_1_1math__utils_1_1detail.html |
| `ConfigurableParam.cxx` Doxygen source | https://aliceo2group.github.io/AliceO2/dd/d03/ConfigurableParam_8cxx_source.html |

### 8.3 Peer-reviewed ([PP])

| Document | Citation |
|---|---|
| O² software framework + GPU usage | Eulisse & Rohr, arXiv:2402.01205 (2024). https://arxiv.org/abs/2402.01205 |

### 8.4 Related repositories

| Topic | URL |
|---|---|
| ROOT Math (SMatrix, SVector, Fit) | https://root.cern/doc/master/group__SMatrixGroup.html |
| AliceO2Group/O2Physics (downstream consumer of CommonConstants) | https://github.com/AliceO2Group/O2Physics |
| AliceO2Group/Configuration (separate configuration system for online DCS — not the same as Common/Utils ConfigurableParam) | https://github.com/AliceO2Group/Configuration |

---

## Appendix A: Structural closure checks

**All seven checks are CLOSED in v0.3.** Every one was `NOT CLOSED` or `CLOSED with caveat` in v0.2, and all seven were blocked on the same missing act: a direct enumeration at a pinned commit. That enumeration was performed for v0.3 — `git clone --filter=blob:none --sparse --depth 1 --branch dev` + `git sparse-checkout set Common`, working tree at **`ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`**, 2026-08-25.

### A.1 `Common/` subdirectory count

**Claim (v0.3).** Ten subdirectories, plus `CMakeLists.txt` and `README.md`.

**Evidence.** [DIRECT] working-tree listing at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`.

**Result: CLOSED ✅** — and the v0.2 claim was wrong in both directions. All three `[VERIFY]` candidates (`SimConfig/`, `Types/`, `maps/`) exist, **and** three further subdirectories existed that v0.2 did not list at all: `DCAFitter/`, `ML/`, `Topologies/`. 7 rows → 10.

### A.2 `MathUtils/` header count

**Claim (v0.3).** 14 headers in `include/MathUtils/` plus 8 in `detail/`; 10 `.cxx` in `src/`.

**Evidence.** [DIRECT] listing at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`.

**Result: CLOSED ✅** — v0.2 covered 8 of 22. Notable omissions now recorded: `BetheBlochAleph.h`, `Tsallis.h`, `SMatrixGPU.h`, `SymMatrixSolver.h`, `LegendrePols.h`, `CachingTF1.h`, `RandomRing.h`, `CartesianGPU.h`.

### A.3 `Field/` class count

**Claim (v0.3).** 8 headers in `include/Field/`, 9 `.cxx` in `src/`.

**Evidence.** [DIRECT] listing at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`.

**Result: CLOSED ✅** — v0.2's four inferred classes all confirmed as real headers; four more found (`MagFieldFact.h`, `MagFieldContFact.h`, `FieldOriginBiasParam.h`, `ALICE3MagneticField.h`). The include path is **`Field/`**, closing `known_verify_flags[5]`.

### A.4 `CommonConstants/` header count

**Claim (v0.3).** Six headers, plus the generator script `make_pdg_header.py`.

**Evidence.** [DIRECT] listing at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`.

**Result: CLOSED ✅** — the v0.2 caveat ("there may be additional headers not surfaced by this sample of consumers") was justified: `Triggers.h` was missing. 5 → 6.

### A.5 B-field polarity convention count — **FIX-13 upheld, v0.3 rejection withdrawn**

**Claim (v0.3.1).** **Three** polarity conventions.

> **⚠ P0 correction.** v0.3 claimed exactly two and, on that basis, **rejected** Gemini1's A-1 finding. The claim was false and the rejection is withdrawn. Root cause, recorded because it is mechanically preventable: the drafter's search was `grep -n "kConvLHC\|kConvDCS2008\|kNConventions\|enum.*Conv"` — a pattern enumerating the two members he expected. `kConvMap2005` matches none of those alternatives. The search found exactly what it was told to look for, the citation stopped one line short of the closing brace, and the absence of a third member was inferred from the silence. Same failure class as the AO2D `:L498` and `L1078-L1078` findings: **a citation range that ends inside the construct it cites.**

**Evidence.** [DIRECT] `Common/Field/include/Field/MagneticField.h`:**L50-52** at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` (file sha256 `93100b5a18c20b51cfec…`):

```cpp
  enum PolarityConvention_t { kConvLHC,
                              kConvDCS2008,
                              kConvMap2005 };
```

**Result: CLOSED ✅ — Gemini1 A-1 UPHELD IN SUBSTANCE.** FIX-13, deferred from v0.2 under architect ruling R-1, resolves **in favour of** the finding, with one correction to it:

| | Verdict |
|---|---|
| Gemini1's claim that the two-convention count was **incomplete** | **correct** |
| Gemini1's identification of the third member as *"Automatic/CCDB-managed"* | **incorrect** — it is `kConvMap2005`, a 2005 field-map legacy convention |
| v0.3's rejection of the finding | **withdrawn** |

The finding was labelled `UNVERIFIED` when raised, and it was right anyway. A reviewer flagging an incomplete enumeration without being able to name the missing member is still supplying real signal, and v0.3 discarded it.

### A.6 `MagFieldParam` field-map type count

**Claim (v0.3).** Three field-map types plus a count sentinel.

**Evidence.** [DIRECT] `Common/Field/include/Field/MagFieldParam.h`:L34-39:

```cpp
  enum BMap_t {
    k2kG,
    k5kG,
    k5kGUniform,
    kNFieldTypes
  };
```

**Result: CLOSED ✅** — v0.1's "5 types" was wrong; v0.2's cautious "at least 3 observed" was right and is now exact: **3 types + `kNFieldTypes` sentinel**. The cycle-1 CV-2 correction is vindicated.

### A.7 Source identity

**Claim (v0.3).** `commit_verified: ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` — 40 characters, `pin_status: recovered`.

**Evidence.** `git rev-parse HEAD` on the sparse clone used for every §3 claim above.

**Result: CLOSED ✅** — supersedes the 7-character `87b9775` carried forward through Modules 1–3, which was never a valid source identity under MIWikiAI Source Identity Convention v0.3 §7.4 and whose freshness v0.2 itself declared unverified. `known_verify_flags[0]` closed.

**Note for Modules 1–3.** They carry the same 7-character SHA. Under the Convention this is a shared defect, and re-pinning them is a separate bounded pass — not in scope here, but it should not be allowed to disappear.

---

## Appendix B: Notation

### B.1 Primary-source inline-tag grammar

Identical to Modules 1-3. See [`AliceO2_overview.md §B.1`](./AliceO2_overview.md#b1-primary-source-inline-tag-grammar) for `[GH]`/`[DX]`/`[QS]`/`[AD]`/`[TDR]`/`[PP]`/`[CC]`/`[CONFLICT-N]` definitions.

### B.2 Common/-specific terminology

| Term | Definition |
|---|---|
| **Chebyshev3D** | 3D Chebyshev-polynomial parameterization of a smooth 3-argument function (e.g. magnetic field over a box). Backing storage. |
| **Chebyshev3DCalc** | Fast evaluator for a stored Chebyshev3D. Inner-loop-friendly. |
| **MagFieldParam** | Enum + compile-time constants specifying which canonical field-map type is in use (k2kG / k5kG / k5kGUniform / ...). |
| **MagFieldFast** | Fast field evaluator for inner propagation loops; trades a small fraction of accuracy for ~10× speed. |
| **MagneticWrapperChebyshev** | Accurate field evaluator backed by a stored Chebyshev3D parameterization. |
| **ConfigurableParam** | The runtime parameter framework in `Common/Utils/`. Named parameter registry with CLI/JSON override. |
| **--configKeyValues** | The standard CLI flag consumed by every O² workflow to override ConfigurableParam defaults. |
| **CommonConstants** | The include path (physical dir: `Common/Constants/include/CommonConstants/`) for physics, LHC, geometry, and cross-detector constants. |
| **kConvLHC** / **kConvDCS2008** / **kConvMap2005** | The three magnetic-field polarity conventions declared by `PolarityConvention_t` and accepted by `MagneticField::createFieldMap` [DIRECT `MagneticField.h`:L50-52]. |
| **o2::math_utils::detail** | The hidden implementation-helper sub-namespace inside MathUtils (bitOps, trigonometric). |

### B.3 B-field units and conventions (cross-referenced to §6.3)

Observed:

| Quantity | Unit | Example |
|---|---|---|
| B-field magnitude | kG (kiloGauss) | 5 kG = 0.5 T (nominal L3 solenoid) |
| Current | kA (kiloAmperes) | L3: ~30 kA for 5 kG [VERIFY — ALICE magnet specification not directly cited; see known_verify_flags[6]]; Dipole: ~6 kA [VERIFY] |
| Length | cm | `kDip1CZ = 6310.8` (cm) |
| Energy | GeV | `beamenergy` parameter of `createFieldMap` denotes **per-beam** energy (not per-nucleon-pair, not total); e.g. 6500 GeV for Run 3 pp at √s = 13 TeV, 2511 GeV/nucleon for PbPb at √sNN = 5.02 TeV [VERIFY — semantics inferred from usage context, not from MagneticField.h fetch; cross-check pending] |

---

## Changelog

### v0.3.1 (2026-08-25) — P0 correction: three polarity conventions, FIX-13 upheld

**Driver.** P0 raised in the `PHASE_0_3_REVIEW_TOOLING` v0.1 consolidated review (`Claude5:MIWikiAI`, 2026-08-25) against this document, surfaced while testing a source-cache prototype. Disclosed there as the consolidator's own drafting error.

**The defect.** `MagneticField.h`:**L50-52** at `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` declares **three** polarity conventions:

```cpp
  enum PolarityConvention_t { kConvLHC,
                              kConvDCS2008,
                              kConvMap2005 };
```

v0.3 cited **L50-51**, claimed exactly two, and on that basis **rejected** Gemini1's A-1 finding (FIX-13), which had been deferred from v0.2 under architect ruling R-1.

**Disposition.** Gemini1's finding is **upheld in substance**: the two-convention count was incomplete. Gemini1's identification of the third member as *"Automatic/CCDB-managed"* was **wrong** — it is `kConvMap2005`. So the correct record is *count refuted, finding upheld, label corrected* — not a clean reinstatement.

**Root cause, recorded because it is mechanically preventable.** The drafter's search was:

```
grep -n "kConvLHC\|kConvDCS2008\|kNConventions\|enum.*Conv"
```

Every alternative names something the drafter already expected. `kConvMap2005` matches none. The search returned exactly the two members it was told to find, the citation stopped one line short of the closing brace, and absence was inferred from silence. This is the same failure class as the AO2D `:L498` fabrication and the `L1078-L1078` label: **a citation range ending inside the construct it cites.** `PHASE_0_3` §8.7's `[VERBATIM]` check catches it mechanically; finding F-10 of that review adds *"citation ending mid-construct must FAIL"* to the adversarial suite, using this case as the fixture.

**Changes.** §4.3 conventions two → three, with `kConvMap2005`; §4.3 code comment; Appendix A.5 rewritten (claim, `[DIRECT]` evidence at L50-52, disposition table); `known_verify_flags_closed_in_v0_3` FIX-13 entry REJECTED → UPHELD; glossary; searchable keywords. The v0.3 changelog's false statement is **retained verbatim** and annotated, not deleted — it was published and committed, so the correction belongs beside it in the record.

**Not changed.** Everything else in v0.3, including the ten-subdirectory enumeration, all header inventories, and the `MagFieldParam::BMap_t` count. Those were verified by direct listing rather than by grep pattern, and re-checking A.6 at the same commit confirms `k2kG`, `k5kG`, `k5kGUniform`, `kNFieldTypes` unchanged.

**Also corrected outside this document.** The v0.3 commit message records *"FIX-13 resolved AGAINST the finding"*. That statement is false in the repository history and should be corrected in the v0.3.1 commit message.

### v0.3 (2026-08-25) — direct source enumeration

**Driver.** v0.2 shipped with seven open structural-closure checks (Appendix A), six `[VERIFY]` flags and one deferred finding, all blocked on a single missing act that v0.2 named explicitly: *"Full DIRECT directory listing of `Common/` at SHA 87b9775 NOT yet performed — Aspect D red-team-fetch MUST produce it."* v0.3 performs it.

**Method.** `git clone --filter=blob:none --sparse --depth 1 --branch dev` + `git sparse-checkout set Common`; working tree at **`ae7df2bd37d0a8b32a6c73cab33cae25b4501e49`**. Source Identity Convention v0.3 §6 Method B, `acquisition_method: direct_git`.

**Findings.**

- **P0 — three subdirectories were entirely absent from v0.2**: `DCAFitter/` (4 `.h` / 4 `.cxx`, secondary-vertex fitting — production reconstruction code), `ML/` (2/1), `Topologies/` (FairMQ `.xml`/`.cfg`). They were not `[VERIFY]` candidates; they were invisible. §3.1 rewritten from 7 inferred rows to 10 enumerated rows.
- **P0 — source identity corrected.** `87b9775` (7 chars, carried forward from Modules 1–3, freshness never verified) → `ae7df2bd37d0a8b32a6c73cab33cae25b4501e49` (40 chars, `pin_status: recovered`).
- **P1 — all six `[VERIFY]` flags closed.** `SimConfig/`, `Types/`, `maps/` all exist. Include paths resolved: `Types/` → **`CommonTypes/`**, `Field/` → **`Field/`** (not `DetectorsBase/Field/`), `Utils/` → `CommonUtils/`.
- **P1 — FIX-13 resolved against the finding.** ⚠ **This statement is FALSE and was corrected in v0.3.1 — see the v0.3.1 changelog above.** `MagneticField.h`:L50-52 declares three conventions. Retained verbatim rather than edited, because the erroneous claim was published and committed; the correction belongs in the record beside it, not in place of it.
- **P1 — A.6 exact.** `MagFieldParam::BMap_t` = `k2kG`, `k5kG`, `k5kGUniform`, `kNFieldTypes`. v0.1's "5 types" wrong; v0.2's "at least 3 observed" correct and now exact.
- **P1 — header inventories completed.** MathUtils 8 → 22 (14 + 8 `detail/`); Field 4 inferred → 8 confirmed; CommonConstants 5 → 6 (`Triggers.h`); ConfigurableParam family 2 → 5.
- **P1 — all seven Appendix A checks CLOSED.** Previously 4 `NOT CLOSED`, 2 `CLOSED with caveat`, 1 deferred.
- **P2 — `Common/maps/` link made direct.** `createFieldMap()` defaults `path` to `$VMCWORKDIR/Common/maps/mfchebKGI_sym.root` [`MagneticField.h`:L241-244]; v0.2 inferred this.
- **P2 — `PhysicsConstants.h` is partly generated** — `make_pdg_header.py` sits alongside it. Edits belong in the generator.
- **P2 — `FieldOriginBiasParam.h`** records an intra-`Common/` dependency: `Field/` consumes `Utils/`'s ConfigurableParam.
- **P2 — `Common/README.md` is itself incomplete** — its Doxygen subpage list omits `DCAFitter/` and `ML/`. Recorded so it is not mistaken for a manifest.

**Provenance change.** v0.1–v0.2 rested primarily on Doxygen HTML pages, web search and downstream `#include` statements. Under the ratified Source Identity Convention a Doxygen page is a **derived** artifact and cannot be primary source identity. Those citations are retained as historical provenance; every structural claim in §3 and Appendix A is now `[DIRECT]`.

**Not changed.** §2 rationale, §4–§6 narrative, §7–§8 cross-references. The three newly-found subdirectories are **recorded but not indexed** — extending Module 4's scope to `DCAFitter/` and `ML/` is an architect decision.



- **v0.2 — 2026-04-24 — cycle-1 fix-pass.** Applied 21 fixes from Claude7 Main Reviewer synthesis (2 P0 + 11 P1 + 8 P2). Key structural changes: (FIX-1 P0) §3.1 `Utils/` include path `(bare)` → `CommonUtils/` per 3-way convergent evidence (CV-1: Claude1 WD-1 via PHOSSimParams.h, Claude2 B-P1-2 via SpacePointsCalibConfParam.h, Sonnet1 C-1 independent verification); (FIX-3+4+7) §5.3 restructured into proper header/.cxx split with ODR footnote, ConfigurableParamHelper.h added as distinct second header (Claude2 in-session fetch); (FIX-5) §3.5 + §6.1 + §4.1 add `MathConstants.h` as 5th CommonConstants header (Sonnet4 N-4 — best non-Opus finding this cycle); (FIX-6) §3.1 `SimConfig/` upgraded [VERIFY] → confirmed/Module-6-scope (Claude1 WD2 via Cave.cxx:146); (FIX-8) §4.3 "5 field parameterization types" → "at least 3 observed" (CV-2 4-way convergent); (FIX-9) `review_cycle: 0 → 1` (CV-4); (FIX-10) Module 3 §2.2 anchor corrected `#22-the-local-frame-convention-why-5d-not-6d` (CV-5); (FIX-12) upstream[] adds Wenzel et al. CHEP 2018 EPJ 214, 05034 (Claude1 red-team fetch D3). Plus 8 P2 polish items. **DISCARDED finding:** Gemini2 G-1 — claimed Module 2 §3.2 anchor broken; 3 independent reviewers (Claude2, Sonnet1, Sonnet4) verified the anchor resolves correctly; applying the "fix" would break a working anchor. Deferred to v0.3 pending architect R-1 ruling: FIX-13 (Gemini1 A-1 third polarity convention, UNVERIFIED — needs direct MagneticField.h fetch) + Aspect D directory enumeration (robots.txt blocker) + SHA freshness check. **Eight** `known_verify_flags` retained (v0.1 also had 8; v0.1 changelog text incorrectly said "Seven" — corrected here per FIX-16). Panel: 2 Opus + 4 Sonnet + 3 Gemini reported; quality ranking Opus > Sonnet >> Gemini; recommendations for Module 5 prompt addenda delivered separately.

- **v0.1 — 2026-04-24 — initial draft.** Indexed `Common/MathUtils/` (math + geometry + Chebyshev + fit wrappers), `Common/Field/` (MagneticField + MagFieldFast + MagneticWrapperChebyshev + MagFieldParam), `Common/Utils/` ConfigurableParam subsystem, `Common/Constants/` (include path `CommonConstants/` — **eight** `known_verify_flags` documenting un-fetched items and anchor-shift risk from Module 3). No `source_inconsistencies` — cited sources concur. SHA `87b9775` carried forward from Modules 1-3; freshness re-verification deferred to Aspect D. Cycle-0 self-review performed 2026-04-24 (sibling file `PHASE_0_1_Module_4_CycleZero_SelfReview_Claude8.md`). 9-reviewer panel dispatched: 3 Gemini + 4 Sonnet + 2 Claude.

---

*Indexed by Claude8 on 2026-04-24. Team MIWikiAI. v0.2 CYCLE_1_FIX_PASS_COMPLETE — awaiting architect gate 4. Panel synthesis: Claude7 Main Reviewer, 9/9 reports consolidated into 21 fixes; 1 Gemini hallucination excluded.*

*Quota: no session-block / quota-loss signals observed.*
