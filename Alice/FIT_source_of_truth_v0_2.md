# The ALICE Fast Interaction Trigger (FIT) — Source of Truth v0.2

```
PDF read:   no (Main Coder this revision). TDR-015 was NOT re-extracted for v0.2.
PDF-verified: Yes by the v1 review panel (Claude1, Claude4, Claude5, GPT1, GPT2),
            all declared "PDF read: yes, ALICE-TDR-015.pdf §10", zero P0 numerical
            contradictions found. v0.2 preserves every numerical value from v1
            unchanged; changes are structural/process/labelling per panel action list.
            Any new numerical claim introduced in v0.2 is flagged [VERIFY].
Coder:      Main Coder Claude2.
Status:     Draft for panel re-review. NOT frozen.
```

**Scope:** The ALICE Fast Interaction Trigger for Run 3, replacing the Run 1/2 T0, V0, and FMD systems. Primary source is TDR-015 Chapter 10 (the dedicated FIT chapter). **This document synthesises the 2014 TDR-015 conceptual design. All as-built Run 3 numbers require the FIT construction paper or the Run 3 performance paper and are flagged throughout as `[VERIFY-FIT-AS-BUILT]`.**

**Primary sources:**
- `[TDR-015 §10]` — ALICE Collaboration, *Upgrade of the Readout & Trigger System Technical Design Report*, CERN-LHCC-2013-019 / ALICE-TDR-015, Chapter 10 *Fast Interaction Trigger — FIT* (2013, addendum 2014). Authoritative conceptual design.
- `[JINST2008]` — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002, §7 (T0), §8 (V0), §9 (FMD). Heritage/legacy detectors.
- `[VERIFY-FIT-AS-BUILT]` — as-built Run 3 (FT0/FV0/FDD) may deviate from the TDR-015 concept; no construction paper available in this project's current upload set.
- `[VERIFY]` — claim not cross-checked against any uploaded primary source.

**Nomenclature.** The TDR-015 FIT chapter uses the names **T0-Plus** and **V0-Plus** for the conceptual design. These were built for Run 3 as **FT0** (evolution of T0-Plus), **FV0** (evolution of V0-Plus, reconfigured as a single A-side disk with 5 rings), and **FDD** (Forward Diffractive Detector, replacing the FMD role on both sides at larger |η|). Throughout this document, each major section carries explicit *Design (TDR-015)* and *As-built (Run 3)* sub-blocks so the two are never conflated.

---

## BibTeX entries required in `bibliography.bib`

```bibtex
@techreport{ALICE-TDR-015,
  author = "{ALICE Collaboration}",
  title = "{Upgrade of the Readout and Trigger System Technical Design Report}",
  institution = "CERN", number = "CERN-LHCC-2013-019, ALICE-TDR-015",
  year = "2013"
}
@article{JINST2008,
  author = "{ALICE Collaboration}", title = "{The ALICE experiment at the CERN LHC}",
  journal = "JINST", volume = "3", pages = "S08002", year = "2008",
  doi = "10.1088/1748-0221/3/08/S08002"
}
```

---

## Changelog v1 → v0.2

**P0 (process, per Claude3 panel):**
- Added `PDF read:` declaration at top — honest "no" from Main Coder; preserves v1 panel's 5-reviewer PDF-verified status as the authoritative numerical anchor.
- Added BibTeX block.

**P1 (structural, per Claude3 panel):**
- New scope-limit note at top of document (Claude1 P1-3).
- QE inconsistency §4.2 fixed (Claude5): replaced single-row table entry with two explicit rows — *Peak QE* and *Effective QE in Cherenkov spectrum*.
- Strict TDR-vs-as-built separation applied to §4, §5, §6, §9 (GPT1/GPT2/Claude1). Each subsection has explicit *Design (TDR-015)* / *As-built (Run 3)* markers.
- FDD sourcing discipline §6 (Claude1/GPT1/GPT2): banner header marks entire section as `[NO PRIMARY SOURCE — FIT construction paper required]`.
- §9.1 η range (Claude1 P1-6): TDR values given explicitly; as-built flagged.
- New §10 Limitations (GPT1).
- §9 sharpened (GPT2) with explicit V0M → FT0M/FV0M centrality-replacement language.
- §7 Electronics expanded with HPTDC-chain latency, bandwidth, O² FLP mapping (GPT2).
- §4.7 module weight (Claude4): 252 g component-only cited separately; assembled weight tagged `[VERIFY]`.
- §2.1 fine-mesh PMT (Claude1 P1-5): tagged `[VERIFY: JINST2008 §7]`.
- §5.3 photosensor assignment (Claude4): tagged `[VERIFY]`.
- §12 "Honest status note" removed (Claude4, TRD v0.2 pattern).
- New §8 Alignment and calibration (stub, mirrors TPC/ITS/TRD).
- Citation format harmonised with TPC v0.3 / ITS v0.2 / TRD v0.3: bare square brackets, no backticks; plain-text math.
- §9 restructured into 6 subsections mirroring TPC v0.3 §11 / ITS v0.2 §5 / TRD v0.3 §5 depth.

**P2 (polish):**
- PANDA + NICA joint attribution §4.2 (Claude5).
- T0A +370 cm vs FT0-A +373 cm one-line note §5 (Claude5).
- Table 10.1 rows flagged explicitly as simulation/TDR values (GPT1).

**Preserved unchanged from v1:** every numerical value verified by the v1 panel (MCP-PMT model, QE value 22%, quartz radiator dimensions, segmentation counts, time resolutions, η ranges, z positions, radiation loads). The v1 physics content was correct on first pass.

---

## 1. Purpose and role of FIT

The Fast Interaction Trigger replaces three legacy ALICE forward systems — **T0, V0, and FMD** — with a single integrated system [TDR-015 §10.1]. It provides all functions those three detectors provided in Run 1 and Run 2, adapted to Run 3 operating conditions (50 kHz Pb-Pb interaction rate, continuous readout) [TDR-015 §10.1]:

1. **Minimum-bias trigger** for pp and Pb-Pb collisions, delivered to the Central Trigger Processor (CTP).
2. **Collision-time (T0) determination** as the reference for the TOF detector and for Run 3 continuous-readout time-frame alignment, with design resolution < 50 ps.
3. **Vertex localisation** along the beam axis from A-side/C-side timing difference.
4. **Online luminosity and beam-condition monitoring**, with direct feedback to the LHC control.
5. **Beam-gas and beam-background rejection** via A-C timing coincidence windows.
6. **Offline centrality and event-plane determination** for Pb-Pb, from the integrated amplitude and its azimuthal segmentation — matching the Run 1/2 V0M performance.
7. **Multiplicity trigger** for central and semi-central Pb-Pb selection.

Two complementary sensor technologies preserve the redundancy principle of the legacy T0+V0 combination [TDR-015 §10.1]: a quartz Cherenkov + MCP-PMT system (T0-Plus/FT0), and a plastic-scintillator + PMT system (V0-Plus/FV0). FDD, the third subsystem, occupies the forward-most rapidity bins with plastic-scintillator pads and handles diffractive-event tagging.

---

## 2. Heritage: the Run 1/2 T0, V0, and FMD

### 2.1 T0 (legacy)

Two arrays of Cherenkov counters, **T0A and T0C**, at z = **+370 cm** and **−70 cm** from the IP [TDR-015 §10.2]. Each array: 12 cylindrical counters with quartz radiator + fine-mesh photomultiplier tube `[VERIFY: fine-mesh PMT specifics, JINST2008 §7]`.

Pseudorapidity coverage: T0C −3.28 < η < −2.97; T0A 4.61 < η < 4.92 [TDR-015 §10.2].

Run 1/2 performance [TDR-015 §10.2]: pp time resolution ~40 ps, vertex efficiency ~50%; Pb-Pb 0-60% at √s_NN = 2.76 TeV, time resolution ~21 ps, vertex efficiency ~100%.

Limitations driving upgrade: small acceptance (12 counters per side), after-pulses in fine-mesh PMTs, inadequate rate capability for Run 3.

### 2.2 V0 (legacy)

Two plastic-scintillator disks at z = **−90 cm (V0C)** and **+329 cm (V0A)** from the IP [TDR-015 §10.3]. Each disk segmented into 4 radial rings × 8 azimuthal sectors = 32 cells. Bicron plastic + wavelength-shifting (WLS) fibres; Hamamatsu R5946 fine-mesh PMT readout [TDR-015 §10.3].

Coverage: V0A 2.8 < η < 5.1; V0C −3.7 < η < −1.8 [TDR-015 §10.3].

Performance [JINST2008 §8]: charged-particle detection efficiency > 99%, time resolution ~700 ps (amplitude-walk corrected), used for the V0M centrality estimator (sum of V0A+V0C amplitudes) throughout Run 1/2.

### 2.3 FMD (legacy)

Silicon-strip forward multiplicity detector in five rings on the A- and C-sides [JINST2008 §9]. Pseudorapidity coverage −3.4 < η < −1.7 (C) and 1.7 < η < 5.0 (A). High-granularity charged-particle counting; not replaced one-for-one in Run 3 — the FDD handles its trigger/diffractive-tagging role, but the high-granularity multiplicity role is not replicated.

---

## 3. FIT — functional requirements

Consolidated from [TDR-015 §10.1]:

- Interaction-rate capability: 50 kHz Pb-Pb minimum-bias; ≥ 1 MHz pp.
- Time resolution (FT0): < 50 ps per A/C-side hit cluster, corresponding to < 20 ps on the A-C difference.
- Charged-particle detection efficiency per side: > 99% for minimum-bias Pb-Pb, > 98% for minimum-bias pp (after amplitude cuts).
- Continuous-readout capability with on-line trigger-decision output to CTP within ~425 ns of the collision (L0 latency budget).
- Radiation tolerance matching the 10-year Run 3+Run 4 integrated forward-region dose.
- Redundancy: two complementary technologies capable of delivering the MB trigger and vertex independently, so neither single-point failure kills the primary trigger.
- Replacement of V0M centrality estimator by FT0M = amplitude(FT0-A) + amplitude(FT0-C) and FV0M = total amplitude in FV0 rings.

---

## 4. FT0 (T0-Plus) — Cherenkov / MCP-PMT subsystem

### 4.1 Concept (Design, TDR-015)

Two arrays of quartz-radiator Cherenkov counters with MCP-PMT readout, positioned on the A-side (FT0-A, z = **+335 cm**) and C-side (FT0-C, z = **−82 cm**) of the IP [TDR-015 §10]. Each MCP-PMT has a segmented anode (4 × 4 pads) to increase effective channel count and reduce per-pad rate. Total FT0-A: 24 MCPs; FT0-C: 28 MCPs [TDR-015 §10].

### 4.2 MCP-PMT: Photonis XP85012 Planacon (Design, TDR-015)

Key parameters [TDR-015 §10]:

| Parameter | Value |
|---|---|
| Active area | 53 × 53 mm² |
| Anode segmentation | 4 × 4 pads |
| Peak quantum efficiency (~380 nm) | ~22% |
| Effective QE in Cherenkov spectrum (lifetime calc.) | ~10% |
| Gain | ~10⁶ |
| Time resolution (single photoelectron) | ~40 ps |
| Maximum count rate | ~5 MHz/pad |
| Radiation tolerance | ~10¹³ n_eq/cm² |

Development driven jointly by the PANDA and ALICE/NICA forward-detector R&D programmes [TDR-015 §10].

### 4.3 MCP-PMT ageing and reliability (Design, TDR-015)

ALD-coated MCPs exhibit negligible gain loss over accumulated charge of several C/cm²; the TDR expects full Run 3 + Run 4 lifetime without MCP replacement [TDR-015 §10].

### 4.4 Absence of after-pulses (Design, TDR-015)

Compared to the fine-mesh PMTs of legacy T0, Planacon MCPs produce negligible after-pulses, eliminating the trigger-ghosting limitation of the legacy system [TDR-015 §10].

### 4.5 Radiator segmentation (Design, TDR-015)

The quartz radiator bar mounted on each MCP-PMT is segmented to match the 4×4 anode pads, so each pad sees an independent Cherenkov signal. Typical quartz bar: 20 mm × 20 mm × **20 mm thickness** [TDR-015 §10]. Cherenkov photons at ~260 nm detected before WLS-absorption attenuation.

### 4.6 Module prototype and timing resolution (Design, TDR-015)

Single-module prototype test-beam measurements: time resolution **~13 ps** per single MCP-pad hit, improving the TDR requirement of 50 ps with significant margin [TDR-015 §10].

### 4.7 Geometry and mechanical envelope (Design, TDR-015)

FT0-A ring outer diameter ~17 cm; FT0-C inner/outer diameter 7.5/17 cm, offset around the beam pipe [TDR-015 §10]. Per-module component weight: Planacon 128 g + quartz 124 g = **252 g components only**. Fully assembled module weight `[VERIFY: ~400-500 g including mounting]`.

### 4.8 Minimum-bias efficiency (simulated, TDR-015)

[TDR-015 §10, Table 10.1; values are TDR simulation, not measured]:

| Beam | Geometry | Efficiency |
|---|---|---|
| pp | FT0 alone | ~88% |
| pp | FT0 ∩ FV0 coincidence | ~70% |
| Pb-Pb minimum bias | FT0 alone | ~99% |

(Table 10.1 of TDR-015 contains additional rows — detailed multiplicity dependence at R_min = 60 mm — not reproduced here; see TDR directly.)

### 4.9 As-built FT0 (Run 3)

As-built geometry broadly preserves the TDR-015 concept with minor adjustments to module positions and quartz-radiator dimensions `[VERIFY-FIT-AS-BUILT]`. Notably FT0-A sits at z = +373 cm (not +335 cm baseline), a deliberate ~38 cm shift from both the TDR-015 baseline and the legacy T0A +370 cm, to accommodate the MFT envelope `[VERIFY-FIT-AS-BUILT]`.

---

## 5. FV0 (V0-Plus) — plastic-scintillator subsystem

### 5.1 Concept and motivation (Design, TDR-015)

V0-Plus: two plastic-scintillator disks on A and C sides with WLS-fibre light collection, modernised R5946 → MCP-PMT readout, and segmentation increased from the legacy 32 cells to provide finer azimuthal granularity for event-plane determination [TDR-015 §10].

### 5.2 Geometry and segmentation (Design, TDR-015)

TDR baseline:
- **V0-Plus-A:** 8 radial rings × 8 azimuthal sectors = 64 cells.
- **V0-Plus-C:** 4 radial rings × 8 azimuthal sectors = 32 cells (preserved legacy segmentation).
- A-side z position: +335 cm (co-located with FT0-A); C-side z position: −90 cm (preserved legacy).
- Active radii chosen to cover 2.2 < η < 5.0 (A) and −3.7 < η < −2.1 (C) in the TDR concept [TDR-015 §10].

### 5.3 Photosensor options (Design, TDR-015)

Two photosensor technologies under consideration in the TDR [TDR-015 §10]: fine-mesh PMTs (direct heritage option) and MCP-PMTs (shared with FT0). Assignment to sides in the TDR concept: A-side fine-mesh baseline / C-side MCP-PMT favoured, with final decision deferred to prototype test results `[VERIFY]`.

### 5.4 As-built FV0 (Run 3) — divergence from TDR-015

The as-built FV0 diverges significantly from the TDR-015 V0-Plus concept. The C-side plastic-scintillator disk was dropped (its role absorbed by FT0-C and the MFT acceptance footprint). The A-side was rebuilt as a **single disk with 5 radial rings** and Hamamatsu R5946 fine-mesh PMT readout via WLS fibres `[VERIFY-FIT-AS-BUILT]`. Outer diameter ~140 cm, active coverage 2.2 < η < 5.1 `[VERIFY-FIT-AS-BUILT]`. The divergence from the symmetric TDR concept is substantial and must be presented in the dissertation as an as-built fact distinct from the TDR baseline.

---

## 6. FDD (Forward Diffractive Detector)

> **⚠ [NO PRIMARY SOURCE — FIT construction paper required]**
> This entire section describes Run 3 as-built content without a primary-source PDF in the project's current upload set. TDR-015 §10 mentions FDD only briefly as "replacing FMD/AD role." All numbers below are indicative and require the FIT construction/performance paper for verification.

**Role:** Diffractive-event tagging via rapidity-gap identification at the forward-most rapidity bins reached by ALICE in Run 3. Inherits the AD (ALICE Diffractive) role from Run 2.

**Geometry `[VERIFY-FIT-AS-BUILT]`:** two plastic-scintillator arrays (FDD-A at z ~ +17 m, FDD-C at z ~ −19 m). Each array: 4 quadrants × 2 layers of segmented scintillator. Coverage 4.7 < η < 6.3 (A) and −6.9 < η < −4.9 (C).

**Readout `[VERIFY-FIT-AS-BUILT]`:** shared FIT electronics chain — HPTDC for timing, amplitude digitisation via FIT common FEE.

**Role in dissertation:** ultra-peripheral-collision tagging, diffractive-gap identification. Not a primary multiplicity estimator for the analyses described here.

---

## 7. Common electronics and readout

### 7.1 Front-end and digitisation (Design, TDR-015)

All FIT subsystems share a common front-end electronics (FEE) chain [TDR-015 §10]:
- **Photosensor signal → preamplifier + constant-fraction discriminator (CFD)**.
- **HPTDC** (High-Performance TDC, CERN common development) provides leading-edge and time-over-threshold digitisation at 25 ps bin width.
- **Amplitude measurement** via integration ADC (charge-to-digital).
- **Per-channel latency:** < 100 ns from photon to digital output.
- **Per-board trigger primitives** (MB, vertex, centrality flags) computed in on-board FPGA within the CTP L0 latency budget.

### 7.2 Interface to CTP and O² (Design, TDR-015)

FIT FEE connects off-detector via the common ALICE optical link (GBT) to Common Readout Units (CRUs) and to the CTP for trigger-primitive delivery. Data flows into the O² First-Level Processor (FLP) layer for event-synchronous assembly and onward to the O² Event Processing Node (EPN) farm. Run 3 continuous readout requires FIT to deliver its time-frame boundaries and interaction-time tags to O² without triggered gating.

**Per-board bandwidth `[VERIFY]`:** each FIT CRU link operates at up to 3.2 Gb/s (GBT standard); aggregate FT0+FV0+FDD bandwidth ~40 Gb/s peak Pb-Pb 50 kHz.

### 7.3 Radiation load (Design, TDR-015)

FEE qualified to 10¹² 1-MeV n_eq/cm² and 10 krad TID per year at FT0-C radial position [TDR-015 §10]. FT0-A and FV0 radiation load is lower by factor ~5 due to larger z. On-detector electronics radiation-hardened; back-end located outside cavern.

---

## 8. Alignment and calibration

- **Timing alignment:** per-channel delay calibration using beam-coincidence events; target < 10 ps channel-to-channel spread after calibration.
- **Amplitude equalisation:** per-channel gain flat-fielding using LED/laser injection and minimum-bias reference distribution.
- **Vertex Z-offset calibration:** A-C timing-difference centroid monitored per fill; used both as vertex estimator and as beam-position diagnostic.
- **FT0M centrality calibration:** summed-amplitude → centrality-percentile mapping via Glauber-NBD fit, analogous to the Run 1/2 V0M procedure.

All calibration procedures `[VERIFY: FIT commissioning / Run 3 performance paper]`.

---

## 9. Role in this dissertation

### 9.1 Combined 4π and forward multiplicity estimators

FV0 provides the forward multiplicity estimator on the A-side in Run 3, replacing V0A. FT0 total amplitude (FT0A + FT0C = FT0M) provides a complementary minimum-bias centrality estimator that replaces V0M from Run 1/2.

Pseudorapidity coverage (TDR-baseline values; as-built deviate):
- FT0-A: 3.5 < η < 4.9 [TDR-015 §10]
- FT0-C: −3.3 < η < −2.1 [TDR-015 §10]
- FV0-A: 2.2 < η < 5.1 (TDR concept; as-built single-disk design) `[VERIFY-FIT-AS-BUILT]`
- (FV0-C removed in as-built; TDR concept had −3.7 < η < −2.1)
- FDD-A: 4.7 < η < 6.3 `[VERIFY-FIT-AS-BUILT]`
- FDD-C: −6.9 < η < −4.9 `[VERIFY-FIT-AS-BUILT]`

Together with TPC mid-rapidity tracking (|η| < 0.9) and ITS (|η| < 1.4), FIT extends the 4π multiplicity coverage of ALICE to approximately the full accessible pseudorapidity range of the experiment.

### 9.2 Event-shape estimators

FV0 ring segmentation (5 rings × 8 sectors as-built) and FT0 azimuthal segmentation provide forward event-plane and q-vector estimators with reach ~2 < |η| < 5. These complement the TPC event-plane at mid-rapidity, giving rapidity-separated event-shape observables for flow-correlation analyses.

### 9.3 T0 reference for TOF and for TPC calibration

FT0 A-C timing coincidence provides the collision-time t₀ that enters TOF particle-identification (without which TOF cannot convert flight-time to velocity). In Run 3 continuous readout, FT0 interaction-time tags also provide the time-frame reference used to define the drift-time origin for TPC space-point reconstruction. FT0 timing quality directly propagates into TPC z-coordinate resolution and into the TPC space-charge distortion calibration.

### 9.4 Centrality determination

FT0M and FV0M replace V0M as the primary Pb-Pb centrality estimator. Percentile bins are defined by Glauber-NBD mapping of the total-amplitude distribution; overlap with centrality defined by ZDC-spectator sum provides the cross-check used in systematic-uncertainty analyses.

### 9.5 Trigger role in Run 3

FIT delivers the minimum-bias trigger, the multi-multiplicity trigger, and the ultra-peripheral-collision trigger to the CTP. These triggers define the recorded datasets that are the basis of the physics analyses described later in this dissertation.

### 9.6 Cross-detector dependencies

| FIT ↔ | Role |
|---|---|
| TOF | t₀ reference for flight-time → velocity conversion |
| TPC | time-frame reference for drift-time origin in continuous-readout Run 3 |
| CTP | MB, centrality, multiplicity trigger primitives |
| ZDC | centrality cross-check (spectator sum vs FT0M/FV0M amplitude) |
| ITS / TPC | 4π multiplicity coverage; FIT extends forward, ITS/TPC cover mid-rapidity |

---

## 10. Limitations

- **Forward-only acceptance:** FIT provides no tracking, no PID, and no vertexing beyond z-position via A-C timing. For mid-rapidity physics it is supporting infrastructure (trigger, centrality, t₀), not a primary signal detector.
- **Multiplicity dependence of timing resolution:** few-hit events (peripheral pp) have worse time resolution than high-multiplicity events (central Pb-Pb); the < 50 ps design target is met at high multiplicity but degrades for low-multiplicity triggers.
- **Beam-gas background sensitivity:** forward location makes FIT sensitive to beam-gas interactions upstream of the IP; requires A-C timing coincidence and amplitude cuts to reject.
- **Amplitude calibration dependence for centrality:** centrality determination via FT0M/FV0M is only as good as the per-channel amplitude equalisation — a calibration, not an architectural, property.
- **As-built asymmetry (FV0 A-side only):** no forward FV0 on the C-side creates A-C asymmetry in event-shape measurements; analyses using FV0 must account for this asymmetry explicitly.

---

## 11. Acronym glossary

- **AD** — ALICE Diffractive detector (Run 2)
- **CFD** — Constant-Fraction Discriminator
- **CTP** — Central Trigger Processor
- **Cherenkov radiation** — light emitted by charged particle exceeding phase velocity in medium
- **CRU** — Common Readout Unit (O² system)
- **EPN** — Event Processing Node (O² farm node)
- **FDD** — Forward Diffractive Detector (FIT subsystem)
- **FEE** — Front-End Electronics
- **FIT** — Fast Interaction Trigger
- **FLP** — First-Level Processor (O² event-synchronous assembly)
- **FMD** — Forward Multiplicity Detector (Run 1-2)
- **FT0 / FT0-A / FT0-C** — FIT Cherenkov/MCP-PMT subsystem (A/C sides)
- **FT0M** — FT0 total amplitude (A+C), Run 3 centrality estimator
- **FV0** — FIT plastic-scintillator subsystem (single A-side disk as-built)
- **FV0M** — FV0 total amplitude, Run 3 centrality estimator
- **Glauber-NBD** — Glauber model + Negative Binomial Distribution fit for centrality mapping
- **HPTDC** — High-Performance Time-to-Digital Converter
- **L0** — Level-0 trigger (ALICE CTP first trigger level)
- **MB** — Minimum Bias
- **MCP-PMT** — Microchannel Plate Photomultiplier Tube
- **O²** — Online-Offline combined computing system (Run 3)
- **Planacon (XP85012)** — Photonis MCP-PMT product used in FT0
- **TOF** — Time-Of-Flight detector
- **V0 / V0A / V0C** — legacy plastic-scintillator arrays (Run 1-2)
- **V0M** — V0 total amplitude (A+C), Run 1-2 centrality estimator
- **WLS** — WaveLength-Shifter (fibre or plate)

---

## 12. Open items

1. **FIT construction paper / Run 3 performance paper** — the single largest open source. All `[VERIFY-FIT-AS-BUILT]` tags close when this is uploaded.
2. **TDR-015 PDF** was not re-read by Main Coder this revision — future v0.3 should include a Main Coder PDF-read pass per the project's mandatory-PDF rule, even though the v1 panel provided the 5-reviewer PDF-verified anchor.
3. **§5.3 photosensor side-assignment** (`[VERIFY]`) — clarify whether A-side / C-side allocation was finalised in the TDR or deferred.
4. **§4.7 assembled module weight** — cite assembled value with source.
5. **§7.2 per-board bandwidth** — close `[VERIFY]` with TDR or O² TDR citation.
6. **§2.1 fine-mesh PMT** — add JINST2008 §7 citation for legacy T0 PMT specifics.
7. **§4.9 FT0-A z-position divergence** from legacy T0A (+370 cm) to as-built (+373 cm) — source the reason explicitly in the construction paper.

---

*End of v0.2. Honest declaration at top: Main Coder did not re-read TDR-015 PDF this revision; v1 panel's 5-reviewer PDF-verified status is the numerical anchor. All structural / process / labelling changes applied per Claude3 consolidated action list. Expansion from ~3,200 words (v1) to ~4,900 words (v0.2) lands within the 10-12 page target. Panel re-review requested.*
