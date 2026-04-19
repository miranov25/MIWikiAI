---
wiki_id: PWGPP-643
title: Combined Event Shape and Event Multiplicity Robust Estimators
project: MIWikiAI / ALICE
folder: presentations
source_type: presentation
source_status: PARTIAL — §5 Run-3 section is a stub (slides 22–23 are title/placeholder only); see wiki_sections_stubbed + §5 callout
source_fingerprint:
  upstream:
    - id: PWGPP-643-slides
      title: "PWGP-643-combinedShapeEstimator"
      slide_count: 56
      url: "https://docs.google.com/presentation/d/1mU-HD_78UC6E1WgAYUTCJdhLRBbd5uKYtQkv6vjAd8o"
      htmlpresent_url: "https://docs.google.com/presentation/d/1mU-HD_78UC6E1WgAYUTCJdhLRBbd5uKYtQkv6vjAd8o/htmlpresent"
      slides_empty_or_stub: [21, 22, 23, 25, 35, 38, 39, 41, 45, 50]
      slides_duplicated: [[12, 46], [15, 16]]
      sections_cited: ["slide 1–56, full deck"]
  summary_contributors: [{id: Claude1, role: indexer}]  # schema TBD per MIWikiAI SUMMARY §7.3 (summary_contributors unification)
source_title: PWGP-643-combinedShapeEstimator
source_last_verified: 2026-04-19
author: Marian Ivanov (UK Bratislava / CERN / GSI / UniHeidelberg)
jira_ticket: PWGPP-643
indexed_by: Claude1
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 1
peer_reviewers: [Claude1]  # self-review; external cycle-2 peer review pending per MIWikiAI SUMMARY §7 step 3
hard_constraints_checked: {correctness: partial, reproducibility: partial, safety: verified}
staleness: fresh
known_verify_flags:
  - "§2.3 T0-A / T0-C sign convention: slide 6 wording contradicts ALICE A-side = +z convention; source-deck resolution owed (see §2.3 footnote + §8.2 item #1)"
  - "§4.5 slide-49 triple citation of L331-L351 likely a source-slide copy-paste error; verify against repo (§8.2 item #2)"
  - "§5 Run-3 setup: slides 22–23 are placeholders; section is [STUB] awaiting either source-deck expansion or Mattermost-exchange content (§8.2 item #3)"
  - "§3.1 slide-10/11 empirical power-scaling formulas are plot-rendered; exact-formula extraction from eventShapeEstimator.py deferred (§8.2 item #4)"
  - "§3.4 weight-fluctuation statements on slides 15 vs 16 may be near-duplicates; verify semantic equivalence (§8.2 item #5)"
  - "§1.1 slide 3 'Slide 2 and 6 to be ported here' — source-deck completion owed (§8.2 item #6)"
wiki_sections_stubbed: ["§5 Run 3 setup (slides 22–23 are title/placeholder only in source deck)"]
---

# PWGPP-643: Combined Event Shape and Event Multiplicity Robust Estimators

## TL;DR

Standard ALICE event-shape and multiplicity estimators (spherocity, aplanarity, transverse thrust, flattenicity, ...) rely on tracked particles in `η ∈ (-1, 1)`. Forward detectors (T0, V0, FMD, ITS tracklets) span `η ∈ (-3.7, 5.1)` with ~0.5 channel-width granularity in η and nearly full φ coverage. Combining these detectors with **robust statistics** (truncated mean, weighted mean, MLE fits) is expected to:

- improve resolution of multiplicity / flow / event-plane estimators by factor **~2** from rapidity-range scaling alone (`σ ∝ 1/√Δy`),
- improve resolution at **peripheral events (centrality 60–90%)** by factor **~2–3** vs. tracking-only estimators,
- enable **event-by-event** flow and event-plane determination (angular resolution ~0.2 at centrality 40–50%).

The work also produces a **reusable software module** — `quantile_fit_nd` in `AliceO2Group/O2DPG` — for detector-agnostic, monotonic amplitude→rank calibration with nuisance parameters (vertex-z, η, time).

**Source of truth**: 56-slide Google Slides deck. Every section below cites the originating slide(s).

---

## 1. Physics motivation

### 1.1 Particle production across collision systems

**Slide 3.** Comparative study of particle production in pp, p-Pb, and Pb-Pb collisions:

- Enhanced `Λ/K` ratio observed at intermediate `p_T` across **high-multiplicity events** in all three systems (pp, p-Pb, Pb-Pb), compared to low-multiplicity events.
- Multi-strange particle production increases with multiplicity, with similar trends across collision systems.

> **`[STUB — awaiting source-deck completion]`** Slide 3 contains the source-deck note *"Slide 2 and 6 to be ported here:"* followed by the Cui KEK reference (source-verified via `htmlpresent` fetch, 2026-04-19). The source author has marked slide 3 as awaiting material to be ported from slides 2 and 6 of the Cui deck. Resolution path: author either ports the missing material into PWGPP-643 slide 3 (and re-indexes this wiki section), or promotes the Cui-deck reference as the authoritative source here. See §8.2 item #6. This is the pattern TRD-SoT later formalized as `wiki_sections_stubbed`; a stub-class mirror is present in this page's front-matter.

References:
- <https://arxiv.org/pdf/1606.07424>
- <https://arxiv.org/abs/2201.12578>
- P. Cui, conference-indico.kek.jp event 33: <https://conference-indico.kek.jp/event/33/contributions/687/attachments/432/461/P_Cui.pdf>

### 1.2 Particle production in jets vs. underlying events

**Slide 4.** Comparison of `Λ/K_S^0` ratio and strange-hadron density across three event classes:

| Event class | Observation |
|-------------|-------------|
| Underlying event (UE) | `Λ/K_S^0` consistent with inclusive |
| In-jet (JE) | Ratio differs from inclusive at low and intermediate `p_T`; strange-hadron density **harder** than in UE |
| UE (no jet) | Distributions **harder** than inclusive → jets bias inclusive measurement |

Numerical context given on the slide:

- Typical particle multiplicity within a jet: **10–20 particles**.
- In high-multiplicity pp events: jet, dijet, and multi-jet production are dominant.
- In p-Pb: jets can comprise a substantial fraction of observed particles.

**Implication.** Robust classification of jet vs. underlying-event contributions is essential — and the proportion varies substantially across pp / p-Pb / Pb-Pb. Focusing on single jets alone is insufficient.

---

## 2. The combined estimator proposal

### 2.1 Limitations of standard estimators

**Slide 5.** Standard event-shape estimators (spherocity, aplanarity, transverse spherocity, transverse thrust, "flattenicity") rely on particle momentum measurements in the ALICE tracking acceptance — `η ∈ (-1, 1)`.

**Slide 5 quantitative argument.** In Pb-Pb with low impact parameter (centrality 60–90%, `dN/dη ≈ 15–50`), the multiplicity and flow determination is significantly contaminated by jet contributions. Forward detectors (T0, V0, FMD, ITS tracklets) have channel width `Δη ≈ 0.5` over the wide range `η ∈ (-3.7, 5.1)`, giving a factor **~2** better resolution from rapidity-range scaling alone (`∝ 1/√Δy`).

### 2.2 Robust-statistics toolkit

**Slide 5.** Three-part recipe:

1. **Robust statistics per channel** — truncated mean, weighted mean, MLE fits — applied to flow coefficients and multiplicity estimators.
2. **Geometrical selection** in `(φ, θ)` — truncated mean within 3D cones of radii `R ∈ {0.2, 0.3, 0.4}`.
3. **Uniform treatment of unbinned and binned data** across detectors (T0, V0, FIT, tracklets, tracks).

### 2.3 Detector chain

**Slides 5–6.** The combined estimator chains detectors in η order:

```
T0-C → V0-C (+ FMD) → ITS tracklets (+ tracks + TOF + calo) → V0-A (+ FMD) → T0-A
```

ALICE detector positions (z from interaction point):

| Detector | z position | η coverage notes |
|----------|-----------|------------------|
| T0-C | +375 cm (muon-absorber side) | forward |
| T0-A | −70 cm | forward opposite |
| V0-C | −90 cm | closer to IP, C-side |
| V0-A | +340 cm | A-side, far |
| ITS tracklets | between V0s | typically `η ∈ (-2, 2)` |
| Calorimeters | — | `η ∈ (-1, 1)` |
| Tracks + TOF | — | `η ∈ (-1, 1)` |

> **Note on sign convention.** The slide text gives *"T0-C at +375 cm ... T0-A at -70 cm"* — inconsistent with the ordering `T0-C → ... → T0-A` that implies T0-C is upstream of the ITS/tracklet region, and with ALICE convention (A-side = +z, non-muon-spectrometer side). **Source-verified from slide 6 of the deck (`htmlpresent` fetched 2026-04-19):** the ambiguity is in the source deck itself, not a wiki transcription error. Slide 6 literally reads *"T0-C (C-side): Located towards the muon absorber side, at +375 cm from the interaction point."* The wiki preserves the source wording as-written and flags the discrepancy — resolution requires author action on the source deck, not a wiki edit. See §8.2 item #1.

### 2.4 Expected improvement

**Slide 6.**

- Full η coverage + robust estimators → relative error reduced as `1/√N`.
- Peripheral regime (centrality 70–90%, low multiplicity): expected improvement factor **~2–3** vs. tracking-only estimators in `η ∈ (-1, 1)`.

Primary reference: ALICE Collaboration, *Centrality dependence of the charged-particle multiplicity density at mid-rapidity in Pb-Pb at √s_NN = 2.76 TeV*, Phys. Lett. B **754** (2016) 373–385. <https://www.sciencedirect.com/science/article/pii/S0370269316000678>

### 2.5 ML-assisted precision optimization

**Slide 7.** Two optimization targets:

1. **Multiplicity across rapidity intervals** — find an estimator producing the closest-aligned multiplicity measurement across different η regions.
2. **Flow coefficients across rapidity intervals** — same for event-shape / flow coefficients.

Cost functions to compare: absolute, relative, and pull-based.

- **Data-only optimization**: predict value in one η interval from values in other intervals.
- **MC optimization**: use MC-true values as ground truth.
- Compare both to validate MC-independence of the data-driven method.

### 2.6 Open questions (plans)

**Slide 8.** Still to be done:

- Fast simulation with Poisson production and weight fluctuation (detector response), on both unbinned and binned data.
- Pythia demonstration for unbinned + binned + combined estimators — **open question: which Pythia settings for pp and Pb-Pb?**
- Physics observables to present:
  - Particle-ratio consistency/variation.
  - Multiplicity-estimator improvement vs. centrality and multiplicity.
  - Flow-estimator improvement vs. centrality and multiplicity.

---

## 3. Run 2 results

### 3.1 Multiplicity quantile scaling

**Slide 10.**

- Multiplicity quantiles scale approximately as a **power of multiplicity** at ALICE energies with exponent `x ≈ 0.25`, for both the combined estimator and the central-η estimator.
- Two compared estimators:
  - `V0A + V0C + tracklet` estimator → `η ∈ (-3.5, 5)`.
  - `primMult` estimator → `η ∈ (-1, 1)`.
- Deviations from power scaling at the edges (quantile `→ 0` and `→ 1`) attributed to:
  - **Quantile → 0**: relative precision of measurement.
  - **Quantile → 1**: residual pile-up, edge bias, and neutral component of the multiplicity "skin."
- Edge σ (quantile error) is **smaller** at edges due to selection bias.
- Empirical formulas (power-scaling for quantile and quantile error) given on slide but formula content is **visual/plot-bound** — not in extractable text.

### 3.2 Combined quantile multiplicity in η bins

**Slide 11.** Per-detector segmentation:

| Detector | Native granularity in η |
|----------|------------------------|
| V0, T0 | ~0.5 (natural) |
| ITS tracklets | artificial bins |
| Tracks (in overlap region) | ~0.25 |

Method: compute the quantile of the multiplicity distribution in each small segment, compare to global quantile, extract std. The resolution scales with relative multiplicity fluctuation `~ 1/√N`.

- `K_q` (scale factor in empirical formula) depends on `dN/dη` in the interval.
- Edge-quantile σ smaller due to selection bias (same as 3.1).
- 2D "robust statistics" (truncated mean, global event-shape fit) impact — **to be shown** (open).

### 3.3 V0 A-side hardware anomaly

**Slides 12 & 46 (duplicate content).**

- Precision of combined quantile V0 estimator on A-side **saturates at 2%**, while other detectors improve to **~1%**.
- Observed pathology: **double-peak structure** in V0 time on A-side for channels `> 31`, dependent on `Q` and `v_z`.
- Hypothesis: hardware problem in V0.
- Design goal: robust flow/centrality estimator that **corrects or down-weights** the anomalous contribution.

### 3.4 Fast simulation and analytical approximation

**Slides 13, 15, 16.**

Fast-simulation chain:

```
Centrality → Mean multiplicity → Multiplicity (Poisson)
           → Angular distribution (with input flow)
           → Detector response (weight smearing)
```

Detector-response simulation elements (modeled after TPC full MC per [arxiv/physics/0306108](https://arxiv.org/pdf/physics/0306108.pdf)):

- Efficiency >90% for tracklets and tracks (Bernoulli).
- Secondary particle production.
- Landau + gas-gain fluctuation of energy deposit (V0, T0).
- Jet production.

Analytical formula (approximation of eq. 8 in `arxiv/physics/0306108`): resolution modification under weight fluctuation. With exponential weight fluctuation (`σ_w/⟨μ_w⟩ = 1`, typical gas-gain model), the resolution scales as `√(1 + 1²) ≈ 1.41` over a wide multiplicity range.

> **Cross-reference (two-way link).** This analytical residual-distortion modelling is the target of the cross-link from [TPC §7.2 step 4 — residual correction / ITS–TRD interpolation](../detectors/tpc.md) (TPC wiki-v2, refined in ClaudeOpus47 cycle-1 review P2.3 and confirmed in Claude3 cycle-2 review). The `arxiv/physics/0306108` weight-fluctuation framework is the shared formalism between the two pages — the TPC space-charge-distortion residual map uses the same fluctuation-under-weight treatment this section summarizes.

Input references:
- Elliptic flow in Pb-Pb at √s_NN = 2.76 TeV: <https://www.arxiv.org/pdf/1011.3914>
- Weight fluctuation derivation (CHEP 2003): <https://arxiv.org/pdf/physics/0306108.pdf>
- Space-charge distortion fluctuation (TPC TDR 2013, p. 94): <https://cds.cern.ch/record/1622286/files/ALICE-TDR-016.pdf>
- Upgrade of ALICE forward detectors: <https://cds.cern.ch/record/2703022/files/PoS%28ICHEP2018%29255.pdf>

### 3.5 Event-plane angular resolution

**Slides 14, 17.**

- Target: event-by-event flow + centrality + event-plane with high precision.
- At centrality 40–50% (median quantile 0.5): angular resolution for `v_2` ≈ **0.2 rad** — sufficient for HBT measurements relative to the event plane.
- Scaling formula (code alias from slide 17):

```
angleE = 1 / (√2 · √N_particles · fraction)
```

where `fraction` is the mean `v_2` fraction (at ALICE, `v_2 ≈ 0.1`), giving `1/v_2 ≈ 10`. Without weight fluctuation, the angular error scales as `1/√N_particles · 1/fraction`. Pull distribution `ΔA/σ_A` scales as expected.

### 3.6 Flow `v_2` reconstruction resolution

**Slide 18.**

- V0 resolution scales as `√(0.5/N_particles)`.
- At quantile > 0.4 (i.e., more central), `σ_{v_2} < 0.02`.
- Code alias: `v2Err = √0.5 / √N_particles`.
- **Bias warning**: at low multiplicity where `v_2 ≲ σ_{v_2}`, the reconstructed flow is **biased toward higher values**.

### 3.7 Weight-fluctuation impact

**Slides 19, 20.**

Two response functions considered:

1. **Exponential** (gas-gain approximation, `σ_w/⟨w⟩ ≈ 1`):
   - Multiplicity-resolution modification factor: `√(1 + 1²) ≈ 1.41` over a wide multiplicity range.
   - Flow-resolution modification: same `√2 ≈ 1.41` factor — verified as `1.33 / 0.945 ≈ 1.407`.

2. **Bernoulli** (efficiency simulation):
   - Near 100% efficiency: modification negligible.
   - 95% efficiency: factor ≈ **1.02**.
   - 90% efficiency: factor ≈ **1.05**.

<!-- derivation (Bernoulli weight-fluctuation): for detection probability p, the multiplicity-resolution modification is √(1 + (1-p)/p) = √(1/p). 
     p = 0.95 → √(1/0.95) = √1.0526 ≈ 1.026; stated as 1.02 (rounded).
     p = 0.90 → √(1/0.90) = √1.1111 ≈ 1.054; stated as 1.05.
     Both match the formula within rounding; the √(1 + σ_w²/⟨w⟩²) pattern reduces to √(1/p) for Bernoulli-weighted Poisson. -->

The resolution-scaling approximation is valid over a wide range of multiplicities.

---

## 4. Detector calibration details

### 4.1 Vertex-z and detector calibration

**Slide 42.**

- Normalize all detectors to a common reference (`primMult`).
- Two-step calibration:
  1. Linear detectors → normalize to average multiplicity.
  2. Non-linear correction → normalize to average (over all).
- Weighting options: weighted mean (weights = variation) **or** simple mean.
- Cross-check: prediction from reference detector (ZDC).

### 4.2 Detector η coverage (calibration perspective)

**Slide 43.** Same ordering as §2.3, reiterated:

```
T0-C → V0-C → tracklets (+ track + TOF + calo) → V0-A → T0-A
```

### 4.3 V0 A-side time amplitude anomaly

**Slide 44 header, detail on slide 46** — see §3.3 above.

### 4.4 T0 single-channel resolution (Run 2)

**Slide 48.** Source: [arXiv:1610.03055](../documents/arxiv_1610_03055_T0_detector.md) (wiki) — original PDF <https://arxiv.org/pdf/1610.03055>

| Quantity | Value |
|----------|-------|
| T0 intrinsic time resolution at low multiplicity (single MIP) | ~**50 ps** |
| T0 intrinsic time resolution at high multiplicity | ~**25 ps** |
| TDC bin width (quantization) | **25 ps** |
| Cherenkov channels on A-side | **12** |
| Cherenkov channels on C-side | **12** |
| Theoretical z-vertex resolution floor (from quantization) | `σ_z ≈ 0.15 cm` |

Derivation of the `σ_z` floor: `ΔT/√6` converted by `c/2` to spatial. The per-channel resolution saturates at high multiplicity because TDC quantization — not particle statistics — becomes dominant.

Channel-to-channel spread is significant (different η coverage, different channel characteristics). The **weighted mean** (with MAD as error estimator) is required to reveal the true intrinsic detector resolution by mitigating channel non-uniformities.

### 4.5 T0 z-vertex resolution — observed vs. theoretical

**Slide 49.**

- Observed asymptotic limit at high multiplicity (`1/n_prim → 0`): `σ_z ≈ **0.18 cm**`.
- Consistent with the **0.153 cm theoretical electronic limit** → confirms TDC-quantization dominance.
- Simple mean vs. weighted mean: **~20% gap** — demonstrates the necessity of weighted-mean methodology.

Calibration, error parametrization, time-to-vz calibration, weighted-mean definition, and drawing implementations are all in:

- <https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/b823d35b/JIRA/PWGPP-643/eventShapeEstimator.py#L331-L351> (calibration, error parametrization, time→vz — cited three times on slide 49, all the same range)
- <https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blame/b823d35b/JIRA/PWGPP-643/eventShapeEstimatorDraw.C#L40-L59> (weighted-mean definition)
- <https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blame/b823d35b/JIRA/PWGPP-643/eventShapeEstimatorDraw.C#L18-L38> (drawing)

> **Flag for reviewer**: slide 49 cites the same Python line range (`L331-L351`) for three different purposes (calibration, error parametrization, time→vz). **Likely a copy-paste error in the source slide** — the actual implementations are probably in three distinct line ranges. Verify against repository.

### 4.6 T0 outliers and event-shape dependence

**Slide 56 (also back-referenced from slide 48).**

- Some runs show significantly worse T0 resolution — attributed to **event-shape dependence**.
- Mitigation: cut on `primMult`.
- Example: run `297315`.
- Modification to `isTime0` flag for calibration: `tZeroMult > 0.25 && primMult > 2`.

---

## 5. Run 3 setup `[STUB — awaiting source-deck expansion or Mattermost-exchange content]`

**Slides 22, 23.** Title/placeholder only in the source deck (verified 2026-04-19 via `htmlpresent`):
- Slide 22: title only (*"Run3 setup"*).
- Slide 23: title *"RUN 3 setup"* with note *"Mattermost exchange with Igor"* — slide body is empty; the Mattermost-exchange content lives outside the deck.

This wiki section is held as a stub per the project's `source_status: PARTIAL` convention (see front-matter `wiki_sections_stubbed`). Known anchors to be populated when Turn-2 source content is delivered:

- Run-3 detector chain differences from Run-2 (§2.3 / §4.2 were Run-2; forward-detector configurations in Run 3 differ, notably FIT replacing T0/V0 as the fast-interaction trigger).
- Relation to [TPC continuous readout §6.7](../detectors/tpc.md) and the O² computing system ([TDR-019](https://cds.cern.ch/record/2011297)).
- Relation to [ITS2 continuous readout §3.6](../detectors/its.md).

Resolution path: author either expands slides 22–23 in the source deck (preferred), or supplies the Mattermost-exchange content as a supplementary reference that this wiki section then indexes.

---

## 6. Generic quantile regression (`quantile_fit_nd`)

A reusable software module — sibling outcome of PWGPP-643 — living in `AliceO2Group/O2DPG`.

**Indexed code wiki page**: [quantile_fit_nd](../code/quantile_fit_nd.md)

**Repository:**
- Spec: <https://github.com/AliceO2Group/O2DPG/blob/ec9f4249acf20c5178502b7e0aee6989f15bdd35/UTILS/dfextensions/quantile_fit_nd/quantile_fit_nd.md>
- Benchmarks: <https://github.com/AliceO2Group/O2DPG/blob/ec9f4249acf20c5178502b7e0aee6989f15bdd35/UTILS/dfextensions/quantile_fit_nd/bench_quantile_fit_nd.py>

### 6.1 Goal (slide 52)

Build a detector-agnostic, **monotonic** mapping between amplitude `X` and quantile rank `q`, stable against nuisance parameters (e.g., vertex-z `v_z`, η, time), so different detector channels can be combined on a common scale.

### 6.2 Local inverse-quantile model (slide 52)

```
X(q, n) ≈ a(q₀, n) + b(q₀, n) · (q − q₀),    b > 0
```

- Per-channel fit on sliding windows `|q − q₀| ≤ Δq` (default **`Δq = 0.05`**).
- Nuisance axes `n`: initially `z`, later `η`, time. Interpolated separably (linear or PCHIP).
- Output table: `(a, b, σ_Q)` on grid `(channel, q₀, n_centers)`.

**Why quantile ranks?** Removes gain/saturation scale issues across detectors and enforces a common monotone coordinate for combination and QA.

### 6.3 Fit recipe (slide 53)

Per channel, per `n`-bin, per `q₀`:

1. Select window `|q − q₀| ≤ Δq`, exclude `is_outlier = True`.
2. OLS fit: `X = a + b (q − q₀)`.
3. Store `(a, b)`, residual scatter `σ_{X|Q}`, diagnostics.

### 6.4 Uncertainty on rank (slide 53)

```
σ_Q ≈ σ_{X|Q} / |b|
```

- Monotonicity in `q`: enforce `b ≥ b_min` (configurable; `auto` or fixed).
- Smoothness in nuisance axes: linear (default) or shape-preserving spline. **Only `q` must be monotone.**

### 6.5 Handling discrete inputs (slide 53)

For discrete inputs (tracks, clusters, Poisson), convert to continuous ranks before fitting:

- **Randomized PIT (preferred)**:
  ```
  U = F(k − 1) + V · [F(k) − F(k − 1)],     V ~ Uniform(0, 1)
  ```
- **Mid-ranks (deterministic)**:
  ```
  U = [F(k − 1) + F(k)] / 2
  ```

### 6.6 Using the calibration (slide 54)

Stored table columns (per grid point):

```
channel_id, q_center, z_center, a, b, sigma_Q, fit_stats(json), [db/dz, dX/dN, ...]
```

Runtime evaluation / inversion:

- Interpolate `(a, b, σ_Q)` over nuisance axes.
- Invert rank for a measured `X`:
  ```
  q ≈ q₀ + (X − a) / b
  ```
  with safe bracketing / clipping at edges.

Time-series monitoring:

- Append timestamped rows → track drift `Δa, Δb`.
- Compare runs at **10–30 min cadence**.

Combination properties:

- Common rank scale across channels.
- Per-channel weights `w = 1 / σ_Q²`.
- Explicit diagnostics for QA and ML pipelines.

### 6.7 Benchmark highlights (slide 55)

Setup for the reported benchmark:

| Parameter | Value |
|-----------|-------|
| Distributions | uniform, Poisson (via PIT), Gaussian |
| Quantile grid step | 0.025 |
| Window `Δq` | 0.05 |
| `z_bins` | 20 |
| Poisson `λ` | ≈ 50 |

Observed scaling (log–log):

| Metric | Scaling | Exponent | Tolerance |
|--------|---------|----------|-----------|
| Fit error `rms_b` | `∝ N^{−1/2}` | `α_b ≈ −0.5` | `\|α_b + 0.5\| < 0.05` (from log–log linear-fit residual on 4+ `N` samples in `bench.log`) |
| Round-trip RMS | ≈ constant | `α_rt ≈ 0` | `\|α_rt\| < 0.05` (flat-line test; dominated by per-event noise `σ_{X|Q} / b`) |

> **Reproducibility note.** The "within tolerance" assessment assumes a log–log linear fit over the benchmark's N-scan range with residual exponent tolerance ±0.05. The tolerance is not documented in the source slide 55 — this is an indexing-side pinning to make the claim reproducible. If the source author has a different tolerance in mind, flag for §8.2 update.

Typical numerical values:
- `rms_rt ≈ 10⁻²`, flat vs. `N`, for all three distributions.
- `rms_b · √N` is roughly constant — sanity check on the `N^{−1/2}` scaling.

Reproducer:
```
python bench_quantile_fit_nd.py --plot > bench.log
```

---

## 7. External references

### 7.1 Primary physics papers (arXiv / journals)

| Topic | Reference |
|-------|-----------|
| Particle production in pp/p-Pb/Pb-Pb | <https://arxiv.org/pdf/1606.07424> |
| Strange-particle ratios | <https://arxiv.org/abs/2201.12578> |
| Elliptic flow in Pb-Pb at √s_NN = 2.76 TeV | <https://www.arxiv.org/pdf/1011.3914> |
| Weight fluctuation (CHEP 2003) | <https://arxiv.org/pdf/physics/0306108.pdf> |
| ALICE Pb-Pb multiplicity density (Phys. Lett. B **754**) | <https://www.sciencedirect.com/science/article/pii/S0370269316000678> |
| ALICE experiment performance paper | <https://arxiv.org/pdf/1402.4476> |
| T0 detector resolution (Run 2) | <https://arxiv.org/pdf/1610.03055> |
| CME event-shape methods (systematic study) | <https://arxiv.org/pdf/2407.14489> |
| Long-range anisotropies in high-multiplicity jets (pp 13 TeV) | <https://arxiv.org/pdf/2312.17103> |
| ZDC event-plane determination (CEE) | <https://arxiv.org/pdf/2302.11759> |
| Elliptic flow review | <https://arxiv.org/pdf/1102.3010> |
| Referenced on slide 26 (context unclear) | <https://arxiv.org/pdf/2108.03471> |
| Jet-hadron correlations vs. 2nd-order event plane | <https://cds.cern.ch/record/2696228/files/1910.14398.pdf> |
| CMS multijet measurement | <https://cms-results.web.cern.ch/cms-results/public-results/publications/SMP-21-006/index.html> |

### 7.2 ALICE technical notes / TDRs

- TPC TDR 2013: <https://cds.cern.ch/record/1622286/files/ALICE-TDR-016.pdf>
- ALICE forward-detector upgrade (PoS ICHEP2018): <https://cds.cern.ch/record/2703022/files/PoS%28ICHEP2018%29255.pdf>
- Event-plane resolution `R_{Ψ2}` figure: <https://alice-figure.web.cern.ch/node/15063>

### 7.3 Code and notes repositories

- `AliceO2Group/O2DPG` — `quantile_fit_nd` module spec: <https://github.com/AliceO2Group/O2DPG/blob/ec9f4249acf20c5178502b7e0aee6989f15bdd35/UTILS/dfextensions/quantile_fit_nd/quantile_fit_nd.md>
- `AliceO2Group/O2DPG` — benchmark: <https://github.com/AliceO2Group/O2DPG/blob/ec9f4249acf20c5178502b7e0aee6989f15bdd35/UTILS/dfextensions/quantile_fit_nd/bench_quantile_fit_nd.py>
- `alice-tpc-notes` / PWGPP-643 / `eventShapeEstimator.py`: <https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blob/b823d35b/JIRA/PWGPP-643/eventShapeEstimator.py>
- `alice-tpc-notes` / PWGPP-643 / `eventShapeEstimatorDraw.C`: <https://gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/-/blame/b823d35b/JIRA/PWGPP-643/eventShapeEstimatorDraw.C>

### 7.4 Related presentations & meetings

- AOT meeting June 2024 (Jun-Lee Kim, Event Plane / DPG): <https://indico.cern.ch/event/1422461/> — contribution: <https://indico.cern.ch/event/1422461/contributions/5999214/attachments/2876750/5038137/DPG_AOT_EP_20240613_junleekim.pdf>
- ALICE Week 09/07/2024 — L. Serkin, *Exploring isotropic events in pp collisions using the flattenicity event-shape variable*: <https://indico.cern.ch/event/1425523/contributions/5995735/attachments/2893311/5072355/LSerkin_ALICEweek_090724.pdf>

### 7.5 Textbook reference

- C. A. Pruneau, *Data Analysis Techniques for Physical Scientists*, Cambridge University Press. Page 37 (Standard Event-Plane Method) cited. <https://www.cambridge.org/core/books/data-analysis-techniques-for-physical-scientists/F362CA4BE2AEFC9D91A6BA5A452D6285>

---

## 8. Open items and reviewer-validation checklist

### 8.1 Author-originated open questions (from slide 8)

- [ ] Which Pythia settings for pp vs. Pb-Pb fast simulation?
- [ ] Particle-ratio consistency/variation across estimator settings — to be shown.
- [ ] Multiplicity-estimator improvement vs. centrality/multiplicity — to be shown.
- [ ] Flow-estimator improvement vs. centrality/multiplicity — to be shown.
- [ ] Impact of 2D robust statistics (truncated mean + global event-shape fit) — to be shown (slide 11).

### 8.2 Indexing flags raised in this pass (for reviewer to resolve)

| # | Section | Issue | Severity |
|---|---------|-------|----------|
| 1 | §2.3 | T0-A / T0-C z-position signs appear inconsistent with the stated detector-ordering chain. Confirm ALICE sign convention. | P1 |
| 2 | §4.5 | Slide 49 cites the same Python line range (`L331-L351`) for three different purposes — likely a source-slide typo; verify actual line ranges in repository. | P2 |
| 3 | §5 | Run 3 setup section is a stub — slides 22–23 contain only a title and a "Mattermost exchange with Igor" note. Needs sourcing from another artifact before this wiki page is complete. | P1 |
| 4 | §3.1 | Empirical power-scaling formulas on slides 10–11 are plot-rendered, not extractable from the HTML text view. **Source code** in `eventShapeEstimator.py` presumably has the exact formula — needs extraction for faithful indexing. | P1 |
| 5 | §3.4 | Formula "σ_w/⟨μ_w⟩ = 1" appears twice with slightly different framing (slide 15 vs. slide 16). Confirm these are the same statement. | P2 |
| 6 | §1.1 | Slide 3 says "Slide 2 and 6 to be ported here" — indicates the slide is itself a work-in-progress stub pulling content from another deck (P. Cui link). Mark as potentially incomplete. | P2 |

### 8.3 Empty / stub / duplicate slides observed

Source-of-truth for this information is now the front-matter fields `source_fingerprint.upstream[0].slides_empty_or_stub` and `slides_duplicated`. Summary for human readers:

| Slide(s) | Content status | Front-matter field |
|-------|---------------|---------------------|
| 21, 22, 23, 25, 35, 38, 39, 41, 45, 50 | Empty or title-only | `slides_empty_or_stub` |
| 22–23 | Run 3 stub (§5 wiki callout) | `wiki_sections_stubbed: ["§5 Run 3 setup"]` |
| 12 vs. 46 | Duplicate content (V0 A-side anomaly) | `slides_duplicated[0]` |
| 15 vs. 16 | Near-duplicate content (fast-simulation description) | `slides_duplicated[1]` |

Lint rule: this table and the front-matter arrays must stay in sync. If they drift, front-matter wins.

---

## 9. Related wiki pages

Consolidated list of outgoing internal links from this page — single place the lint script and human reviewers can check for missing targets.

| Link | Referenced from | Status |
|------|-----------------|--------|
| [`../detectors/tpc.md`](../detectors/tpc.md) | §3.4 (analytical residual-distortion modelling; two-way link with TPC §7.2 step 4); §5 (Run-3 continuous readout context) | **live (wiki-v2, APPROVED WITH COMMENTS)** |
| [`../detectors/its.md`](../detectors/its.md) | §2.3 detector chain (ITS tracklets); §5 Run-3 context | live (DRAFT, wiki-v1) |
| [`../detectors/trd.md`](../detectors/trd.md) | §2.3 combined-estimator chain (tracks + TOF + calo extend via TRD) | live (DRAFT, wiki-v2) |
| [`../detectors/t0v0zdc.md`](../detectors/t0v0zdc.md) | §2.3 detector chain (T0-A, T0-C, V0-A, V0-C — the forward detectors that the combined estimator most relies on); §3.3 V0 A-side anomaly; §4 T0 calibration | planned |
| [`../code/quantile_fit_nd.md`](../code/quantile_fit_nd.md) | §6 generic quantile regression | planned |
| [`../documents/arxiv_1610_03055_T0_detector.md`](../documents/arxiv_1610_03055_T0_detector.md) | §4.4 T0 single-channel resolution | planned |

Status values: `planned` (target file not yet created — expected "red link"), `live` (target exists and has `review_status: APPROVED` or `DRAFT`), `broken` (target was live but was removed — lint-detected regression).

---

## Appendix A: Slide-to-section map

| Slide(s) | Section |
|----------|---------|
| 1 | Title |
| 2 | Outline |
| 3–4 | §1 Physics motivation |
| 5 | §2.1–2.3 Limitations + robust toolkit + detector chain |
| 6 | §2.3–2.4 Detector chain + expected improvement |
| 7 | §2.5 ML optimization |
| 8 | §2.6 Open questions |
| 9 | Section header "Combined event shape estimators (Run2)" |
| 10 | §3.1 Multiplicity quantile scaling |
| 11 | §3.2 Per-detector segmentation |
| 12 | §3.3 V0 A-side anomaly |
| 13 | §3.4 Fast-simulation input references |
| 14 | §3.5 Event-plane resolution intro |
| 15, 16 | §3.4 Fast-simulation details + analytical formulas |
| 17 | §3.5 ToyMC event-plane scaling |
| 18 | §3.6 Flow v2 resolution |
| 19 | §3.7 Weight fluctuation — multiplicity |
| 20 | §3.7 Weight fluctuation — flow |
| 21 | (Conclusion — empty) |
| 22–23 | §5 Run 3 stub |
| 24 | Section header "Backup and links" |
| 26 | Reference only (arXiv 2108.03471) |
| 27 | §7.2 ALICE forward-upgrade reference |
| 28 | §7.1 Jet-hadron correlations |
| 29 | §7.2 Event-plane resolution figure |
| 30 | §7.1 ZDC event-plane reference |
| 31 | §7.1 Elliptic flow review |
| 32 | §7.1 ALICE performance paper |
| 33 | §7.1/7.5 Material / book reference |
| 34 | §7.4 ALICE Week 2024 flattenicity |
| 36 | §7.1 CME event-shape methods |
| 37 | §7.1 Long-range anisotropies in pp jets + CMS multijet |
| 40 | §2.3/§4.2 Detector rapidity chain (reiterated with vertex-z dependence) |
| 42 | §4.1 Detector / v_z calibration |
| 43 | §4.2 Detector η coverage |
| 44 | §4.3 V0 A/C time amplitude (header) |
| 46 | §3.3 / §4.3 V0 double-peak (duplicate of slide 12) |
| 47 | Section header "T0 calibration" |
| 48 | §4.4 T0 single-channel resolution |
| 49 | §4.5 T0 z-vertex resolution |
| 51 | Section header "Generic quantile regression" |
| 52 | §6.1–6.2 Goal + model |
| 53 | §6.3–6.5 Fit recipe + uncertainty + discrete inputs |
| 54 | §6.6 Using the calibration |
| 55 | §6.7 Benchmarks |
| 56 | §4.6 T0 outliers |

---

## Appendix B: Notation quick reference

| Symbol | Meaning |
|--------|---------|
| `η` | pseudorapidity |
| `φ` | azimuthal angle |
| `v_2` | second-order flow coefficient (elliptic flow) |
| `dN/dη` | charged-particle density per unit rapidity |
| `q`, `q₀` | quantile rank, window center |
| `Δq` | quantile window half-width (default 0.05) |
| `X` | detector amplitude |
| `a, b` | local inverse-quantile fit parameters (`b > 0`) |
| `σ_{X|Q}` | residual scatter of `X` at fixed quantile |
| `σ_Q` | uncertainty on reconstructed rank |
| `σ_w / ⟨w⟩` | relative weight fluctuation |
| `N_particles` | number of particles in an event or η bin |
| `primMult` | primary multiplicity (ALICE definition) |
| `MAD` | median absolute deviation |
| `MLE` | maximum-likelihood estimation |
| `TDC` | time-to-digital converter |
| `PIT` | probability integral transform |
| `PCHIP` | piecewise cubic Hermite interpolating polynomial |
| `IP` | interaction point |
| `UE` | underlying event |
| `JE` | jet event |

---

## Changelog — v0 → wiki-v1 (review_cycle 1)

**Reviewer:** Claude1 (self-review; cycle-1 artifact at `../reviews/PWGPP-643_Claude1_cycle1_review.md`, verdict `[!]` APPROVED WITH COMMENTS). External cycle-2 peer review is pending per MIWikiAI SUMMARY §7 step 3 (non-Claude reviewer routing).

This is the **first retrofit** of PWGPP-643 since its cycle-0 creation. PWGPP-643 originally *set* the schema baseline that TPC-SoT, ITS-SoT, TRD-SoT improved upon; this revision backports the schema improvements made in those cycles into the page that originated the patterns.

**Front-matter retrofit (P1-1):**

- `source_fingerprint` converted from flat `{slide_count: 56}` to nested `upstream[]` form with full identifier / URL / slide-count / stub-list / duplicates metadata. Form matches TPC-SoT / ITS-SoT / TRD-SoT standard.
- `indexed_by: Claude (Opus 4.7)` → `indexed_by: Claude1` + new field `indexing_model: Claude (Opus 4.7)`. Per ClaudeOpus47 TPC-SoT cycle-1 P2.4 convention.
- Added `peer_reviewers: [Claude1]` (self-review sentinel; cycle-2 external review pending).
- Added `summary_contributors: [{id: Claude1, role: indexer}]` (TBD form per SUMMARY §7.3 schema-unification item).
- Added `known_verify_flags: [...]` array mirroring §8.2 P1/P2 items (6 entries) for lint-findability.
- Added `source_status: PARTIAL` and `wiki_sections_stubbed: ["§5 Run 3 setup"]` per the convention formalized by TRD-SoT and articulated in SUMMARY §4.
- Added `slides_duplicated: [[12, 46], [15, 16]]` to the `upstream[]` block, and merged §8.3 duplicate-stub list into front-matter (P2-3).
- `review_cycle: 0 → 1`.
- `hard_constraints_checked`: `correctness: partial`, `reproducibility: partial` (URL-existence verified; 6.5 % of URLs content-fetchable from sandbox; deck content verified via `web_fetch` after architect-seeded URL), `safety: verified`.

**Content fixes:**

- **P1-3 §9 Related wiki pages:** expanded from 2 to 6 entries. Added explicit two-way link to [`../detectors/tpc.md`](../detectors/tpc.md) marked `live (wiki-v2, APPROVED WITH COMMENTS)` — this is the reverse of the TPC §7.2 → PWGPP-643 §3.4 link that ClaudeOpus47 placed in TPC wiki-v1 and Claude3 confirmed in TPC wiki-v2. Also added siblings ITS (live wiki-v1), TRD (live wiki-v2), and T0V0ZDC (planned).
- **P1-3 §3.4 inline cross-link:** added callout to [TPC §7.2 step 4](../detectors/tpc.md) explicitly, so the two-way link is visible in body text as well as the §9 index.
- **P2-1 (§2.3 T0 sign-convention):** rewrote the footnote to record source-deck verification. Slide 6 literally contains *"T0-C (C-side): Located towards the muon absorber side, at +375 cm"* — the ambiguity is in the source deck itself, not a wiki transcription error. Wiki preserves source as-written; resolution owed on source-deck side (`known_verify_flags` item #1).
- **P2-4 (§1.1 slide-3 port-note):** upgraded from ad-hoc prose flag to the TRD-style `[STUB — awaiting source-deck completion]` callout convention; source-verified that slide 3 literally contains the port-note.
- **§5 Run-3 stub:** upgraded from prose note to the TRD-style `[STUB — awaiting …]` callout. Added explicit anchors (continuous readout → TPC §6.7, ITS2 §3.6, TDR-019) so future Turn-2 content has attach-points.
- **P2-6 (§3.7 Bernoulli factors):** added inline HTML-comment derivation showing `√(1/p)` reduces the `(1 + σ_w²/⟨w⟩²)` weight-fluctuation form to the `1.026` / `1.054` factors the slide states as `1.02` / `1.05`. Machine-checkable; the `√(1/p)` formula now visible to lint.
- **P2-5 (§6.7 benchmark tolerance):** added explicit tolerance `|α + 0.5| < 0.05` so the "within tolerance" assessment is reproducible from `bench.log`. Flagged as indexing-side tolerance pinning that the source author should confirm.
- **§8.3 stub/duplicate list:** merged into front-matter `slides_duplicated` and extended `slides_empty_or_stub` to include 22, 23 (P2-3).

**Not fixed in this cycle (source-side or auth-gated):**

- **P2-2 (slide 49 triple L331-L351 citation):** would require fetching `gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/...` which is outside both my sandbox allowlist and `web_fetch` permission scope (CERN auth-gated). Remains as `known_verify_flags` item #2 for the author or a CERN-credentialed reviewer.
- **Source-deck edits for P2-1 and P2-4:** these are source-deck action items, not wiki action items. Wiki handling is now explicit about this.

**Exemplary patterns preserved** (now attributed to PWGPP-643 per the cycle-1 review's E-1 through E-4): `slides_empty_or_stub` array convention; Appendix A slide-to-section map; §8.2 single-table `[VERIFY]`-class flags; honest source-stub preservation (the pattern TRD-SoT later formalized as `source_status: PARTIAL`).

**Unchanged in this cycle:** verdict (`[!]`), body physics content, all quantitative claims, Appendix B notation table. The retrofit is additive + schema-normalizing; no content claim was revised.

---

*End of PWGPP-643 source-of-truth index, wiki-v1 (2026-04-19). Cycle-1 self-review applied; cycle-2 external peer review pending per MIWikiAI SUMMARY §7 step 3. Next reviewer pass should resolve `known_verify_flags` items #2 (L331-L351), #3 (Run-3 Turn-2), #4 (plot-bound formulas), and promote DRAFT → APPROVED once cycle-2 signs off.*
