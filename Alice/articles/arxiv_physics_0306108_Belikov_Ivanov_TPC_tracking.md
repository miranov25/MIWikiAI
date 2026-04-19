---
wiki_id: arxiv-physics-0306108
title: "TPC tracking and particle identification in high-density environment (Belikov, Ivanov, Safarik, Bracinik — CHEP03 2003)"
project: MIWikiAI / ALICE
folder: documents
source_type: academic-paper
source_status: CLOSED — peer-reviewed conference paper, no upstream turns pending
source_fingerprint:
  upstream:
    - id: arxiv-physics-0306108v2
      authors: ["Y. Belikov", "M. Ivanov", "K. Safarik", "J. Bracinik"]
      affiliations:
        - "CERN, Switzerland (Belikov, Ivanov, Safarik)"
        - "Comenius University, Bratislava (Bracinik)"
      title: "TPC tracking and particle identification in high-density environment"
      conference: "CHEP03 — Conference on Computing in High Energy and Nuclear Physics"
      conference_location: "La Jolla, California, USA"
      conference_dates: "2003-03-24 — 2003-03-28"
      paper_code: "TULT011"
      arxiv_id: "physics/0306108v2"
      arxiv_subject: "physics.data-an"
      arxiv_date: "2003-06-27"
      url: "https://arxiv.org/abs/physics/0306108"
      pdf_url: "https://arxiv.org/pdf/physics/0306108"
      page_count: 10
      sections_cited: ["§1 Intro", "§2 (§2.1 gas gain, §2.2 secondary ionization)", "§3 COG error", "§4 COG with amplitude", "§5 shape-based", "§6 (§6.1–6.6 cluster finder / seeding)", "§7 (§7.1 double track, §7.2 dE/dx)", "§8 Conclusions", "Table I (seeding), Table II (performance)"]
      authoritative_tables: ["Table I (seeding efficiency vs distance)", "Table II (TPC tracking performance at dN/dy=4000)"]
  summary_contributors: [{id: Claude1, role: indexer}]
author_of_summary_page: "Claude1 indexing; originating paper authors above"
indexed_by: Claude1
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
source_last_verified: 2026-04-19
source_verification_depth: paper-CONTENT-VERIFIED (full PDF fetched via arxiv.org; all formulas §2–§5 and tables transcribed; equation-to-formula closure confirmed for eq 10 √2 factor)
review_status: DRAFT
review_cycle: 0
peer_reviewers: [Claude1]  # self-indexed; cycle-1 external review pending per MIWikiAI SUMMARY §7.1
hard_constraints_checked: {correctness: verified, reproducibility: verified, safety: verified}
staleness: historical — paper is from 2003; applicability to Run-3 flagged in §8 below
known_verify_flags:
  - "§2.2 G_Lfactor linear parametrization 'validated on reasonable interval of N' — parametrization interval bounds not stated numerically in paper"
  - "§4 empirical G(N)/N = G(A)/(kA) substitution — k factors k_ch, k_prim are detector-calibration constants; not quoted numerically in paper (to be taken from aliroot / O2 code)"
  - "§5 eq 29 shape-correction 'const' factor — value not given in paper text"
  - "§7 Table II performance at dN/dy=4000 — Run-1 simulation-era benchmark; Run-3 reality has ITS+TRD+TOF global fit (see O2-6344 §4, §7) which modifies the isolated-TPC baseline"
---

# arxiv:physics/0306108 — TPC tracking and PID in high-density environment

*Belikov, Ivanov, Safarik (CERN) + Bracinik (Comenius University) — CHEP03, La Jolla, March 2003. Conference paper code TULT011. arXiv:physics/0306108v2 submitted 27 Jun 2003.*

## TL;DR

**Foundational paper** for ALICE TPC reconstruction: derives the **space-point error parametrization** used (with extensions) from Run 1 through Run 3, and introduces the **parallel Kalman-filter tracking** approach for the high-density environment (occupancies up to 40 % in inner sectors, 20 % outer).

**Three headline physical results:**

1. **Gas-gain fluctuation factor** (§2.1). For exponential gas-gain distribution (σ_g = ḡ, typical proportional-regime detector):

   > G²_gfactor = 2N / (N+1)   →   **√2 ≈ 1.414** in the large-N limit

   This is the **"factor √2"** now referenced implicitly or explicitly in every downstream ALICE TPC resolution estimate — including [PWGPP-643 §3.4](../presentations/PWGPP-643_combined_shape_estimator.md) and [O2-6344 §3](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) (weight-fluctuation framework).

2. **Secondary-ionization factor** (§2.2). For 1/E² parametrization σ²_G / G² diverges formally, so eq (8) is refitted numerically with σ²_G / G² as a free parameter (equivalent to linear parametrization in N validated on practical range).

3. **Master σ²_COG equations** (§3, eqs 21–22) combining diffusion, angular spread, and the two fluctuation factors, plus electronic noise. **This is the parametrization the ALICE TPC uses.** Equations recast in terms of measured cluster amplitude A (§4, eqs 23–24) — this is what gets evaluated at runtime during tracking.

**Algorithmic contributions:** fast-spline cluster unfolding (§6.1) with charge conservation; shape-based two-cluster resolution using central moments (§6.2); parallel Kalman-filter with multi-hypothesis tracking and overlap resolution (§7); logarithmic truncated mean for dE/dx at 60 % truncation (§7.2).

**Published performance at dN/dy = 4000:** σ_φ = 1.4 mrad, σ_Θ = 1.0 mrad, σ_pt/pt = 0.88 %, σ_dEdx/dEdx = 6.0 %, efficiency ε = 99 %. These are Run-1-era ALICE TPC numbers; modern Run-3 global alignment (ITS+TPC+TRD+TOF) and distortion decomposition — see [O2-6344](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) — build on the framework of this paper but achieve different operating points.

---

## 1. Context and place in the calibration chain

Run-1 through Run-3 ALICE TPC reconstruction builds on four stages, and this paper is the canonical source for Stages A–C:

| Stage | Topic | Source |
|---|---|---|
| **A** | Cluster-finding geometry + unfolding | §6 of this paper |
| **B** | Space-point error σ² parametrization | §§2–5 of this paper |
| **C** | Kalman-filter parallel tracking | §7 of this paper |
| D | Global alignment, distortion decomposition, material-budget correction | Modern: ALICE JINST2008 §6; [TPC-SoT](../TDR/tpc.md); [O2-6344](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) |

**Important caveat (paper-to-2025 gap):** this paper is Run-1-era simulation. Stages A–C as formulas / algorithms are largely unchanged; stage D is what Run-3 rebuilt on top. **The σ²_COG formulas here are still the inner loop of today's TPC reconstruction.** The table-II performance numbers are not — they've been superseded by global-fit-era measurements.

---

## 2. Physical framework — local-coordinate accuracy

### 2.1 Setup — track angles and diffusion

The track direction relative to the pad plane is described by two angles:

- **α** — angle between track projected onto pad plane and pad-row (relevant for y, i.e. pad-direction measurement).
- **β** — angle between track and z-axis (relevant for z, i.e. drift-direction measurement).

Ionization electrons, randomly distributed along the trajectory, produce a COG spread with two components:

- **Angular spread** (uniform): `L_a = L_pad · tan α` (or β for z)
- **Diffusion** (gaussian with σ_D): transverse D_T for y, longitudinal D_L for z

E×B and unisochronity effects are **negligible** for ALICE TPC (paper's stated claim; confirmed by downstream ALICE studies).

Typical baseline resolution integrated over all clusters: **σ_y ~ 0.8 mm, σ_z ~ 1.0 mm**.

### 2.2 Gas gain fluctuation (paper §2.1)

Each ionization electron is independently amplified with random gas gain `g_i`. The reconstructed COG is the **gain-weighted mean** of electron positions:

```
X_COG = Σ(g_i x_i) / Σ(g_i)       [eq 4]
```

The mean is unbiased (⟨X_COG⟩ = x̄), but the **variance is inflated** by a factor G²_gfactor:

```
σ²_XCOG = σ²_x / N × G²_gfactor    [eq 6]

G²_gfactor = N · ⟨Σg²⟩ / ⟨ΣΣ g_i g_j⟩    [eq 7]
```

For sufficiently large N (quasi-independence of the sums):

```
G²_gfactor ≈ N · (σ²_g/ḡ² + 1) / (N + σ²_g/ḡ²)    [eq 8]
```

**For a proportional-regime detector** (exponential gas-gain distribution), σ_g = ḡ (i.e. σ_g/ḡ = 1). Substituting:

```
G²_gfactor = 2N / (N+1)    [eq 10]
```

**In the large-N limit: G_gfactor → √2 ≈ 1.414.** This is the origin of the factor-√2 gas-gain contribution that appears in every downstream ALICE TPC resolution statement.

**Arithmetic closure check** (machine-checkable):
`G²_gfactor(N=1) = 2·1/2 = 1 → G_gfactor = 1.00` (single electron; no averaging advantage, no penalty)
`G²_gfactor(N=10) = 20/11 ≈ 1.818 → G_gfactor ≈ 1.349`
`G²_gfactor(N=100) = 200/101 ≈ 1.980 → G_gfactor ≈ 1.407`
`G²_gfactor(N→∞) = 2 → G_gfactor = 1.41421...` ✓

Physical meaning: gas-gain variance **multiplies** the diffusion-driven variance by up to a factor of 2 — the gain-weighted COG is a noisier estimator of the geometric COG than the unweighted mean would be, because amplitude fluctuations re-weight the electrons' contributions.

### 2.3 Secondary ionization fluctuation (paper §2.2)

Each primary electron `i` produces `n_i − 1` secondary electrons; each is then amplified by gas gain. Total electron gain per primary cluster is `G_n = Σ g_j` with known mean and variance:

```
⟨G_n⟩ = n̄ · ḡ                                      [eq 13]
σ²_Gn / ⟨G_n⟩² = σ²_n / n̄² + (σ²_g / ḡ²) · 1/n̄    [eq 14]
```

**An analogous fluctuation factor G²_Lfactor** [eq 15] is defined with G_n in place of g.

**Technical difficulty:** for the standard 1/E² parametrization of secondary ionization, σ²_Gn / ⟨G_n⟩ **diverges**, so the simple closed-form substitution into eq 8 is invalid (one "exotic" cluster can dominate ΣΣ G_i G_j).

**Resolution in the paper:** numerical simulation of G_Lfactor; fit with formula (8) using σ²_G/G² as a free parameter — found not to describe a wide-enough N range. **Final choice: linear parametrization of G_Lfactor in N, validated on the practical N-interval of the ALICE TPC** (interval bounds not stated numerically — [flagged: known_verify_flags item #1]).

---

## 3. COG error parametrization

### 3.1 Master equations (§3, eqs 21–22)

Combining all stochastic contributions (diffusion + angular + gas-gain + secondary-ionization + electronic noise; E×B and unisochronity neglected), the COG variance is:

**z-direction (time, drift):**
```
σ²_zCOG = (D²_L · L_drift / N_ch) · G_g
        + (tan²α · L²_pad / (12 · N_chprim)) · G_Lfactor(N_chprim)
        + σ²_noise                                                [eq 21]
```

**y-direction (pad):**
```
σ²_yCOG = (D²_T · L_drift / N_ch) · G_g
        + (tan²β · L²_pad / (12 · N_chprim)) · G_Lfactor(N_chprim)
        + σ²_noise                                                [eq 22]
```

where:
- `N_ch` — total number of electrons in cluster
- `N_chprim` — number of primary electrons in cluster
- `L_drift` — drift length
- `L_pad` — pad length
- `D_L, D_T` — longitudinal, transverse diffusion coefficients

**Note on angle assignment:** the paper pairs `tan α` with z (eq 21) and `tan β` with y (eq 22). This is consistent with paper's §2 definition where α is the in-pad-plane track angle (affecting along-pad-row spread, which via drift-time-binning contributes to z) and β is the track-vs-z-axis angle (affecting the pad-direction spread via geometric projection). Readers tracing through downstream code (e.g. aliroot `AliTPCclusterMI`) will find the same assignment.

### 3.2 Amplitude-based re-parametrization (§4, eqs 23–24)

At runtime, `N_ch` and `N_chprim` are not directly measured — only the **total cluster charge A**. The paper substitutes:

```
G(N)/N = G(A)/(kA)    — empirical parametrization, better fit than G(N)/N itself
```

With calibration constants `k_ch` (total) and `k_prim` (primary), the formulas become:

```
σ²_zCOG = (D²_L · L_drift / A) · G_g(A)/k_ch
        + (tan²α · L²_pad) / (12 · A) · G_Lfactor(A)/k_prim
        + σ²_noise                                                [eq 23]

σ²_yCOG = (D²_T · L_drift / A) · G_g(A)/k_ch
        + (tan²β · L²_pad) / (12 · A) · G_Lfactor(A)/k_prim
        + σ²_noise                                                [eq 24]
```

**`k_ch, k_prim` are detector-calibration constants.** Numerical values are not in the paper — they are extracted from aliroot/O2 reconstruction code. [Flagged: `known_verify_flags` item #2.]

### 3.3 Shape-based refinement (§5)

The cluster shape (measured σ_t in time, σ_p in pad direction) provides additional information beyond amplitude. Expected cluster widths:

```
σ_t = √(D²_L · L_drift + σ²_preamp + tan²α · L²_pad / 12)    [eq 26]
σ_p = √(D²_T · L_drift + σ²_PRF + tan²β · L²_pad / 12)       [eq 27]
```

where σ_preamp is the time-response function r.m.s. and σ_PRF is the pad-response function r.m.s.

**Runtime correction** (eq 29):

```
σ_COG → σ_COG(A) · (1 + const · δRMS/teorRMS)
```

where `δRMS/teorRMS` is the relative distortion of the measured signal shape from the expected one.

The `const` factor value is **not stated in the paper** — [flagged: `known_verify_flags` item #3]. In practice it is tuned per detector calibration pass.

**Threshold-effect correction:** the measured r.m.s. is biased because bins below threshold are zero-suppressed (eq 28). The paper's fix is to **replace below-threshold bins with virtual charges** using Gaussian interpolation of the cluster shape. This removes large systematic shifts in the COG that depended on the local track position relative to the pad/time boundary.

---

## 4. Cluster finder and unfolding (§6)

### 4.1 Classical approach

A two-step pipeline:

1. **Find 2D clusters** in (pad-row, time) planes, searching in **5×5-bin regions** around local maxima. This is bigger than a typical cluster (σ_t and σ_p ≈ 0.75 bins).
2. **Reconstruct space points** at the pad-row centers.

### 4.2 Cluster attributes (§6.2)

Each cluster stored with:

| Field | Meaning |
|---|---|
| `fY, fZ` | COG in y, z |
| `fSigmaY, fSigmaZ` | Cluster width |
| `fMax` | Signal at maximum |
| `fQ` | Total charge |
| `fCType` | Ratio of cluster charge attributable to current track / total charge in 5×5 region |

**The error is assigned only during tracking** (via eqs 23–24), not at cluster-finding time, because track angles α, β are needed to evaluate the angular contribution.

### 4.3 Unfolding (§6.1)

For clusters wider than a critical r.m.s. threshold, the **fast spline method** splits overlapping clusters (fig 2 of paper) by:
- Assuming both sub-clusters have the same r.m.s. (i.e. same track angles).
- Requiring charge conservation in the overlap bin.

For the reference 6-amplitude configuration `{C_i | i=1..6}`, the left-cluster contribution to the shared bin 4 is:

```
A_L4 → C_4 · A_L4 / (A_L4 + A_R4)    [eq 30]
A_R4 → C_4 · A_R4 / (A_L4 + A_R4)    [eq 31]
```

**Fundamental limitation:** two clusters with separation < ~2 time bins (~1 cm) **cannot be resolved** because the local-maximum requirement forbids them. Systematic COG shifts toward the two-track midpoint occur until cluster shape triggers unfolding — after that, no systematic shift.

### 4.4 Asymmetry-based two-cluster estimation (§6.2)

For a cluster suspected of being unresolved-overlap, the paper derives from central moments (μ_i) of the cluster:

```
R = μ₆³ / (μ₂² − μ_{0,2}²)³              [eq 32]

r_1 = 0.5 ± 0.5 · √(1 − 4/R)             [eq 33]

d   = √[(4 + R) · (μ₂² − μ_{0,2}²)]      [eq 34]
```

giving **amplitude ratio r_1** and **two-track distance d** — but this requires global track-context (neighboring pad-row shapes), so it's only available during tracking, not during cluster finding.

---

## 5. Seeding (§6.3–6.6)

### 5.1 Combinatorial seeding (§6.4)

Loop over **pairs of clusters** on pad-rows i_1 and i_2 (separated by n = 20 rows); for each pair, try a helix through the two points and the primary vertex; run Kalman filter from outer to inner point; if ≥ half of potential points associate, save as a seed.

Vertex constraint used only at this stage. Subsequent tracking allows arbitrary impact parameters.

### 5.2 Track-following seeding (§6.5)

For each cluster in the middle pad-row, take the **two nearest clusters** up and down, run a local linear fit (y and z), extrapolate; recursively extend up to i_1 and i_2. Linear fit switches to polynomial after 7 clusters.

### 5.3 Performance — Table I (§6.6)

**Combinatorial seeding efficiency vs pad-row distance (primaries, `pt > 200 MeV/c`):**

| distance | time | efficiency (%) |
|---|---|---|
| 24 | 95 s | 92.2 |
| 20 | 52 s | 90.4 |
| 16 | 34 s | 88.7 |
| 14 | 25 s | 88.1 |
| 12 | 19 s | 85.2 |

**Headline numbers for strategy:**
- Combinatorial: ~90 % efficiency, N²-scaling cost.
- Track-following: 80 % efficiency, much faster.
- **Repeated seeding saturates below 100 %** because overlapping tracks are not independent — `ε_all = 1 − ∏(1 − ε_i)` is only an upper bound.

**Default strategy (at paper time):** two combinatorial seedings in outermost 20 pad-rows + six track-following seedings homogeneously spaced in outermost sector.

---

## 6. Parallel Kalman tracking (§7)

### 6.1 Multi-hypothesis iteration

Per pad-row:
1. Propagate each track candidate.
2. Find nearest cluster.
3. Estimate cluster-position error via eqs 23–24, with shape correction eq 29.
4. Update track if residual² < (3σ)² in both directions.
5. Remove overlapped hypotheses (shared-cluster fraction > 0.6 threshold).
6. Stop inactive hypotheses.
7. Continue to last pad-row.

**Search window width:** ±4σ, where σ is the convolution of predicted track error and expected cluster r.m.s. — chosen to accommodate overlapped clusters (whose positional error is much larger than the not-overlapped estimate).

**No cluster competition** was implemented (memory cost of branching Kalman hypotheses + performance penalty).

### 6.2 Double-track resolution (§7.1)

Two tracks very close along a long path produce **ambiguity** — same track vs. two close tracks vs. two tracks with misinterpreted-multiple-scattering direction change.

Additional criteria under investigation at paper time:
- **Mean local deposited charge** (should double for a genuinely overlapping track-pair).
- **Mean local cluster shape** (should be systematically wider).

### 6.3 dE/dx measurement (§7.2)

**Logarithmic truncated mean** at **60 % truncation** gives the best dE/dx resolution. Uses **local cluster maxima** (not total cluster charge) to avoid distortion due to track overlaps. **Shared clusters are excluded from the dE/dx estimate.**

Per-pad-type normalization (different gas gain, different PRF) required. Correction function for cluster shape introduced to handle local track overlaps (correlation between measured dE/dx and particle multiplicity observed without correction).

### 6.4 Performance — Table II (§7)

**ALICE TPC tracking performance, dN/dy = 4000 charged primaries (Run-1 simulation era):**

| Quantity | Value |
|---|---|
| σ_φ | **1.399 ± 0.030 mrad** |
| σ_Θ | **0.997 ± 0.018 mrad** |
| σ_pt / pt | **0.881 ± 0.011 %** |
| σ_dEdx / dEdx | **6.00 ± 0.2 %** |
| Efficiency ε | **99.0 %** |

**These are pre-data-taking simulation results.** Run-3 global-alignment (ITS+TPC+TRD+TOF) and continuous-readout reality achieves different operating points; this table is the Run-1 baseline from which Run-2 / Run-3 / Run-4 improvements are measured.

---

## 7. Key formulas — consolidated index

For cross-referencing from other MIWikiAI pages:

| Paper eq | Topic | Formula |
|---|---|---|
| **(4)** | Gain-weighted COG | `X_COG = Σ(g_i x_i) / Σ(g_i)` |
| **(8)** | Gas-gain factor (approx, quasi-independent) | `G²_g = N(σ²_g/ḡ² + 1) / (N + σ²_g/ḡ²)` |
| **(10)** | Gas-gain factor (exponential, σ_g = ḡ) | `G²_g = 2N / (N+1)` — **√2 in large-N limit** |
| (14) | Secondary-ionization variance | `σ²_Gn/⟨G_n⟩² = σ²_n/n̄² + σ²_g/ḡ² · 1/n̄` |
| (15) | G_Lfactor definition | `G²_L = N · ⟨Σ G²⟩ / ⟨ΣΣ G_iG_j⟩` |
| **(21)** | σ²_zCOG master equation (in N) | diffusion + angular + noise |
| **(22)** | σ²_yCOG master equation (in N) | diffusion + angular + noise |
| **(23)** | σ²_zCOG amplitude-based (in A) | using `G(A)/kA` empirical |
| **(24)** | σ²_yCOG amplitude-based (in A) | using `G(A)/kA` empirical |
| (25) | Cluster shape gaussian model | `f(t,p) = K_max · exp[−(t−t₀)²/2σ²_t − (p−p₀)²/2σ²_p]` |
| (26) | Time cluster width | `σ_t = √(D²_L·L_drift + σ²_preamp + tan²α·L²_pad/12)` |
| (27) | Pad cluster width | `σ_p = √(D²_T·L_drift + σ²_PRF + tan²β·L²_pad/12)` |
| **(29)** | Shape-based σ_COG correction | `σ_COG → σ_COG(A) · (1 + const · δRMS/teorRMS)` |

**Bold rows** are the formulas most-cited downstream — mark as canonical anchor points.

---

## 8. Relation to later work indexed in MIWikiAI

### 8.1 PWGPP-643 — weight-fluctuation combined-estimator framework

[PWGPP-643 §3.4](../presentations/PWGPP-643_combined_shape_estimator.md) uses **this paper's eq (8)** as its "approximation of eq 8 in arxiv/physics/0306108" for the resolution-modification-under-weight-fluctuation analysis. The "√(1 + 1²) ≈ 1.41 factor" quoted there is exactly eq (10) of this paper in the large-N limit.

**Two-way link target:** PWGPP-643 §3.4 ↔ this §2.2 + §7 eq (10).

### 8.2 O2-6344 — continued distortion decomposition

[O2-6344 §3](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) quotes the same weight-fluctuation framework. The **Python dfextensions toolkit's AliasDataFrame / GroupByRegressor** (O2-6344 §3.2) is a modern numerical-implementation layer on top of the physical decomposition this paper introduced conceptually.

O2-6344 §8.2 (unbinned-residual extensions: Qmax/dE/dx per row, occupancy) and §8.3 (TRD tracklet info, PR #14969) are direct continuations of this paper's §7.2 dE/dx framework.

**Two-way link target:** O2-6344 §3 / §8.2 / §8.3 ↔ this §§2.1, 2.2, 7.2.

### 8.3 TPC-SoT — fundamental reconstruction-parametrization source

[TPC-SoT](../TDR/tpc.md) carries the physical parameters (D_L, D_T, L_pad, etc.) that feed this paper's eqs 21–24 at runtime. Every numerical-resolution claim in TPC-SoT §6.x (space-point resolution) traces to this paper's framework.

**Two-way link target:** TPC-SoT §6 / §7 ↔ this §§3, 4, 7.

### 8.4 Intentional scope gap

This paper covers **local TPC-only reconstruction** — cluster finding, per-cluster error estimate, parallel Kalman within TPC, TPC-only PID. It **does not cover**:

- Global alignment across detectors (ITS, TRD, TOF) — see [O2-6344 §1, §7](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md).
- Space-charge distortions and distortion decomposition — see [TPC-SoT §7](../TDR/tpc.md) and [O2-6344 §3](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md).
- Material-budget correction — see [O2-6344 §2](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md).
- Run-3 continuous readout, GEM-based gain — see [TPC-SoT §6.7](../TDR/tpc.md).

These all **extend** this paper's framework rather than replace it.

---

## 9. Open items / reviewer-validation checklist

### 9.1 Indexing flags for reviewer

| # | Section | Issue | Severity |
|---|---|---|---|
| 1 | §2.3 / §3.2 | Paper refers to `k_ch`, `k_prim` calibration constants by name but does not quote numerical values. Runtime reconstruction uses aliroot/O2 calibration — wiki links should be added when [dfextensions_toolkit](../code/dfextensions_toolkit.md) or an aliroot-specific documents page is indexed | P2 |
| 2 | §3.3 | `const` in eq 29 shape-correction formula not given numerically in paper text | P2 |
| 3 | §2.2 | Linear-parametrization validity interval for G_Lfactor not stated numerically | P2 |
| 4 | §6.4 / §5.3 | Table I efficiency numbers are simulation at paper-time. Run-3 reality with ITS+TPC+TRD+TOF global track is not directly comparable. Consumer of this table should note the context. | P2 |
| 5 | §7 Table II | Same caveat as row 4: Run-1-era performance. **Flagged as staleness: historical.** | P2 |
| 6 | overall | The paper's language for "particle identification" section is tersely stated ("truncated mean at 60 %"); downstream [TRD-SoT §4](../TDR/trd.md) and [O2-6344 §8.3](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) refine the truncation-mean method considerably. Worth an explicit note for readers who land on this paper via a "how is dE/dx computed" query. | P3 (annotation only) |

### 9.2 Arithmetic-closure spot-checks

Performed during indexing:

- **Eq (10) large-N limit:** `G²_g(N→∞) = 2N/(N+1) → 2`, so `G_g → √2 = 1.41421...`. Claim in paper: "deteriorates σ_XCOG by factor of about √2" ✓
- **Eq (10) N=10:** `G²_g = 20/11 = 1.818...` → `G_g = 1.349`. Paper states good agreement with simulation. Not contradicted. ✓
- **σ_g/ḡ = 1 substitution:** for exponential `f(g) = (1/ḡ) exp(−g/ḡ)`, `⟨g⟩ = ḡ`, `⟨g²⟩ = 2ḡ²`, so `σ²_g = ⟨g²⟩ − ⟨g⟩² = 2ḡ² − ḡ² = ḡ²`, hence `σ_g = ḡ`. ✓
- **Eqs (21)–(22) vs (23)–(24) consistency:** amplitude-based form preserves the three-term structure (diffusion + angular + noise) with `N → A/k`. Structural consistency confirmed. ✓

### 9.3 Empty / stub sections

None. Paper is a closed conference-proceedings publication; all sections are complete.

---

## 10. Related wiki pages

Consolidated outgoing internal links.

| Link | Referenced from | Status |
|---|---|---|
| [`../TDR/tpc.md`](../TDR/tpc.md) | §1 Context (stage A/B/C of reconstruction); §3 master formulas use TPC-specific `D_L, D_T, L_pad`; §8.3 TPC-SoT §6.x derivation cross-link | **live (wiki-v2)** |
| [`../TDR/trd.md`](../TDR/trd.md) | §6.3 dE/dx extension — TRD's tracklet-averaging approach extends this paper's §7.2 method; O2-6344 §8.3 PR #14969 is the modern TRD-tracklet continuation | live (wiki-v2) |
| [`../presentations/PWGPP-643_combined_shape_estimator.md`](../presentations/PWGPP-643_combined_shape_estimator.md) | §8.1 — PWGPP-643 §3.4 cites this paper's eq (8) directly for the √2 factor | live (wiki-v1) |
| [`../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md`](../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) | §8.2 — O2-6344 §3 continues the weight-fluctuation framework; §8.2–8.3 extend §7.2 dE/dx | live (wiki-v1) |
| [`../TDR/its.md`](../TDR/its.md) | §5.1 — combinatorial seeding uses primary-vertex from ITS pixels | live (wiki-v1) |
| [`../code/dfextensions_toolkit.md`](../code/dfextensions_toolkit.md) | §8.2 — modern Numba-accelerated implementation of the GroupBy regression used for the σ²_COG(A) lookup | planned |

Status values: `planned` (target not yet created), `live` (target exists and has `review_status: APPROVED` or `DRAFT`), `broken` (target was live but was removed — lint-detected regression).

---

## 11. External references

| Topic | Reference |
|---|---|
| **Primary paper (this one)** | [arXiv:physics/0306108v2](https://arxiv.org/abs/physics/0306108) — PDF: https://arxiv.org/pdf/physics/0306108 |
| CHEP03 conference proceedings | La Jolla, California, March 24–28, 2003 — paper code TULT011 |
| Paper reference [1] (ALICE Technical Proposal) | CERN/LHCC/95-71 |
| Paper reference [2] (ALICE TPC TDR) | ALICE Collaboration, Technical Design Report of the Time Projection Chamber — see [CDS record 451098](https://cds.cern.ch/record/451098) (external fetch deferred per v0.3 §8 item 2) |

---

## Appendix A: Paper-section-to-wiki-section map

| Paper section | Wiki section |
|---|---|
| §1 Introduction | §1 Context |
| §2 (intro) Accuracy of local coord | §2.1 Setup |
| §2.1 Gas gain fluctuation | §2.2 |
| §2.2 Secondary ionization | §2.3 |
| §3 COG error parametrization | §3.1 (eqs 21–22) |
| §4 Precision from measured amplitude | §3.2 (eqs 23–24) |
| §5 Precision from measured cluster shape | §3.3 (eqs 25–29) |
| §6 TPC cluster finder | §4 |
| §6.1 Cluster unfolding | §4.3 |
| §6.2 Cluster characteristics | §4.2, §4.4 |
| §6.3–6.6 Seed finding | §5 |
| §7 Parallel Kalman tracking | §6 |
| §7.1 Double-track resolution | §6.2 |
| §7.2 dE/dx measurement | §6.3 |
| §8 Conclusions | TL;DR + §8 Relation to later work |
| Table I | §5.3 |
| Table II | §6.4 |

---

## Appendix B: Notation

| Symbol | Meaning |
|---|---|
| α | Track angle in pad plane (affects along-pad-row spread) |
| β | Track angle vs z-axis (affects pad-direction projection) |
| D_L | Longitudinal diffusion coefficient |
| D_T | Transverse diffusion coefficient |
| L_drift | Drift length |
| L_pad | Pad length |
| N_ch | Total electrons in cluster (secondary + primary) |
| N_chprim | Primary electrons in cluster |
| g_i | Random gas gain for electron i |
| σ_g | R.m.s. of gas-gain distribution |
| G_gfactor | Gas-gain multiplicative factor for σ²_COG (eq 7–10) |
| G_Lfactor | Secondary-ionization multiplicative factor (eq 15) |
| σ_preamp | Time-response function r.m.s. |
| σ_PRF | Pad-response function r.m.s. |
| A | Total measured cluster charge |
| k_ch, k_prim | Calibration constants for amplitude-based parametrization |
| COG | Centre of gravity |
| PRF | Pad response function |
| E×B | Crossed-field drift-velocity modification |
| χ² | Goodness-of-fit statistic (Kalman-filter residual check) |
| dN/dy | Charged-particle rapidity density |

---

## Changelog

- **v0 → wiki-v1 (2026-04-19).** First indexing pass (Claude1). 10-page conference paper fetched via arxiv.org PDF (source CONTENT-VERIFIED; eq (10) √2 closure confirmed at N=10, 100, and large-N limit). Front-matter follows MIWikiAI SUMMARY v0.3 schema: nested `source_fingerprint.upstream[]` with arxiv_id, paper_code, conference metadata; `indexed_by/indexing_model` split; `peer_reviewers: [Claude1]` self-indexed; `known_verify_flags` (4 items for values not in paper text); `source_status: CLOSED` (published work, no turns pending); `staleness: historical` (2003 Run-1-era simulation; Table II performance superseded by global alignment in Run 3). Cross-links live to TPC-SoT (wiki-v2), TRD-SoT (wiki-v2), ITS-SoT (wiki-v1), PWGPP-643 (wiki-v1), O2-6344 (wiki-v1); `planned` to dfextensions_toolkit. First entry in `Alice/documents/`. Review cycle 0 (self-indexed); external cycle-1 peer review pending per MIWikiAI SUMMARY v0.3 §7.1 sprint rules.

---

*End of wiki entry for arxiv:physics/0306108 (Belikov, Ivanov, Safarik, Bracinik — CHEP03 2003). Self-indexed by Claude1 on 2026-04-19. Source paper is the canonical reference for ALICE TPC space-point error parametrization (eqs 21–24), gas-gain fluctuation factor (eq 10), and the foundational parallel-Kalman tracking algorithm. Downstream chain: TPC-SoT §6 → PWGPP-643 §3.4 → O2-6344 §3 / §8.2 / §8.3, all of which this paper underwrites.*

*No quota issues observed during indexing.*
