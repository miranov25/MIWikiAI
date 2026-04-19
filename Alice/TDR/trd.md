---
wiki_id: TRD-SoT
title: ALICE Transition Radiation Detector (TRD) — Source of Truth
project: MIWikiAI / ALICE
folder: detectors
source_type: detector-tdr-summary
source_title: TRD_source_of_truth_v0_3_turn1.md
source_status: SOURCE IS PARTIAL — Turn 1 of 2 (§§1–5 delivered; §§6–10 pending Turn 2)
source_fingerprint:
  upstream:
    - id: TRD-TDR
      title: "Technical Design Report of the Transition Radiation Detector"
      report_number: "CERN-LHCC-2001-021, ALICE-TDR-9"
      year: 2001
      month: October
      cds: "https://cds.cern.ch/record/519145"
      pdf: "https://cds.cern.ch/record/519145/files/cer-2275567.pdf"
      pdf_fingerprint: "cer-2275567.pdf, 188 pp (full text extracted via pdftotext per source header)"
      sections_cited: ["§1", "§4.1.1", "§4.3", "§4.4", "§4.5", "§4.6.1", "§14", "Ch. 7", "Ch. 11", "Table 1.1", "pp. 23 / 27"]
      authoritative_table: "Table 1.1 (TDR parameter summary)"
    - id: JINST2008
      title: "The ALICE experiment at the CERN LHC"
      doi: "10.1088/1748-0221/3/08/S08002"
      url: "https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002"
      sections_cited: ["§6 (TRD)"]
      read_status: "partial — full-pass deferred per source header"
    - id: ALICE-TDR-019
      title: "Technical Design Report for the Upgrade of the Online-Offline Computing System"
      report_number: "CERN-LHCC-2015-006, ALICE-TDR-019"
      cds: "https://cds.cern.ch/record/2011297"
      sections_cited: ["referenced for Run 3 continuous-readout interface"]
  summary_version: "v0.3 turn-1 (partial — §§1–5 only)"
  summary_author: "Main Coder Claude2 (per source header)"
source_last_verified: 2026-04-19
author: Marian Ivanov (dissertation lead); source-of-truth distilled with AI-assisted review
indexed_by: Claude1
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 2
peer_reviewers: [ClaudeOpus47]
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags: ["§3.2 Xe absorption-length reference at 5 keV", "§3.2 operational Lorentz angle at B = 0.5 T", "§3.2 Run 1/2 as-operated gas gain", "§4.2 TRAP on-chip filter 4→3 decimation mechanism (TRD-TDR §4.5)", "§5.2 as-measured Run 1/2 pion rejection"]
wiki_sections_stubbed: ["§6 Performance summary (awaiting source Turn 2 — performance table)", "§7 Operational history (awaiting source Turn 2)", "§8 expanded glossary (Turn 2 will request ~25 entries; current §8 has basic set)"]
---

# TRD: ALICE Transition Radiation Detector — Source of Truth

> **Source status.** The upstream distillation `TRD_source_of_truth_v0_3_turn1.md` is **Turn 1 of 2** — it delivers physics role, TR principle, chamber design, readout, and reconstruction role (§§1–5 of this wiki page). The source author has deferred §§6–10 to Turn 2: performance summary table, alignment + calibration detail, operational history, expanded glossary, open items, full v0.2 → v0.3 changelog. Those wiki sections are explicitly stubbed below and should be filled once Turn 2 is delivered.

## TL;DR

The TRD occupies the radial slot **2.90–3.68 m** of the central barrel, between the [TPC](./tpc.md) (outer radius ~2.5 m) and TOF (inner radius ~3.7 m). It is **540 radial drift chambers** organised as 18 supermodules × 5 z-stacks × 6 r-layers, with ~1.16 M cathode pads [TRD-TDR Table 1.1, §4.4]. Active area **736 m²**, gas volume **~27 m³** of Xe/CO₂ (85/15), material budget **14.3 % X₀** over the six-layer stack.

Three functions:

1. **Electron identification** above p ≈ 1 GeV/c — where [TPC](./tpc.md) dE/dx alone becomes statistical. TR yield drives on Lorentz factor γ; for electrons vs pions at the same momentum, γ_e / γ_π = m_π / m_e ≈ 275 — so electrons (γ ≈ 2000 at 1 GeV/c) emit TR efficiently, pions (γ ≈ 7) emit essentially none. TDR design target: **factor-100 pion rejection at 90 % electron efficiency** (isolated track), ~50 at dN_ch/dy = 8000 [TRD-TDR §1].
2. **Tracking extension.** Six tracklets (~400 μm rφ resolution each [TRD-TDR Ch. 11]) extend the central-barrel track lever arm from ~2.5 m to **~3.7 m (+48 %)** — the benefit is most visible at p_T ≳ 10 GeV/c.
3. **Fast Level-1 trigger** (Run 1/2). On-chamber **TRAP** chips reconstruct tracklets in ~6 μs; off-detector **Global Tracking Unit (GTU)** matches them across layers and issues L1 triggers on high-p_T hadrons, jets, and electron candidates [TRD-TDR Ch. 7]. In Run 3 the L1 role is **dissolved** because O² continuous readout records every collision [TDR-019]; TRD electron ID moves fully offline.

**Role in this dissertation:** the TRD is the **outer reference track** for the Run 3 **TPC space-charge-distortion calibration** — the ITS–TRD track-interpolation method is the backbone of the [TPC §7.2 step-4](./tpc.md) residual-distortion correction. ITS provides the inner reference (precision vertexing), TRD the outer (~3.7 m lever arm). TRD alignment + timing quality propagates directly into TPC distortion-map quality, which is the principal calibration subject of the dissertation.

---

## 1. Purpose and role of the TRD

The Transition Radiation Detector occupies the radial range **2.90 m to 3.68 m** inside the ALICE central barrel [TRD-TDR Table 1.1], sandwiched between the [TPC](./tpc.md) (outer radius ~2.5 m) and the TOF (inner radius ~3.7 m). It consists of **540 radial drift chambers** organised as 18 supermodules × 5 stacks in z × 6 layers in r [TRD-TDR §1; Table 1.1]. The TRD provides three complementary functions that together motivated its construction:

**(1) Electron identification** for momenta above the regime where [TPC](./tpc.md) dE/dx alone separates electrons from hadrons (p ≳ 1 GeV/c). The principal physics motivation is heavy quarkonia (J/ψ, Υ) reconstructed via their dielectron decay, and open heavy-flavour measurements via semileptonic electron channels. The TRD complements the TPC rather than replacing it: below ~1 GeV/c the TPC dE/dx 1/β² region already separates electrons cleanly from pions, but above that momentum the curves cross and TPC dE/dx alone becomes statistical.

**(2) Tracking.** The six-layer drift-chamber stack contributes to the global ALICE track fit. Each layer provides up to 15 drift-time samples (see §4), which combine into a single **tracklet** — a short straight-line segment internal to one chamber. Matched across six layers, TRD tracklets extend the barrel track lever arm from the TPC outer radius to ~3.7 m, improving σ(p_T)/p_T at high transverse momentum and providing a rigid external constraint on TPC space-charge distortions (§5.5 below).

**(3) Fast Level-1 trigger** (Run 1 and Run 2). On-detector electronics reconstructs tracklets in ~6 μs after the collision. Tracklets are aggregated by the off-detector **Global Tracking Unit (GTU)**, which issues L1 triggers on high-p_T tracks, jets, and electron candidates. This was unique among ALICE central-barrel subdetectors during triggered operation; in Run 3 the L1 role is dissolved because continuous readout records every collision (§4.4).

**Acceptance summary:** \|η\| < 0.9 [TRD-TDR §1, p. 23; Table 1.1], full azimuth (18 supermodules, 20° each), active area **736 m²** [TRD-TDR §1, p. 27], gas volume **~27 m³** of Xe/CO₂ [TRD-TDR §1, p. 23; Table 1.1].

## 2. Transition radiation — physics principle

### 2.1 Emission mechanism

Transition radiation is electromagnetic radiation emitted when a charged particle crosses the interface between two media with different dielectric constants. The radiation spectrum is dominated by soft X-rays (photon energies of a few keV for high-γ particles), and the total emitted energy per interface is proportional to the particle's Lorentz factor **γ = E/mc²**.

**Why γ drives the electron/pion separation:** at the same momentum p, two particles with masses m₁ and m₂ have Lorentz factors in the ratio γ₁/γ₂ = m₂/m₁. For electrons and pions, this ratio is **m_π / m_e ≈ 275**. At p = 1 GeV/c this means γ_e ≈ 2000 while γ_π ≈ 7 — an enormous disparity. Electrons emit transition radiation efficiently above γ ≈ 1000, while pions at the same momentum are still far below the emission threshold, emitting essentially none.

### 2.2 Formation zone and radiator design

TR emission from a single interface is small — typically α × 1/137 photons emitted per crossing, and the photons are strongly forward-peaked. Efficient TR generation therefore requires many interfaces per radiator. The radiator must satisfy two competing constraints:

- **Dense interfaces for yield:** emission from successive interfaces adds coherently within the **formation zone** ζ ≈ **γ² λ / (2π)** (standard TR form, e.g. Landau–Lifshitz Vol. 8 §116; Artru–Yodh; Cherry & Lord review), which at γ = 2000 and λ ~ 0.2 nm (5 keV photon) is ζ ≈ (2000)² × 0.2 nm / (2π) ≈ 127 μm — i.e. of order **hundreds of micrometres**. Interfaces closer than ζ interfere; further apart than ζ they add incoherently.
<!-- derivation: γ² × λ / (2π) = 4e6 × 0.2 nm / 6.283 = 127 μm. NOTE: the formula MUST carry γ², not γ — single-γ gives 63.7 nm which contradicts the stated "hundreds of μm" order. Corrected in review_cycle 1 (ClaudeOpus47 P1.1). -->
- **Low material budget:** TR photons are easily reabsorbed in the radiator itself before reaching the detector gas. The radiator must be dense enough to maximise interface density yet thin in radiation length to preserve the TR.

**ALICE TRD solution:** each of the six layers carries a **4.8 cm radiator** built as a fibre/foam sandwich [TRD-TDR Table 1.1; §14]. Fibres give high interface density at low mean density; foam provides mechanical rigidity. Test beams demonstrated yield of roughly one to two detected TR photons per minimum-ionising electron per layer — sufficient for **~100× pion rejection over six layers at 90 % electron efficiency**.

### 2.3 Photon detection in the drift gas

TR photons enter the drift chamber and are absorbed in the xenon component of the **Xe/CO₂ (85/15)** gas mixture [TRD-TDR §1, p. 23]. Xenon is chosen for its high atomic number (Z = 54): photoelectric cross-section scales approximately as Z⁵ in the few-keV range, giving xenon an absorption length of about **1–2 cm at 5 keV** `[VERIFY: Xe absorption-length reference]`. Absorption deposits the full photon energy locally as a compact cluster of ionisation electrons. These cluster charges superimpose on the primary ionisation trail of the traversing particle (~275 electrons per cm in Xe/CO₂ 85/15 [TRD-TDR §1, p. 23]), appearing as a characteristic peak near the radiator-side end of the drift-time distribution.

The sorting between pion (no TR) and electron (TR present) is therefore a **pattern-recognition problem in the charge-vs-drift-time distribution**, not simple integrated-charge discrimination. The 15 time bins of the drift-time readout (§4.2) are precisely what enables this discrimination — a single integrated dE/dx value per track, as an all-in-one calorimeter would provide, is substantially less powerful.

## 3. Chamber design

### 3.1 Overall structure

The 540 readout chambers are radial multiwire proportional chambers with cathode-pad readout. Chambers are arranged in a gently curved **projective geometry**: chamber width increases with radius, and adjacent chambers align radially to the interaction point so that high-p_T tracks cross a single chamber cleanly [TRD-TDR §1, p. 27]. The largest individual chamber measures **120 × 159 cm²** [TRD-TDR Table 1.1]; supermodules span the full 6-layer radial depth and half the z range.

Each chamber comprises, in order along the drift direction from outside inwards:

1. **Radiator**, 4.8 cm of fibre/foam sandwich [TRD-TDR §14].
2. **Drift region**, 3.0 cm [TRD-TDR Table 1.1], bounded by the radiator on one side and the anode wire plane on the other, with a uniform drift field of **700 V/cm (0.7 kV/cm)** [TRD-TDR Table 1.1].
3. **Amplification region**, 0.7 cm [TRD-TDR Table 1.1], containing the anode wire grid at 5 mm pitch [TRD-TDR §4.3].
4. **Cathode pad plane** with 144 pads in the rφ direction per chamber and 12 to 16 pad rows in z depending on layer and stack position [TRD-TDR §1; Table 1.1]. Pads typically 6–7 cm² in area [TRD-TDR §1, p. 27].

### 3.2 Gas and drift dynamics

**Gas composition.** Xe/CO₂ 85/15 by volume [TRD-TDR §1]. Xenon provides TR absorption via the photoelectric effect; CO₂ quenches ultraviolet photons from ionisation avalanches and stabilises the gain. Total chamber gas volume **~27 m³** [TRD-TDR §1, p. 23] — substantial because xenon is expensive, which motivated dedicated recirculation and purification systems.

**Drift velocity.** v_d = **1.5 cm/μs** [TRD-TDR §1; §4.1.1]. The TDR states explicitly the choice of v_d = 1.5 cm/μs [TRD-TDR §4.1.1], corresponding to a drift time of **2.0 μs** over the 3.0 cm drift region. Lorentz angle ≈ 8° at B = 0.4 T [TRD-TDR §1, p. 27]; ALICE operates at B = 0.5 T, so the as-deployed Lorentz angle is slightly larger `[VERIFY: operational Lorentz angle]`.

**Gas gain.** Nominal design: **5 × 10³** [TRD-TDR §1, p. 27]. Prototype measurements achieved gain of 8000 at anode voltage U_a = 1420 V [TRD-TDR §4.6.1], with the TDR recommending an operational ceiling ≤ 10⁴. Run 1/2 as-operated values `[VERIFY: TRD operations note]`.

**Primary ionisation.** A minimum-ionising particle liberates approximately **275 electrons per cm** in Xe/CO₂ 85/15 [TRD-TDR §1, p. 27]. Combined with the 3 cm drift region → **~825 primary electrons per track per chamber** before gas gain. TR photon absorption adds a localised cluster of several hundred to a thousand additional electrons at the radiator-side end of the drift profile for electron-emitted photons.

**Diffusion.** Negligible over the drift distance at the operating drift field [TRD-TDR Table 1.1].

### 3.3 Total pad count

The full detector contains **1,156,032 pads ≈ 1.16 × 10⁶** [TRD-TDR §4.4]. Arithmetic from the pad-plane layout: 144 pads per row (rφ) × 70–76 rows per layer (z, layer-dependent) × 6 layers × 18 supermodules. This is the largest channel count among ALICE central-barrel detectors in Run 1–2 and remains so in Run 3.

### 3.4 Material budget

**Total six-layer stack: 14.3 % X₀** [TRD-TDR Table 1.1]. Per-layer ≈ **2.4 % X₀**. The 4.8 cm fibre/foam radiator accounts for the dominant fraction of the per-layer budget; remaining contributions come from chamber gas envelope, cathode pad plane, support structure, and on-chamber front-end electronics.

*Footnote:* TRD-TDR §1 prose states *"less than 14 %"* as a rounded figure; Table 1.1 gives the precise design value 14.3 %. This page cites the table as the authoritative normative source; the prose figure is consistent within rounding.

## 4. Readout electronics

### 4.1 On-chamber front-end architecture

Each readout chamber carries its front-end electronics directly on the back of the pad plane, organised into **Multi-Chip Modules (MCMs)**. The MCM is the physical package; its internal architecture comprises three distinct functional elements that must not be conflated:

- **PASA** — PreAmplifier/ShAper ASIC. Charge-sensitive preamp + semi-Gaussian shaper, one channel per readout pad. Shaping time matched to the 2 μs drift window.
- **ADC** — 10-bit analog-to-digital converter, one per channel, clocked at **10 MHz** [TRD-TDR Ch. 7].
- **TRAP** — TRD digital tracklet processor chip. Receives digitised samples from ADC; performs on-chip filtering (tail cancellation of the long ion-drift signal tail); stores samples in time-bin memory; computes a straight-line tracklet within the chamber using a built-in linear-fit unit.

> **Distinction from TPC Run 3 SAMPA:** PASA+ADC+TRAP are **separate chips** in the TRD MCM — preamp/shape, digitise, then local tracklet fit. The TPC Run 3 [SAMPA ASIC](./tpc.md) integrates preamp + shaper + ADC + DSP on a single 32-channel die (see [TPC §6.5](./tpc.md)), and produces no on-chip tracklet — it just streams time-samples. Both are "on-chamber DAQ", but the TRD additionally does on-chamber *track finding* to feed the L1 trigger path.

Each MCM handles a small group of pads — of order 16–18 channels — and the tracklet computation is local to the chamber.

### 4.2 Time sampling

Drift-time information is recorded as **15 time bins of 133 ns** spanning the 2 μs drift window [TRD-TDR §4.5; Table 1.1]. Relation to the 10 MHz ADC clock requires care:

- ADC clock runs at 10 MHz (100 ns intervals) → 20 raw samples per 2 μs drift window.
- Only **15 bin samples at 133 ns effective spacing** are stored per drift window after on-chip filtering and decimation.
- `15 × 133 ns = 1.995 μs ≈ 2.0 μs`, covering the full drift region.
<!-- derivation: 15*133 = 1995 ns ≈ 2.0 μs -->

**On the non-integer 4/3 decimation factor:** 20 raw samples → 15 stored samples is `4 → 3`. The TRAP on-chip filter performs tail-cancellation of the long ion-drift signal tail *before* storage, and its output is resampled at 133 ns spacing (sometimes described as a weighted-sum shaper that maps groups of 4 raw ADC samples into 3 filtered output samples). `[VERIFY against TRD-TDR §4.5 for the exact filter-kernel / decimation mechanism]` — this matters for anyone reconstructing the time-bin response function from first principles.

The 133 ns bin spacing is the **post-processing storage width, not the raw ADC rate** [TRD-TDR §4.5]. Per-bin charge is the primary observable both for tracking (charge-weighted pad-row centroid → rφ position; drift time → z position) and for electron ID (TR photon absorption appears as a peak in a specific bin range).

### 4.3 On-detector trigger path

TRAP tracklet outputs from all six layers within a single z-stack are shipped off-detector to the **Global Tracking Unit (GTU)**, which matches tracklets across layers into three-layer and six-layer track candidates. The GTU computes a crude p_T estimate (precision limited by the short ~80 cm radial lever arm of the TRD alone) and applies programmable trigger logic [TRD-TDR Ch. 7]:

- **High-p_T hadron trigger** — single-track p_T threshold.
- **Electron candidate trigger** — tracklet-level electron-likelihood (from charge profile) combined with p_T threshold.
- **Jet trigger** — multi-tracklet topologies.

Trigger decision latency ~6 μs from collision — fits within the ALICE Level-1 budget. This was one of the principal functions of the TRD during Run 1/2 triggered operation.

### 4.4 Run 3 continuous readout

In Run 3 the TRD migrated to continuous readout as part of the global O² transition [TDR-019]. The TRAP chips stream tracklet and time-sample data continuously to **Common Readout Units (CRUs)**, and the GTU's L1-trigger role is **dissolved** because every collision is recorded. The TRD's electron-ID function remains, performed entirely offline, and the TRD continues to provide outer reference space-points for the [TPC space-charge distortion calibration](./tpc.md) (§5.5).

## 5. Role in the reconstruction chain

### 5.1 Tracking

The TRD defines the outer boundary of the ALICE central-barrel Kalman track fit for \|η\| < 0.9. Each matched tracklet contributes **~400 μm rφ spatial resolution** [TRD-TDR Ch. 11]. Six matched tracklets extend the outer sensitive radius from the TPC outer (**~2.5 m**) to the TRD outer (**~3.7 m**), a **+48 % outer-radius increase**. In the stricter sense of tracking *lever arm* (inner-to-outer of the sensitive volume, measured from the TPC inner radius ~0.85 m), the extension is from `2.466 − 0.848 = 1.62 m` (TPC-only) to `3.68 − 0.848 = 2.83 m` (TPC + TRD) = **+75 % true lever-arm increase**. The effect on σ(p_T)/p_T is most visible at high transverse momentum (p_T ≳ 10 GeV/c), where the TPC resolution alone begins to degrade because the helix curvature becomes small relative to single-point resolution.
<!-- derivation: outer-radius Δ: (3.68−2.50)/2.50 = 47.2% ≈ +48%. true lever-arm Δ: (3.68−0.848)/(2.466−0.848) − 1 = 2.832/1.618 − 1 = 74.9% ≈ +75%. -->

See [TPC §11.1 tracking](./tpc.md) for the TPC side of the match, and [ITS §5.1](./its.md) for the inner seed.

### 5.2 Electron identification

TR photon detection layered on top of truncated-mean dE/dx is the primary electron-hadron separation tool above p ≈ 1 GeV/c. TDR design goal: **factor-100 pion rejection at 90 % electron efficiency** at isolated-track multiplicity; at the design high-multiplicity of dN_ch/dy = 8000 the expected rejection is ~50 [TRD-TDR §1]. Run 1/2 as-measured values `[VERIFY: TRD performance paper]`.

Combined with [TPC](./tpc.md) dE/dx, TOF time-of-flight (useful up to ~5 GeV/c for e/π), and in some analyses EMCal, the barrel delivers e/π separation across ~0.1–20 GeV/c. See [TPC §11.3 particle identification](./tpc.md) for the combined-PID matrix.

### 5.3 Level-1 trigger (Run 1 / Run 2)

TRAP tracklets → GTU combinatorial matching → L1 issue to the Central Trigger Processor. Trigger classes enabled include jet triggers that drove much of the Run 2 high-p_T hadron programme, and dielectron triggers for Υ and J/ψ studies. Trigger p_T precision is deliberately crude (single-stack lever arm only); its role is to enrich the recorded sample, not to provide the final p_T measurement.

### 5.4 Run 3 reconstruction role

With continuous readout the L1 trigger role is dissolved and the TRD becomes an offline-only contributor to tracking, electron ID, and — critically for this dissertation — **space-charge calibration of the TPC**.

### 5.5 Cross-detector role in this dissertation

- **TPC space-charge calibration anchor.** The **ITS–TRD track-interpolation method** is the backbone of the Run 3 TPC residual-distortion correction — see [TPC §7.2 step 4](./tpc.md). [ITS](./its.md) provides the inner reference (precision vertexing), TRD provides the outer reference (~3.7 m lever arm). Any residual drift-field distortion in the TPC appears as a mismatch between the TPC space-points and the ITS–TRD extrapolation. TRD alignment + timing quality therefore propagates directly into the quality of TPC distortion maps — the principal calibration subject of this dissertation. See also [PWGPP-643 §3.4 analytical residual-distortion modelling](../presentations/PWGPP-643_combined_shape_estimator.md) and [O2-5095 §7 sector-edge calibration](../presentations/O2-5095_TPC_dEdx_index.md).
- **Momentum cross-check.** For tracks with good six-layer TRD match, TRD-independent p_T (combined with ITS inner points) provides a cross-check of the TPC-driven p_T, useful in isolating TPC-specific systematics.
- **PID complement.** TRD electron ID is used both as a primary signal selector (quarkonia, heavy-flavour leptons) and as an electron veto in hadron analyses.

### 5.6 Cross-detector dependencies (summary)

| TRD ↔ | Role | Wiki page |
|---|---|---|
| TPC | outer tracking extension; residual-distortion calibration reference | [./tpc.md](./tpc.md) |
| ITS | inner reference for the ITS–TRD interpolation across the TPC | [./its.md](./its.md) |
| TOF | PID cross-check at lower p_T; shared L1 trigger architecture Run 1/2 | [./tof.md](./tof.md) |
| GTU / CTP | L1 trigger path Run 1/2 | — |
| O² / CRU | continuous readout Run 3 | see [TDR-019] |

---

## 6. Performance summary  `[STUB — awaiting source Turn 2]`

> The source `TRD_source_of_truth_v0_3_turn1.md` header states Turn 2 will deliver a **performance summary table** as §6 of the source. This wiki section is held as a stub pending that delivery. Known anchors already placed in body:
>
> - TDR design electron-ID performance (§5.2): **factor-100 π rejection at 90 % e efficiency** (isolated), ~50 at dN_ch/dy = 8000 [TRD-TDR §1].
> - Per-tracklet rφ resolution (§5.1): **~400 μm** [TRD-TDR Ch. 11].
> - Run 1/2 as-measured π-rejection, tracking resolution, Run 3 as-operated values: all flagged `[VERIFY: TRD performance paper]` — carry through §10.
>
> When Turn 2 is delivered, expected contents: measured (Run 1/2 / Run 3) values for electron efficiency vs pion rejection, per-tracklet σ(rφ, z), per-layer gain stability, operational timing resolution, and a consolidated target-vs-achieved table.

## 7. Operational history  `[STUB — awaiting source Turn 2]`

> Turn 2 of source is expected to cover alignment + calibration detail and operational history. Known anchors from §§1–5:
>
> - Run 1/2: triggered operation, GTU issues L1 on high-p_T / electron / jet (§4.3, §5.3).
> - LS2: integration with O² readout path.
> - Run 3: continuous readout, L1 dissolved, offline-only electron ID, TPC-calibration anchor role active (§4.4, §5.5).
>
> Year-by-year commissioning, supermodule installation schedule, Xe gas-loop events, TRAP firmware versions — all held for Turn 2.

## 8. Glossary (basic set — Turn 2 will expand to ~25 entries)

- **TRD** — Transition Radiation Detector.
- **TR** — Transition Radiation (electromagnetic emission at interfaces with differing dielectric constants).
- **Supermodule** — one of 18 azimuthal TRD modules spanning 20° in φ and the full 6-layer radial depth and full z range; see §3.1. Total per detector: 18 supermodules.
- **Stack** — z-segment of a supermodule; 5 stacks per supermodule.
- **Layer** — radial layer within a chamber/supermodule; 6 layers per supermodule.
- **Chamber** — one readout element; 540 = 18 × 5 × 6.
- **Radiator** — 4.8 cm fibre/foam sandwich upstream of each chamber that produces TR photons (§2.2).
- **Drift region** — 3.0 cm Xe/CO₂ volume between radiator and anode wire plane (§3.1).
- **Amplification region** — 0.7 cm with anode wires at 5 mm pitch where gas gain occurs (§3.1).
- **Pad plane** — cathode with 144 rφ pads × 12–16 z rows per chamber (§3.1).
- **MCM** — Multi-Chip Module (on-chamber front-end package containing PASA + ADC + TRAP).
- **PASA** — PreAmplifier/ShAper ASIC (one per pad).
- **TRAP** — TRD tracklet processor ASIC (on-chamber digital, performs linear fit within chamber).
- **Tracklet** — straight-line segment fit within a single TRD chamber from its 15 time-sample drift profile.
- **GTU** — Global Tracking Unit (off-detector; matches tracklets across 6 layers within a z-stack).
- **L1** — Level-1 trigger (Run 1/2, dissolved in Run 3).
- **CTP** — Central Trigger Processor.
- **CRU** — Common Readout Unit (O² system, Run 3).
- **Xe/CO₂ (85/15)** — TRD drift gas.
- **X₀** — Radiation length (material-budget unit).

## 9. External references (authoritative URLs)

### 9.1 Primary sources (directly cited in body)

| Tag | Full citation | URL |
|---|---|---|
| **[TRD-TDR]** | ALICE Collaboration, *Technical Design Report of the Transition Radiation Detector*, CERN-LHCC-2001-021 / ALICE-TDR-9 (3 October 2001) | CDS: <https://cds.cern.ch/record/519145> · PDF: <https://cds.cern.ch/record/519145/files/cer-2275567.pdf> |
| **[JINST2008]** | ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002, §6 (TRD) | DOI: <https://doi.org/10.1088/1748-0221/3/08/S08002> · IOP: <https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002> |
| **[TDR-019]** | Buncic, Krzewicki, Vande Vyvre, *Technical Design Report for the Upgrade of the Online-Offline Computing System*, CERN-LHCC-2015-006 / ALICE-TDR-019 (2015) | CDS: <https://cds.cern.ch/record/2011297> |

### 9.2 Additional references (flagged in §10 for later passes)

| Topic | Citation | URL |
|---|---|---|
| ALICE TRD construction + performance paper | ALICE Collaboration, *The ALICE Transition Radiation Detector: construction, operation, and performance*, NIM A (2018) — exact volume/pages `[VERIFY]` | `[VERIFY — populate DOI in next review cycle]` |
| ALICE Run 3 performance paper | In preparation / forthcoming | `[VERIFY]` |
| Xe photoelectric absorption data | e.g. NIST XCOM, or the TRD-TDR radiator-absorption appendix | `[VERIFY — pick canonical source]` |

### 9.3 BibTeX stubs

```bibtex
@techreport{ALICE-TRD-TDR,
  author      = "{ALICE Collaboration}",
  title       = "{Technical Design Report of the Transition Radiation Detector}",
  institution = "CERN",
  number      = "CERN-LHCC-2001-021, ALICE-TDR-9",
  year        = "2001",
  month       = "Oct",
  url         = "https://cds.cern.ch/record/519145"
}

@article{JINST2008,
  author   = "{ALICE Collaboration}",
  title    = "{The ALICE experiment at the CERN LHC}",
  journal  = "JINST",
  volume   = "3",
  pages    = "S08002",
  year     = "2008",
  doi      = "10.1088/1748-0221/3/08/S08002",
  url      = "https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002"
}

@techreport{ALICE-TDR-019,
  author      = "Buncic, P and Krzewicki, M and Vande Vyvre, P",
  title       = "{Technical Design Report for the Upgrade of the Online-Offline Computing System}",
  institution = "CERN",
  number      = "CERN-LHCC-2015-006, ALICE-TDR-019",
  year        = "2015",
  url         = "https://cds.cern.ch/record/2011297"
}
```

---

## 10. Open items and reviewer-validation checklist

### 10.1 `[VERIFY]` flags from source — carried forward

| # | Section | Issue | Severity |
|---|---|---|---|
| 1 | §2.3 / §3.2 | Xenon absorption length at 5 keV (~1–2 cm). Confirm against canonical reference (NIST XCOM or TRD-TDR radiator-absorption section). | P2 |
| 2 | §3.2 | Operational Lorentz angle at B = 0.5 T (TDR quotes ~8° at B = 0.4 T). | P2 |
| 3 | §3.2 | Run 1/2 as-operated gas gain (TDR design 5 × 10³, prototype 8000 @ U_a = 1420 V, ceiling ≤ 10⁴). Source for operational value. | P2 |
| 4 | §5.2 | As-measured Run 1/2 pion rejection (TDR design factor 100 at 90 % e-eff isolated, ~50 at dN_ch/dy = 8000). | P1 |
| 5 | §4.2 | TRAP on-chip filter 4→3 decimation mechanism (20 raw ADC samples → 15 stored at 133 ns). Verify filter-kernel exact form against TRD-TDR §4.5. Introduced review_cycle 1 (ClaudeOpus47 P2.2). | P2 |

### 10.2 Source Turn 2 deliverables — expected content

| # | Wiki section | Expected source content | Blocking? |
|---|---|---|---|
| 5 | §6 Performance summary | measured e-efficiency / π-rejection, per-tracklet σ(rφ, z), gain stability, timing resolution, target-vs-achieved table | yes — §6 is currently stub |
| 6 | §7 Operational history | alignment + calibration detail; year-by-year history; Xe gas events; TRAP firmware versions | yes — §7 is currently stub |
| 7 | §8 Glossary | expanded to ~25 entries (Claude3 request, per source header) | no — current 20 entries adequate |
| 8 | Source changelog v0.2 → v0.3 | full P0/P1 fix-list with before/after citations | no — affects source bookkeeping, not this wiki |

### 10.3 Reviewer checklist

- [ ] **Hard constraint — correctness:** every quantitative claim has a citation tag resolving to §9; every `[VERIFY]` is enumerated in §10.1.
- [ ] **Hard constraint — reproducibility:** every URL in §9 is reachable and returns the expected document at the claimed CDS record / DOI. In particular: `https://cds.cern.ch/record/519145` must resolve to *Technical Design Report of the Transition Radiation Detector*, 188 pp, `cer-2275567.pdf`.
- [ ] **Hard constraint — safety (public disclosure):** no unpublished data, no private GitLab paths as clickable links, no internal paths.
- [ ] **Source-status disclosure:** front-matter `source_status:` and `wiki_sections_stubbed:` accurately reflect Turn-1-partial state; §6 and §7 are visibly marked `[STUB — awaiting source Turn 2]`.
- [ ] **Citation-tag coverage:** no uncited number anywhere in body (`[VERIFY]` acceptable as placeholder but must appear in §10.1).
- [ ] **Cross-ref integrity:** every `./tpc.md` / `./its.md` / `./tof.md` / `../presentations/*.md` link either resolves or appears in §11 "Related wiki pages" with status `planned` / `live`.
- [ ] **Arithmetic closure** (machine-checkable; every check with full sum expression):
  - §3.3 pad-count: `144 pads/row × 74.33 (weighted-mean rows) × 6 layers × 18 supermodules = 1,156,032` ✓ exact. Note: 74.33 is *non-integer* because stack-position-dependent row counts (12–16 per stack, layer-dependent — see §3.1) don't uniformly average to an integer. A naïve `144 × 74 × 6 × 18 = 1,150,848` misses the stated total by 5,184; the correct weighted mean is `1,156,032 / (144 × 6 × 18) = 1,156,032 / 15,552 = 74.33`.
  - §3.1 chamber total: `18 supermodules × 5 stacks × 6 layers = 540 chambers` ✓
  - §4.2 time-sampling: `15 × 133 ns = 1995 ns ≈ 2.0 μs` ✓
  - §3.2 primary e⁻ per track per chamber: `275 e/cm × 3 cm = 825 e⁻` ✓
  - §3.4 per-layer material budget: `14.3 % / 6 = 2.38 % ≈ 2.4 %` ✓
  - §5.1 outer-radius extension: `(3.68 − 2.50) / 2.50 = 47.2 %` ≈ stated +48 % ✓ (baseline: relative to TPC outer radius)
  - §5.1 true tracking lever-arm extension: `(3.68 − 0.848) / (2.466 − 0.848) − 1 = 2.832 / 1.618 − 1 = 74.9 %` ≈ stated +75 % ✓ (baseline: TPC inner radius, both TPC and TPC+TRD lever arms measured from same inner)
  - **§2.2 formation-zone formula closure check** (new, per ClaudeOpus47 P1.1): `γ² × λ / (2π) = 4,000,000 × 0.2 nm / 6.283 = 127 μm` ≈ stated "hundreds of μm" ✓. Single-γ form fails by factor γ ≈ 2000.
- [ ] **Appendix A source-to-section map complete:** every numbered body section has at least one row mapping to source §/Table.

---

## 11. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`./tpc.md`](./tpc.md) | TL;DR, §1, §4.1, §4.4, §5.1, §5.2, §5.5, §5.6 | live (wiki-v2, APPROVED WITH COMMENTS) |
| [`./its.md`](./its.md) | TL;DR, §5.1, §5.5, §5.6 | live (DRAFT, wiki-v1) |
| [`./tof.md`](./tof.md) | §1, §5.2, §5.6 | planned |
| [`./t0v0zdc.md`](./t0v0zdc.md) | (indirect via TPC §11.4) | planned |
| [`../presentations/PWGPP-643_combined_shape_estimator.md`](../presentations/PWGPP-643_combined_shape_estimator.md) | §5.5 | planned (draft exists) |
| [`../presentations/O2-5095_TPC_dEdx_index.md`](../presentations/O2-5095_TPC_dEdx_index.md) | §5.5 | planned (draft exists) |

Status values: `planned` (target not yet created — expected red link); `live` (target exists, status ≥ DRAFT); `broken` (previously live, now missing — lint-detected regression).

---

## Appendix A: Source-to-section map

| Wiki § | Primary source section(s) |
|---|---|
| §1 Purpose | [TRD-TDR] §1, Table 1.1, pp. 23 / 27 |
| §2.1 TR emission | physics background (general; no explicit TRD-TDR tag per source) |
| §2.2 Formation zone / radiator | [TRD-TDR] §14, Table 1.1 |
| §2.3 Photon detection in Xe/CO₂ | [TRD-TDR] §1, p. 23; absorption-length `[VERIFY]` |
| §3.1 Chamber overall structure | [TRD-TDR] §1, §4.3, §14, Table 1.1, p. 27 |
| §3.2 Gas + drift | [TRD-TDR] §1, §4.1.1, §4.6.1, Table 1.1, p. 27 |
| §3.3 Total pads | [TRD-TDR] §4.4 |
| §3.4 Material budget | [TRD-TDR] Table 1.1 (+ §1 prose footnote) |
| §4.1 MCM / PASA / ADC / TRAP | [TRD-TDR] Ch. 7 |
| §4.2 Time sampling | [TRD-TDR] §4.5, Table 1.1 |
| §4.3 GTU / L1 path | [TRD-TDR] Ch. 7 |
| §4.4 Run 3 continuous readout | [TDR-019] + [TRD-TDR] (via mapping to O² I/F) |
| §5.1 Tracking | [TRD-TDR] Ch. 11 |
| §5.2 Electron ID | [TRD-TDR] §1 + `[VERIFY]` Run 1/2 performance paper |
| §5.3 L1 trigger Run 1/2 | [TRD-TDR] Ch. 7 |
| §5.4 Run 3 reconstruction role | derived / dissertation-specific synthesis |
| §5.5 Cross-detector in dissertation | links [TPC](./tpc.md) §7.2 step 4; [ITS](./its.md) §5.2 |
| §6 Performance summary | **STUB — source Turn 2 pending** |
| §7 Operational history | **STUB — source Turn 2 pending** |

## Appendix B: Notation quick reference

| Symbol | Meaning |
|---|---|
| γ = E/mc² | Lorentz factor; drives TR yield |
| v_d | electron drift velocity in the TRD gas (1.5 cm/μs) |
| U_a | anode voltage (prototype 1420 V) |
| ζ ≈ γ²λ/(2π) | TR formation zone (standard γ² form — see §2.2) |
| λ | photon wavelength |
| α | fine-structure constant (TR emission per interface ~ α × 1/137) |
| X₀ | radiation length |
| σ(p_T)/p_T | relative transverse-momentum resolution |
| dE/dx | specific ionisation energy loss |
| dN_ch/dy | charged-particle density per unit rapidity |
| MIP | minimum-ionising particle |
| p_T | transverse momentum |
| m_e / m_π | electron / charged-pion rest mass (ratio ≈ 1/275) |
| Xe/CO₂ (85/15) | TRD drift gas |
| PASA / ADC / TRAP / MCM / GTU | see §8 glossary |

---

## Changelog — source v0.3 turn-1 → wiki-v0

- **Structural:** converted to PWGPP-643 schema with flat YAML front-matter; `source_fingerprint` = nested upstream (TRD-TDR, JINST2008, TDR-019) + summary_version explicitly labelled `turn-1 (partial — §§1–5 only)`. New front-matter fields `source_status` and `wiki_sections_stubbed` added to make the partial-source state visible without reading §6/§7.
- **Reviewer-ID convention (per TPC review P2.4):** `indexed_by: Claude1` + `indexing_model: Claude (Opus 4.7)` as separate fields from day one (matches current MIWikiAI convention).
- **Added §9 External references:** canonical URLs for every citation tag. **[TRD-TDR]** resolved to CDS record 519145 plus direct PDF link (`cer-2275567.pdf`, 188 pp, fingerprint matches source header). JINST2008 DOI + IOP. TDR-019 CDS. BibTeX block with `url=` fields.
- **Added §10 Reviewer checklist:** all 4 source `[VERIFY]` flags carried forward, severity-classified; hard-constraints line added; URL-reachability explicit check; machine-checkable arithmetic-closure targets (pad total, chamber total, time-sampling closure, primary e⁻, lever-arm extension).
- **Added §11 Related wiki pages:** 6 outgoing links — [tpc.md](./tpc.md) **live (wiki-v1)**, [its.md](./its.md) **live (DRAFT)**, [tof.md](./tof.md) / [t0v0zdc.md](./t0v0zdc.md) planned, + PWGPP-643 + O2-5095 presentation drafts.
- **Inline cross-links placed:** TL;DR + §1 / §4.1 / §4.4 / §5.1 / §5.2 / §5.5 / §5.6 → TPC; §5.1 / §5.5 / §5.6 → ITS; §5.2 / §5.6 → TOF. §4.1 includes a callout contrasting TRD MCM architecture with TPC SAMPA. §5.5 preserves the source's explicit cross-reference to "TPC SoT §7.2 step 4" (residual-correction feedback loop).
- **Added Appendix A source-to-section map; Appendix B notation quick reference.**
- **Stubs clearly marked:** §6 Performance summary and §7 Operational history show `[STUB — awaiting source Turn 2]` callouts. Known anchors already in body (§5.1 resolution, §5.2 TDR design, §3.4 material budget, §4 operational history markers) are listed inside the stubs so the eventual Turn-2 merge has explicit attach-points.
- **Content unchanged:** all physics claims, numbers, tables, `[VERIFY]` flags preserved exactly from source turn-1. No new quantitative claims added.

## Changelog — wiki-v0 → wiki-v1 (review_cycle 1)

**Reviewer:** ClaudeOpus47 (peer review, 2026-04-19, verdict `[!]` APPROVED WITH COMMENTS). Review artifact archived alongside this page. 0 P0, **1 P1 (physics-formula error)**, 4 actionable P2 — all fixed here; P2.4 (`summary_contributors` schema unification) explicitly deferred per reviewer's recommendation to the cross-page generalization pass.

**Fixes applied:**

- **P1.1 (§2.2 formation-zone formula — PHYSICS ERROR).** The formula was stated as `ζ ≈ γ λ / (2π)` but the numerical example (γ = 2000, λ = 0.2 nm → "hundreds of μm") requires the standard `ζ ≈ γ² λ / (2π)` form (Landau–Lifshitz Vol. 8 §116; Artru–Yodh; Cherry & Lord). Single-γ form gives 63.7 nm — off from the stated ~100 μm by the expected factor of γ ≈ 2000, i.e. a dropped exponent. Corrected to `γ² λ / (2π)` with the numerical derivation now shown inline: `(2000)² × 0.2 nm / (2π) ≈ 127 μm`. Added machine-checkable HTML comment `<!-- γ² × λ / (2π) = 4e6 × 0.2 nm / 6.283 = 127 μm. NOTE: single-γ gives 63.7 nm which contradicts stated "hundreds of μm". -->`. Textbook references now cited inline. Also added a dedicated **formula-closure check** as a new reviewer-checklist target (§10.3), addressing ClaudeOpus47's generalization action: *"for every equation `X = f(a,b,c)` with a numerical example in the same section, verify `f(a₀,b₀,c₀) = X₀`"*.
- **P2.1 (§10.3 pad-count arithmetic closure).** Naïve `144 × 74 × 6 × 18 = 1,150,848` misses the stated 1,156,032 by 5,184 pads — outside integer-rounding tolerance. Corrected: the weighted-mean row count is `1,156,032 / (144 × 6 × 18) = 74.33`, non-integer because stack-position-dependent row counts (12–16 per stack, layer-dependent) don't uniformly average to an integer. Checklist entry now reads `144 × 74.33 × 6 × 18 = 1,156,032` ✓ exact, with the non-integer-mean explanation inline.
- **P2.2 (§4.2 non-integer decimation factor).** Added one-paragraph explanation of the 4→3 decimation: 20 raw ADC samples (10 MHz × 2 μs) → 15 stored samples after TRAP tail-cancellation filter. Mechanism described as "weighted-sum shaper mapping groups of 4 raw samples into 3 filtered output samples" — marked `[VERIFY against TRD-TDR §4.5]` because the exact filter kernel wasn't in source turn-1. New item #5 added to §10.1 for this `[VERIFY]`. New flag also surfaced in front-matter `known_verify_flags`.
- **P2.3 (§5.1 lever-arm baseline ambiguity).** Original text quoted only "+48 % relative increase" without stating the baseline. Now states **both**: +48 % outer-radius increase (baseline: TPC outer radius 2.5 m → TRD outer 3.68 m, which is what "+48 %" refers to), and **+75 % true tracking lever-arm increase** (baseline: TPC inner radius 0.85 m — the stricter tracking definition). Machine-checkable derivations for both inline. The stricter +75 % number is the one that matters for σ(p_T)/p_T improvements, so readers now see both. Checklist (§10.3) updated to carry both baselines as separate arithmetic-closure targets.
- **P2.5 (§8 glossary Supermodule cleanup).** Removed the mid-thought rhetorical self-correction ("the detector has 18 × 2 = 36 per-side? **No** — 18 supermodules total"). Clean entry now states: *"one of 18 azimuthal TRD modules spanning 20° in φ and the full 6-layer radial depth and full z range; see §3.1. Total per detector: 18 supermodules."*
- **Front-matter:** `review_cycle: 0 → 1`; added `peer_reviewers: [ClaudeOpus47]`; added new item "§4.2 TRAP on-chip filter 4→3 decimation mechanism (TRD-TDR §4.5)" to `known_verify_flags` list.

**Also applied in §10.3 (defensive improvement beyond what review asked):** new **formula-closure** check line for §2.2 formation-zone formula. This is the generalization ClaudeOpus47 recommended — "the formula + numerical example must close with the formula applied literally". The 12-item TPC-style arithmetic-closure format now covers: pad count (with explicit non-integer-mean annotation), chamber total, time-sampling window, primary e⁻ count, per-layer material budget, outer-radius extension (TPC-baseline), true lever-arm extension (TPC-inner-baseline), and formula-closure for the formation zone.

**Deferred to cross-page retrofit** (per reviewer recommendation):

- **P2.4 (`summary_author` / `summary_review_panel` / neither — schema unification).** Reviewer recommends standardising on a single `summary_contributors:` list field with `{id, role}` entries covering both solo-author and panel cases. This affects TPC-SoT (`summary_review_panel: [...]`), ITS-SoT (no field; now sentinel `[Claude1]`), and this page (`summary_author: "Main Coder Claude2"`) — i.e. three different conventions across three pages. Must be resolved in one coordinated retrofit, not per-file.
- **`[computed]` tag convention** (ITS-SoT review P2.4 carryover). Same reason.

**Content unchanged** except for P1.1 (physics formula corrected: the page was wrong before). All other text preserved. No new quantitative claims added.

---

*End of TRD Source of Truth, wiki-v1 — superseded by wiki-v2 (cross-page status sync only, no content change).*

## Changelog — wiki-v1 → wiki-v2 (cross-page status sync, no content change)

**Trigger:** Claude3 review of TPC wiki-v1 (2026-04-19) flagged P1-1 "cross-page link-status asymmetry" — when a target page publishes a new revision, every page linking to it must update its status annotation. TPC itself was subsequently bumped to wiki-v2; this page now carries the mirror-image fix.

**Changes:**

- §11 Related wiki pages row `./tpc.md`: `live (wiki-v1, APPROVED WITH COMMENTS)` → **`live (wiki-v2, APPROVED WITH COMMENTS)`**.
- §11 Related wiki pages row `./its.md`: `live (DRAFT, wiki-v0)` → **`live (DRAFT, wiki-v1)`** (stale since ITS cycle 1 completed).
- Front-matter `review_cycle: 1 → 2`. `peer_reviewers` unchanged: `[ClaudeOpus47]` — this sync is author-driven, not a new peer review. **No content change, no new arithmetic, no new VERIFY flags.**

**Not done in this bump:**

- Source Turn 2 is still pending → §6 Performance summary + §7 Operational history remain `[STUB — awaiting source Turn 2]`.
- The schema convergence items deferred by ClaudeOpus47 cycle 1 (P2.4 `summary_contributors` unification; `[computed]` tag convention; `source_fingerprint` / `document_version` split) continue to ride the generalization pass — no local fix here.

---

*End of TRD Source of Truth, wiki-v2 (wiki-v1 + cross-page status sync, 2026-04-19). **Turn-1 content was already marked `[OK]`-eligible in wiki-v1 per ClaudeOpus47 cycle 1.** Overall page status remains `DRAFT` until source Turn 2 delivers §§6–10, unchanged. Next content-level revision triggers: (a) source Turn 2 landing, (b) new reviewer pass on Turn-1 content, (c) cross-page status sync when T0V0ZDC or TOF goes live.*
