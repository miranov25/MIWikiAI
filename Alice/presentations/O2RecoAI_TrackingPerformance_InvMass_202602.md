---
wiki_id: O2RecoAI_TrackingPerformance_InvMass_202602
title: "ALICE Tracking Performance — Invariant-Mass Resolution & Bias Calibration: Analytical Parameterisation with ToyMC Validation (O2RecoAI, Feb 2026)"
project: MIWikiAI / ALICE
folder: presentations
source_type: working-presentation-index
source_title: "Presentation_v7.pptx (Drive filename; content title: 'ALICE Tracking Performance — Invariant Mass Resolution and Bias Calibration')"
source_fingerprint:
  upstream:
    - id: O2RecoAI-InvMass-v7-2026-02
      title: "ALICE Tracking Performance — Invariant Mass Resolution and Bias Calibration — Analytical Parametrization with ToyMC Validation"
      drive_filename: "Presentation_v7.pptx"
      drive_id: "1W0uqqBxgcO9Rk6aEZVUDqEwj8TXx3XEh"
      view_url: "https://drive.google.com/file/d/1W0uqqBxgcO9Rk6aEZVUDqEwj8TXx3XEh/view"
      owner: "miranov25@googlemail.com (Marian Ivanov)"
      created: "2026-02-25"
      modified: "2026-03-04"
      file_format: "PowerPoint .pptx (not Google Slides)"
      file_size: "~6.6 MB"
      authorship_on_slide_1: "M. Ivanov, M. Ivanov Jr. — with R. Schotter (Strangeness QA), Matthias (TPC group)"
      group: "O2RecoAI — ALICE Experiment"
      venue_stated: "O2RecoAI — ALICE Experiment — February 2026"
      extracted_slide_structure: "21 main slides (1–21) + 10 backup slides (B1–B10); numbering in source is occasionally out-of-order (slide 20 appears out of sequence; slide 10 appears after 21)"
      figure_extraction: "none — text-extracted only; resolution/bias correlation plots (slides 13, 14, 15) and B8/B9 grid QA plots are not reproduced"
      review_state_per_slide_B10: "6 reviewers, all approved, 7 P1 items fixed (prior-cycle internal review, not MIWikiAI review)"
      git_anchor: "partO2-6685, commits 8ec683d0 + fbefaf9e (per slide B10)"
      final_slide_anomaly: "Trailing 'Gluckstern Formula with √720' slide appears to be pasted chat content with a closing 'Would you like me to:...' prompt — likely not a finalised slide; see §11.3"
    - id: Shahoyan-PDP-2026-02-17
      title: "R. Shahoyan — ALICE Physics Data Processing board, 2026-02-17"
      cited_as: "[S1] in deck"
      role: "current-results source — Run 3 LHC22-24 preliminary and Run 3 LHC25 (correct v4)"
      indico_not_extracted_from_deck: true
    - id: Schotter-StrangenessQA
      title: "R. Schotter — Strangeness QA"
      cited_as: "[S2] in deck"
      role: "K⁰s, Λ, Λ̄ mass distributions; co-author contribution"
    - id: Ivanov-PW-2018
      title: "M. Ivanov — Physics Working Group, 2018"
      cited_as: "[S3] in deck"
      role: "Run 2 peripheral reference numbers"
    - id: Gluckstern-NIM-1963
      title: "R. L. Gluckstern — Uncertainties in track momentum and direction, due to multiple scattering and measurement errors"
      journal: "Nucl. Instrum. Meth. 24 (1963) 381"
      role: "standard momentum-resolution formula reference; appears on the trailing anomalous slide — see §11.3"
  summary_version: "n/a (source is v7 of a living PowerPoint; Feb 25 → Mar 4 2026 modification window)"
  summary_review_panel: []
source_last_verified: 2026-04-19
author: Marian Ivanov (dissertation lead); wiki page distilled with AI-assisted indexing
indexed_by: Claude5
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 0
peer_reviewers: []
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags:
  - "§1 authorship: slide 1 lists 'M. Ivanov Jr.' — confirm full-name and ORCID attribution for thesis/publication"
  - "§3 fit-parameter table slide 4: Run 3 LHC22-24 (prelim.) vs LHC25 (correct v4) — meaning of 'correct v4' label vs 'v7' deck version (may be different versioning)"
  - "§3 σ_ang = 2.26 mrad·GeV vs 2.35 mrad·GeV for LHC22-24 vs LHC25 — improvement interpretation ('new ITS geometry')"
  - "§4 cross-species leverage Fisher-matrix condition number 3.2 — confirm against B4 reproduction"
  - "§5 bias model δ(q/pT) = dqpt0 + dqpt1·(q/pT) + dqpt2·(q/pT)² — verify polynomial order rationale (why quadratic stops)"
  - "§6 K⁰s low-pT linearisation failure 'fixed in new version with tracking cuts' — status of new version vs v7 deck"
  - "§7 charge decomposition (Λ/Λ̄, D⁰/D̄⁰) bias cancellation sign rule — verify against working code"
  - "§7 particle/antiparticle comparison: K⁺ vs K⁻ hadronic interaction in material — does current MC have this asymmetry modeled?"
  - "§11 slide 18 'calibration sample 2000 vs 3.6×2000 tracks' statistic-sufficiency claim — verify source of the 3.6× factor"
  - "§11 Gluckstern trailing slide (§11.3): is this intended content or accidentally-pasted chat fragment?"
  - "§7 data request §7.3 axis 4 'Δφ (daughter) relative to parent φ' — binning convention (bin count not specified in table)"
wiki_sections_stubbed:
  - "Figure content (resolution/bias correlation scatter plots slides 13, 14, 15; B8/B9 grid QA heatmaps) — not reproduced in text-only pass"
---

# ALICE Tracking Performance — Invariant-Mass Resolution & Bias Calibration (O2RecoAI, Feb 2026)

> **What this page is.** An indexed, cross-linked rendering of `Presentation_v7.pptx` by M. Ivanov and M. Ivanov Jr. (with R. Schotter and Matthias), O2RecoAI group, February 2026. The deck is an analysis-and-framework status report — ~21 main slides + 10 backup slides. The talk argues that **Run 3 momentum resolution is 2.5× worse than Run 2**, presents a 3-parameter analytical framework for resolution (σ²_M = SM2·σ²) and a 3-parameter bias model (δM = dM·dqpt), and validates both against a ToyMC across 7 decay species to < 5 % closure. The operational ask is binned mass distributions from the strangeness / charm QA groups.
>
> **Relation to other MIWikiAI pages.** This deck *and* the [ATO-630 offline-week deck (2024-10-31)](./ATO-630_OccupancyImpact_OfflineWeek_20241031.md) both address the Run-3 momentum-resolution problem, but from different angles: ATO-630 attacks it at the **cluster-error and correction-map** level; this deck attacks it at the **invariant-mass-reconstruction** level. The two are complementary — cluster-error parameterisation (ATO-630) feeds σ_qpt and σ_ptrel in this framework; mass-resolution diagnostics (this deck) validate whether those cluster-level fixes survived through to the reconstructed physics observables. See §10 for the dependency graph.
>
> **Working status.** Claims reflect the v7 state (2026-03-04 modification). Slide-B10 notes that 6 reviewers have approved and 7 P1 items have been fixed — that was an internal-group review, **not** a MIWikiAI review. This page is MIWikiAI cycle 0.

## TL;DR

The deck answers three questions:

1. **How bad is Run 3 momentum resolution, in numbers?** Slide 4 fit table: σ(pT)/pT @ 1 GeV is 0.45 % (Run 2 peripheral best) → 1.16 % (Run 3 LHC25 correct v4). At 10 GeV: 1.87 % → 4.40 %. Ratio ~2.5× across the board. Angular resolution, separately, has *improved* 15–20 % (2.89 → 2.35 mrad·GeV) — the new ITS geometry delivers on the angular side. The bottleneck is momentum calibration/alignment, not sensor geometry.
2. **Is there a framework that can deploy calibration corrections and be trusted?** Yes — a 3-parameter analytical model:
   - **Resolution:** σ²_M(pT) = SM2_ptrel·σ²_ptrel + SM2_qpt·σ²_qpt + SM2_ang·σ²_ang. The SM2 coefficients are **kinematic-only** (no free fit parameters per species), computed from decay kinematics.
   - **Bias:** δ(q/pT) = dqpt0 + dqpt1·(q/pT) + dqpt2·(q/pT)². Transfers to δM linearly via ∂M/∂(q/pT).
   - The framework is validated by ToyMC across 7 species (K⁰s, Λ, Λ̄, D⁰, D̄⁰, φ, J/ψ), 8 pre-defined configurations, 5000 events per (species, pT) bin. Closure: all 8/8 pass at 5 %; resolution correlation r > 0.92; bias correlation r > 0.97. Fisher-matrix condition number 3.2 — well-posed, unique solution with 3 species.
3. **What's needed to deploy it on real data?** N-dimensional histograms with axes M_reco × pT × cosθ* × φ × Δφ × η × centrality, *charge-separated* (Λ/Λ̄, D⁰/D̄⁰ must not be mixed or bias signals cancel). Raw mass distributions preferred — the group fits σ_M and δM themselves.

Operational slogan from the deck (slide 19): *"You give us binned mass distributions → we deliver per-track calibration."*

## 1. Context and scope

**When:** February 2026. Drive metadata: created 2026-02-25, modified 2026-03-04; venue stated as "O2RecoAI — ALICE Experiment — February 2026."

**Who:** **M. Ivanov** (deck author, dissertation lead) and **M. Ivanov Jr.** (coauthor). Collaborators named on title: **R. Schotter** (Strangeness QA) and **Matthias** (TPC group). Deck attributes `[S1]` R. Shahoyan (PDP 2026-02-17), `[S2]` R. Schotter (Strangeness QA), `[S3]` M. Ivanov (PW 2018) as data sources on slide 2.

**[VERIFY]** full-name/ORCID disambiguation for "M. Ivanov Jr." before thesis citation.

**What the deck is:**
- A status report on the O2RecoAI group's invariant-mass resolution-and-bias framework.
- A validation report: ToyMC closure across 7 species → framework is trusted at < 5 % before real-data deployment.
- A data request to the Strangeness and Charm QA groups.
- Contains both **main slides (1–21)** and **backup slides (B1–B10)** — the backup contains the numeric lookup tables (Fisher matrix, coefficient grids, species-specific enhancement factors).

**What the deck is not:**
- Not a peer-reviewed paper.
- Not a published calibration result — it delivers a framework, not numbers for existing data. The numbers in slide 3/4 are preliminary fits from current data to establish the scale of the problem.
- Not the full working reconstruction — complementary to [ATO-630 offline-week deck](./ATO-630_OccupancyImpact_OfflineWeek_20241031.md) (cluster error) and [MITPCTPC IonDrift deck](./MITPCTPC_IonDrift_20122023.md) (space-charge ion-disc fluctuation).

## 2. The problem: Run 3 momentum resolution in numbers

Slide 4 — the central evidence. **Run 2 peripheral best** vs **Run 3 LHC25 (correct v4)** fit parameters from an invariant-mass global fit:

| Parameter | Run 2 (best) | Run 3 (correct v4) | Ratio | Interpretation (deck's own) |
|---|---|---|---|---|
| σ_ptrel (MS floor, dimensionless) | 0.41 % | 1.07 % | ×2.6 | Uncorrected material / misalignment |
| σ_qpt (curvature, c/GeV) | 0.0018 | 0.0043 | ×2.3 | Spatial resolution degraded |
| σ_ang (angular, mrad·GeV) | 2.89 | 2.35 | ×0.81 | **Improved** — new ITS geometry |
| σ(pT)/pT @ 1 GeV | 0.45 % | 1.16 % | ×2.6 | (see full table slide 3) |
| σ(pT)/pT @ 10 GeV | 1.87 % | 4.40 % | ×2.4 | High-pT physics impact |

Cross-system consistency: PbPb 0–5 % central shows σ_ptrel = 0.0117 and σ_ang = 2.82 mrad·GeV — occupancy degrades momentum; angular returns to Run 2 level (suggesting the Run 3 angular gain is sensor-quality-limited, not calibration-limited).

Slide 4 conclusion, verbatim: **"Momentum resolution degraded ×2.5 → alignment/calibration bottleneck. Angular resolution improved 15–20% → ITS upgrade delivers. Primary bottleneck is calibration/alignment, not sensor geometry."**

### 2.1 The "apples vs oranges" caveat

Slide 3 table lists four datasets with different reco passes, calibrations, and collision systems:
- Run 2 peripheral (best)
- Run 3 LHC22–24 (preliminary)
- Run 3 LHC25 (correct v4)
- PbPb 0–5 % central

The deck explicitly warns (slide 3): ⚠ *"Different conditions — different reco passes, calibrations, collision systems. Apples vs oranges."* The quantitative factor-2.5 conclusion therefore comes from cross-era comparisons, not same-sample A/B. The framework's purpose (§3 below) is to get matched-conditions comparisons going forward.

## 3. The framework — 3 resolution parameters, 3 bias parameters

### 3.1 Resolution model

Slide 5:
```
σ²_M(pT) = SM2_ptrel · σ²_ptrel  +  SM2_qpt · σ²_qpt  +  SM2_ang · σ²_ang
```

- **σ_ptrel** — σ(pT)/pT floor (dimensionless, multiple-scattering-dominated).
- **σ_qpt** — curvature precision (c/GeV, point-resolution-dominated at high pT).
- **σ_ang** — angular scale (mrad·GeV).

Three physical parameters, three experimental observables. The SM2 prefactors depend only on decay kinematics per species — they are *not* fit parameters, they are **computed from kinematic relations** alone. This is what makes the cross-species fit uniquely determined (§4).

### 3.2 Bias model

Slides 9, 10:
```
δ(q/pT) = dqpt0 + dqpt1·(q/pT) + dqpt2·(q/pT)²
δM       = dM_dqpt0·dqpt0 + dM_dqpt1·dqpt1 + dM_dqpt2·dqpt2
```

Three bias parameters: a constant (`dqpt0`), a linear term (`dqpt1`), and a quadratic (`dqpt2`). The transfer coefficients `dM_dqptN` come from ∂M/∂(q/pT) at the decay kinematics of each species.

**Charge decomposition is essential** (§7.2) — for Λ/Λ̄ and D⁰/D̄⁰, the bias-coefficient signs *flip* between particle and antiparticle, so mixing them cancels the bias signal.

**[VERIFY]** why the polynomial stops at quadratic (vs cubic). Likely justified by current statistics + physical argument; not explicit in the text extraction.

### 3.3 Relationship resolution ↔ bias

Slide 10 ("The Complete Picture"):

| Observable | Model | Fit parameters | Binning |
|---|---|---|---|
| σ_M(pT) | SM2·σ² (quadrature) | σ_ptrel, σ_qpt, σ_ang | per pT |
| δM(pT, cosθ*) | dM_dqptk · dqptk (linear) | dqpt0, dqpt1, dqpt2 | per (pT, cosθ*) |

**Iteration logic:**
1. Fit σ from `exp0` (resolution model, no bias) → first estimate.
2. Compute `exp1 = √(exp0² + Var_cosθ*(δM))` — adds bias variance contribution (only valid after integrating over cosθ*).
3. Refit with `exp1`.

Typical convergence: ~10 % delta in step 2 → < 1 % after refit (slide 10 verbatim).

`exp0 / exp1` rationale: resolution broadens; bias shifts (doesn't broaden). When you integrate over cosθ*, the bias *variation* across cosθ* acts like additional resolution — so you need exp1 for the integrated-bin fit and exp0 for the differential-bin fit (slide B6).

## 4. Cross-species leverage — why the multi-species fit works

Slide 6, cross-referenced to slide B4:

| Particle | SM2_ptrel | SM2_ang | SM2_ang / SM2_ptrel | Dominant sensitivity |
|---|---|---|---|---|
| K⁰s → ππ | 0.052 | 1.71 | 33 | **Angular** (94 % at pT = 1 GeV) |
| Λ → pπ | 0.008 | 0.30 | 38 | Angular (strong pT dep.) |
| D⁰ → Kπ | 1.17 | 4.8 | 4.1 | **Momentum** at high pT |

**Three independent constraints from three species:**
- K⁰s is angular-dominated → measures σ_ang.
- D⁰ is momentum-dominated → measures σ_ptrel + σ_qpt.
- Λ provides the third constraint needed for unique solution.

### 4.1 Fisher matrix (B4)

| | SM2_ptrel | SM2_qpt | SM2_ang |
|---|---|---|---|
| K⁰s | 0.052 | 0.54 | 1.71 |
| Λ | 0.008 | 0.064 | 0.30 |
| D⁰ | 1.18 | 11.7 | 5.90 |

**Condition number: 3.2** — well-posed; the system is not numerically fragile. E3 closure-test recovers σ_ptrel to 3.9 %, σ_qpt to 2.7 %, σ_ang to 2.2 %, dqpt0 to 0.0 % (slide B4).

### 4.2 Why single-species approaches fail

Slide 16:
- **K⁰s-only** measures σ_ang but *cannot separate* σ_ptrel from σ_qpt.
- **D⁰-only** measures total momentum resolution but cannot decompose.
- **Single (φ, η) bin** gives local resolution but no global picture or cross-check.

The same track physically crosses all detectors at once — one set of (σ_ptrel, σ_qpt, σ_ang) must describe all decays self-consistently. **Inconsistency between species is itself the diagnostic** for systematic effects (material, alignment).

## 5. Kinematic coefficients — the physics content

Slide 7. The SM2 coefficients have species-specific pT behaviour:

- **K⁰s:** all coefficients constant to < 1 % across pT. Pure angular sensitivity.
- **Λ:** pT-dependent. Heavy proton → slow → large η sensitivity variation.
- **D⁰:** SM2_ang varies ~30 %. The K⁺ in D⁰ → Kπ is non-relativistic at low pT (β → 0 at daughter pT ~ m_K).

The most important species-specific effect (slide B3):

| Particle | Daughter | η/φ derivative enhancement | Physics |
|---|---|---|---|
| K⁰s | π (140 MeV) | ×2.3 | Mildly relativistic |
| Λ | p (938 MeV) | ×1.1 | Heavy, slow |
| D⁰ | K (494 MeV) | **×8.0** | Non-relativistic |

This is **why ∂M/∂η ≠ ∂M/∂φ** — η enters through Lorentz boost (sensitive to β), φ doesn't. D⁰ has a factor ×8.0 enhancement of the η-derivative over the φ-derivative because the kaon is non-relativistic. Conclusion (slide 7 verbatim): *"φ and η corrections are fundamentally different — cannot use common 'angular' correction."*

### 5.1 Coefficient lookup (slide B7)

| pT | SM2_ptrel(K⁰s) | SM2_ang(K⁰s) | SM2_ptrel(D⁰) | SM2_ang(D⁰) | SM2_ptrel(Λ) | SM2_ang(Λ) |
|---|---|---|---|---|---|---|
| 1 | 0.051 | 1.80 | 1.259 | 7.84 | 0.005 | 0.34 |
| 2 | 0.051 | 1.71 | 1.223 | 7.15 | 0.007 | 0.30 |
| 5 | 0.051 | 1.71 | 1.178 | 5.90 | 0.008 | 0.30 |
| 10 | 0.052 | 1.70 | 1.168 | 4.54 | 0.008 | 0.30 |
| 20 | 0.052 | 1.71 | 1.166 | 4.18 | 0.008 | 0.30 |

(K⁰s effectively constant across pT; D⁰ decreasing because kaon becomes more relativistic.)

## 6. ToyMC validation

### 6.1 Generation pipeline

Slide 8:
```
1. Generate parents at fixed pT, thermal yields
2. Decay isotropic in rest frame → Lorentz boost
3. Smear daughters:  δ(pT)/pT ~ σ_ptrel,  δ(q/pT) ~ σ_qpt,  δ(φ,η) ~ σ_ang/pT
4. Bias:  δ(q/pT) = dqpt0 + dqpt1·(q/pT) + dqpt2·(q/pT)²
5. Reconstruct M from smeared+biased daughters
6. Compare measured σ_M, δM to analytical prediction
```

**Ground truth known** (exact σ_ptrel, σ_qpt, σ_ang, dqpt0/1/2 by construction) → closure test is meaningful. **5000 events per (species, pT) bin. 25 pT bins × 8 cosθ* bins × 7 species = ~7000 bins per configuration.**

### 6.2 Validation results

Slide 12 — **parameter scan:** 8 predefined configs × 7 species × 5000 evt/bin → **8/8 pass at 5 %** tolerance.

Slide 13 — **resolution per-species correlation:** measured σ_M vs analytical prediction across all pT bins and configurations. **All correlations r > 0.92.** Outliers at low pT where linearisation failed — deck notes *"fixed in new version with tracking cuts. Presentation to be updated"* (**[VERIFY]** — is that new version this v7, or a later one?).

Slide 14 — **bias validation:** δM(cosθ*) slopes correctly predicted; **all correlations r > 0.97**. Charge decomposition (Λ/Λ̄, D⁰/D̄⁰) essential.

Slide 15 — **resolution + bias + residuals overview:** **all within ±5 % for pT > 1 GeV.**

### 6.3 Robust estimators

Slide B5 shows the failure mode at low pT: daughter pT < 0.15 GeV → M(pT₁, pT₂) is highly non-linear. A 1 % Gaussian input produces kurtosis > 1000 and events at 21σ in the output distribution.

The deck's mitigation (slide 11 verbatim):

| Species | pT (GeV) | std (MeV) | IQR σ (MeV) | std/IQR | Kurtosis |
|---|---|---|---|---|---|
| K⁰s | 0.3 | 10.0 | 3.8 | 2.6 | 1183 |
| Λ | 0.5 | 6.7 | 1.4 | 4.7 | 2092 |
| K⁰s | 2.0 | 4.2 | 4.2 | 1.00 | 0.0 |

Strategy: **IQR/1.349** measures the Gaussian core (robust to tails); **kurtosis gate (> 1.0) excludes non-Gaussian bins**. At pT ≥ 1 GeV the distribution is Gaussian and IQR = std = analytical prediction — the framework recovers the standard case automatically.

## 7. From ToyMC to real data — the deployment plan

### 7.1 Staged rollout (slide 17)

| Stage | Status | Data | Purpose |
|---|---|---|---|
| ToyMC (uniform, Gaussian) | ✅ Done | — | Validate analytical framework |
| ToyMC with φ/θ-dependent bias | → In progress | unit test | Mimic sector-dependent calibration |
| Real-data fits | → Next | LHC23/24/25 | Extract actual detector parameters |
| MC-data fits | → Next | standard MC | Extract MC parameters for comparison |
| Distorted-MC fits | → Next | MC with imperfect calibration | Stress-test |

What **stays the same** in the transition to data: analytical derivatives (kinematics only), fitting framework, robust estimators (IQR, kurtosis gate).

What **changes:** φ modulation → separate coefficients for +/− daughters (framework already supports per-daughter decomposition); tracking cuts added to ToyMC; TPC-only V0 refit is explicitly *out of scope* for Phase 0.1E but extensible.

### 7.2 Data request — ND histograms (slide 18)

The deliverable the framework needs:

| Axis | Variable | Binning | Notes |
|---|---|---|---|
| 0 | M_reco | Fine around M_PDG | Raw distribution — the group fits σ_M and δM themselves |
| 1 | pT (parent) | 25 bins, 0.2–20 GeV | |
| 2 | cosθ* | 8 bins, −1 to +1 | **Main sensitivity variable** |
| 3 | φ (parent) | 18 sectors (20°) | Sector-dependent |
| 4 | Δφ (daughter) | Relative to parent φ | Daughter non-uniformity |
| 5 | η (parent) | 10 bins, −1 to +1 | |
| 6 | centrality | 5–10 bins | |

Species required: **K⁰s, Λ, Λ̄, D⁰, D̄⁰, φ, J/ψ**. Charge separation mandatory (§7.3 below).

**Sliding-window fit** avoids hard bin edges; bins adjusted to statistics. For K⁰s/Λ specifically: include **V0 radius bins** because resolution depends on which ITS layers were hit.

**[VERIFY]** axis-4 binning — table does not specify bin count for Δφ.

### 7.3 Charge decomposition is mandatory

Slide 19:

| Comparison | What it probes |
|---|---|
| δM(Λ) − δM(Λ̄) vs cosθ* | Charge-dependent bias (bias coefficients flip sign between particle and antiparticle) |
| σ_M(D⁰) vs σ_M(D̄⁰) | K⁺ vs K⁻ hadronic interaction in material (asymmetric) |
| (σ_ptrel, σ_qpt, σ_ang) Λ vs Λ̄ | Material budget accuracy in MC |

Statement (slide 19 verbatim): **"Charge separation is mandatory — bias signals cancel if particle/antiparticle mixed."**

**[VERIFY]** whether the current ALICE MC models K⁺/K⁻ hadronic-interaction asymmetry correctly — the slide-19 D⁰/D̄⁰ comparison is sensitive to this.

## 8. Bias vs fluctuation decomposition

Slide 18 (numbered "18" in source but content-wise between 19 and 20): a calibration-statistics question.

With **2000 tracks** calibration sample: track parameters are broadening — this is **insufficient statistics** for unambiguous bias/fluctuation separation. With **3.6 × 2000 = 7200 tracks**: OK.

**[VERIFY]** the 3.6× factor source — is this MC-closure-derived, or a rule-of-thumb from sampling theory?

Implication: per-sector per-pT per-φ calibration tables need the ×3.6 scale-up from current strangeness-QA yields to avoid systematic broadening introduced by the calibration itself.

## 9. Roadmap (slide 21)

Four priorities, explicit owners:

| Priority | Timeline | Deliverable | Owners |
|---|---|---|---|
| **P1 — Now** | current | K⁰s/Λ/Λ̄ from strangeness QA. Global fit → 25 % → 4 % precision. φ, η maps. | M. Ivanov + R. Schotter |
| **P2 — Weeks** | next | D⁰/D̄⁰ from charm QA. Momentum decomposition. Radial cuts. | M. Ivanov + Charm QA |
| **P3 — 1–2 months** | | Full program + MC correction. D*⁺, Ξ, Ω. Per-production tables. | RootInteractive ND maps (M. Ivanov Jr.) |
| **P4 — To follow** | future | TPC-only V0 calibration. TOF pT scale (to 1.5 GeV). | V0 group (Matthias), TPC group (Romain) |

Closing statement: *"You give us binned mass distributions → we deliver per-track calibration."*

## 10. Role in the dissertation and relation to other pages

Three dissertation roles:

1. **The analytical framework is itself a dissertation deliverable** — §3 above is the methodological core (3-parameter resolution + 3-parameter bias), with explicit closure validation.
2. **The ToyMC validation is a methodological demonstration** — the independence of SM2 coefficients from fit (kinematic-only) is a structural claim that only a closure test in controlled-ground-truth conditions can establish.
3. **The Run 2 vs Run 3 scaling (×2.5 in momentum) is an ALICE-wide result** that the framework enables measuring self-consistently.

### 10.1 Dependency graph with other MIWikiAI pages

```
            ┌──────────────────┐
            │  ../TDR/tpc.md   │  ← detector baseline (gas, GEM, padrows, space-charge)
            └─────────┬────────┘
                      │ feeds into
                      ▼
      ┌─────────────────────────────────┐
      │  ATO-630 offline-week           │  ← cluster-error parameterisation
      │  (occupancy → cluster σ)        │     (σ_qpt, σ_ptrel at cluster level)
      │  ATO-630_OccupancyImpact...md   │
      └─────────┬───────────────────────┘
                │ feeds σ_qpt, σ_ptrel into
                ▼
      ┌─────────────────────────────────┐
      │  THIS DECK                      │  ← invariant-mass resolution framework
      │  (3-param σ² fit, 3-param bias) │     (cross-species validation at physics level)
      │  Pres_v7 Feb 2026               │
      └─────────────────────────────────┘
                ▲
                │ orthogonal: 2D space-charge correction
                │ (different approach to the same momentum-resolution issue)
                │
      ┌─────────────────────────────────┐
      │  MITPCTPC_IonDrift_20122023.md  │  ← ion-disc fluctuation 2D correction
      └─────────────────────────────────┘
```

Cluster-error fixes (ATO-630) should *improve* the σ_ptrel and σ_qpt numbers measured by this framework. A Run 2 → Run 3 gap that *closes* in this framework after ATO-630 deployment = end-to-end validation.

### 10.2 Contrast with ATO-630 deck

| Aspect | ATO-630 deck | This deck |
|---|---|---|
| Level of observable | Cluster / track residuals | Invariant-mass, decay-kinematic |
| Driver parameter | Occupancy (2D map) | σ_ptrel, σ_qpt, σ_ang (1 scalar each) |
| Validation strategy | 54-setting parameter scan on real LHC23zzh data | ToyMC closure at known ground truth |
| Deliverable | Cluster-error parameterisation code in O2 | ND histograms in → calibration tables out |
| Teams | TPC offline group, ALICE reconstruction | O2RecoAI + Strangeness QA + Charm QA |
| Dissertation chapter connection | Calibration & reconstruction performance | Cross-species validation, systematic-effect diagnostics |

## 11. Open items, anomalies, and checklist

### 11.1 `[VERIFY]` flags — from front-matter

1. Authorship of "M. Ivanov Jr." — full name + ORCID before citation.
2. "correct v4" label semantics on slide 3/4 — what version series.
3. σ_ang 2.26 → 2.35 mrad·GeV LHC22-24 → LHC25: interpretation attributed to "new ITS geometry."
4. Fisher-matrix condition number 3.2 against B4 numbers (both quoted in deck; cross-verify).
5. Bias polynomial order rationale (why quadratic stop).
6. Low-pT linearisation fix "in new version" — is that this v7 or a later version?
7. Charge-decomposition sign rule Λ/Λ̄ against working code.
8. K⁺/K⁻ hadronic-interaction asymmetry in current ALICE MC.
9. 3.6× factor in bias/fluctuation decomposition (§8) provenance.
10. Gluckstern trailing slide (§11.3 below) — intentional or accidental?
11. Δφ-axis binning count (§7.2 axis 4).

### 11.2 Figure extraction deferred

Resolution correlation scatter plots (slide 13), bias correlation plots (slide 14), overview triptych (slide 15), and grid-QA heatmaps (B8, B9) are not reproduced in this text-only pass. For tomorrow's prep or follow-up citation, these plots need to be extracted from the PPTX directly.

### 11.3 The trailing "Gluckstern Formula with √720" slide

The final slide of the extracted content is titled *"Found It! The Gluckstern Formula with √720"* and contains:
- ASCII-art formulas for Gluckstern momentum resolution.
- The Gluckstern 1963 NIM reference.
- The complete point+MS formula.
- **A closing prompt: "Would you like me to: Create a slide with this formula? Show how this applies to your K⁰ resolution data? Derive the √720 factor from first principles?"**

That closing prompt is what a chat interface says, not what a presentation slide says. This slide appears to be **accidentally-pasted chat content** — likely from a conversation with an AI about the Gluckstern formula — that ended up in the deck but was not authored-as-a-slide. The physics content (Gluckstern 1963, NIM A 24, 381) is entirely standard and referenced correctly, but the *form* is wrong for a presentation slide.

**Recommendation:** either (a) replace with a proper Gluckstern slide before publication, (b) remove it entirely if it wasn't meant to be there, or (c) keep the physics content but strip the closing prompt. I have preserved the Gluckstern reference in the front-matter BibTeX (§13) so the reference survives regardless of the slide's fate.

**[VERIFY]** with the author: is this intended deck content?

### 11.4 Reviewer checklist

- [ ] Run the ToyMC closure test independently against v7 code (partO2-6685 commits 8ec683d0 + fbefaf9e per B10).
- [ ] Verify slide-3 fit-parameter table reproduces from current strangeness-QA output.
- [ ] Verify B4 Fisher-matrix condition number 3.2.
- [ ] Verify B7 coefficient lookup at one (species, pT) entry.
- [ ] Confirm authorship / ORCID for M. Ivanov Jr.
- [ ] Resolve the Gluckstern trailing slide (§11.3).
- [ ] Confirm Δφ-axis binning (§7.2).
- [ ] Run `[VERIFY]` items 1–11 (§11.1).

## 12. Glossary (deck-specific terms)

| Term | Definition |
|---|---|
| **σ_ptrel** | σ(pT)/pT floor. Dimensionless. Multiple-scattering-dominated at low pT. |
| **σ_qpt** | Curvature precision. Units c/GeV. Point-resolution-dominated at high pT. |
| **σ_ang** | Angular resolution scale. Units mrad·GeV. |
| **SM2_x** | Coefficient of σ²_x in the σ²_M decomposition. Kinematic-only, computed per species. |
| **dM_dqptk** | Transfer coefficient from bias parameter `dqptk` to invariant-mass bias δM. |
| **dqpt0/1/2** | Bias parameters: constant / linear / quadratic in (q/pT). |
| **cosθ*** | Decay angle in rest frame; main sensitivity variable for bias. |
| **exp0 / exp1** | Resolution models: no-bias / bias-variance-included (see §3.3). |
| **IQR / 1.349** | Robust Gaussian-σ estimator from the interquartile range. |
| **Kurtosis gate** | Rejection criterion (kurtosis > 1.0 → non-Gaussian → excluded). |
| **Condition number** | Stability metric of the Fisher matrix; 3.2 here = well-posed. |
| **E3 closure** | ToyMC test at configuration E3 (ground-truth known; recovery < 4 %). |
| **Sliding-window fit** | Fit technique avoiding hard bin edges; bin boundaries adjust to statistics. |
| **ND histogram** | N-dimensional binned histogram — the operational deliverable requested in §7.2. |
| **RootInteractive ND maps** | Interactive dashboard framework used for calibration-map visualisation. See [ATO-630 §14](./ATO-630_OccupancyImpact_OfflineWeek_20241031.md). |
| **TPC-only V0 refit** | Alternative V0 reconstruction using TPC tracking only — complementary momentum scale to ITS+TPC; explicitly out of scope for current Phase 0.1E. |
| **Phase 0.1E** | O2RecoAI phase designation for the current invariant-mass-calibration work. |

## 13. References

### 13.1 Data sources (cited in deck `[Sn]` notation)

| Ref | Citation | Role |
|---|---|---|
| [S1] | R. Shahoyan — Physics Data Processing board, 2026-02-17 | Run 3 LHC22–24 (preliminary) and LHC25 (correct v4) fit-parameter table source |
| [S2] | R. Schotter — Strangeness QA | K⁰s, Λ, Λ̄ mass distributions |
| [S3] | M. Ivanov — Physics Working group, 2018 | Run 2 peripheral reference numbers |

**[VERIFY]** — extracting specific Indico URLs for [S1]/[S2]/[S3] requires opening the deck's figure slides; not captured in text-only extraction.

### 13.2 External references

| Ref | Citation |
|---|---|
| G1 | R. L. Gluckstern, *Uncertainties in track momentum and direction, due to multiple scattering and measurement errors*, Nucl. Instrum. Meth. **24** (1963) 381. Standard momentum-resolution formula; reference appears on trailing slide (§11.3). |

### 13.3 Code and git anchors

| Anchor | Role |
|---|---|
| `partO2-6685` | Git branch/issue for the framework |
| Commit `8ec683d0` | ToyMC validation snapshot |
| Commit `fbefaf9e` | Framework extension snapshot |
| `o2recoai` (Python, numpy-optimised, ~3 s/config) | The implementation |
| Analytical derivatives validated to < 10⁻⁸ vs numerical (10× faster) | Per slide B10 |

### 13.4 BibTeX stubs

```bibtex
@misc{O2RecoAI-InvMass-v7-2026-02,
  author = {Ivanov, Marian and Ivanov, Marian Jr. and Schotter, Romain and {Matthias}},
  title  = {{ALICE Tracking Performance --- Invariant Mass Resolution and Bias Calibration: Analytical Parametrization with ToyMC Validation}},
  year   = {2026},
  month  = feb,
  note   = {O2RecoAI group, ALICE Experiment; PowerPoint Presentation\_v7.pptx; Drive ID 1W0uqqBxgcO9Rk6aEZVUDqEwj8TXx3XEh},
  url    = {https://drive.google.com/file/d/1W0uqqBxgcO9Rk6aEZVUDqEwj8TXx3XEh/view}
}

@article{Gluckstern-NIM-1963,
  author  = {Gluckstern, R. L.},
  title   = {{Uncertainties in track momentum and direction, due to multiple scattering and measurement errors}},
  journal = {Nucl. Instrum. Meth.},
  volume  = {24},
  pages   = {381},
  year    = {1963}
}
```

## 14. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`./ATO-630_OccupancyImpact_OfflineWeek_20241031.md`](./ATO-630_OccupancyImpact_OfflineWeek_20241031.md) | §10.1 dependency graph; §10.2 contrast table | live (DRAFT wiki-v0) |
| [`./MITPCTPC_IonDrift_20122023.md`](./MITPCTPC_IonDrift_20122023.md) | §10.1 orthogonal correction stream | live (DRAFT wiki-v0) |
| [`../TDR/tpc.md`](../TDR/tpc.md) | §10.1 detector baseline | live (DRAFT wiki-v2) |
| [`../TDR/its.md`](../TDR/its.md) | §2 ("new ITS geometry" gains on angular resolution) | live (DRAFT wiki-v1) |
| [`./PWGPP-643_combined_shape_estimator.md`](./PWGPP-643_combined_shape_estimator.md) | (anticipated — shape estimator may use same cluster-level input) | planned (draft exists) |
| [`./O2-5095_TPC_dEdx_index.md`](./O2-5095_TPC_dEdx_index.md) | (anticipated — dEdx-related systematics interact with this framework) | planned (draft exists) |
| [`./O2-4592.md`](./O2-4592.md) | (reconstruction-chain context) | live (DRAFT) |

Status values: `planned` / `live` / `broken` per the standard convention.

## Appendix A: Source-to-section map

Main slides (1–21):

| Slide | Content | Indexed in |
|---|---|---|
| 1 | Title / authors / abstract | §1 |
| 2 | Motivation — σ_M as integrator of momentum + angular | §2 intro |
| 3 | Current results table "apples vs oranges" | §2, §2.1 |
| 4 | Run 2 vs Run 3 fit comparison | §2 (central table) |
| 5 | Resolution model 3-parameter formula | §3.1 |
| 6 | Cross-species leverage table | §4 |
| 7 | Kinematic coefficients / η vs φ | §5 |
| 8 | ToyMC pipeline 6-step | §6.1 |
| 9 | Bias model δ(q/pT) | §3.2 |
| 10 | Resolution + bias complete picture | §3.3 |
| 11 | Robust estimators (IQR, kurtosis gate) | §6.3 |
| 12 | ToyMC parameter scan 8/8 pass | §6.2 |
| 13 | Resolution per-species correlation r > 0.92 | §6.2 |
| 14 | Bias validation δM(cosθ*) r > 0.97 | §6.2 |
| 15 | ToyMC overview ±5 % | §6.2 |
| 16 | Why global fits (single-species limitations) | §4.2 |
| 17 | From ToyMC to real data staged rollout | §7.1 |
| 18 | Data request ND histograms | §7.2 |
| 19 | Charge decomposition mandatory | §7.3 |
| 20 (labelled "18" in source) | Bias vs fluctuation — statistics requirement 3.6× | §8 |
| 21 | Roadmap 4 priorities | §9 |

Backup slides (B1–B10):

| Slide | Content | Indexed in |
|---|---|---|
| B1 | D⁰ coefficient bug — v3.0 constant 2.83 was wrong | §5 context |
| B2 | v3.2 → v5 impact of corrected coefficients | §5 context |
| B3 | η vs φ derivative physics per particle | §5 (table) |
| B4 | Fisher matrix + condition number 3.2 | §4.1 |
| B5 | Non-linear mass formula at low pT | §6.3 |
| B6 | exp1 integration condition | §3.3 |
| B7 | Coefficient lookup tables | §5.1 |
| B8 | Grid QA — resolution | §6.2 (figure stubbed) |
| B9 | Grid QA — bias | §6.2 (figure stubbed) |
| B10 | Code and data availability + review history | §1 + §13.3 |

Trailing anomalous slide:

| Slide | Content | Indexed in |
|---|---|---|
| (unlabelled, end) | Gluckstern formula with √720 | §11.3 |

## Appendix B: Notation

| Symbol | Meaning |
|---|---|
| σ_M | Invariant-mass resolution |
| δM | Invariant-mass bias |
| σ_ptrel | σ(pT)/pT dimensionless resolution floor |
| σ_qpt | Curvature precision, units c/GeV |
| σ_ang | Angular resolution scale, mrad·GeV |
| SM2_x | Fisher-matrix coefficient (per species, per pT) |
| dM_dqptk | Bias transfer coefficient (per species, per pT, per cosθ*) |
| cosθ* | Decay angle in rest frame |
| q/pT | Charge-signed curvature |
| IQR | Interquartile range |
| r | Pearson correlation coefficient (used as validation metric) |
| 0.3·B·L² | Gluckstern curvature-to-pT conversion factor |
| √720 | Gluckstern optimal-weighting factor (= √(720/N) statistical factor; √720 ≈ 26.83) |

## Changelog

- **2026-04-19 — wiki-v0 (cycle 0), Claude5 as indexer.** Initial distillation of `Presentation_v7.pptx` (O2RecoAI invariant-mass framework, February 2026 version, modified through 2026-03-04). Main slides (1–21) and backup slides (B1–B10) indexed thematically. Figure content deferred to a figure-extraction pass. Trailing "Gluckstern √720" slide flagged as likely-accidental chat-paste in §11.3 — physics content preserved in §13.2 regardless. Eleven `[VERIFY]` flags in front-matter `known_verify_flags` and §11.1. Cross-links to sibling presentations (ATO-630 offline-week, MITPCTPC IonDrift) and detector pages (`../TDR/tpc.md`, `../TDR/its.md`) use the ratified `TDR/` folder name per TS v0.3 §2. Schema follows provisional §5 of Technical_SUMMARY_MIWikiAI v0.3.

---

*Compiled by Claude5 (Claude Opus 4.7) on 2026-04-19 as wiki-v0 DRAFT. Working-deck index — claims reflect v7 state (Feb 25 → Mar 4 2026). Framework-and-validation deck; numbers (fit parameters, Fisher-matrix condition, closure percentages) are load-bearing and cross-referenced to backup slides where available. This is MIWikiAI review-cycle 0; the per-slide-B10 note about "6 reviewers, all approved, 7 P1 items fixed" refers to O2RecoAI internal review, not this wiki page's review state.*

*No quota issues observed during authoring.*
