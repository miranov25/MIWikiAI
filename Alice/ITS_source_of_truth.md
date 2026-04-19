# The ALICE Inner Tracking System (ITS) — Source of Truth

**Scope:** Run 1–2 ITS (ITS1) and Run 3 ITS Upgrade (ITS2), with a brief outlook on ITS3. Intended as the normative reference document for the dissertation chapter; all quantitative claims are tagged to a primary source.

**Primary sources:**
- `[JINST2008]` — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST 3 (2008) S08002.
- `[TDR-017]` — *Technical Design Report for the Upgrade of the ALICE ITS*, CERN-LHCC-2013-024 / ALICE-TDR-017 (2013).
- `[CDR-ITS]` — *The ALICE ITS Upgrade — Conceptual Design Report* (2012).
- `[TDR-021]` — *ITS3 Technical Design Report*, CERN-LHCC-2024-003 (2024).
- `[VERIFY]` tag = drawn from textbook/memory, requires cross-check before submission.

---

## 1. Purpose and role of the ITS

The Inner Tracking System is the innermost subdetector of ALICE, occupying the radial region from the beam pipe outward to approximately 43 cm (ITS1) or 40 cm (ITS2). Its four principal functions, unchanged across Run 1 to Run 3, are `[JINST2008 §3.1]`:

1. **Primary vertex reconstruction.** The innermost layers provide the shortest lever arm to the interaction point and thus the best localisation of the primary vertex. In central Pb–Pb events, the high track multiplicity yields primary vertex resolution substantially better than 100 μm in all three coordinates.
2. **Secondary vertex reconstruction and heavy-flavour tagging.** Charm ( cτ ≈ 60–300 μm) and beauty ( cτ ≈ 450–500 μm) hadrons decay at measurable distances from the primary vertex. Their identification via displaced-vertex topology requires impact parameter resolution comparable to or better than cτ, which in turn drives the innermost-layer radius and material budget.
3. **Low-momentum charged-particle tracking.** ITS-standalone tracking recovers charged particles with transverse momenta below the TPC acceptance threshold (pT ≲ 100 MeV/c), and supplies the low-pT end of spectra measurements that are central to QGP characterisation.
4. **Particle identification via dE/dx.** The analog-readout layers of ITS1 (SDD, SSD — four layers total) provide truncated-mean dE/dx measurements in the non-relativistic 1/β² region, complementing the TPC at low momentum `[JINST2008 §3.1]`. ITS2 removes this capability, relying on the TPC for hadron PID; the trade-off was deemed acceptable given the gain in rate, granularity, and material budget.

The ITS also supplies Level-0 trigger inputs (SPD Fast-OR in ITS1) and serves as the primary seed for outward track propagation through the TPC, TRD, and TOF.

---

## 2. ITS1 — the Run 1 and Run 2 detector

### 2.1 Overall geometry and technology rationale

ITS1 consists of **six cylindrical layers** arranged concentrically around a beryllium beam pipe of 29.8 mm outer radius `[JINST2008 §3.1]`. The charged-particle surface density in central Pb–Pb at LHC energies falls from ~50/cm² at r = 4 cm to ~1/cm² at r = 40 cm, so the detector uses three distinct silicon technologies tuned to each radial zone:

| Layer | Technology | Mean r [cm] | z extent [cm] | \|η\| coverage | Channels |
|---|---|---|---|---|---|
| 1 (SPD) | Hybrid pixel | 3.9 | ±14.1 | < 2.0 | 3,276,800 |
| 2 (SPD) | Hybrid pixel | 7.6 | ±14.1 | < 1.4 | 6,553,600 |
| 3 (SDD) | Silicon drift | 15.0 | ±22.2 | < 0.9 | 43,008 |
| 4 (SDD) | Silicon drift | 23.9 | ±29.7 | < 0.9 | 90,112 |
| 5 (SSD) | Double-sided Si strip | 38.0 | ±43.1 | < 0.97 | 1,146,880 |
| 6 (SSD) | Double-sided Si strip | 43.0 | ±48.9 | < 0.97 | 1,486,080 |

Values from `[JINST2008 Table 3.1]`. Total channel count ≈ 12.5 million, dominated by the SPD pixels. The two innermost layers are truly two-dimensional pixel devices (binary readout, ~50 μm pitch in the bending plane); the four outer layers are analog to enable dE/dx sampling.

The active silicon is mounted on a rigid carbon-fibre space frame shared across all three subdetectors. Services (cooling, power, signal) run out axially to both A-side and C-side patch panels.

### 2.2 Silicon Pixel Detector (SPD) — layers 1 and 2

**Sensor.** P-on-n high-resistivity silicon diode matrix, 200 μm thick, 256 × 32 pixels per sensor chip area `[JINST2008 §3.1.1]`. Pixel size 50 μm (rφ) × 425 μm (z). The pitch asymmetry is deliberate: the fine pitch is aligned with the bending plane of the ALICE solenoidal field (0.5 T axial), where momentum-dependent deflection is measured, while the coarser z pitch matches the lower resolution requirement along the beam.

**Front-end chip.** Bump-bonded readout ASIC in IBM 0.25 μm CMOS rad-hard process. Per-pixel discriminator with ~3000 e⁻ threshold, a 4-deep multi-event buffer, and an in-pixel `Fast-OR` that is logically ORed across all pixels in the chip.

**Stave structure.** Each stave carries 2 half-staves; each half-stave has 2 ladders of 5 pixel chips each, bump-bonded to a common sensor. The barrel contains 60 staves (20 on layer 1 inner + 40 on layer 2 outer), 240 ladders, and **1,200 pixel chips** — ~9.84 M pixels total `[JINST2008 Table 3.1]`.

**SPD trigger.** The Fast-OR signals are propagated to a dedicated Pixel Trigger (PIT) processor in the control room. Programmable FPGA logic computes topological conditions (any hit, multi-layer coincidence, global hit count) on a 10 MHz pixel clock — effectively one bunch-crossing granularity for Pb–Pb. The PIT output is delivered to the Central Trigger Processor (CTP) as a Level-0 (L0) trigger input with ~800 ns fixed latency `[JINST2008 §3.1.1]`.

**Cooling.** Evaporative C₄F₁₀ two-phase cooling with 1.35 kW total load. Inlet temperature ~13 °C, set to maintain sensor temperature below 25 °C during operation to limit leakage current and annealing.

**Material budget.** Approximately 1.14% \(X_0\) per layer averaged over the acceptance `[JINST2008 Table 3.1]`, dominated by the sensor + readout chip + pixel bus + cooling duct combination. This value became the principal limitation of ITS1 at low pT.

**Spatial resolution.** Intrinsic hit resolution of ~12 μm (rφ) × ~100 μm (z) `[JINST2008 Table 3.1]`, achieved through charge-sharing between adjacent pixels.

**Known operational issues.** Over the course of Run 1 and Run 2, a fraction of SPD chips developed bias or readout faults; operational efficiency by end of Run 2 was approximately 95% of nominal channels, with dead regions accounted for in acceptance corrections. `[VERIFY: ALICE ITS alignment paper for final numbers]`.

### 2.3 Silicon Drift Detector (SDD) — layers 3 and 4

**Principle.** A silicon drift detector is a large-area fully-depleted silicon wafer with a linear potential gradient imposed by a series of p+ cathode strips on both faces `[JINST2008 §3.1.2]`. Ionisation electrons produced by a traversing particle drift *parallel to the wafer surface* at a velocity v_d ≈ μ_n E (≈ 6.5 μm/ns at the nominal 0.8 kV/cm field) until they reach a linear array of n+ collection anodes at the wafer edge. The two spatial coordinates are reconstructed as:
- **Anode coordinate (one direction):** from the anode that collects the charge, with interpolation between neighbouring anodes weighted by charge sharing.
- **Drift-time coordinate (orthogonal direction):** from the time elapsed between the event trigger and the arrival of the charge cloud at the anode.

**Sensor.** Neutron-transmutation-doped (NTD) silicon, 300 μm thick, active area approximately 7.02 × 7.53 cm² per wafer. Drift length up to 35 mm. Each wafer has 256 anodes on each of two sides, with the drift field dividing the wafer into two independent drift regions `[JINST2008 §3.1.2]`.

**Front-end readout.** The PASCAL + AMBRA ASIC pair provides preamplification, analog pipeline storage (256 cells at 40 MHz sampling), and 8-bit ADC conversion. Total readout time per event ~1 ms at 40 MHz sampling over the drift window, which is the principal contributor to the ~1 kHz ITS1 readout ceiling.

**Channel count.** 14 layer-3 ladders × 6 modules + 22 layer-4 ladders × 8 modules = 260 modules × 256 anodes × 2 sides = **133,120 anodes**.

**Drift velocity calibration.** v_d depends on carrier mobility and thus on temperature (Δv_d / v_d ≈ –0.8%/°C) and on any local field nonuniformity. Three rows of MOS charge injectors per wafer inject calibration pulses at known drift distances, yielding v_d maps updated every few minutes during physics runs `[JINST2008 §3.1.2]`. Temperature is monitored with Pt1000 sensors on each ladder.

**Spatial resolution.** Design targets of 35 μm (drift) × 25 μm (anode) `[JINST2008 §3.1.2]`; achieved values in Run 2 cosmic-ray and pp alignment within ~10 μm of these targets.

**dE/dx capability.** The analog readout provides a charge measurement per cluster used, together with the SSD, for dE/dx sampling in the non-relativistic region.

### 2.4 Silicon Strip Detector (SSD) — layers 5 and 6

**Sensor.** Double-sided silicon microstrip, 300 μm thick, 768 strips per side at 95 μm pitch `[JINST2008 §3.1.3]`. The two sides carry orthogonal strip patterns with a small 35 mrad stereo angle — sufficient for two-dimensional cluster reconstruction via the strip coincidence, while minimising the ghost-hit rate inherent to stereo strip designs.

**Front-end.** HAL25 ASIC in IBM 0.25 μm CMOS, 128 channels per chip, per-channel analog shaper and 40 MHz sample-and-hold.

**Modules and channels.** 748 modules on layer 5 + 950 modules on layer 6 = **1,698 modules × 1,536 strip channels** ≈ 2.6 M strips `[JINST2008 Table 3.1]`.

**Resolution.** ~20 μm (rφ) × ~830 μm (z) `[JINST2008 Table 3.1]`, the poorer z coming from the small stereo angle.

**dE/dx.** Analog amplitude on both sides is recorded and used in combination with the SDD to form truncated-mean dE/dx for tracks with at least three analog hits.

### 2.5 ITS1 services, alignment, and operation

**Mechanical assembly.** The six layers are supported on a single carbon-fibre space frame, positioned between the beam pipe and the inner field cage of the TPC. The ITS–TPC relative position is monitored with an optical alignment system to < 20 μm precision `[JINST2008 §2.4]`. The ITS–beam pipe clearance is 5 mm nominal.

**Power and cooling.** SPD uses C₄F₁₀ evaporative cooling, SDD and SSD use demineralised water at ~20 °C inlet. Total power dissipation is dominated by SDD analog electronics.

**Alignment.** The detector is aligned with cosmic-ray muon tracks (collected before first stable beam each year) and refined with pp-collision tracks, using Millepede II global fits. Final Run 2 alignment achieves residual systematic shifts below ~10 μm in the SPD and ~30 μm in SDD/SSD. `[VERIFY: ITS alignment paper JINST 5 (2010) P03003]`.

**Readout rate ceiling.** The combined readout time is dominated by the SDD analog drift + digitisation, limiting ITS1 to approximately 1 kHz sustained trigger rate in Pb–Pb — the most fundamental operational limitation and the principal driver of the Run 3 upgrade.

### 2.6 ITS1 performance summary

| Quantity | Value | Source |
|---|---|---|
| Impact parameter resolution (rφ) at pT = 1 GeV/c | ~75 μm | `[JINST2008 §3.1]` |
| Impact parameter resolution (rφ) at pT = 10 GeV/c | ~20 μm | `[JINST2008 §3.1]` |
| Primary vertex resolution (central Pb–Pb) | < 10 μm (transverse) | `[VERIFY]` |
| SPD spatial resolution (rφ × z) | 12 × 100 μm² | `[JINST2008]` |
| SDD spatial resolution (drift × anode) | 35 × 25 μm² | `[JINST2008]` |
| SSD spatial resolution (rφ × z) | 20 × 830 μm² | `[JINST2008]` |
| Max sustained readout rate (Pb–Pb) | ~1 kHz | `[TDR-017 §1.1]` |
| Total material budget, \|η\| < 0.9 | ~7.7% \(X_0\) | `[TDR-017 §1.1]` |
| Tracking efficiency at pT = 100 MeV/c | ~70% | `[TDR-017 Fig. 1.x]` |

### 2.7 Limitations that motivated the Run 3 upgrade

`[TDR-017 §1.1]` enumerates four shortcomings of ITS1 that the Run 3 physics programme could not tolerate:

1. **Readout rate.** 1 kHz ceiling vs 50 kHz Pb–Pb minimum-bias requirement — a factor 50 deficit. This alone made the upgrade mandatory, since Run 3 rare-probe statistics (charm baryons, low-mass dielectrons, low-pT charm) require minimum-bias recording of the full luminosity.
2. **Impact parameter resolution at low pT.** Innermost-layer radius of 39 mm, dominated by the 29 mm beam-pipe radius and pixel assembly material, sets an irreducible floor on the low-pT impact parameter resolution through multiple scattering. σ_{d0,rφ} ≈ 75 μm at 1 GeV/c is insufficient for Λ_c (cτ ≈ 60 μm) reconstruction with high purity.
3. **Material budget.** 1.14% \(X_0\) per inner layer — multiple scattering degrades momentum resolution at low pT.
4. **Granularity and two-track separation.** The 50 × 425 μm² SPD pixel is coarse in z, and the SPD occupancy in central Pb–Pb events approaches a few percent, leaving little margin at higher luminosities.

---

## 3. ITS2 — the Run 3 Upgrade

### 3.1 Design goals

The ITS Upgrade TDR `[TDR-017 §1.2]` defines five high-level goals:

1. Reduce the beam-pipe outer radius from 29.8 mm to **18.6 mm**, enabling Layer 0 to sit at r = 22.4 mm.
2. Reduce Inner-Barrel material budget to **0.35% \(X_0\) per layer**, a factor ~3 improvement.
3. Reduce pixel pitch below 30 × 30 μm², improving intrinsic spatial resolution to ~5 μm.
4. Read out Pb–Pb at **100 kHz** minimum-bias and pp at **400 kHz** — a factor 100 above ITS1.
5. Improve impact parameter resolution in rφ by a factor ~3 at pT = 500 MeV/c.

These goals were achieved by migrating the entire detector to a single technology — **Monolithic Active Pixel Sensors (MAPS)** — implemented in the custom **ALPIDE** chip.

### 3.2 Geometry

ITS2 has **seven** cylindrical layers in two mechanical assemblies `[TDR-017 §1.2, Table 1.1]`:

| Layer | Barrel | Mean r [mm] | z length [mm] | Staves | Chips/stave | Total chips |
|---|---|---|---|---|---|---|
| 0 | IB | 22.4 | 271 | 12 | 9 | 108 |
| 1 | IB | 30.1 | 271 | 16 | 9 | 144 |
| 2 | IB | 37.8 | 271 | 20 | 9 | 180 |
| 3 | ML | 194.4 | 844 | 24 | 112 | 2,688 |
| 4 | ML | 247.0 | 844 | 30 | 112 | 3,360 |
| 5 | OL | 353.0 | 1,475 | 42 | 196 | 8,232 |
| 6 | OL | 405.0 | 1,475 | 48 | 196 | 9,408 |

Totals: **192 staves, 24,120 chips, ~12.64 × 10⁹ pixels** `[TDR-017 Table 1.1]`. Acceptance: full azimuth, \|η\| < 1.22 for tracks through all 7 layers.

### 3.3 ALPIDE chip

ALPIDE (ALice PIxel DEtector) is a monolithic CMOS sensor fabricated in the **TowerJazz 180 nm CMOS imaging process** on p-type epitaxial silicon of resistivity > 1 kΩ·cm `[TDR-017 §4]`.

**Top-level parameters** `[TDR-017 Table 4.1]`:

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

**In-pixel front-end.** Each pixel contains:
- A charge-sensitive preamplifier with a ~3 μs shaping time.
- A discriminator with per-pixel threshold, tunable via the `ITHR` and `VCASN` global DACs plus one masking bit per pixel.
- A 3-deep hit memory (multi-event buffer) to cover the ~5 μs integration + readout latency.

**Priority-encoder readout.** Hit addresses are read out by a matrix of priority encoders that scan the 512 × 1024 matrix and deliver only the addresses of hit pixels — data-driven, zero-suppressed — eliminating row-by-row raster readout. Empty events produce no data payload.

**Radiation tolerance.** ALPIDE is qualified to **700 krad TID** and **1 × 10¹³ 1-MeV n_eq/cm²** NIEL, with margin over the expected ITS2 inner-layer dose for Run 3 and Run 4 combined `[TDR-017 §4.5]`.

### 3.4 Inner Barrel stave

Each IB stave carries **nine** ALPIDE chips in a single row on a **cold plate** of carbon-fibre composite with embedded polyimide cooling pipes `[TDR-017 §5.1]`. A **Flexible Printed Circuit (FPC)** — aluminium on polyimide — distributes power and signals and is wire-bonded to each chip. Chips are thinned to 50 μm.

**Material breakdown** (target 0.35% \(X_0\) per layer):
- Silicon sensor, 50 μm: 0.053% \(X_0\)
- Chip metallisation: 0.060% \(X_0\)
- FPC: 0.082% \(X_0\)
- Cold plate + pipes: 0.140% \(X_0\)
- Glue and misc: ~0.015% \(X_0\)

Cooling is water-based at 18–22 °C inlet, flowing through two parallel polyimide pipes of 1.024 mm inner diameter, embedded in the cold plate.

### 3.5 Outer Barrel modules and staves

Outer-barrel staves are built from **Hybrid Integrated Circuits (HICs)**, each a module of **14 chips** (2 rows × 7 chips) glued to an FPC `[TDR-017 §5.2]`. One chip per row is configured as **master**; the other six are **slaves** that transmit to the master over short in-module buses. The master aggregates and transmits off-module.

- Middle Layers (3, 4): 8 HICs per stave ⇒ 112 chips.
- Outer Layers (5, 6): 14 HICs per stave ⇒ 196 chips.

Each stave is split into two **half-staves** mechanically; the cold plate is shared with a carbon-fibre space frame (Truss). OB chip thickness is 100 μm to facilitate HIC assembly. Material budget per OB layer is approximately **1.0% \(X_0\)** `[TDR-017 Table 1.1]`.

### 3.6 Readout architecture

ITS2 is a **hit-driven, continuous-readout** system `[TDR-017 §6]`:

- Each chip continuously transmits hit addresses. There is no trigger gate on the data path.
- **IB chips** transmit at **1.2 Gbps per chip** directly off-detector.
- **OB chips** transmit at 400 Mbps to their in-HIC master, which aggregates and forwards at up to 1.2 Gbps over the stave link.
- Off-detector, each stave is served by a **Readout Unit (RU)** board. The RU handles clock/trigger/configuration delivery to the chips, decodes and rate-matches the hit stream, and forwards data to the **Common Readout Units (CRU)** in the ALICE O² system.
- Clock and trigger signals use the CERN **GBT** link protocol, providing fixed-latency delivery.
- Trigger interface: even though data are continuous, the central trigger still supplies **heartbeat triggers** (every LHC orbit, 89.4 μs) that delineate time frames and **physics triggers** for configuration and calibration modes.

The interface with O² is the boundary described in `[TDR-019]` (O² Upgrade TDR).

### 3.7 Services and beam pipe

The Run 3 installation required a **new beryllium beam pipe** of 18.6 mm outer radius (inner 18.0 mm), installed concentrically with the ITS2 IB. Cooling, power, and data services run axially to the A-side and C-side patch panels PP1, followed by patch panels PP2/PP3 further out in the services barrel. Total dissipated power is ~10 kW; water cooling is distributed from the ALICE service cavern.

### 3.8 Performance targets and first-year results

| Quantity | ITS1 (Run 2) | ITS2 (design) | Factor |
|---|---|---|---|
| σ(d0, rφ) at pT = 500 MeV/c | ~120 μm | ~40 μm | ×3 |
| σ(d0, z) at pT = 500 MeV/c | ~200 μm | ~40 μm | ×5 |
| Innermost layer radius | 39 mm | 22.4 mm | –43% |
| IB material / layer | 1.14% \(X_0\) | 0.35% \(X_0\) | ×3 |
| Pixel pitch | 50 × 425 μm² | 26.88 × 29.24 μm² | ~×30 |
| Readout rate Pb–Pb | ~1 kHz | 100 kHz | ×100 |
| Tracking ε at pT = 100 MeV/c | ~70% | > 90% | — |

Commissioning data from 2022–2023 Run 3 operations indicate noise-hit rates on the innermost layer below 10⁻⁷ per pixel per strobe, well within design, and tracking performance consistent with TDR projections. `[VERIFY: ALICE Run 3 performance paper]`.

### 3.9 Installation and commissioning

- **2017–2019:** ALPIDE production, wafer qualification.
- **2019–2020:** IB and OB stave assembly at CERN, Bari, Daresbury, Frascati, Liverpool, NIKHEF, Pusan, Strasbourg, Wuhan.
- **2020–2021:** Surface integration, cosmic-ray tests of full detector.
- **Mid-2021:** Installation in the ALICE cavern together with the new beam pipe.
- **July 2022:** First LHC Run 3 pp collisions recorded with ITS2.
- **2022–2025:** Full Run 3 physics operation; further alignment refinements with cosmic and collision data.

Timeline per `[TDR-017 §8]`, actual dates per `[VERIFY: ALICE Run 3 performance paper]`.

---

## 4. ITS3 — Run 4 outlook (brief)

For completeness, `[TDR-021]` describes a further upgrade of the **Inner Barrel only**, foreseen for the 2028–2029 Long Shutdown. ITS3 replaces IB layers 0–2 with **wafer-scale, bent monolithic pixel sensors** in **TowerJazz 65 nm CMOS**, eliminating the FPC, the cold plate, and water cooling (replaced by air cooling through a self-supporting bent-silicon shell). Target IB material: **0.05% \(X_0\) per layer**, a further factor-7 reduction. The Outer Barrel of ITS2 is retained. ITS3 is outside the scope of this dissertation but is noted for completeness since publications from the dissertation period may discuss its prospects.

---

## 5. Role of the ITS in this dissertation

For this work the ITS participates in three capacities:

**Combined tracking seed.** ITS space points — ideally all seven ITS2 layers, or all six ITS1 layers — seed the track fit that is propagated outward through the TPC, TRD, and TOF. Kalman-filter track reconstruction uses the ITS hits both as inner constraints on the trajectory and as a multiple-scattering anchor for the momentum fit.

**Primary-vertex constraint for TPC calibration.** Tracks with high-quality ITS hit patterns (matched to all IB layers in ITS2) provide a clean, low-bias sample used to constrain TPC time-zero (t0) and to monitor TPC space-charge distortions. The ITS–TPC matching efficiency itself is a calibration observable sensitive to TPC distortions and to ITS misalignment.

**Impact parameter for heavy-flavour topology.** Secondary-vertex reconstruction of displaced charm and beauty decays relies on the rφ and z impact parameters measured by the ITS. The factor-3 improvement from ITS2 opens low-pT charm-baryon measurements that were inaccessible in Run 2.

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

## 7. Open items for reviewer follow-up

1. **Confirm ITS2 as-built performance** against the ALICE Run 3 performance paper (arXiv, 2024) for every `[VERIFY]` tag in §3.8–3.9 and §2.6.
2. **Fill page/section numbers** in `[TDR-017 §x.y]` placeholders during LaTeX conversion.
3. **SDD/SSD resolutions and alignment.** Cross-check against the ITS cosmic-alignment paper (JINST 5 (2010) P03003).
4. **Radiation doses** at the inner layers for ITS1 (end of Run 2 integrated dose) and ITS2 (projected end of Run 3) to be added.
5. **Figures to insert in LaTeX** (not embedded in this markdown):
   - ITS1 six-layer geometry cross section.
   - ITS2 seven-layer geometry cross section (IB vs OB).
   - ALPIDE pixel cross section showing collection diode and epi-layer.
   - IB stave exploded view.
   - Impact parameter resolution vs pT, ITS1 vs ITS2 overlay.
   - Material budget per layer, stacked contributions.

*End of document. Next chunk on request: TPC source-of-truth, from `[TDR-016]` (upgrade) + `[JINST2008]` (Run 1–2) + `[TDR-019]` (continuous readout).*
