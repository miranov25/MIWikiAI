# Multiple Scattering and Curvature Contributions to TRD Midpoint Residual

**Author:** Claude2 (Main Reviewer, O2DistAI)  
**Date:** 2026-04-28  
**Context:** PHASE 0.4 — TRD+TOF alignment, pre-meeting estimate

---

## Question

Estimate the **multiple scattering** and **track curvature uncertainty** contributions to the **midpoint residual** in the ALICE TRD for pions at 1, 2, 5, and 10 GeV/c.

The midpoint residual is defined as:

$$\text{Res}_i = d_i - \frac{1}{2}(d_{i-1} + d_{i+1})$$

where $d_i$ is the cluster (tracklet) position at TRD layer $i$, and $d_{i-1}$, $d_{i+1}$ are measurements at the neighboring layers. This estimator removes any linear (straight-line) track component but is sensitive to:

1. **Multiple scattering** — random angular deflections in the layer material
2. **Track curvature mismatch** — the residual picks up the sagitta of the curved track; uncertainty in the track momentum translates into sagitta uncertainty

---

## Input Parameters

| Parameter | Value | Source |
|-----------|-------|--------|
| X/X₀ per TRD layer | **~2.5%** | Total TRD ~15% / 6 layers (ALICE TRD NIM paper) |
| Inter-layer spacing L | **~16 cm** | TRD radial extent ~80 cm (r = 290–370 cm), 6 layers, center-to-center = 80/5 |
| Layer thickness t | **~10 cm** | Radiator (~5 cm) + drift (3 cm) + amplification + readout |
| Magnetic field B | **0.5 T** | ALICE solenoid nominal |
| TPC momentum resolution δp/p | **~1–2%** | At 1–10 GeV/c (TPC standalone) |
| Pion mass | 139.6 MeV/c² | At p ≥ 1 GeV: β ≈ 1 |

---

## Calculation

### Step 1 — RMS scattering angle per layer (Highland formula)

$$\theta_0 = \frac{13.6 \text{ MeV}}{\beta c \, p} \sqrt{x/X_0} \left[1 + 0.038 \ln(x/X_0)\right]$$

With x/X₀ = 0.025:
- √(0.025) = 0.158
- ln(0.025) = −3.69
- Correction factor: 1 + 0.038 × (−3.69) = 0.86

$$\theta_0 \approx \frac{13.6 \times 0.158 \times 0.86}{p \text{ [GeV]}} = \frac{1.85 \text{ mrad}}{p \text{ [GeV]}}$$


### Step 2 — MS contribution to the midpoint residual

In the thin-scatterer model (measurement at each layer, then scattering), the midpoint residual picks up contributions from:

1. **Scattering at layer i** (dominant): deflects the particle between layers i and i+1, shifting d_{i+1} relative to the interpolation baseline. The contribution to the residual:

$$\sigma_{\text{inter}} = \frac{1}{2} \theta_0 \times L$$

2. **Scattering within layer i material** (sub-dominant): scattering in the first half of layer i's material displaces the particle at the measurement point within the layer itself:

$$\sigma_{\text{intra}} = \frac{\theta_{0,\text{half}} \times t/2}{\sqrt{3}} \approx \frac{36 \text{ μm}}{p \text{ [GeV]}}$$

   This is ~25% of the inter-layer term and adds in quadrature.

3. **Scattering at layers i−1 and i+1**: their linear contributions cancel exactly in the midpoint formula (by construction — the midpoint estimator removes linear deflections).

**Combined:**

$$\sigma_{\text{MS}}(\text{Res}_i) = \sqrt{\sigma_{\text{inter}}^2 + \sigma_{\text{intra}}^2} \approx \frac{152 \text{ μm}}{p \text{ [GeV]}}$$

The inter-layer term dominates (95% of the variance).

---

## Step 3 — Curvature (sagitta) contribution from momentum uncertainty

### The sagitta

A charged particle in a magnetic field B follows a circular arc with radius R = p/(0.3B). The midpoint residual measures the **sagitta** — the deviation of the middle point from the chord connecting the outer two:

$$s = \frac{L^2}{2R} = \frac{L^2 \times 0.3 B}{2p}$$

With L = 0.16 m, B = 0.5 T:

$$s = \frac{0.0256 \times 0.15}{2p} = \frac{1920 \text{ μm}}{p \text{ [GeV]}}$$

### Sagitta uncertainty from momentum resolution

If the track momentum is known with precision δp/p, the curvature 1/R has the same relative uncertainty. The uncompensated sagitta (after the track fitter subtracts its best-estimate curvature) is:

$$\delta s = s \times \frac{\delta p}{p} = \frac{1920}{p} \times \frac{\delta p}{p} \text{ μm}$$

| p (GeV/c) | Sagitta s (μm) | δs at δp/p = 1% (μm) | δs at δp/p = 2% (μm) |
|-----------|----------------|----------------------|----------------------|
| 1         | 1920           | 19.2                 | 38.4                 |
| 2         | 960            | 9.6                  | 19.2                 |
| 5         | 384            | 3.8                  | 7.7                  |
| 10        | 192            | 1.9                  | 3.8                  |

The full sagitta is large (mm scale) but the track fitter removes most of it. What remains is the sagitta uncertainty δs, which is O(1–40 μm) — comparable to or smaller than the MS contribution.

---

## Combined Results

All three contributions added in quadrature:

$$\sigma(\text{Res}_i) = \sqrt{\sigma_{\text{MS}}^2 + \delta s^2 + \sigma_{\text{intrinsic,midpoint}}^2}$$

where σ_intrinsic,midpoint = √(3/2) × σ_det ≈ 490 μm for σ_det ≈ 400 μm (the midpoint of 3 independent measurements with equal resolution has variance 1.5 × σ²_det).

| p (GeV/c) | θ₀ (μrad) | σ_MS (μm) | Sagitta s (μm) | δs at 1% (μm) | δs at 2% (μm) | σ_intrinsic (μm) | **σ_total at 1.5%** (μm) |
|-----------|-----------|-----------|----------------|---------------|---------------|-------------------|--------------------------|
| **1**     | 1850      | **152**   | 1920           | 19            | 38            | 490               | **514**                  |
| **2**     | 925       | **76**    | 960            | 10            | 19            | 490               | **496**                  |
| **5**     | 370       | **30**    | 384            | 4             | 8             | 490               | **491**                  |
| **10**    | 185       | **15**    | 192            | 2             | 4             | 490               | **490**                  |

(σ_total computed with δp/p = 1.5% as midpoint of 1–2% range)

### Breakdown: non-intrinsic contributions only

Isolating the physics contributions (MS + curvature) without intrinsic detector resolution:

| p (GeV/c) | σ_MS (μm) | δs at 1.5% (μm) | **σ_MS ⊕ δs** (μm) | Fraction of σ_intrinsic |
|-----------|-----------|-----------------|---------------------|-------------------------|
| **1**     | 152       | 29              | **155**             | 32%                     |
| **2**     | 76        | 14              | **77**              | 16%                     |
| **5**     | 30        | 6               | **31**              | 6%                      |
| **10**    | 15        | 3               | **15**              | 3%                      |

---

## Interpretation

**Multiple scattering dominates over curvature uncertainty at all momenta.** The MS contribution is 5–10× larger than δs across the 1–10 GeV range. This is because MS scales as 1/p while δs scales as (δp/p)/p — and at the 1–2% momentum resolution level, the curvature correction is already quite good.

- At **1 GeV/c**: MS (152 μm) + curvature (29 μm) = **155 μm combined** — 32% of intrinsic resolution. Both effects are significant for alignment.

- At **2 GeV/c**: MS (76 μm) + curvature (14 μm) = **77 μm combined** — 16% of intrinsic. MS still dominates; curvature is a small correction.

- At **5 GeV/c**: MS (30 μm) + curvature (6 μm) = **31 μm combined** — 6% of intrinsic. Both effects are sub-dominant corrections. This is the sweet spot for alignment extraction.

- At **10 GeV/c**: MS (15 μm) + curvature (3 μm) = **15 μm combined** — 3% of intrinsic. Negligible relative to detector resolution. Statistics become the limiting factor (fewer high-p tracks).

**Key insight:** The sagitta itself is large (1920 μm at 1 GeV, 192 μm at 10 GeV) — but the track fitter removes it using the measured momentum. Only the **uncertainty** in that removal (δs = s × δp/p) contributes to the midpoint residual. At 1–2% momentum resolution, this residual sagitta is small.

**For PHASE 0.4 alignment:** The optimal momentum window for TRD alignment extraction is **p ≈ 3–10 GeV/c**, where MS + curvature combined are below ~50 μm (10% of intrinsic) but track statistics are still adequate. Below 3 GeV, MS contamination is significant; above 10 GeV, statistics become sparse.

---

## Notes

- Layer spacing L = 16 cm is approximate (center-to-center of adjacent chambers). The actual measurement-point-to-measurement-point distance depends on whether the tracklet position is reconstructed at the anode plane (outer edge of drift region) or at the chamber midpoint.

- The X/X₀ = 2.5% per layer is an average. Material distribution within a layer is non-uniform (pad plane ~0.8% X/X₀, radiator foam ~0.5%, gas ~0.2%, support structures ~1%). The Highland formula with average X/X₀ is accurate to ~10%.

- For the z-direction midpoint residual, the same MS formula applies — scattering is isotropic in the small-angle limit.
