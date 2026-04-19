---
wiki_id: ATO-630_OccupancyImpact_OfflineWeek_20241031
title: "Impact of Occupancy on TPC Space-Point Resolution, Tracking, and PID — Bias, Smearing, Mitigation (offline week 31.10.2024)"
project: MIWikiAI / ALICE
folder: presentations
source_type: working-presentation-index
source_title: "ATO-630_SystermaticError_TPCmeeting_24012023 (Google Slides; reused Jan 2023 → Oct 2024)"
source_fingerprint:
  upstream:
    - id: ATO-630-Slides-2024-10-31
      title: "Impact of Occupancy on TPC Space Point Resolution, tracking and PID: Bias, Smearing, and Mitigation Strategies in Reconstruction"
      drive_filename: "ATO-630_SystermaticError_TPCmeeting_24012023"
      drive_id: "1fWy2IRnJW-VDMtbYhyrhIFGkEMsvlSt8-fhiLjqvCfA"
      view_url: "https://docs.google.com/presentation/d/1fWy2IRnJW-VDMtbYhyrhIFGkEMsvlSt8-fhiLjqvCfA/edit"
      owner: "miranov25@googlemail.com (Marian Ivanov)"
      created: "2024-01-24"
      modified: "2024-10-31"
      venue: "ALICE offline week, 31.10.2024"
      deck_lineage: "Originally assembled Jan 2023 as ATO-630 systematic-error meeting deck; accumulated content through ~10 intermediate updates; current state is the 31.10.2024 offline-week version"
      extracted_slides: "~207 (duplication heavy across working updates; many sections repeat 2–3×)"
      filename_note: "`Systermatic` in the upstream filename is a typo for `Systematic`; wiki normalises the subject token in wiki_id (ATO-630 ticket ID is authoritative)"
    - id: Ivanov-CHEP2003-arXiv
      title: "Weight-fluctuation theory of TPC cluster resolution (CHEP 2003 proceedings preprint)"
      arxiv: "physics/0306108"
      url: "https://arxiv.org/pdf/physics/0306108.pdf"
      role: "theoretical base for diffusion + angular + combined cluster-resolution formulas used throughout deck; cited ≥ 6× in the slides"
    - id: ALICE-TPC-NIM-2010
      title: "The ALICE TPC, a large 3D tracking device with fast readout (Alme et al.)"
      journal: "Nucl. Instrum. Meth. A 622 (2010) 316–367"
      url: "https://www.sciencedirect.com/science/article/pii/S0168900210008910"
      role: "Run 1 / Run 2 analytical parameterization of space-point resolution (MWPC era, low IR)"
    - id: ALICE-TPC-pass2-MDPI
      title: "Run 1 / Run 2 pass2 tracking fix: Q, dEdx, and rate dependence in cluster error"
      journal: "Particles 5(1) (2022) 8"
      url: "https://www.mdpi.com/2571-712X/5/1/8"
      role: "documents the Run 1 / Run 2 pass2 fix where Q/dEdx/rate dependence was added to the cluster-error estimator; the Run 3 story is re-doing this lesson"
    - id: ALICE-Laser-Calibration-2023
      title: "TPC laser calibration (Ivanov, Yiota, Mesut et al., ~2020 work, 2023 writeup)"
      arxiv: "2304.03881"
      url: "https://arxiv.org/pdf/2304.03881.pdf"
      role: "laser validation of common-mode capacitive-coupling correction; referenced for the CRU-firmware closure-test status"
    - id: Ivanov-CHEP2003-InspireHEP
      title: "TPC tracking and particle identification in high-density environment (CHEP 2003 MI proceedings)"
      inspirehep: "https://inspirehep.net/literature/621229"
      conference: "CHEP 2003, SLAC, eConf C0303241"
      role: "the proceedings companion to arxiv.org/pdf/physics/0306108; source for 1D → 2D nearest-neighbour distance derivations used on slides 10 / 125"
    - id: PDG-Detectors-2019
      title: "Particle detectors at accelerators — PDG Review 2019"
      url: "https://pdg.lbl.gov/2019/reviews/rpp2019-rev-particle-detectors-accel.pdf"
      role: "referenced as canonical source for combined/corrected dEdx per region in Run 2"
    - id: Ivanov-Overleaf-Thesis
      title: "Ivanov PhD thesis — public note (Overleaf project)"
      url: "https://www.overleaf.com/project/642845e49aeb65eb8a4c23aa"
      role: "umbrella thesis document; this deck feeds directly into §§ on cluster error parameterization and occupancy mitigation"
    - id: Companion-Same-Meeting
      title: "Same-meeting companion — Tracking in high-density environment (mitigation details)"
      url: "https://indico.cern.ch/event/1463360/#283-tracking-in-high-density-e"
      role: "explicitly cross-referenced from slide 20: 'Further mitigation strategies for combined tracking and PID in separate presentation with the same meeting'"
  summary_version: "n/a (living working deck; ~10 intermediate updates between Jan 2023 and Oct 2024)"
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
  - "§3.2 σ_angle ≈ 0.24, σ_drift ≈ 0.12 cm/drift (dY) vs 0.15 cm/drift (dZ), σ_rate ≈ 0.1–0.11 cm/MHz, σ_0 ≈ 0.06 cm vs 0.0 cm — verify against current ATO-630_ErrParam.C commit"
  - "§4.1 cluster-overlap probability P(0.2 occupancy) ≈ 86 % on 3×3 time×pad matrix — assumes independence; deck flags this as simplistic"
  - "§4.2 nearest-distance formula assumes 15 000 clusters/row at 37 kHz, 32 drift bins, tan(π/9) sector opening — verify scaling if rate or sector geometry changed"
  - "§5.3 virtual-charge correction linear coefficient 2.8 in treeCl->SetAlias formula — empirical; verify derivation"
  - "§6.2 IFC exponential decay slope ≈ 1/(5 cm), default err0 = 3 cm, minDist = 2 cm, maskError = 5 cm — parameters are empirical defaults"
  - "§7.1 C1&C2 fluctuation onset at ~25 kHz, B-field dependent — verify against 2024 data"
  - "§8.2 ωτ ≈ 0.33 from Run 1 laser calibration — 'never published' per deck slide 27; track provenance"
  - "§10.1 factor-~3 occupancy-slope reduction in DCA and angular matching — cite the 54-setting scan output as primary evidence"
  - "§13 some Indico URLs use event fragments (e.g. `#preview:4835782`, `#390-overview-of-the-run-3-reco`) — fragment stability over years not guaranteed"
wiki_sections_stubbed:
  - "Figures and plots in deck are not reproduced; textual content and formulas captured. A figure-extraction pass is deferred."
---

# Impact of Occupancy on TPC Space-Point Resolution, Tracking, and PID — working-deck index (offline week 31.10.2024)

> **What this page is.** An indexed, cross-linked rendering of the 2024-10-31 offline-week presentation by Marian Ivanov on the ATO-630 systematic-error / occupancy programme. The deck has been a living document since January 2023 and accumulates the full arc of the Run 3 cluster-error → track-error → sector-edge → IFC → C1&C2 → composed-correction story. For the companion deck on ion-disc-fluctuation 2D correction specifically, see [./MITPCTPC_IonDrift_20122023.md](./MITPCTPC_IonDrift_20122023.md); that one is a subset of the programme described here.
>
> **Working status.** Claims are 2024-10-31 working-status. Quantitative results cite the ATO-630 parameter scan, the LHC23zzh 544116.38kHz GSI pre-production as the canonical benchmark dataset, and the 5 TPC-notes JIRA tickets (ATO-615 / ATO-628 / ATO-630 / ATO-650 / ATO-650-C12). Not a peer-reviewed result; not a TDR.
>
> **If you are Marian preparing tomorrow's talk:** §13 collects every article, proceedings, thesis reference, Indico link, code repo, and JIRA ticket mentioned in the deck, organised by type. That section is the priority deliverable of this wiki page.

## TL;DR

Three high-level claims drive the deck:

1. **Run 3 TPC cluster resolution is ~√2 worse than Run 2 intrinsic** — attributable to a widening of the gas-gain PDF by ~√2 · σ_GG / ⟨GG⟩, measured experimentally via Fe-55 peak width [Ivanov-CHEP2003-arXiv weight-fluctuation theory; slide 135]. Combined with *factor-3 larger occupancy* in Run 3 PbPb vs Run 1/2, the untreated performance gap is substantial: factor-2 worse DCA at high rate relative to the PbPb 50 Hz Run-2-like reference (3 mm → 6 mm).
2. **The Run-1 / Run-2 lessons are not yet fully redeployed in Run 3.** In particular: Q and dEdx dependence in the cluster-error formula (fixed for Run 1/2 in pass2 [ALICE-TPC-pass2-MDPI]), rate-dependent track systematic error, and the CHEP-2006 TRD-style tracklet refit are all items the Run 3 code either missed initially or is only now re-adding. The pass3 → pass4_test benchmark shows the first measurable gains from this redeployment.
3. **A 54-setting parameter scan at GSI (LHC23zzh pre-production) shows the new occupancy-dependent error parameterisation reduces the DCA and angular-matching *occupancy slope* by a factor of ~3** [slide 172]. Offset reductions of 20–22% in DCA resolution follow, concentrated at high-pT where MS is not dominant.

Supporting threads:

- **Occupancy, not rate, is the dominant driver.** Two tracks at the same interaction rate can have very different local occupancies (see §4.3 fit: rate coefficient one order of magnitude smaller than local-occupancy coefficient). Cluster overlap probability on the 3×3 time×pad matrix approaches **86% at 20% occupancy** under the independence approximation [slide 9].
- **Sector boundaries are one of the biggest deteriorators.** Edge bias has at least four components (incomplete clusters, fake contributions, imperfect distortion calibration, tracking selection bias). A Run-1-style virtual-charge correction can reduce effective dead zone from 1.7 → 1.3 cm [slide 87].
- **Sectors C1 and C2 fluctuate anomalously.** IDC0 RMS is ~20× larger than in other sectors; onset at ~25 kHz; B-field dependent. Root cause in Run 2 was "sticky wires"; in Run 3 the source is **not yet known** [slide 113]. Mitigation is rate-dependent systematic error + cluster masking, not correction.
- **IFC (inner field cage) imperfections** are exponential-in-ΔR with slope ≈ divider-gap pitch. They drive most of the innermost-padrow bias. Mitigation: mask r − r_IFC < 2 cm (error = 5 cm), apply exponential decay with slope 1/(5 cm) above that.
- **Composed correction is non-linear in maps, linear in local distortion vectors.** This is the key factorisation result (shared with [./MITPCTPC_IonDrift_20122023.md §5](./MITPCTPC_IonDrift_20122023.md)): Taylor-expand around a nominal map for global regime; linearly combine local-distortion deltas for cross-rate reuse.
- **Track refit improvement is the open frontier.** CHEP-2006 TRD-style tracklet-based refit with LTS (Least Trimmed Squares) robust fitting and lever-arm-aware angular weighting was prepared 2019–2020 for Run 3 TRD but not deployed. Slide 17 proposes porting to TPC; this would address the residual resolution beyond what cluster-error alone achieves.

For dissertation scope see §12.

## 1. Context and scope

**When:** ALICE offline week, 2024-10-31 (slide 1 title block: "For offline week 31.10.2024"). Deck lineage traces to 2024-01-24 upload as the ATO-630 systematic-error TPC-meeting deck; the two dates are visible in Drive metadata (created 2024-01-24, modified 2024-10-31).

**Who:** Marian Ivanov (deck author, dissertation lead).

**What ticket:** [ATO-630 in alice-tpc-notes](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/tree/master/JIRA/ATO-630) is the primary tracker. The deck also touches ATO-615 (track covariance), ATO-628 (combined-tracking dashboard), and ATO-650 (parameter scan production).

**Scope of the deck:**
1. **Part 1 (slides 1–20).** Comparative analysis Run 1 / Run 2 / Run 3 cluster resolution. Occupancy impact on resolution and PID. Mitigation strategies. Explicit cross-reference at slide 20 to a same-meeting companion on *combined tracking + PID mitigation* — see §13.2 below.
2. **Part 2 (slides 22–45).** Non-parametric distortion map fit; composed correction (options 1 and 2); V-shape C-side calibration via template DCA fit; new variables in AO2D time-series.
3. **Part 3 (slides 45–62).** Systematic error for tracking and clustering, specifically extended from a 2023-01-25 working state. TPC intrinsic resolution budget. Stochastic vs systematic cluster and track errors. Additive cluster error.
4. **Part 4 (slides 63–~170).** The new TPC refit algorithm: motivation, sector-edge effects, edge-bias toy MC, common-mode coupling, C1&C2 fluctuation mitigation, parameter-scan campaign at GSI.
5. **Part 5 (slides ~170–207).** Benchmark scan (54 settings) results, DCA improvement, pass3 → pass4_test strangeness-performance gain, data-driven efficiency correction using trackQA AO2D, AO2D table proposals.

**What the deck is not:**
- Not a single-event report. It's a campaign summary across almost two years.
- Not peer-reviewed; claims reflect the 2024-10-31 state.
- Not the code — code lives in AliceO2Group/AliceO2 and alice-tpc-offline/alice-tpc-notes; see §13.6.

## 2. The core problem: Run 3 TPC at high occupancy

### 2.1 The Run 1 / Run 2 baseline

At low interaction rate with MWPC readout, the TPC space-point resolution factorises cleanly into four independent stochastic terms [Ivanov-CHEP2003-arXiv §§2–3; ALICE-TPC-NIM-2010]:

- **Diffusion term** (gas-gain-fluctuation-weighted) — drift-length dependent.
- **Angular term** (secondary-ionisation fluctuation) — tan(α) dependent, pad-length scaled.
- **Noise + baseline fluctuation** — nominally rate-independent at low IR.
- **Occupancy term** — subdominant at Run 1 / Run 2 rates except at the highest multiplicities.

The Run 1 tracking code initially **did not** use Q, dEdx, or rate in space-point error estimation, producing dEdx- and rate-dependent χ² and missing-cluster fractions; fixed in pass2 [ALICE-TPC-pass2-MDPI]. This is the lesson Run 3 is re-learning.

### 2.2 What changed in Run 3

Three changes compound:

1. **GEM readout** (from MWPC). Ion backflow now drives large time-dependent space-charge distortions — see [../TDR/tpc.md §6.1, §7](../TDR/tpc.md) for detector-side background.
2. **Higher occupancy.** Run 3 PbPb runs at 50 kHz (design), producing ~3× higher local occupancy than Run 2. Absolute cluster counts quoted: ~15 000 clusters per row at 37 kHz [slide 10].
3. **Transparency / gas-gain widening.** PDF of the gas gain broadens by ~√2·σ_GG/⟨GG⟩ (measured via Fe-55 peak width). This degrades cluster resolution *before* any occupancy effect — the effect appears in the intrinsic Run 3 resolution budget as a factor-√2 vs Run 2.

### 2.3 Three failure modes

The deck organises the observed problems into three classes:

| Class | Nature | Dominant in | Fix strategy |
|---|---|---|---|
| **Stochastic cluster error** | Diffusion + angular + baseline + occupancy | All rates; occupancy drives Run 3 excess | Extend analytical formula (§3) |
| **Systematic cluster error** | Correlated bias from imperfect correction maps (IFC, C1&2 fluctuation, sector edge, charging) | High-gradient regions | Mask + exponential/box-shaped additive error (§5–§7) |
| **Systematic track error** | Residual bias of distortion maps surviving cluster-level correction | All tracks, rate-dependent | Additive to track covariance diagonal; linear-in-rate extension in prep. (§10 roadmap) |

## 3. Cluster error parameterisation — the main deliverable

### 3.1 Run 1 / Run 2 theoretical basis

The weight-fluctuation derivation in [Ivanov-CHEP2003-arXiv] §§2–3 gives the combined cluster-resolution formula at low IR. Section 4 of that preprint extends it with Q/dEdx dependence. This is the formula family that [ALICE-TPC-pass2-MDPI] documents as the Run 1/Run 2 pass2 deployment.

### 3.2 Run 3 formula (implementation)

The O2 implementation comes in two versions, committed to [alice-tpc-notes / ATO-630_ErrParam.C](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/22bd07586bed2e118fcb5ffd6586149e5de9d113/JIRA/ATO-630/ATO-630_ErrParam.C#L9-28):

**Version A — without Q dependence (August 2023):**

```cpp
// x[0]=tan(angle), x[1]=scaled drift (0-1), x[2]=scaled multiplicity (pp @1 MHz units)
// p[0]=offset, p[1]=angular, p[2]=diffusion, p[3]=multiplicity, p[4]=padLength
double getResolutionScaled(double *x, double *p) {
   float sigma2 = 0;
   sigma2 += p[0]*p[0];
   sigma2 += p[1]*p[1] * x[0]*x[0] * p[4];          // angular
   sigma2 += p[2]*p[2] * x[1] / p[4];                // diffusion
   sigma2 += p[3]*p[3] * x[2];                       // multiplicity
   return TMath::Sqrt(sigma2);
}
```

**Version B — with Q/⟨Q⟩ dependence, Run-2-style (May 2024):**

```cpp
// additional x[3]=Q/MIP, x[4]=<Q>/MIP
double getResolutionQ(double *x, double *p) {
   float sigma2 = 0;
   sigma2 += p[0]*p[0];
   sigma2 += p[1]*p[1] * x[0]*x[0] * p[4] / x[4];          // angular/⟨Q⟩
   sigma2 += p[2]*p[2] * x[1] / (p[4] * x[3]);              // diffusion/Q
   sigma2 += p[3]*p[3] * x[2] / x[4];                       // multiplicity/⟨Q⟩
   return TMath::Sqrt(sigma2);
}
```

**Current Run 3 fit parameters** (from [ATO-630_ErrParam.C](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/769d5ce72145f3315edce0e0ba5d145ea1a7710b/JIRA/ATO-630/ATO-630_ErrParam.C)):

| Parameter | dY value | dZ value | Meaning |
|---|---|---|---|
| σ_angle | 0.24 | 0.24 | angular term coefficient |
| σ_drift | 0.12 cm/drift | 0.15 cm/drift | diffusion coefficient |
| σ_rate | 0.10 cm/MHz | 0.11 cm/MHz | multiplicity/rate coefficient |
| σ_0 | 0.06 cm | 0.0 cm | constant offset |

Next-iteration plan: cosmic-ray data needed to disentangle tgl and drift contributions to σ_0. **`[VERIFY]`** — these numerical values are from the May-2023 fit; verify against the current code.

### 3.3 Timeline (from deck)

- **August 2023:** first Run-3 parameterisation deployed without Q dependence (Version A).
- **May 2024:** occupancy usage turned on.
- **May 2024:** Q-dependent version (Version B) deployed.
- **October 2024 (this deck):** 54-setting scan validates; pass3 → pass4_test benchmark delta shows invariant-mass improvement at high and intermediate pT.

## 4. Occupancy impact on space-point resolution

### 4.1 Cluster-overlap probability

For a 3×3 time×pad matrix defining a cluster region, under the independence approximation:

```
P(overlap) = 1 − (1 − occupancy)^9
```

Evaluated:

| Occupancy | P(overlap) |
|---|---|
| 10 % | 61 % |
| **20 %** | **86 %** |
| 30 % | 96 % |

Deck flags this is a simplistic formula (independence assumption); real clusters show correlation. Still, the scaling is steep: the Run 3 PbPb mean occupancy (10–30%) places a significant fraction of clusters in overlap [slide 9].

### 4.2 Nearest-neighbour distance (2D exponential)

Given n points distributed on L cm² area, the 2D nearest-neighbour PDF is **not** the 1D exponential form — it is:

```
f(d) = 2π ρ d · exp(−π ρ d²)
```

where ρ is the areal density. For 15 000 clusters per row at 37 kHz, with 32 drift bins of 250 cm length × local-X sector opening tan(π/9):

```cpp
TF1 frho1("f1", "[0]/(32*250*x*tan(pi/9))", 90, 250);
frho1->SetParameter(0, 15000);   // 15 000 clusters / row @ 37 kHz
TF1 fd("fd", "1/(2*sqrt([0]/(32*250*x*tan(pi/9))))", 90, 250);
```

**[VERIFY]** cluster-per-row scaling if rate or sector geometry changed. Deck attributes the derivation to GPT-generated formulas [slide 10 code comment].

### 4.3 MAE fits — the dominant-term argument

Four variants of the linear-ridge MAE fit are run with progressively more covariates [slides 12, 120]:

| Variant | Covariates | Fit result (|Δy| coefficients) |
|---|---|---|
| F0 | `o15x, |snp|` | `[9.39e-05, 0.026]` |
| F1 | `+ rate` | `[9.06e-05, 0.0255, 3.02e-07]` |
| F2 | `+ avgCharge` | `[9.99e-05, 0.0347, 4.55e-07, 0.759]` |
| F3 | `+ o15x·avgCharge²` | `[3.87e-05, 0.0334, 4.6e-07, 0.328, 0.00199]` |

**Key takeaway:** the **local-occupancy coefficient on o15x is the dominant term**, ~100× larger than the rate coefficient. The rate coefficient is `O(10⁻⁷)` vs local-occupancy `O(10⁻⁴)` in the linear-regression result. **Occupancy, not rate, is what matters** — two tracks at the same IR can see very different local occupancies.

The charge dependence matters: at high Q, the effective dependence on rate *decreases*. Physical interpretation: high-Q clusters are less perturbed by background charge superposition [slides 12, 120].

### 4.4 MC occupancy fits (preliminary)

A simple additive-in-square fit `|dy| = √(p0² + (p1·x/2500)²)` fits both MC and data to occupancy-scaled-by-radius [slides 13, 123]:

```
Data scan 8–38 kHz:  |dY(cm)| vs occu15/lx — fit ok
MC 38 kHz with distortion + attachment: p0 = 0.1777 ± 0.0008, p1 = 0.5566 ± 0.0032
```

MC **qualitatively** describes worsening as function of local occupancy. Quantitative MC/data comparison is pending [slide 13].

## 5. Sector edge and dead-zone effects

### 5.1 The convolution of four effects

Edge bias is a composite [slides 86, 105]:

1. **Incomplete clusters** — dead zone cuts off the Gaussian charge distribution.
2. **Fake clusters** — contamination from mis-associated hits.
3. **Imperfect distortion calibration** — boundary gradients exceed 3D-map resolution.
4. **Tracking selection bias** — χ² cuts remove the informative edge clusters.

Observable patterns:
- Δy bias 0–3 cm (IR-dependent).
- Dead-zone ~ 3 cm width.
- ITS extrapolation resolution 0.6–3 cm → masks the edge structure with its own uncertainty.
- ExB generates asymmetry in electron arrival; Δrφ ≈ ωτ(0.3) · Δr — at high IR this becomes comparable to the dead-zone itself.

### 5.2 Virtual-charge correction (Run-1 legacy)

The Run-1 offline reconstruction used a virtual charge on the sector edge, reflecting pad-response-function + diffusion coupling — documented in [Ivanov-CHEP2003 proceedings; slide 87]. The correction shifts edge-pad clusters by an amount permitted by the expected cluster width:

```cpp
treeCl->SetAlias("dSigmaY", "sqrt(sigmaY2Out) - sigmaY");
treeCl->SetAlias("dyEdgeCorr",
  "-sign(y) * (abs(y)<2.3) * (dSigmaY<-0.1) * (dSigmaY+0.1) * 2.8");
```

**Effect:** effective dead zone shrinks from 1.7 cm → 1.3 cm. **[VERIFY]** the empirical factor 2.8 — derivation not in slide.

### 5.3 Dead-zone cut strategy

Alternative to virtual-charge correction: simply *don't attempt* cluster assignment in the dead-zone. Parameters scanned: `no-mask`, `PadCenter`, `PadCenter − 0.3 cm`. The "mask-at-pad-center" option significantly improves DCA performance and reduces outlier fraction at sector boundaries [slides 107–108].

Trade-off: reduces cluster count on highly-inclined tracks (which cross sector boundaries) but the remaining clusters are unbiased. For combined tracking with ITS, this is the better trade.

### 5.4 Calibration by high-precision ITS+TPC tracks

The insight from slide 89: ITS extrapolation has O(cm) resolution, but **combined ITS+TPC** tracks have 0.025–0.05 cm intrinsic resolution. Use the combined tracks to build residual maps capable of resolving sub-mm gradients.

**Algorithm:**
1. Generate delta tree Δ₀ for ΔR and ΔRφ.
2. Apply 3D-map corrections → Δ₁.
3. Parabolic fit to Δ₁, zero at ITS midpoint (≈ 20 cm).
4. Store Δ₀, Δ₁, and fit residuals for downstream map creation.

Factor 100–1000× less data needed for high-precision calibration vs ITS-extrapolation alone, and outlier detection simplified.

## 6. IFC (inner field cage) imperfections

### 6.1 Guard-ring oscillation structure

From the September 2023 high-rate (~660 kHz pp) studies [slides 32–34, 60–62]:

- **Oscillations in Z** with granularity 20 / 10 cm — matches the guard-ring spacing.
- **Radial decay** approximately exponential, slope matching the divider gap pitch.
- **Rate dependence** — at higher IR, radial distortion brings the IFC-neighbourhood exponential tail deeper into the fiducial volume. Systematic bias in innermost padrows therefore depends **exponentially on ΔR** and hence **exponentially on IR**.
- **C-side charging-up**: additional exponential-in-drift contribution near the central electrode, strongly visible below drift < 20 cm.

### 6.2 Systematic error + masking

The code (to port to O2) [slide 79]:

```cpp
// getSystematicIFC0: r-IFC exponential decay with hard mask inside minDist
float getSystematicIFC0(int sector, int row, int y, float z,
                         float err0=3, float slope=0.2,
                         float minDist=2, float maskError=5) {
   // ...computing cluster r from (sector, row, y, z)...
   float r_IFC = 83;                               // cm
   if (r - r_IFC < minDist) return maskError;      // mask very close to IFC
   float err = err0 * exp(-(r - r_IFC) * slope);   // exponential decay
   return err;
}
```

Default parameters: err0 = 3 cm, slope = 1/5 cm, minDist = 2 cm, maskError = 5 cm. **[VERIFY]** parameter tuning against the current pass validation.

## 7. Sector C1 & C2 — local distortion fluctuation

### 7.1 The anomaly

At IR above ~25 kHz, sectors C1 and C2 (C-side innermost two sectors) show DCA fluctuations 20× larger than other sectors in the IDC0 RMS — [slide 110]. Fluctuation is B-field dependent. At 38 kHz the fluctuation is ~½× the 50 kHz value, so dependence on IR is not linear near the onset.

### 7.2 Run 2 analog and the unknown source

In Run 2, a similar pattern had a known cause: **sticky wires** producing local line-charge sources. The distortion map → space-charge-density → line-charge model fit chain was documented [slides 112–115]. Positive feedback from electron collection on expanding channels produced long-timescale fluctuation.

In Run 3, the source is **NOT YET KNOWN** [slide 113 verbatim: "Run3 - ??? NOT KNOW YET ???"]. Mitigation is therefore masking + systematic error, not correction.

### 7.3 Mitigation code

Rate-dependent systematic error linear in rate, linear in Δφ from sector centre, exponential in radius:

```cpp
float getSystematicErrorC12(float lx, float ly, int sector=1, float lz=-1,
                              float rateEstimator=1,
                              float slopeRow=1/5., float errNorm=0.1) {
   if (sector != 1 && sector != 2) return 0;
   if (lz > 0) return 0;                               // C side only
   const float dEdge = M_PI / 18;
   float dy = (sector == 1) ?  0.5*(ly/lx)/dEdge + dEdge
                             : -0.5*(ly/lx)/dEdge + dEdge;
   float errC12 = rateEstimator * dy * exp(-(lx - 83.) * slopeRow);
   return errC12;
}
```

Later iteration replaces exponential-in-R by box-shape (rectangular) — fit of fluctuation showed rectangular decay was a better approximation [slide 128]. Box-version with `sysClusErrorC12Box` and `sysClusErrorC12Norm` parameters is the current state [slides 162, 164].

**Status:** sectors C1 and C2 remain **unsuitable for physics analysis** at 2024-10-31 per slide 110. Local distortion variations need to be mitigated in apass (subsequent reconstruction pass) before these sectors re-enter.

## 8. Composed correction and factorisation

This section is shared with [./MITPCTPC_IonDrift_20122023.md §5](./MITPCTPC_IonDrift_20122023.md); summary only here.

### 8.1 Five map classes

| Class | Spatial granularity | Temporal granularity | Use case |
|---|---|---|---|
| 3D nominal | coarse | coarse | rate-averaged bulk |
| 3D sector-average | finer | finer | sector-boundary gradients |
| 2D φ-symmetric | high | high | O-rings, drift strips, charging |
| 2D time-granular | per `(sector, tgl, mult)` | very high | fast fluctuations |
| IDC (ion discs) | per-disc | per-TF | ion-disc fluctuation (subject of IonDrift deck) |

### 8.2 Three composition regimes

```
  Linear addition      ΔΧ = Σ kᵢ ΔΧᵢ           (not valid in Run 3 — distortion too large)
  Taylor expansion     ΔΧ = ΔΧ_nom + Σ kᵢ ∂ΔΧ/∂ⱼ i + …   (Run 3 working regime)
  Local linearity      ΔΧ_L = Σ kᵢ ΔΧ_L,ᵢ      (enables cross-rate reuse of delta maps)
```

### 8.3 Option 1 vs Option 2 architectures

**Option 1 [slide 40]:** delta model added to underlying distortion model; local corrections composed linearly; integrate along trajectory at reconstruction.

**Option 2 [slide 41]:** analytical model for the process + underlying space charge; subtract space charge; use diff as additive global correction.

Code pipeline both options feed: [AliceO2 PR #12439](https://github.com/AliceO2Group/AliceO2/pull/12439#issuecomment-1853441547).

## 9. Track refit improvements — the TRD-like approach

### 9.1 Why cluster unfolding has a hard ceiling

Cluster shape is critically dependent on local track properties, but:
- In refit, no access to raw digits — cluster finder must have pre-baked the right unfolding for high-pT / small-angle tracks.
- Even with perfect track knowledge, cluster shape fluctuates too much for reliable unfolding.
- Unfolded clusters show **worse** resolution and larger systematic bias than isolated clusters.

### 9.2 The combined information approach (CHEP 2003 / CHEP 2006)

The route Run 1 used successfully at dN_ch/dy ~ 8000: combine **local cluster + global track + local track** information. Track is divided into N tracklets with well-defined local angle and resolution [Ivanov-CHEP2003-arXiv; Ivanov-CHEP2006 slides].

### 9.3 Robust tracklet fit with LTS + outlier rejection

From the 2005–2006 and 2019–2020 development [Ivanov-CHEP2006-slides]:
- One-parameter robust fit using **median or LTS (Least Trimmed Squares)** minimisation.
- LTS error estimation for the tracklet weight.
- **Delta-angle (tracklet − track)** used as scaling factor for Kalman weight, above a σ threshold in the outlier region.
- Tested on TRD in 2019–2020 but not promoted to Run 3 production.

**Proposal (slide 17, 73):** port to TPC refit. Would address residual resolution deterioration beyond what cluster-error parameterisation captures. **Status:** TBD (deck's own label).

## 10. Benchmark results

### 10.1 54-setting parameter scan at GSI

Source data: LHC23zzh.b5p production, runs 544116.38kHz (PbPb 38 kHz, golden) through 544126.50Hz (reference) — [slide 170 data-path table]. First 5 settings are apass3-like references; remaining 49 are scan parameters on cluster-error, dead-zone cut, C12 systematic, IFC systematic, covariance type, track sigma, seeding-error options.

**Key result [slide 172]:** for high-pT tracks (|pT| > 3 GeV):
- Occupancy-dependent DCA slope and angular-matching slope both reduced by **factor ~3** in the new-parameterisation settings vs old.
- Offset (DCA resolution at zero occupancy) reduced by 20–22% (§10.2).
- Occupancy slope is **rate-independent** — determined by cluster overlaps, not ion rate.

### 10.2 DCA resolution scan vs q/pT and rate

From the scan [slides 184–186]:
- 20–22% improvement in DCA resolution averaged over rate, with the new parameterisation.
- Improvement concentrated at |q/pT| ≲ 1 (high pT). At lower pT, MS dominates regardless.
- Occupancy dependence is **stronger** than rate dependence in the new error parameterisation.

### 10.3 pass3 → pass4_test strangeness invariant-mass gain

Cross-validated by Lucia Anna Tarasovicova + Romain Schotter on strangeness performance [slide 204, AOT meeting 2024]:
- Measurable invariant-mass resolution improvement at intermediate and high pT.
- Particle-yield refinement confirmed.
- Link: [https://indico.cern.ch/event/1422461/](https://indico.cern.ch/event/1422461/)

### 10.4 χ² flattening

TPC → ITS χ² matching becomes flat vs occupancy with the new settings, vs steeply rising in the reference [slide 154, 158]. This is the diagnostic signal that the error parameterisation is now capturing the occupancy dependence rather than externalising it to systematic χ² drift.

## 11. Mitigation roadmap — what to do and what not to do

### Recommended actions (from slide 20, 196)

- **Consult with experts.** Apply maximum-information principles.
- **Use analytical tools.** Analytical formulas + RootInteractive for functional composition.
- **Emphasise statistics.** Group-by statistics in small bins, then decompose bias vs fluctuation (slide 50).
- **Route occupancy-correction through data-driven methods.** Efficiency corrections vs occupancy collapse pT spectra across rates to a single curve [slide 193 — Igor, Evgeny, Marian].

### Practices to avoid

- **Ignoring Run 1 / Run 2 lessons.** The pass2 lesson (Q, dEdx, rate dependence in error formula) is the obvious Run 3 template; skipping it cost 1–2 years.
- **Substituting hard statistical evidence with compelling narratives.** Verbatim from slide 20.

### Priority actions (from slide 80 "TODO")

| Action | Owner | Target |
|---|---|---|
| Rate-dependent systematic track error | Marian + Ruben | PbPb Feb 2024 (delivered in scan) |
| Cluster error occupancy dependence | David (moving-avg histogramming), Matthias + Marian (testing) | Feb 2024 (delivered Aug 2023 / May 2024) |
| IFC + charging + edge combined formula | Marian (fit), David + Ruben (port), Matthias + Marian (scan) | Feb 2024 (in progress) |
| TRD-like robust TPC refit | TBD | future phase |

## 12. Role in the dissertation

This deck is the umbrella document for Chapter(s) on **Run 3 TPC calibration and tracking performance** in [Ivanov-Overleaf-Thesis]. Sub-deliverables traceable to this material:

1. **Cluster-error parameterisation** (§3) — implementation + parameter determination, §§ of thesis.
2. **Composed correction factorisation** (§8) — derivation and deployment strategy, §§ of thesis; IonDrift sub-thread in [./MITPCTPC_IonDrift_20122023.md](./MITPCTPC_IonDrift_20122023.md).
3. **Sector edge calibration** (§5) — Run 1 virtual-charge methodology retrofitted to Run 3; CHEP 2003 methodological continuity.
4. **Systematic error treatment** (§§5–7) — the IFC + C1&2 + charging + sector-edge combined-formula approach.
5. **54-setting scan campaign** (§10) — validation evidence for the methodology.

The same-meeting companion [Companion-Same-Meeting] covers the **combined tracking + PID mitigation** layer on top of this work.

---

## 13. References — organised for citation

This section is the operational deliverable of this wiki page. Each entry is cited in the deck; the JIRA-path references are the working code corresponding to the slide claim.

### 13.1 Peer-reviewed and preprint articles (the "3 TPC + 1 TRD articles" of the deck's own framing)

| Ref | Citation | Role in deck |
|---|---|---|
| **A1** | Ivanov, M., *Cluster Finder Performance Using Weight Fluctuation Theory*, CHEP 2003 preprint — [arXiv:physics/0306108](https://arxiv.org/pdf/physics/0306108.pdf). | **TPC theoretical base.** Cited ≥ 6× in deck. §§ 2.1 diffusion term, 2.2 angular term, 3 combined formula, 4 combined with Q/dEdx. |
| **A2** | J. Alme et al., *The ALICE TPC, a large 3-dimensional tracking device with fast readout for ultra-high multiplicity events*, [Nucl. Instrum. Meth. A **622** (2010) 316](https://www.sciencedirect.com/science/article/pii/S0168900210008910). | **TPC Run 1 / Run 2 analytical parameterisation** (MWPC era, low IR). The reference parameterisation pre-Run-3. |
| **A3** | ALICE Collaboration, *Run 1 / Run 2 pass2 tracking fix*, [Particles **5** (2022) 8](https://www.mdpi.com/2571-712X/5/1/8). | **TPC pass2 retrofit.** Documents the addition of Q, dEdx, and rate dependence to the cluster-error formula — this is the Run-1/2 lesson Run 3 is replaying. |
| **A4** | Ivanov, M. et al., *TPC laser calibration / common-mode coupling correction*, 2023 — [arXiv:2304.03881](https://arxiv.org/pdf/2304.03881.pdf). | **TRD/TPC related.** Laser validation of common-mode capacitive-coupling correction; referenced for CRU-firmware status (pseudo-code lines 32–33 partially implemented). |

> **Self-citation note (deck slide 2):** *"Insights from (my) 3 TPC and 1 TRD articles on analytical tracking formulations for high interaction rate (IR) data."* The most likely mapping to the deck author's own publications: **A1 (CHEP 2003 theory), A2 (NIM A 2010 Alme et al., ALICE-collaboration paper co-authored), A3 (pass2 MDPI paper), plus a TRD paper — candidate: [Ivanov-CHEP2006 proceedings P1, §13.2] or a separate TRD NIM paper.** Verify with the author which specific 4 papers are intended before citing in tomorrow's talk.

### 13.2 Conference proceedings and presentations

| Ref | Citation |
|---|---|
| **P1** | Ivanov, M., *TPC tracking and particle identification in high-density environment*, CHEP 2003, SLAC, eConf C0303241 — [InspireHEP 621229](https://inspirehep.net/literature/621229), [SLAC presentation PPT](http://www.slac.stanford.edu/econf/C0303241/proc/pres/269.PPT), [conference page](https://www-conf.slac.stanford.edu/chep03/). Source for the 1D → 2D nearest-neighbour derivation (§4.2). |
| **P2** | Ivanov, M., *TRD tracking (tracklet-based)*, CHEP 2006 — [slides](https://indico.cern.ch/event/408139/contributions/979783/attachments/815693/1117683/394_slides_ivanov_CHEP06.ppt), [proceedings PDF](https://indico.cern.ch/event/408139/contributions/979783/attachments/815694/1117684/MarianIvanovchep06.pdf). Deck notes this is "mostly TRD tracking (updated algorithm discussed within btg group, not yet documented)". Base for §9 robust tracklet refit. |

### 13.3 Technical documents and thesis

| Ref | Citation |
|---|---|
| **T1** | Ivanov, M., *PhD thesis — public note*, Overleaf — [https://www.overleaf.com/project/642845e49aeb65eb8a4c23aa](https://www.overleaf.com/project/642845e49aeb65eb8a4c23aa). The umbrella. |
| **T2** | PDG Review, *Particle detectors at accelerators*, 2019 — [pdg.lbl.gov/2019/reviews](https://pdg.lbl.gov/2019/reviews/rpp2019-rev-particle-detectors-accel.pdf). Reference for combined/corrected dEdx per region (§ slide 196). |

### 13.4 Other Google Slides / docs referenced

| Ref | Citation |
|---|---|
| **S1** | Ivanov, M., *Systematic bias and fluctuation studies*, Google Slides — [slides](https://docs.google.com/presentation/d/1CbL0PQZkDPZ_YRL9t4PlASfuXvcpcVALm7TDZErjRXA/edit#slide=id.g2ad27518780_0_6). Companion to this deck for systematic-bias treatment. |
| **S2** | Indico interactive dashboard — [combined resolution dashboard HTML](https://indico.cern.ch/event/1358443/contributions/5719632/attachments/2774587/4835781/dashboard_CombResol.html). |
| **S3** | Same-meeting companion — [*Tracking in high-density environment*](https://indico.cern.ch/event/1463360/#283-tracking-in-high-density-e). |

### 13.5 CERN Indico meetings (chronological)

| Date | Event | Link |
|---|---|---|
| 2017-04-06 | Technical board — analytical distortion model | [event 605126, contribution 2538484](https://indico.cern.ch/event/605126/contributions/2538484/attachments/1441002/2218550/DistortionAnalitycalModelsForTB_06042017_v2.pdf) |
| 2020 Offline week | Theoretical — space-point distortion decomposition (ATO-490) | [event 888263, contribution 3784229](https://indico.cern.ch/event/888263/contributions/3784229/attachments/2006136/3352668/ATO-490-DataDrivenCorrection_1903.pdf) |
| 2020-10-08 | RD51 / New Horizons TPC workshop — fluctuation & time series | [event 889369, contribution 4011353](https://indico.cern.ch/event/889369/contributions/4011353/attachments/2118297/3566420/RD51_MarianIvanov_08102020_v3.pdf) |
| 2022-05-10 | 5th ALICE ML workshop — ATO-490 / ATO-589 Data-Driven SC Correction | [event 1078970](https://indico.cern.ch/event/1078970/contributions/4833313/attachments/2442800/4185177/ATO-490-ATO-589-DataDrivenSCCorrection_5thML_10052022_v3.pdf) |
| 2023-02-08 | TPC meeting — afterglow / neutron interaction | [event 1243741](https://indico.cern.ch/event/1243741/contributions/5263100/attachments/2589842/4468888/TPC_Meeting_08022023.pdf) |
| 2023-02-09 | Cluster error details (treestream usage in sim) | [event 1270050](https://indico.cern.ch/event/1270050/#21-usage-of-treestreams-in-sim) |
| 2023-12 | Combined-resolution dashboard + Jupyter notebook | [event 1358443, contribution 5719632](https://indico.cern.ch/event/1358443/contributions/5719632/) ; [JupyterNotebook preview](https://indico.cern.ch/event/1358443/#preview:4835782) |
| 2024-02 | Update for the calibration (V-shape DCA fit) | [event 1365933](https://indico.cern.ch/event/1365933/#12-update-for-the-calibration) |
| 2024-07 | ALICE week — Run 3 reco overview | [event 1425523](https://indico.cern.ch/event/1425523/#390-overview-of-the-run-3-reco) |
| 2024 | Updates on strangeness performance apass3 vs apass4 PbPb 2023 (Tarasovicova, Schotter) | [event 1422461](https://indico.cern.ch/event/1422461/) |
| 2024-10-31 | **This deck / same-meeting companion** | [event 1463360](https://indico.cern.ch/event/1463360/#283-tracking-in-high-density-e) |

### 13.6 Code repositories

| Repo / file | URL |
|---|---|
| alice-tpc-notes / ATO-615 track-performance draw | [gitlab.cern.ch/../ATO-615/trackinPerformanceDraw.C#L24](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/f3e25430bba2252ce12e5b8fc5dc81c31ff1ee53/JIRA/ATO-615/trackinPerformanceDraw.C#L24) |
| alice-tpc-notes / ATO-628 combined-tracking performance bias | [gitlab.cern.ch/../ATO-628/trackingPerformanceBias.ipynb](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/054559678f24d65f80d54b0a172cc3171a8dc257/JIRA/ATO-628/trackingPerformanceBias.ipynb) |
| alice-tpc-notes / ATO-630 ErrParam — early snapshot | [gitlab.cern.ch/../ATO-630/ATO-630_ErrParam.C (769d5ce)](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/769d5ce72145f3315edce0e0ba5d145ea1a7710b/JIRA/ATO-630/ATO-630_ErrParam.C) |
| alice-tpc-notes / ATO-630 ErrParam — May 2024 version | [gitlab.cern.ch/../ATO-630/ATO-630_ErrParam.C (22bd075, L9-28)](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/22bd07586bed2e118fcb5ffd6586149e5de9d113/JIRA/ATO-630/ATO-630_ErrParam.C#L9-28) |
| alice-tpc-notes / ATO-630 IFC systematic code | [gitlab.cern.ch/../ATO-630/ATO-630_ErrParam.C#L132-151 (deba989)](https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/deba9893e9e667e9d16f1d9868c40f6de945b7a8/JIRA/ATO-630/ATO-630_ErrParam.C#L132-151) |
| AliceO2 — TrackParametrizationWithError | [github.com/AliceO2Group/AliceO2/../TrackParametrizationWithError.cxx#L1068-L1070](https://github.com/AliceO2Group/AliceO2/blob/88d397aa63ac60da2fbc65503a6c548b86b7f599/DataFormats/Reconstruction/src/TrackParametrizationWithError.cxx#L1068-L1070) |
| AliceO2 — GPUParam.inc C12 error | [github.com/AliceO2Group/AliceO2/../GPUParam.inc#L108](https://github.com/AliceO2Group/AliceO2/blob/b316ab5ac48a27eaca45cd556e1d983d8df22f0b/GPU/GPUTracking/Base/GPUParam.inc#L108) |
| AliceO2 PR #12439 — composed correction | [github.com/AliceO2Group/AliceO2/pull/12439#issuecomment-1853441547](https://github.com/AliceO2Group/AliceO2/pull/12439#issuecomment-1853441547) |
| AliceO2 PR #12928 — constrained track parameters | [github.com/AliceO2Group/AliceO2/pull/12928](https://github.com/AliceO2Group/AliceO2/pull/12928) |
| AliRoot — AliTPCCorrection (Run 1 legacy) | [github.com/alisw/AliRoot/../AliTPCCorrection.cxx#L1820-L1837](https://github.com/alisw/AliRoot/blob/master/TPC/TPCbase/AliTPCCorrection.cxx#L1820-L1837) |
| RANSAC (scikit-learn) | [scikit-learn.org/../plot_ransac.html](https://scikit-learn.org/stable/auto_examples/linear_model/plot_ransac.html) |
| RANSAC (Wikipedia) | [en.wikipedia.org/wiki/Random_sample_consensus](https://en.wikipedia.org/wiki/Random_sample_consensus) |

### 13.7 JIRA tickets referenced

| Ticket | Scope in deck |
|---|---|
| **ATO-615** | TPC track covariance / performance plotting |
| **ATO-628** | Combined-tracking dashboard (pt + rate + occupancy resolution model) |
| **ATO-630** | **Primary ticket.** Systematic error + cluster-error parameterisation. This is the deck's tracker. |
| **ATO-650** | Parameter-scan production at GSI (54 settings) |
| **ATO-490 / ATO-589** | Data-driven SC correction (2022 ML workshop; 2020 offline week) |
| **O2-4592** | Source data set for TPC→ITS chi2 factorisation (apass2 PbPb) |

### 13.8 BibTeX stubs

```bibtex
@misc{Ivanov-CHEP2003-arXiv,
  author = {Ivanov, M.},
  title  = {{Cluster finder performance using weight fluctuation theory}},
  year   = {2003},
  eprint = {physics/0306108},
  archivePrefix = {arXiv},
  url    = {https://arxiv.org/pdf/physics/0306108.pdf}
}

@article{Alme-ALICE-TPC-2010,
  author  = {Alme, J. and others},
  title   = {{The ALICE TPC, a large 3-dimensional tracking device with fast readout for ultra-high multiplicity events}},
  journal = {Nucl. Instrum. Meth. A},
  volume  = {622},
  pages   = {316--367},
  year    = {2010},
  doi     = {10.1016/j.nima.2010.04.042}
}

@article{ALICE-TPC-pass2-MDPI,
  title   = {{Run 1 / Run 2 pass2 tracking fix}},
  journal = {Particles},
  volume  = {5},
  number  = {1},
  pages   = {8},
  year    = {2022},
  url     = {https://www.mdpi.com/2571-712X/5/1/8}
}

@misc{Ivanov-Laser-2023,
  author = {Ivanov, M. and others},
  title  = {{TPC common-mode capacitive-coupling correction (laser)}},
  year   = {2023},
  eprint = {2304.03881},
  archivePrefix = {arXiv},
  url    = {https://arxiv.org/pdf/2304.03881.pdf}
}

@inproceedings{Ivanov-CHEP2003-proceedings,
  author = {Ivanov, M.},
  title  = {{TPC tracking and particle identification in high-density environment}},
  booktitle = {CHEP 2003, SLAC},
  year   = {2003},
  note   = {eConf C0303241},
  url    = {https://inspirehep.net/literature/621229}
}

@misc{Ivanov-CHEP2006-TRD,
  author = {Ivanov, M.},
  title  = {{TRD tracking — tracklet-based refit (CHEP 2006)}},
  year   = {2006},
  url    = {https://indico.cern.ch/event/408139/contributions/979783/}
}

@misc{PDG-2019-Detectors,
  title = {{Particle Detectors at Accelerators}},
  note  = {{Particle Data Group Review 2019}},
  year  = {2019},
  url   = {https://pdg.lbl.gov/2019/reviews/rpp2019-rev-particle-detectors-accel.pdf}
}
```

---

## 14. Glossary (working terms beyond those in IonDrift)

| Term | Definition |
|---|---|
| **ATO-630** | Primary JIRA ticket for systematic-error + cluster-error parameterisation programme |
| **apass / cpass / pass** | ALICE reconstruction passes: `cpassN` calibration passes, `apassN` analysis passes; numbering increments across major reco revisions |
| **IDC** | Integrated Digital Current — continuously-readout aggregate current input for space-charge correction; see [../TDR/tpc.md §7.3](../TDR/tpc.md) |
| **IFC** | Inner Field Cage — inner radial boundary of TPC drift volume at r ≈ 83 cm |
| **OFC** | Outer Field Cage — outer radial boundary at r ≈ 250 cm |
| **ROC** | Read-Out Chamber — the GEM-equipped chamber at z = ±250 cm |
| **C1 / C2** | C-side sectors 1 and 2, the anomalously-fluctuating sectors |
| **kHz (in data paths)** | File-path convention: `544116.38kHz` means run 544116 at effective 38 kHz IR |
| **tgl** | Tangent of dip angle = pz / pT |
| **snp** | sin(φ) — track azimuth sine; local-X-Y component |
| **MAE** | Mean Absolute Error — robust resolution estimator; factor ~1.2 under STD for Gaussian, more robust against tails |
| **LTS** | Least Trimmed Squares — robust fitter rejecting worst-fit fraction of points |
| **RANSAC** | Random sample consensus — robust regressor inlier/outlier split |
| **Fe-55 peak width** | Iron-55 X-ray reference used to measure σ_GG / ⟨GG⟩ experimentally |
| **Virtual charge** | Charge added at pad edge in reconstruction to emulate the pad-response-function tail truncated by the dead zone (Run 1 method; see slide 87) |
| **trackQA table** | AO2D auxiliary table with per-region dEdx, TPC time, tracklet-bytemask; currently sampled at 10% |
| **RootInteractive** | Interactive dashboard framework (indico 1358443) used for occupancy/rate scan visualisation |
| **o15 / o15x / o15xaq** | Derived variables: o15 = cluster-count in nearest-time bin of 31; o15x = o15 / lx; o15xaq = o15x × ⟨Q⟩² |
| **CPass8 / pass4_test** | Specific reconstruction-pass labels used as scan references |

## 15. Open items and reviewer-validation checklist

### 15.1 `[VERIFY]` flags — from front-matter, restated

1. σ_angle / σ_drift / σ_rate / σ_0 parameters (§3.2) against current commit.
2. Cluster-overlap independence-approximation formula (§4.1) against non-independent calculation.
3. Nearest-distance 15 000 clusters/row scaling (§4.2) at different rates.
4. Virtual-charge factor 2.8 derivation (§5.3).
5. IFC err0=3, slope=1/5, minDist=2, maskError=5 parameter tuning (§6.2).
6. C1&C2 fluctuation onset ~25 kHz, B-field dependence (§7.1) against 2024 data.
7. ωτ ≈ 0.33 from Run 1 laser (§8 — "never published" per slide 27) — provenance.
8. Factor-3 occupancy-slope reduction (§10.1) — 54-setting scan output as evidence.
9. Indico URLs with fragment anchors (§13.5) — long-term stability.

### 15.2 Additional open items

- **Deck self-citation "3 TPC + 1 TRD articles"** — explicit identification of the four papers is needed for tomorrow's talk. Working hypothesis in §13.1 footnote; verify with Marian before referencing.
- **ATO-630_ErrParam.C commit drift.** The three gitlab.cern.ch links span three different commit hashes (`769d5ce7`, `22bd0758`, `deba9893`). Consolidate to the current master or tag the one the deck's numbers correspond to.
- **Figure extraction deferred.** The 40 MB deck contains substantial plots (DCA-vs-occupancy scatters, 54-setting scan heatmaps, RootInteractive dashboards). Text-only extraction captures formulas and conclusions; figures are linked via Indico or derivable by opening the deck.

### 15.3 Reviewer checklist

- [ ] Verify the four self-cited articles against Marian's publication list.
- [ ] Reproduce the factor-3 occupancy-slope-reduction claim on a randomly chosen LHC23zzh run.
- [ ] Verify §3.2 fit parameters against latest ATO-630_ErrParam.C commit.
- [ ] Confirm §7.1 C1&C2 onset rate on the 2024 data.
- [ ] Check cross-links to IonDrift deck (§5.1 factorisation) and tpc.md (§2, §7).
- [ ] Run ` `[VERIFY]` `items 1–9 (§15.1).

## 16. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`../TDR/tpc.md`](../TDR/tpc.md) | §§1, 2.2, 6 (IFC physics), 7 (space-charge baseline), 8 (composed correction context) | live (DRAFT wiki-v2) |
| [`../TDR/its.md`](../TDR/its.md) | §5 (ITS+TPC high-precision track for edge calibration) | live (DRAFT wiki-v1) |
| [`../TDR/trd.md`](../TDR/trd.md) | §9 (CHEP 2006 TRD tracklet methodology inheritance) | live (DRAFT wiki-v0; source PARTIAL turn 1/2) |
| [`./MITPCTPC_IonDrift_20122023.md`](./MITPCTPC_IonDrift_20122023.md) | §8 (factorisation), §2 (Run 3 context) — IonDrift deck is a subset of this programme | live (DRAFT wiki-v0) |
| [`./PWGPP-643_combined_shape_estimator.md`](./PWGPP-643_combined_shape_estimator.md) | (anticipated — combined shape estimator likely uses cluster-error output from §3) | planned (draft exists) |
| [`./O2-5095_TPC_dEdx_index.md`](./O2-5095_TPC_dEdx_index.md) | §§3.2, 10 (per-region dEdx and error parameterization interact) | planned (draft exists) |
| [`./O2-4592.md`](./O2-4592.md) | §10 (TPC→ITS χ² factorisation) | live (DRAFT) |

Status values: `planned` / `live` / `broken` per the standard convention.

## Appendix A: Source-to-section map (selected)

| Slide(s) | Section |
|---|---|
| 2 | §1 scope and the "3 TPC + 1 TRD articles" self-citation |
| 4–6 | §3 cluster-error formulas (Run 1/2 → Run 3) |
| 7 | §10 occupancy-aware impact summary |
| 9 | §4.1 cluster-overlap probability |
| 10, 125 | §4.2 nearest-neighbour 2D formula |
| 11 | §2.3 shared-cluster bugs |
| 12, 120–122 | §4.3 MAE fit variants |
| 13, 123 | §4.4 MC occupancy fit |
| 14, 65–66 | §10 combined ITS+TPC resolution model |
| 17, 73–74 | §9 CHEP 2006 tracklet refit |
| 20 | §11 "what to do / what not to do" + same-meeting companion pointer |
| 23–26 | §8 non-parametric fit + dEdx correction linearisation (Taylor) |
| 27–28 | §8.2 Huber / RANSAC ωτ ≈ 0.33 |
| 29–34, 60–62 | §6 IFC maps + oscillation |
| 40–41 | §8.3 composition option 1 / option 2 |
| 42 | §5.4 template DCA fit via parabolic Kalman |
| 46, 136 | §2.3 TPC intrinsic resolution targets |
| 47, 137 | §2.3 stochastic vs systematic error taxonomy |
| 50–51 | §10 local group-by statistics + DCA decomposition |
| 53 | §2.3 track systematic error numerical defaults |
| 54 | §3 additive cluster error status |
| 79 | §6.2 IFC code (getSystematicIFC0) |
| 80, 128 | §11 TODO table |
| 86–87, 101–104 | §5 edge bias + virtual charge |
| 107–109 | §5.3 dead-zone cut scan |
| 110–117 | §7 C1&C2 fluctuation |
| 116 | §7.3 C1&2 systematic error code |
| 135 | §2.2 Run 2 → Run 3 √2 degradation |
| 170 | §10.1 54-setting scan data paths |
| 172 | §10.1 scan outcome: factor-~3 slope reduction |
| 184–188 | §10.2 scan resolution plots |
| 189–194 | §10 data-driven efficiency correction (trackQA) |
| 196 | §11 optimal PID strategy |
| 198 | §15 cluster-outside-acceptance bug |
| 204 | §10.3 strangeness performance pass3 → pass4_test |

## Appendix B: Notation

| Symbol | Meaning |
|---|---|
| σ_GG | Standard deviation of gas gain |
| ⟨GG⟩ | Mean gas gain |
| kMS | Multiple-scattering coefficient (0.1 at inner wall, 3 at vertex) |
| ωτ | Cyclotron-frequency × momentum-transfer-time product; Run 1 laser ≈ 0.33 |
| Δdeadzone | Width of the non-instrumented region at sector boundary |
| Δsigma_Y | Difference between measured and expected cluster width |
| o15 / o15x | See glossary §14 |
| paramErrY / paramErrZ | Fit parameter vectors in the `getResolutionScaled` formulas |
| σ_errmask | Hard-masked cluster-error value (IFC / dead-zone) |

## Changelog

- **2026-04-19 — wiki-v0 (cycle 0), Claude5 as indexer.** Initial distillation of the 2024-10-31 ATO-630 offline-week deck (with full Jan 2023 → Oct 2024 lineage). Focus on comprehensive reference capture (§13) per architect's explicit ask for tomorrow's presentation. Text extraction only; deck figures not reproduced. 9 `[VERIFY]` flags in front-matter `known_verify_flags` and §15. Cross-links to [../TDR/tpc.md](../TDR/tpc.md), [./MITPCTPC_IonDrift_20122023.md](./MITPCTPC_IonDrift_20122023.md), [../TDR/its.md](../TDR/its.md), [../TDR/trd.md](../TDR/trd.md) use ratified `TDR/` folder name per TS v0.3 §2. Schema follows provisional §5 of Technical_SUMMARY_MIWikiAI v0.3.

---

*Compiled by Claude5 (Claude Opus 4.7) on 2026-04-19 as wiki-v0 DRAFT. Working-deck index — claims reflect 2024-10-31 state. Deck is large (40 MB, ~207 slides, heavy duplication); synthesis is thematic, not slide-by-slide. For the slide-by-slide index, see Appendix A selected-slide map; full slide list available via Drive. For ion-disc-fluctuation subset specifically, see [./MITPCTPC_IonDrift_20122023.md](./MITPCTPC_IonDrift_20122023.md).*

*No quota issues observed during authoring.*
