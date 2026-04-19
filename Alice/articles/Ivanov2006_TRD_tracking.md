---
wiki_id: Belikov2006_TRD_tracking
title: "Belikov et al. (CHEP'06) — Track Reconstruction in High-Density Environment"
project: MIWikiAI / ALICE
folder: articles
source_type: article-proceedings
source_title: "Belikov, Hristov, Ivanov, Safarik — Track reconstruction in high density environment"
source_fingerprint:
  upstream:
    - id: Belikov2006chep
      authors: ["I. Belikov", "P. Hristov", "M. Ivanov", "K. Safarik"]
      venue: "CHEP'06 — Computing in High Energy Physics, Mumbai, India, 2006"
      contribution_url: "https://indico.cern.ch/event/408139/contributions/979783/"
      pdf_url: "https://indico.cern.ch/event/408139/contributions/979783/attachments/815694/1117684/MarianIvanovchep06.pdf"
      pdf_fingerprint: "MarianIvanovchep06.pdf, ~4 pp (fetched 2026-04-19; OCR noise on math symbols and some numbers)"
      sections_cited: ["TRD — General description", "TRD Tracking", "Local reconstruction", "TRD stand-alone tracking", "Tracklet Search", "Precision of local tracklet reconstruction", "Conclusion"]
    - id: TRD-TDR
      cross_ref: "Referenced as [2] — see ../detectors/trd.md"
      cds: "https://cds.cern.ch/record/519145"
    - id: Fruhwirth1987
      title: "Fruhwirth R 1987 Nucl. Instrum. Methods A 262 444 (Kalman filter for track fitting)"
      cross_ref: "Referenced as [3]"
    - id: Mankel1997
      title: "Mankel R 1997 Nucl. Instrum. Methods A 395 169 (Combinatorial Kalman filter)"
      cross_ref: "Referenced as [5]"
  summary_version: "wiki-v0 (first indexation pass from article)"
source_status: "COMPLETE — full article fetched; numeric values partially OCR-garbled; structural content complete"
source_last_verified: 2026-04-19
author: Marian Ivanov (dissertation lead; also co-author of this paper); indexed with AI assistance
indexed_by: Claude2
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 0
peer_reviewers: []
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags:
  - "§1 Lorentz-factor threshold for TR emission — numeric value OCR-garbled"
  - "§1 Six-layer radiation thickness — numeric value OCR-garbled (TRD-TDR gives 14.3% X₀)"
  - "§1 Xe/CO₂ ratio — OCR shows 'Xe, CO(15%)' — TRD-TDR gives 85/15"
  - "§3 Drift velocity units — OCR shows 'cm/s', physically must be cm/μs (~1.5)"
  - "§3 Unisochronity maximum z_3 — OCR shows 6.7 cm which exceeds the 3.0 cm drift region; likely 0.67 cm (wire-pitch unit) or similar"
  - "§3 Signal unfolding precision — OCR shows '2 mm resp. 0.4 mm'; consistent with the inferred direction but verify"
  - "§5 Formula 16 ratio L_drift/L_pad ≈ 0.3 and tan(α_z) threshold '3' — dimensionally unclear in OCR"
  - "§5 Tracklet-resolution vs track-extrapolation claim '2× worse' — confirm against paper"
  - "§6 Formulas 17–20 — mathematical symbols heavily OCR-garbled; structural content captured but exact form needs PDF check"
  - "§7 Density context 'N≈5000' — assumed dN/dy ≈ 5000 per TRD-TDR design multiplicity envelope (8000); confirm from paper"
---

# Belikov et al. (CHEP'06) — Track Reconstruction in High-Density Environment

## TL;DR

Four-page CHEP'06 proceedings paper by I. Belikov, P. Hristov, **M. Ivanov** (dissertation lead), and K. Safarik, describing the extension of the ALICE barrel Kalman-filter tracking to the **Transition Radiation Detector (TRD)** and the standalone fast **Riemann-sphere** fit. The paper is one of the foundational methods references for TRD reconstruction as implemented in AliRoot [Belikov2006chep §Abstract]. Three algorithmic contributions are developed:

1. **Tracklet search** — a two-stage reduction of the per-chamber cluster-association combinatorics from naive O(N^layers) down to manageable size via TRD-specific geometric constraints (pad-row crossing probability, unisochronity x-shift, z-rectangular error) [§Tracklet Search].
2. **Iterative and projection (LTS-style) tracklet algorithms** — two robust alternatives to Combinatorial Kalman, avoiding its CPU blowup [§Tracklet Search].
3. **Effective tracklet-uncertainty parameterization** — a formula combining angular effect, unisochronity-limited floor, and local intrinsic resolution, rather than a cluster-width-scaled estimate that biases low and high-momentum tracks in opposite directions [§Precision].

**Headline results** [§Conclusion]:
- TRD inclusion improves barrel `p_T` resolution by **~40 %** vs no-TRD setup (PPR Vol. II baseline).
- Fake-track ratio in TRD reduced from **10 % → ~5 %** using the projection algorithm vs plain Kalman without combinatorial filter, without significant CPU increase.

**Role in the dissertation.** This paper is the **algorithmic ancestor** of the current AliRoot/O² TRD tracking stack used in the [TPC space-charge calibration](../detectors/tpc.md) residual-distortion step (ITS–TRD interpolation across the TPC, see [TPC §7.2 step 4](../detectors/tpc.md)). The tracklet-uncertainty parameterization (§6 below, formulas 17–20 of the paper) remains the conceptual basis for how TRD tracklet errors propagate into the Kalman track fit, which in turn sets the weight of TRD space-points in the residual-distortion reference. TRD alignment and timing quality — themselves byproducts of the same tracklet algorithm — propagate directly into TPC distortion-map quality.

---

## 1. Scope and detector context

The paper addresses **track reconstruction in the ALICE TRD under high-density conditions** [§Abstract]. The TRD geometry used in the paper (540 chambers in 6 layers surrounding the TPC, ~7 m total length, ~750 m² sensitive area, largest chamber 159 × 120 cm², 13 cm module thickness) [§TRD General Description] is consistent with TRD-TDR parameters — see [TRD-SoT §1 and §3.1](../detectors/trd.md) for the canonical distillation of the same figures from the TDR. The paper's intro effectively paraphrases TRD-TDR Table 1.1.

**OCR-affected values in this section, deferred to §10.1:**
- Six-layer anticipated radiation thickness ("about 	") — OCR lost the value. TRD-TDR gives **14.3 % X₀** [TRD-SoT §3.4], which is what the paper almost certainly quotes.
- Gas mixture — OCR shows "Xe, CO(15 %)"; TRD-TDR canonical is **Xe/CO₂ (85/15)** [TRD-SoT §3.2].
- TR-emission Lorentz-factor threshold "corresponds to a Lorentz factor of  ." — value OCR-garbled. TR physics onset is γ ≳ 1000 for typical radiator materials; TRD-TDR design point is γ ≈ 2000 for 1 GeV/c electrons [TRD-SoT §2.1].

**Anode/cathode geometry** [§TRD General Description]:
- Drift region: **3 cm**.
- Amplification region: **0.7 cm**.
- Cathode wire grid: **0.25 cm** wire pitch, **75 μm** wire diameter.
- Anode wires: **0.5 cm** pitch, **20 μm** diameter.
- Cathode pad widths: **0.664–0.818 cm** (φ direction), pad lengths **7.5–9 cm** (z direction) [§footnote 1].
- Total channels: **~1.18 × 10⁶** readout pads — consistent with TRD-TDR canonical **1.16 × 10⁶** quoted in [TRD-SoT §3.3] (paper rounds up; TDR Table 1.1 is the authoritative figure).
- Max drift time: **~2 μs**, sampled at **10 MHz** on all channels [§TRD General Description; refs 7, 8].

---

## 2. Tracking context and main challenges

Three challenges identified for TRD tracking [§TRD Tracking]:

1. **Material budget.** ~**35 %** of tracks are absorbed within the TRD volume; mean energy loss of surviving tracks is ~**15 %** of particle energy [§TRD Tracking].
2. **High cluster density.** In the expected high-density environment, clusters from different tracks overlap. On the propagation road defined by track-position uncertainty there are, on average, **~1.5 clusters per layer** at multiplicity N ≈ 5000 [§TRD Tracking]. `[VERIFY: paper quotes "N≈5000"; almost certainly dN/dy ≈ 5000 per TRD-TDR design envelope of 8000]`
3. **Material-query cost.** ROOT Geometrical Modeler [ref 9] query time ~**15 μs** per local material-density / radiation-length / density² query [§TRD Tracking].

**Two algorithmic responses to the material-query cost** [§TRD Tracking]:

- **Option A:** Propagate track up to next material boundary defined by the modeler; get local material parameters; propagate with current parameters. Accurate but one boundary query per material change.
- **Option B:** Calculate mean parameters between tracklet start and end points (density, density × z², radiation length). **~1 track propagation per tracklet**; additionally reusable for close parallel track hypotheses.

**Design choice:** Option B was adopted as the primary method [§TRD Tracking].

**Why not Combinatorial Kalman [ref 5].** The authors note that the standard Kalman filter is insufficient in high-density environments, and that Combinatorial Kalman [Mankel 1997] would give significantly better results — but was rejected due to combinatorics blowup and consequent CPU requirements. The tracklet-search approach (§5 below) is the deliberate alternative.

---

## 3. Local reconstruction

The TRD is a **three-dimensional detector** [§Local Reconstruction]. The three coordinates are reconstructed differently:

### 3.1 x-coordinate (drift direction)

From the drift time (time bin). Linear approximation [§Local Reconstruction, eq. 1]:

```
x(t) = v_d_mean × (t_drift − t_0)
```

with `v_d_mean` ≈ **1.5 cm/μs** (drift region) `[OCR-GARBLED — paper OCR showed "cm/s", physically must be cm/μs per TRD-SoT §3.2]`. The drift velocity is nearly constant across a large fraction of the drift region, rising in the amplification region.

**Unisochronity effect.** The drift time depends on the distance to the anode wire `z_3`. Electrons drifting at maximal `z_3` `[OCR-GARBLED — value unclear; paper shows "6.7 cm" but drift region is only 3 cm]` have a longer drift path, and cross the low-field region between two anode wires. This produces a drift-time offset of **~120 ns** for electrons originating from the drift cathode versus electrons drifting a shorter path [§Local Reconstruction].
<!-- unisochronity: 120 ns offset = 120 ns × 1.5 cm/μs = 0.18 cm = 1.8 mm effective x-shift if propagated through naive v_d_mean; this is the key systematic this paper's tracklet search has to handle -->

### 3.2 y-coordinate (bending plane — the critical resolution)

The y-coordinate is **the most crucial** because it defines the transverse-momentum resolution of the TRD [§Local Reconstruction]. Three options evaluated:

| Method | Speed | Precision | Chosen? |
|---|---|---|---|
| **Centre-of-gravity (COG)** | Fast | Non-linear bias in PRF wings | No |
| **Lookup table** (mean y as function of amplitudes in 3 adjacent pads) | Fast (same order as COG) | Better than Mathieson fit | **Yes** |
| **Mathieson function fit** | Slow | Baseline | No |

The **Pad Response Function (PRF)** shape depends on the track inclination angle; the lookup table was optimized for **high-momentum, small-inclination** tracks [§Local Reconstruction].

### 3.3 z-coordinate (parallel to magnetic field)

Resolution limited by pad size (PRF width in z direction is negligible compared to pad length). A **tilted-pad design** is employed to increase tracking capability in z [§Local Reconstruction] — the formulation enters the Riemann fit directly, see §4 below.

### 3.4 Tail cancellation and unfolding

The signals read out from the cathode pads are induced by positive ions drifting slowly from the amplification region → signals have long ion tails. Convolution with the PASA response gives the **Time Response Function (TRF)**, which is asymmetric.

**TRF → strong correlation between subsequent time bins**, especially for tracks with large angular inclination (**angular effect**). The authors apply **tail cancellation on raw data before clusterization** to remove these tails [§Local Reconstruction].

**Signal unfolding** for extended clusters: precision of the position measurement for **unfolded** clusters is significantly worse than for isolated ones:
- Isolated cluster: **~0.4 mm** y-resolution.
- Unfolded (overlapping) cluster: **~2 mm** y-resolution.
- Factor ~5 degradation. `[VERIFY: paper ordering of "2 mm resp. 0.4 mm"]`

---

## 4. TRD standalone tracking — linear Riemann-sphere fit

For CPU efficiency, the TRD standalone track fit uses a **linear Riemann-sphere fit** [§TRD stand-alone tracking, eqs. 2–10]. The method projects (x, y) measurements onto a sphere, reducing the circle-fit problem to a plane-fit problem solvable in closed form. The paper gives the standard system of normal equations in the form of a 3×3 matrix equation whose coefficients are sums over measurement points [eqs. 2–10].

**Key algorithmic properties stated in the paper:**
- Closed-form linear solver — no iteration.
- **Vertex constraint** is applied by fixing one parameter (related to distance from origin) to zero [§stand-alone tracking].
- Gives results **similar to non-linear fit** [§stand-alone tracking] but **~10× faster** [§stand-alone tracking, numerical claim].
- Used also for **seeding of secondary particles** [§TRD Tracking].

**Tilted-pad modification** [§stand-alone tracking, eqs. 11–15]. Because the pads are tilted, the directly measured cathode-pad coordinate is not y but:

```
y' = y − tan(α_tilt) × (z_pad − z_v)
```

where `z_pad` is the pad centre in z, `z_v` the track z at the measurement, and `α_tilt` the tilting angle. Under the assumption that the track z position depends linearly on x over ~60 cm, and that Σ(z²) ≈ Σ(y²), the standard Riemann-fit normal equations are modified to incorporate the tilt correction. The modified form is given in eqs. 12–15 of the paper; the paper notes the modified fit remains linear and fast.

`[OCR note: equations 12–15 in the OCR are heavily symbol-garbled; structural content (Riemann fit with tilt correction, still linear) is captured; exact coefficient form requires PDF cross-check]`

---

## 5. Tracklet search — combinatorics reduction

**The central algorithmic contribution** of the paper [§Tracklet Search].

### 5.1 Why the naive approach fails

At N ≈ 5000, average clusters in propagation road per plane ≈ **1.5** [§Tracklet Search]. The naive "nearest cluster" strategy is insufficient; two close tracks can produce combinatorics of order **~7 × 10ⁿ** `[OCR-GARBLED — exponent not clearly readable]` per track at six layers — too large for Combinatorial Kalman.

### 5.2 Geometric assumptions reducing the search space

Five TRD-specific assumptions are used to prune the search before any CPU-expensive fit:

1. **Tracklet y-resolution ≈ 0.4 mm; track-extrapolation y-resolution ≈ 2× worse** (~0.8 mm) [§Tracklet Search]. The tracklet is more precise than the extrapolation — drives the choice of using in-chamber tracklets as primary observables rather than individual clusters.
2. **Unisochronity systematic shift in x** for all clusters in one plane is uncorrectable without good enough z resolution to determine the distance to the wire [§Tracklet Search]. Treated as a common offset per chamber.
3. **z-error ≈ rectangular distribution** of width equal to pad length (~4 cm) [§Tracklet Search].
4. **Averaging ~20 samples in one plane does not improve z resolution** — except at **pad-row boundary crossings**, which occur with ~**15 % probability** depending on track z-inclination [§Tracklet Search].
5. **Pad-row crossing count is bounded**, given by:
   ```
   N_change = ceil( L_drift × tan(α_z) / L_pad )        [eq. 16]
   ```
   With `L_drift / L_pad ≈ 0.3`, tracks with `tan(α_z) < 3` `[OCR-GARBLED — threshold value]` cannot cross pad-rows more than once. Tracklets with more than one change are excluded from consideration. Tracklets whose z-direction change is **opposite** to the overall track direction are also excluded as unphysical.

**Consequence:** the 3D tracklet search reduces to a **small number of 2D (x-y) searches** [§Tracklet Search] — one per time bin, per allowed z-crossing topology.

### 5.3 Two linear algorithms for the remaining search

Even after geometric pruning, the remaining combinatorics in close-track scenarios (~7 × 10ⁿ `[OCR]`) is too large for Combinatorial Kalman. Two linear algorithms are implemented within the reconstruction framework [§Tracklet Search]:

**A. Iterative algorithm.**
1. Take clusters most close to the track; remove trivial z-swapped clusters.
2. Iterate:
   - Compute tracklet position, angle, and their uncertainty.
   - Compute updated weighted-mean position (track + tracklet).
   - Compute χ² for the tracklet.
   - Take clusters closest to the weighted mean.

**B. Projection algorithm (LTS-style).** Analogous to **Least Trimmed Squares regression** in one dimension [§Tracklet Search]:
1. Loop over possible z-direction changes.
2. For each:
   - Compute residuals to the weighted mean (track + tracklet).
   - Find the sub-sample (`N_time_bins`) of clusters with minimal distance to the weighted mean.
   - Simple sort: O(N log N).
3. Outliers (atypical, infrequent observations away from the characteristic residual distribution) are removed from the sample.

The paper flags Fig. 2 as illustrative: four views of a tracklet (PRF, residuals vs time bin, residual projection, originating samples over threshold) shown first for an isolated tracklet (no overlap) and then for two overlapped clusters in the same z-slice — the projection-algorithm logic for outlier rejection becomes visible.

---

## 6. Precision of local tracklet reconstruction

The paper develops the tracklet y-position uncertainty in stages [§Precision of local tracklet reconstruction].

### 6.1 Angular-effect parameterization (eq. 17)

```
σ_y² = σ_0² + A × tan²(α) / N_samples            [eq. 17]
```

- `σ_0`: residual floor independent of angle.
- `A`: angular-effect coefficient, **linear-fit parameter** corresponding to the width of the TRF convoluted with time-measurement uncertainty (unisochronity contribution).
- `tan(α)`: track inclination.
- `N_samples`: number of time-bin samples in the tracklet.

**Electronic-noise contribution** to position precision is ~0.2 mm [§Precision] — **negligible** compared to the angular term for nonzero inclination.

**Key observation:** unisochronity is the **same for all measurements in a given chamber**, therefore the tracklet position resolution **does not scale as 1/√N_samples** — it hits a chamber-level floor [§Precision].

### 6.2 Cluster-shape scaling (eq. 18) is not the right parameterization

```
σ_y' ² = σ_0' ² + A' × tan²(α) × (PRF_shape_scale)²    [eq. 18]
```

Here the fitted coefficients `σ_0'` and `A'` come out "roughly the same" as those of eq. 17 — **but the PRF width `σ_PRF ≈ 3 mm` is much larger than `σ_0`** [§Precision]. Using eq. 18 as the uncertainty estimate produces a systematic bias:
- **Small-inclination, high-momentum tracks:** σ is **overestimated** — they get underweighted in the Kalman fit.
- **Large-inclination, low-momentum tracks:** σ is **underestimated** — they get overweighted and Kalman converges to wrong solutions.

**Both biases work against momentum resolution.** The paper emphasises: this choice "made a big impact on the achieved momentum resolution" [§Precision]. Equation 17 is adopted as the tracklet-uncertainty estimate in both the Kalman filter and the Riemann fitter.

### 6.3 Overlap correction — local intrinsic resolution (eqs. 19, 20)

In high-density environments, overlapping tracks degrade cluster-position resolution in a way that is **not captured by eq. 17 alone** (which assumes an isolated track). A per-chamber **local intrinsic resolution** is introduced:

```
σ_local² = χ²_local / (N_clusters − 2)                [eq. 19]
```

and the full tracklet-position uncertainty becomes:

```
σ_tracklet² = [σ_0² + A × tan²(α) / N_samples] × [σ_local² / χ²_local]      [eq. 20]
```

- First factor (from eq. 17): the **lower limit** of uncertainty, set by unisochronity + angular effect.
- Second factor: the **local modulation** from χ²_local / expected — accounts for overlap-induced degradation.

Equation 17 is interpreted as the **lower limit of uncertainty**; eq. 20 is the full estimate.

`[OCR note: eqs. 17–20 symbolic form is partially garbled in the OCR; structural content (floor + angular term + local modulation) is captured. Exact coefficient placement and power structure require PDF cross-check.]`

---

## 7. Results and role in this dissertation

### 7.1 Stated headline results [§Conclusion]

| Claim | Value | Reference |
|---|---|---|
| Improvement of barrel `p_T` resolution with TRD vs without | **~40 %** | §Conclusion; [ref 10 PPR Vol. II] baseline |
| Fake-track ratio, previous non-combinatorial Kalman | **~10 %** | §Conclusion |
| Fake-track ratio, robust projection algorithm (this paper) | **~5 %** | §Conclusion |
| CPU overhead of projection vs plain Kalman | "without significant increase" | §Conclusion |

### 7.2 Connection to dissertation calibration chain

This paper is the algorithmic ancestor for the TRD tracking behaviour that enters the ITS–TRD interpolation across the TPC used for Run 3 space-charge residual-distortion correction [TPC §7.2 step 4](../detectors/tpc.md). In particular:

- The **tracklet-uncertainty parameterization** (eq. 20) sets how TRD space-points are weighted in the Kalman global fit. That weight determines how much "pull" TRD exerts on the reference track used for the TPC residual map.
- The **~0.4 mm intrinsic tracklet resolution** [§Tracklet Search] is the number that propagates into the "~400 μm per tracklet" quoted in [TRD-SoT §5.1](../detectors/trd.md) — consistent across the two sources modulo rounding.
- The **projection algorithm's fake-reduction** directly improves the purity of the ITS–TRD-interpolated reference sample used for the residual map. Calibration quality → TPC distortion-map quality, which is a principal subject of this dissertation.

### 7.3 Role in the paper-tree

- This article **predates** the Run 3 continuous-readout context; tracking is triggered-mode. The Kalman-filter + tracklet-search algorithmic content translates directly to Run 3 (the data-flow model changes, the math doesn't).
- Underpins the foundation for [TRD-SoT §5.1 tracking](../detectors/trd.md) and [TPC §11.1 tracking](../detectors/tpc.md).

---

## 8. Glossary (paper-specific)

- **TRD** — Transition Radiation Detector (see [../detectors/trd.md](../detectors/trd.md)).
- **TPC** — Time Projection Chamber (see [../detectors/tpc.md](../detectors/tpc.md)).
- **Kalman filter** — recursive Bayesian estimator for track fitting [ref 3, Fruhwirth 1987].
- **Combinatorial Kalman filter** — multi-hypothesis extension; tracks multiple candidate branches [ref 5, Mankel 1997]. Rejected here on CPU grounds.
- **Riemann-sphere fit** — circle-fit-as-plane-fit geometric reformulation; closed-form linear solve.
- **Tracklet** — set of clusters belonging to the same track within one TRD chamber [§Tracklet Search footnote 2].
- **PRF — Pad Response Function** — the charge distribution across adjacent pads induced by one track [§Local Reconstruction].
- **TRF — Time Response Function** — per-channel temporal response; asymmetric due to ion-tail [§Local Reconstruction].
- **COG — Centre-of-Gravity** — naive amplitude-weighted position estimator; rejected on non-linearity grounds.
- **LTS — Least Trimmed Squares** — robust regression rejecting outliers by trimming worst-χ² fraction [§Tracklet Search projection algorithm].
- **AliRoot** — ALICE simulation/reconstruction framework [ref 4, Brun et al. 2003].
- **Unisochronity effect** — drift-time offset depending on distance-to-wire `z_3`, causing chamber-level x-shift [§Local Reconstruction].
- **Tilted pads** — pad orientation not aligned with φ, improves z resolution [§Local Reconstruction; §stand-alone tracking eqs. 11–15].
- **PASA** — PreAmplifier/ShAper ASIC (see [TRD-SoT §4.1](../detectors/trd.md)).
- **PPR** — ALICE Physics Performance Report [ref 10] — the no-TRD baseline against which the 40 % `p_T` improvement is quoted.

---

## 9. External references

### 9.1 Primary source

| Tag | Citation | URL |
|---|---|---|
| **[Belikov2006chep]** | I. Belikov, P. Hristov, M. Ivanov, K. Safarik, *Track reconstruction in high density environment*, CHEP'06 proceedings (Mumbai, India, 2006) | [CERN Indico contribution](https://indico.cern.ch/event/408139/contributions/979783/) · [PDF](https://indico.cern.ch/event/408139/contributions/979783/attachments/815694/1117684/MarianIvanovchep06.pdf) |

### 9.2 Cited references (from paper §REFERENCES)

| Ref | Citation | Cross-link |
|---|---|---|
| [1] | ALICE Technical Proposal, CERN/LHCC 95-71 | — |
| [2] | **ALICE TRD TDR**, CERN/LHCC 2001-021 / ALICE-TDR-9 | [TRD-SoT §9 primary source](../detectors/trd.md) — same TDR |
| [3] | Fruhwirth R 1987 *Nucl. Instrum. Methods* **A 262** 444 (Kalman filter) | — |
| [4] | R. Brun et al., *Nucl. Instr. Meth. Phys. Res.* **A 502** (2003) 339 (AliRoot) | — |
| [5] | Mankel R 1997 *Nucl. Instrum. Methods* **A 395** 169 (Combinatorial Kalman) | — |
| [6] | B. Dolgoshein, *Nucl. Instr. Meth. Phys. Res.* **A 326** (1993) 434 (TR physics) | — |
| [7] | A. Andronic et al., *Nucl. Instr. Meth. Phys. Res.* **A 498** (2003) 143 | — |
| [8] | A. Andronic et al., *Nucl. Instr. Meth. Phys. Res.* **A 523** (2004) 302 | — |
| [9] | *ROOT User's Guide* ch. 19 (Geometrical Modeler) | — |
| [10] | **ALICE Physics Performance Report (PPR) Volume II** — baseline for the 40 % `p_T`-resolution improvement claim | — |

### 9.3 BibTeX stub

```bibtex
@inproceedings{Belikov2006chep,
  author       = "Belikov, I. and Hristov, P. and Ivanov, M. and Safarik, K.",
  title        = "{Track reconstruction in high density environment}",
  booktitle    = "{Proc. CHEP'06, Computing in High Energy Physics, Mumbai, India}",
  year         = "2006",
  url          = "https://indico.cern.ch/event/408139/contributions/979783/",
  note         = "Indico contribution 979783, attachment 815694"
}
```

---

## 10. Open items and reviewer-validation checklist

### 10.1 OCR-garbled values — must be resolved against PDF before cycle-1 review

| # | Section | Issue | Severity |
|---|---|---|---|
| 1 | §1 | TR Lorentz-factor threshold value missing from OCR ("corresponds to a Lorentz factor of  ."). Recover exact value from PDF. | P1 |
| 2 | §1 | Six-layer radiation thickness value missing ("about 	"). TRD-TDR gives 14.3 % X₀; confirm paper quotes same. | P2 |
| 3 | §1 | Gas mixture ratio. OCR "Xe, CO(15 %)"; canonical Xe/CO₂ (85/15). Confirm. | P2 |
| 4 | §3.1 | Drift velocity units. OCR "1.5 cm/s"; physically cm/μs. Confirm. | P1 |
| 5 | §3.1 | Unisochronity maximum `z_3` value. OCR "6.7 cm" > drift region (3 cm); value likely mis-OCR'd (0.67 cm or similar). | P1 |
| 6 | §3.4 | Signal-unfolding precision: OCR "2 mm resp. 0.4 mm". Confirm which is which. | P2 |
| 7 | §4 | Eqs. 11–15 (tilt-modified Riemann fit). Structural content OK; exact coefficient form partially OCR-garbled. | P2 |
| 8 | §5.1 | Combinatorics bound "~7 × 10ⁿ" — exponent not clearly OCR'd. | P2 |
| 9 | §5.2 | Eq. 16 tan(α_z) threshold "3" and `L_drift/L_pad ≈ 0.3` — confirm dimensionally. | P2 |
| 10 | §6 | Eqs. 17–20 — structural content OK; exact symbol placement partially OCR-garbled. | P1 (foundational formulas) |
| 11 | §2 | Density context `N ≈ 5000` — confirm this is dN/dy per TRD-TDR convention. | P2 |

### 10.2 Reviewer checklist

- [ ] **Hard constraint — correctness:** every quantitative claim has a citation tag resolving to §9; every OCR-garbled value is enumerated in §10.1.
- [ ] **Hard constraint — reproducibility:** the Indico URL resolves, the PDF downloads, and `MarianIvanovchep06.pdf` fingerprint matches the cited attachment (815694/1117684).
- [ ] **Hard constraint — safety (public disclosure):** no private paths leaked; the paper is a public CHEP proceedings contribution.
- [ ] **Source-fidelity on OCR-affected values:** every `[OCR-GARBLED]` item has either an inferred value from a cross-referenced authoritative source (e.g. TRD-TDR for radiation thickness) or is explicitly marked `[VERIFY]` with the OCR reading preserved.
- [ ] **Citation coverage:** no uncited number anywhere in §§1–7.
- [ ] **Cross-ref integrity:** every `../detectors/*.md` link resolves; version labels are current (TPC wiki-v2, ITS wiki-v1, TRD wiki-v0 as of 2026-04-19).
- [ ] **Arithmetic closure** (where paper provides derivations):
  - §1 Chamber-total cross-check: `18 supermodules × 5 stacks × 6 layers = 540 chambers` ✓ (consistent with TRD-SoT §3.1).
  - §1 Channel-count consistency: paper "~1.18 × 10⁶" vs TRD-TDR canonical "1,156,032 ≈ 1.16 × 10⁶" [TRD-SoT §3.3] — rounds up by ~2 %, not an arithmetic error.
  - §3.1 Max drift span: `2 μs × 1.5 cm/μs = 3 cm` ✓ (matches drift region).
  - §3.1 Unisochronity x-shift (derived): `120 ns × 1.5 cm/μs = 0.18 cm = 1.8 mm` — comment line only.
  - §4 Riemann-fit speedup claim "10× faster" — stated, no reproducible derivation in paper.
  - §7 `p_T`-resolution improvement 40 % — stated relative to PPR Vol II baseline [ref 10]; not cross-reproducible from this paper alone.
- [ ] **Appendix A source-to-section map complete.**
- [ ] **Cross-page consequence:** adding this page **does not** retroactively change any detector wiki's cross-link table — `articles/Belikov2006_TRD_tracking.md` is a new outgoing node, not a new target. However, `../detectors/trd.md` could usefully add an inbound link from its §5.1 tracking discussion to this paper in its next revision (advisory — not a cross-link MUST).

---

## Appendix A: Source-to-section map

| Wiki § | Paper section | OCR status |
|---|---|---|
| §1 Scope and detector context | Abstract + §TRD–General Description | partial OCR loss on numeric values — itemised §10.1 |
| §2 Tracking context + challenges | §TRD Tracking | clean on text; values OK |
| §3 Local reconstruction | §Local Reconstruction | partial on drift-velocity units (§10.1 #4), z_3 (§10.1 #5) |
| §4 Riemann-sphere fit | §TRD stand-alone tracking + eqs. 2–15 | eqs. 11–15 partially garbled (§10.1 #7) |
| §5 Tracklet search | §Tracklet Search | clean on structure; eq. 16 threshold + combinatorics bound (§10.1 #8, #9) |
| §6 Tracklet precision | §Precision of local tracklet reconstruction + eqs. 17–20 | equations partially garbled (§10.1 #10) |
| §7 Results / role | §Conclusion | clean |

## Appendix B: Notation quick reference

| Symbol | Meaning |
|---|---|
| `v_d` | electron drift velocity in TRD drift region (≈ 1.5 cm/μs) |
| `v_d_mean` | average drift velocity used in linear x-reconstruction (eq. 1) |
| `t_drift`, `t_0` | drift-time measurement, reference time zero |
| `z_3` | distance from anode wire in drift region (unisochronity coordinate) |
| `α` | track inclination angle (in eq. 17 context: inclination relative to y-direction) |
| `α_z` | track inclination in z-direction (eq. 16) |
| `α_tilt` | pad tilt angle (eq. 11) |
| `σ_y`, `σ_y'` | y-position uncertainty (eq. 17, eq. 18) |
| `σ_0`, `σ_0'` | y-uncertainty floor |
| `A`, `A'` | angular-effect coefficients |
| `N_samples` | number of time-bin samples in a tracklet |
| `σ_local` | per-chamber local intrinsic y-resolution (eq. 19) |
| `χ²_local` | per-chamber tracklet fit χ² |
| `L_drift`, `L_pad` | drift length, pad length (eq. 16) |
| `p_T` | transverse momentum |
| `dN/dy` | charged-particle density per unit rapidity |

---

## Changelog

### wiki-v0 (2026-04-19, Claude2) — first indexation

- **Source.** Full-text CHEP'06 paper fetched via `web_fetch` from Indico. 4-page PDF; OCR extraction substantially complete for text, partially garbled on mathematical symbols, Greek letters, and some numeric values. Every garbled value explicitly enumerated in §10.1 rather than inferred silently.
- **Structural.** MIWikiAI schema, closest exemplar: TRD-SoT wiki-v0 (same author-family, same content domain, sibling article-vs-detector pair). Front-matter matches the current convention (separate `indexed_by`/`indexing_model` fields; `peer_reviewers: []` for a fresh v0; `source_status: COMPLETE` with explicit caveat on OCR-garbled values; `known_verify_flags` enumerated).
- **Authorship note.** Marian Ivanov is both the dissertation lead (MIWikiAI project author) and a co-author of this paper. Front-matter `author:` field follows the convention used across detector pages (dissertation lead first), and the paper itself is canonically attributed to all four authors in §9.1.
- **Section structure.** TL;DR → scope/context → tracking challenges → local reconstruction → Riemann fit → tracklet search → precision → results/role → glossary → refs → checklist → appendices → changelog. Matches TRD-SoT layout.
- **Cross-links.** Inbound to TPC wiki-v2 (§7.2 step 4, §11.1 tracking), ITS wiki-v1 (for completeness of the barrel reconstruction chain context), TRD wiki-v0 (§1 detector parameters, §3.2 gas, §3.4 material budget, §4.1 readout, §5.1 tracking resolution). Version labels current as of 2026-04-19 — same lint-class bug to watch I flagged in the three detector reviews.
- **[OCR-GARBLED] convention.** New tag used sparingly for values where the OCR is readable enough to show a value exists but not enough to trust it. Distinct from `[VERIFY]` (which is "this value is correct in the source but needs a secondary confirmation") and from `[PENDING]` (which is "no value yet"). Consider adding to governance QuickRef once the OCR-affected-article workflow is seen once or twice more.
- **Arithmetic closure** (§10.2): chamber-total `18 × 5 × 6 = 540` ✓; channel-count rounds consistently with TRD-TDR; drift-span `2 μs × 1.5 cm/μs = 3 cm` ✓; unisochronity x-shift `120 ns × 1.5 cm/μs = 1.8 mm` derived as context.
- **Content unchanged from source:** all physics claims, algorithm descriptions, numbers (except where OCR-garbled — itemised §10.1), equation structure preserved. No new quantitative claims introduced.

### Next reviewer pass — cycle 1

- Resolve every §10.1 `[OCR-GARBLED]` item against the PDF directly (or against a cleaner text extraction).
- Confirm equations 17–20 in §6 against the PDF; the physical reasoning is captured but the exact symbolic placement may need correction.
- Consider advisory edit to [TRD-SoT §5.1](../detectors/trd.md) adding a cross-link inbound from that detector page to this article — not a cross-link MUST per governance, but useful for downstream readers following the tracking-algorithm thread.

---

*End of Belikov2006_TRD_tracking wiki-v0 (2026-04-19, Claude2). Article-folder first indexation. Source is a CHEP'06 proceedings paper authored by the dissertation lead and three colleagues; captures the algorithmic foundation for the TRD tracking subsystem as it exists in AliRoot / O² today. 11 `[OCR-GARBLED]` items enumerated in §10.1 — all are identifiable, none are silently inferred; cycle-1 review should resolve them against the PDF.*
