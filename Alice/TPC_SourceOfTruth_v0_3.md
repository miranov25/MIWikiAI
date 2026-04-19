# ALICE Time Projection Chamber (TPC) — Source of Truth v0.3

**Version:** 0.3 (post-review panel; P0+P1 fixes from Claude1, Main Coder, Gemini1, GPT1/2/3)
**Sources (verified this revision):**
- **[JINST2008]** — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002, §3.2 (pp. 54–70).
- **[TDR-016]** — ALICE Collaboration, *Upgrade of the ALICE Time Projection Chamber*, CERN-LHCC-2013-020 / ALICE-TDR-016 (March 2014).

All quantitative claims below carry a bracketed source tag pointing to the chapter/section or table. Values marked `[computed]` are derived arithmetically from tagged source values. Values marked `[VERIFY]` need a further pass against a primary source before final submission.

## BibTeX entries required in `bibliography.bib`

The following entries must be present in the project `bibliography.bib` before LaTeX conversion. **CDS record numbers below should be cross-checked against the CERN Document Server before committing.**

```bibtex
@article{JINST2008,
  author   = "{ALICE Collaboration}",
  title    = "{The ALICE experiment at the CERN LHC}",
  journal  = "JINST",
  volume   = "3",
  pages    = "S08002",
  year     = "2008",
  doi      = "10.1088/1748-0221/3/08/S08002"
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
  author      = "{ALICE Collaboration}",
  title       = "{Technical Design Report for the Upgrade of the Online-Offline Computing System}",
  institution = "CERN",
  number      = "CERN-LHCC-2015-006, ALICE-TDR-019",
  year        = "2015"
}
```

Stubs to add for §15 open items: SAMPA paper (Barboza et al., JINST 11 (2016) C05055 or subsequent 2020); TPC Run 1 performance (Int. J. Mod. Phys. A 29 (2014) 1430044); ALICE Run 3 performance paper (arXiv 2024, `[VERIFY]`).

## Changelog v0.2 → v0.3

- **P0** Added BibTeX block above.
- **P0** §5.2: OROC small/large-pad boundary explicitly marked `[computed]`.
- **P0** §6.4: channel-count reconciliation rewritten — Run 1/2 arithmetic now closes (15,488 × 36 = 557,568), Run 3 delta is 4,608 channels.
- **P1** §3.1 vessel-dimension row relabelled (containment inner wall, not drift gas extent).
- **P1** §4.3: 20-word direct TDR quote paraphrased.
- **P1** §4.1 gas history tightened — design baseline / operational mixture / alternatives separated.
- **P1** §5.4: unsourced "~200 µs recovery" value removed; qualitative statement retained.
- **P1** §6.5: SAMPA Run 3 sampling baseline clarified (10 MHz default).
- **P1** §7.1: space-charge magnitude clarified as local peak amplitude, not global shift.
- **P1** §7.4: wording softened — preservation is a TDR design target, not yet a measured result.
- **P1** New §11: Role in the reconstruction chain.
- Section numbers ≥ 11 from v0.2 shifted by +1.

---

## 1. Physics role and design drivers

The TPC is the **main tracking detector of the ALICE central barrel** [JINST2008 §3.2.1]. It provides, together with the ITS (inside), TRD (outside) and TOF (beyond TRD):

1. Three-dimensional tracking of charged particles in a large gaseous drift volume.
2. Momentum measurement in the 0.5 T solenoidal field (combined with ITS for the inner space-points and TRD/TOF for the lever arm).
3. Particle identification (PID) via the specific ionization energy loss d*E*/d*x* over a wide momentum range.
4. Primary and secondary vertex contributions through precise space points.
5. Input to the High-Level Trigger (Run 1/2) and to the O² online-offline system (Run 3).

**Core design choice:** a TPC was selected over all-silicon tracking because it combines very large phase-space coverage with minimal material budget in the sensitive volume, while handling unprecedented track densities. The Run 1 design target was d*N*_ch/d*η* = 8000, implying ~20 000 primary and secondary tracks within acceptance [JINST2008 §3.2.1]. Actual multiplicities in Pb–Pb are ~1600–2000 at mid-rapidity in 0–5% central collisions [TDR-016 §6.2], well below the design ceiling, leaving substantial rate/occupancy headroom that was exploited by the Run 3 upgrade.

## 2. Acceptance

| Quantity | Value | Source |
|---|---|---|
| Pseudorapidity (full radial track length) | \|η\| < 0.9 | JINST2008 Tab. 3.12 |
| Pseudorapidity (1/3 radial track length, reduced resolution) | \|η\| < 1.5 | JINST2008 Tab. 3.12 |
| Azimuthal coverage | 360° | JINST2008 Tab. 3.12 |
| Dead-zone fraction (between sectors) | ~10% of azimuth | JINST2008 §3.2.2 |
| *p*_T range | ~0.1–100 GeV/*c* | JINST2008 §3.2.1 |

Sector dead zones arise from the support rods and chamber edges. The dead zones of inner and outer chambers are aligned — a choice that optimizes high-*p*_T resolution (by providing uninterrupted tracking for accepted tracks) at the cost of the azimuthal acceptance cracks.

## 3. Geometry (common to Run 1–3)

The mechanical structure was **not changed by the Run 3 upgrade**; the field cage, central electrode, end plates, support rods, Mylar strip cage, gas system and services are reused. Only the readout chambers and front-end electronics were replaced.

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

- **Central electrode:** stretched aluminised Mylar foil, **22 µm** thick — minimizing material at η ≈ 0.
- **Potential grading:** aluminised Mylar strips wound around 18 inner + 18 outer support rods; 166 strips per side.
- **High-voltage divider:** one inner and one outer rod house resistive dividers using high-resistivity water cooling (100 kV divider).
- **Drift field:** 400 V/cm.
- **Central-electrode HV:** 100 kV.
- **Insulating envelope:** CO₂ in containment vessels outside the field cage.
- **Mechanical precision:** ~250 µm, coplanarity adjusted by individual shimming of the 3-point chamber mounts.

### 3.3 Drift physics

Under a uniform axial **E** field, primary ionization electrons drift toward the end plates at

&nbsp;&nbsp;&nbsp;&nbsp;*v*_d = µ(E, B, gas) · E

The transverse position of the cluster is determined by the pad at which the charge is collected; the longitudinal (*z*) coordinate is obtained from the arrival time. The detector is in a 0.5 T axial field, producing a tight E×B alignment.

For the Ne/CO₂/N₂ (90/10/5) baseline mixture:
- Drift velocity **~2.7 cm/µs** → maximum drift time **~92 µs** over the 2.5 m half-length [JINST2008 Tab. 3.12].
- Diffusion: D_L = D_T = **220 µm / √cm** [JINST2008 Tab. 3.12].
- Cluster spread at full drift (√(2.5 m)) ≈ 3.5 mm (computed from D × √L).

## 4. Drift gas

### 4.1 Run 1 / Run 2 gas mixtures [JINST2008 §3.2.2; TDR-016 §3]

- **Design baseline (Run 1 start-up):** Ne/CO₂ (90/10) [JINST2008 §3.2.2].
- **Operational mixture (late Run 1 onward):** Ne/CO₂/N₂ (90/10/5). The N₂ admixture was introduced for improved quenching and high-gain operational stability [TDR-016 §3]. JINST2008 Table 3.12 lists (90/10/5), reflecting the mixture in use at the time of that publication. **`[VERIFY]`** the exact run period when the change from (90/10) to (90/10/5) took effect.
- **Alternative considered (Run 2):** Ar/CO₂ (90/10) was evaluated as a replacement for Ne to further stabilise the wire chambers at the higher Run 2 Pb–Pb interaction rate of 10 kHz [TDR-016 §3]. Simulations indicated momentum and d*E*/d*x* resolutions comparable to the Ne mixtures, with space-charge distortions remaining at the ~1 cm level using the triggered gating grid, at a slight reduction of event rate to tape. Ar/CO₂ was **not deployed**: the combination of higher diffusion (larger cluster spread), higher primary ionisation (more drift-volume space charge), and modified gas-gain operating point did not offer a net operational advantage over the stable Ne/CO₂/N₂ baseline for the remaining Run 2 programme.

Selection criteria:
- Low diffusion → good spatial resolution.
- Low radiation length → low multiple scattering.
- Small space-charge effect.
- Gas ageing stability (CH₄ and CF₄ mixtures rejected on ageing grounds).
- "Cold gas" drawback: drift velocity is strongly temperature-dependent in Ne/CO₂, setting the **ΔT ≤ 0.1 K thermal-uniformity requirement** across the drift volume.

Impurity targets: CO₂ and N₂ fractions stable to 0.1%; O₂ contamination ≲ 1 ppm to limit attachment loss over 2.5 m drift to < 5% [JINST2008 §3.2.2].

### 4.2 Run 3 baseline [TDR-016 §3]

The baseline gas mixture for the upgraded TPC is **Ne/CO₂/N₂ (90/10/5)**, retained from late Run 1/2 operation. The choice was revisited in light of GEM operation requirements (drift velocity, diffusion, gas gain, ion mobility). Key Run 3 drivers:
- Gas gain of ~2000 must be reached with ≤ 1% ion backflow.
- Drift velocity must remain high enough to keep drift times comparable, so that pileup at 50 kHz interaction rate stays manageable (~5 events within one drift time, see §7.1).

### 4.3 Gas system [TDR-016 §2.7]

- **Closed-loop circulation:** ~15 m³/h recirculated via a regulated compressor.
- **Pressure regulation:** relative pressure constant to better than **0.1 mbar**.
- **Purification:** copper-catalyzer cartridges remove O₂ and H₂O.
- **Fresh-gas injection:** ~50 l/h continuous.
- **Monitoring:** an analysis line continuously reads O₂/H₂O and composition; a gas chromatograph takes periodic samples.
- **Buffer:** high-pressure storage absorbs atmospheric fluctuations without interruption.
- **Control:** PLC with SCADA user interface.
- **Mixer flexibility:** default Ne/CO₂/N₂; mass-flow controllers can be recalibrated for Ar or CF₄. Ne-saving filling procedure uses molecular-sieve trapping of CO₂.

Per TDR-016 §2.7: the Run 3 upgrade required **no hardware or software modifications to the gas system**; the existing infrastructure is reused entirely.

## 5. Readout in Run 1 / Run 2 — MWPC era

### 5.1 Multi-wire proportional chambers [JINST2008 §3.2.2]

The 72 readout chambers were MWPCs with cathode-pad readout. Each chamber comprised:
- Anode wire grid (signal amplification).
- Cathode wire plane.
- **Gating grid** — critical, see §5.4.

Geometry:
- Anode-to-cathode distance: **2 mm (IROC), 3 mm (OROC)**.
- Operating gas gain: up to **2 × 10⁴**.

### 5.2 Pad geometry [JINST2008 Tab. 3.12]

| Region | Radial active range | Pad size (φ × r) | Rows | Pads/sector |
|---|---|---|---|---|
| IROC | 848 – 1321 mm | 4 × 7.5 mm² | 63 | 5504 |
| OROC (small pads) | 1346 – ~1977 mm `[computed]` | 6 × 10 mm² | 64 | 5952 |
| OROC (large pads) | ~1977 `[computed]` – 2466 mm | 6 × 15 mm² | 32 | 4032 |

- Pads per sector-side: 15 488 = 5504 + 5952 + 4032.
- **Total pads: 557 568** (15 488 × 2 sides × 18 sectors) [JINST2008 Tab. 3.12] — arithmetic closes cleanly.

Radial dead zone between IROC and OROC: 1321 → 1346 mm ≈ 25 mm.

The small/large-pad boundary radius **~1977 mm** is `[computed]`: JINST2008 Tab. 3.12 gives only the pad counts (64 small + 32 large rows) and the OROC outer active limit; the implied boundary follows from 64 × 10 mm + 1346 mm ≈ 1977 mm. The source does not quote this radius explicitly — confirm against TDR-016 §6 pad-plane drawing before treating as authoritative.

### 5.3 Front-end electronics [JINST2008 §3.2.3]

Each channel has:
1. **PASA** — charge-sensitive amplifier / semi-Gaussian shaper.
2. **10-bit ADC**, sampling at 5–10 MHz (IC capable of 25 MHz).
3. **Digital circuit** — tail-cancellation (shortening filter), baseline subtraction, zero suppression.

Aggregate:
- Front-End Cards (FECs): 121/sector × 36 = **4356**.
- Readout Control Units (RCUs): 6/sector × 36 = **216**, each serving 18–25 FECs.
- Time samples per drift: 500–1000.
- Central Pb–Pb event size (at design d*N*/d*η* = 8000): ~90 MB.
- pp event size: ~1–4 MB.
- Aggregate bandwidth: ~30 GB/s.
- Trigger rate ceilings: **300 Hz central Pb–Pb, 1 kHz pp**.
- Conversion gain: 6 ADC counts / fC.

### 5.4 The gating grid

Between events, the gating grid is closed: alternating ±ΔV bias on its wires absorbs drift-volume electrons and blocks amplification-region ions from back-drifting into the field cage. The gate opens on the L1 trigger, 6.5 µs after the collision, for one full drift time (~90 µs) [JINST2008 §3.2.2]. Closed-gate electron suppression exceeds a factor 10⁵.

**This is the binding rate limitation of Run 1/2:** the combination of 90 µs open time, mandatory closed-gate recovery, and the L1 trigger architecture gives an effective ceiling of a few hundred Hz in central Pb–Pb [JINST2008 §3.2.2]. Lifting this limit drove the entire Run 3 upgrade.

### 5.5 Space-charge distortions — Run 1/2

With the gating grid, ion backflow from the amplification region is blocked during closed periods. The residual space charge from drift-volume ionization itself produces distortions of order a few mm at ~200 Hz central Pb–Pb rates, corrected offline [JINST2008 §3.2.2].

## 6. The Run 3 upgrade — GEM readout [TDR-016]

### 6.1 Motivation

Run 3 physics requires inspection of the **full Pb–Pb minimum-bias rate**, projected at **50 kHz interaction rate** after LS2 [TDR-016 §1]. At this rate the gating-grid scheme is no longer viable — the duty cycle cannot keep up, and with a permanently open gate the ion backflow from MWPCs would produce space-charge distortions far beyond what can be calibrated. The upgrade therefore replaced the MWPC chambers with **quadruple-GEM stacks** and deployed fully **continuous (triggerless) readout** [TDR-016 §6.1].

Reuse strategy — the mechanical skeleton is preserved:

| Component | Run 3 |
|---|---|
| Field cage, central electrode, rods, Mylar strips | **Reused** |
| End plates | **Reused** |
| Gas system, services, cooling | **Reused** |
| Baseline gas mixture | **Reused** (Ne/CO₂/N₂ 90/10/5) |
| Sector/chamber segmentation (18 × IROC + OROC) | **Preserved** |
| Readout chambers | **Replaced**: MWPC → quadruple-GEM |
| Front-end electronics | **Replaced**: PASA/ALTRO → SAMPA |
| Readout architecture | **Replaced**: triggered → continuous |
| Gating grid | **Removed** |

### 6.2 GEM basics

A Gas Electron Multiplier is a ~50 µm polyimide foil clad with copper on both sides, perforated with a hexagonal pattern of bi-conical holes. A voltage across the foil (≈ 200–400 V typ.) creates fields ≳ 50 kV/cm inside the holes, where drifting electrons undergo avalanche multiplication. Most amplification-region ions are absorbed on the top GEM electrode or on successive GEM foils; only a small fraction — the **ion backflow (IBF)** — drifts upstream into the field cage.

A *Standard* ALICE GEM foil has hole pitch **140 µm**; *Large-Pitch* (LP) foils have **280 µm** pitch [TDR-016 §5.1.3]. Mixing the two pitches in a stack is the key to the IBF-optimized baseline solution.

### 6.3 Baseline solution: S-LP-LP-S quadruple GEM [TDR-016 §5.1.3]

The chosen configuration is a **four-GEM stack** where:
- **Layer 1 (top):** Standard pitch (140 µm).
- **Layer 2:** Large Pitch (280 µm).
- **Layer 3:** Large Pitch (280 µm).
- **Layer 4 (bottom, towards pad plane):** Standard pitch (140 µm).

This is the **S-LP-LP-S** arrangement.

Why this geometry:
- The large-pitch foils in layers 2 and 3 have lower optical transparency and, with asymmetric transfer-field settings, block ions efficiently without excessively degrading electron transmission.
- An **increasing gain sequence down the stack** (lower gain in GEM 1/2, higher gain in GEM 3/4) reduces IBF: ions created in the inner amplifying layers are blocked by the upstream foils before reaching the drift volume.
- Trade-off: raising electron transmission in GEM 1 (higher U_GEM1) helps energy resolution but worsens IBF; raising GEM 2 behaves similarly. Optimization is simultaneous over IBF and energy resolution.

Typical operating point [TDR-016 §5.1.3, around Fig. 5.4]:
- Transfer fields: **E_T1 = 4 kV/cm, E_T2 = 2 kV/cm, E_T3 = 0.1 kV/cm**.
- Induction field: **E_ind = 4 kV/cm**.
- Total effective gain fixed at **~2000**.
- U_GEM2 tested over 235 V / 255 V / 285 V; U_GEM3/U_GEM4 ratio held fixed while absolute scaled to maintain gain.

**Achieved performance:**
- IBF **~0.7 %** at energy resolution **~12 %** (5.9 keV, ⁵⁵Fe) [TDR-016 §5.1.3].
- Both requirements simultaneously met: IBF ≤ 1 % for tolerable space-charge distortions; σ_E/E sufficient for d*E*/d*x* PID.

### 6.4 Chamber structure [TDR-016 Ch. 4, 5]

Each sector carries:
- One **IROC** — subdivided for pad readout into **IROC 1 + IROC 2** stacks [TDR-016 §6 tables], with 2304 + 3200 = 5504 channels per sector.
- One **OROC** — subdivided into **OROC 1 + OROC 2 + OROC 3** stacks, with 2944 + 3712 + 3200 = 9856 channels per sector.

**Total Run 3 channel count per side:** 5504 + 9856 = 15 360 per sector × 18 sectors = 276 480 per side.
**Total Run 3 channels (both sides): 552 960** [TDR-016 §6.3, electronics table].

**Comparison with Run 1/2:** JINST2008 Tab. 3.12 gives 557 568 Run 1/2 pads (15 488 per sector-side × 36). The difference to Run 3 is **557 568 − 552 960 = 4 608 channels (~0.8%)**, corresponding to a small pad-plane re-segmentation — most clearly in IROC (5504 channels preserved) versus OROC where the Run 3 three-stack division (2944 + 3712 + 3200 = 9856) replaces the Run 1/2 two-region layout (5952 + 4032 = 9984). The approximate equivalence preserves reconstruction-geometry compatibility.

Chamber components (per GEM stack):
- Frame with HV connections, gas-tight seal.
- Four GEM foils stretched and glued in a frame.
- Readout pad plane with trace routing to Kapton flex cables.

### 6.5 Front-end electronics: SAMPA [TDR-016 §6.1]

**SAMPA ASIC** — custom mixed-signal front-end chip common to ALICE TPC and Muon Chamber upgrades, described in a dedicated TDR. Key features (as described in TDR-016 §6.1):

- **32 channels per chip.**
- **Charge-sensitive preamplifier + semi-Gaussian shaper** on each channel, producing **differential voltage signals**.
- **Negative-polarity input signals** (GEM output) — opposite polarity from the Run 1/2 MWPC anode-wire signals, motivating the redesigned front end.
- **Continuous ADC sampling** on each channel; **10 MHz** default sampling rate for the Run 3 TPC baseline (20 MHz high-resolution mode supported but not the default) `[VERIFY: TDR-016 §6.1 / SAMPA datasheet]`. ADC resolution: 10-bit `[VERIFY]`.
- **Digital Signal Processor (DSP)** on-chip: tail cancellation, baseline restoration, zero suppression, formatting.
- **Output:** digital data streamed to the GBTx ASIC.

Each FEC (Front-End Card) carries **5 SAMPAs** = 160 channels per FEC.

### 6.6 Data transport: GBT, VTTx/VTRx, CRU [TDR-016 §6.1, Fig. 6.1]

Downstream of the SAMPA:
- **GBTx ASIC** multiplexes SAMPA output streams into a single high-speed link. The GBTx can multiplex 10 (14) e-links with (without) forward error correction [TDR-016 §6.1].
- **VTTx** (Versatile Twin Transmitter) and **VTRx** (Versatile Transceiver) — radiation-hard optical link components.
- **GBT unidirectional data links at 3.2 Gbit/s** — from FEC to CRU [TDR-016 §6, electronics figures].
- **Common Readout Unit (CRU)** — off-detector, in the control room; common ALICE development shared across subsystems. Interfaces the TPC to the online O² farm, the trigger/timing system (TTS), and the detector control system (DCS).

### 6.7 Continuous readout and triggered mode [TDR-016 §6.1]

In Run 3 the default is continuous (triggerless) readout — the SAMPA samples continuously and the CRU streams data to O². A **triggered mode is also supported** for calibration and low-rate running: when a Level-0 trigger arrives, only the data corresponding to one drift time (~100 µs) is frozen in memory and read out.

### 6.8 Pileup and occupancy [TDR-016 §6.2]

Measured (Run 1) and scaled densities at √s_NN = 5.5 TeV:
- ⟨d*N*_ch/d*η*⟩ ≈ **2000** (central 0–5%).
- ⟨d*N*_ch/d*η*⟩ ≈ **500** (minimum bias).

At 50 kHz interaction rate, the average number of interactions within one drift time (~100 µs) is **N_pileup = 5**. The "equivalent" d*N*_ch/d*η* seen by the detector within a drift window is:
- **2500** for minimum bias + 4 minimum-bias pileup events.
- **4000** for a central event embedded in 4 minimum-bias pileup events.

Both values sit below the original Run 1 design envelope of 8000 — a deliberate headroom that the chamber/pad geometry preserves.

### 6.9 Data rates [TDR-016 §6.3 electronics table]

Per-region average data rate / channel and required bandwidth / channel:

| Region | Avg. data rate/chan (Mbit/s) | Req. bandwidth/chan (Mbit/s) | Channels | Total data (Gbit/s) | Total bandwidth (Gbit/s) |
|---|---|---|---|---|---|
| IROC 1 | 22 | 40 | 2304 | 50 | 100 |
| IROC 2 | 16 | 30 | 3200 | 50 | 100 |
| OROC 1 | 15 | 30 | 2944 | 45 | 90 |
| OROC 2 | 13 | 25 | 3712 | 50 | 100 |
| OROC 3 | 11 | 20 | 3200 | 35 | 70 |

Total front-end channels: **552 960**. Aggregate bandwidth requirement: **~8280 Gbit/s** [TDR-016 §6.3]. Online data compression in O² (clustering + track seeding) reduces this to permanent-storage bandwidth.

## 7. Space-charge distortions and calibration in Run 3 [TDR-016 Ch. 8]

### 7.1 The distortion budget

Without a gating grid, back-drifting ions accumulate in the drift volume. At 50 kHz Pb–Pb and 1 % IBF with gain 2000, the steady-state space-charge density produces **local drift-field distortions whose peak amplitude reaches up to ~10 cm** in the most affected regions (inner radius, large drift distance) [TDR-016 §1 exec summary]. This is the *local peak* displacement of reconstructed space-points, not a global shift — the distortion varies strongly with radius, drift length, and sector. It is far beyond what static corrections can handle passively; the Run 3 TPC explicitly *relies on calibration* to recover tracking accuracy. **`[VERIFY]`** whether TDR-016 quotes ~10 cm or a larger number (up to ~20 cm has been cited in later performance summaries for the most extreme inner-radius regions).

### 7.2 Calibration pipeline [TDR-016 §8]

The distortion correction proceeds in stages:

1. **Space-charge density maps.** 3D average space-charge distributions are computed from simulations and continuously refined using actual data.
2. **Space-charge field calculation.** Given ρ_sc(*r*,φ,*z*), the Poisson equation is solved to obtain Δ**E**(*r*,φ,*z*) everywhere in the drift volume.
3. **Distortion maps.** The inhomogeneous Laplace equation is solved (numerical solver) to translate Δ**E** into per-point position displacements of drifting electrons.
4. **Residual correction (second reconstruction stage).** Using ITS–TRD track interpolation across the TPC, a **high-resolution residual distortion map** is built from the difference between TPC space-points and the ITS–TRD extrapolation. This closes the feedback loop.

### 7.3 Current-based monitoring

Dedicated current measurements on the GEM electrodes provide near-real-time monitoring of the integrated ion flux, which feeds the space-charge map updates [TDR-016 §8.5.2].

### 7.4 Expected Run 3 performance [TDR-016 §8.4.2]

The TDR demonstrates that, with the calibration pipeline in place, **the momentum resolution after residual correction is designed to be preserved** at essentially the Run 1/2 benchmark — i.e. the upgrade target is **no measurable degradation** versus the Run 1/2 TPC for the physics observables that drive the upgrade programme [TDR-016 exec summary; §8.4.2 referenced but not directly extracted in this revision]. Specific post-correction resolution numbers to be populated in the next revision against TDR-016 §8.4.2 and the ALICE Run 3 performance paper (`[VERIFY]`).

## 8. Performance (Run 1/2 measured) [JINST2008 Tab. 3.12]

- Position resolution in **rφ**: 1100 µm (inner radius) → 800 µm (outer).
- Position resolution in **z**: 1250 µm → 1100 µm.
- **d*E*/d*x* resolution**: 5.0 % isolated tracks; 6.8 % at d*N*/d*η* = 8000.
- Pad occupancy at d*N*/d*η* = 8000: 40 % (inner) → 15 % (outer).
- Pad occupancy in pp: 5 × 10⁻⁴ (inner) → 2 × 10⁻⁴ (outer).

Combined with ITS (inner) and TRD/TOF (outer), intermediate-*p*_T σ(*p*_T)/*p*_T is at the ~1 % level, degrading to ~5–10 % at the high end of the range.

## 9. Particle identification via d*E*/d*x*

The TPC samples specific ionization energy loss along each track. The Bethe–Bloch curve

&nbsp;&nbsp;&nbsp;&nbsp;−⟨d*E*/d*x*⟩ ∝ (*z*²/β²) · [ln(2*m*_e *c*² β² γ² / *I*) − β²] + density correction

yields distinct values for different particle species at the same momentum (since β differs with mass). Operating regimes:
- **1/β² region, *p* ≲ 1 GeV/*c*:** strong π/K/p separation.
- **Minimum ionization at βγ ≈ 3–4.**
- **Relativistic rise:** logarithmic growth of ⟨d*E*/d*x*⟩ — extends electron/hadron separation to several GeV/*c* and permits statistical π/K/p separation.

Per-track d*E*/d*x* uses a **truncated mean** over ~150 samples along the track (typically keeping the lowest ~60% of samples) to suppress Landau fluctuations. The resolution figures in §8 assume this truncation.

## 10. Calibration and corrections (summary)

1. **Drift velocity:** monitored via dedicated drift-velocity monitors, laser tracks, and ITS–TPC residual matching.
2. **Gas gain:** tracked via charge-injection pulser and X-ray sources; stability demonstrated to **0.45 %** in GEM R&D over ~21 hours in Ne/CO₂ with 180 ppm H₂O [TDR-016 §5.1.2, Fig. 5.3].
3. **E×B corrections:** parameterized and applied at reconstruction.
4. **Space-charge distortions:** see §7 above.
5. **Laser calibration** [JINST2008 §3.2.2]: each end plate distributes a ~2 cm laser beam to 6 of 18 outer support rods; at 2 × 4 *z*-positions, micro-mirror bundles produce **7 fine rays of ~1 mm diameter** perpendicular to the beam axis. Repetition rate ~10 Hz.
6. **Alignment:** ITS–TPC relative alignment monitored by an optical system to < 20 µm; the TPC is aligned to the solenoid axis with < 1 mrad.
7. **Calibration pulser** [TDR-016 §11.4.4]: electronic pulse injection for channel-level gain and timing.

## 11. Role in the reconstruction chain

The TPC is the **main tracking detector** of the ALICE central barrel. Its role is best understood through the data flow of a single charged-particle track and through the collaboration with neighbouring detectors.

### 11.1 Tracking

- **Seed:** TPC standalone tracking starts from pad-plane clusters grouped into a helix hypothesis via a Kalman-filter outside-in pass. In Run 3 the initial seeding can alternatively be provided by ITS tracklets (inside-out); both strategies are run and merged.
- **Main track fit:** The TPC supplies up to ~150 space-points per track over the 1.6 m radial lever arm. This drives the intermediate-*p*_T momentum resolution (σ(*p*_T)/*p*_T ≈ 1 % for *p*_T ~1 GeV/*c*, ITS+TPC combined) [JINST2008 Tab. 3.12].
- **Extension:** TRD tracklets (matched outside the TPC) extend the lever arm to ~3.7 m and reduce σ(*p*_T)/*p*_T at high *p*_T (\>10 GeV/*c*).
- **Low-*p*_T:** for tracks with *p*_T below the TPC inner-radius threshold (~100 MeV/*c*), ITS-standalone tracking is the primary reconstruction, with the TPC contributing only if the track reaches the active gas volume.

### 11.2 Vertexing

- **Primary vertex:** determined principally by the ITS. The TPC contributes at the level of a constraint — long TPC tracks are extrapolated to the primary vertex and the weighted intersection refines the ITS-driven fit.
- **Secondary vertex:** V⁰ and cascade topologies (K⁰_S, Λ, Ξ, Ω) rely on the TPC for charged-daughter tracking at displacement scales of 1 cm to 1 m — a range where the TPC's long lever arm combined with its momentum measurement is essential. Heavy-flavour displaced-vertex reconstruction combines TPC momentum with ITS impact-parameter resolution.

### 11.3 Particle identification

- **d*E*/d*x*:** the TPC provides truncated-mean specific ionisation (~150 samples, lowest ~60 % retained) over the full *p*_T range from ~100 MeV/*c* up to the relativistic-rise regime (see §9). Separation in the non-relativistic 1/β² region is best for *p* ≲ 1 GeV/*c*; the relativistic rise extends statistical π/K/p separation to several GeV/*c*.
- **Combined PID:** TPC d*E*/d*x* is combined with TOF time-of-flight (1–5 GeV/*c*) and TRD electron-likelihood (electron identification above 1 GeV/*c*) for the full barrel PID matrix.

### 11.4 Multiplicity and event-shape estimators (dissertation focus)

- **Charged-particle multiplicity at mid-rapidity:** the TPC provides the cleanest mid-rapidity track counting within \|η\| < 0.9 (full radial length) and 0.9 < \|η\| < 1.5 (reduced radial length, reduced resolution). TPC-based multiplicity is the principal mid-rapidity input to combined 4π multiplicity estimators that combine central-barrel tracking with forward systems (V0 / FIT).
- **Event-shape observables:** event-plane and q-vector reconstruction using TPC tracks offers the finest φ-granularity available in ALICE; TPC-based event-shape estimators complement the lower-granularity but larger-acceptance forward estimators (FV0 ring segmentation, ZDC).
- **Acceptance limits:** the ~10 % azimuthal dead-zone fraction (inter-sector gaps) and the fall-off of tracking efficiency at \|η\| → 0.9 must be folded into acceptance corrections for multiplicity analyses. Alignment of the IROC/OROC dead zones (preserved in Run 3) simplifies these corrections.

### 11.5 Calibration role

- **TPC is the detector whose calibration is most consequential** for this dissertation. Space-charge distortion maps (§7) are the dominant systematic in Run 3 and the primary subject of much of this work.
- **Reference tracks for TPC calibration** come from ITS + TRD matching: tracks with high-quality ITS and TRD hits, interpolated across the TPC, provide the residual distortion map that closes the Run 3 calibration feedback loop (§7.2, step 4).
- **FIT provides the collision-time reference (t0)** for continuous-readout time-frame reconstruction, a necessary input to the TPC z-coordinate measurement.

### 11.6 Cross-detector dependencies (summary)

| TPC ↔ | Role |
|---|---|
| ITS | inner tracking seed; primary vertex; reference for space-charge residual map |
| TRD | outer tracklet extension; reference for space-charge residual map; Level-1 trigger (Run 1/2) |
| TOF | timing-based PID (1–5 GeV/*c*); track-level time information |
| FIT | collision-time t0 for continuous-readout drift coordinate |
| V0 / FIT (forward) | complementary multiplicity estimator combining with TPC mid-rapidity counting |
| Solenoid | 0.5 T axial field — the momentum-measurement prerequisite |

## 12. Thermal management [JINST2008 §3.2.2]

ΔT ≤ 0.1 K uniformity is enforced by a multi-layer cooling architecture:
1. Heat screen at the outer radius, toward the TRD.
2. Heat screens at the inner radius, shielding from ITS services.
3. Heat screens inside the readout-chamber bodies, shielding from FEE heat.
4. Dedicated FEE cooling.
5. Cooling of the resistive potential divider (high-resistivity water for the 100 kV divider).
6. Outer FEE heat screen.

All circuits are leakless (sub-atmospheric). No dedicated shield in the ITS-facing region (material-budget constraint) — the ITS manages its outer-surface temperature itself.

## 13. Integration and services

- **Support:** the TPC rides on a rail system inside the spaceframe, gliding on four Teflon feet; can be retracted ~5 m to the "parking position" for ITS or beam-pipe access [JINST2008 §3.2.2].
- **Service support wheels:** two wheels that cover the end plates but are independently supported by TPC rails. They carry the ~1 t / side of electronics without loading the readout chambers, reducing thermal coupling to the drift volume.
- **ITS mount:** the innermost TPC shell supports the ITS at two points; this causes a ~0.7 mm sag of the inner drum [JINST2008 §3.1 integration].
- **Installation & services (Run 3 additions)** [TDR-016 Ch. 11]: upgraded HV system, low-voltage distribution, cooling for the new FEE, and calibration pulser distribution. LS2 installation was done in situ on the existing spaceframe.

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

## 16. Open items for further refinement

The following should be enriched with additional sources before the dissertation finalisation:

- **SAMPA reference paper** (Barboza et al., JINST 2016) — for chip-level specs: sampling rate, ADC bits, DSP algorithm parameters, radiation tolerance.
- **CRU reference** — O² TDR (ALICE-TDR-019) was not exhaustively read this pass.
- **ALICE TPC performance papers** (e.g., *Int. J. Mod. Phys. A* **29** (2014) 1430044 for Run 1; dedicated Run 3 performance notes) — for measured (vs designed) momentum and d*E*/d*x* resolution.
- **TPC Run 3 commissioning reports** — for as-achieved IBF, space-charge calibration residuals, and initial-data performance.

These are flagged rather than filled from memory, in line with the project's source-verification rule.

---

*End of v0.3. Changes vs v0.2: P0 fixes (BibTeX block added; §5.2 computed-radius marker; §6.4 channel-count reconciliation rewritten with correct arithmetic). P1 fixes (§3.1 vessel rows relabelled; §4.3 direct quote paraphrased to stay under copyright limits; §4.1 gas history separated into design baseline / operational mixture / alternatives; §5.4 unsourced 200 µs recovery removed; §6.5 SAMPA 10 MHz sampling baseline clarified; §7.1 space-charge magnitude clarified as local peak; §7.4 wording softened to TDR design target). New §11 "Role in the reconstruction chain" — this is the key addition for the dissertation, covering tracking, vertexing, PID, multiplicity / event-shape, calibration, and cross-detector dependencies. Sections 11–15 of v0.2 renumbered to 12–16. Items remaining `[VERIFY]`: gas-history transition date (§4.1); SAMPA sampling rate and ADC bit-depth (§6.5); space-charge peak value 10 vs 20 cm (§7.1); TDR-016 §8.4.2 specific post-correction resolution numbers (§7.4); Run 3 as-measured performance throughout.*
