# ALICE Forward Trigger & Centrality Detectors (T0, V0, ZDC) — Source of Truth v0.1

```
PDF read: yes, 2008_JINST_3_S08002.pdf §5.1 (ZDC), §5.4 (V0), §5.5 (T0)
          — fully extracted and verified against the relevant line ranges
          of the pdftotext extract
          no,  ALICE Forward Detectors TDR (CERN-LHCC-2004-025 / ALICE-TDR-011)
               — not in uploads; would deepen numerical detail but is not
               required for v0.1 drafting against JINST 2008.
Coder:    Reviewer Claude1 acting as coder (at architect's direct instruction)
Status:   Draft for panel review. NOT frozen.
```

**Scope:** Run 1 / Run 2 configuration of the three ALICE forward systems that (together with FMD) are replaced in Run 3 by FIT and retained ZDC. This document is the companion to `FIT_source_of_truth.md` — FIT's heritage lives here.

**Primary source:**
- `[JINST2008 §X]` — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002, Chapter 5 (Forward detectors). All numerical claims below are tagged to the specific subsection.

**Secondary (not yet consulted):**
- Forward Detectors TDR (ALICE-TDR-011, 2004) — recommended v0.2 deepening.
- ZDC performance updates (Arnaldi et al.) — referenced in JINST2008 Ref. [170].

**`[VERIFY]` tag** = claim not yet source-verified or drawn from ALICE performance papers.

---

## BibTeX (add to project `bibliography.bib`)

```bibtex
@article{JINST2008,
  author  = "{ALICE Collaboration}",
  title   = "{The ALICE experiment at the CERN LHC}",
  journal = "JINST", volume = "3", pages = "S08002", year = "2008",
  doi     = "10.1088/1748-0221/3/08/S08002"
}
```

Already present in the shared bibliography from the TPC/ITS/TRD/FIT passes — no new entries required for this v0.1.

---

## 1. Role and scope

The three Run 1/2 forward detectors discussed here serve distinct, complementary functions:

| Detector | Primary role | Key observable |
|---|---|---|
| **T0** | Start-time (t₀) reference for TOF; L0 vertex trigger; minimum-bias / multiplicity trigger | Cherenkov timing, ~40 ps per PMT |
| **V0** | Minimum-bias trigger; centrality estimator in Pb–Pb; beam-gas rejection; luminosity | Integrated scintillator amplitude; A–C coincidence timing |
| **ZDC** | Centrality via spectator nucleons; L1 centrality trigger; reaction-plane estimate | Spectator-nucleon energy at 0° |

T0 and V0 are **replaced in Run 3 by the FIT system** (FT0 + FV0 + FDD); see `FIT_source_of_truth.md`. ZDC is **retained** (in upgraded readout form) through Run 3 and beyond.

---

## 2. V0 detector

### 2.1 Design considerations [JINST2008 §5.4.1]

The V0 consists of two arrays of plastic-scintillator counters, **V0A** and **V0C**, on opposite sides of the ALICE interaction point. Functions:

1. **Minimum-bias trigger** for the central barrel in pp and A–A collisions.
2. **Centrality indicator** via the monotone relation between the V0 multiplicity and the primary emitted multiplicity — enabling rough multiplicity-based central (CT2), semi-central (CT1), and minimum-bias triggers.
3. **Beam-gas veto** via A–C timing coincidence (AND mode). A *p*-gas trigger with V0C alone (OR mode of MB) is used to reject muon-arm background.
4. **Luminosity measurement** in pp collisions to **~10 % precision**.

Default operation: **AND (A&C) mode**. pp minimum-bias detection efficiency: **~75 %** for at least one charged particle in both sides (bare); **~84 %** including secondary-interaction environmental effects.

### 2.2 Geometry and segmentation [JINST2008 §5.4.2]

| Parameter | V0A | V0C |
|---|---|---|
| z from IP | **+340 cm** | **−90 cm** (mounted on front face of hadron absorber) |
| Pseudorapidity coverage | **2.8 < η < 5.1** | **−3.7 < η < −1.7** |
| Segmentation | 32 counters = 4 rings × 8 sectors (45°) | 48 elementary counters (2 inner rings × 8 + 2 outer rings × 16) paired 2-by-2 → 32 effective channels |
| Scintillator material | BC-404, **2.5 cm thick** | BC-404, **2.0 cm thick** |
| Light collection | WLS (BCF-9929A, Ø 1 mm, 1 cm pitch), "megatile" — embedded in transverse faces | WLS in groups of 9 glued along radial edges |

**Ring η boundaries (per `[JINST2008 Table 5.4]`):**

| Ring | V0A η_max / η_min | V0C η_max / η_min (signed) |
|---|---|---|
| 0 | 5.1 / 4.5 | −3.7 / −3.2 |
| 1 | 4.5 / 3.9 | −3.2 / −2.7 |
| 2 | 3.9 / 3.4 | −2.7 / −2.2 |
| 3 | 3.4 / 2.8 | −2.2 / −1.7 |

### 2.3 Photosensors and readout [JINST2008 §5.4.2–§5.4.3]

- **PMTs:** Hamamatsu **H6153-70MOD** — 32 per array × 2 arrays = 64 PMTs total.
- **Mounting:** V0A PMTs in groups of 4 directly on the disk holder; V0C in groups of 8 on the absorber.
- **Time resolution:** **~450 ps (V0A), ~350 ps (V0C)** — sufficient for trigger-timing but coarse compared to T0. Cited in [TDR-015 §10.3] as the legacy performance driving the FIT replacement.

### 2.4 Radiation concerns

V0 is close to the IP at small angles; radiation-induced degradation of scintillator/WLS light yield is a known concern [JINST2008 Ref. 189]. Spare inner V0C elements are foreseen for in-situ replacement if large irradiation effects require it.

---

## 3. T0 detector

### 3.1 Design objectives [JINST2008 §5.5.1]

The T0 detector was designed for four functions, listed in order of priority:

1. **Generate a start time (t₀) for the TOF detector**, independent of the vertex position, with target RMS precision **~50 ps**.
2. **Measure the z-position of the vertex** online with precision **±1.5 cm** and generate an **L0 vertex trigger** when the position lies within preset limits — rejecting beam-gas interactions.
3. **Generate an early "wake-up" signal to the TRD**, prior to L0.
4. **Redundancy to V0** for minimum-bias and multiplicity (CT1/CT2) triggers.

Because T0 generates the earliest (L0) trigger signals, they must be produced **online** without any possibility of offline correction. Dead time is required to be shorter than the 25 ns pp bunch-crossing period.

### 3.2 Detector layout [JINST2008 §5.5.2, Table 5.5]

| Parameter | T0-A | T0-C |
|---|---|---|
| z-position | **+375 cm** | **−72.7 cm** |
| r-position | 6.5 cm | 6.5 cm |
| Number of Cherenkov counters | **12** | **12** |
| Pseudorapidity coverage | **+4.61 / +4.92** | **−3.28 / −2.97** |
| Active area | 37.7 cm² | 37.7 cm² |
| Single-module time resolution | **~37 ps** | 37 ps |
| Online vertex resolution | 1.5 cm | 1.5 cm |
| pp efficiency (single array, with beam pipe) | **50 %** | 59 % |
| pp efficiency, A∧C coincidence | **40 %** | — |

Each Cherenkov counter is a **quartz radiator + fine-mesh PMT** assembly.

### 3.3 Fast electronics and signal generation [JINST2008 §5.5.3]

- **T0 timing signal** generated by an **analogue mean timer**: output position = (T0-A + T0-C)/2 + T_delay.
- **Online vertex signal** = T0-A − T0-C, digitised and fed to a discriminator with programmable upper/lower limits → **T0_vertex trigger**.
- **Multiplicity triggers (T0_semi-central, T0_central):** two discriminator levels on the linear sum of all array amplitudes.
- **Constant-fraction discriminator:** Canberra CFD model 454. Input dynamic range 50–3000 mV (≈ 1–60 MIP). Time-walk **120 ps** — corrected offline for non-trigger signals.
- **Mean-timer stability:** ±10 ps online stability verified with laser and CERN PS beams [JINST2008 §5.5.3].
- **All fast-electronics modules:** dead time < 25 ns.

### 3.4 Readout [JINST2008 §5.5.3]

Digitisation chain is **common with the TOF detector**:

| Module | Function |
|---|---|
| **CPDM** | Clock and Pulse Distribution Module — distributes the 40 MHz low-jitter LHC clock to TRM, DRM, and main T0 electronics. |
| **TRM** | TDC Readout Module — houses 30 **HPTDC** chips per card. T0 uses HPTDC in **very-high-resolution mode, 24.4 ps bin width**. |
| **DRM** | Data Readout Module — interface to the ALICE DAQ via DDL optical link; receives trigger information from CTP via TTCrx; provides slow-control. |

**Channels recorded:** time and amplitude of each of the 24 PMTs, plus the derived signals (interaction time, vertex, T0-C/T0-A, linear amplitude sum, two multiplicity signals).

---

## 4. ZDC — Zero Degree Calorimeter

### 4.1 Role [JINST2008 §5.1.1]

The ZDC measures the energy carried at 0° by spectator (non-interacting) nucleons in A–A collisions, providing the most direct experimental handle on **collision geometry**:

&nbsp;&nbsp;&nbsp;&nbsp;E_ZDC (TeV) = 2.76 × N_spectators
&nbsp;&nbsp;&nbsp;&nbsp;N_participants = A − N_spectators

where 2.76 TeV/nucleon is the Pb-beam energy at nominal LHC operation. (The simple expression breaks down in practice because not all spectators are collected — see §4.3.)

Functions:
1. **Centrality estimator** for Pb–Pb (and later Xe–Xe, p–Pb).
2. **Level-1 centrality trigger** input.
3. **Reaction-plane estimate** (position-sensitive detector).

### 4.2 Layout [JINST2008 §5.1.2]

Two hadronic ZDC sets on either side of the IP at **±116 m**. Each set comprises two sampling calorimeters:

- **ZN** — spectator-neutron calorimeter, placed **between** the outgoing beam pipes at 0° relative to the LHC axis.
- **ZP** — spectator-proton calorimeter, placed **externally** to the outgoing beam pipe on the side where positive particles are magnetically deflected (the LHC beam-line dipoles spatially separate spectator protons from neutrons).

In addition, two **ZEM** (zero-degree electromagnetic) calorimeters sit **~7 m** from the IP on both sides of the beam pipe, opposite the muon arm. ZEM helps disambiguate peripheral vs very-peripheral events, where ZN/ZP spectator signal alone is degenerate.

All four hadronic detectors (ZN+ZP on both A and C sides) are installed on **lifting platforms** — lowered out of the horizontal beam plane when not in use, to avoid the highest-radiation position.

### 4.3 Hadronic calorimeters — working principle [JINST2008 §5.1.2.1]

The hadronic ZDCs are **quartz-fibre sampling calorimeters**. Shower particles produce **Cherenkov light** in the quartz fibres (active material) embedded in a dense absorber (passive material), and the Cherenkov light is channelled to PMTs at the calorimeter rear.

Why quartz-Cherenkov rather than scintillator:
- **Radiation hardness** — quartz survives the extreme forward radiation environment at 116 m.
- **Fast response** — Cherenkov light emission has no scintillation decay constant; signals are nanosecond-scale.
- **Directional sensitivity** — only shower particles above the Cherenkov threshold and within the cone contribute, suppressing background.

Design constraint: the ZN transverse size is **≤ 7 cm** (limited by the space between the outgoing beam pipes), requiring a very dense absorber to contain showers.

### 4.4 ZN / ZP / ZEM parameters [JINST2008 Table 5.1]

| Parameter | ZN | ZP | ZEM |
|---|---|---|---|
| Dimensions (cm³) | **7.04 × 7.04 × 100** | 12 × 22.4 × 150 | 7 × 7 × 20.4 |
| Absorber | **Tungsten alloy** | Brass | Lead |
| Density ρ (g/cm³) | **17.6** | 8.5 | 11.3 |
| Fibre core diameter (µm) | 365 | 550 | 550 |
| Fibre spacing (mm) | 1.6 | 4 | — |
| Filling ratio | 1/22 | 1/65 | — |
| Length in X₀ | 251 | 100 | — |
| Length in λ_I | **8.7** | 8.2 | — |
| Number of PMTs | 5 | 5 | — |

**Fibre spacing < X₀ of absorber** by design — this prevents electron absorption in the passive material that would cause non-uniformity.

**PMT segmentation:** 5 PMTs per hadronic calorimeter enable position reconstruction of the shower centroid → reaction-plane estimation and event-by-event centrality quality.

### 4.5 Spectator physics and centrality

At the LHC:
- **Central collisions (small impact parameter):** many participants, few spectators → **low** ZDC energy.
- **Peripheral collisions (large impact parameter):** few participants, many spectators → **high** ZDC energy.
- **Very peripheral:** spectator nucleons can form fragments that are deflected out of the ZDC acceptance → ZDC response **saturates and then decreases** with impact parameter. This is the reason ZEM is needed: ZEM energy grows monotonically with multiplicity and resolves the ZDC ambiguity in the most-peripheral regime.

### 4.6 Calibration and monitoring

Per [JINST2008 §5.1.4] `[VERIFY: specific calibration procedure]`:
- Pedestal monitoring via dedicated calibration triggers.
- PMT-gain stability via LED / laser pulses.
- **Nucleon-scale calibration** from the single-spectator-neutron peak observed in peripheral collisions (a clean 2.76 TeV / nucleon signature).

---

## 5. Role in this dissertation

### 5.1 V0 — primary Run 1/2 centrality estimator

V0 is the reference for all Run 1/2 centrality analyses. The summed **V0M = V0A + V0C amplitude** is fitted by a Glauber model and sliced into centrality percentiles. This dissertation inherits this definition for Run 1/2 data and transitions to **FT0M / FV0 amplitude** for Run 3 — the continuity of the centrality definition across runs is a key cross-calibration exercise.

### 5.2 V0 — event-plane estimator

V0 8-sector segmentation per side supports second-harmonic event-plane reconstruction. Resolution is modest (coarse segmentation; low η-coverage) — **used as cross-check**, with the TPC providing the higher-precision reference.

### 5.3 T0 — t₀ reference for TOF and timing consistency

For all analyses using TOF PID, the T0-derived start time enters the measured time-of-flight. T0's ~50 ps online and ~37 ps/module resolution directly affects the achievable TOF-based π/K/p separation. In Run 3 this function transfers to **FT0**.

### 5.4 ZDC — independent centrality cross-check

For Pb–Pb analyses, ZDC centrality (from spectator-nucleon energy plus ZEM disambiguation) is used as an **independent centrality estimator** alongside V0M. Agreement between the two within ~1 centrality class is a standard ALICE quality check.

### 5.5 Cross-detector coupling

- **T0 → TRD wake-up** (Run 1/2). Removed in Run 3 (continuous readout).
- **V0 → CTP** (MB, multiplicity triggers). Replaced by FIT → CTP in Run 3.
- **T0 → TOF** (start time). Replaced by FT0 → TOF in Run 3.
- **ZDC → CTP** (L1 centrality trigger). Retained in Run 3.

---

## 6. Performance summary

| Quantity | Value | Source |
|---|---|---|
| V0A z | +340 cm | [JINST2008 §5.4.2] |
| V0C z | −90 cm | [JINST2008 §5.4.2] |
| V0A η coverage | 2.8 < η < 5.1 | [JINST2008 §5.4.2] |
| V0C η coverage | −3.7 < η < −1.7 | [JINST2008 §5.4.2] |
| V0 channels | 32 per array (after pairing) | [JINST2008 §5.4.2] |
| V0A time resolution | ~450 ps | [VERIFY: ALICE performance paper]; quoted in [TDR-015 §10.3] |
| V0C time resolution | ~350 ps | [VERIFY]; [TDR-015 §10.3] |
| V0 pp MB efficiency (A&C) | ~84% (with secondaries) | [JINST2008 §5.4.1] |
| T0-A z | +375 cm | [JINST2008 Table 5.5] |
| T0-C z | −72.7 cm | [JINST2008 Table 5.5] |
| T0 counters per array | 12 | [JINST2008 Table 5.5] |
| T0-A η | +4.61 / +4.92 | [JINST2008 Table 5.5] |
| T0-C η | −3.28 / −2.97 | [JINST2008 Table 5.5] |
| T0 single-PMT resolution | ~37 ps | [JINST2008 Table 5.5] |
| T0 vertex resolution | 1.5 cm | [JINST2008 Table 5.5] |
| T0 online t₀ precision (target) | ~50 ps | [JINST2008 §5.5.1] |
| T0 HPTDC bin width | 24.4 ps | [JINST2008 §5.5.3] |
| T0 CFD time-walk | 120 ps (offline-corrected) | [JINST2008 §5.5.3] |
| ZDC position | ±116 m from IP | [JINST2008 §5.1.2] |
| ZEM position | ~7 m from IP | [JINST2008 §5.1.2] |
| ZN absorber | W-alloy, ρ = 17.6 g/cm³ | [JINST2008 Table 5.1] |
| ZN dimensions | 7.04 × 7.04 × 100 cm³ | [JINST2008 Table 5.1] |
| ZN length | 8.7 λ_I, 251 X₀ | [JINST2008 Table 5.1] |
| ZP absorber | Brass, ρ = 8.5 g/cm³ | [JINST2008 Table 5.1] |
| ZEM absorber | Lead, ρ = 11.3 g/cm³ | [JINST2008 Table 5.1] |
| PMTs per hadronic ZDC | 5 | [JINST2008 Table 5.1] |

---

## 7. Operational evolution

| Run | V0 | T0 | ZDC | FMD |
|---|---|---|---|---|
| Run 1 | In | In | In | In |
| Run 2 | In (V0A/V0C refurbished) `[VERIFY]` | In | In | In |
| Run 3 | **Replaced by FV0** | **Replaced by FT0** | **Retained** (new electronics) | **Replaced by FDD** |

See `FIT_source_of_truth.md` for the Run 3 successor system.

---

## 8. Glossary

- **V0A / V0C** — Forward scintillator arrays on A-side (opposite muon arm) / C-side (muon-arm side)
- **T0-A / T0-C** — Forward Cherenkov timing arrays on the two sides
- **ZDC** — Zero Degree Calorimeter (hadronic)
- **ZN / ZP** — Zero-degree Neutron / Proton calorimeters
- **ZEM** — Zero-degree ElectroMagnetic calorimeter
- **BC-404 / BCF-9929A** — Bicron/Saint-Gobain plastic scintillator and WLS fibre types
- **CFD** — Constant-Fraction Discriminator
- **CPDM** — Clock & Pulse Distribution Module (TOF/T0 electronics)
- **TRM** — TDC Readout Module (TOF/T0)
- **DRM** — Data Readout Module (TOF/T0)
- **HPTDC** — High-Performance Time-to-Digital Converter
- **DDL** — ALICE Detector Data Link (optical)
- **TTCrx** — Trigger-Timing-Control receiver chip
- **MIP** — Minimum-Ionising Particle
- **λ_I / X₀** — Nuclear interaction length / radiation length

---

## 9. Open items for v0.2

1. **ALICE Forward Detectors TDR** (ALICE-TDR-011, 2004) — upload would allow deeper treatment of V0 light-collection geometry, T0 fast-electronics detail, ZDC calibration procedure, and ZEM segmentation.
2. **ZDC performance paper** (Arnaldi et al., cited as [JINST2008 Ref. 170]) — for measured energy resolution, event-plane resolution, and Run-1/2 centrality calibration curves.
3. **V0 time-resolution numbers** in §2.3 and §6: sourced to [TDR-015 §10.3] here but should be cross-verified against an ALICE V0 performance note.
4. **Run 3 ZDC electronics upgrade** — if ZDC continuous-readout details are in scope, the RTS TDR (TDR-015) Chapter 11 covers this; a v0.2 could add a short §7.X on the ZDC continuous-readout transition.
5. **V0M Glauber-fit parameters** and **centrality class definitions** — belong in the analysis chapter, not here, but cross-reference when the dissertation's centrality framework is written.

---

*End of v0.1. Spans roughly 8 printed pages of markdown. All numerical content (Tables 5.1, 5.4, 5.5 + prose numbers) verified against the extracted text of [JINST2008] Chapter 5 this pass.*
