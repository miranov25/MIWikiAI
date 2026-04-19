---
wiki_id: O2-6344
title: Material Budget and ITS / TRD Alignment Patch (TPC distortion decomposition, rate scan, global alignment)
project: MIWikiAI / ALICE
folder: presentations
source_type: presentation
source_status: PARTIAL — working-progress deck; many items flagged "ongoing", "to be released", "work in progress"; wiki indexes the 2026-04-19 snapshot of a live JIRA ticket
source_fingerprint:
  upstream:
    - id: O2-6344-slides
      title: "O2-6344 - Materialbudget and ITS_TRDAlignmentPatch"
      slide_count: 61
      url: "https://docs.google.com/presentation/d/1_CEbykfc0mqYJlfQAxqisNciEYgeWUFORHLnsl9w2Fc"
      htmlpresent_url: "https://docs.google.com/presentation/d/1_CEbykfc0mqYJlfQAxqisNciEYgeWUFORHLnsl9w2Fc/htmlpresent"
      slides_empty_or_stub: [5, 19, 24, 38, 48, 53, 58]
      slides_duplicated: [[40, 41], [52, 54], [26, 27]]
      sections_cited: ["slide 1–61, full deck"]
  summary_contributors: [{id: Claude1, role: indexer}]
jira_ticket: O2-6344
indico_reference: "https://indico.cern.ch/event/1578036/contributions/6769875/"
author: Marian Ivanov (UK Bratislava / CERN / GSI / UniHeidelberg); with Matthias (rate-scan studies), Ruben (ITS alignment, mentioned)
indexed_by: Claude1
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
source_last_verified: 2026-04-19
source_verification_depth: deck-CONTENT-VERIFIED (htmlpresent fetched; slides 1–61 read)
review_status: DRAFT
review_cycle: 0
peer_reviewers: [Claude1]  # self-indexed; cycle-1 external review pending per MIWikiAI SUMMARY §7.1 sprint mode
hard_constraints_checked: {correctness: partial, reproducibility: partial, safety: verified}
staleness: fresh
known_verify_flags:
  - "§1.2 Δq/pt intrinsic-resolution reference value 0.0007 GeV⁻¹ — source is internal QA study, not cited to external paper"
  - "§2.3 ~10–20 % material-budget rescale estimate — working estimate from extrapolation-bias fit; quantitative confirmation deferred to ongoing dY-refit study"
  - "§3.3 effective slope ωτ ≈ 0.38 ± 0.01 — agreement with 0.385 from independent charging-up fit is stated; cross-paper/source verification against TPC TDR ωτ prediction deferred"
  - "§3.4 crossing-point R ≈ 146 cm space-charge-free reference — stated as 'similar to TPC TDR (2012) simulation'; exact TDR figure / section not cited"
  - "§3.7 charging-up fit parameters τ1 = 1708 ± 22 s, τ2 = 2558 ± 35 s — run 564848 2025 pp; physical interpretation as IFC charging-up stated but specific physical-model derivation not in deck"
  - "§5.1 ITS-out residual 'virtual radial scaling ≈ 50 µm at 0.2 T, 26 µm at 0.5 T' — reported for LHC25ah/565788 and LHC25h5MC/566341/566407; field-scaling origin flagged as 'tracking bug, under investigation'"
  - "§6.2 DCA sector-edge ±0.02 cm left-right modulation 'consistent with space-charge deficit at the chamber cross with lower gain' — qualitative attribution; quantitative modelling ongoing"
  - "§4.1 LUT vs GEO material-bias slope ~20 % — working first-guess estimate; detailed analysis ongoing (~10–20 % flagged as 'a lot')"
wiki_sections_stubbed:
  - "§8.2 fiducial-volume cut algorithm — 'discussed since 2 years' but no device available yet (no device with access to TPC cluster, tracks, and ITS tracks simultaneously); primary-vertex-based interpolation now possible"
  - "§7.3 TRD/TOF alignment final calibration — iteration 0 shown; vertex-constrained crosscheck pending (new data set with vertex constraint)"
  - "§9 Open items — many sub-items marked 'ongoing', 'to be released', 'not yet finished'; deck is a live status report, not a closed deliverable"
---

# O2-6344 — Material Budget and ITS / TRD Alignment Patch

## TL;DR

Progress report (JIRA ticket O2-6344) on the **combined calibration chain** for the ALICE TPC + ITS + TRD + TOF system during the Run-3 2023–2025 campaign. The deck is a **working-document snapshot** (61 slides, 2026-04-19) documenting ongoing work rather than a closed deliverable. Four tightly-coupled themes:

1. **ITS alignment** — MILLIPEDE weak-mode in Run-3 alignment causes elliptical angular bias; q/pt-dependent DCA bias in the ITS "gap" regions (sector boundaries 0→18 and 8→9). Proposed **Kalman-emulation angular alignment** using TPC as the constraint — a stopgap pending the new Ruben alignment.
2. **Material budget calibration** — the reconstruction uses an approximate LUT with coarse (φ, r, η) granularity, introducing up to ~20 % systematic bias in q/pt and reconstructed y. Ongoing calibration scales the material budget by ~10 % (first-guess) using PID-dependent dY(q/pt) fits; fastMC-template refitting of residuals at multiple radii is the proposed path.
3. **TPC distortion decomposition** — factorized fitting via **Python dfextensions toolkit** (Numba-accelerated) decomposes the distortion into charging-up (O(10 min)), space-charge fluctuation (O(ms)), IFC / resistor-rod / GEM-stack / sector-boundary components. Time granularity now pushed from O(min) to O(<1 s) for Δ-fits. **Rate-scan program** (−40 % → +20 % at start-of-fill + mid-fill) proposed to measure dD/dRate with ~0.002 cm precision, disentangling rate-dependent and current-dependent components.
4. **Global ITS + TPC + TRD + TOF alignment** — first test of iterative global calibration combining all residual fits; **ITS-out tracking anomaly** identified as a distinct, reproducible bug (present in ideal MC, B-field-sign-reversing, step at q/pt ≈ 0) independent of data-side issues.

Companion infrastructure: SoA framework for distortion factorization / compression (schema in deck §55); TRD tracklet info PR (AliceO2 #14969) for pileup tagging and dE/dx recalculation.

**Primary entry point to the ALICE calibration chain as of 2026-04-19.** Cross-references every detector SoT page currently in MIWikiAI (TPC, ITS, TRD — and TOF as the fourth leg of the alignment chain, not yet indexed).

---

## 1. ITS alignment problems (slides 1–4)

### 1.1 Observations — MILLIPEDE weak mode + derivative bug

**Slide 1.** Two concurrent issues in the Run-3 ITS alignment:
- **Weak mode in MILLIPEDE minimization** — global shift / rotation modes insufficiently constrained.
- **Bug in derivatives** (reported by Ruben, under investigation) — distinct from the weak-mode issue.

Three observational signatures:
- DCA bias and smearing for primary tracks.
- q/pt bias at high and low pt (up / down asymmetry).
- TPC–ITS bias — **parabolic misalignment**, i.e. rotation coefficient scaling parabolically vs. some reference variable.
- **~2 mm modulation in the TPC** (residual).

### 1.2 Δq/pt bias in the ITS "gap" regions

**Slide 2.** `apass3` dataset (`/alice/data/2023/LHC23zzh/apass3/544121`). In the **sector-boundary gap regions** (0→18 and 8→9), a Δq/pt bias of **0.002 GeV⁻¹** is observed, while the intrinsic resolution is **~0.0007 GeV⁻¹** — i.e. the bias is ~3× the intrinsic resolution.

Key observations:
- Bias is **strongly tgl-dependent** — varies with track longitudinal angle and vertex-z.
- Ongoing: **4D calibration maps** being prepared with added `vz` dimension: `(q/pt, tgl, vz) → Δq/pt_correction`.
- Independent TPC studies reveal **radial distortions in sectors that appear non-physical**, likely due to ITS-side bias leaking in.

**Current fit state:** assumes constant shift `Δq/pt` (approximation valid at very high pt). A more sophisticated q/pt-dependent DCA-bias model is required for full correction.

### 1.3 Global alignment fit — linear (hyper-plane) regression (April 2023)

**Slide 3.** Two running fits:
- `ITS → TPC` (4 coefficients; first harmonic Δy, 2 harmonics Δφ)
- `ITS + TRD → TPC`

**Fit strategy:**
- `B = 0` used outside of boundaries.
- First harmonic (global x, y shift); second harmonic set to 0 for better data description (weak calibration modes).
- 2 harmonics retained for Δφ.

**Fit results (in cm and mrad):**

| Variable | Fit components (4 values) |
|---|---|
| `ITS → TPC` Δy (cm) | −0.021, −0.139, 0.020, 0.004 |
| `ITS → TPC` Δφ (mrad) | 0.38, 0.23, 0.85, 0.11, 0.13 |
| `ITS+TRD → TPC` Δy (cm) | −0.027, −0.081, 0.030, 0.028 |
| `ITS+TRD → TPC` Δφ (mrad) | 0.40, −0.41, 0.89, −0.17, −0.46 |

**Misalignment impact:**
- **High-pt tracks:** rotated.
- **Low-pt tracks:** rotated *and* curvature-modified (Δq/pt added).
- Residual misalignment to be added to correction fits ("smearing").

Implementation uses `sklearn.linear_model.LinearRegression` on the augmented variable set `[sinP, cosP, sin2P, cos2P, sinPX, cosPX, sin2PX, cos2PX, x]`.

### 1.4 Proposed solution — two paths

**Slide 4.** Two ordered options:

1. **Try new Ruben alignment** — even if not "perfect" on DCA.
2. **If new alignment not available:** apply **angular-element Kalman-emulation alignment** using the TPC constraint (from §1.3). This acts as a "Kalman update" for the ITS (and TRD, TOF) alignment parameters.

**Mechanism:** since alignment errors are unknown, the Kalman update uses the expected alignment error. Shifts the alignable volumes by the amount described by the observed parabolic misalignment and the curvature observations.

---

## 2. Material budget calibration (slides 6–18)

### 2.1 The LUT approximation and its biases (slide 7)

Material budget in the reconstruction (and in TPC distortion calibration) uses an approximate **lookup table (LUT) with limited (φ, r, η) granularity**. Consequences:

- Coarse LUT granularity introduces **systematic biases in q/pt and reconstructed y-position** up to **~20 %**, with strong φ-dependent modulations.
- These effects mainly manifest in the fitted **ΔX calibration** (subsequent slides).
- The material budget itself is only known with limited precision (iteration with the Gamma group ongoing).

**Goal:** calibrate an efficient, accurate material-budget correction that reduces systematic distortions while keeping CPU usage manageable.

### 2.2 Ongoing calibration strategy (slide 8)

Big-statistics dataset: TPC tracks propagated to the primary vertex using three different material-budget correction variants:

- **Geo** — full Geant material budget.
- **LUT** — current approximation.
- **NoMat** — zero material (reference).

**GroupBy statistics:**
- Bins in `(φ, η, vz, PID)`.
- Fit variable: `dY_observed : dY_nomaterial`.
- Expected: **PID-dependent** response; effective scaling of the material-budget correction.
- **Status:** not finished.

### 2.3 Extrapolation bias — quantitative estimate (slide 9)

**Reference trajectory check:** extrapolation from 80 cm → 0 cm.

**Order-of-magnitude expectations:**
- Pion at 0.2 GeV (`1/pt = 5`): extrapolation bias **≈ 1 cm**.
- Extrapolation from outer ITS → outer TPC (250 → 40 cm): **≈ 7 cm** (scales as `(distance-ratio)²`; stated factor in deck: `(250−40)/80)² ≈ 7.0` — this geometric scaling agrees with the observation).

**Observed bias in correction maps:** ~0.5–1 cm. To match, **material budget rescaling by ~10 %** is required — stated as "seems feasible."

**Particle-species dependence:** dY vs q·pt plot (color = dE/dx) shows three clearly distinguishable particle species (π, K, p) in the extrapolation-bias map.

**Proposed approach:** refit the dY bias at different radii using **fastMC templates**, determine effective Δ(material) explaining biases for three particle species. Implemented via `TLinearFitter` (root/aliroot).

### 2.4 LUT-vs-Geo systematic (slides 10, 11)

Slide 10 shows simplified-material O2 reconstruction leads to systematic bias in **deflection**: mean trajectory position differs between full-material and LUT treatments, with a **slope ~20 %**. Bias is **φ-dependent**.

### 2.5 Material-budget fit — DCA deflection (slides 13–14)

DCA deflection used as the material-budget fit target. PID-specific fits via GroupBy (`pidCode == 0, 2, 3, 4`); per-PID linear correlation `dyLUT : dyLUT_fitqpt` extracted and plotted (4-panel canvas, one per PID).

### 2.6 Radial scaling vs affine transformation (slide 16)

Coordinate transform used for the material-budget scaling:
- `x = r · sin(φ)`, `y = r · cos(φ)`, `z = z`
- `R = sqrt(r² + z²)`
- `R → R · (1 + ε)`

---

## 3. TPC distortion decomposition and rate-scan calibration (slides 20–33)

### 3.1 Factorization framework (slide 21)

**Per-fill calibration** resolves fast and slow distortion components in time and space using **factorized distortion fitting** via the new Python calibration libraries (Numba-accelerated). Time granularity: **1 h (unbinned residuals)** now grouped to **10- and 5-minute intervals** (~6× finer); further refinement expected once TPC is included in the fit.

**Decomposition steps:**

| Step | Target | Method |
|---|---|---|
| Δ₀ | Remove baseline (average after charge-up saturation) → isolates space-charge fluctuations | global subtract |
| Δ₁ | Fit φ-symmetric (ΔΦ) component → `corr0` | azimuthal average |
| Δ₂ | Remove per-stack effects → `corr1` | stack-by-stack fit |
| *smoothing* | Eliminate high-gradient components (charging-up, imperfections) | kernel smoothing |
| Δ₃ | `(y2xBin, z2xBin)` high-gradient corr2 | 2D residual fit |
| Δ₄ | Residual corrections | final pass |

**Main distortion sources (time constants):**

| Source | Time constant |
|---|---|
| Space-charge fluctuations | O(ms) |
| IFC charging-up (φ-symmetric) | O(10 min) |
| Resistor-rod structure | O(10 min) |
| GEM stack resistor fluctuations | O(s) |
| Sector-boundary fluctuations | O(s) |
| Standard sector-cross / sector-boundary effects | continuous |

### 3.2 Python dfextensions toolkit (slide 22)

General-purpose Python statistical utilities for calibration, performance parametrization, distortion decomposition, dE/dx calibration. **Numba JIT** gives C++-like speed with Python flexibility.

Main classes:
- **`AliasDataFrame`** — lazy evaluation, data aliasing, compression.
- **`GroupByRegressor`** — multi-dimensional functional regression in grouped bins.
- **`GroupByRegressor` (sliding window)** — extension supporting continuous time or spatial regression with sliding-window and kernel models.

Status: toolkit **ready for expert distortion decomposition and calibration production at GSI** (fully functional, not available two weeks prior to deck date). Reference: Offline Week presentation [Development of Python Calibration Toolkit](https://indico.cern.ch/event/1589178/#323-development-of-pythonc-cal).

### 3.3 Rate-scan program (slides 23, 26–29)

**Proposed scan:** two well-defined rate steps (**+20 %, −40 %** relative to nominal). Runs at **start-of-fill (charging-up regime)** and **mid-fill (saturated regime)**. Duration: ~2 min per ramp.

**Physical rationale:**
- Simultaneous variation of current and boundary potential introduces **non-trivial coupling** in the distortion response. Rate-scan separates the two components.
- Numerical derivative `dD/dRate` should be **approximately independent of charging-up state** (physical expectation). Rate scan tests this.
- **ITS-out-based measurement alone is insufficient** — 5 cm extrapolation error, 2–3 cm bias. In the **derivative**, material-budget / ITS-alignment / seeding-bias systematics largely cancel.

**Relevance for Pb-Pb 2025:** during LHC24as the IFC anomaly made derivative calibration almost impossible (rate and current strongly correlated in time). Two well-separated scans allow clean decomposition.

### 3.4 DCA bias time evolution — two-exponential model (slide 27)

**Model fit (Run 564848, 2025 pp):**

```
f(t) = A · exp(−t/τ₁) + B · exp(−t/τ₂) + C
```

| Parameter | Value |
|---|---|
| A | −1.584 ± 0.093 cm |
| τ₁ | 1708 ± 22 s |
| B | 1.36 ± 0.093 cm |
| τ₂ | 2558 ± 35 s |

**Physical interpretation:**
- Dominant time-dependent distortion from **IFC 2** (φ-symmetric component).
- τ₁, τ₂ characterize charging-up relaxation.
- Calibration from short (5 min) time-sliced fits with symmetry assumption reduces statistics requirement by `nPhiBins = 360`.

**Caveat:** LHC24as Pb-Pb period showed markedly different time evolution — additional contributing effects present.

### 3.5 A-side / C-side asymmetry (slides 30, 31)

**φ-symmetric component:** radial distortions (ΔX) leak into ΔY via E×B with
```
ΔY ≈ ΔX × ωτ ≈ −0.38 · ΔX
```

**Side-dependence in first two hours:**

| Side | |ΔY| envelope | Dependence on tan λ | Residual fluctuation |
|---|---|---|---|
| A | up to ~0.5 cm | broad pseudorapidity range | stable at later times |
| C | up to ~0.25 cm | localised to |tan λ| < 0.2 | still fluctuating at later times |

**Residual asymmetry** in charging-up distortions — φ-asymmetric deviations visible in one sector (both sides), likely related to the **resistor-rod region** with field inhomogeneities. Modelled by per-sector local linear fit in `(y2xBin ~ tan φ, z2xBin ~ tan θ)` using Numba-based group-by regression.

### 3.6 d⟨Y,X⟩/d⟨IDC⟩ numerical derivative (slide 32)

**Effective ωτ extracted from IDC-derivative:**
- ωτ ≈ **0.38 ± 0.01** on both A and C sides.
- In excellent agreement with the independent charging-up fit value **0.385**.
- Validates the proportionality `ΔRφ / ΔR = ωτ` — i.e., ωτ largely independent of radius and drift distance within uncertainties.
- At small drift (drift ≈ 0) the derivative is less stable — next iteration will impose a `drift(0)` boundary condition.

### 3.7 Crossing-point calibration — space-charge-free reference radius (slide 33)

The numerical derivatives `d⟨X,Y⟩/dIDC` **cross zero at R ≈ 146 cm** on both A and C sides. This defines the **space-charge-free reference radius**, similar to the TPC-TDR (2012) simulation prediction.

**Physical constraint:** independent of
- residual ITS misalignment,
- material-budget uncertainties,
- imperfect ITS track momenta.

**Practical implication:** enables direct calibration of residual radial distortions at ±0.5 T and (more strongly) at ±0.2 T. Basis for the IR rate-scan `500 → 1500 → 100 → 500 kHz` before Pb-Pb operation.

### 3.8 Sector-edge calibration bias (slide 34)

Factorized fit (ΔY) on high-statistics maps (~900 × 2000 tracks per voxel) vs. `(y2xAV ~ tan φ)`:

- **Left-right modulation:** step of **±0.02 cm**, consistent with space-charge deficit at the chamber cross (lower gain region).
- **Two-bin oscillation near tan φ ≈ 0:** reflects lower pad gain at the cross region (~0.03 cm).
- **Smooth boundary transition:** expected response with missing charge in the dead zone.
- **Strong bias in the last sector-edge bin** is **linearly correlated with pad-to-frame distance** (dEdge) — geometric, not distortional.

**Separation of real distortion from edge-cluster bias:**
- Exclude edge pad rows during map creation (option to be added).
- Alternatively, use 40 bins in tan φ and fit physically across the boundary (ongoing map production).

External reference: [JINST 2021 16 P03022 (TPC pad-plane performance)](https://iopscience.iop.org/article/10.1088/1748-0221/16/03/P03022/pdf).

---

## 4. Global iterative calibration and ITS-out anomaly (slides 35–37)

### 4.1 First test of the iterative global chain (slide 35)

First combined-residual fit of ITS + TPC + TRD + TOF. Main observations:
- **Clear B-field-dependent anomaly in ITS-out tracking** (details §4.2).
- **Extrapolation uncertainty at TPC outer radius ≈ 5 cm**; systematic bias of similar order (1–3 cm).
- Using ITS for TPC dX calibration is problematic (known for years).

**Identified issues (3):**
1. **dE/dx correction bias** — partially reduced with low-dE/dx selection; still limited by material-budget precision (§2).
2. **Step at q/pt ≈ 0** — likely bug or non-linearity in ITS-out tracking; sign reverses with B; **absent in the ITS + TRD calibration chain.**
3. **Residual bias ∝ (q/pt)² × r** — non-linear term now explicitly parametrized (also not seen in ITS + TRD).

**Additional finding:** `dX` fit slope (`⟨dY⟩ vs tgSlp`) strongly depends on the q/pt fit range — must be controlled to avoid artificial radial scaling in the global fit.

### 4.2 ITS-out tracking anomaly — detail (slide 37)

Residual fit on first ITS layer shows:
- **Linear dependence of residual vs q/pt** with visible offset and two bands (positive / negative pt).
- Effect present **in ideal MC** → not a data-only issue.
- **Slope depends on B-field (sign-reversal)** with larger effect for smaller dE/dx.

**"Virtual" radial scaling values:**
- **~50 µm at 0.2 T**
- **~26 µm at 0.5 T**

Datasets: LHC25ah/565788 (B = 0.5 T, data); LHC25h5MC/566341.b2m; LHC25h5MC/566407.b2p.

### 4.3 Residual cluster-track dependence on inclination — table (slide 36)

Linear fit residuals after official residual CCDB correction, as a function of the local-track-inclination fit range:

| fitRange | dY (cm) | dX (cm) |
|---|---|---|
| ±0.200 | −0.003 | 1.559 |
| ±0.300 | 0.015 | 0.830 |
| ±0.400 | 0.019 | 0.563 |
| ±0.500 | 0.020 | 0.381 |
| ±0.600 | 0.021 | 0.239 |
| ±0.700 | 0.023 | 0.150 |
| ±0.800 | 0.024 | 0.089 |
| ±0.900 | 0.024 | 0.052 |

**Observation:** ΔY stable within ≈0.02 cm. ΔX strongly depends on fit range and calibration scheme. Sensitivity differs between SM and CPM maps. For robust calibration, linear fits must be extracted as a function of dE/dx, q/pt selection, rate, and magnetic-field polarity.

---

## 5. ITS + TPC + TRD interpolation map (slides 39–47)

### 5.1 Fit cascade (slide 39)

Five-stage fit cascade integrating TPC, ITS, TRD residuals:

| Stage | Name | Purpose |
|---|---|---|
| 1 | **FitCorr0** — TPC-TPC per side/sector | Charging-up estimator; sets global ΔY∞ baseline |
| 2 | **FitCorr1** — TPCΔ1 – ITScluster | φ-symmetric (space-charge) estimator; global alignment dy-fit with ITS as reference |
| 3 | **FitCorr2** — TPCΔ2 per sector | Sector-by-sector Δ-fit; baseline + fast fluctuations |
| — | **TPC + ITS refit** | Tracks refitted with FitCorr0 + FitCorr1 + FitCorr2 |
| 4 | **FitCorr3** — final TPC fit (TPCΔ3 + ITS refit) | Final 3D correction map (ITS–TPC–TRD consistent) |

**Time granularity:** O(min) for full 3D fits; down to O(<1 s) for Δ-fits + symmetry-constrained fits. Two levels: O(s) and O(min).

### 5.2 Charging-up snapshot estimator (slides 40–42)

Estimator: cluster → track residuals, **RMS ≈ 0.15 cm** (not 5 cm) even without smoothing. Only ~5–10 TFs needed for **≈ 0.002 cm resolution** in the folded average.

**Two-rate scan:** one at start-of-fill, one after ~2 h (charging-up completed). Two snapshots → differential calibration.

**Jump patterns at GEM stack boundaries:**
- `Jump ∝ dR · ωτ(B)`
- At 0.5 T: dY step ± 0.12 cm; dR ± 0.3 cm; dZ ± 0.4 cm

### 5.3 Distortion factorization (slides 43–45)

**Evolution of factorized component vs IDC:**
- Charging-up and boundary terms behave smoothly, well-constrained statistically.
- After subtracting baseline shape, residual deviation at **±0.02 cm** level.
- **Accuracy target:** final calibration distortion bias < 0.2 cm (intrinsic-resolution scale).

**Boundary distortions evolve in time:**
- At the beginning of the fill vs after ~2 h: shape is **diametrically different** close to the IFC and OFC.
- Driven by charging-up dynamics; visible in Δy(pad row) patterns.
- **Sign and magnitude of distortion change over time** close to both inner and outer field cages.

**dZ vs dY coupling:** dZ arises from (i) dR × tan λ (geometric) and (ii) ExB drift-velocity modulation.

### 5.4 DCA sector-edge — two-effect separation (slide 46)

**After edge-pad-row-exclusion bug fix:** DCA σ and RMS improved significantly.

**Remaining bias is tracking-side, not distortion-map-side:**
- Clusters in edge pad rows bias fitted track toward sector centre.
- Geometric structure expected: selecting tracks at given momentum / φ naturally produces COG distribution in lower/upper radius branches.

**Proposed reconstruction strategy:**
- Refit tracks using **interpolation across sector edge** (TPC + ITS or TPC + vertex).
- **Fiducial-volume cut:** only clusters inside safe pad-row / φ region enter fit.
- Edge clusters used for QA only, not for χ² minimisation or vertexing.
- **Blocking issue:** "discussed since 2 years — problem in device structure. No device available with access to TPC clusters, tracks, and ITS tracks simultaneously." Primary-vertex-based interpolation is now possible.

### 5.5 Work-in-progress snapshot (slide 47)

- **5- and 10-min maps** extracted for several pp fills (Matthias).
- **Physically-motivated decomposition-based smoothing** to be applied → closure test next.
- For fills without available IDC derivatives, a common derivative will be used temporarily.
- **Stack boundary + cross-region decomposition** to use the "golden fill"; scheduled after the TPC meeting, before the SC meeting.

---

## 6. CTF fluctuation tagging (slides 49–51)

### 6.1 Pb-Pb apass2 (2023) fluctuations (slide 49)

Discrete fluctuation in **C1 / C2 sectors** at very high Pb-Pb rates (> 25 kHz) — the "usual suspects." Additional O(0.5 cm) fluctuations seen in other sectors.

**Proposed physics-analysis cutoff:** `Δ DCAR (10–2000 TFs)` and `Δ DCAR (2000–RUN TFs)`.

### 6.2 Bad-CTF tagging algorithm (slide 50)

- Tagging variable: `DCA_10TF − DCA_10000TF` (local vs long-term median); residual bias removed with better residual calibration.
- Bad-TF threshold: e.g. **0.3 cm**.
- Final bad-TF flag: **logical OR** of bad-condition flags across individual φ intervals (sectors).

### 6.3 CTF rejection fractions (slide 51)

For apass1: rejecting CTFs with local bias > 2–3 σ of DCA bias.

**Threshold options investigated:** 0.3 cm, 0.5 cm, 0.6 cm. In apass1: **hardwired cut** for selection; further refinement in physics analysis.

---

## 7. ITS + TPC + TRD + TOF full alignment (slides 56–59)

### 7.1 Iteration 0 — anchored to ITS out (slide 57)

**Combined model:** TPC distortion decomposition + charge-up + global alignment + space-charge. Anchored to ITS-out.

**Consequence:** clear mismatch in **TRD / TOF matching** (up / down sectors), indicating inconsistent alignment between ITS and TRD/TOF.

### 7.2 Radial distortion + TRD / TOF misalignment (slide 59)

Radial-distortion fit combining TPC distortion + ITS + TRD + TOF alignment. **New data set with vertex constraint** to crosscheck residual misalignment (pending).

---

## 8. Data infrastructure — SoA, compression, unbinned residuals (slides 52–55, 60–61)

### 8.1 SoA compression schema (slide 55)

Example schema (JSON-style) for diagnostic fit outputs:
- `dzC1_slope_sinPhiR_DITS0SideFit`: `float32`
- `diag_n_total_DITS0SideFit` / `diag_n_valid_DITS0SideFit` / `diag_n_filtered_DITS0SideFit`: `int32`
- `diag_cond_xtx_DITS0SideFit`: `float32` (condition number of X^T X)
- `diag_status_DITS0SideFit`: `object`

**Compression state machine** per-field, e.g. for dy:
```
compress_expr:   round(asinh(dy) * 40)
decompress_expr: sinh(dy_c / 40.)
compressed_dtype: int16
decompressed_dtype: float16
```

Similar for `dz`, `y` (factor `0x7fff / 50`), `z` (factor `0x7fff / 300`).

### 8.2 Unbinned residual extensions — TPC (slide 60)

**Per-row extensions (~1 byte per row):**
- `Qmax / dE/dx`, `Qtot / dE/dx`
- Occupancy

**TPC refit and dE/dx improvements:**
- **Cluster-error parametrization** (drift, track angle, occupancy, Q-dependence).
- **Tracklet-error parametrization** (adapted from TRD algorithm): RMS of cluster residuals, local angular matching, charge-ratio information.
- Tracklet weighting (local + global).
- Same data feeds into improved dE/dx recalculation.

### 8.3 TRD tracklet information — PR #14969 (slide 61)

- Three charge values per tracklet (tags pileup from past and future).
- **Recomputed dE/dx** with log-weighted mean for improved robustness.
- Use of Q_tracklet (integration time `vdrift ≈ 1.5 cm/ms`):
  - Error parametrization (outlier tagging)
  - Pileup rejection / correction
    - Missing charge for pileup tracks
    - Radial-shift effects
    - Incorrect tilting correction

Repository: [AliceO2 PR #14969](https://github.com/AliceO2Group/AliceO2/pull/14969) — "Add extra info with charge and timing to unbinned residuals."

---

## 9. Open items and reviewer-validation checklist

### 9.1 Author-declared open items (as they appear in the deck)

- [ ] Material-budget calibration — not finished (§2.2).
- [ ] PID-dependent effective material-budget scaling factor.
- [ ] Detailed re-fit of dY bias at different radii using fastMC templates (§2.3).
- [ ] Rate scan program: two fills, two rate steps (−40 %, +20 %); status "waiting for unbinned residuals for calibration" (§3.3).
- [ ] Δ-map for MC production: "to be released on Friday or Monday" (§5.5, relative to deck date).
- [ ] TPC used in fit — "this week" (§3.1).
- [ ] Vertex-constrained crosscheck of TRD / TOF alignment (§7.2).
- [ ] 5 / 10 min pp fill maps — closure test pending (§5.5).
- [ ] Fiducial-volume cut — no device available yet; primary-vertex-based interpolation now possible (§5.4).

### 9.2 Indexing flags for reviewer to resolve

| # | Section | Issue | Severity |
|---|---|---|---|
| 1 | §1.2 | Intrinsic-resolution value 0.0007 GeV⁻¹ is from an internal QA study; no external paper citation | P2 |
| 2 | §2.3 | `((250 − 40)/80)² ≈ 7 cm` arithmetic: actual `(210/80)² = 6.89 ≈ 7 cm` ✓; deck omits the explicit expression — reproduction straightforward but worth making explicit | P2 |
| 3 | §3.4 | Charging-up τ₁, τ₂ values stated without derivation of the two-exponential model from first principles | P2 |
| 4 | §3.7 | "TPC TDR (2012) simulation" reference for R ≈ 146 cm crossing point — specific TDR section/figure not cited | P2 |
| 5 | §4.2 | ITS-out tracking anomaly is marked "bug, under investigation" — wiki preserves the finding; resolution is code-side, not wiki-side | P2 |
| 6 | §6.2 | φ-interval OR-logic for bad-TF tagging — threshold 0.3 cm is one of three options "compromise efficiency/bias"; final choice not fixed in deck | P2 |
| 7 | deck-wide | Slides 5, 19, 24, 38, 48, 53, 58 are empty; 40/41 and 52/54 and 26/27 are near-duplicates (different field polarity or textual revisions). Source-deck hygiene, not wiki issue | P3 |

### 9.3 Arithmetic-closure spot-checks

- §2.3 extrapolation scaling: `((250 − 40)/80)² = (210/80)² = (2.625)² = 6.89 ≈ 7.0 cm` ✓
- §3.4 two-exponential fit: τ₁ = 1708 ± 22 s ≈ 28.5 min; τ₂ = 2558 ± 35 s ≈ 42.6 min. Both in the O(10 min) → O(1 h) range expected for IFC charging-up.
- §3.5 ωτ cross-consistency: 0.38 (IDC derivative) vs 0.385 (charging-up fit) — agreement within quoted ±0.01 ✓
- §3.7 crossing-point `R ≈ 146 cm`: between TPC IROC inner (~85 cm) and outer (~250 cm); in the OROC region. Order-of-magnitude plausible for space-charge-free radius.
- §5.2 RMS / TF scaling: 0.15 cm RMS, 5–10 TFs, `σ_avg = 0.15/√N ≈ 0.047–0.067` cm. Stated resolution 0.002 cm requires `N ≈ 5625` TFs, not 5–10 — the "folded average" in the deck implies additional averaging beyond the N-TF stack (likely radial / azimuthal averaging of the per-TF maps). Worth clarifying for the reviewer.

### 9.4 Empty / duplicate slides (source-side)

| Slides | Status |
|---|---|
| 5, 19, 24, 38, 48, 53, 58 | Empty / section dividers |
| 40 vs 41 | Near-duplicate: Bz = −0.5 T vs +0.5 T of the same plot |
| 52 vs 54 | Near-duplicate: two "Status" slides with overlapping content |
| 26 vs 27 | Near-duplicate: DCA time-evolution model text repeated |

---

## 10. Related wiki pages

Consolidated outgoing internal links — single place the lint script and human reviewers can check for missing targets.

| Link | Referenced from | Status |
|---|---|---|
| [`../TDR/tpc.md`](../TDR/tpc.md) | §2 (material-budget impact on TPC); §3 (distortion decomposition); §4 (dX calibration, ITS-out issues); §5 (ITS-TPC-TRD interpolation); §8.2 (unbinned residual extensions) | **live (wiki-v2, APPROVED WITH COMMENTS)** |
| [`../TDR/its.md`](../TDR/its.md) | §1 (ITS alignment primary topic); §4 (ITS-out anomaly); §5.1 (ITScluster as fit anchor); §7 (ITS+TPC+TRD+TOF alignment) | live (DRAFT, wiki-v1) |
| [`../TDR/trd.md`](../TDR/trd.md) | §1.3 (ITS+TRD → TPC global fit); §5.1 (TRD residuals in fit cascade); §7 (TRD alignment); §8.3 (TRD tracklet info) | live (DRAFT, wiki-v2) |
| [`../TDR/t0v0zdc.md`](../TDR/t0v0zdc.md) | TOF (fourth alignment leg, §7) — T0V0ZDC page doesn't currently cover TOF; if/when TOF-SoT is added, cross-link here | planned |
| [`./PWGPP-643_combined_shape_estimator.md`](./PWGPP-643_combined_shape_estimator.md) | §3.1 shared Python dfextensions / GroupByRegressor toolkit; §3.3 rate-scan analytical formula connects to PWGPP-643 §3.4 weight-fluctuation framework | live (DRAFT, wiki-v1) |
| [`../documents/ALICE-TDR-019_O2_computing.md`](../documents/ALICE-TDR-019_O2_computing.md) | §8.1 SoA compression framework — part of the O² system | planned |
| [`../code/dfextensions_toolkit.md`](../code/dfextensions_toolkit.md) | §3.2 AliasDataFrame / GroupByRegressor — reusable module that earns its own wiki page | planned |

Status values: `planned` (target file not yet created), `live` (target exists and has `review_status: APPROVED` or `DRAFT`), `broken` (target was live but was removed — lint-detected regression).

---

## 11. External references

### 11.1 Published papers

| Topic | Reference |
|---|---|
| TPC pad-plane performance | [JINST 2021 16 P03022 — DOI 10.1088/1748-0221/16/03/P03022](https://iopscience.iop.org/article/10.1088/1748-0221/16/03/P03022/pdf) |

### 11.2 Repositories / pull requests

| Item | URL |
|---|---|
| `dfextensions` / GroupByRegressor | [github.com/miranov25/O2DPG (feature/groupby-optimization)](https://github.com/miranov25/O2DPG/blob/feature/groupby-optimization/UTILS/dfextensions/groupby_regression/docs/README.md) |
| TRD tracklet info PR | [AliceO2 PR #14969](https://github.com/AliceO2Group/AliceO2/pull/14969) |

### 11.3 Indico / meetings

| Event | URL |
|---|---|
| Space-charge dashboard scan (event 1243742) | https://indico.cern.ch/event/1243742/contributions/5273456/attachments/2593976/4481262/spaceChargeDashboardScan.html |
| Primary presentation (this deck, event 1578036) | https://indico.cern.ch/event/1578036/contributions/6769875/ |
| LHC24as IFC instabilities snapshot (TPC meeting 27 Nov 2024) | https://indico.cern.ch/event/1382743/contributions/6251901/attachments/2975348/5237475/snapshot%20(29).pdf |
| Offline Week — Python Calibration Toolkit | https://indico.cern.ch/event/1589178/#323-development-of-pythonc-cal |

### 11.4 Internal repositories / working directories

- `/lustre/alice/users/miranov/NOTESData/alice-tpc-notes/JIRA/O2-6344/scanNew2/` — SM_CTP_Der_16x, CPM_CTP_Der_16x per-sector distortion scans (referenced §4.1).
- `/lustre/alice/users/miranov/NOTESData/alice-tpc-notes/JIRA/ATO-628/MLFit/smoothMaps/withTPCTRD/LHC25am.b5p.scan/567569.566kHz/` — charging-up snapshot plots (§5.2).
- Input dataset `apass3`: `/alice/data/2023/LHC23zzh/apass3/544121`.

---

## Appendix A: slide-to-section map

| Slide(s) | Section |
|---|---|
| 1 | §1.1 ITS alignment — observations |
| 2 | §1.2 Δq/pt bias in ITS "gap" regions |
| 3 | §1.3 Global alignment fit — linear regression |
| 4 | §1.4 Proposed solution |
| 5 | *(empty — section divider)* |
| 6 | Section header "Preliminary studies of material budget" |
| 7 | §2.1 LUT approximation and biases |
| 8 | §2.2 Ongoing calibration strategy |
| 9 | §2.3 Extrapolation bias quantitative estimate |
| 10 | §2.4 LUT-vs-Geo systematic |
| 11 | §2.4 LUT-vs-Geo systematic (detail) |
| 12 | "Improvement of the LUTs" section title |
| 13 | §2.5 Material-budget fit DCA deflection |
| 14 | §2.5 DCA deflection — ROOT canvas code |
| 15 | "Material budget fit — scaling" section title |
| 16 | §2.6 Radial scaling vs affine transformation |
| 17 | "Residual fit decomposition" section title |
| 18 | §2.5 Dy intercept at qpt=0 — per-sector breakdown |
| 19 | *(empty)* |
| 20 | Section header "Space point distortion time evolution and rate scan request" |
| 21 | §3.1 Factorization framework (time constants table) |
| 22 | §3.2 Python dfextensions toolkit |
| 23 | §3.3 Rate scan program — physical motivation |
| 24 | *(empty)* |
| 25 | Section header "Rate scan and time-dependent distortion calibration" |
| 26 | §3.3 Rate scan program — details (pp2025, run 567445) |
| 27 | §3.4 DCA bias time evolution — two-exponential model (duplicate of slide 26) |
| 28 | §3.3 LHC24as IFC instabilities reminder |
| 29 | §3.3 Rate scan procedure table |
| 30 | §3.5 A/C side asymmetry (time evolution) |
| 31 | §3.5 Residual asymmetry + group-by fit code |
| 32 | §3.6 d⟨Y,X⟩/d⟨IDC⟩ numerical derivative |
| 33 | §3.7 Crossing-point calibration R ≈ 146 cm |
| 34 | §3.8 Sector-edge calibration bias |
| 35 | §4.1 Global iterative calibration — first test |
| 36 | §4.3 Residual cluster-track fit-range dependence table |
| 37 | §4.2 ITS-out anomaly detail (data + MC, field scaling) |
| 38 | *(empty)* |
| 39 | §5.1 ITS+TPC+TRD interpolation fit cascade |
| 40 | §5.2 Charging-up snapshot estimator (Bz = −0.5 T) |
| 41 | §5.2 Charging-up snapshot estimator (Bz = +0.5 T, duplicate of 40) |
| 42 | §5.2 Charging-up B-field comparison (0.5 T vs 0.2 T) |
| 43 | §5.3 Distortion factorization (Δ(IDC) decomposition) |
| 44 | §5.3 Charging-up time evolution (fill begin vs 2 h) |
| 45 | §5.3 dZ vs dY coupling |
| 46 | §5.4 DCA sector-edge bias + tracking bias |
| 47 | §5.5 Work-in-progress snapshot |
| 48 | *(empty)* |
| 49 | §6.1 Pb-Pb apass2 C1/C2 fluctuations |
| 50 | §6.2 Bad-CTF tagging algorithm |
| 51 | §6.3 CTF rejection fractions (apass1) |
| 52 | §8 Status |
| 53 | *(empty)* |
| 54 | §8 Status (duplicate of 52 with re-worded text) |
| 55 | §8.1 SoA compression schema |
| 56 | §7.1 ITS+TPC+TRD+TOF alignment (overview) |
| 57 | §7.1 Iteration 0 — ITS-out anchored |
| 58 | *(empty)* |
| 59 | §7.2 Radial distortion + TRD/TOF misalignment |
| 60 | §8.2 Unbinned residual extensions (TPC) |
| 61 | §8.3 TRD tracklet information (PR #14969) |

---

## Appendix B: Notation quick reference

| Symbol | Meaning |
|---|---|
| `q/pt` | reconstructed charge over transverse momentum (GeV⁻¹) |
| `Δq/pt` | q/pt bias relative to expected |
| `tgl` | tangent of the longitudinal track angle |
| `vz` | primary-vertex z-coordinate |
| `DCA` | distance of closest approach |
| `ΔX`, `ΔY`, `ΔZ` | distortion / residual components in local TPC frame |
| `ωτ` | product of cyclotron frequency and drift time (dimensionless E×B mixing) |
| `IDC` | integrated digital current (TPC rate proxy) |
| `IFC` / `OFC` | inner / outer field cage |
| `GEM` | gas electron multiplier |
| `CPass0` / `apass1` / `apass2` / `apass3` | calibration / reconstruction pass identifiers |
| `IROC` / `OROC` | inner / outer readout chamber |
| `LUT` | lookup table (material budget approximation) |
| `COG` | centre of gravity (cluster position) |
| `CTF` | compressed time frame |
| `TF` | time frame |
| `SM` / `CPM` | stack map / cluster-plane map distortion-correction flavours |
| `MILLIPEDE` | global-fit alignment code |
| `PID` | particle identification |
| `dE/dx` | specific energy loss |
| `SoA` | structure-of-arrays (data layout) |
| `Numba` | Python JIT compiler used in dfextensions |

---

## Changelog

- **v0 → wiki-v1 (2026-04-19, this commit).** First indexing pass (Claude1). 61-slide deck indexed via `htmlpresent` fetch (architect-seeded URL) after content verification. Front-matter follows MIWikiAI SUMMARY v0.3 schema (`source_fingerprint.upstream[]` nested, `indexed_by`/`indexing_model` split, `peer_reviewers: [Claude1]` self-indexed, `known_verify_flags`, `wiki_sections_stubbed`, `slides_duplicated` including the three identified near-duplicates). Cross-links into TPC-SoT (live wiki-v2), ITS-SoT (live wiki-v1), TRD-SoT (live wiki-v2), PWGPP-643 (live wiki-v1) plus four `planned` entries. Source-verification depth: deck CONTENT-VERIFIED. Review cycle 0 (self-indexed); external cycle-1 peer review pending per MIWikiAI SUMMARY v0.3 §7.1 sprint-mode rules (max 3 findings, `[!]` or `[OK]` only).

---

*End of O2-6344 source-of-truth index, wiki-v1 (2026-04-19, review_cycle 0). Self-indexed by Claude1; external cycle-1 peer review pending per sprint §7.1. Document indexes a live working-progress JIRA ticket — staleness to be monitored; `source_last_verified` should update each time the deck is re-fetched and diffed.*

*No quota issues observed during indexing.*
