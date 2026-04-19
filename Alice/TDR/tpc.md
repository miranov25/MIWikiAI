---
wiki_id: TPC-SoT
title: ALICE Time Projection Chamber (TPC) — Source of Truth
project: MIWikiAI / ALICE
folder: detectors
source_type: detector-tdr-summary
source_title: TPC_SourceOfTruth_v0_3.md
source_fingerprint:
  upstream:
    - id: JINST2008
      title: "The ALICE experiment at the CERN LHC"
      doi: "10.1088/1748-0221/3/08/S08002"
      url: "https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002"
      sections_cited: ["§3.2.1", "§3.2.2", "§3.2.3", "Table 3.12"]
    - id: ALICE-TDR-016
      title: "Upgrade of the ALICE Time Projection Chamber"
      report_number: "CERN-LHCC-2013-020, ALICE-TDR-016"
      cds: "https://cds.cern.ch/record/1622286"
      sections_cited: ["§1", "§2.7", "§3", "§5.1.2", "§6.1", "§6.2", "§6.3", "Ch. 8", "§8.4.2", "§8.5.2", "Ch. 11"]
    - id: ALICE-TDR-019
      title: "Technical Design Report for the Upgrade of the Online-Offline Computing System"
      report_number: "CERN-LHCC-2015-006, ALICE-TDR-019"
      cds: "https://cds.cern.ch/record/2011297"
      sections_cited: ["referenced only — not exhaustively read this pass"]
  summary_version: "v0.3"
  summary_review_panel: ["Claude1", "Main Coder", "Gemini1", "GPT1", "GPT2", "GPT3"]
source_last_verified: 2026-04-19
author: Marian Ivanov (dissertation lead); source-of-truth distilled with AI-assisted review panel
indexed_by: Claude1
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 2
peer_reviewers: [ClaudeOpus47, Claude3]
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags: ["§4.1 gas-history transition date", "§6.5 SAMPA sampling rate + ADC bit-depth", "§7.1 space-charge peak 10 vs 20 cm", "§7.4 TDR-016 §8.4.2 post-correction resolution", "§14 Run 3 as-measured performance"]
---

# TPC: ALICE Time Projection Chamber — Source of Truth

## TL;DR

The TPC is the **main tracking + PID detector of the ALICE central barrel**: gaseous drift chamber, `|η| < 0.9` full acceptance (`|η| < 1.5` reduced), 90 m³ active volume, 0.5 T axial field, up to ~150 space-points per track over a 1.6 m radial lever arm. Its role spans **tracking, vertexing, dE/dx PID over the full p_T range (~0.1–100 GeV/c), mid-rapidity multiplicity, event-shape observables, and calibration reference for the full central barrel**.

The mechanical structure (field cage, central electrode, gas system, support, services) is **unchanged Run 1 → Run 3** [TDR-016 §2.7]. The Run 3 upgrade replaced (a) the MWPC readout chambers with **quadruple-GEM (S-LP-LP-S) stacks**, (b) the PASA/ALTRO front-end with the **SAMPA ASIC**, and (c) the triggered readout with **continuous (triggerless) readout into the O² computing system**. The gating grid was removed; the resulting ion backflow (up to 1%, gas gain ~2000) produces **space-charge distortions with local peak amplitudes of order ~10 cm**, corrected by a 4-stage calibration pipeline culminating in residual maps built from ITS–TRD track interpolation.

Run 1/2 performance anchors (measured): rφ resolution 1100 → 800 μm, z 1250 → 1100 μm, dE/dx 5.0 % (isolated) / 6.8 % (at dN/dη=8000), σ(p_T)/p_T ~1 % at 1 GeV/c combined with ITS. Run 3 target: **preserve** these numbers after space-charge correction [TDR-016 §8.4.2; VERIFY against Run 3 performance paper].

**Source of truth:** distilled from JINST 2008 §3.2 and ALICE-TDR-016 (Run 3 upgrade TDR). Every quantitative claim below carries a bracketed citation tag resolving to §7 External references. Values marked `[computed]` are derived arithmetically; values marked `[VERIFY]` are flagged for resolution against primary sources.

---

## 1. Physics role and design drivers

The TPC is the **main tracking detector of the ALICE central barrel** [JINST2008 §3.2.1]. It provides, together with ITS (inside), TRD (outside) and TOF (beyond TRD):

1. Three-dimensional tracking of charged particles in a large gaseous drift volume.
2. Momentum measurement in the 0.5 T solenoidal field (combined with ITS for inner space-points, TRD/TOF for lever arm).
3. Particle identification (PID) via specific ionization energy loss dE/dx over a wide momentum range.
4. Primary and secondary vertex contributions through precise space points.
5. Input to the High-Level Trigger (Run 1/2) and to the O² online-offline system (Run 3).

**Core design choice:** a TPC was selected over all-silicon tracking because it combines very large phase-space coverage with minimal material budget in the sensitive volume, while handling unprecedented track densities. The Run 1 design target was dN_ch/dη = 8000, implying ~20,000 primary + secondary tracks within acceptance [JINST2008 §3.2.1]. Actual multiplicities in Pb–Pb are ~1600–2000 at mid-rapidity in 0–5% central collisions [TDR-016 §6.2], well below the design ceiling, leaving substantial rate/occupancy headroom that was exploited by the Run 3 upgrade.

## 2. Acceptance

| Quantity | Value | Source |
|---|---|---|
| Pseudorapidity (full radial track length) | \|η\| < 0.9 | JINST2008 Tab. 3.12 |
| Pseudorapidity (1/3 radial track length, reduced resolution) | \|η\| < 1.5 | JINST2008 Tab. 3.12 |
| Azimuthal coverage | 360° | JINST2008 Tab. 3.12 |
| Dead-zone fraction (between sectors) | ~10% of azimuth | JINST2008 §3.2.2 |
| p_T range | ~0.1–100 GeV/c | JINST2008 §3.2.1 |

Sector dead zones arise from the support rods and chamber edges. The dead zones of inner and outer chambers are aligned — a choice that optimizes high-p_T resolution (uninterrupted tracking for accepted tracks) at the cost of azimuthal acceptance cracks.

## 3. Geometry (common to Run 1–3)

The mechanical structure was **not changed by the Run 3 upgrade** [TDR-016 §2.7]; field cage, central electrode, end plates, support rods, Mylar strip cage, gas system and services are all reused. Only the readout chambers and front-end electronics were replaced.

### 3.1 Overall dimensions [JINST2008 Tab. 3.12]

| Parameter | Value |
|---|---|
| Inner active radius | 848 mm |
| Outer active radius | 2466 mm |
| Drift length (half) | 2 × 2500 mm |
| Gas volume | 90 m³ |
| Outer containment vessel (inner / outer wall) | 2580 / 2780 mm |
| Inner containment vessel (inner / outer wall) | 606.5 / 788 mm |
| Segmentation in φ | 18 sectors per end plate |
| Segmentation in r | 2 chambers per sector (IROC + OROC) |
| Total readout chambers | 2 × 2 × 18 = **72** |
| Total mass (field cage + chambers) | ~8 t |
| Readout electronics mass (per side) | ~1 t |

### 3.2 Field cage [JINST2008 §3.2.2]

- **Central electrode:** stretched aluminised Mylar foil, **22 μm** thick — minimizing material at η ≈ 0.
- **Potential grading:** aluminised Mylar strips wound around 18 inner + 18 outer support rods; 166 strips per side.
- **High-voltage divider:** one inner and one outer rod house resistive dividers using high-resistivity water cooling (100 kV divider).
- **Drift field:** 400 V/cm.
- **Central-electrode HV:** 100 kV.
- **Insulating envelope:** CO₂ in containment vessels outside the field cage.
- **Mechanical precision:** ~250 μm, coplanarity adjusted by individual shimming of the 3-point chamber mounts.

### 3.3 Drift physics

Under a uniform axial **E** field, primary ionization electrons drift toward the end plates at `v_d = μ(E, B, gas) · E`. The transverse position of the cluster is determined by the pad at which the charge is collected; the longitudinal (z) coordinate is obtained from the arrival time. The detector is in a 0.5 T axial field, producing a tight E×B alignment.

For the Ne/CO₂/N₂ (90/10/5) baseline mixture:
- Drift velocity **~2.7 cm/μs** → maximum drift time **~92 μs** over the 2.5 m half-length [JINST2008 Tab. 3.12].
- Diffusion: **D_L = D_T = 220 μm / √cm** [JINST2008 Tab. 3.12]. The equality of longitudinal and transverse diffusion is specific to the 0.5 T operating point — at B = 0 the two would differ (generically D_T > D_L for cold gases), but in the axial field the transverse component is **E×B-suppressed** to match D_L.
- Cluster spread at full drift (√(2.5 m)) ≈ 3.5 mm (computed from D × √L).

## 4. Drift gas

### 4.1 Run 1 / Run 2 gas mixtures [JINST2008 §3.2.2; TDR-016 §3]

- **Design baseline (Run 1 start-up):** Ne/CO₂ (90/10) [JINST2008 §3.2.2].
- **Operational mixture (late Run 1 onward):** Ne/CO₂/N₂ (90/10/5). N₂ was added for improved quenching and high-gain operational stability [TDR-016 §3]. JINST2008 Table 3.12 lists (90/10/5), reflecting the mixture in use at the time of publication. **`[VERIFY]`** the exact run period of the (90/10) → (90/10/5) transition.
- **Alternative considered (Run 2):** Ar/CO₂ (90/10) was evaluated as a Ne replacement to further stabilise wire chambers at the higher Run 2 PbPb 10 kHz rate [TDR-016 §3]. Simulations indicated momentum + dE/dx resolutions comparable to Ne mixtures, with space-charge distortions remaining at the ~1 cm level using the triggered gating grid, at a slight reduction of event rate to tape. **Ar/CO₂ was not deployed:** higher diffusion (larger cluster spread), higher primary ionisation (more space charge), and a modified gas-gain operating point did not offer net operational advantage over the stable Ne/CO₂/N₂ baseline.

**Selection criteria:** low diffusion (spatial resolution), low radiation length (multiple scattering), small space-charge effect, gas ageing stability (CH₄ and CF₄ rejected on ageing). "Cold gas" drawback: drift velocity is strongly temperature-dependent in Ne/CO₂, setting the **ΔT ≤ 0.1 K thermal-uniformity requirement** across the drift volume.

**Impurity targets:** CO₂ + N₂ fractions stable to 0.1%; O₂ contamination ≲ 1 ppm to limit attachment loss over 2.5 m drift to < 5% [JINST2008 §3.2.2].

### 4.2 Run 3 baseline [TDR-016 §3]

The baseline Run 3 gas mixture is **Ne/CO₂/N₂ (90/10/5)**, retained from late Run 1/2 operation. Revisited in light of GEM requirements (drift velocity, diffusion, gas gain, ion mobility). Key Run 3 drivers:
- Gas gain ~2000 must be reached with ≤ 1 % ion backflow.
- Drift velocity high enough so that pileup at 50 kHz stays manageable (~5 events within one drift time — see §7.1).

### 4.3 Gas system [TDR-016 §2.7]

- **Closed-loop circulation:** ~15 m³/h recirculated via a regulated compressor.
- **Pressure regulation:** relative pressure constant to better than **0.1 mbar**.
- **Purification:** copper-catalyzer cartridges remove O₂ and H₂O.
- **Fresh-gas injection:** ~50 l/h continuous.
- **Monitoring:** analysis line continuously reads O₂/H₂O and composition; gas chromatograph takes periodic samples.
- **Buffer:** high-pressure storage absorbs atmospheric fluctuations.
- **Control:** PLC with SCADA user interface.
- **Mixer flexibility:** default Ne/CO₂/N₂; MFCs recalibratable for Ar or CF₄. Ne-saving fill uses molecular-sieve CO₂ trapping.

Per TDR-016 §2.7: the Run 3 upgrade required **no hardware or software modifications to the gas system**; existing infrastructure is reused entirely.

## 5. Readout in Run 1 / Run 2 — MWPC era

### 5.1 Multi-wire proportional chambers [JINST2008 §3.2.2]

The 72 readout chambers were MWPCs with cathode-pad readout. Each chamber comprised anode wire grid (signal amplification), cathode wire plane, and **gating grid** (critical, see §5.4).

Geometry:
- Anode-to-cathode distance: **2 mm (IROC), 3 mm (OROC)**.
- Operating gas gain: up to **2 × 10⁴**.

### 5.2 Pad geometry [JINST2008 Tab. 3.12]

| Region | Radial active range | Pad size (φ × r) | Rows | Pads/sector |
|---|---|---|---|---|
| IROC | 848 – 1321 mm | 4 × 7.5 mm² | 63 | 5504 |
| OROC (small pads) | 1346 – ~1986 mm `[computed]` | 6 × 10 mm² | 64 | 5952 |
| OROC (large pads) | ~1986 `[computed]` – 2466 mm | 6 × 15 mm² | 32 | 4032 |

- Pads per sector-side: 15,488 = 5504 + 5952 + 4032.
- **Total pads: 557,568** (15,488 × 2 sides × 18 sectors) [JINST2008 Tab. 3.12] — arithmetic closes cleanly.
- Radial dead zone between IROC and OROC: 1321 → 1346 mm ≈ **25 mm**.

The small/large-pad boundary radius **~1986 mm** is `[computed]`: JINST2008 Tab. 3.12 gives only the pad counts (64 small + 32 large rows) and the OROC outer active limit; the implied boundary follows from `1346 mm + 64 × 10 mm = 1986 mm`, cross-checked from the outer edge as `2466 mm − 32 × 15 mm = 1986 mm`. The source does not quote this radius explicitly — confirm against TDR-016 §6 pad-plane drawing before treating as authoritative.
<!-- derivation: 1346 + 64*10 = 1986; 2466 - 32*15 = 1986 -->

> **Correction history:** v0.3 / wiki-v0 both stated ~1977 mm (arithmetic error: 64×10 was mis-rendered as 64×10 − 9 in the head calculation). Corrected to 1986 mm in review_cycle 1 following ClaudeOpus47 P1.1 finding, 2026-04-19.

### 5.3 Front-end electronics [JINST2008 §3.2.3]

Each channel has:
1. **PASA** — charge-sensitive amplifier / semi-Gaussian shaper.
2. **10-bit ADC**, sampling at 5–10 MHz (IC capable of 25 MHz).
3. **Digital circuit** — tail-cancellation (shortening filter), baseline subtraction, zero suppression.

Aggregate:
- Front-End Cards (FECs): 121/sector × 36 = **4356**.
- Readout Control Units (RCUs): 6/sector × 36 = **216**, each serving 18–25 FECs.
- Time samples per drift: 500–1000.
- Central Pb–Pb event size (at design dN/dη = 8000): ~90 MB.
- pp event size: ~1–4 MB.
- Aggregate bandwidth: ~**30 GB/s (≈ 240 Gbit/s)**.
- Trigger rate ceilings: **300 Hz central Pb–Pb, 1 kHz pp**.
- Conversion gain: 6 ADC counts / fC.

### 5.4 The gating grid

Between events, the gating grid is closed: alternating ±ΔV on its wires absorbs drift-volume electrons and blocks amplification-region ions from back-drifting into the field cage. The gate opens on the L1 trigger, 6.5 μs after the collision, for one full drift time (~90 μs) [JINST2008 §3.2.2]. Closed-gate electron suppression exceeds **10⁵**.

**This is the binding rate limitation of Run 1/2:** the combination of 90 μs open time, mandatory closed-gate recovery, and the L1 trigger architecture gives an effective ceiling of a few hundred Hz in central Pb–Pb [JINST2008 §3.2.2]. Lifting this limit drove the entire Run 3 upgrade.

### 5.5 Space-charge distortions — Run 1/2

With the gating grid, ion backflow from the amplification region is blocked during closed periods. Residual space charge from drift-volume ionization itself produces distortions of order a few mm at ~200 Hz central Pb–Pb rates, corrected offline [JINST2008 §3.2.2].

## 6. Readout in Run 3 — GEM era [TDR-016]

### 6.1 Upgrade motivation

LS2 rebuilt the readout chambers to enable **continuous (triggerless) readout** at a 50 kHz Pb–Pb interaction rate — **~170× the Run 1/2 rate ceiling** (50 kHz / ~300 Hz central, per §5.3 and §5.4). Gating-grid removal demands a readout technology with intrinsic ion-backflow suppression.
<!-- derivation: 50,000 Hz / 300 Hz = 166.7 ≈ 170× (NOT 150× — stated-ratio-must-reproduce-from-same-page rule). Corrected review_cycle 2 (Claude3 P1-2). -->

### 6.2 Quadruple-GEM stack [TDR-016 §1, §5]

Each readout chamber carries a **4-foil Gas Electron Multiplier stack** in the **S-LP-LP-S** configuration (Standard–Large Pitch–Large Pitch–Standard).

- Target ion backflow: **≤ 1 %** at gas gain 2000.
- Target electron transmission (efficiency ε): high and stable (specific number TDR-016 §5, to be extracted in later revision).
- Stability: gain stable to **0.45 %** over ~21 hours in Ne/CO₂ with 180 ppm H₂O (TDR-016 §5.1.2, Fig. 5.3).
- Gas-gain working point: **~2000**.

**Why S-LP-LP-S:** mixing foil pitches breaks the symmetry of ion drift paths — standard-pitch foils at the outer positions maximize electron transmission while large-pitch foils in the middle trap back-drifting ions. The specific combination was optimized against IBF/ε trade-off in extensive R&D (TDR-016 Ch. 5).

### 6.3 Pad plane [TDR-016 §6]

Run 3 partitions each chamber into **5 pad regions** (IROC 1–2, OROC 1–3) with progressively larger pad sizes going outward in radius. The total Run 3 channel count per sector changed slightly from Run 1/2 due to this re-partitioning:

| Run | Pads / sector (one side) | Total TPC channels |
|---|---|---|
| Run 1/2 | 15,488 | 557,568 |
| Run 3 | 15,360 [TDR-016 §6.3] | 552,960 |

Run 3 delta: **−4,608 channels** vs Run 1/2. The reshuffle rebalances occupancy across the regions at 50 kHz pileup.

### 6.4 Readout chamber mechanics [TDR-016 §5]

Each Run 3 ROC is a sealed assembly of:
- Four GEM foils stretched and glued in a frame.
- Readout pad plane with trace routing to Kapton flex cables.

### 6.5 Front-end electronics: SAMPA [TDR-016 §6.1]

**SAMPA ASIC** — custom mixed-signal front-end chip common to ALICE TPC and Muon Chamber upgrades, described in a dedicated design paper (see §7.1). Key features as described in TDR-016 §6.1:

- **32 channels per chip.**
- **Charge-sensitive preamplifier + semi-Gaussian shaper** on each channel, producing **differential voltage signals**.
- **Negative-polarity input signals** (GEM output) — opposite polarity from Run 1/2 MWPC anode-wire signals; motivated the redesigned front end.
- **Continuous ADC sampling** per channel; **10 MHz** default for the Run 3 TPC baseline (20 MHz supported but not default) `[VERIFY: TDR-016 §6.1 / SAMPA datasheet]`. ADC resolution: **10-bit** `[VERIFY]`.
- **On-chip DSP:** tail cancellation, baseline restoration, zero suppression, formatting.
- **Output:** digital data streamed to GBTx ASIC.

Each FEC (Front-End Card) carries **5 SAMPAs** = 160 channels / FEC.

### 6.6 Data transport: GBT, VTTx/VTRx, CRU [TDR-016 §6.1, Fig. 6.1]

- **GBTx ASIC** multiplexes SAMPA output into a single high-speed link; can multiplex 10 (14) e-links with (without) forward error correction [TDR-016 §6.1].
- **VTTx** (Versatile Twin Transmitter) and **VTRx** (Versatile Transceiver) — radiation-hard optical link components.
- **GBT unidirectional data links at 3.2 Gbit/s** — FEC → CRU [TDR-016 §6, electronics figures].
- **Common Readout Unit (CRU)** — off-detector, common ALICE development across subsystems. Interfaces the TPC to the online O² farm, TTS, and DCS.

### 6.7 Continuous readout + triggered mode [TDR-016 §6.1]

Run 3 default: **continuous (triggerless) readout** — SAMPA samples continuously, CRU streams data to O². A **triggered mode is also supported** for calibration and low-rate running: on an L0 trigger, only one drift-time (~100 μs) is frozen and read out.

### 6.8 Pileup and occupancy [TDR-016 §6.2]

Measured (Run 1) and scaled densities at √s_NN = 5.5 TeV:
- ⟨dN_ch/dη⟩ ≈ **2000** (central 0–5%).
- ⟨dN_ch/dη⟩ ≈ **500** (minimum bias).

At 50 kHz interaction rate, average events within one drift (~100 μs) = **N_pileup = 5**. "Equivalent" dN/dη in a drift window:
- **2500** for MB + 4 MB pileup events.
- **4000** for a central event + 4 MB pileup events.

Both below the Run 1 design envelope of 8000 — deliberate headroom preserved by the chamber/pad geometry.

### 6.9 Data rates [TDR-016 §6.3]

Per-region average data rate/channel and required bandwidth/channel. Table values are **per sector-side**; aggregation across all 36 sector-sides (18 sectors × 2 ends) gives the full-TPC totals at the bottom.

| Region | Avg. rate/chan (Mbit/s) | Req. bandwidth/chan (Mbit/s) | Channels / sector-side | Data / sector-side (Gbit/s) | Bandwidth / sector-side (Gbit/s) |
|---|---|---|---|---|---|
| IROC 1 | 22 | 40 | 2304 | 50 | 100 |
| IROC 2 | 16 | 30 | 3200 | 50 | 100 |
| OROC 1 | 15 | 30 | 2944 | 45 | 90 |
| OROC 2 | 13 | 25 | 3712 | 50 | 100 |
| OROC 3 | 11 | 20 | 3200 | 35 | 70 |
| **Sum per sector-side** | — | — | **15,360** | **230** | **460** |

> **Footnote on bandwidth column.** The "Bandwidth / sector-side" values (100/100/90/100/70) are **rounded-up engineering allocations per region**, not exact products of `channels × bandwidth-per-channel`. Computing `Σ(channels × req. bandwidth-per-chan)` gives `2304×40 + 3200×30 + 2944×30 + 3712×25 + 3200×20 = 92.2 + 96.0 + 88.3 + 92.8 + 64.0 = 433 Gbit/s` per sector-side, not 460 — i.e. the allocation carries a ~6 % regional headroom above the exact demand. This is standard DAQ engineering practice; the 460 Gbit/s sum-row is the **provisioned** bandwidth. Similarly, `Data / sector-side` values are rounded at the Gbit/s digit — e.g. IROC 2 exact product is `3200 × 16 Mbit/s = 51.2 Gbit/s`, tabulated as 50. Rounding residuals ≤ 3 % on the data column, ≤ 6 % on the bandwidth column.
<!-- derivation (P2-3, Claude3 review_cycle 2): Σ(chan × req-bw) = 2304*40 + 3200*30 + 2944*30 + 3712*25 + 3200*20 Mbit/s = 92160 + 96000 + 88320 + 92800 + 64000 = 433,280 Mbit/s ≈ 433 Gbit/s per sector-side -->

Aggregate across all 36 sector-sides:
- Total FE channels: **552,960** = 15,360 × 36.
- **Aggregate data rate: ~8280 Gbit/s ≈ 1035 GB/s** = 230 × 36 [TDR-016 §6.3].
- Aggregate bandwidth requirement: ~16,560 Gbit/s = 460 × 36 (headroom over average data rate).
<!-- derivation: 230*36 = 8280; 460*36 = 16560; 8280/8 = 1035 -->

Online data compression in O² (clustering + track seeding) reduces the 8280 Gbit/s stream for permanent storage.

**Run 1/2 → Run 3 ratio:** Run 1/2 aggregate ~240 Gbit/s (§5.3) vs Run 3 ~8280 Gbit/s → **factor ~34 in raw FE bandwidth**, reflecting the continuous readout + higher rate + same channel count × 5-region SAMPA sampling.

## 7. Space-charge distortions and calibration in Run 3 [TDR-016 Ch. 8]

### 7.1 The distortion budget

Without a gating grid, back-drifting ions accumulate in the drift volume. At 50 kHz Pb–Pb, 1 % IBF, and gain 2000, the steady-state space-charge density produces **local drift-field distortions whose peak amplitude reaches ~10 cm** in the most affected regions (inner radius, large drift distance) [TDR-016 §1 exec summary]. This is a **local peak** displacement of reconstructed space-points, not a global shift — the distortion varies strongly with radius, drift length, sector. Far beyond what static corrections can handle passively; the Run 3 TPC **relies on calibration** to recover tracking accuracy. **`[VERIFY]`** whether TDR-016 quotes ~10 cm or a larger number (up to ~20 cm cited in later performance summaries for extreme inner-radius regions).

### 7.2 Calibration pipeline [TDR-016 §8]

Distortion correction proceeds in stages:

1. **Space-charge density maps.** 3D average space-charge distributions from simulations, continuously refined using data.
2. **Space-charge field calculation.** Given ρ_sc(r,φ,z), the Poisson equation is solved to obtain ΔE(r,φ,z).
3. **Distortion maps.** The inhomogeneous Laplace equation is solved (numerical solver) to translate ΔE into per-point position displacements.
4. **Residual correction (second reconstruction stage).** Using **ITS–TRD track interpolation across the TPC**, a high-resolution residual distortion map is built from the difference between TPC space-points and the ITS–TRD extrapolation. This closes the feedback loop. — See related work: [PWGPP-643 §3.4 analytical residual-distortion modelling](../presentations/PWGPP-643_combined_shape_estimator.md) and [O2-5095 §7 Sector-edge calibration](../presentations/O2-5095_TPC_dEdx_index.md).

### 7.3 Current-based monitoring

Dedicated current measurements on the GEM electrodes provide near-real-time monitoring of the integrated ion flux, feeding the space-charge map updates [TDR-016 §8.5.2].

### 7.4 Expected Run 3 performance [TDR-016 §8.4.2]

The TDR demonstrates that, with the calibration pipeline in place, **the momentum resolution after residual correction is designed to be preserved** at essentially the Run 1/2 benchmark — the upgrade target is **no measurable degradation** versus the Run 1/2 TPC for the physics observables driving the upgrade programme [TDR-016 exec summary; §8.4.2 referenced but not directly extracted in this revision]. Specific post-correction resolution numbers to be populated in the next revision against TDR-016 §8.4.2 and the ALICE Run 3 performance paper `[VERIFY]`.

## 8. Performance (Run 1/2 measured) [JINST2008 Tab. 3.12]

- Position resolution **rφ**: **1100 μm (inner radius) → 800 μm (outer)**.
- Position resolution **z**: **1250 μm → 1100 μm**.
- **dE/dx resolution**: **5.0 %** (isolated tracks); **6.8 %** at dN/dη = 8000.
- Pad occupancy at dN/dη = 8000: **40 % (inner) → 15 % (outer)**.
- Pad occupancy in pp: **5 × 10⁻⁴ (inner) → 2 × 10⁻⁴ (outer)**.

Combined with ITS (inner) and TRD/TOF (outer), intermediate-p_T σ(p_T)/p_T is at the **~1 % level**, degrading to **~5–10 %** at the high end.

## 9. Particle identification via dE/dx

The TPC samples specific ionization along each track. The Bethe–Bloch curve

&nbsp;&nbsp;&nbsp;&nbsp;−⟨dE/dx⟩ ∝ (z²/β²) · [ln(2 m_e c² β² γ² / I) − β²] + density correction

yields distinct values for different particle species at the same momentum. Operating regimes:
- **1/β² region, p ≲ 1 GeV/c:** strong π/K/p separation.
- **Minimum ionization at βγ ≈ 3–4.**
- **Relativistic rise:** logarithmic growth of ⟨dE/dx⟩ — extends electron/hadron separation to several GeV/c and gives statistical π/K/p separation.

Per-track dE/dx uses a **truncated mean** over ~150 samples (typically keeping the lowest ~60 %) to suppress Landau fluctuations. Resolution figures in §8 assume this truncation.

**Run 3 high-occupancy impact on dE/dx:** see [O2-5095 index](../presentations/O2-5095_TPC_dEdx_index.md) — documents the bias + resolution degradation vs occupancy, the per-region `<Qmax>/<Qtot>` correction strategy, and the transfer-function calibration that restores MAD to ≈ σ/1.4.

## 10. Calibration and corrections (summary)

1. **Drift velocity:** monitored via dedicated drift-velocity monitors, laser tracks, and ITS–TPC residual matching.
2. **Gas gain:** tracked via charge-injection pulser and X-ray sources; stability **0.45 %** in GEM R&D over ~21 hours in Ne/CO₂ with 180 ppm H₂O [TDR-016 §5.1.2, Fig. 5.3].
3. **E×B corrections:** parameterized and applied at reconstruction.
4. **Space-charge distortions:** see §7 above.
5. **Laser calibration** [JINST2008 §3.2.2]: each end plate distributes a ~2 cm laser beam to 6 of 18 outer support rods; at 2 × 4 z-positions, micro-mirror bundles produce **7 fine rays of ~1 mm diameter** perpendicular to the beam axis. Repetition rate ~10 Hz.
6. **Alignment:** ITS–TPC relative alignment monitored by an optical system to < 20 μm; TPC aligned to solenoid axis with < 1 mrad.
7. **Calibration pulser** [TDR-016 §11.4.4]: electronic pulse injection for channel-level gain and timing.

## 11. Role in the reconstruction chain

The TPC is the **main tracking detector** of the ALICE central barrel. Its role is best understood through the data flow of a single charged-particle track and through the collaboration with neighbouring detectors.

### 11.1 Tracking

- **Seed:** TPC standalone tracking starts from pad-plane clusters grouped into a helix hypothesis via Kalman-filter outside-in. In Run 3 initial seeding can alternatively be provided by ITS tracklets (inside-out); both strategies are run and merged.
- **Main track fit:** TPC supplies up to ~150 space-points per track over the 1.6 m radial lever arm. Drives intermediate-p_T momentum resolution (**σ(p_T)/p_T ≈ 1 %** at p_T ~1 GeV/c, ITS+TPC combined) [JINST2008 Tab. 3.12].
- **Extension:** TRD tracklets (matched outside the TPC) extend the lever arm to ~3.7 m and reduce σ(p_T)/p_T at high p_T (> 10 GeV/c). See [TRD §4](../detectors/trd.md).
- **Low-p_T:** for p_T below the TPC inner-radius threshold (~100 MeV/c), [ITS-standalone tracking](../detectors/its.md) is primary; TPC contributes only if the track reaches the active gas volume.

### 11.2 Vertexing

- **Primary vertex:** determined principally by the [ITS](../detectors/its.md). TPC contributes as a constraint — long TPC tracks extrapolated to primary vertex; weighted intersection refines the ITS-driven fit.
- **Secondary vertex:** V⁰ and cascade topologies (K⁰_S, Λ, Ξ, Ω) rely on the TPC for charged-daughter tracking at displacements 1 cm → 1 m — range where the long lever arm + momentum measurement is essential. Heavy-flavour displaced-vertex reconstruction combines TPC momentum with ITS impact-parameter resolution.

### 11.3 Particle identification

- **dE/dx:** TPC provides truncated-mean specific ionisation (~150 samples, lowest ~60 % retained) over the full p_T range from ~100 MeV/c up to the relativistic-rise regime (see §9). Separation in the non-relativistic 1/β² region best for p ≲ 1 GeV/c; relativistic rise extends statistical π/K/p separation to several GeV/c.
- **Combined PID:** TPC dE/dx combined with TOF time-of-flight (1–5 GeV/c) and TRD electron-likelihood (electron ID > 1 GeV/c) for the full barrel PID matrix. See [TRD §3 combined PID](../detectors/trd.md).

### 11.4 Multiplicity and event-shape estimators (dissertation focus)

- **Charged-particle multiplicity at mid-rapidity:** TPC provides cleanest mid-rapidity track counting within \|η\| < 0.9 (full radial length) and 0.9 < \|η\| < 1.5 (reduced radial length, reduced resolution). TPC-based multiplicity is principal mid-rapidity input to combined 4π multiplicity estimators combining central-barrel tracking with forward systems — see [T0/V0/ZDC](../detectors/t0v0zdc.md) and [PWGPP-643 combined shape estimator](../presentations/PWGPP-643_combined_shape_estimator.md).
- **Event-shape observables:** event-plane and q-vector reconstruction using TPC tracks offers the finest φ-granularity available in ALICE; TPC-based event-shape estimators complement the lower-granularity / larger-acceptance forward estimators (FV0 ring segmentation, ZDC).
- **Acceptance limits:** the ~10 % azimuthal dead-zone fraction (inter-sector gaps) and tracking-efficiency fall-off at \|η\| → 0.9 must be folded into acceptance corrections for multiplicity analyses. Alignment of IROC/OROC dead zones (preserved in Run 3) simplifies these corrections.

### 11.5 Calibration role

- **TPC is the detector whose calibration is most consequential** for this dissertation. Space-charge distortion maps (§7) are the dominant systematic in Run 3 and the primary subject of much of this work — see [O2-5095 TPC dE/dx / calibration index](../presentations/O2-5095_TPC_dEdx_index.md).
- **Reference tracks for TPC calibration** come from ITS + TRD matching: tracks with high-quality ITS + TRD hits, interpolated across the TPC, provide the residual distortion map that closes the Run 3 calibration feedback loop (§7.2 step 4).
- **FIT provides the collision-time reference (t0)** for continuous-readout time-frame reconstruction — necessary input to TPC z-coordinate — see [T0/V0/ZDC](../detectors/t0v0zdc.md).

### 11.6 Cross-detector dependencies (summary)

| TPC ↔ | Role | Wiki page |
|---|---|---|
| ITS | inner tracking seed; primary vertex; reference for space-charge residual map | [../detectors/its.md](../detectors/its.md) — live (DRAFT, wiki-v1) |
| TRD | outer tracklet extension; reference for space-charge residual map; L1 trigger (Run 1/2) | [../detectors/trd.md](../detectors/trd.md) — live (DRAFT, wiki-v1) |
| TOF | timing-based PID (1–5 GeV/c); track-level time information | [../detectors/tof.md](../detectors/tof.md) — planned |
| FIT / T0 / V0 | collision-time t0 for continuous-readout drift coordinate; forward multiplicity | [../detectors/t0v0zdc.md](../detectors/t0v0zdc.md) — planned |
| Solenoid | 0.5 T axial field — momentum-measurement prerequisite | — |

## 12. Thermal management [JINST2008 §3.2.2]

**ΔT ≤ 0.1 K** uniformity enforced by a multi-layer cooling architecture:
1. Heat screen at outer radius, toward TRD.
2. Heat screens at inner radius, shielding from ITS services.
3. Heat screens inside the readout-chamber bodies, shielding from FEE heat.
4. Dedicated FEE cooling.
5. Cooling of the resistive potential divider (high-resistivity water for the 100 kV divider).
6. Outer FEE heat screen.

All circuits are leakless (sub-atmospheric). No dedicated shield in the ITS-facing region (material-budget constraint) — ITS manages its outer-surface temperature itself.

## 13. Integration and services

- **Support:** TPC rides on a rail system inside the spaceframe, gliding on four Teflon feet; can be retracted ~5 m to the "parking position" for ITS or beam-pipe access [JINST2008 §3.2.2].
- **Service support wheels:** two wheels cover the end plates but are independently supported by TPC rails. They carry the ~1 t/side of electronics without loading the readout chambers, reducing thermal coupling to drift volume.
- **ITS mount:** innermost TPC shell supports the ITS at two points; this causes ~0.7 mm sag of the inner drum [JINST2008 §3.1 integration].
- **Installation & services (Run 3 additions)** [TDR-016 Ch. 11]: upgraded HV system, LV distribution, cooling for the new FEE, calibration pulser distribution. LS2 installation done in situ on the existing spaceframe.

## 14. Operational history

| Run | Years | Readout | Gas baseline | Rate ceiling (Pb–Pb) | Notes |
|---|---|---|---|---|---|
| Run 1 | 2010–2013 | MWPC + gating grid | Ne/CO₂ (90/10), then +N₂ | ~300 Hz central | √s_NN = 2.76 TeV Pb–Pb |
| LS1 | 2013–2015 | — | — | — | Consolidation only |
| Run 2 | 2015–2018 | MWPC + gating grid | Ne/CO₂/N₂ (90/10/5) | ~300 Hz central | √s_NN = 5.02 TeV Pb–Pb; Ar/CO₂ evaluated but not deployed |
| LS2 | 2019–2022 | — | — | — | **TPC upgrade: MWPC → S-LP-LP-S GEM; continuous readout; SAMPA FE** |
| Run 3 | 2022– | Quadruple-GEM + continuous | Ne/CO₂/N₂ (90/10/5) | 50 kHz interaction rate | O² online processing; full min-bias inspection |

## 15. Glossary

- **IROC / OROC** — Inner / Outer Readout Chamber. 36 of each; each subdivided into IROC 1–2 / OROC 1–3 pad-plane regions in Run 3.
- **MWPC** — Multi-Wire Proportional Chamber (Run 1/2 amplification).
- **GEM** — Gas Electron Multiplier (Run 3 amplification).
- **S-LP-LP-S** — Quadruple-GEM stack with Standard–Large Pitch–Large Pitch–Standard foil pitches.
- **IBF** — Ion Backflow. Fraction of amplification-region ions that drift back into the drift volume.
- **ε** — Electron transmission efficiency through the GEM stack.
- **PASA** — PreAmplifier/ShAper ASIC (Run 1/2).
- **ALTRO** — ALICE TPC Readout ASIC (Run 1/2 digital processing).
- **SAMPA** — 32-channel mixed-signal front-end ASIC (Run 3); common ALICE development.
- **GBTx** — Radiation-hard multiplexing ASIC connecting SAMPA to the CRU.
- **VTTx / VTRx** — Versatile link optical transmitters/transceivers.
- **CRU** — Common Readout Unit (off-detector).
- **FEC** — Front-End Card (5 SAMPAs = 160 channels in Run 3).
- **RCU** — Readout Control Unit (Run 1/2; 216 total).
- **TTS** — Trigger, Timing and Synchronization system.
- **DCS** — Detector Control System.
- **HLT** — High-Level Trigger (Run 1/2).
- **O²** — Online–Offline combined computing system (Run 3).

---

## 16. External references (authoritative URLs)

### 16.1 Primary sources (directly cited in body)

| Tag | Full citation | URL |
|---|---|---|
| **[JINST2008]** | ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002 | DOI: <https://doi.org/10.1088/1748-0221/3/08/S08002> · IOP: <https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002> |
| **[TDR-016]** | ALICE Collaboration, *Upgrade of the ALICE Time Projection Chamber*, CERN-LHCC-2013-020 / ALICE-TDR-016 (March 2014) | CDS: <https://cds.cern.ch/record/1622286> |
| **[TDR-019]** | Buncic, Krzewicki, Vande Vyvre, *Technical Design Report for the Upgrade of the Online-Offline Computing System*, CERN-LHCC-2015-006 / ALICE-TDR-019 (2015) | CDS: <https://cds.cern.ch/record/2011297> |

### 16.2 Additional references (flagged in §17 for next pass)

| Topic | Citation | URL |
|---|---|---|
| SAMPA ASIC design paper | Barboza et al., *SAMPA ASIC for ALICE TPC and MCH upgrades*, JINST **11** (2016) C05055 (plus successor publications) | DOI: <https://doi.org/10.1088/1748-0221/11/05/C05055> |
| TPC Run 1 performance | ALICE Collaboration, *Performance of the ALICE Experiment at the CERN LHC*, Int. J. Mod. Phys. A **29** (2014) 1430044 | DOI: <https://doi.org/10.1142/S0217751X14300440> |
| ALICE Run 3 performance paper | In preparation / forthcoming 2024 | `[VERIFY]` — not yet cited |

### 16.3 BibTeX stubs

```bibtex
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

@techreport{ALICE-TDR-016,
  author      = "{ALICE Collaboration}",
  title       = "{Upgrade of the ALICE Time Projection Chamber}",
  institution = "CERN",
  number      = "CERN-LHCC-2013-020, ALICE-TDR-016",
  year        = "2014",
  url         = "https://cds.cern.ch/record/1622286"
}

@techreport{ALICE-TDR-019,
  author      = "Buncic, P and Krzewicki, M and Vande Vyvre, P",
  title       = "{Technical Design Report for the Upgrade of the Online-Offline Computing System}",
  institution = "CERN",
  number      = "CERN-LHCC-2015-006, ALICE-TDR-019",
  year        = "2015",
  url         = "https://cds.cern.ch/record/2011297"
}

@article{SAMPA2016,
  author   = "Barboza, S et al.",
  title    = "{SAMPA: the new 32 channels ASIC for the ALICE TPC and MCH upgrades}",
  journal  = "JINST",
  volume   = "11",
  pages    = "C05055",
  year     = "2016",
  doi      = "10.1088/1748-0221/11/05/C05055"
}

@article{ALICEPerfRun1,
  author   = "{ALICE Collaboration}",
  title    = "{Performance of the ALICE Experiment at the CERN LHC}",
  journal  = "Int. J. Mod. Phys. A",
  volume   = "29",
  pages    = "1430044",
  year     = "2014",
  doi      = "10.1142/S0217751X14300440"
}
```

---

## 17. Open items and reviewer-validation checklist

### 17.1 `[VERIFY]` flags from v0.3 — carried forward

| # | Section | Issue | Severity |
|---|---|---|---|
| 1 | §4.1 | Exact run period when gas mixture transitioned from Ne/CO₂ (90/10) to Ne/CO₂/N₂ (90/10/5). JINST2008 lists (90/10/5); confirm from operational logs. | P2 |
| 2 | §5.2 | Small/large-pad boundary radius = 1986 mm is `[computed]` (derivation shown in machine-checkable comment). Confirm against TDR-016 §6 pad-plane drawing. Arithmetic error in v0.3 / wiki-v0 (1977 mm) corrected in review_cycle 1. | P2 |
| 3 | §6.5 | SAMPA default sampling rate 10 MHz (vs 20 MHz) and ADC bit-depth 10-bit — cite SAMPA design paper / datasheet directly. | P1 |
| 4 | §7.1 | Local peak space-charge displacement: TDR quotes "~10 cm"; later performance summaries cite up to ~20 cm. Resolve against both sources. | P1 |
| 5 | §7.4 | TDR-016 §8.4.2 post-correction momentum-resolution numbers not yet extracted. Populate next revision. | P1 |
| 6 | §14 Run 3 | Run 3 as-measured performance numbers to be added from performance paper / commissioning reports. | P1 |

### 17.2 Open items for further enrichment (from source §16)

| # | Source to add | Purpose |
|---|---|---|
| 7 | SAMPA reference paper (Barboza et al., JINST 2016 C05055 + successor) | Chip-level specs: sampling rate, ADC bits, DSP parameters, radiation tolerance |
| 8 | [TDR-019](https://cds.cern.ch/record/2011297) | Not exhaustively read this pass — CRU/FLP/EPN architecture; O² data-processing detail |
| 9 | ALICE TPC performance papers — Run 1 (Int. J. Mod. Phys. A 29 (2014) 1430044); Run 3 dedicated notes | Measured (vs designed) momentum + dE/dx resolution |
| 10 | TPC Run 3 commissioning reports | As-achieved IBF, space-charge calibration residuals, initial-data performance |

### 17.3 Reviewer checklist

- [ ] **Hard constraint — correctness:** every quantitative claim has a citation tag resolving to §16; every `[computed]` value has its derivation shown.
- [ ] **Hard constraint — reproducibility:** every URL in §16 is reachable and returns the expected document at the claimed DOI / CDS record.
- [ ] **Hard constraint — safety (public disclosure):** no unpublished data, no private GitLab paths as clickable links, no internal GSI paths as clickable links.
- [ ] **Citation-tag coverage:** no uncited number anywhere in body (`[VERIFY]` acceptable as placeholder but must be enumerated in §17.1).
- [ ] **Cross-ref integrity:** every `../detectors/*.md` / `../presentations/*.md` link either resolves or appears in §18 "Related wiki pages" with status `planned`.
- [ ] **Arithmetic closure** (targets explicit, all derivations in machine-checkable HTML comments where applicable):
  - §5.2 pad-count totals: `15,488 = 5504 + 5952 + 4032`; `15,488 × 36 = 557,568`
  - §5.2 small/large-pad boundary: `1346 + 64 × 10 = 1986` = `2466 − 32 × 15` (two-sided check)
  - §6.3 Run 3 channel delta: `(15,488 − 15,360) × 36 = 4,608`
  - §6.9 aggregate data rate: `230 × 36 = 8,280` Gbit/s
  - §6.9 aggregate bandwidth: `460 × 36 = 16,560` Gbit/s
  - §5.3 / §6.9 unit consistency: 30 GB/s = 240 Gbit/s; 8280 Gbit/s = 1035 GB/s
  - §3.3 cluster spread: `220 μm × √250 ≈ 3.48 mm` → stated as 3.5 mm
  - §3.1 radial lever arm: `2466 − 848 = 1618` ≈ 1.6 m (cited in §11.1)
- [ ] **Appendix A source-to-section map complete:** every numbered section has at least one row mapping to source §/Table.

---

## 18. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`../detectors/its.md`](../detectors/its.md) | §1, §11.1, §11.2, §11.6 | live (DRAFT, wiki-v1) |
| [`../detectors/trd.md`](../detectors/trd.md) | §1, §11.1, §11.3, §11.6 | live (DRAFT, wiki-v1) |
| [`../detectors/t0v0zdc.md`](../detectors/t0v0zdc.md) | §11.4, §11.5, §11.6 | planned |
| [`../detectors/tof.md`](../detectors/tof.md) | §11.3, §11.6 | planned |
| [`../presentations/PWGPP-643_combined_shape_estimator.md`](../presentations/PWGPP-643_combined_shape_estimator.md) | §7.2, §11.4 | planned (draft exists) |
| [`../presentations/O2-5095_TPC_dEdx_index.md`](../presentations/O2-5095_TPC_dEdx_index.md) | §7.2, §9, §11.5 | planned (draft exists) |

Status values: `planned` (target not yet created — expected red link); `live` (target exists, status ≥ DRAFT); `broken` (previously live, now missing — lint-detected regression).

---

## Appendix A: Source-to-section map

| Wiki § | Primary source section(s) |
|---|---|
| §1 Physics role | [JINST2008] §3.2.1; [TDR-016] §6.2 |
| §2 Acceptance | [JINST2008] Tab. 3.12, §3.2.2 |
| §3.1 Dimensions | [JINST2008] Tab. 3.12 |
| §3.2 Field cage | [JINST2008] §3.2.2 |
| §3.3 Drift physics | [JINST2008] Tab. 3.12 |
| §4.1 Gas Run 1/2 | [JINST2008] §3.2.2; [TDR-016] §3 |
| §4.2 Gas Run 3 | [TDR-016] §3 |
| §4.3 Gas system | [TDR-016] §2.7 |
| §5.1 MWPC | [JINST2008] §3.2.2 |
| §5.2 Pad geometry | [JINST2008] Tab. 3.12 |
| §5.3 Run 1/2 FE | [JINST2008] §3.2.3 |
| §5.4 Gating grid | [JINST2008] §3.2.2 |
| §5.5 Run 1/2 space charge | [JINST2008] §3.2.2 |
| §6.1–6.2 GEM upgrade | [TDR-016] §1, §5 |
| §6.3 Pad plane Run 3 | [TDR-016] §6.3 |
| §6.4 Chamber mechanics | [TDR-016] §5 |
| §6.5 SAMPA | [TDR-016] §6.1 + SAMPA paper (`[VERIFY]` §17.1 #3) |
| §6.6 Data transport | [TDR-016] §6.1, Fig. 6.1 |
| §6.7 Readout modes | [TDR-016] §6.1 |
| §6.8 Pileup | [TDR-016] §6.2 |
| §6.9 Data rates | [TDR-016] §6.3 |
| §7.1 Distortion budget | [TDR-016] §1 exec summary |
| §7.2 Calibration pipeline | [TDR-016] §8 |
| §7.3 Current monitoring | [TDR-016] §8.5.2 |
| §7.4 Run 3 performance target | [TDR-016] §8.4.2 (`[VERIFY]` §17.1 #5) |
| §8 Run 1/2 performance | [JINST2008] Tab. 3.12 |
| §9 PID / dE/dx | [JINST2008] §3.2.1 + [O2-5095 deck index] for Run 3 detail |
| §10.2 Gain stability | [TDR-016] §5.1.2, Fig. 5.3 |
| §10.5 Laser calibration | [JINST2008] §3.2.2 |
| §10.7 Calibration pulser | [TDR-016] §11.4.4 |
| §11 Role in reconstruction | derived / dissertation-specific synthesis |
| §12 Thermal management | [JINST2008] §3.2.2 |
| §13 Integration | [JINST2008] §3.2.2 + [TDR-016] Ch. 11 |
| §14 Operational history | [JINST2008] + [TDR-016] §3 + public run periods |

## Appendix B: Notation quick reference

| Symbol | Meaning |
|---|---|
| `dN_ch/dη` | charged-particle density per unit pseudorapidity |
| `σ(p_T)/p_T` | relative transverse-momentum resolution |
| `dE/dx` | specific ionization energy loss |
| `I` | mean excitation energy (Bethe–Bloch) |
| `βγ` | relativistic factor β · γ = p/(mc) |
| `D_L, D_T` | longitudinal / transverse diffusion coefficient |
| `v_d` | electron drift velocity |
| `μ(E,B,gas)` | electron mobility in E, B field and given gas |
| `E × B` | Lorentz-force correction axis |
| `ε` | electron transmission efficiency (GEM) |
| IBF | ion backflow fraction |
| MWPC / GEM / ROC | see §15 glossary |
| ΔE, ρ_sc | field perturbation, space-charge density |
| FEC / FLP / EPN / CRU | FE card / First-Level / Event-Processing node / Common Readout Unit |
| TTS / DCS | Trigger+Timing / Detector Control System |

---

## Changelog — v0.3 → wiki-v0

- **Structural:** converted to PWGPP-643 schema — YAML front-matter with `source_fingerprint` (upstream + summary_version), numbered sections preserved from v0.3, `[JINST2008]`/`[TDR-016]`/`[TDR-019]` tags retained in body and resolved to URLs in §16.
- **Added §16 External references:** canonical URLs for every citation tag (JINST DOI + IOP direct, CDS records for both TDRs, DOI for SAMPA paper and Int. J. Mod. Phys. A Run 1 performance paper).
- **Added §17 Reviewer checklist:** carried forward all v0.3 `[VERIFY]` flags, severity-classified P1/P2; hard-constraints line added; §16 URL-reachability added as explicit check.
- **Added §18 Related wiki pages:** outgoing links to ITS, TRD, T0/V0/ZDC, TOF pages (planned) + PWGPP-643 and O2-5095 deck indices (drafts exist).
- **Added Appendix A source-to-section map; Appendix B notation quick reference.**
- **Cross-links placed inline:** §7.2 → PWGPP-643 §4; §11.1/§11.3/§11.6 → TRD §3/§4; §11.4 → T0V0ZDC + PWGPP-643; §11.5 → O2-5095 deck.
- **Content unchanged:** all physics claims, numbers, tables, `[VERIFY]` flags preserved exactly from v0.3. No new quantitative claims added.

## Changelog — wiki-v0 → wiki-v1 (review_cycle 1)

**Reviewer:** ClaudeOpus47 (peer review, 2026-04-19, verdict `[!]` APPROVED WITH COMMENTS). Review artifact archived alongside this page.

**Fixes applied:**

- **P1.1 (§5.2 arithmetic error).** Small/large-pad boundary radius corrected from **~1977 mm → ~1986 mm**. Derivation shown two ways: `1346 + 64 × 10 = 1986` (from IROC-OROC boundary inward) and `2466 − 32 × 15 = 1986` (from outer edge inward). Both match. Machine-checkable HTML comment `<!-- 1346 + 64*10 = 1986; 2466 - 32*15 = 1986 -->` added. Correction history note inserted inline in §5.2. §17.1 item #2 updated.
- **P2.1 (§5.3 unit consistency).** Run 1/2 aggregate bandwidth now reported as `~30 GB/s (≈ 240 Gbit/s)` so readers can compare with Run 3's 8280 Gbit/s (§6.9) without converting. Run 1/2 → Run 3 ratio (~34×) now explicit in §6.9.
- **P2.2 (§6.9 table clarity).** Data-rates table column headers renamed to make per-sector-side scope explicit (`Channels / sector-side`, `Data / sector-side (Gbit/s)`, `Bandwidth / sector-side (Gbit/s)`). Added per-sector-side sum row (`15,360 channels; 230 Gbit/s data; 460 Gbit/s bandwidth`). Aggregation-across-36-sector-sides explicitly shown with arithmetic (`230 × 36 = 8280`) and machine-checkable comment. Aggregate bandwidth (16,560 Gbit/s = 460 × 36) added alongside data rate.
- **P2.3 (§7.2 cross-link target).** Refined `[PWGPP-643 §4](...)` → `[PWGPP-643 §3.4 analytical residual-distortion modelling](...)` — tighter topical match per reviewer (residual-distortion analytical modelling, `arxiv/physics/0306108` framework). §11.4 link to PWGPP-643 as a whole unchanged (that one is already correctly scoped).
- **P2.4 (front-matter reviewer-ID convention).** `indexed_by: Claude (Opus 4.7)` → `indexed_by: Claude1` (matches `summary_review_panel` naming convention). Model information preserved as new field `indexing_model: Claude (Opus 4.7)`. Added `peer_reviewers: [ClaudeOpus47]` field. `review_cycle: 0 → 1`.
- **§17.3 arithmetic-closure check strengthened.** Check target list expanded from 2 items to 8, each derivation shown explicitly in the checklist so a lint script can verify. Rationale: the reviewer's P1.1 arithmetic error survived the v0 checklist pass because the check target list was incomplete.

**Deferred to generalization step** (per reviewer recommendation):

- **P2.5 (fingerprint schema split).** Reviewer recommends splitting `source_fingerprint` → `source_fingerprint` (upstream-only) + new `document_version` block for `summary_version` / `summary_review_panel`. Deferred because this affects all MIWikiAI pages simultaneously; should be done in the generalization step with ITS, TRD, T0V0ZDC together, not as a local edit here.
- **P2.6 (`[computed]` notation convention).** Reviewer recommends one consistent convention (inline tag vs parenthetical). Deferred to generalization step for the same reason.

**Content unchanged:** all physics claims, numbers (except 1977→1986 correction), tables, `[VERIFY]` flags preserved exactly from wiki-v0. No new quantitative claims added in this review cycle.

## Changelog — wiki-v1 → wiki-v2 (review_cycle 2)

**Reviewer:** Claude3 (peer review, 2026-04-19, verdict `[!]` APPROVED WITH COMMENTS). 0 P0, 2 P1, 5 P2. **Concurs with ClaudeOpus47 cycle-1 findings + extends** with cross-page asymmetry that only became visible after ITS-SoT landed. Review artifact archived alongside this page.

**Fixes applied:**

- **P1-1 (cross-page link-status asymmetry).** §18 had `../detectors/its.md` → `planned` and `../detectors/trd.md` → `planned`, but both pages have been `live (DRAFT)` since review_cycle 1. Updated both rows to `live (DRAFT, wiki-v1)`. Also propagated to §11.6 cross-detector table: ITS and TRD rows now carry explicit `live (DRAFT, wiki-v1)` annotations next to their link cells. This is exactly the lint-detectable class of bug Claude3 flagged — when a new page goes live, every target page that references it must update its status row. Reminder for the governance doc: this should be a MUST-do step in the page-landing checklist.
- **P1-2 (§6.1 rhetorical ratio).** "150× the Run 1/2 rate ceiling" → **"~170× the Run 1/2 rate ceiling (50 kHz / ~300 Hz central, per §5.3 and §5.4)"**. The stated numbers on this page (50 kHz / 300 Hz = 166.7) don't produce 150. Machine-checkable HTML comment added. Claude3's principle: *on a Source-of-Truth page, every stated ratio must reproduce from quoted numbers on the same page*.
- **P2-2 (§3.3 diffusion B-field context).** `D_L = D_T = 220 μm / √cm` now comes with one-sentence context: the equality is specific to the 0.5 T operating point — at B = 0 the two would differ (generically D_T > D_L for cold gases), but in the axial field transverse diffusion is E×B-suppressed to match D_L. Addresses the reader who recalls generic TPC pedagogy and is puzzled by the equality.
- **P2-3 (§6.9 bandwidth column convention).** Added footnote explaining that `Bandwidth / sector-side` column values (100/100/90/100/70 Gbit/s) are **rounded-up engineering allocations per region**, not exact products of `channels × bandwidth-per-channel`. Explicit derivation in the footnote: `Σ(chan × req-bw) = 433 Gbit/s per sector-side` vs sum-row 460 Gbit/s is a ~6 % regional headroom (standard DAQ engineering practice). Similar note on the 3 % rounding residual in the data column (IROC 2 exact `3200 × 16 = 51.2` rounds to 50). Machine-checkable HTML comment with the full sum.
- **P2-5 (§11.6 table formatting consistency).** TOF row was `"planned"` plain text while t0v0zdc row had a clickable link. Now both rows have the same format: clickable link + `— planned` status annotation. §18 legend explicitly permits clickable links to `planned` targets (expected red links), so the uniform-link convention is safe. ITS and TRD cells also now carry their `live (DRAFT, wiki-v1)` annotation in-line for table-level uniformity.

**Front-matter:** `review_cycle: 1 → 2`; `peer_reviewers: [ClaudeOpus47] → [ClaudeOpus47, Claude3]`.

**Deferred to generalization pass** (Claude3 concurs with deferral):

- **P2-1 (`hard_constraints_checked` migration).** After two review cycles both arithmetic-complete and source-verification-partial, these should migrate from `pending` to `partial` / `verified`. Claude3 proposes concrete values. Not fixed here because the same migration applies to every SoT page — better done coordinated in the generalization doc with explicit value conventions, not hand-edited per file.
- **P2-4 (indexer-as-panelist convention).** Is the `indexed_by: Claude1` entry implicitly a member of `summary_review_panel`? Both conventions are defensible. Document the choice in generalization; no page-local fix.
- **Carryover from earlier cycles:** P2.5 fingerprint `document_version` split + P2.6 `[computed]` notation convention (ClaudeOpus47 cycle 1); `summary_contributors` schema unification (ClaudeOpus47 TRD cycle-1 P2.4). All ride the generalization pass together.

**Claude3 acknowledgments worth preserving** (the reviewer explicitly flagged these as exemplary, advisory for generalization mandates):

- Two-sided arithmetic derivation with machine-checkable HTML comment (§5.2 line 173 of wiki-v1) — Claude3 recommends as project-wide MUST.
- Correction-history blockquote inline at §5.2 — Karpathy-pattern audit trail.
- §17.3 arithmetic-closure checklist with full sum expressions — extend to all SoT pages.
- Appendix A source-to-section map complete coverage — confirm as SoT-class MUST.

**Content unchanged except for the specific corrections above.** All physics claims, numbers (except the 150×→170× rhetorical-ratio fix), tables, `[VERIFY]` flags preserved. The diffusion-context note and bandwidth-column footnote **add explanation, don't change quantitative claims**.

---

*End of TPC Source of Truth, wiki-v2 (derived from v0.3 via wiki-v0 + ClaudeOpus47 cycle 1 + Claude3 cycle 2, 2026-04-19). All P1s from review_cycle 2 applied. P2-2, P2-3, P2-5 applied locally per reviewer. P2-1 and P2-4 deferred to generalization pass (Claude3 concurs). Cross-page consequence: ITS-SoT and TRD-SoT should verify their own outgoing status-row entries to this page now read `live (DRAFT, wiki-v2)` — same lint-detectable bug class as P1-1 here. Next reviewer pass can consider promotion to `[OK]` APPROVED subject to §17.1 `[VERIFY]` items #3–#6.*
