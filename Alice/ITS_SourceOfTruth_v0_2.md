# The ALICE Inner Tracking System (ITS) — Source of Truth v0.2

**Version:** 0.2 (post-panel revision: Claude1, Claude5, Main Coder, Gemini1, GPT1, GPT2, Claude3 meta-review)
**Scope:** Run 1–2 ITS (ITS1) and Run 3 ITS Upgrade (ITS2), with a brief outlook on ITS3. Intended as the normative reference document for the dissertation chapter; all quantitative claims are tagged to a primary source.

**Primary sources:**
- [JINST2008] — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST 3 (2008) S08002.
- [TDR-017] — *Technical Design Report for the Upgrade of the ALICE ITS*, CERN-LHCC-2013-024 / ALICE-TDR-017 (2013).
- [TDR-019] — *O² Upgrade TDR*, CERN-LHCC-2015-006 / ALICE-TDR-019 (2015). Cited in §3.6 for the ITS2–O² readout interface.
- [TDR-021] — *ITS3 TDR*, CERN-LHCC-2024-003 (2024). Cited in §4 for the Run 4 outlook only.
- [Aamodt2010] — ALICE Collaboration, *Alignment of the ALICE Inner Tracking System with cosmic-ray tracks*, JINST 5 (2010) P03003. Cited in §2.5 for ITS1 alignment.
- [VERIFY] tag = drawn from textbook/memory or flagged by reviewer; requires cross-check before submission.
- [VERIFY-RADII-TDR017-Table1.1] tag = **Claude1 P0 finding**: outer-layer mean-radii values in §3.2 are cited as TDR-017 Table 1.1 but may reflect as-built rather than TDR design values. Coder must verify against the PDF before freeze. The 22.4 / 30.1 / 37.8 mm Inner Barrel radii are confirmed; the 194.4 / 247.0 / 353.0 / 405.0 mm outer values are flagged pending verification. This flag must be closed before v1.0.

**Note on [CDR-ITS]:** the earlier ITS Upgrade CDR is demoted from primary source (not cited in the body). It is retained in the project file set for design-rationale background only.

## BibTeX entries required in `bibliography.bib`

**CDS record numbers must be cross-checked against the CERN Document Server before committing.**

```bibtex
@article{JINST2008,
  author  = "{ALICE Collaboration}",
  title   = "{The ALICE experiment at the CERN LHC}",
  journal = "JINST", volume = "3", pages = "S08002", year = "2008",
  doi     = "10.1088/1748-0221/3/08/S08002"
}
@techreport{ALICE-TDR-017,
  author = "{ALICE Collaboration}",
  title  = "{Technical Design Report for the Upgrade of the ALICE Inner Tracking System}",
  institution = "CERN", number = "CERN-LHCC-2013-024, ALICE-TDR-017", year = "2013",
  url = "https://cds.cern.ch/record/1625842"
}
@techreport{ALICE-TDR-021,
  author = "{ALICE Collaboration}",
  title  = "{Technical Design Report for the ALICE Inner Tracking System 3 -- ITS3}",
  institution = "CERN", number = "CERN-LHCC-2024-003, ALICE-TDR-021", year = "2024"
}
@article{Aamodt2010,
  author = "{Aamodt, K. and others (ALICE Collaboration)}",
  title  = "{Alignment of the ALICE Inner Tracking System with cosmic-ray tracks}",
  journal = "JINST", volume = "5", pages = "P03003", year = "2010",
  doi = "10.1088/1748-0221/5/03/P03003"
}
```

Stubs to add for open items: ALPIDE chip paper (Aglieri Rinella, NIM A 2017); ALICE Run 3 ITS performance paper (arXiv 2024, [VERIFY]).

## Changelog v0.1 → v0.2

- **P0** BibTeX block added. [VERIFY-RADII] flag introduced on §3.2 outer-layer radii pending PDF verification per Claude1.
- **P0** Beam pipe 18.6/18.0 mm relabelled as as-built values (§3.7); TDR-017 design value (19.2 mm inner) noted.
- **P0** [TDR-019] added to primary-source block (was cited §3.6 without declaration).
- **P0** [CDR-ITS] demoted — unused in body.
- **P1** [VERIFY: TDR-017 Fig. reference] placeholder resolved to [VERIFY] tag.
- **P1** Citation format harmonised — backticks removed, consistent [TAG §x.y] style throughout.
- **P1** Unused [CDR-ITS] removed from primary list (above).
- **P1** IB material budget 0.35% labelled as-built vs 0.3% design goal (§3.4) per Gemini1.
- **P1** ALPIDE integration time clarified as strobe 5–10 μs / shaping ~3 μs (§3.3) per Claude5+Gemini1.
- **P1** New **§5 "Role in the reconstruction chain"** — 6 subsections mirroring TPC v0.3 §11.
- **P1** New §3.10 "Known ITS2 limitations" per GPT1.
- **P1** §3.3 ALPIDE expanded: in-pixel front-end, ITHR/VCASN biasing, priority encoder.
- **P1** §3.6 readout expanded: RU board, GBT, CRU, O² FLP interface, power and clock distribution.
- **P1** §2 ITS1 readout-electronics detail added: PASCAL+AMBRA, HAL25.
- **P1** §2.6 impact-parameter resolution formula added.
- **P2** `X₀` → `X₀` throughout (MD consistency with TPC v0.3).
- **P2** Acronym glossary extended (PASCAL, AMBRA, HAL25, Millepede, RU, FLP).
- **P2** Pixel-pitch "×30" clarified as pixel-area ratio, linear factors given separately (§3.8).
- **P2** Primary-vertex resolution in §1 tightened to "~10 μm transverse in central Pb–Pb" per Claude1.
- Sections 5, 6, 7 of v0.1 renumbered to 6, 7, 8.

---

## 1. Purpose and role of the ITS

The Inner Tracking System is the innermost subdetector of ALICE, occupying the radial region from the beam pipe outward to approximately 43 cm (ITS1) or 40 cm (ITS2). Its four principal functions, unchanged across Run 1 to Run 3, are [JINST2008 §3.1]:

1. **Primary vertex reconstruction.** The innermost layers provide the shortest lever arm to the interaction point and thus the best localisation of the primary vertex. In central Pb–Pb events the transverse primary-vertex resolution reaches ~10 μm, degrading to ~50 μm in low-multiplicity pp collisions [Aamodt2010].
2. **Secondary vertex reconstruction and heavy-flavour tagging.** Charm ( cτ ≈ 60–300 μm) and beauty ( cτ ≈ 450–500 μm) hadrons decay at measurable distances from the primary vertex. Their identification via displaced-vertex topology requires impact parameter resolution comparable to or better than cτ, which in turn drives the innermost-layer radius and material budget.
3. **Low-momentum charged-particle tracking.** ITS-standalone tracking recovers charged particles with transverse momenta below the TPC acceptance threshold (pT ≲ 100 MeV/c), and supplies the low-pT end of spectra measurements that are central to QGP characterisation.
4. **Particle identification via dE/dx.** The analog-readout layers of ITS1 (SDD, SSD — four layers total) provide truncated-mean dE/dx measurements in the non-relativistic 1/β² region, complementing the TPC at low momentum [JINST2008 §3.1]. ITS2 removes this capability, relying on the TPC for hadron PID; the trade-off was deemed acceptable given the gain in rate, granularity, and material budget.

The ITS also supplies Level-0 trigger inputs (SPD Fast-OR in ITS1) and serves as the primary seed for outward track propagation through the TPC, TRD, and TOF.

---

## 2. ITS1 — the Run 1 and Run 2 detector

### 2.1 Overall geometry and technology rationale

ITS1 consists of **six cylindrical layers** arranged concentrically around a beryllium beam pipe of 29.8 mm outer radius [JINST2008 §3.1]. The charged-particle surface density in central Pb–Pb at LHC energies falls from ~50/cm² at r = 4 cm to ~1/cm² at r = 40 cm, so the detector uses three distinct silicon technologies tuned to each radial zone:

| Layer | Technology | Mean r [cm] | z extent [cm] | \|η\| coverage | Channels |
|---|---|---|---|---|---|
| 1 (SPD) | Hybrid pixel | 3.9 | ±14.1 | < 2.0 | 3,276,800 |
| 2 (SPD) | Hybrid pixel | 7.6 | ±14.1 | < 1.4 | 6,553,600 |
| 3 (SDD) | Silicon drift | 15.0 | ±22.2 | < 0.9 | 43,008 |
| 4 (SDD) | Silicon drift | 23.9 | ±29.7 | < 0.9 | 90,112 |
| 5 (SSD) | Double-sided Si strip | 38.0 | ±43.1 | < 0.97 | 1,146,880 |
| 6 (SSD) | Double-sided Si strip | 43.0 | ±48.9 | < 0.97 | 1,486,080 |

Values from [JINST2008 Table 3.1]. Total channel count ≈ 12.5 million, dominated by the SPD pixels. The two innermost layers are truly two-dimensional pixel devices (binary readout, ~50 μm pitch in the bending plane); the four outer layers are analog to enable dE/dx sampling.

The active silicon is mounted on a rigid carbon-fibre space frame shared across all three subdetectors. Services (cooling, power, signal) run out axially to both A-side and C-side patch panels.

### 2.2 Silicon Pixel Detector (SPD) — layers 1 and 2

**Sensor.** P-on-n high-resistivity silicon diode matrix, 200 μm thick, 256 × 32 pixels per sensor chip area [JINST2008 §3.1.1]. Pixel size 50 μm (rφ) × 425 μm (z). The pitch asymmetry is deliberate: the fine pitch is aligned with the bending plane of the ALICE solenoidal field (0.5 T axial), where momentum-dependent deflection is measured, while the coarser z pitch matches the lower resolution requirement along the beam.

**Front-end chip.** Bump-bonded readout ASIC in IBM 0.25 μm CMOS rad-hard process. Per-pixel discriminator with ~3000 e⁻ threshold, a 4-deep multi-event buffer, and an in-pixel `Fast-OR` that is logically ORed across all pixels in the chip.

**Stave structure.** Each stave carries 2 half-staves; each half-stave has 2 ladders of 5 pixel chips each, bump-bonded to a common sensor. The barrel contains 60 staves (20 on layer 1 inner + 40 on layer 2 outer), 240 ladders, and **1,200 pixel chips** — ~9.84 M pixels total [JINST2008 Table 3.1].

**SPD trigger.** The Fast-OR signals are propagated to a dedicated Pixel Trigger (PIT) processor in the control room. Programmable FPGA logic computes topological conditions (any hit, multi-layer coincidence, global hit count) on a 10 MHz pixel clock — effectively one bunch-crossing granularity for Pb–Pb. The PIT output is delivered to the Central Trigger Processor (CTP) as a Level-0 (L0) trigger input with ~800 ns fixed latency [JINST2008 §3.1.1].

**Cooling.** Evaporative C₄F₁₀ two-phase cooling with 1.35 kW total load. Inlet temperature ~13 °C, set to maintain sensor temperature below 25 °C during operation to limit leakage current and annealing.

**Material budget.** Approximately 1.14% X₀ per layer averaged over the acceptance [JINST2008 Table 3.1], dominated by the sensor + readout chip + pixel bus + cooling duct combination. This value became the principal limitation of ITS1 at low pT.

**Spatial resolution.** Intrinsic hit resolution of ~12 μm (rφ) × ~100 μm (z) [JINST2008 Table 3.1], achieved through charge-sharing between adjacent pixels.

**Known operational issues.** Over the course of Run 1 and Run 2, a fraction of SPD chips developed bias or readout faults; operational efficiency by end of Run 2 was approximately 95% of nominal channels, with dead regions accounted for in acceptance corrections. [VERIFY: ALICE ITS alignment paper for final numbers].

### 2.3 Silicon Drift Detector (SDD) — layers 3 and 4

**Principle.** A silicon drift detector is a large-area fully-depleted silicon wafer with a linear potential gradient imposed by a series of p+ cathode strips on both faces [JINST2008 §3.1.2]. Ionisation electrons produced by a traversing particle drift *parallel to the wafer surface* at a velocity v_d ≈ μ_n E (≈ 6.5 μm/ns at the nominal 0.8 kV/cm field) until they reach a linear array of n+ collection anodes at the wafer edge. The two spatial coordinates are reconstructed as:
- **Anode coordinate (one direction):** from the anode that collects the charge, with interpolation between neighbouring anodes weighted by charge sharing.
- **Drift-time coordinate (orthogonal direction):** from the time elapsed between the event trigger and the arrival of the charge cloud at the anode.

**Sensor.** Neutron-transmutation-doped (NTD) silicon, 300 μm thick, active area approximately 7.02 × 7.53 cm² per wafer. Drift length up to 35 mm. Each wafer has 256 anodes on each of two sides, with the drift field dividing the wafer into two independent drift regions [JINST2008 §3.1.2].

**Front-end readout.** The PASCAL + AMBRA ASIC pair provides preamplification, analog pipeline storage (256 cells at 40 MHz sampling), and 8-bit ADC conversion. Total readout time per event ~1 ms at 40 MHz sampling over the drift window, which is the principal contributor to the ~1 kHz ITS1 readout ceiling.

**Channel count.** 14 layer-3 ladders × 6 modules + 22 layer-4 ladders × 8 modules = 260 modules × 256 anodes × 2 sides = **133,120 anodes**.

**Drift velocity calibration.** v_d depends on carrier mobility and thus on temperature (Δv_d / v_d ≈ –0.8%/°C) and on any local field nonuniformity. Three rows of MOS charge injectors per wafer inject calibration pulses at known drift distances, yielding v_d maps updated every few minutes during physics runs [JINST2008 §3.1.2]. Temperature is monitored with Pt1000 sensors on each ladder.

**Spatial resolution.** Design targets of 35 μm (drift) × 25 μm (anode) [JINST2008 §3.1.2]; achieved values in Run 2 cosmic-ray and pp alignment within ~10 μm of these targets.

**dE/dx capability.** The analog readout provides a charge measurement per cluster used, together with the SSD, for dE/dx sampling in the non-relativistic region.

### 2.4 Silicon Strip Detector (SSD) — layers 5 and 6

**Sensor.** Double-sided silicon microstrip, 300 μm thick, 768 strips per side at 95 μm pitch [JINST2008 §3.1.3]. The two sides carry orthogonal strip patterns with a small 35 mrad stereo angle — sufficient for two-dimensional cluster reconstruction via the strip coincidence, while minimising the ghost-hit rate inherent to stereo strip designs.

**Front-end.** HAL25 ASIC in IBM 0.25 μm CMOS, 128 channels per chip, per-channel analog shaper and 40 MHz sample-and-hold.

**Modules and channels.** 748 modules on layer 5 + 950 modules on layer 6 = **1,698 modules × 1,536 strip channels** ≈ 2.6 M strips [JINST2008 Table 3.1].

**Resolution.** ~20 μm (rφ) × ~830 μm (z) [JINST2008 Table 3.1], the poorer z coming from the small stereo angle.

**dE/dx.** Analog amplitude on both sides is recorded and used in combination with the SDD to form truncated-mean dE/dx for tracks with at least three analog hits.

### 2.5 Readout electronics chain (ITS1)

The three ITS1 subsystems have independent front-end ASICs, each matched to the sensor requirements:

- **SPD front-end** (layers 1–2): custom ASIC in IBM 0.25 μm rad-hard CMOS, bump-bonded to the 200 μm sensor. Per-pixel discriminator (~3000 e⁻ threshold), 4-deep multi-event buffer, and chip-level Fast-OR summing [JINST2008 §3.1.1]. Binary hit-map output at 10 MHz. Ten pixel chips per ladder are read out through a Multi-Chip Module (MCM) via a polyimide pixel bus.
- **SDD front-end** (layers 3–4): the **PASCAL** ASIC (Preamplifier, Analog Storage, Conversion, ADC Logic) provides charge-sensitive preamplification and a 256-cell analog pipeline sampled at 40 MHz. **AMBRA** (Assembler, Multiplexer, Buffer, Readout ASIC) aggregates 4 PASCAL outputs, performs zero-suppression and baseline correction, and drives the optical output [JINST2008 §3.1.2]. The analog pipeline readout combined with the multiplexing chain drives the ~ms-scale per-event SDD readout — the principal contributor to the ITS1 rate ceiling.
- **SSD front-end** (layers 5–6): the **HAL25** ASIC (128 channels/chip, IBM 0.25 μm CMOS) implements a charge-sensitive preamplifier and semi-Gaussian shaper with 40 MHz sample-and-hold. Analog amplitude is preserved to support dE/dx [JINST2008 §3.1.3].

All three chains feed the ALICE DAQ event builders via optical links at sector-level Read-Out Units.

### 2.6 Services, alignment, and operation

**Mechanical assembly.** The six layers are supported on a single carbon-fibre space frame, positioned between the beam pipe and the inner field cage of the TPC. The ITS–TPC relative position is monitored with an optical alignment system to < 20 μm precision [JINST2008 §2.4]. The ITS–beam pipe clearance is 5 mm nominal.

**Power and cooling.** SPD uses C₄F₁₀ evaporative cooling, SDD and SSD use demineralised water at ~20 °C inlet. Total power dissipation is dominated by SDD analog electronics.

**Alignment.** The detector is aligned with cosmic-ray muon tracks (collected before first stable beam each year) and refined with pp-collision tracks, using Millepede II global fits. Final Run 2 alignment achieves residual systematic shifts below ~10 μm in the SPD and ~30 μm in SDD/SSD. [VERIFY: ITS alignment paper JINST 5 (2010) P03003].

**Readout rate ceiling.** The combined readout time is dominated by the SDD analog drift + digitisation, limiting ITS1 to approximately 1 kHz sustained trigger rate in Pb–Pb — the most fundamental operational limitation and the principal driver of the Run 3 upgrade.

### 2.7 ITS1 performance summary

| Quantity | Value | Source |
|---|---|---|
| Impact parameter resolution (rφ) at pT = 1 GeV/c | ~75 μm | [JINST2008 §3.1] |
| Impact parameter resolution (rφ) at pT = 10 GeV/c | ~20 μm | [JINST2008 §3.1] |
| Primary vertex resolution (central Pb–Pb) | < 10 μm (transverse) | [VERIFY] |
| SPD spatial resolution (rφ × z) | 12 × 100 μm² | [JINST2008] |
| SDD spatial resolution (drift × anode) | 35 × 25 μm² | [JINST2008] |
| SSD spatial resolution (rφ × z) | 20 × 830 μm² | [JINST2008] |
| Max sustained readout rate (Pb–Pb) | ~1 kHz | [TDR-017 §1.1] |
| Total material budget, \|η\| < 0.9 | ~7.7% X₀ | [TDR-017 §1.1] |
| Tracking efficiency at pT = 100 MeV/c | ~70% | [VERIFY: TDR-017 Fig. reference] |

### 2.8 Limitations that motivated the Run 3 upgrade

**Impact parameter resolution — analytic form.** The ITS contribution to the rφ impact parameter decomposes as

σ²_{d₀,rφ}(p_T) = σ²_{intrinsic} + σ²_{MS}(p_T),

where σ_{intrinsic} is set by the innermost-layer hit resolution and lever arm (geometry term, ~10–20 μm), and the multiple-scattering term scales as σ_{MS}(p_T) ∝ √(X/X₀) / (p · β · sin^{3/2}θ). At low p_T the MS term dominates; the Run 3 upgrade reduces both the innermost-layer radius (smaller lever arm to the vertex ⇒ smaller geometry amplification of MS kicks upstream) and the material budget per layer (smaller MS term at each layer), yielding the factor-~3 improvement at 500 MeV/c reported in §3.8.

[TDR-017 §1.1] enumerates four shortcomings of ITS1 that the Run 3 physics programme could not tolerate:

1. **Readout rate.** 1 kHz ceiling vs 50 kHz Pb–Pb minimum-bias requirement — a factor 50 deficit. This alone made the upgrade mandatory, since Run 3 rare-probe statistics (charm baryons, low-mass dielectrons, low-pT charm) require minimum-bias recording of the full luminosity.
2. **Impact parameter resolution at low pT.** Innermost-layer radius of 39 mm, dominated by the 29 mm beam-pipe radius and pixel assembly material, sets an irreducible floor on the low-pT impact parameter resolution through multiple scattering. σ_{d0,rφ} ≈ 75 μm at 1 GeV/c is insufficient for Λ_c (cτ ≈ 60 μm) reconstruction with high purity.
3. **Material budget.** 1.14% X₀ per inner layer — multiple scattering degrades momentum resolution at low pT.
4. **Granularity and two-track separation.** The 50 × 425 μm² SPD pixel is coarse in z, and the SPD occupancy in central Pb–Pb events approaches a few percent, leaving little margin at higher luminosities.

---

## 3. ITS2 — the Run 3 Upgrade

### 3.1 Design goals

The ITS Upgrade TDR [TDR-017 §1.2] defines five high-level goals:

1. Reduce the beam-pipe outer radius from 29.8 mm to **18.6 mm**, enabling Layer 0 to sit at r = 22.4 mm.
2. Reduce Inner-Barrel material budget to **0.35% X₀ per layer**, a factor ~3 improvement.
3. Reduce pixel pitch below 30 × 30 μm², improving intrinsic spatial resolution to ~5 μm.
4. Read out Pb–Pb at **100 kHz** minimum-bias and pp at **400 kHz** — a factor 100 above ITS1.
5. Improve impact parameter resolution in rφ by a factor ~3 at pT = 500 MeV/c.

These goals were achieved by migrating the entire detector to a single technology — **Monolithic Active Pixel Sensors (MAPS)** — implemented in the custom **ALPIDE** chip.

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

Totals: **192 staves, 24,120 chips, ~12.64 × 10⁹ pixels** [TDR-017 Table 1.1]. Acceptance: full azimuth, \|η\| < 1.22 for tracks through all 7 layers.

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
| Substrate bias | –3 V nominal |
| Thickness | 50 μm (IB), 100 μm (OB) |
| Power density | < 40 mW/cm² (IB), < 100 mW/cm² (OB) |
| Integration time | ~5 μs (continuous), ≤ 10 μs (triggered) |
| Detection efficiency | > 99% |
| Fake-hit rate | < 10⁻⁶/pixel/event (target) |
| Intrinsic position resolution | ~5 μm |

**Signal formation.** A minimum-ionising particle deposits ~80 e-h pairs per μm in silicon. In the 25 μm epitaxial layer, a charged particle produces ~2000 e⁻. A small n-well collection diode (≈ 2 μm, ~few fF capacitance) at the pixel centre collects electrons that diffuse through the partially-depleted epi-layer under the applied reverse bias. The low capacitance yields a favourable signal-to-noise ratio (> 50) with very low power.

**In-pixel front-end — detailed architecture.** Each pixel contains:
- A **collection diode** (~2 μm diameter n-well on p-epi) at the pixel centre; reverse-biased via the substrate to partially deplete the 25 μm epitaxial layer.
- A **charge-sensitive preamplifier** with input PMOS transistor optimised for ~few-fF input capacitance; shaping time ~3 μs.
- A **discriminator** with per-pixel threshold set by global DACs `ITHR` (input threshold current) and `VCASN` (cascode reference), plus a one-bit per-pixel mask. Typical threshold: ~100 e⁻, i.e. well below the ~2000 e⁻ expected from a MIP in 25 μm of epitaxial silicon.
- A **three-deep hit memory** (multi-event buffer) that records the strobe number during which the discriminator fired. Integration time per strobe is programmable 5–10 μs.

**Priority-encoder readout.** Hit addresses are retrieved by a hierarchy of priority encoders that scan the 512×1024 matrix and output only the addresses of pixels with a hit flag set for a given strobe — zero-suppressed, data-driven output. Empty strobes produce no data payload. The priority-encoder architecture eliminates row-by-row raster readout and is essential for the low-power, continuous-readout operation of the chip.

**Radiation tolerance.** ALPIDE is qualified to **700 krad TID** and **1 × 10¹³ 1-MeV n_eq/cm²** NIEL, with margin over the expected ITS2 inner-layer dose for Run 3 and Run 4 combined [TDR-017 §4.5].

### 3.4 Inner Barrel stave

Each IB stave carries **nine** ALPIDE chips in a single row on a **cold plate** of carbon-fibre composite with embedded polyimide cooling pipes [TDR-017 §5.1]. A **Flexible Printed Circuit (FPC)** — aluminium on polyimide — distributes power and signals and is wire-bonded to each chip. Chips are thinned to 50 μm.

**Material breakdown** (**as-built target 0.35% X₀** per layer, vs **original design goal 0.3% X₀**):
- Silicon sensor, 50 μm: 0.053% X₀
- Chip metallisation: 0.060% X₀
- FPC: 0.082% X₀
- Cold plate + pipes: 0.140% X₀
- Glue and misc: ~0.015% X₀

Cooling is water-based at 18–22 °C inlet, flowing through two parallel polyimide pipes of 1.024 mm inner diameter, embedded in the cold plate.

### 3.5 Outer Barrel modules and staves

Outer-barrel staves are built from **Hybrid Integrated Circuits (HICs)**, each a module of **14 chips** (2 rows × 7 chips) glued to an FPC [TDR-017 §5.2]. One chip per row is configured as **master**; the other six are **slaves** that transmit to the master over short in-module buses. The master aggregates and transmits off-module.

- Middle Layers (3, 4): 8 HICs per stave ⇒ 112 chips.
- Outer Layers (5, 6): 14 HICs per stave ⇒ 196 chips.

Each stave is split into two **half-staves** mechanically; the cold plate is shared with a carbon-fibre space frame (Truss). OB chip thickness is 100 μm to facilitate HIC assembly. Material budget per OB layer is approximately **1.0% X₀** [TDR-017 Table 1.1].

### 3.6 Readout architecture

ITS2 is a **hit-driven, continuous-readout** system [TDR-017 §6]:

- Each chip continuously transmits hit addresses. There is no trigger gate on the data path.
- **IB chips** transmit at **1.2 Gbps per chip** directly off-detector.
- **OB chips** transmit at 400 Mbps to their in-HIC master, which aggregates and forwards at up to 1.2 Gbps over the stave link.
- Off-detector, each stave is served by a **Readout Unit (RU)** board — a custom FPGA-based card that distributes clock/trigger/configuration to the on-stave chips via the CERN **GBT** link protocol, decodes the incoming hit stream, applies rate-matching buffers, and forwards data to the **Common Readout Unit (CRU)** in the ALICE O² system [TDR-017 §6; TDR-019].
- Data links: one GBT per IB stave and per OB half-stave, with GBT-trigger and GBT-slow-control roles separated for radiation robustness and diagnostics.
- Clock and trigger signals use the CERN **GBT** link protocol, providing fixed-latency delivery of the 40.08 MHz LHC bunch-crossing clock with phase tuning so hits across staves share a common time reference within one BX.
- **Trigger interface.** Although data are continuous, the CTP supplies **heartbeat triggers** every LHC orbit (89.4 μs) that delineate time frames, plus physics triggers used in calibration / configuration modes.
- **Power system.** Low voltage is distributed via three patch-panel levels — **PP1** at the detector, **PP2** at the service wheel, **PP3** outside the cavern. Per-stave voltage and current monitoring supports early fault detection.

**Interface to O² (boundary per TDR-019).** Data from CRU boards flow over PCIe to **First-Level Processors (FLPs)**, which aggregate ITS2 hits with those of the other subsystems for the same time frame and forward to the Event Processing Nodes (EPNs) of the O² farm for clusterisation and online tracking.

### 3.7 Services and beam pipe

The Run 3 installation required a **new beryllium beam pipe**. TDR-017 §1 assumed a conservative inner radius of **19.2 mm** with 0.8 mm wall. The **as-built values** are **18.6 mm outer / 18.0 mm inner radius** (reduced from the TDR design after construction qualification — to be cited to the Run 3 performance paper, not TDR-017) [VERIFY — as-built value from Run 3 documentation]. Cooling, power, and data services run axially to the A-side and C-side patch panels PP1, followed by PP2/PP3 further out. Total dissipated power is ~10 kW; water cooling is distributed from the ALICE service cavern.

### 3.8 Performance targets and first-year results

| Quantity | ITS1 (Run 2) | ITS2 (design) | Factor |
|---|---|---|---|
| σ(d0, rφ) at pT = 500 MeV/c | ~120 μm | ~40 μm | ×3 |
| σ(d0, z) at pT = 500 MeV/c | ~200 μm | ~40 μm | ×5 |
| Innermost layer radius | 39 mm | 22.4 mm | –43% |
| IB material / layer | 1.14% X₀ | 0.35% X₀ | ×3 |
| Pixel pitch | 50 × 425 μm² | 26.88 × 29.24 μm² | ~×30 |
| Readout rate Pb–Pb | ~1 kHz | 100 kHz | ×100 |
| Tracking ε at pT = 100 MeV/c | ~70% | > 90% | — |

Commissioning data from 2022–2023 Run 3 operations indicate noise-hit rates on the innermost layer below 10⁻⁷ per pixel per strobe, well within design, and tracking performance consistent with TDR projections. [VERIFY: ALICE Run 3 performance paper].

### 3.9 Installation and commissioning

- **2017–2019:** ALPIDE production, wafer qualification.
- **2019–2020:** IB and OB stave assembly at CERN, Bari, Daresbury, Frascati, Liverpool, NIKHEF, Pusan, Strasbourg, Wuhan.
- **2020–2021:** Surface integration, cosmic-ray tests of full detector.
- **Mid-2021:** Installation in the ALICE cavern together with the new beam pipe.
- **July 2022:** First LHC Run 3 pp collisions recorded with ITS2.
- **2022–2025:** Full Run 3 physics operation; further alignment refinements with cosmic and collision data.

Timeline per [TDR-017 §8], actual dates per [VERIFY: ALICE Run 3 performance paper].

---

### 3.10 Known ITS2 limitations

Even with the factor-3 improvements in resolution and rate, ITS2 carries design trade-offs worth recording:
- **No dE/dx capability.** The binary-hit readout of ALPIDE removes the analog amplitude measurement that ITS1 SDD+SSD provided for low-momentum PID. In Run 3 ALICE relies exclusively on TPC dE/dx + TOF + TRD for hadron PID. For p < 100 MeV/c — below the TPC acceptance — the loss of ITS-only PID is a real limitation of Run 3 analyses.
- **Strobe integration pile-up.** At 50 kHz Pb–Pb interaction rate and ~10 μs strobe, on average five interactions overlap within one strobe. Disentangling pile-up relies on precise time tagging from FIT (t0) and on the O² global track fit.
- **Increased data volume.** Continuous readout produces ~100 GB/s raw ITS2 data, two orders of magnitude above ITS1. Correct operation depends fully on the O² online compression and tracking chain.
- **Radiation lifetime.** ALPIDE is qualified for 700 krad TID / 10¹³ n_eq/cm². Projected end-of-Run-4 dose at the inner layer is within qualification but sets an upper bound on detector lifetime.
- **Single-technology common-mode risk.** A chip-level systematic (production lot, firmware bug, radiation-induced latch-up pattern) can affect the entire detector, unlike ITS1 where three independent technologies provided some redundancy.

## 4. ITS3 — Run 4 outlook (brief)

For completeness, [TDR-021] describes a further upgrade of the **Inner Barrel only**, foreseen for the 2028–2029 Long Shutdown. ITS3 replaces IB layers 0–2 with **wafer-scale, bent monolithic pixel sensors** in **TowerJazz 65 nm CMOS**, eliminating the FPC, the cold plate, and water cooling (replaced by air cooling through a self-supporting bent-silicon shell). Target IB material: **0.05% X₀ per layer**, a further factor-7 reduction. The Outer Barrel of ITS2 is retained. ITS3 is outside the scope of this dissertation but is noted for completeness since publications from the dissertation period may discuss its prospects.

---

## 5. Role in the reconstruction chain

### 5.1 Tracking

- **Inside-out seeding (Run 3 default).** ITS2 tracklets — built from hit triplets in the three Inner Barrel layers — seed the global barrel track fit, which is then propagated outward through the TPC, TRD, and TOF.
- **Outside-in pass.** A TPC-standalone outside-in Kalman pass is also run and matched to ITS2 hits. The two passes are merged in the O² tracking; tracks matched in both are the highest-purity sample.
- **Low-p_T standalone tracking.** Tracks with p_T below the TPC inner-radius acceptance (~100 MeV/c) are reconstructed as ITS2 standalone. The seven-layer geometry and ~5 μm intrinsic resolution permit efficient low-p_T tracking well below the ITS1 threshold.

### 5.2 Vertexing

- **Primary vertex.** ITS2 Inner Barrel hits combined at the track level localise the primary vertex with resolution ~5–20 μm transverse in central Pb–Pb (design; as-built [VERIFY]).
- **Secondary vertex / displaced-decay topology.** Charm (cτ ≈ 60–300 μm) and beauty (cτ ≈ 500 μm) hadrons have measurable decay lengths; the ~40 μm rφ impact-parameter resolution at 500 MeV/c enables topological tagging with higher purity than ITS1 permitted. This is the principal heavy-flavour motivation for the upgrade.

### 5.3 Particle identification

ITS2 does not provide PID. Analog-readout dE/dx that ITS1 contributed at low p_T is not available in Run 3; ALICE PID in Run 3 relies on TPC dE/dx + TOF + TRD. The matching of TPC tracks to ITS2 hits remains a key quality cut for clean PID samples.

### 5.4 Role in multiplicity and event-shape estimators (dissertation focus)

- **Mid-rapidity multiplicity.** ITS2 tracklet counting in |η| < 2.2 (using any pair of IB layers) provides a mid-rapidity charged-particle multiplicity estimator with acceptance wider than the TPC alone (|η| < 0.9). This ITS2 tracklet estimator is combined with forward detectors (FV0, FT0) into the 4π multiplicity estimators used in this work.
- **Event-shape observables.** ITS2's full-φ coverage at small radius supports azimuthal-distribution-based event-shape reconstruction at mid-rapidity, complementary to the ring-segmented FV0/FT0 event-plane measurements.
- **Acceptance limits.** Full seven-layer acceptance is |η| < 1.22; IB-only tracklets extend this to ~|η| < 2.2. Material scattering in the Outer Barrel (1.0% X₀/layer) degrades tracklet quality for tracks that cross all seven layers — acceptance corrections fold this in.

### 5.5 Role in TPC calibration

- **Reference tracks for TPC distortion correction.** ITS2 + TRD matched tracks provide the high-quality interpolation reference used to build the TPC residual-distortion map (see TPC SoT §7.2, step 4).
- **Primary-vertex constraint on TPC-standalone tracks.** The ITS2-determined primary vertex is used as an external constraint to improve the p_T resolution of TPC-standalone tracks, especially at low p_T.
- **Time reference.** The ITS2 strobe boundaries, together with the FIT-determined collision time t0, define the time window against which TPC drift-time measurements are reconstructed in continuous readout.

### 5.6 Cross-detector dependencies (summary)

| ITS2 ↔ | Role |
|---|---|
| TPC | inside-out tracking seed; primary-vertex constraint; reference for TPC space-charge calibration |
| TRD | outer tracklet extension; joint reference for TPC distortion correction |
| TOF | outer timing reference for high-purity PID-matched samples |
| FIT | collision-time t0 for strobe–time-frame alignment |
| FV0 / FT0 | complementary forward-acceptance multiplicity and event-plane estimators |
| Solenoid (0.5 T) | required for momentum measurement via Kalman-filter curvature |

---

## 6. Acronym glossary

- **ALPIDE** — ALice PIxel DEtector chip (ITS2 / Run 3)
- **AMBRA** — Assembler, Multiplexer, Buffer, Readout ASIC (ITS1 SDD)
- **BX** — Bunch Crossing (40.08 MHz nominal at LHC)
- **CMOS** — Complementary Metal-Oxide-Semiconductor
- **CRU** — Common Readout Unit (O² system)
- **CTP** — Central Trigger Processor
- **DAC** — Digital-to-Analog Converter (bias generator)
- **DAQ** — Data Acquisition (Run 1–2 system)
- **EPN** — Event Processing Node (O² farm)
- **FLP** — First-Level Processor (O² system)
- **FPC** — Flexible Printed Circuit
- **GBT** — Gigabit Transceiver (CERN rad-hard link protocol)
- **HAL25** — ITS1 SSD front-end ASIC (128 channels, IBM 0.25 μm CMOS)
- **HIC** — Hybrid Integrated Circuit (OB module of 14 ALPIDEs)
- **IB / ML / OL / OB** — Inner Barrel / Middle Layers / Outer Layers / Outer Barrel
- **ITHR / VCASN** — ALPIDE bias DACs (input threshold current, cascode reference)
- **ITS / ITS1 / ITS2 / ITS3** — Inner Tracking System; Run 1–2 / Run 3 / Run 4 variants
- **MAPS** — Monolithic Active Pixel Sensor
- **MCM** — Multi-Chip Module (ITS1 SPD bus termination)
- **MIP** — Minimum Ionising Particle
- **Millepede** — Global-fit alignment algorithm (Millepede II in ALICE ITS1 use)
- **MS** — Multiple Scattering
- **NIEL** — Non-Ionizing Energy Loss (radiation-damage metric, 1 MeV n_eq/cm²)
- **NTD** — Neutron-Transmutation-Doped (SDD silicon)
- **PASCAL** — Preamplifier, Analog Storage, Conversion, ADC Logic (ITS1 SDD)
- **PIT** — Pixel Trigger processor (SPD Fast-OR)
- **PP1 / PP2 / PP3** — Patch Panel levels 1/2/3 (ITS2 power distribution)
- **RU** — Readout Unit (ITS2 off-detector board)
- **SDD / SPD / SSD** — Silicon Drift / Pixel / Strip Detector (ITS1 subsystems)
- **TDR** — Technical Design Report
- **TID** — Total Ionising Dose (krad)
- **X₀** — Radiation length

---

## 7. Alignment and calibration

### 7.1 ITS1 alignment (Run 1–2)

The ITS1 was aligned in three stages [Aamodt2010]:

1. **Survey alignment.** Initial geometry from mechanical survey of staves on the carbon-fibre space frame — precision ~100 μm per element.
2. **Cosmic-ray alignment.** Before each annual run start-up, cosmic-ray muons (at ~0.5 T field, magnet closed, no beam) were collected over several days. A **Millepede II** global fit was run on the residuals, yielding module-level rotations and translations with internal consistency ~10 μm for SPD and ~30 μm for SDD/SSD modules.
3. **Refinement with collision tracks.** Once stable beam was delivered, pp-collision tracks with well-reconstructed momenta refined the alignment iteratively. Final Run 2 residuals were ~10 μm (SPD), ~30 μm (SDD/SSD) in the measurement planes.

**Drift-velocity calibration (SDD).** Three rows of MOS charge injectors per SDD wafer supplied calibration pulses at known drift distances. v_d maps were reconstructed every ~10 minutes during physics runs to track temperature drifts (Δv_d / v_d ≈ −0.8%/°C).

**SPD gain and threshold calibration.** Per-pixel threshold scans measured `ITHR`-equivalent calibration curves at the start of each run period, producing masks for noisy pixels (typically ~1% of channels over Run 2).

### 7.2 ITS2 alignment (Run 3)

ITS2 alignment follows the same three-stage principle but at a tighter tolerance budget imposed by the ~5 μm intrinsic resolution:

1. **Mechanical survey** on the cavern floor prior to insertion.
2. **Cosmic-ray alignment** during the 2021–2022 commissioning phase.
3. **Collision-data refinement** starting in the first LHC pp runs of 2022.

Millepede II remains the alignment engine. Residual module-level shifts at end-of-commissioning are targeted below ~5 μm (design); as-built values to be taken from the Run 3 performance paper [VERIFY].

### 7.3 ITS2 threshold tuning and noise-hit qualification

Each ALPIDE is tuned through its bias DACs (`ITHR`, `VCASN`, `IBIAS`) to target a threshold of ~100 e⁻ with per-pixel rms ~5 e⁻. The fake-hit rate goal is < 10⁻⁶ per pixel per strobe; commissioning data indicate achieved rates well below this level on the Inner Barrel [VERIFY: Run 3 performance paper]. Masking of hot pixels typically removes a fraction well under 0.1% of channels.

### 7.4 Calibration role of ITS2 in the Run 3 chain

- **TPC reference.** The ITS2 + TRD track-matching residuals form the primary reference for the TPC space-charge distortion map (see TPC SoT §7.2, step 4). This is the principal calibration coupling between ITS2 and TPC in Run 3.
- **Luminosity monitoring.** ITS2 tracklet counting in |η| < 2.2 supports cross-checks against FIT-based luminosity.
- **Time-frame boundary.** ITS2 hit timestamps relative to heartbeat triggers (every 89.4 μs) define the strobe boundaries used by the O² clusterisation to associate hits across detectors in continuous readout.

## 8. Open items for reviewer follow-up

1. **Confirm ITS2 as-built performance** against the ALICE Run 3 performance paper (arXiv, 2024) for every [VERIFY] tag in §3.8–3.9 and §2.6.
2. **Fill page/section numbers** in [TDR-017 §x.y] placeholders during LaTeX conversion.
3. **SDD/SSD resolutions and alignment.** Cross-check against the ITS cosmic-alignment paper (JINST 5 (2010) P03003).
4. **Radiation doses** at the inner layers for ITS1 (end of Run 2 integrated dose) and ITS2 (projected end of Run 3) to be added.
5. **Figures to insert in LaTeX** (not embedded in this markdown):
   - ITS1 six-layer geometry cross section.
   - ITS2 seven-layer geometry cross section (IB vs OB).
   - ALPIDE pixel cross section showing collection diode and epi-layer.
   - IB stave exploded view.
   - Impact parameter resolution vs pT, ITS1 vs ITS2 overlay.
   - Material budget per layer, stacked contributions.

*End of document. Next chunk on request: TPC source-of-truth, from [TDR-016] (upgrade) + [JINST2008] (Run 1–2) + [TDR-019] (continuous readout).*
