---
wiki_id: ITS-SoT
title: ALICE Inner Tracking System (ITS / ITS2 / ITS3) — Source of Truth
project: MIWikiAI / ALICE
folder: detectors
source_type: detector-tdr-summary
source_title: ITS_source_of_truth.md
source_fingerprint:
  upstream:
    - id: JINST2008
      title: "The ALICE experiment at the CERN LHC"
      doi: "10.1088/1748-0221/3/08/S08002"
      url: "https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002"
      sections_cited: ["§2.4", "§3.1", "§3.1.1", "§3.1.2", "§3.1.3", "Table 3.1"]
    - id: ALICE-TDR-017
      title: "Technical Design Report for the Upgrade of the ALICE Inner Tracking System"
      report_number: "CERN-LHCC-2013-024, ALICE-TDR-017"
      cds: "https://cds.cern.ch/record/1625842"
      sections_cited: ["§1.1", "§1.2", "Table 1.1", "§4", "Table 4.1", "§4.5", "§5.1", "§5.2", "§6", "§8", "Fig. 1.x"]
    - id: CDR-ITS
      title: "The ALICE ITS Upgrade — Conceptual Design Report"
      report_number: "CERN-LHCC-2012-013, LHCC-P-005"
      cds: "https://cds.cern.ch/record/1475244"
      sections_cited: ["referenced as conceptual predecessor to TDR-017"]
    - id: ALICE-TDR-021
      title: "Technical Design Report for the ALICE Inner Tracking System 3 — ITS3: A bent wafer-scale monolithic pixel detector"
      report_number: "CERN-LHCC-2024-003, ALICE-TDR-021"
      cds: "https://cds.cern.ch/record/2890181"
      sections_cited: ["referenced for Run 4 outlook only"]
    - id: ALICE-TDR-019
      title: "Technical Design Report for the Upgrade of the Online-Offline Computing System"
      report_number: "CERN-LHCC-2015-006, ALICE-TDR-019"
      cds: "https://cds.cern.ch/record/2011297"
      sections_cited: ["referenced only — §3.6 body (O² continuous-readout interface)"]
  summary_version: "v0 (source doc is un-versioned)"
  summary_review_panel: [Claude1]
source_last_verified: 2026-04-19
author: Marian Ivanov (dissertation lead); source-of-truth distilled with AI-assisted review
indexed_by: Claude1
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 1
peer_reviewers: [ClaudeOpus47]
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags: ["§2.5 SPD operational efficiency end-of-Run-2 (alignment paper)", "§2.5 alignment residuals (ITS alignment paper)", "§2.6 Pb-Pb primary-vertex resolution", "§3.8 ITS2 first-year performance (Run 3 performance paper)", "§3.9 installation dates (Run 3 performance paper)", "§7.4 radiation doses end-Run-2 and projected end-Run-3"]
---

# ITS: ALICE Inner Tracking System — Source of Truth

## TL;DR

The ITS is the **innermost ALICE detector**, sitting directly around the beam pipe. It drives primary + secondary vertex reconstruction, low-p_T (below TPC threshold) tracking, and — in Run 1/2 only — low-momentum dE/dx PID. Two generations are in this document:

- **ITS1 (Run 1–2, 2010–2018):** six layers across three silicon technologies — **SPD** pixels (L1-2), **SDD** drift detectors (L3-4), **SSD** strip detectors (L5-6). Inner radius 39 mm, material 1.14 % X₀/inner-layer, readout ceiling ~1 kHz Pb–Pb, σ(d0, rφ) ~75 μm at 1 GeV/c [JINST2008 §3.1].
- **ITS2 (Run 3, 2022–):** seven layers, single technology — **ALPIDE** monolithic CMOS pixel sensors (MAPS) on 180 nm TowerJazz imaging process. Inner radius **22.4 mm** (beam pipe shrunk to 18.6 mm OR), material budget **0.35 % X₀/IB layer** (factor ~3), pixel pitch ~27×29 μm² (factor ~30), intrinsic resolution ~5 μm, readout rate **100 kHz Pb–Pb / 400 kHz pp** (factor ~100), σ(d0, rφ) target **~40 μm at 500 MeV/c** (factor ~3 improvement over Run 2) [TDR-017 Table 1.1].
- **ITS3 (Run 4, 2028–):** IB-only replacement with bent, wafer-scale monolithic pixel sensors in TowerJazz 65 nm CMOS, air-cooled, targeting 0.05 % X₀/IB-layer [TDR-021]. Outside dissertation scope.

The ITS2 upgrade removes analog readout → **no ITS dE/dx PID in Run 3** (TPC-only for hadron PID). The trade-off was accepted for rate, granularity, and material-budget gains.

In this dissertation the ITS participates as: (a) **tracking seed** — inner constraint for outside-in Kalman fits through TPC/TRD/TOF; (b) **calibration anchor** — clean ITS-matched sample used for TPC t0 and space-charge-distortion reference (§5); (c) **impact-parameter provider** for heavy-flavour topology. See [TPC §7.2 calibration pipeline](./tpc.md) for the ITS→TPC residual-distortion feedback loop.

---

## 1. Purpose and role of the ITS

The Inner Tracking System is the innermost subdetector of ALICE, occupying the radial region from the beam pipe outward to approximately 43 cm (ITS1) or 40 cm (ITS2). Its four principal functions, unchanged Run 1 → Run 3 [JINST2008 §3.1]:

1. **Primary vertex reconstruction.** Innermost layers provide the shortest lever arm to the interaction point → best primary-vertex localisation. In central Pb–Pb events, high track multiplicity yields primary-vertex resolution **substantially better than 100 μm** in all three coordinates.
2. **Secondary vertex reconstruction and heavy-flavour tagging.** Charm (cτ ≈ 60–300 μm) and beauty (cτ ≈ 450–500 μm) hadrons decay at measurable distances from the primary vertex. Identification via displaced-vertex topology requires impact-parameter resolution comparable to or better than cτ, driving the innermost-layer radius and material budget.
3. **Low-momentum charged-particle tracking.** ITS-standalone tracking recovers particles with p_T below the TPC acceptance threshold (p_T ≲ 100 MeV/c), supplying the low-p_T end of spectra central to QGP characterisation.
4. **Particle identification via dE/dx (ITS1 only).** The analog-readout layers of ITS1 (SDD + SSD, 4 layers) provide truncated-mean dE/dx in the non-relativistic 1/β² region, complementing the TPC at low momentum [JINST2008 §3.1]. **ITS2 removes this capability** — reliance on TPC for hadron PID; trade-off accepted given rate / granularity / material gains.

The ITS also supplies Level-0 trigger inputs (SPD Fast-OR in ITS1) and serves as the **primary seed for outward track propagation** through the TPC, TRD, and TOF — see [TPC §11.1](./tpc.md).

---

## 2. ITS1 — the Run 1 and Run 2 detector

### 2.1 Overall geometry and technology rationale

ITS1 has **six cylindrical layers** around a beryllium beam pipe of 29.8 mm outer radius [JINST2008 §3.1]. The charged-particle surface density in central Pb–Pb at LHC energies falls from ~50/cm² at r = 4 cm to ~1/cm² at r = 40 cm, so three distinct silicon technologies are tuned to each radial zone:

| Layer | Technology | Mean r [cm] | z extent [cm] | \|η\| coverage | Channels |
|---|---|---|---|---|---|
| 1 (SPD) | Hybrid pixel | 3.9 | ±14.1 | < 2.0 | 3,276,800 |
| 2 (SPD) | Hybrid pixel | 7.6 | ±14.1 | < 1.4 | 6,553,600 |
| 3 (SDD) | Silicon drift | 15.0 | ±22.2 | < 0.9 | 43,008 |
| 4 (SDD) | Silicon drift | 23.9 | ±29.7 | < 0.9 | 90,112 |
| 5 (SSD) | Double-sided Si strip | 38.0 | ±43.1 | < 0.97 | 1,146,880 |
| 6 (SSD) | Double-sided Si strip | 43.0 | ±48.9 | < 0.97 | 1,486,080 |

Values from [JINST2008 Table 3.1]. Total channel count ≈ **12.5 million**, dominated by SPD pixels. Two innermost layers are truly 2D pixel devices (binary readout, ~50 μm pitch in bending plane); four outer layers are analog → dE/dx sampling.

The active silicon is mounted on a rigid carbon-fibre space frame shared across all three subdetectors. Services (cooling, power, signal) run out axially to both A-side and C-side patch panels.

### 2.2 Silicon Pixel Detector (SPD) — layers 1 and 2

**Sensor.** P-on-n high-resistivity silicon diode matrix, **200 μm thick**, 256 × 32 pixels per sensor chip area [JINST2008 §3.1.1]. Pixel size **50 μm (rφ) × 425 μm (z)**. Pitch asymmetry is deliberate: fine pitch aligned with 0.5 T solenoidal bending plane (momentum-dependent deflection) while coarser z matches lower-resolution requirement along beam.

**Front-end chip.** Bump-bonded readout ASIC in **IBM 0.25 μm CMOS rad-hard process**. Per-pixel discriminator with ~**3000 e⁻** threshold, 4-deep multi-event buffer, in-pixel **Fast-OR** logically ORed across all pixels in the chip.

**Stave structure.** Each stave: 2 half-staves; each half-stave 2 ladders of 5 pixel chips each, bump-bonded to a common sensor. Barrel: 60 staves (20 on L1 inner + 40 on L2 outer), 240 ladders, **1,200 pixel chips** → ~9.84 M pixels total [JINST2008 Table 3.1].

**SPD trigger.** Fast-OR signals → dedicated Pixel Trigger (PIT) processor in control room. Programmable FPGA logic computes topological conditions (any hit, multi-layer coincidence, global hit count) on 10 MHz pixel clock — one bunch-crossing granularity for Pb–Pb. PIT output → Central Trigger Processor (CTP) as L0 trigger with ~**800 ns fixed latency** [JINST2008 §3.1.1].

**Cooling.** Evaporative C₄F₁₀ two-phase cooling, **1.35 kW total load**. Inlet ~13 °C, sensor temperature kept below 25 °C to limit leakage + annealing.

**Material budget.** ~**1.14 % X₀ per layer** averaged over acceptance [JINST2008 Table 3.1], dominated by sensor + readout chip + pixel bus + cooling duct. Principal limitation of ITS1 at low p_T.

**Spatial resolution.** Intrinsic hit resolution ~**12 μm (rφ) × ~100 μm (z)** [JINST2008 Table 3.1] — via charge-sharing between adjacent pixels.

**Known operational issues.** Over Run 1/2, fraction of SPD chips developed bias / readout faults; end-of-Run-2 operational efficiency ~95 % of nominal channels, dead regions accounted for in acceptance corrections. `[VERIFY: ALICE ITS alignment paper JINST 5 (2010) P03003 + end-of-Run-2 status note]`.

### 2.3 Silicon Drift Detector (SDD) — layers 3 and 4

**Principle.** Large-area fully-depleted silicon wafer with a linear potential gradient imposed by a series of p+ cathode strips on both faces [JINST2008 §3.1.2]. Ionisation electrons drift **parallel to the wafer surface** at `v_d ≈ μ_n E` (~6.5 μm/ns at nominal 0.8 kV/cm) until they reach a linear array of n+ collection anodes at the wafer edge. Two spatial coordinates:
- **Anode coordinate:** from the anode collecting the charge, interpolated between neighbouring anodes weighted by charge sharing.
- **Drift-time coordinate:** from the time elapsed between event trigger and arrival of the charge cloud at the anode.

**Sensor.** **Neutron-transmutation-doped (NTD) silicon**, 300 μm thick, active area ~**7.02 × 7.53 cm²** per wafer. **Drift length up to 35 mm**. Each wafer has 256 anodes on each of two sides; drift field divides the wafer into two independent drift regions [JINST2008 §3.1.2].

**Front-end readout.** **PASCAL + AMBRA** ASIC pair — preamplification, analog pipeline storage (256 cells at 40 MHz sampling), 8-bit ADC conversion. Total readout per event ~**1 ms** at 40 MHz over the drift window — principal contributor to the **~1 kHz ITS1 readout ceiling**.

**Channel count.** 14 L3 ladders × 6 modules + 22 L4 ladders × 8 modules = 260 modules × 256 anodes × 2 sides = **133,120 anodes**.

**Drift velocity calibration.** v_d depends on carrier mobility → temperature (Δv_d/v_d ≈ −0.8 %/°C) and local field non-uniformity. Three rows of **MOS charge injectors** per wafer inject calibration pulses at known drift distances, yielding v_d maps updated every few minutes during physics runs [JINST2008 §3.1.2]. Temperature monitored with Pt1000 sensors on each ladder.

**Spatial resolution.** Design target **35 μm (drift) × 25 μm (anode)** [JINST2008 §3.1.2]; Run-2 cosmic-ray + pp alignment within ~10 μm of target.

**dE/dx capability.** Analog readout provides charge measurement per cluster, used with SSD for truncated-mean dE/dx in non-relativistic region.

### 2.4 Silicon Strip Detector (SSD) — layers 5 and 6

**Sensor.** Double-sided silicon microstrip, **300 μm thick**, **768 strips per side at 95 μm pitch** [JINST2008 §3.1.3]. Two sides carry orthogonal strip patterns with a small **35 mrad stereo angle** — sufficient for 2D cluster reconstruction via strip coincidence while minimising ghost-hit rate.

**Front-end.** **HAL25 ASIC** in IBM 0.25 μm CMOS, 128 channels per chip, per-channel analog shaper + 40 MHz sample-and-hold.

**Modules and channels.** 748 modules on L5 + 950 modules on L6 = **1,698 modules × 1,536 strip channels/module ≈ 2.6 M strips** [JINST2008 Table 3.1].

> **Footnote on per-layer arithmetic.** The per-layer channel counts in §2.1 Table above are transcribed directly from [JINST2008 Table 3.1] and do **not** equal `modules × 1,536 strips/module` in the nominal sense: L5 table 1,146,880 vs `748 × 1,536 = 1,148,928` (−2,048 channels); L6 table 1,486,080 vs `950 × 1,536 = 1,459,200` (+26,880 channels, **+1.8 %**). The L5 shortfall is consistent with a ~2-module disabled/reserved-strip correction; the L6 excess is larger and its origin is unclear from the table alone. Likely explanations: (a) the published table includes stereo-coincidence or readout-bus overhead channels that are not bare strip channels, or (b) L6 module counts include variants with non-nominal strip counts. The total sum (1,146,880 + 1,486,080 = 2,632,960 ≈ 2.6 M) still matches the rounded figure cited. **`[VERIFY]`** the exact channel-counting convention against [JINST2008 Table 3.1] — surfaced as §8.1 item #7 below.
<!-- discrepancy flagged in review_cycle 1 by ClaudeOpus47 P2.1; L5: 748*1536=1148928 vs table 1146880; L6: 950*1536=1459200 vs table 1486080 -->

**Resolution.** ~**20 μm (rφ) × ~830 μm (z)** [JINST2008 Table 3.1]; poorer z coming from the small stereo angle.

**dE/dx.** Analog amplitude on both sides recorded; combined with SDD for truncated-mean dE/dx for tracks with at least 3 analog hits.

### 2.5 ITS1 services, alignment, and operation

**Mechanical assembly.** Six layers supported on a single carbon-fibre space frame, between the beam pipe and the inner field cage of the TPC. ITS–TPC relative position monitored with an optical alignment system to < 20 μm [JINST2008 §2.4]. ITS–beam-pipe clearance: 5 mm nominal.

**Power and cooling.** SPD uses C₄F₁₀ evaporative cooling; SDD and SSD use demineralised water at ~20 °C inlet. Total power dissipation dominated by SDD analog electronics.

**Alignment.** Cosmic-ray muon tracks (before first stable beam each year) + pp-collision tracks; **Millepede II** global fits. Final Run 2 alignment: residual systematic shifts **< ~10 μm in SPD**, **< ~30 μm in SDD/SSD**. `[VERIFY: ITS alignment paper JINST 5 (2010) P03003]`.

**Readout rate ceiling.** Combined readout dominated by SDD analog drift + digitisation → **ITS1 ceiling ~1 kHz sustained trigger in Pb–Pb** — the most fundamental operational limitation and the principal driver of the Run 3 upgrade.

### 2.6 ITS1 performance summary

| Quantity | Value | Source |
|---|---|---|
| Impact parameter resolution (rφ) at p_T = 1 GeV/c | ~75 μm | [JINST2008 §3.1] |
| Impact parameter resolution (rφ) at p_T = 10 GeV/c | ~20 μm | [JINST2008 §3.1] |
| Primary vertex resolution (central Pb–Pb) | < 10 μm (transverse) | `[VERIFY]` |
| SPD spatial resolution (rφ × z) | 12 × 100 μm² | [JINST2008] |
| SDD spatial resolution (drift × anode) | 35 × 25 μm² | [JINST2008] |
| SSD spatial resolution (rφ × z) | 20 × 830 μm² | [JINST2008] |
| Max sustained readout rate (Pb–Pb) | ~1 kHz | [TDR-017 §1.1] |
| Total material budget, \|η\| < 0.9 | ~7.7 % X₀ | [TDR-017 §1.1] |
| Tracking efficiency at p_T = 100 MeV/c | ~70 % | [TDR-017 Fig. 1.x] |

### 2.7 Limitations that motivated the Run 3 upgrade

[TDR-017 §1.1] enumerates four shortcomings of ITS1 that the Run 3 physics programme could not tolerate:

1. **Readout rate.** 1 kHz ceiling vs 50 kHz Pb–Pb minimum-bias requirement — factor-50 deficit. This alone made the upgrade mandatory, since Run 3 rare-probe statistics (charm baryons, low-mass dielectrons, low-p_T charm) require MB recording of the full luminosity.
2. **Impact parameter resolution at low p_T.** Innermost-layer radius of 39 mm, dominated by 29 mm beam-pipe radius + pixel-assembly material, sets an irreducible floor via multiple scattering. σ(d0, rφ) ≈ 75 μm at 1 GeV/c is **insufficient for Λ_c (cτ ≈ 60 μm)** reconstruction with high purity.
3. **Material budget.** 1.14 % X₀ per inner layer — multiple scattering degrades momentum resolution at low p_T.
4. **Granularity and two-track separation.** 50 × 425 μm² SPD pixel is coarse in z; SPD occupancy in central Pb–Pb approaches a few percent — little margin at higher luminosities.

---

## 3. ITS2 — the Run 3 Upgrade

### 3.1 Design goals

[TDR-017 §1.2] defines five high-level goals:

1. Reduce beam-pipe OR from 29.8 mm to **18.6 mm**, enabling Layer 0 at r = 22.4 mm.
2. Reduce IB material budget to **0.35 % X₀ per layer** (factor ~3 improvement).
3. Reduce pixel pitch below 30 × 30 μm² → intrinsic spatial resolution ~**5 μm**.
4. Read out Pb–Pb at **100 kHz** MB and pp at **400 kHz** (factor 100 above ITS1).
5. Improve impact-parameter resolution in rφ by factor ~3 at p_T = 500 MeV/c.

All achieved by migrating the entire detector to a single technology — **Monolithic Active Pixel Sensors (MAPS)** — implemented in the custom **ALPIDE** chip.

### 3.2 Geometry

ITS2 has **seven** cylindrical layers in two mechanical assemblies [TDR-017 §1.2, Table 1.1]:

| Layer | Barrel | Mean r [mm] | z length [mm] | Staves | Chips/stave | Total chips |
|---|---|---|---|---|---|---|
| 0 | IB | 22.4 | 271 | 12 | 9 | 108 |
| 1 | IB | 30.1 | 271 | 16 | 9 | 144 |
| 2 | IB | 37.8 | 271 | 20 | 9 | 180 |
| 3 | ML | 194.4 | 844 | 24 | 112 | 2,688 |
| 4 | ML | 247.0 | 844 | 30 | 112 | 3,360 |
| 5 | OL | 353.0 | 1,475 | 42 | 196 | 8,232 |
| 6 | OL | 405.0 | 1,475 | 48 | 196 | 9,408 |

Totals: **192 staves, 24,120 chips, ~12.64 × 10⁹ pixels** [TDR-017 Table 1.1]. Acceptance: full azimuth, **\|η\| < 1.22** for tracks through all 7 layers.

### 3.3 ALPIDE chip

ALPIDE (ALice PIxel DEtector) is a monolithic CMOS sensor fabricated in the **TowerJazz 180 nm CMOS imaging process** on p-type epitaxial silicon of resistivity > 1 kΩ·cm [TDR-017 §4].

**Top-level parameters** [TDR-017 Table 4.1]:

| Parameter | Value |
|---|---|
| Die size | 15.0 × 30.0 mm² |
| Matrix | 512 rows × 1024 columns |
| Pixel pitch | **26.88 μm (rφ) × 29.24 μm (z)** |
| Pixels per chip | 524,288 |
| Epitaxial layer | ~25 μm, high-ρ p-type |
| Substrate bias | −3 V nominal |
| Thickness | 50 μm (IB), 100 μm (OB) |
| Power density | < 40 mW/cm² (IB), < 100 mW/cm² (OB) |
| Integration time | ~5 μs (continuous), ≤ 10 μs (triggered) |
| Detection efficiency | > 99 % |
| Fake-hit rate | < 10⁻⁶ / pixel / event (target) |
| Intrinsic position resolution | ~5 μm |

**Signal formation.** MIP deposits ~80 e-h pairs/μm in silicon. In the 25 μm epi-layer → ~**2000 e⁻** per MIP. A small n-well collection diode (~2 μm, ~few fF capacitance) at the pixel centre collects electrons diffusing through the partially-depleted epi-layer under reverse bias. Low capacitance → S/N > 50 at very low power.

**In-pixel front-end.** Each pixel contains:
- Charge-sensitive preamplifier with ~3 μs shaping.
- Discriminator with per-pixel threshold, tunable via `ITHR` and `VCASN` global DACs + one masking bit per pixel.
- 3-deep hit memory (multi-event buffer) covering ~5 μs integration + readout latency.

**Priority-encoder readout.** Hit addresses read out by a matrix of priority encoders scanning the 512 × 1024 matrix — **data-driven, zero-suppressed** — only addresses of hit pixels are emitted. Empty events → no data payload.

**Radiation tolerance.** Qualified to **700 krad TID** and **1 × 10¹³ 1-MeV n_eq/cm² NIEL**, with margin over expected ITS2 inner-layer dose for Run 3 + Run 4 combined [TDR-017 §4.5].

### 3.4 Inner Barrel stave

Each IB stave carries **nine** ALPIDE chips in a single row on a **cold plate** of carbon-fibre composite with embedded polyimide cooling pipes [TDR-017 §5.1]. A **Flexible Printed Circuit (FPC)** — aluminium on polyimide — distributes power + signals and is wire-bonded to each chip. Chips thinned to 50 μm.

**Material breakdown** (target 0.35 % X₀ / layer):
- Silicon sensor, 50 μm: 0.053 % X₀
- Chip metallisation: 0.060 % X₀
- FPC: 0.082 % X₀
- Cold plate + pipes: 0.140 % X₀
- Glue + misc: ~0.015 % X₀

Cooling: water at 18–22 °C inlet through two parallel polyimide pipes of 1.024 mm ID embedded in the cold plate.

### 3.5 Outer Barrel modules and staves

Outer-barrel staves are built from **Hybrid Integrated Circuits (HICs)** — modules of **14 chips** (2 rows × 7 chips) glued to an FPC [TDR-017 §5.2]. One chip per row configured as **master**; the other six as **slaves** transmitting to master over short in-module buses. Master aggregates and transmits off-module.

- Middle Layers (3, 4): 8 HICs/stave → 112 chips.
- Outer Layers (5, 6): 14 HICs/stave → 196 chips.

Each stave split into two **half-staves** mechanically; cold plate shared with a carbon-fibre space frame (Truss). OB chip thickness 100 μm (facilitates HIC assembly). Material budget per OB layer: **~1.0 % X₀** [TDR-017 Table 1.1].

### 3.6 Readout architecture

ITS2 is a **hit-driven, continuous-readout** system [TDR-017 §6]:

- Each chip continuously transmits hit addresses — no trigger gate on the data path.
- **IB chips:** 1.2 Gbps per chip directly off-detector.
- **OB chips:** 400 Mbps to in-HIC master, which aggregates and forwards at up to 1.2 Gbps over the stave link.
- Off-detector, each stave is served by a **Readout Unit (RU)** board. RU handles clock/trigger/configuration delivery, decodes + rate-matches the hit stream, forwards to the **Common Readout Units (CRU)** in the ALICE O² system.
- Clock and trigger signals use the CERN **GBT** link protocol (fixed-latency delivery).
- Trigger interface: even though data are continuous, central trigger still supplies **heartbeat triggers** (every LHC orbit, 89.4 μs) that delineate time frames, and **physics triggers** for configuration / calibration modes.

O² interface described in [TDR-019]. See also [TPC §6.7 continuous readout](./tpc.md) for the shared Run 3 readout paradigm.

### 3.7 Services and beam pipe

The Run 3 installation required a **new beryllium beam pipe** of **18.6 mm OR (18.0 mm IR)**, installed concentrically with the ITS2 IB. Cooling, power, and data services run axially to A-side + C-side patch panels PP1, then PP2/PP3 in the services barrel. Total dissipated power ~**10 kW**; water cooling distributed from the ALICE service cavern.

### 3.8 Performance targets and first-year results

| Quantity | ITS1 (Run 2) | ITS2 (design) | Factor |
|---|---|---|---|
| σ(d0, rφ) at p_T = 500 MeV/c | ~120 μm | ~40 μm | ×3 |
| σ(d0, z) at p_T = 500 MeV/c | ~200 μm | ~40 μm | ×5 |
| Innermost layer radius | 39 mm | 22.4 mm | −43 % |
| IB material / layer | 1.14 % X₀ | 0.35 % X₀ | ×3 |
| Pixel pitch | 50 × 425 μm² | 26.88 × 29.24 μm² | ~×30 |
| Readout rate Pb–Pb | ~1 kHz | 100 kHz | ×100 |
| Tracking ε at p_T = 100 MeV/c | ~70 % | > 90 % | — |

Commissioning data from 2022–2023 Run 3 operations: noise-hit rates on innermost layer **< 10⁻⁷ per pixel per strobe** (well within design); tracking performance consistent with TDR projections. `[VERIFY: ALICE Run 3 performance paper]`.

### 3.9 Installation and commissioning

- **2017–2019:** ALPIDE production, wafer qualification.
- **2019–2020:** IB and OB stave assembly at CERN, Bari, Daresbury, Frascati, Liverpool, NIKHEF, Pusan, Strasbourg, Wuhan.
- **2020–2021:** Surface integration, cosmic-ray tests of full detector.
- **Mid-2021:** Installation in the ALICE cavern together with the new beam pipe.
- **July 2022:** First LHC Run 3 pp collisions recorded with ITS2.
- **2022–present:** Full Run 3 physics operation; further alignment refinements with cosmic + collision data. (As of indexing date 2026-04-19: Run 3 ongoing.)

Timeline per [TDR-017 §8]; actual dates per `[VERIFY: ALICE Run 3 performance paper]`.

---

## 4. ITS3 — Run 4 outlook (brief)

For completeness, [TDR-021] describes a further upgrade of the **Inner Barrel only**, foreseen for the 2028–2029 Long Shutdown. ITS3 replaces IB layers 0–2 with **wafer-scale, bent monolithic pixel sensors** in **TowerJazz 65 nm CMOS**, eliminating the FPC, the cold plate, and water cooling (replaced by air cooling through a self-supporting bent-silicon shell). Target IB material: **0.05 % X₀ per layer** — a further factor-7 reduction. Outer Barrel of ITS2 is retained. ITS3 is outside the scope of this dissertation but noted for completeness since publications from the dissertation period may discuss its prospects.

---

## 5. Role of the ITS in this dissertation

For this work the ITS participates in three capacities:

### 5.1 Combined tracking seed

ITS space points — ideally all seven ITS2 layers, or all six ITS1 layers — seed the track fit that is propagated outward through the TPC, TRD, and TOF. Kalman-filter track reconstruction uses the ITS hits both as inner constraints on the trajectory and as a multiple-scattering anchor for the momentum fit. See [TPC §11.1 tracking](./tpc.md).

### 5.2 Primary-vertex constraint for TPC calibration

Tracks with high-quality ITS hit patterns (matched to all IB layers in ITS2) provide a clean, low-bias sample used to constrain **TPC time-zero (t0)** and to monitor **TPC space-charge distortions**. The ITS–TPC matching efficiency itself is a calibration observable sensitive to TPC distortions and to ITS misalignment. See [TPC §7.2 calibration pipeline step 4](./tpc.md).

### 5.3 Impact parameter for heavy-flavour topology

Secondary-vertex reconstruction of displaced charm and beauty decays relies on the rφ and z impact parameters measured by the ITS. The factor-3 improvement from ITS2 opens low-p_T charm-baryon measurements that were inaccessible in Run 2.

---

## 6. Acronym glossary

- **ALPIDE** — ALice PIxel DEtector chip (ITS2 / Run 3)
- **CMOS** — Complementary Metal-Oxide-Semiconductor
- **CRU** — Common Readout Unit (O² system)
- **CTP** — Central Trigger Processor
- **DAC** — Digital-to-Analog Converter (bias generator)
- **FPC** — Flexible Printed Circuit
- **GBT** — Gigabit Transceiver (CERN link protocol)
- **HIC** — Hybrid Integrated Circuit (OB module of 14 ALPIDEs)
- **IB / ML / OL / OB** — Inner Barrel / Middle Layers / Outer Layers / Outer Barrel
- **ITHR / VCASN** — ALPIDE bias DACs (threshold, cascode)
- **ITS / ITS1 / ITS2 / ITS3** — Inner Tracking System; Run 1–2 / Run 3 / Run 4 variants
- **MAPS** — Monolithic Active Pixel Sensor
- **NIEL** — Non-Ionizing Energy Loss (radiation-damage metric, 1 MeV n_eq/cm²)
- **NTD** — Neutron-Transmutation-Doped (SDD silicon)
- **PIT** — Pixel Trigger (SPD Fast-OR processor)
- **RU** — Readout Unit (ITS2 off-detector board)
- **SDD / SPD / SSD** — Silicon Drift / Pixel / Strip Detector
- **TID** — Total Ionising Dose (krad)
- **X₀** — Radiation length

---

## 7. External references (authoritative URLs)

### 7.1 Primary sources (directly cited in body)

| Tag | Full citation | URL |
|---|---|---|
| **[JINST2008]** | ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002 | DOI: <https://doi.org/10.1088/1748-0221/3/08/S08002> · IOP: <https://iopscience.iop.org/article/10.1088/1748-0221/3/08/S08002> |
| **[TDR-017]** | ALICE Collaboration, *Technical Design Report for the Upgrade of the ALICE Inner Tracking System*, CERN-LHCC-2013-024 / ALICE-TDR-017 (2013) | CDS: <https://cds.cern.ch/record/1625842> |
| **[CDR-ITS]** | ALICE Collaboration, *The ALICE ITS Upgrade — Conceptual Design Report*, CERN-LHCC-2012-013 / LHCC-P-005 (2012) | CDS: <https://cds.cern.ch/record/1475244> |
| **[TDR-021]** | ALICE Collaboration, *Technical Design Report for the ALICE Inner Tracking System 3 — ITS3: A bent wafer-scale monolithic pixel detector*, CERN-LHCC-2024-003 / ALICE-TDR-021 (2024) | CDS: <https://cds.cern.ch/record/2890181> |
| **[TDR-019]** | Buncic, Krzewicki, Vande Vyvre, *Technical Design Report for the Upgrade of the Online-Offline Computing System*, CERN-LHCC-2015-006 / ALICE-TDR-019 (2015) | CDS: <https://cds.cern.ch/record/2011297> |

### 7.2 Additional references (flagged in §8 for next pass)

| Topic | Citation | URL |
|---|---|---|
| ITS cosmic-ray alignment paper | ALICE Collaboration, *Alignment of the ALICE Inner Tracking System with cosmic-ray tracks*, JINST **5** (2010) P03003 | DOI: <https://doi.org/10.1088/1748-0221/5/03/P03003> |
| ALICE Run 3 performance paper | In preparation / forthcoming 2024 | `[VERIFY]` |

### 7.3 BibTeX stubs

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

@techreport{ALICE-TDR-017,
  author      = "{ALICE Collaboration}",
  title       = "{Technical Design Report for the Upgrade of the ALICE Inner Tracking System}",
  institution = "CERN",
  number      = "CERN-LHCC-2013-024, ALICE-TDR-017",
  year        = "2013",
  url         = "https://cds.cern.ch/record/1625842"
}

@techreport{ALICE-CDR-ITS,
  author      = "{ALICE Collaboration}",
  title       = "{The ALICE ITS Upgrade --- Conceptual Design Report}",
  institution = "CERN",
  number      = "CERN-LHCC-2012-013, LHCC-P-005",
  year        = "2012",
  url         = "https://cds.cern.ch/record/1475244"
}

@techreport{ALICE-TDR-021,
  author      = "{ALICE Collaboration}",
  title       = "{Technical Design Report for the ALICE Inner Tracking System 3 --- ITS3: A bent wafer-scale monolithic pixel detector}",
  institution = "CERN",
  number      = "CERN-LHCC-2024-003, ALICE-TDR-021",
  year        = "2024",
  url         = "https://cds.cern.ch/record/2890181"
}

@article{ALICE-ITS-Alignment-2010,
  author   = "{ALICE Collaboration}",
  title    = "{Alignment of the ALICE Inner Tracking System with cosmic-ray tracks}",
  journal  = "JINST",
  volume   = "5",
  pages    = "P03003",
  year     = "2010",
  doi      = "10.1088/1748-0221/5/03/P03003"
}
```

---

## 8. Open items and reviewer-validation checklist

### 8.1 `[VERIFY]` flags from source — carried forward

| # | Section | Issue | Severity |
|---|---|---|---|
| 1 | §2.2 / §2.5 | SPD end-of-Run-2 operational efficiency (~95 % dead-channel fraction); confirm against ALICE ITS alignment paper + end-of-Run-2 status note. | P2 |
| 2 | §2.5 | Alignment residuals (SPD ~10 μm, SDD/SSD ~30 μm) — confirm against JINST 5 (2010) P03003. | P2 |
| 3 | §2.6 | Primary-vertex resolution < 10 μm (central Pb–Pb) — source unclear. | P1 |
| 4 | §3.8 | ITS2 first-year noise-hit rate + tracking performance — validate against ALICE Run 3 performance paper once published. | P1 |
| 5 | §3.9 | Installation dates + Run 3 operation timeline — confirm against ALICE Run 3 performance paper. | P2 |
| 6 | §8.4 (open item #4) | ITS1 end-of-Run-2 integrated radiation dose; ITS2 projected end-of-Run-3 dose. Not yet populated. | P2 |
| 7 | §2.4 | SSD per-layer channel counts in §2.1 Table vs `modules × 1,536 strips/module`: L5 mismatch −2,048, L6 mismatch +26,880 (+1.8 %). Resolve the channel-counting convention used in [JINST2008 Table 3.1]. Added in review_cycle 1 (ClaudeOpus47 P2.1). | P2 |

### 8.2 Open items for further enrichment

| # | Source to add | Purpose |
|---|---|---|
| 8 | Fill page/section numbers in [TDR-017 §x.y] placeholders (Fig. 1.x in particular) | LaTeX-ready citations |
| 9 | Cross-check SDD/SSD resolutions + alignment against [JINST 5 (2010) P03003](https://doi.org/10.1088/1748-0221/5/03/P03003) | Verify Run 2 residuals |
| 10 | Radiation doses at inner layers (ITS1 end-of-Run-2; ITS2 projected end-of-Run-3) | Populate radiation-damage section |
| 11 | Figures to embed in LaTeX (not in this markdown): ITS1 6-layer cross-section; ITS2 7-layer cross-section (IB vs OB); ALPIDE pixel cross-section (collection diode + epi); IB stave exploded view; σ(d0) vs p_T ITS1 vs ITS2; material budget per layer, stacked | Dissertation chapter |

### 8.3 Reviewer checklist

- [ ] **Hard constraint — correctness:** every quantitative claim has a citation tag resolving to §7; every `[VERIFY]` is enumerated in §8.1.
- [ ] **Hard constraint — reproducibility:** every URL in §7 is reachable and returns the expected document at the claimed DOI / CDS record.
- [ ] **Hard constraint — safety (public disclosure):** no unpublished data, no private GitLab paths as clickable links, no internal paths as clickable links.
- [ ] **Citation coverage:** no uncited number anywhere in body.
- [ ] **Cross-ref integrity:** every `./tpc.md` / sibling-detector / presentation link either resolves or appears in §9 "Related wiki pages" with status `planned`.
- [ ] **Arithmetic closure** (every check with full sum expression, per review generalization action):
  - §2.2 SPD total pixels: `1,200 chips × 8,192 px/chip = 9,830,400 ≈ 9.84 M` ✓
  - §2.2 SPD per-layer: `400 × 8,192 = 3,276,800` (L1); `800 × 8,192 = 6,553,600` (L2) ✓
  - §2.3 SDD anode count: `14 × 6 + 22 × 8 = 260 modules × 256 anodes × 2 sides = 133,120` ✓
  - §2.3 SDD per-layer: `84 × 512 = 43,008` (L3); `176 × 512 = 90,112` (L4) ✓
  - §2.4 SSD module-strip check: `748 × 1,536 = 1,148,928` vs Table L5 `1,146,880` = **mismatch −2,048** `[VERIFY §8.1 #7]`; `950 × 1,536 = 1,459,200` vs Table L6 `1,486,080` = **mismatch +26,880** `[VERIFY §8.1 #7]`; sum `1,146,880 + 1,486,080 = 2,632,960 ≈ 2.6 M` ✓ (rounded claim holds)
  - §3.2 ITS2 chip total: `108 + 144 + 180 + 2,688 + 3,360 + 8,232 + 9,408 = 24,120` ✓
  - §3.2 ITS2 stave total: `12 + 16 + 20 + 24 + 30 + 42 + 48 = 192` ✓
  - §3.2 ITS2 pixel total: `24,120 chips × 524,288 px/chip ≈ 12.64 × 10⁹` ✓
  - §3.4 IB material-budget sum: `0.053 + 0.060 + 0.082 + 0.140 + 0.015 = 0.350 %` X₀ ✓ (exact target)
  - §3.3 ALPIDE die-fit check: `1,024 × 26.88 μm = 27.52 mm` (matrix rφ) fits in 30 mm die (periphery margin); `512 × 29.24 μm = 14.97 mm` (matrix z) fits in 15.0 mm die ✓
  - §3.8 Innermost-radius reduction: `(39 − 22.4) / 39 = 42.6 %` ≈ stated −43 % ✓
  - §3.8 Pixel-area ratio: `(50 × 425) / (26.88 × 29.24) = 21,250 / 786 ≈ 27` — stated "~×30" rounds up (off by ~10 %; documentation choice, not arithmetic error)
- [ ] **Appendix A source-to-section map complete:** every numbered section has at least one row mapping to source §/Table.

---

## 9. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`./tpc.md`](./tpc.md) | TL;DR, §1, §3.6, §5.1, §5.2 | live (DRAFT) |
| [`./trd.md`](./trd.md) | §1, §5.1 | planned |
| [`./t0v0zdc.md`](./t0v0zdc.md) | (indirect via TPC §11.4) | planned |
| [`./tof.md`](./tof.md) | §1, §5.1 | planned |
| [`../presentations/PWGPP-643_combined_shape_estimator.md`](../presentations/PWGPP-643_combined_shape_estimator.md) | §5.2 (calibration anchor) | planned (draft exists) |
| [`../presentations/O2-5095_TPC_dEdx_index.md`](../presentations/O2-5095_TPC_dEdx_index.md) | §5.2 (via TPC space-charge calibration) | planned (draft exists) |

Status values: `planned` (target not yet created — expected red link); `live` (target exists, status ≥ DRAFT); `broken` (previously live, now missing — lint-detected regression).

---

## Appendix A: Source-to-section map

| Wiki § | Primary source section(s) |
|---|---|
| §1 Purpose | [JINST2008] §3.1 |
| §2.1 Geometry overview | [JINST2008] Table 3.1, §3.1 |
| §2.2 SPD | [JINST2008] §3.1.1, Table 3.1 |
| §2.3 SDD | [JINST2008] §3.1.2 |
| §2.4 SSD | [JINST2008] §3.1.3, Table 3.1 |
| §2.5 Services / alignment | [JINST2008] §2.4, §3.1; [ITS alignment paper JINST 5 (2010) P03003] `[VERIFY]` |
| §2.6 ITS1 performance | [JINST2008] §3.1 + [TDR-017] §1.1 |
| §2.7 ITS1 upgrade motivation | [TDR-017] §1.1 |
| §3.1 ITS2 design goals | [TDR-017] §1.2 |
| §3.2 ITS2 geometry | [TDR-017] §1.2, Table 1.1 |
| §3.3 ALPIDE chip | [TDR-017] §4, Table 4.1, §4.5 |
| §3.4 IB stave | [TDR-017] §5.1 |
| §3.5 OB stave / HIC | [TDR-017] §5.2, Table 1.1 |
| §3.6 Readout architecture | [TDR-017] §6; [TDR-019] for O² interface |
| §3.7 Services / beam pipe | [TDR-017] (services chapter — Ch number `[VERIFY]`) |
| §3.8 Performance targets | [TDR-017] Table 1.1, Fig. 1.x; ALICE Run 3 performance paper `[VERIFY]` |
| §3.9 Installation timeline | [TDR-017] §8; ALICE Run 3 performance paper `[VERIFY]` |
| §4 ITS3 outlook | [TDR-021] |
| §5 Role in dissertation | derived / dissertation-specific synthesis |

## Appendix B: Notation quick reference

| Symbol | Meaning |
|---|---|
| cτ | proper decay length of unstable hadron |
| σ(d0, rφ) / σ(d0, z) | impact-parameter resolution in bending plane / along beam |
| p_T | transverse momentum |
| X₀ | radiation length (material-budget unit) |
| v_d | drift velocity (SDD electrons) |
| μ_n | electron mobility in silicon |
| e-h | electron-hole pair |
| S/N | signal-to-noise ratio |
| MIP | minimum-ionising particle |
| TID / NIEL | total ionising dose / non-ionising energy loss |
| n_eq/cm² | 1-MeV-neutron-equivalent fluence |
| Pt1000 | platinum thin-film temperature sensor (1 kΩ @ 0 °C) |
| SPD / SDD / SSD / IB / ML / OL / OB | see §6 glossary |

---

## Changelog — source v0 → wiki-v0

- **Structural:** converted to PWGPP-643 schema with flat YAML front-matter; `source_fingerprint` = nested upstream (JINST2008, TDR-017, CDR-ITS, TDR-021, TDR-019) + summary version. Section numbering preserved from source.
- **Added §7 External references:** canonical URLs for every citation tag — JINST DOI + IOP; TDR-017 / CDR-ITS / TDR-021 / TDR-019 CDS records; ITS cosmic-ray alignment paper DOI added (was flagged `[VERIFY]` in source §2.5 and §7 open-item #3). BibTeX block with `url=` fields.
- **Added §8 Reviewer checklist:** all source `[VERIFY]` flags carried forward, P0/P1/P2 severity-classified; hard-constraints line added; URL-reachability explicit check; arithmetic-closure check for SDD anode count + ITS2 chip total.
- **Added §9 Related wiki pages:** 6 outgoing links — tpc.md (**live**, DRAFT exists from this batch), trd.md / t0v0zdc.md / tof.md (planned siblings) + PWGPP-643 + O2-5095 deck indices.
- **Inline cross-links added:** TL;DR → TPC §7.2; §1 / §3.6 / §5.1 / §5.2 → TPC pages. These are the first two-way links in the detector sub-wiki — TPC §11.6 table and ITS §5 now point at each other.
- **Added Appendix A source-to-section map; Appendix B notation quick reference.**
- **Content unchanged:** all physics claims, numbers, tables, `[VERIFY]` flags preserved exactly from source. No new quantitative claims added.

## Changelog — wiki-v0 → wiki-v1 (review_cycle 1)

**Reviewer:** ClaudeOpus47 (peer review, 2026-04-19, verdict `[!]` APPROVED WITH COMMENTS). Review artifact archived alongside this page. 0 P0, 0 P1, 5 P2 — all 4 actionable P2 items fixed here; P2.4 (`[computed]` tagging convention) explicitly deferred per reviewer's recommendation to the cross-page retrofit step.

**Fixes applied:**

- **P2.1 (§2.4 SSD per-layer channel arithmetic).** Footnote added immediately after §2.4 "Modules and channels" line documenting the mismatch between the §2.1 table values (transcribed from [JINST2008 Table 3.1]) and the nominal `modules × 1,536 strips/module` product: L5 `748 × 1,536 = 1,148,928` vs table `1,146,880` (−2,048); L6 `950 × 1,536 = 1,459,200` vs table `1,486,080` (+26,880, +1.8 %). Total sum `2,632,960 ≈ 2.6 M` still closes. Machine-checkable HTML comment `<!-- L5: 748*1536=1148928 vs table 1146880; L6: 950*1536=1459200 vs table 1486080 -->` added. Discrepancy surfaced to §8.1 as new `[VERIFY]` item #7 (P2 severity) and into §8.3 arithmetic-closure check list. Subsequent §8.2 items renumbered 7–10 → 8–11.
- **P2.2 (front-matter `upstream` ≠ §7.1 primary-sources).** Added `TDR-019` (O² TDR) to `source_fingerprint.upstream` list with `sections_cited: ["referenced only — §3.6 body"]`. Front-matter now lists five upstream sources, matching §7.1.
- **P2.3 (missing `summary_review_panel`).** Added `summary_review_panel: [Claude1]` to front-matter (solo production; sentinel value makes the schema uniform with TPC-SoT).
- **P2.5 (stale "2022–2025" date range).** §3.9 timeline updated: `"2022–2025: Full Run 3 physics operation"` → `"2022–present: Full Run 3 physics operation; further alignment refinements with cosmic + collision data. (As of indexing date 2026-04-19: Run 3 ongoing.)"`.
- **Schema alignment (carried over from TPC-SoT review P2.4):** `indexed_by: Claude (Opus 4.7)` → `indexed_by: Claude1`; model info preserved as separate field `indexing_model: Claude (Opus 4.7)`. Added `peer_reviewers: [ClaudeOpus47]` field. `review_cycle: 0 → 1`. This brings ITS into alignment with TPC wiki-v1 and TRD wiki-v0 which already use this convention.
- **§8.3 arithmetic-closure check strengthened per reviewer generalization action** ("every checklist line must include the complete sum expression"). Rewritten from 2 items to 12, each sum spelled out. New checks include: SPD per-layer pixel totals, SDD per-layer anode totals, SSD mismatches with cross-link to §8.1 #7, IB material-budget sum (exact 0.350 %), ALPIDE matrix-pitch-vs-die fit, innermost-radius reduction, pixel-area ratio. All non-SSD checks close; SSD mismatches explicit.

**Deferred to cross-page retrofit** (per reviewer recommendation):

- **P2.4 (`[computed]` tagging convention).** Reviewer explicitly said "don't block this page on it" — applying one consistent convention (inline tag vs. parenthetical) across all four wiki pages in a single pass is more efficient than editing them one at a time. Will ride with the generalization step alongside the TPC-SoT wiki-v1 `source_fingerprint` / `document_version` split.

**Content unchanged** (physics claims, quantitative values, tables). The SSD arithmetic mismatch was *disclosed*, not corrected — the [JINST2008 Table 3.1] values remain authoritative and the module-count product is now contextualized.

---

*End of ITS Source of Truth, wiki-v1 (derived from source via wiki-v0 + ClaudeOpus47 peer review, 2026-04-19). All 4 actionable P2 items from review_cycle 1 applied. P2.4 schema item deferred to cross-page retrofit. Next reviewer pass can consider `[OK]` APPROVED subject to resolution of §8.1 flags #3 (primary-vertex-resolution source), #4 (Run 3 performance paper), and #7 (SSD channel-counting convention).*
