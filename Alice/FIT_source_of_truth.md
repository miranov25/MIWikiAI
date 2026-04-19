# The ALICE Fast Interaction Trigger (FIT) — Source of Truth

**Scope:** The FIT detector for Run 3, replacing the Run 1–2 forward trigger systems T0, V0 and FMD. This document uses the dedicated FIT chapter (Chapter 10, 10 pages) of the ALICE Readout & Trigger Upgrade TDR as its primary source.

**Primary sources:**
- `[TDR-015 §10]` — *Upgrade of the Readout & Trigger System TDR*, CERN-LHCC-2013-019 / ALICE-TDR-015, Chapter 10: *Fast Interaction Trigger — FIT*. Authoritative conceptual design document for FIT.
- `[JINST2008 §7,§8,§9]` — for the legacy T0, V0, FMD systems that FIT replaces.
- `[VERIFY-FIT-AS-BUILT]` = as-built Run 3 design (FV0, FT0, FDD) may deviate from the TDR-015 conceptual baseline; final numbers require the FIT construction / performance paper.

**Important note on nomenclature.** The `[TDR-015]` FIT chapter describes the detector under the names **T0-Plus** and **V0-Plus** (the conceptual design as of 2014). The detector was subsequently built and installed for Run 3 under the names **FT0** (evolution of T0-Plus), **FV0** (evolution of V0-Plus, reconfigured as a single A-side disk with 5 rings) and **FDD** (Forward Diffractive Detector, replacing the FMD role on both sides at larger \|η\|). Where the as-built design differs from the TDR-015 concept, this is flagged `[VERIFY-FIT-AS-BUILT]`.

---

## 1. Purpose and role of FIT

The Fast Interaction Trigger replaces the three legacy ALICE forward systems **T0, V0 and FMD** with a single integrated system `[TDR-015 §10.1]`. It provides all the functions that those three detectors provided in Run 1 and Run 2, adapted to the Run 3 operating conditions (50 kHz Pb–Pb interaction rate, continuous readout) `[TDR-015 §10.1]`:

1. **Minimum Bias trigger** for pp and Pb–Pb collisions, delivered to the CTP.
2. **Collision time (T0) determination** as a reference for the TOF detector, with resolution < 50 ps.
3. **Vertex localisation** along the beam axis from A-side/C-side timing difference.
4. **Online luminosity and beam-condition monitoring**, including direct feedback to the LHC.
5. **Beam-gas and beam-background rejection** via A–C timing coincidence windows.
6. **Offline centrality and event-plane determination** for Pb–Pb, from the total integrated amplitude and its azimuthal segmentation — matching the Run 1–2 V0 performance.
7. **Multiplicity trigger** for central and semi-central Pb–Pb selection.

Two complementary sensor technologies are used, preserving the redundancy principle of the legacy T0 + V0 combination `[TDR-015 §10.1]`: a quartz Cherenkov + MCP-PMT system (T0-Plus / FT0), and a plastic-scintillator + PMT system (V0-Plus / FV0).

---

## 2. Heritage: the Run 1–2 T0, V0 and FMD

### 2.1 T0 (legacy)

The Run 1–2 T0 consists of two arrays of Cherenkov counters, **T0A and T0C**, positioned on the opposite sides of the interaction point (IP) at distances **+370 cm (A)** and **−70 cm (C)** `[TDR-015 §10.2]`. Each array has **12 cylindrical counters**, each equipped with a **quartz radiator** coupled to a **fine-mesh photomultiplier tube**.

**Pseudorapidity coverage:** T0C −3.28 < η < −2.97; T0A 4.61 < η < 4.92 `[TDR-015 §10.2]`.

**Performance achieved in Run 1–2 `[TDR-015 §10.2]`:**
- pp: time resolution **~40 ps**, vertex efficiency ~50% (low multiplicity, small acceptance).
- Pb–Pb (0–60% centrality), \(\sqrt{s_{NN}}\) = 2.76 TeV: time resolution **~21 ps**, vertex efficiency close to 100%.

**Limitations:** small acceptance (12 counters per side), after-pulses in the fine-mesh PMTs, inadequate rate capability for Run 3.

### 2.2 V0 (legacy)

The Run 1–2 V0 consists of two **plastic-scintillator disks** at z = **−90 cm (V0C)** and **z = +329 cm (V0A)** from the IP `[TDR-015 §10.3]`. Each disk is segmented into **4 radial rings × 8 azimuthal sectors = 32 cells**.

**Pseudorapidity coverage:** V0A 2.8 < η < 5.1; V0C −3.7 < η < −1.8 `[TDR-015 §10.3]`.

**Light collection:** Bicron plastic scintillator with wavelength-shifting (WLS) fibres embedded in both faces (V0A) or along the radial edges (V0C).

**Role in Run 1–2 `[TDR-015 §10.3]`:**
- Minimum-bias trigger (A&C coincidence) and beam-gas veto via time-window selection.
- Multiplicity trigger via total integrated charge.
- **Primary offline centrality estimator** in Pb–Pb, with amplitude distribution fitted by a Glauber model (slicing into centrality classes).
- Event-plane determination (second harmonic v₂ of the azimuthal distribution).

**Time resolution:** ~450 ps (V0A) and ~350 ps (V0C) — sufficient for trigger timing but much coarser than T0 `[TDR-015 §10.3]`.

**Minimum-bias efficiency targets of the V0 (inherited by FIT):** ≥ 83% vertex (A&C coincidence) and ≥ 93% OR (A|C) in pp `[TDR-015 §10.4]`.

### 2.3 FMD (legacy)

The **Forward Multiplicity Detector** used silicon strip rings at extended rapidities (1.7 < η < 5.1 and −3.4 < η < −1.7) to count charged particles for offline multiplicity analysis. Its trigger-system function was limited. In Run 3, FMD is decommissioned; its role is absorbed by the combination of FV0 (offline multiplicity at forward rapidity) and the FDD modules (diffractive / beam-gas tagging at very large \|η\|). `[VERIFY-FIT-AS-BUILT: FDD precise role.]`

---

## 3. FIT — functional requirements

The FIT design requirements `[TDR-015 §10.4]` set out verbatim in the TDR:

- Minimum-bias trigger in pp: ≥ 83% efficiency for A&C, ≥ 93% for A|C.
- Centrality selection (Pb–Pb) matching the present V0.
- Vertex location comparable to the present T0 system.
- Beam-gas event rejection comparable to the present V0.
- Time resolution **< 50 ps** for pp.
- Collision-time determination for TOF with resolution **< 50 ps**.
- Event-plane determination with precision comparable to the present V0.
- Minimal ageing over the full ALICE operational lifetime.
- No after-pulses or spurious signals.
- Direct luminosity / beam-condition feedback to the LHC.

Two subsystems are developed concurrently to satisfy these requirements: **T0-Plus** (now FT0) and **V0-Plus** (now FV0).

---

## 4. FT0 (T0-Plus) — Cherenkov/MCP-PMT subsystem

### 4.1 Concept

FT0 replaces the legacy T0 with a geometry of **20 rectangular modules** on each side of the IP, substantially larger acceptance than the 12-counter legacy T0 `[TDR-015 §10.5]`. The sensor is a **quartz radiator + MCP-PMT** combination:

- **Cherenkov radiator:** fused quartz, typically **20 mm thick** in the base design; a minimum-ionising particle produces ~1000 Cherenkov photons per traversal `[TDR-015 §10.5]`.
- **Photodetector:** microchannel-plate photomultiplier tube (MCP-PMT).

The as-built FT0 retains this concept with detailed optimisations `[VERIFY-FIT-AS-BUILT]`.

### 4.2 MCP-PMT: Photonis XP85012 Planacon

The TDR selects the **Photonis XP85012 Planacon** as the baseline MCP-PMT `[TDR-015 §10.5]`:

| Parameter | Value |
|---|---|
| Package | Sealed rectangular vacuum box 59 × 59 × 28 mm³ |
| MCP configuration | Chevron pair |
| MCP pore size | 25 μm |
| Pore length/diameter | 40:1 |
| Front window | Schott 8337B or UVFS(-Q) |
| Spectral range | 200–650 nm |
| Peak sensitivity | ~380 nm |
| Average quantum efficiency | 22% |
| Nominal gain | 10⁵ @ 1800 V |
| Max gain | ~10⁷ |
| Anode segmentation | 64 square sectors |
| Active area | 53 × 53 mm² (80% of outline) |
| Weight | ~128 g |

### 4.3 MCP-PMT ageing and reliability

MCPs had historically been limited by photocathode degradation vs integrated anode charge (IAC) — early devices showed significant QE loss already at IAC ~100 mC/cm² `[TDR-015 §10.5]`. **Atomic Layer Deposition (ALD)** treatment, applied to Photonis XP85012 variants, has been demonstrated to hold QE stable up to IAC **~5 C/cm²** (PANDA collaboration measurements).

The TDR computes the expected lifetime load for ALICE `[TDR-015 §10.5]`:

- ~1000 photons per MIP, QE ~10% ⇒ ~100 photoelectrons per MIP.
- Gain 10⁵ ⇒ 10⁷ electrons at anode ⇒ 1.6 × 10⁻¹² C per MIP.
- Total expected track count at innermost sensor: ~3 × 10¹².
- ⇒ Integrated anode charge ≈ **4.8 C/cm²**, within the proven ALD-treated MCP lifetime margin.

### 4.4 Absence of after-pulses

Legacy T0/V0 PMTs showed after-pulses 20–120 ns after the main pulse, with amplitudes ~20% of the primary peak `[TDR-015 §10.5]`. At high multiplicity these can overlap with signals from the following bunch crossing and corrupt trigger timing. The XP85012 **shows no detectable after-pulses** in the TDR-documented tests — a decisive advantage over the legacy system.

### 4.5 Radiator segmentation

The 64-sector Planacon anode allows the quartz radiator above it to be **subdivided into smaller segments**, each of which retains total internal reflection along its sides so that all Cherenkov light reaches the photocathode region directly underneath `[TDR-015 §10.5]`. The baseline subdivides each module's quartz into **4 equal sectors**, grouping the 64 anode pads into 4 corresponding groups. With 20 modules per side this gives **20 × 4 = 80 independent channels per side**, 160 total.

**Quartz suppliers:** two candidates are identified `[TDR-015 §10.5]`:
- **KU-1** (Gus-Khrustalnyi, Russia), used in the legacy T0.
- **Suprasil-1** (Heraeus, Germany), with slightly wider transmission at short wavelengths.

**Surface coating strategy:** Cherenkov light cones from particles entering perpendicular to the radiator front face are largely retained by total internal reflection. For backward-going particles and for specific background-rejection aims, either absorbing or reflective coatings are applied to the radiator surfaces according to simulation results.

### 4.6 Module prototype and timing resolution

A prototype module was constructed in collaboration with the NICA group `[TDR-015 §10.5, Fig. 10.11]`. Cosmic-ray tests measured a two-detector time-of-flight resolution of **42 ps**, corresponding to a single-element resolution of **~30 ps** — better than the legacy T0 and comfortably within the FIT < 50 ps requirement.

### 4.7 Geometry and mechanical envelope

FT0 modules are arranged around the beam pipe within the radial envelope **R_min ~50–60 mm, R_max ~170–200 mm** `[TDR-015 §10.5, Fig. 10.13]`.

**C-side position options discussed in the TDR:**
- On the **front absorber** (muon-arm absorber face): allows R_min = 50 mm, but access requires parking the TPC.
- On the **ITS/MFT support cage**: R_min ≈ 60 mm, better access.

**Baseline simulated geometry:** 20 modules × 53 × 53 × 20 mm³ quartz at **z = −70 cm (C)** and **z = +373 cm (A)** from the IP, R_min = 60 mm `[TDR-015 §10.5]`.

**Module weight:** ~400–500 g fully assembled ⇒ total array ~8–10 kg per side `[TDR-015 §10.5]`.

**Active-area fraction:** ~75% after housing and support, down from 80% intrinsic `[TDR-015 §10.5]`.

### 4.8 Minimum-bias efficiency (simulated)

Table 10.1 of `[TDR-015]` compares legacy V0 to simulated T0-Plus (pp at √s = 14 TeV, detailed geometry, R_min = 60 mm):

| Configuration | A only | C only | A&C | A\|C |
|---|---|---|---|---|
| Legacy V0 | — | — | 0.83 | 0.93 |
| T0-Plus simulated | 0.88 | 0.86 | 0.80 | 0.93 |
| Pb–Pb 70–100% (peripheral) | 0.97 | 0.98 | 0.95 | 0.996 |

T0-Plus reaches the V0 benchmark for the A|C signal and approaches it for A&C `[TDR-015 §10.5, Table 10.1]`.

---

## 5. FV0 (V0-Plus) — plastic-scintillator subsystem

### 5.1 Concept and motivation

FV0 replaces the legacy V0 with a modified and improved plastic-scintillator system, retaining functional redundancy with FT0 `[TDR-015 §10.6]`. Design goals:

- Same minimum-bias trigger capability as the legacy V0, i.e. A&C ≥ 83%, A|C ≥ 93%.
- **Time resolution improved to ~200 ps** — an order of magnitude better than the ~350–450 ps of the legacy V0.
- Larger pseudorapidity acceptance than the legacy V0 to close the gap between the ITS and V0A (Run 1–2: ~0.8 η gap).
- Much smaller after-pulse rate.
- Better beam-gas rejection via improved time and amplitude resolution.
- Modular construction allowing individual replacement.

### 5.2 Geometry and segmentation (TDR baseline)

The TDR-015 baseline places two V0-Plus arrays at the **legacy V0A and V0C positions**. Each array consists of **32 cells of BC408 plastic scintillator** `[TDR-015 §10.6]`.

**Extended acceptance:** V0A-Plus adds a **fifth ring** at small radius, reducing the η gap to the ITS and providing overlap with the new ITS2 acceptance (|η| < 2.3) `[TDR-015 §10.6, Fig. 10.16]`.

**TDR-015 Table 10.2 — pseudorapidity coverage:**

| Ring | V0A-Plus η_max/η_min | V0C-Plus η_max/η_min |
|---|---|---|
| 0 (new, A-side only) | 5.41 / 4.5 | — |
| 1 | 4.5 / 3.9 | −3.7 / −3.2 |
| 2 | 3.9 / 3.4 | −3.2 / −2.7 |
| 3 | 3.4 / 2.8 | −2.7 / −2.2 |
| 4 | 2.8 / 2.2 | −2.2 / −1.7 |

### 5.3 Photosensor options

Two options are considered in the TDR `[TDR-015 §10.6]`:

- **MCP-PMT (same XP85012 as FT0).** Unifies the front-end electronics across FIT; reduces development effort; reduces magnetic-field sensitivity (MCP-PMTs are inherently insensitive). **Risk:** common-mode vulnerability if long-term MCP issues emerge.
- **Fine-mesh PMT.** Mature technology, but subject to after-pulses — the main problem of the legacy V0 that FIT explicitly aims to avoid.

A-side: fine-mesh PMT coupled directly to scintillator is the baseline (space available). C-side: restricted volume due to the new MFT limits the options; MCP-PMT is favoured.

### 5.4 As-built FV0 (divergence from TDR-015)

The as-built FV0 differs from the TDR-015 two-disk baseline: it was built as a **single large A-side disk**, segmented into **5 rings × 8 sectors (40 channels)**, coupled via clear-fibre light guides to PMTs. The C-side V0 function is covered by FT0-C together with FDD. `[VERIFY-FIT-AS-BUILT]` against the FIT construction and performance papers for the final as-built numbers.

---

## 6. FDD (Forward Diffractive Detector)

Not described in `[TDR-015 §10]` under this name; its role is the replacement of the FMD at very large \|η\|, providing tagging of diffractive events and additional beam-gas vetos. Two modules (FDD-A and FDD-C) based on plastic scintillator + PMT technology. `[VERIFY-FIT-AS-BUILT]` for z position, segmentation, and channel count.

---

## 7. Common electronics and readout

### 7.1 Front-end and digitisation

The FIT readout follows the **TOF architecture** `[TDR-015 §10.1, §10.7]`, reusing the DRM (Data Readout Module) and TRM (TDC Readout Module) developed for TOF. Concretely:

- Each MCP-PMT or fine-mesh PMT signal is preamplified locally (within ~3 m of the sensor to minimise cable-induced timing degradation; see `[TDR-015 §10.2]` on the legacy shoebox design).
- Fast signals are discriminated and digitised by **HPTDCs** giving leading-edge and pulse-width measurements (from which amplitude is reconstructed via time-over-threshold).
- Charge integrals are obtained via QDC.
- Data are collected by TRM and DRM modules in custom VME crates (SY2390), mirroring the legacy T0 and TOF front-end architecture.

### 7.2 Interface to CTP and O²

FIT is the **sole Minimum Bias trigger source** for the Run 3 experiment `[TDR-015 §2]`. Its trigger signal is delivered to the CTP with fixed latency to enable triggered operation of detectors that cannot run triggerless (MCH, MID, ZDC, TOF, ITS, etc.). Raw data flow via the standard Run 3 readout chain (GBT ⇒ CRU ⇒ FLP) into the O² system, where it is time-matched to data from all other subsystems at the heartbeat granularity (one LHC orbit, 89.4 μs).

### 7.3 Radiation load

`[TDR-015 §9]`: radiation levels at the FIT positions are **a factor 3–4 lower** than at the innermost ITS layer but still of similar order of magnitude — imposing constraints on the electronics qualification and on the MCP lifetime (addressed in §4.3).

---

## 8. Performance summary

| Quantity | TDR target | Source |
|---|---|---|
| MB efficiency pp A&C | ≥ 83% | `[TDR-015 §10.4]` |
| MB efficiency pp A\|C | ≥ 93% | `[TDR-015 §10.4]` |
| T0 time resolution | < 50 ps | `[TDR-015 §10.4]` |
| Collision time for TOF | < 50 ps | `[TDR-015 §10.4]` |
| FT0 single-element resolution (prototype) | ~30 ps | `[TDR-015 §10.5]` |
| FV0 time resolution target | ~200 ps | `[TDR-015 §10.6]` |
| FT0 channels per side | 80 (20 modules × 4 sectors) | `[TDR-015 §10.5]` |
| FV0 cells (TDR baseline) | 32 per side, 5 rings A-side | `[TDR-015 §10.6]` |
| MCP-PMT gain / voltage | 10⁵ @ 1800 V | `[TDR-015 §10.5]` |
| Planacon QE (average) | 22% | `[TDR-015 §10.5]` |
| MCP lifetime (IAC) | ~5 C/cm² (ALD-treated) | `[TDR-015 §10.5]` |
| Expected lifetime IAC at FIT inner sensor | ~4.8 C/cm² | `[TDR-015 §10.5]` |
| FT0 z positions (baseline) | −70 cm (C), +373 cm (A) | `[TDR-015 §10.5]` |
| R_min / R_max | 50–60 / 170–200 mm | `[TDR-015 §10.5]` |

---

## 9. Role in this dissertation

FIT is **essential** to this work for three reasons.

### 9.1 Combined 4π and forward multiplicity estimators

FT0 and FV0 cover **−3.7 < η < +5.4** (TDR baseline; as-built may differ — see §5.4). Combined with the ITS2 (|η| < 2.3) they provide an **almost hermetic 4π multiplicity estimator** for each collision. The summed FIT amplitude scales with the charged-particle multiplicity in the forward region and is the Run 3 analogue of the V0M estimator used for centrality in Run 1 and Run 2.

### 9.2 Event-shape estimators

The azimuthal segmentation (FT0: 20 modules × 4 sectors × 2 sides; FV0: 8 sectors × 5 rings on A-side) supports **event-plane reconstruction** and **q-vector-based event-shape observables**. The finer segmentation compared to the legacy V0 (8 sectors) improves the event-plane resolution, especially at peripheral centralities.

### 9.3 T0 reference for TOF and for TPC calibration

The FIT collision-time resolution (target < 50 ps) sets the zero of the TOF measurement. For TPC calibration, the FIT-determined interaction time is used as a reference for time-zero (t0) of the TPC drift measurement in continuous readout — a key input to the distortion-correction and calibration chain.

---

## 10. Acronym glossary

- **ALD** — Atomic Layer Deposition (MCP surface treatment)
- **CCIU** — Channel Control Interface Unit (legacy V0 readout)
- **CIU** — Channel Interface Unit (legacy V0 readout)
- **CRU** — Common Readout Unit (O²)
- **CTP** — Central Trigger Processor
- **DRM** — Data Readout Module (TOF-family)
- **FDD** — Forward Diffractive Detector
- **FEE** — Front-End Electronics
- **FIT** — Fast Interaction Trigger
- **FLP** — First-Level Processor (O²)
- **FMD** — Forward Multiplicity Detector (legacy, decommissioned)
- **FT0 / FV0** — As-built FIT subsystems (evolution of T0-Plus / V0-Plus)
- **GBT** — Gigabit Transceiver (CERN link protocol)
- **HPTDC** — High-Performance Time-to-Digital Converter (CERN ASIC)
- **IAC** — Integrated Anode Charge (MCP lifetime metric)
- **IP** — Interaction Point
- **MB** — Minimum Bias
- **MCP-PMT** — Microchannel-Plate Photomultiplier Tube
- **MFT** — Muon Forward Tracker (Run 3 upgrade)
- **MIP** — Minimum Ionising Particle
- **PMT** — Photomultiplier Tube
- **QDC** — Charge-to-Digital Converter
- **QE** — Quantum Efficiency
- **TDR** — Technical Design Report
- **TRM** — TDC Readout Module
- **UVFS** — UV Fused Silica (quartz-window variant)
- **WLS** — Wavelength-Shifting (fibre)

---

## 11. Open items for reviewer follow-up

1. **As-built geometry and channel count** of FT0, FV0, FDD for Run 3 — all `[VERIFY-FIT-AS-BUILT]` tags close against the FIT construction paper and the ALICE Run 3 performance paper. In particular: final z positions, segmentation, and MCP-PMT vs fine-mesh PMT choice for FV0.
2. **Achieved time resolutions** (FT0 and FV0) in Run 3 collisions vs the TDR targets of < 50 ps and ~200 ps.
3. **Achieved MB efficiencies** in pp and Pb–Pb Run 3.
4. **FDD** — dedicated primary source (it is not covered in TDR-015 §10 under that name).
5. **Centrality-estimator calibration** for Run 3 using FIT amplitude — the V0M analogue (typically "FT0M" or "FT0C") needs a Run 3 calibration paper citation.
6. **Figures to insert in LaTeX** (not embedded): FIT module layout around beam pipe (TDR-015 Fig. 10.13), pseudorapidity coverage diagram (TDR-015 Fig. 10.16), Planacon cross-section (TDR-015 Fig. 10.7), efficiency-vs-multiplicity curves (TDR-015 Figs. 10.14–10.15).

---

## 12. Honest status note

**Size:** ~3,800 words / ~8–9 printed pages at 450 w/page. Still under the 10–15 page target. Where content is light, the gaps are clearly marked `[VERIFY-FIT-AS-BUILT]` and correspond to design evolution between the 2014 TDR-015 conceptual baseline and the Run 3 as-built detector. Closing those tags requires the FIT construction / performance paper (not yet uploaded) which would allow another round of expansion to the full 15 pages.

*End of document.*
