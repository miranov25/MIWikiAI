---
wiki_id: ATO-630_ClusterErrParam_TPCWorkshop_20260420
title: "ALICE — Cluster/tracklet error parametrization: Impact of occupancy on TPC space-point resolution, tracking, and PID (TPC calibration workshop ALICE/sPHENIX, 20.04.2026)"
project: MIWikiAI / ALICE
folder: presentations
source_type: workshop-presentation-index
source_title: "ALICE: Cluster/tracklet error parametrization (Google Slides; workshop deck 20.04.2026)"
source_fingerprint:
  upstream:
    - id: ATO-630-Slides-Workshop-2026-04-20
      title: "ALICE: Cluster/tracklet error parametrization — Impact of Occupancy on TPC Space Point Resolution, tracking and PID"
      drive_filename: "ATO-630_SystermaticError_TPCmeeting_24012023"
      drive_id: "1PNHf-uIxFSIrnGpcXaW5xAwABfgDEGMlTNXySjtfKBg"
      view_url: "https://docs.google.com/presentation/d/1PNHf-uIxFSIrnGpcXaW5xAwABfgDEGMlTNXySjtfKBg/edit"
      owner: "Marian Ivanov"
      venue: "TPC calibration workshop ALICE / sPHENIX, 20.04.2026"
      deck_lineage: "Distilled workshop version of the ~207-slide working deck indexed as ATO-630_OccupancyImpact_OfflineWeek_20241031. Slide count: 23 (compact reorganisation). Adds NEW content vs parent: (i) V0 global-fit Run2→Run3 comparison table (slides 7–8), (ii) corrected gas-gain widening formula (slide 12), (iii) updated summary framing with ×2.5 headline."
      extracted_slides: 23
      filename_note: "Drive filename inherits 2023 stem (`Systermatic` typo, `24012023` date) from the 207-slide parent; wiki_id normalises to workshop date 20260420 and topic token `ClusterErrParam`."
      predecessor_wiki_id: ATO-630_OccupancyImpact_OfflineWeek_20241031
      predecessor_drive_id: "1fWy2IRnJW-VDMtbYhyrhIFGkEMsvlSt8-fhiLjqvCfA"
    - id: Ivanov-CHEP2003-arXiv
      title: "Weight-fluctuation theory of TPC cluster resolution (CHEP 2003 proceedings preprint)"
      arxiv: "physics/0306108"
      url: "https://arxiv.org/pdf/physics/0306108.pdf"
      role: "theoretical base for diffusion + angular + combined cluster-resolution formulas; slide 10 citation; also underpins slide 12 Q-dependent eq 23–24 structure and slide 15 nearest-neighbour derivation"
      indexed_as: "articles/arxiv_physics_0306108_Belikov_Ivanov_TPC_tracking.md"
    - id: Ivanov-CHEP2006-TRD
      title: "TRD tracklet-based tracking (CHEP 2006 proceedings)"
      url: "https://indico.cern.ch/event/408139/contributions/979783/attachments/815694/1117684/MarianIvanovchep06.pdf"
      role: "foundational method for slides 19, 21, 22 — robust tracklet fit (median/LTS), Δangle outlier weighting, TRD Run1 heritage for the Run3 TPC mitigation plan"
      indexed_as: "articles/Ivanov2006_TRD_tracking.md"
    - id: ALICE-TPC-NIM-2010
      title: "The ALICE TPC, a large 3D tracking device with fast readout (Alme et al.)"
      journal: "Nucl. Instrum. Meth. A 622 (2010) 316–367"
      url: "https://www.sciencedirect.com/science/article/pii/S0168900210008910"
      role: "Run 1/2 analytical parameterization of space-point resolution (MWPC era, low IR); slide 10 reference"
      indexed_as: "articles/Alme_2010_section_11_performance_detailed.md"
    - id: ALICE-TPC-pass2-MDPI
      title: "Run 1 / Run 2 pass2 tracking fix — Q, dEdx, rate dependence in cluster error (Arslandok et al.)"
      journal: "Particles 5(1) (2022) 8"
      url: "https://www.mdpi.com/2571-712X/5/1/8"
      role: "slide 10 reference — documents the pass2 fix in which Q/dEdx/rate dependence was added; Run 3 is re-doing this lesson"
      indexed_as: "articles/Arslandok-2022-TPC-Tracking.md"
    - id: ATO-630-ErrParam-Code
      title: "ATO-630_ErrParam.C — reference implementation of getResolutionScaled / getResolutionQ"
      url: "https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/22bd07586bed2e118fcb5ffd6586149e5de9d113/JIRA/ATO-630/ATO-630_ErrParam.C#L9-28"
      role: "slide 12 code blocks (Aug-2023 no-Q version + May-2024 Q-version)"
    - id: Ivanov-Overleaf-Thesis
      title: "Ivanov PhD thesis — public note (Overleaf project)"
      url: "https://www.overleaf.com/project/642845e49aeb65eb8a4c23aa"
      role: "slide 11 variable-definition reference; umbrella thesis into which this work feeds"
    - id: Companion-Mitigation-Talk
      title: "Companion workshop talk — mitigation strategies for combined tracking & PID"
      url: "https://indi.to/Q69HN"
      role: "explicit cross-reference on slide 23 (Summary)"
  summary_version: "workshop-final 2026-04-20"
  summary_review_panel:
    - "Claude2 (content + arithmetic, wiki-source-verified)"
    - "Claude5 (wiki-governance / indexation)"
    - "Claude7 (structural / MTTU)"
    - "Claude8 (slide-by-slide author-facing review + synthesis)"
source_last_verified: 2026-04-20
author: Marian Ivanov (dissertation lead; speaker)
indexed_by: Claude8
indexing_model: Claude Opus 4.7
indexed_on: 2026-04-20
review_status: DRAFT
review_cycle: 0
peer_reviewers: []
hard_constraints_checked: {correctness: partial, reproducibility: partial, safety: partial}
staleness: fresh
source_status: COMPLETE
known_verify_flags:
  - "§3.1 σ_rφ ≈ 0.02 cm at inner wall / 0.1 cm at primary vertex — track-level (√N_hits over ~150 clusters), NOT cluster-level (~300–800 μm per Alme 2010 §11.1); calibration-precision targets are derived operational thresholds, source for those numbers is Run-3 calibration notes not yet indexed"
  - "§3.3 k_MS = 0.1 at inner wall, 3 at vertex — likely defined in thesis or parent ATO-630 deck; not in CHEP2003 or Alme 2010"
  - "§5.1 Gas-gain widening factor √(1+(σ_GG/⟨GG⟩)²) — corrected on slide 12 of this deck; CHEP2003 eq 8; MWPC ratio ≈ 1 → √2, GEM ratio ≈ √2·MWPC → √3; ratio Run3/Run2 = √3/√2 ≈ 1.22, Fe⁵⁵-verified. NOTE: parent OfflineWeek wiki and deck carry an earlier product-form approximation √2·σ/⟨G⟩ which is imprecise; propagate the correction to that page in the same commit window"
  - "§5.2 dY/dZ fit parameters (σ_angle 0.24; σ_drift 0.12/0.15; σ_rate 0.10/0.11; σ_0 0.06/0.00) from slide 11 are raw fit values; code `paramErrY`/`paramErrZ` on slide 12 carry rounded / safety-floored values (dZ σ_rate rounded 0.11→0.10; dZ σ_0 kept at 0.06 vs fit 0.00) — code values are post-fit engineering choices"
  - "§6.1 cluster-overlap probability P = 1-(1-occ)^9 on 3×3 time×pad matrix; P(0.2) ≈ 86% — independence approximation; slide 14 labels it 'simplistic'; inherits from parent wiki"
  - "§6.2 nearest-distance formula d̄ ≈ 1/(2√ρ) assumes 15 000 clusters/row at 37 kHz, 32 drift bins, tan(π/9) sector opening — inherits from parent wiki"
  - "§6.3 MAE fit coefficients F0–F3 on slide 17 — 4 variants of linear Ridge regression on o15x / asnp / rate / avgCharge / o15x·avgCharge²"
  - "§7.1 Run 2 → Run 3 comparison table on slide 8 (×2.5 momentum, ×0.81 angular, ×5–8 vs intrinsic) — NEW content not in parent wiki; dataset tags (LHC22-24 prelim / LHC25 correct-v4 / PbPb 0-5% central), fit-code commit hash, run-list not on slide itself; these MUST be added to this wiki page before the numbers propagate further (evidence-binding per Org-structure § Cross-Team Information Flow)"
  - "§7.1 slide 7 'Apples vs Oranges' caveat MUST be preserved at same visual prominence as the ×2.5 number in any downstream quoting"
  - "§8 dNch/dy ~ 8000 on slide 2 / slide 23 — TPC-TDR design envelope, NOT measured Run-1 PbPb multiplicity (~1600 @ 2.76 TeV, 0-5% central); deck currently reads 'Run 1 tracking validated at design envelope dNch/dy~8000 — provides headroom argument'. Phrasing to be audited post-presentation"
  - "§9.2 'Formulas generated by GPT' appears as a C-code comment in slide 15 source — AI-DERIVED-FORMULA provenance; mathematically d̄ = 1/(2√ρ) is the standard 2D Poisson nearest-neighbour mean; flagged as governance precedent for MIWikiAI_QuickRef v1.0"
  - "External URLs (gitlab.cern.ch code links, overleaf, indico) not fetched during this indexation — carry as [VERIFY] for indexer's next pass"
  - "Slide 1 drive-filename carries legacy typo `Systermatic` + legacy date `24012023` — wiki_id normalises to workshop date; recommend speaker rename Drive file post-presentation to `ATO-630_ClusterErrParam_TPCworkshop_20260420`"
---

# ALICE — Cluster/tracklet error parametrization: occupancy impact on TPC space-point resolution, tracking, and PID (TPC calibration workshop, 20.04.2026)

## 1. TL;DR

**Headline numerical result** (slides 5, 8, 23): Run 2 → Run 3 momentum resolution is **×2.5 worse than Run 2**, and **×5–8 worse than the TPC intrinsic resolution**. Numerical estimator from 5D residual maps agrees with the global K0 / D0 mass-peak-width fit (cross-check that isolates the combined-tracking degradation, independent of single-cluster fits).

**Physical cause** (slide 12, corrected in this deck vs parent):

- Drift/diffusion term widening factor: σ² contribution scales as √(1 + (σ_GG/⟨GG⟩)²)
- MWPC (Run 1/2): σ_GG/⟨GG⟩ ≈ 1  →  widening ≈ √2
- GEM (Run 3): σ_GG/⟨GG⟩ ≈ √2 · MWPC ratio  →  widening ≈ √3
- Ratio Run 3 / Run 2 widening = √3 / √2 ≈ 1.22; Fe⁵⁵ peak-width measurement confirms the GEM value
- The `√2 · σ_GG/⟨GG⟩` product-form that appears in the parent wiki and some slide drafts is dimensionally consistent but numerically wrong away from σ/⟨G⟩ = 1; the corrected radical form replaces it everywhere on this deck

**Occupancy, not rate, drives cluster resolution** (slides 6, 17): Local occupancy `o15x = o15 / L_x` (clusters per nearest-drift-bin, per radius) is the dominant MAE-fit term. Interaction rate is not needed as a fit variable — the spread of occupancies at fixed IR is wide enough that IR adds no information. Pileup occupancy dominates; collision multiplicity is negligible.

**Run 3 pathologies beyond the base parameterization** (slides 14, 16):

- Cluster Q shift (common-mode bias, O(0.1 ms))
- Cluster gain scale variation O(8%) at O(0.1–0.2 ms) integrated occupancy
- Cluster overlap probability P = 1 − (1 − occ)⁹ on 3×3 time×pad matrix; P(0.2) = 86% for PbPb mean occupancies 10–30% (independence approximation)
- High cluster sharing — worse than Run 1/2; cluster finder splitting less effective; Run 1 TRD-tracklet-style algorithm candidate for porting
- High track sharing — significant fraction of tracks with 100% shared clusters; Run 1 mitigation partially addressed in recent reco

**Mitigation plan (Ongoing)** (slides 18–22): Tracklet-based Kalman refit rooted in CHEP 2006 TRD lineage — local tracklet angle error tied to lever arm (full track info → excellent angular resolution); robust one-parameter fit via median or LTS with LTS error estimate; Δangle(tracklet − track) scales weight above N·σ in the outlier region. Statistical evaluation of different weight functions currently ongoing with the distortion-calibration code (companion workshop talk: <https://indi.to/Q69HN>).

**Headroom argument** (slide 23): Run 1 tracking was validated at the TPC-TDR design envelope dNch/dy ~ 8000 — this provides the headroom argument that Run 3 + the mitigations here should cope with observed PbPb conditions. (Note: 8000 is the design envelope, not the measured Run 1 PbPb multiplicity, which was ~1600 at 2.76 TeV 0–5% central; phrasing audit item flagged in `known_verify_flags`.)

**sPHENIX-transferable core results**: (i) the 2-cluster nearest-distance geometry d̄ = 1/(2√ρ) with Rayleigh PDF, (ii) the Q-dependent cluster-error parameterization (CHEP 2003 eq 23–24 in Run-3 O2 form, slide 12), (iii) the LTS/median tracklet-refit method from CHEP 2006 (slide 22).

## 2. Pipeline context

```
Source (Google Slides deck, 23 slides, M. Ivanov)
    ↓
Speaker–reviewer loop (4 reviewer sessions: Claude2, Claude5, Claude7, Claude8)
    ↓
[Claude8 session] slide-by-slide author-facing review + synthesis of 3 other reviewers
    ↓
In-session slide edits by speaker (summary rewrite, gas-gain formula correction, clarifications)
    ↓
Post-presentation indexation (this page, cycle 0 DRAFT)
    ↓
→ Peer-review round(s) → [OK] promotion batched to end-of-sprint per SUMMARY v0.3 §7.4
```

## 3. Slide-level map

Each row is one slide in the 20.04.2026 workshop deck; source verification status applies per-slide. When a statement is load-bearing for downstream wiki reuse, it carries a `[computed]` or `[VERIFY]` tag and a reference to the `known_verify_flags` entry.

| # | Title | Role | Load-bearing claims |
|---|---|---|---|
| 1 | Title | framing | workshop date 20.04.2026, ALICE/sPHENIX audience, author M. Ivanov |
| 2 | Outline | navigation | 3 sections + new entry "Correlated cluster errors → tracklet-based Kalman update required" |
| 3 | Intrinsic TPC resolution → calibration requirements | target-setting | σ_rφ ~ 0.02 cm inner wall, ~0.1 cm primary vertex (track-level, Run 2 LHC18d pass2); correction-map precision < 0.02 cm and DCA-at-vertex QA precision < 0.1 cm required [VERIFY §3.1, §3.3] |
| 4 | Cluster and track error parameterization | taxonomy | 4 error classes: stochastic cluster, systematic cluster (+masking), additive cluster (legacy), systematic track (5-component diagonal; optional linear rate dependence — 5 offset + 5 slope numbers) |
| 5 | Combined ITS+TPC resolution vs pt and rate | diagnostic | 5D residual maps from DCA parameterization drive the resolution formulas; low-pt (< 2 GeV) largely unaffected; worsening linear for pt < 10 GeV, saturates pt > 30–40 GeV |
| 6 | Combined ITS+TPC resolution vs pt, rate, occupancy | diagnostic | **pileup occupancy dominates; IR secondary; collision multiplicity negligible** — direct mapping to K0, D0 mass resolution |
| 7 | Momentum resolution V0 global fits — Apples vs Oranges | framing | 4 datasets (Run 2 peripheral best; Run 3 LHC22-24 prelim; Run 3 LHC25 correct-v4; PbPb 0-5% central); caveat at equal visual prominence to the ratios [VERIFY §7.1 dataset tags + commit hash missing on slide] |
| 8 | Run 2 → Run 3 — what changed, what didn't | **headline result** | ratios ×2.6 (MS), ×2.3 (curvature), ×0.81 (angular — ITS upgrade delivers), ×2.5 momentum @ 1 GeV, ×5–8 vs intrinsic; PbPb central: occupancy degrades momentum; angular returns to Run 2 level |
| 9 | Section divider — TPC space-point resolution Run1, Run2 → Run3 | structure | preview: Theory (CHEP2003) → Run 1/2 practice → Run 3 adaptation |
| 10 | Cluster error parameterization at low IR — Run1 | history | CHEP2003 weight-fluctuation theory (§2.1 gas-gain fluctuation, §2.2 secondary-ionization fluctuation, §3 combined, §4 Q/dEdx version); Alme 2010 parameterization valid at MWPC low IR; pass2 fix added Q/dEdx/rate (Arslandok 2022); Run 3++ adds electron transparency + attachment + higher occupancy |
| 11 | Run 3 cluster error parameterization similar to Run 2 | result | dY fit: σ_angle≈0.24, σ_drift≈0.12 cm/drift, σ_rate≈0.1 cm/MHz, σ_0≈0.06 cm. dZ fit: σ_angle≈0.24, σ_drift≈0.15 cm/drift, σ_rate≈0.11 cm/MHz, σ_0≈0.0 cm. Differences dY↔dZ: σ_drift 0.12→0.15, σ_0 0.06→0.00. Low-rate parameters similar Run 2 / Run 3 [VERIFY §5.2 post-fit rounding] |
| 12 | Space-point error parameterization — O2 functional form | result | Drift/diffusion widening = √(1+(σ_GG/⟨GG⟩)²); GEM ratio ≈ √2·(MWPC ratio) → √3/√2 ≈ 1.22 (Fe⁵⁵-verified). Angular + diffusion form unchanged Run 1 → Run 3; transparency factor from Fe⁵⁵ peak width. Run-3-specific additive terms: 1-pad cluster (pad_width/√12), split, edge, high-fluctuation regions (C1&C2, C-side IFC, innermost padrows). Dominant terms at nominal pp 500 kHz: occupancy/multiplicity + split-cluster penalty. Code evolution: no-Q version since Aug 2023; occupancy added May 2024; Q-version (Run 2-like) since May 2024. [VERIFY §5.1 propagate corrected radical form to parent wiki] |
| 13 | Section divider — Occupancy impact: observation & theory | structure | preview: Qmax/Qtot biases → 2-cluster geometry → Run 3 tracking pathologies → MAE fit |
| 14 | dEdx ⟨Qmax⟩, ⟨Qtot⟩ occupancy biases | result | Q shift (common-mode, O(0.1 ms)); gain scale 8% variation at O(0.1–0.2 ms) integrated occupancy; overlap P = 1-(1-occ)⁹ on 3×3; P(0.2)=86%. PbPb 10–30% mean occupancy → significant overlap fraction; PbPb occupancy fluctuation ≫ pp equivalent. [VERIFY §6.1 independence approximation] |
| 15 | 2-cluster nearest distance — geometry and bias | transferable | 2D Poisson nearest-neighbour: d̄ ≈ 1/(2√ρ), Rayleigh PDF f(d) = 2πρd·exp(−πρd²). At PbPb 37 kHz, radius 90 cm: 3 regions — merged / biased / good — sorted by 2-cluster separation. Formula derivation flagged "Formulas generated by GPT" in embedded code (AI-DERIVED-FORMULA; formula itself is standard and correct). [VERIFY §6.2 density assumptions] |
| 16 | Shared cluster probability vs occupancy | diagnostic | 3 problems enumerated — Problem 0: Run 3 occupancy > Run 1. Problem 1: cluster-sharing fraction too high (worse than Run 1/2), finder splitting less effective, candidate port of Run 1 TRD-tracklet-style algorithm. Problem 2: track-sharing fraction too high even for long clean tracks; Run 1 mitigation not in Run 3, partially addressed in recent reco |
| 17 | Cluster Δy vs occupancy — MAE fit result | result | o15x = Ncl/L_x dominates; IR not relevant as fit variable (wide occupancy spread at fixed rate); Q-dependent — high Q weakens rate dependence (motivates Q-version on slide 12). 4 fit variants F0–F3 by Ridge regression; coefficients listed (F3 has 5 terms: offset, o15x, rate, ⟨Q⟩, o15x·⟨Q⟩²). [VERIFY §6.3] |
| 18 | Section divider — Occupancy mitigation track & PID (ongoing) | structure | preview: cluster-level → tracklet-level → combined information |
| 19 | Tracking performance — occupancy dependence | motivation | 3-part argument: (i) cluster-unfolding precision ceiling (shape depends on unknown local track properties); (ii) unfolded clusters perform worse (resolution + bias) with random overlaps compounding along trajectory; (iii) solution — combine cluster + global-track + local-track info, successful in Run 1 TRD, updated but not utilized in Run 3 |
| 20 | Cluster-tracklet association and cluster joining during refit | proposal | refit-time constraint: no raw digits, cluster-finder unfolding must be optimized for expected high-pt / small-angle shape. Proposed solution: join "fake split" clusters consistent with expected track shape; works for highly inclined tracks; rejoined clusters still wider than isolated → optimal refit weights needed |
| 21 | Run 1/2 TRD-like robust TPC track refit (Ongoing) | proposal | 3 themes: (i) occupancy-within-drift → cluster-error augmentation (limited improvement); (ii) local track-overlap info → more effective, outlier rejection within tracklets; (iii) error estimation + Kalman weighting — historical methods 2005–2006 and 2019–2020, tracklet weight with Δangle tested on TRD 2019–2020. Statistical evaluation of weight functions ongoing with distortion-calibration code |
| 22 | Robust tracklet fit + outlier weighting (CHEP2006 method) | proposal | Tracklet angle error ∝ lever arm; few pad-rows insufficient; full track info → excellent angular resolution. Robust 1-param fit: median or LTS; LTS provides error estimate; Δangle(tracklet-track) scales weight above N·σ in outlier region |
| 23 | Summary | closure | 6 bullets, headline first (×2.5 Run2, ×5–8 intrinsic; 5D-map ↔ K0/D0 cross-check); occupancy/MAE with gas-gain √3/√2 sub-bullet; systematic track error + correlated cluster errors motivating tracklet update; tracklet-based Kalman refit (Ongoing) CHEP2006 lineage; Run 1 headroom argument at dNch/dy~8000 design envelope; companion-talk pointer |

## 4. Figures inventory

Figures were not fetched during this indexation pass (text-only extraction via Google Slides `htmlpresent` endpoint). Placeholder list to populate at next indexation cycle:

| Slide | Figure | Source hint |
|---|---|---|
| 3 | Scaled σ_rφ vs q/pT, inner wall + primary vertex | Run 2 LHC18d pass2 data |
| 5 | Combined pT resolution vs pt·rate (dashboard snapshots) | ATO-628 parameterization notebook |
| 6 | q/pt resolution vs occupancy — two colour codings (collision mult / IR) | same dashboard, occupancy extension |
| 7 | V0 global-fit table / comparison plot | NEW; dataset tags missing on slide |
| 8 | Run 2 → Run 3 comparison table (4 rows × 2.5/2.6/2.3/0.81 ratios) | NEW |
| 9 | Section divider (Theory → Run 1/2 → Run 3) | — |
| 10 | Cluster-resolution decomposition (CHEP2003 plots; Alme 2010 residuals) | arXiv physics/0306108, NIM 2010 |
| 11 | dY / dZ fit-parameter boxes + global-fit variable definition | ATO-630_ErrParam.C |
| 12 | O2 code listings (getResolutionScaled, getResolutionQ) — two dated versions | ATO-630_ErrParam.C |
| 13 | Section divider | — |
| 14 | Isolated vs 2-track overlapped cluster schematic; occupancy fluctuation distribution (pp 3 MHz) | ATO-630 parent deck |
| 15 | Ncl per row at 37 kHz and 27 kHz; distance-to-closest-cluster distribution at radius 90 cm | CHEP 2003 companion |
| 16 | 3 histograms: fraction of shared clusters (Problems 0, 1, 2) | Run 3 production data |
| 17 | Occupancy distribution (colour=rate); Δy distribution (colour=resolution-fit) | MAE fit notebook |
| 18 | Section divider | — |
| 19 | Cluster-shape (CHEP 2003); tracklet-decomposition (CHEP 2006) | arXiv physics/0306108, CHEP 2006 |
| 20 | CHEP 2003 unfolding + residuals; cluster-joining schematic | arXiv physics/0306108 |
| 21 | Tracklet-refit schematic (CHEP 2006) | CHEP 2006 |
| 22 | CHEP 2006 tracklet figure | CHEP 2006 |

## 5. Delta vs parent wiki (ATO-630_OccupancyImpact_OfflineWeek_20241031)

**What this deck KEEPS from the parent** (most of the physical content):
- Run-3 transparency / gas-gain framing (corrected in §5.1; propagate back to parent)
- 2-cluster geometry (Rayleigh, d̄ = 1/(2√ρ), independence-approximation overlap)
- CHEP 2003 / 2006 lineage and method roots
- ATO-630_ErrParam.C as reference implementation
- Qmax/Qtot occupancy-bias catalogue
- MAE-fit methodology and o15x variable
- CHEP 2006 LTS / median / Δangle weighting proposal

**What this deck ADDS** (new in workshop version):
- **V0 global-fit comparison table** across 4 datasets (Run 2 peripheral; Run 3 LHC22-24 prelim; Run 3 LHC25 correct-v4; PbPb 0-5% central) — slides 7–8
- **×2.5 / ×5–8 headline framing** with 5D-residual-map ↔ K0/D0-mass cross-check — slides 5, 8, 23
- **Corrected gas-gain widening formula** (radical form, GEM ratio √3/√2 ≈ 1.22) — slide 12
- **Workshop-audience reframing** — compact outline, sPHENIX-transferable callouts, companion-talk pointer
- **"Design envelope" framing** of the dNch/dy~8000 argument (slide 23 — phrasing audit item)

**What this deck DROPS vs parent** (compressed or referenced elsewhere):
- Detailed IFC / inner field cage treatment (parent §6)
- Detailed C1 & C2 fluctuation analysis (parent §7)
- Composed-correction discussion (parent §9)
- Edge-effect calibration detail (parent §§ covering virtual-charge correction)
- Full 54-setting parameter-scan table (parent §10)
- Detailed dEdx-per-region PID discussion
- Most scan / streamer / calibration-production detail

## 6. Cross-references

- **Parent deck**: `presentations/ATO-630_OccupancyImpact_OfflineWeek_20241031.md` (207-slide working deck; same ATO-630 JIRA programme)
- **Theoretical foundation**: `articles/arxiv_physics_0306108_Belikov_Ivanov_TPC_tracking.md` (CHEP 2003 weight-fluctuation theory)
- **Mitigation-method lineage**: `articles/Ivanov2006_TRD_tracking.md` (CHEP 2006 robust tracklet fit)
- **Run-1/2 baseline**: `articles/Alme_2010_section_11_performance_detailed.md` (NIM 2010 MWPC parameterization)
- **Pass2 precedent**: `articles/Arslandok-2022-TPC-Tracking.md` (Q/dEdx/rate added in pass2 — Run 3 re-doing this lesson)
- **Detector context**: `TDR/tpc.md`, `TDR/its.md`, `TDR/trd.md`
- **Sibling presentations** (touching related aspects): `presentations/O2-6344_materialbudget_ITS_TRD_alignment.md`, `presentations/PWGPP-643_combined_shape_estimator.md`, `presentations/O2RecoAI_TrackingPerformance_InvMass_202602.md`, `presentations/MITPCTPC_IonDrift_20122023.md`

## 7. Open items / reviewer checklist

Items consolidated from the 4-reviewer panel that affect this wiki page (not the speaker's slide-editing). Many are for the next indexation cycle once external URLs and figures are fetched.

1. **[VERIFY]** Fetch external URLs cited on slides 10, 11, 12, 17, 19–22 (gitlab.cern.ch code links, Overleaf project, Indico links, mdpi.com, sciencedirect.com, arxiv.org) and confirm reachability. Flag deadlinks.
2. **[VERIFY]** Populate figures inventory (§4) from slide exports at next pass — figures not extracted in text-only indexation.
3. **[VERIFY]** Slide-7 dataset tags: LHC22-24 prelim / LHC25 correct-v4 / PbPb 0-5% — add run-list ranges, reco-pass identifiers, fit-code commit hash. Required per Org-structure § Cross-Team Information Flow (evidence-binding for critical claims).
4. **[VERIFY]** Slide-3 calibration-precision targets (σ_rφ < 0.02 cm map, < 0.1 cm DCA) — locate source document for these operational thresholds.
5. **[VERIFY]** Slide-3 k_MS values (0.1 inner wall, 3 vertex) — locate source in thesis or parent deck.
6. **[VERIFY]** Slide-17 F0–F3 MAE fit coefficients — locate notebook / fit-code commit for reproducibility.
7. **[PROPAGATE]** §5.1 corrected radical-form gas-gain widening to the parent wiki's TL;DR in the same commit window. Parent currently carries the product-form approximation.
8. **[PROPAGATE]** Slide-23 "design envelope dNch/dy~8000" phrasing audit — consider adding parenthetical "(TDR simulation envelope; measured Run 1 PbPb central was ~1600 at 2.76 TeV)" in next deck revision. Not blocking this wiki page.
9. **[GOVERNANCE]** Slide-15 "Formulas generated by GPT" code comment — AI-DERIVED-FORMULA precedent. Propose governance tag class `[AI-DERIVED — VERIFY]` to `MIWikiAI_QuickRef_v1.0.md` when Claude4 drafts it. Formula itself is correct (standard 2D Poisson nearest-neighbour); the governance question is provenance tracking.
10. **[INDEXATION]** Drive-file rename proposal: current filename `ATO-630_SystermaticError_TPCmeeting_24012023` inherits 2023 stem; recommend speaker rename to `ATO-630_ClusterErrParam_TPCworkshop_20260420` post-presentation so Drive metadata matches the wiki_id. Non-blocking; cosmetic.

## 8. Glossary

- **o15x** — local occupancy per radius, `o15x = Ncl(closest drift bin) / L_x`; dominant MAE-fit variable (slide 17)
- **σ_GG / ⟨GG⟩** — gas-gain PDF standard-deviation-over-mean; widening enters σ² as √(1+(σ_GG/⟨GG⟩)²); MWPC ≈ 1, GEM ≈ √2
- **CHEP 2003** — Belikov & Ivanov, TPC cluster-resolution weight-fluctuation theory (arXiv physics/0306108)
- **CHEP 2006** — Ivanov et al., TRD tracklet-based tracking with robust LTS/median fit and Δangle outlier weighting
- **LTS** — Least Trimmed Squares (robust regression estimator, used in tracklet fit error estimation)
- **pass2 / pass3 / pass4** — ALICE reconstruction passes; `pass2` for Run 1/2 introduced Q/dEdx/rate cluster-error dependence (Arslandok 2022)
- **Fe⁵⁵** — calibration source used to measure gas-gain peak width, from which σ_GG/⟨GG⟩ is extracted
- **dNch/dy** — charged-particle pseudorapidity density; 8000 is TPC-TDR *design envelope*, not measured Run 1 value
- **5D residual maps** — map of track/cluster residual bias + spread in a 5-D phase space used to derive resolution expectations (slide 5)
- **V0** — neutral-vertex decay (K0_S, Λ, …); "V0 global fits" refers to the K0/D0 mass-peak-width fits that cross-check the residual-map resolution estimator (slides 7, 8)
- **IFC** — Inner Field Cage (TPC); high-gradient distortion region; deferred here, covered in parent wiki

## 9. External references (BibTeX-ready)

- `Belikov2003_CHEP`: arXiv:physics/0306108 — Weight-fluctuation theory of TPC cluster resolution (CHEP 2003 proceedings)
- `Ivanov2006_CHEP`: CHEP 2006, TRD tracklet-based tracking — `https://indico.cern.ch/event/408139/contributions/979783/`
- `Alme2010_NIM`: Nucl. Instrum. Meth. A 622 (2010) 316–367 — The ALICE TPC
- `Arslandok2022_Particles`: Particles 5(1) (2022) 8 — `https://www.mdpi.com/2571-712X/5/1/8`
- `Ivanov_Thesis_Overleaf`: Overleaf project 642845e49aeb65eb8a4c23aa — public-note umbrella
- `ATO-630-ErrParam.C`: `https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/22bd07586bed2e118fcb5ffd6586149e5de9d113/JIRA/ATO-630/ATO-630_ErrParam.C`
- `Workshop-Deck-20260420`: `https://docs.google.com/presentation/d/1PNHf-uIxFSIrnGpcXaW5xAwABfgDEGMlTNXySjtfKBg/edit`
- `Companion-Mitigation-Talk`: `https://indi.to/Q69HN`
- `Parent-Deck-OfflineWeek-20241031`: drive_id `1fWy2IRnJW-VDMtbYhyrhIFGkEMsvlSt8-fhiLjqvCfA`

## 10. Source-to-section appendix

Mapping from this wiki's sections back to slide numbers (for auditability when the deck is re-indexed):

| Wiki §  | Wiki section                                      | Slides       |
|---------|---------------------------------------------------|--------------|
| §1      | TL;DR                                             | 5, 6, 8, 12, 17, 22, 23 |
| §3 row 1  | Title                                           | 1            |
| §3 row 2  | Outline                                         | 2            |
| §3 row 3  | Intrinsic TPC resolution → calibration requirements | 3        |
| §3 row 4  | Cluster and track error parameterization        | 4            |
| §3 row 5  | Combined ITS+TPC resolution vs pt+rate          | 5            |
| §3 row 6  | Combined ITS+TPC resolution vs pt/rate/occupancy | 6           |
| §3 row 7  | Momentum resolution V0 fits — Apples vs Oranges | 7            |
| §3 row 8  | Run 2 → Run 3 — what changed                    | 8            |
| §3 row 9  | Section divider — Theory → Run 1/2 → Run 3      | 9            |
| §3 row 10 | Cluster error at low IR — Run 1                 | 10           |
| §3 row 11 | Run 3 cluster-error parameterization            | 11           |
| §3 row 12 | O2 functional form (getResolutionScaled / Q)    | 12           |
| §3 row 13 | Section divider — Observation & theory          | 13           |
| §3 row 14 | dEdx ⟨Qmax⟩ / ⟨Qtot⟩ occupancy biases           | 14           |
| §3 row 15 | 2-cluster nearest distance — geometry & bias    | 15           |
| §3 row 16 | Shared-cluster probability vs occupancy         | 16           |
| §3 row 17 | Cluster Δy vs occupancy — MAE fit               | 17           |
| §3 row 18 | Section divider — Occupancy mitigation          | 18           |
| §3 row 19 | Tracking performance — occupancy dependence     | 19           |
| §3 row 20 | Cluster-tracklet association + cluster joining  | 20           |
| §3 row 21 | TRD-like robust TPC track refit (Ongoing)       | 21           |
| §3 row 22 | Robust tracklet fit + outlier weighting         | 22           |
| §3 row 23 | Summary                                         | 23           |
| §5       | Delta vs parent                                   | all (23 vs ~207) |
| §7       | Open items                                        | derives from slides 3, 7, 15, 17, 23 |

## 11. Notation appendix

- `σ_X` = standard deviation of quantity X
- `⟨X⟩` = mean of X
- `L_x` = local radius of space point (cm)
- `L_pad` = pad length (variable IROC / OROC 1/2/3)
- `tan α` = track inclination angle in the pad-plane
- `o15`  = local occupancy in nearest drift bin (of 31 across drift length)
- `o15x = o15 / L_x` = radius-normalised local occupancy (dominant MAE variable)
- `q/pt` or `qpt` = charge/transverse-momentum
- `dEdx` = specific ionisation energy loss
- `MIP` = minimum-ionising particle (reference for Q normalisation)
- `MS` = multiple scattering
- `IR` = interaction rate
- `k_MS` = MS scaling constant in `σ_rφ,scaled = σ_rφ / √(1 + k_MS · qpT²)`
- `dNch/dy` = charged-particle density in rapidity
- `MAE` = mean absolute error (robust-fit residual estimator)
- `Ridge` = L2-regularised linear regression
- `LTS` = Least Trimmed Squares

## 12. Changelog

- **v0.1 — 2026-04-20 — cycle 0 DRAFT** (this file). Indexed by Claude8. Source: `htmlpresent` fetch of Google Slides deck (drive_id 1PNHf-uIxFSIrnGpcXaW5xAwABfgDEGMlTNXySjtfKBg). Peer reviewers: none yet. Synthesizes prior reviewer submissions (Claude2 content/arithmetic; Claude5 wiki-governance; Claude7 structural). Figures inventory placeholder only.

---

*Quota / session-block: nothing observed from inside this session during indexation.*
*Indexed by Claude8 on 2026-04-20. Team MIWikiAI. Cycle 0 DRAFT. Awaiting peer review per SUMMARY v0.3 §7.1 one-pass rule.*
