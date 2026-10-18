---
wiki_id: TDR_TOF_SourceOfTruth
title: "ALICE Time-Of-Flight (TOF) detector — design, simulation, reconstruction, calibration and performance, Run 1 to Run 3"
project: MIWikiAI / ALICE
folder: TDR
source_type: source-of-truth
version: "v0.4 — merged draft for the narrow confirmation review"
date: 2026-10-17
indexed_by: "Claude5:MIWikiAI"
reviewer_architecture: "Opus5.5"
supersedes:
  - "TOF_SourceOfTruth_v0_3_Claude5 (selected baseline)"
  - "TOF_SourceOfTruth_v0_2_20261017_GPT1_MIWikiAI (donor: document architecture, efficiency taxonomy, review questions)"
  - "TOF_SourceOfTruth_v0_2_Claude9 (donor: additional PPR figures and facts)"
baseline_decision: "v0.3 selected as baseline by the GPT4:MIWikiAI official review summary of 2026-10-17 (six reviewers); architect go for v0.4 on 2026-10-17"
document_family:
  - "TOF_SourceOfTruth (this document) — stable detector, literature, definitions, expected and measured performance"
  - "TOF_Reconstruction_SourceIndex v0.1 — AliRoot / AliceO2 / O2Physics implementation and mutable reconstruction parameters"
  - "TOF_Matching_Performance_Debugging v0.1 — the 2025/2026 run- and pass-specific investigation"
source_status: "DRAFT — cycle 0 of v0.4, not reviewed; Claude5 must not be the sole approver"
review_cycle: 0
peer_reviewers_assigned: []
peer_reviewers_reported: []
review_artifact: "TOF_SourceOfTruth_v0_4_Claude5.pdf — one PDF generated from this file; its identity page prints this file's SHA-256"
source_identity:
  miwikiai_commit: "not yet committed — the PDF must be rebuilt from the committed file and its SHA-256 recorded in the review manifest"
  pdf_sha256: "recorded outside the PDF (a file cannot contain its own hash)"
figures:
  local_files: 17   # PNGs in figures/TOF/ next to this file; all embedded in the PDF
  published_links: 12  # published ALICE figure images (7 figure slots) linked by URL; embedded once the paper PDFs are provided
  licence_note: "PPR Vol. II figures are from CERN-LHCC-2005-030 (© CERN), reproduced with attribution for ALICE-internal review. Licence of every reproduced figure to be confirmed before any public release."
source_inconsistencies:
  - {id: CONFLICT-1, topic: "MRPC strip count 1593 vs 1638", status: "open — this page infers central modules omitted in front of PHOS; the PPR simulation removed five, the 45-strip difference would need three"}
  - {id: CONFLICT-2, topic: "TOF radius", status: "resolved — radial extent 370–399 cm"}
  - {id: CONFLICT-3, topic: "Run 3 matching window: 28.8 us (caption) vs 29.8 us (diagram) vs the text definition 1/f_T", status: "open — not to be resolved by arithmetic; needs the readout configuration or the authors"}
  - {id: CONFLICT-4, topic: "design time resolution 80 vs 150 ps", status: "resolved — 150 ps in the 2000 TDR era, 80 ps baseline (incl. 50 ps start time) by PPR Vol. II in 2005"}
  - {id: CONFLICT-5, topic: "FT0 fit function in the Run 3 paper", status: "resolved — Double EMG in both versions"}
  - {id: CONFLICT-6, topic: "FT0 event-time resolution 16 vs 17 ps", status: "both quoted — different data sets; not a TOF quantity"}
  - {id: CONFLICT-7, topic: "Run 3 77.9 ps: 'full eta range' (text) vs abs(eta) < 0.8 (figure label)", status: "open — minor"}
known_verify_flags:
  - "TOF TDR, its Addendum, the Readout & Trigger TDR and PPR Vol. I not read."
  - "Values marked [read-off] were read by eye from rasterised PPR Vol. II figures; uncertainty about ±0.02–0.03."
  - "Plateau values of the published Run 1/2 matching-efficiency curves (ALICE 2014 Perf Fig. 37, Carnesecchi 2019 Fig. 2a, Jacazio 2018 Fig. 2) not read off — figure images not available here; paper PDFs needed."
  - "Text of Carnesecchi 2019, Jacazio 2018 and ALICE 2026 TOF-Run3 re-checked on 2026-10-17 through a web fetch tool that returns quotes; figures not seen."
  - "No published Run 3 TOF matching efficiency or mismatch fraction found."
  - "ALICE 2014 Perf §7.3 not re-checked in v0.4 (pad occupancy 6.7% vs 6.5% mismatched hits may be swapped; T0 efficiency, 30 ps with 30 tracks, 98.5%)."
searchable_keywords: [TOF, Time-Of-Flight, MRPC, HPTDC, DRM2, CRU, continuous readout, event collision time, FT0, T0, time slewing, time-over-threshold, matching efficiency, matching contamination, mismatch, fake match, PID, Bayesian PID, beta, Physics Performance Report, PPR Vol II, HIJING, MatchInfoTOF, Run 1, Run 2, Run 3, 152928 channels, 1593 strips, efficiency definitions, denominator]
---

# ALICE Time-Of-Flight (TOF) — source of truth

## How to read this page

This page explains the ALICE Time-Of-Flight detector for a physicist who has not worked on it, and is the reference an AI advisor loads before answering TOF questions. It covers what was planned and simulated before data taking, the hardware, how a time measurement becomes particle identification, how the detector was operated and calibrated in Run 1/2 and Run 3, and the published performance — in particular what "matching efficiency" means in each source, which is where most apparent disagreements come from.

**One of three documents.** This page holds only stable, literature-backed content. Two companion documents hold the rest:

| Document | Holds | Does not hold |
|---|---|---|
| **TOF_SourceOfTruth** (this page) | detector concept and geometry; time measurement and resolution; event time; calibration concepts; published design, simulated and measured performance; efficiency definitions | software class names, default parameters, CCDB values, run- or pass-specific plots |
| **TOF_Reconstruction_SourceIndex** | where each concept lives in AliRoot / AliPhysics and AliceO2 / O2Physics; reconstruction parameters and their defaults, pinned at a commit | physics conclusions |
| **TOF_Matching_Performance_Debugging** | the 2025/2026 investigation: QA task settings, the 2026 matching plot, TRD correlation, field polarity, parameter scans, fake-match diagnostics | stable definitions (it cites this page) |

**Literature keys.** Sources are cited by readable author–year keys such as **[PPR-II 2005]** or **[Carnesecchi 2019]**; the full list, with identifiers and how far each was read, is in §11. Figures of a source are cited as *[PPR-II 2005, Fig. 5.102]*.

**Value labels.** **DESIGN** = planned; **AS-BUILT** = installed hardware; **MC** = simulated expectation; **MEASURED** = from data. Never mix them — the TPC source-of-truth v0.3 incident came from using a design channel count as as-built. Further tags: `[computed]` arithmetic done for this page; `[read-off]` read by eye from a figure, uncertainty about ±0.02–0.03; `[ARCHITECT]` stated by Marian Ivanov, not published; `[CONFLICT-n]` sources disagree (§10); `[VERIFY]` not yet checked against the primary source. Facts established from code belong to the SourceIndex, not here.

**Figures.** Figures from the Physics Performance Report Vol. II and plots made for this page are embedded in the PDF. Published ALICE figures from the Run 1–3 papers are linked by URL; they render in the Markdown version and are boxed links in the PDF until the paper PDFs are available. Every caption carries the figure's numbers in text, because an AI advisor reading this page does not see images.

---

## Executive summary

The ALICE TOF is a 141 m² barrel of 1593 multigap resistive plate chambers (MRPCs), read out by 152,928 pads between 3.70 and 3.99 m from the beam, covering −0.9 < η < 0.9 over the full azimuth. It identifies pions, kaons and protons in the intermediate momentum range — roughly 0.5 to 4 GeV/c — by comparing the measured arrival time of each track with the time expected for each mass hypothesis.

**Before data taking**, the Physics Performance Report Vol. II (2005) simulated the full chain with an assumed 80 ps overall resolution (including a 50 ps start-time uncertainty). It predicted 3σ π/K separation up to 2.5 GeV/c and K/p up to 4 GeV/c; a track–TOF matching efficiency, for tracks that leave a hit on TOF, of about 92% (central Pb–Pb) to 97% (pp) for pions at 2 GeV/c and about 75% integrated over momentum in central Pb–Pb; but only about 60% of primary pions in central Pb–Pb reaching TOF and leaving a hit at all — because of about 15% dead space and 0.18 absorption lengths of material, mostly the TRD — so that only about 55% of primary pions end up correctly matched, and at best about 40% of primary kaons, at the optimal momentum, end up identified.

**Measured time resolution** was about 80 ps in Run 1; in Run 2 a channel-by-channel time-slewing calibration brought it from about 84 to 56 ps; the first Run 3 pp data of 2022 give 72.8–77.9 ps, with improvement expected. The chambers installed for Run 1 are still in use, with no observable degradation after 15 years; Run 3 brought a new readout board, continuous readout through a periodic trigger at about 33 kHz, and fully rewritten O² software.

**Matching efficiency** is defined differently in almost every source: per track that leaves a TOF hit (simulation), per TPC track (Run 1), per inner-tracker track (Run 2), per generated primary (simulation, overall). The values range from about 55% to 97% depending on that choice alone (Fig. 1.1). **No Run 3 matching efficiency or mismatch fraction has been published.** The 2026 internal measurement and its comparison with Run 1/2 are handled in TOF_Matching_Performance_Debugging; §7.6 states only why it matters.

| | Simulation (PPR Vol. II, 2005) | Run 1 (2009–2013) | Run 2 (2015–2018) | Run 3 (2022–) |
|---|---|---|---|---|
| Software | AliRoot | AliRoot | AliRoot | O² (AliceO2, O2Physics) |
| Time resolution | 80 ps assumed (60 / 120 ps variants) | ≈ 80 ps | ≈ 84 ps → 56 ps after channel-by-channel calibration | 72.8 ± 0.5 ps (FT0 method, abs(η) < 0.5) |
| Matching efficiency | π at 2 GeV/c per track with TOF hit: ≈ 0.92 (Pb–Pb), ≈ 0.97 (pp); ≈ 0.75 momentum-integrated, central Pb–Pb [read-off]; ≈ 0.55 per primary pion, central Pb–Pb [read-off] | ≈ 0.70 early [computed]; curves published | curve published (p–Pb 2016), lower than 2013 below 4 GeV/c | **not published** |
| Mismatch | contamination 0.03 (peripheral) to 0.24 (dN/dη ≈ 5400) [read-off] | < 1% pp; ≈ 6.5% of hits in very central Pb–Pb `[VERIFY]` | visible in β plots; no number found | **not published** |

![Time resolution by period](tof_plot_resolution_by_period.png)

*Figure 0.1 — TOF time resolution by period: PPR Vol. II design baseline 80 ps (MC, including 50 ps start-time uncertainty); Run 1 about 80 ps; Run 2 about 84 ps with the earlier calibration and about 56 ps with the channel-by-channel time-slewing calibration (Pb–Pb 5.02 TeV); Run 3 2022 pp 72.8 ± 0.5 ps (FT0 method, abs(η) < 0.5), 74.7 ± 2.3 ps (two-track method, abs(η) < 0.5), 77.9 ± 0.8 ps (FT0 method, full η, labelled abs(η) < 0.8 in the paper's figure); about 68 ps quoted in Run 3 proceedings without the selection. Methods and selections differ; orientation only. Sources: [PPR-II 2005], [Akindinov 2013], [Carnesecchi 2019], [ALICE 2026 TOF-Run3], [Strazzi 2024]. Plot made for this page.*

---

## 1. What TOF does and why ALICE needs it

### 1.1 Role in ALICE particle identification

ALICE identifies particles with several complementary techniques. At low momentum the TPC and ITS separate species by specific energy loss; at high momentum the TPC relativistic rise and HMPID take over. In between — from about 0.5 to a few GeV/c — the dE/dx bands of pions, kaons and protons cross, and **time of flight** is the cleanest separator. TOF measures the flight time t_TOF − t_ev over a path l of about 4 m (the detector sits 370–399 cm from the beam), hence the velocity β = l / (c · (t_TOF − t_ev)); with the momentum from tracking this gives the mass (§3.1) [PPR-II 2005, §5.4.4.3; ALICE 2026 TOF-Run3].

The reach follows from the resolution. With 80 ps the simulation predicted better than 3σ π/K separation up to 2.5 GeV/c and K/p up to 4 GeV/c [PPR-II 2005, §5.4.4.1], and Run 1 Pb–Pb data delivered exactly that [ALICE 2014 Perf, §7.3]. The reach depends on the chosen nσ criterion, the event-time resolution and the tracking, so there is no single species-independent "TOF momentum limit". Identified spectra, resonances, light nuclei and heavy-flavour decays with PID on several daughters depend on TOF. A decay with two identified daughters needs TOF on both, so any loss of single-track efficiency enters squared (§7.6).

### 1.2 The measurement chain

TOF is not an independent object detector: its value depends on central tracking. A TOF-identified particle has passed eight steps, each with its own losses, resolution and failure mode (Fig. 1.1). Every "TOF efficiency" in the literature is a ratio between two of these steps, so a number without its numerator and denominator is incomplete.

![Measurement chain and efficiency definitions](tof_plot_measurement_chain.png)

*Figure 1.1 — The eight steps from a primary particle to a TOF PID decision, with the main losses at each step, and the steps covered by four efficiency definitions in use. A: PPR ε_m, correct matches per TPC track that leaves a hit on TOF — π at 2 GeV/c ≈ 0.92 central Pb–Pb, ≈ 0.97 pp [MC, read-off]. B: Run 1/2 data definitions, tracks with any TOF signal per reconstructed track — plateau values not yet read off. C: PPR fraction of generated primaries correctly matched — π at 2 GeV/c ≈ 0.55, central Pb–Pb [MC, read-off]. D: PPR overall PID efficiency per generated primary — π ≈ 0.55, K ≈ 0.4, p ≈ 0.45, central Pb–Pb [MC, read-off]. Loss values: [PPR-II 2005, §5.4.4]; active channels and MRPC efficiency: [Carnesecchi 2019]. Plot made for this page.*

---

## 2. The detector

### 2.1 Geometry and segmentation

TOF is a cylinder of 18 azimuthal sectors around the TPC and TRD, at radii 370–399 cm [ALICE 2014 Perf, §7.3], covering −0.9 < η < 0.9 [ALICE 2026 TOF-Run3]. Each sector is divided into five modules along the beam; the central module covers abs(z) < 58 cm [PPR-II 2005, §5.4.4.1]. The sensitive element is the MRPC strip, 7.4 × 120 cm², read out by two rows of 48 pads of 2.5 × 3.5 cm² [ALICE 2026 TOF-Run3; Jacazio 2018].

| Quantity | Value | Label | Source |
|---|---|---|---|
| Coverage | −0.9 < η < 0.9, full azimuth | AS-BUILT | [ALICE 2026 TOF-Run3] |
| Radial extent | 370–399 cm | AS-BUILT | [ALICE 2014 Perf, §7.3] |
| Average distance from the beam pipe | 3.8 m | AS-BUILT | [ALICE 2026 TOF-Run3] |
| Sectors × modules along z | 18 × 5; central module abs(z) < 58 cm | DESIGN | [PPR-II 2005] |
| MRPC strips | **1593** | AS-BUILT | [ALICE 2026 TOF-Run3; Alici 2012; Carnesecchi 2019; Strazzi 2024] `[CONFLICT-1]` |
| Strip active area | 7.4 × 120 cm² | AS-BUILT | [ALICE 2026 TOF-Run3] |
| Pads per strip | 96 (2 × 48) | AS-BUILT | [Jacazio 2018; ALICE 2026 TOF-Run3] |
| Pad size | 2.5 × 3.5 cm² | AS-BUILT | [ALICE 2026 TOF-Run3] |
| Readout channels | **152,928** | AS-BUILT | [Akindinov 2010b; Jacazio 2018; Carnesecchi 2019]; `[computed]` 1593 × 96 |
| Active area | **141 m²** | AS-BUILT | [ALICE 2026 TOF-Run3]; `[computed]` 1593 × 0.0888 m² = 141.5 m² |
| Dead space | about 15% of the abs(η) < 0.9 acceptance | DESIGN/MC | [PPR-II 2005, §5.4.4.2] |
| Material in front of TOF | 0.18 absorption lengths, mostly TRD | DESIGN/MC | [PPR-II 2005, §5.4.4.2] |
| Gas mixture (stated for Run 3) | Freon 93% + SF₆ 7% | AS-BUILT | [Strazzi 2024] |

**The PHOS window.** In the PPR Vol. II simulation the central modules of the five sectors covering 220° < φ < 320° were removed to minimise material in front of the PHOS calorimeter, costing 5% of the geometrical acceptance [PPR-II 2005, §5.4.4.1]. The PPR says nothing about strip counts. This page infers that omitted central modules in front of PHOS explain the two counts in the literature, 1638 strips for a complete detector against 1593 as built — but the numbers do not match the PPR layout: `[computed]` 1638 − 1593 = 45 strips is three central modules if a central module holds 15 strips, while the PPR simulation removed five (75 strips, which would give 1563). Strip count per module and the as-built number of sectors without central module `[VERIFY: TDR Addendum]`.

**Design-era values that must not be quoted as as-built:** about 150–160 m² and about 160,000 channels (R&D papers 2000–2001), 1638 strips (complete-detector count). `[computed]` 1638 strips would give 157,248 pads and 145.5 m².

![ALICE detector in Run 3](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/2017-May-11-ALICE_RUN3_labels_HD.png)

*Figure 2.1 — The ALICE detector in Run 3; TOF is the barrel layer outside the TRD. [ALICE 2026 TOF-Run3, Fig. 1]*

### 2.2 The multigap resistive plate chamber

The ALICE MRPC is a double-stack chamber, each stack with five gas gaps of 250 µm, the gaps set by fishing line stretched across the glass sheets [Carnesecchi 2019]. The many thin gaps give a fast, narrow-timing avalanche signal. Measured properties:

- intrinsic time resolution better than 50 ps and efficiency close to 100% [Alici 2012]; 40 ps at the pad centre was the value used in the PPR simulation [PPR-II 2005, Table 5.13];
- single-pad efficiency 98% averaged over the pad area, from test beam; simulation with that value reproduces the data [Alici 2012];
- average MRPC efficiency 98.5% in operation [ALICE 2014 Perf, §7.3]; [Carnesecchi 2019] quotes about 98–99% intrinsic efficiency, citing the Run 1 performance paper;
- average charge per track about 6 pC; the detector current grows linearly with luminosity, so TOF also works as a luminometer [Carnesecchi 2019];
- dead time of MRPC plus front-end about 10 ns — short enough for continuous readout [ALICE 2026 TOF-Run3];
- no observable degradation of current, rate, uniformity or particle detection efficiency after 15 years [Strazzi 2024]; the Run 1 → Run 2 efficiency change is attributed to the completed TRD, not to MRPC ageing [Jacazio 2018].

### 2.3 Readout chain

Each pad signal is discriminated in the front-end; leading-edge time and time-over-threshold (ToT) are digitised by the High Performance TDC (HPTDC) on TDC readout modules (TRM) [ALICE 2026 TOF-Run3; Akindinov 2004 HPTDC]. ToT is the proxy for the deposited charge in the slewing calibration (§5.3, §6.3). For Run 3 a new Digital Readout Module (DRM2) sends data through the ALICE Common Readout Units (CRU) into the O² processing farm [ALICE 2026 TOF-Run3; Falchieri 2018].

### 2.4 Operation

In 2017 TOF was operated for 2116 hours, 99% of the time the TPC was running; on average 93% of the channels were active, the missing 7% from readout-electronics faults (4%) and external high-voltage distribution faults (3%) [Carnesecchi 2019]. The active-channel fraction is a separate factor in any efficiency: it is neither the MRPC efficiency (98–99%) nor the matching efficiency.

---

## 3. From a time stamp to particle identification

### 3.1 The quantities

| Symbol | Meaning |
|---|---|
| t_TOF | time measured by TOF for the matched hit |
| t_ev | collision time of the event |
| l | track length from the vertex to the TOF hit |
| p | momentum from ITS+TPC tracking |
| t_exp(i) | expected flight time for mass hypothesis i |

Mass from the measurement [PPR-II 2005, §5.4.4.3; ALICE 2026 TOF-Run3]:

```
m = p / (βγ) = p · sqrt( (c t_TOF)² / l²  −  1 )        (t_TOF measured from t_ev)
```

The expected time is integrated step by step during track propagation, Δt_k = Δl_k · sqrt(p_k² + m_i²) / p_k (c = 1), with p_k the local momentum, so energy loss along the path is included [PPR-II 2005, §5.4.4.3]. In Run 1/2 the integral and the expected times for e, μ, π, K and p were updated at every step of the outward Kalman refit and stopped at the TOF matching stage [ALICE 2014 Perf, §6]. In the PPR study a good extrapolation back to the primary vertex was required for a reliable t_exp; for primaries that requirement was 95% efficient [PPR-II 2005, §5.4.4.3, footnote].

**The PID response.** Since the PPR, the response for hypothesis i is a Gaussian in t_TOF around t_exp(i) with σ² = σ²_TOF + σ²_reco, where σ_reco — from the momentum and track-length uncertainties — depends on momentum and species and is about 30 ps on average in the simulation [PPR-II 2005, §5.4.4.3]. The Gaussian is weighted with prior abundances C_i into a Bayesian probability, and the track takes the identity with the highest probability. The PPR used C_π = 0.85, C_K = 0.10, C_p = 0.05 and C_e ≈ C_μ = 0.01, close to the generator-level concentrations, in both Pb–Pb and pp [PPR-II 2005, §5.4.4.3]. The method was later validated on data [ALICE 2016 Bayes]. In analysis the variable is usually nσ_i = (t_TOF − t_ev − t_exp(i)) / σ_PID,i.

### 3.2 What the resolution is made of

The overall resolution combines the TOF measurement, the tracking uncertainty on t_exp and the uncertainty on t_ev in quadrature [Jacazio 2018; ALICE 2026 TOF-Run3]. The PPR simulation broke the TOF term into six pieces [PPR-II 2005, Table 5.13]:

σ²_TOF = σ²_MRPC + 2σ²_TDC + σ²_Cal + σ²_Clock + 2σ²_ClTRM + σ²_T0

| Scenario | σ_MRPC | σ_TDC | σ_Cal | σ_Clock | σ_ClTRM | σ_T0 | nominal | `[computed]` quadrature |
|---|---|---|---|---|---|---|---|---|
| baseline | 40 | 20 | 30 | 15 | 10 | 50 | 80 ps | 78.9 ps |
| worst case | 60 | 50 | 50 | 35 | 10 | 50 | 120 ps | 122.6 ps |
| T0 at 15 ps | 40 | 20 | 30 | 15 | 10 | 15 | 60 ps | 62.8 ps |

All values in ps. The calibration term was expected to stay well below 30 ps; the start time below 50 ps from the T0 detector, 15 ps from T0 in central Pb–Pb, and possibly about 5 ps from TOF itself in central Pb–Pb with a combinatorial algorithm [PPR-II 2005, §5.4.4.1].

![PPR resolution budget](tof_plot_resolution_budget_ppr2.png)

*Figure 3.1 — Squared contributions to the TOF resolution in the three PPR Vol. II scenarios; the start time (T0) dominates the 80 ps baseline. Quadrature sums 78.9, 122.6 and 62.8 ps against nominal 80, 120 and 60 ps. Data from [PPR-II 2005, Table 5.13]; plot made for this page.*

The Run 2 proceedings use the same structure for data — σ²_MRPC + 2σ²_TDC + σ²_FEE + σ²_clock + σ²_Cal + σ²_trk + σ²_event, with TDC about 20 ps, front-end about 10 ps, LHC clock about 15 ps [Carnesecchi 2019, Eq. 3.2]. Their 56 ps is the width of t_TOF − t_ev − t_exp(π) [Carnesecchi 2019, Fig. 3a], so it contains the tracking and event-time terms as well (Appendix A.7). In Run 3 the resolution goes from about 100 ps at p ≈ 0.5 GeV/c to better than 80 ps with the ΔΔt method as the tracking term shrinks [ALICE 2026 TOF-Run3, §3, Fig. 11].

### 3.3 The event collision time

- **T0 / FT0 Cherenkov detectors.** In Run 1 the T0 was 100% efficient for the 60% most central Pb–Pb collisions, dropping to about 50% near 90% centrality [ALICE 2014 Perf, §7.3]. In Run 3 the FT0 gives about 16 ps in pp (fit σ = 16.40 ± 0.05 ps) [ALICE 2026 TOF-Run3, §2.2, Fig. 8]; FIT proceedings quote 17 ps [Melikyan 2024] `[CONFLICT-6]`.
- **TOF itself.** A combinatorial fit over tracks reaching TOF, usable from three tracks and reaching about 30 ps with 30 tracks [ALICE 2014 Perf, §7.3]; the resolution scales roughly as σ_TOF / sqrt(n_tracks) [Jacazio 2018, Eq. 2.3] — an idealisation: `[computed]` 80 ps / sqrt(30) ≈ 15 ps against the 30 ps quoted for Run 1 (Appendix A.14) — and is better than 5 ps for events with more than about 600 TOF-matched tracks in Run 2 [Jacazio 2018], as the PPR anticipated for central Pb–Pb.
- **Fallback.** Run-averaged start time [ALICE 2014 Perf, §7.3]. Full Run 1 study: [ALICE 2017 t0].

### 3.4 Signal shape

The TOF time response has an exponential tail on the late side [ALICE 2026 TOF-Run3]; in Run 2 the asymmetric tails were described as still under study [Carnesecchi 2019]. The PPR simulation already showed non-Gaussian tails growing for kaons and protons from energy loss and multiple scattering, and mis-associated tracks spread over several nanoseconds [PPR-II 2005, Fig. 5.107]. In Run 3 data about 7% of the signal lies above 2σ and 2.3% above 3σ (Gaussian: 2.3% and 0.13%); a 3σ cut loses about 3%, reproduced by simulation [ALICE 2026 TOF-Run3].

![PPR t_TOF − t_exp](tof_ppr2_fig5_107.png)

*Figure 3.2 — t_TOF − t_exp in simulated central Pb–Pb for (a) pions, (b) kaons, (c) protons; dark: correctly associated tracks, close to Gaussian for pions with growing tails for kaons and protons; light: mis-associated tracks spread over several nanoseconds. [PPR-II 2005, Fig. 5.107]*

![t_TOF − t_exp(π) vs momentum, Run 3](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/DeltaPiT0AC_vs_fP.png)

*Figure 3.3 — Measured minus expected time for the pion hypothesis versus momentum, 2022 pp at 13.6 TeV; kaon and proton bands separate from the pion band at low momentum and merge at high momentum. [ALICE 2026 TOF-Run3, Fig. 6]*

---

## 4. Expected performance from simulation — Physics Performance Report Vol. II (2005)

The PPR Vol. II detector-performance chapter has a complete TOF section: simulation setup, track–TOF matching algorithm, matching efficiency and contamination, PID efficiency and contamination [PPR-II 2005, §5.4.4, report pp. 100–111]. It is the reference for what the TOF was designed to deliver, and it defines its quantities more carefully than most later papers. **Everything in this section is a 2005 simulation of the design detector (MC), never a measurement.**

### 4.1 Simulation setup

- Central Pb–Pb: 200 HIJING 1.36 events, impact parameter 0–5 fm — the main reference; four peripheral samples of 30 events each, 5–15 fm.
- Parametrised Pb–Pb with dN_ch/dη = 2000, 5000 and 8000 (60 events each) to bracket the then-unknown multiplicity.
- pp: 15,000 PYTHIA minimum-bias events at √s = 14 TeV.
- GEANT3 transport; Gaussian time response, with pad-border sharing and position-dependent MRPC resolution from test beams.
- Magnetic field B = 0.5 T; momentum threshold to reach TOF 300 MeV/c for pions, 350 for kaons, 450 for protons.

### 4.2 The matching algorithm (AliRoot design)

1. **Starting sample:** all TPC tracks that can be extrapolated from the TPC outer wall (R ≈ 2.6 m) to the TOF inner radius (R ≈ 3.7 m), through TRD tracking.
2. **Recovery step:** TRD tracking stops tracks that cross regions with much passive material (notably TRD module boundaries). A second propagation with average material properties recovers them. With it nearly all TPC tracks that left a TOF signal enter the matching; the matching efficiency gains a factor 1.3–2 depending on momentum, at the cost of a factor about 1.1 more fake associations. The report adds that such a complementary extrapolation becomes even more necessary with a reduced TRD acceptance, as foreseen at start-up.
3. **Ordering:** tracks sorted by curvature, highest momentum first, to reduce fake associations.
4. **Window:** a (dφ, dz) window from the track parameters and their errors pre-selects fired pads.
5. **Step 1:** the track is propagated through TOF until it crosses a pre-selected pad; that pad's time is assigned.
6. **Step 2:** for tracks that crossed no fired pad, the closest signal within d_max is assigned — **d_max = 3 cm in Pb–Pb, 9 cm in pp**. In pp the looser cut gives about 10% more efficiency for about twice the (small) contamination.
7. A pad used once is flagged and not given to another track.

![PPR fraction of tracks extrapolated](tof_ppr2_fig5_101.png)

*Figure 4.1 — Fraction of TPC tracks that left a signal on TOF and are extrapolated to the TOF inner radius, versus (a) momentum and (b) pseudorapidity, central Pb–Pb. Dark: TRD tracking alone, rising to about 0.8 [read-off] at high momentum and dipping strongly at TRD module boundaries in η; light: with the recovery step, about 1.0. [PPR-II 2005, Fig. 5.101]*

In the design, **TRD-based extrapolation alone would have lost about 20% of the TOF-hit tracks at high momentum and more at low momentum**; the recovery step was essential. Whether a reconstruction has an equivalent path for tracks that fail TRD matching is therefore a first question for any efficiency comparison; for O² it is a code question tracked in the SourceIndex and the debugging document.

### 4.3 Matching efficiency and contamination — definitions

The PPR defines [PPR-II 2005, Eq. 5.15]:

- **matching efficiency** ε_m = N_m,t / N_reco,TOF — correctly matched tracks divided by **TPC-reconstructed tracks that release a hit on TOF**;
- **matching contamination** C_m = N_m,f / (N_m,t + N_m,f) — wrongly matched over all matched.

This ε_m is a *findable* efficiency: tracks that never reach TOF are not in the denominator (definition A in Fig. 1.1). The overall efficiency per generated primary is shown separately (Fig. 4.3). Two contamination sources are distinguished: the main one is tracks that did **not** reach TOF (interaction in material, decay for kaons) but were extrapolated anyway and picked up an unrelated hit; the smaller one is tracks that did reach TOF but were mis-extrapolated. In about 10% of contamination cases in central Pb–Pb the hit belongs to the track's own secondary, so the time remains roughly correct.

### 4.4 Matching performance — numbers

![PPR matching efficiency and contamination, central Pb–Pb](tof_ppr2_fig5_102.png)

*Figure 4.2 — Matching efficiency ε_m (open) and contamination C_m (shaded; dark: tracks that reached TOF, light: tracks that did not) versus momentum for primary (a) pions, (b) kaons, (c) protons in central Pb–Pb. Pions [read-off]: ε_m ≈ 0.63 at 0.5 GeV/c, 0.85 at 1 GeV/c, 0.89 at 1.5 GeV/c, 0.92 at 2 GeV/c, 0.95 at 3 GeV/c, 0.97 at 4 GeV/c; C_m ≈ 0.30 at 0.5 GeV/c, 0.17 at 1 GeV/c, 0.12–0.13 at 2–3 GeV/c. Kaons and protons: ε_m ≈ 0.8 at 1 GeV/c; above 2 GeV/c kaons ≈ 0.95–1.0, protons ≈ 0.89–0.95; C_m ≈ 0.2 at 1 GeV/c, 0.12–0.15 above 2 GeV/c. [PPR-II 2005, Fig. 5.102]*

![PPR fraction of primaries matched, central Pb–Pb](tof_ppr2_fig5_103.png)

*Figure 4.3 — Fraction of **all** primary (a) pions, (b) kaons, (c) protons generated at abs(θ − 90°) < 45° that leave a hit on TOF (open), are correctly matched (light) or wrongly matched (dark), central Pb–Pb. Pions [read-off]: with hit ≈ 0.58–0.60 above 1 GeV/c; correct ≈ 0.50 at 1 GeV/c, 0.55 at 2 GeV/c, 0.57 at 3 GeV/c; fake ≈ 0.08–0.10. Kaons: with hit ≈ 0.45 at 1.5 GeV/c rising to 0.5 (decays); protons ≈ 0.55. The loss from 1 to about 0.6 comes from dead space (about 15%), material (0.18 absorption lengths, mostly TRD) and decays. [PPR-II 2005, Fig. 5.103]*

![PPR efficiency and contamination vs multiplicity](tof_ppr2_fig5_104.png)

*Figure 4.4 — ε_m (a) and C_m (b) versus momentum, averaged over π, K, p, for dN_ch/dη = 2000 (dark), 5000 (open), 8000 (light). Efficiency changes by a few percent; contamination roughly halves from the highest to the lowest multiplicity. [PPR-II 2005, Fig. 5.104]*

![PPR efficiency and contamination vs centrality](tof_ppr2_fig5_105.png)

*Figure 4.5 — Momentum-integrated (0.45–6 GeV/c) ε_m (a) and C_m (b) versus dN_ch/dη for HIJING Pb–Pb at different centralities. [read-off] ε_m ≈ 0.835 at the lowest multiplicity, 0.80 at dN/dη ≈ 1100, 0.78 at 2800, 0.75 at 5400; C_m ≈ 0.03, 0.10, 0.165, 0.235 at the same points; open symbols (hit from the track's own secondaries) about 0.04. Text: in the most peripheral collisions (dN/dη ≈ 100) the efficiency is 10% higher and the mis-associated fraction a factor 8 smaller than in central events (dN/dη ≈ 6000); the own-secondary component is essentially independent of multiplicity and dominates below dN/dη ≈ 1000, the uncorrelated component scales with dN/dη. [PPR-II 2005, Fig. 5.105 and §5.4.4.2]*

![PPR matching efficiency, pp](tof_ppr2_fig5_106.png)

*Figure 4.6 — ε_m (open) and C_m (shaded) versus momentum in minimum-bias pp at 14 TeV for (a) pions, (b) kaons, (c) protons. [read-off] Pions: ε_m ≈ 0.93 at 1 GeV/c, 0.97–0.99 above 2 GeV/c; C_m ≈ 0.07–0.08 (with d_max = 9 cm). Kaons ≈ 0.95–1.0, protons ≈ 0.92–0.97 above 1 GeV/c. [PPR-II 2005, Fig. 5.106]*

| Quantity (simulation) | pp | Pb–Pb, low multiplicity | central Pb–Pb | Source |
|---|---|---|---|---|
| ε_m per track with TOF hit, π at 2 GeV/c | ≈ 0.97 | — | ≈ 0.92 | Figs. 4.6, 4.2 [read-off] |
| ε_m momentum-integrated | — | ≈ 0.835 | ≈ 0.75 (dN/dη ≈ 5400) | Fig. 4.5 [read-off] |
| C_m momentum-integrated | — | ≈ 0.03 | ≈ 0.24 | Fig. 4.5 [read-off] |
| primaries with TOF hit, π above 1 GeV/c | — | — | ≈ 0.60 | Fig. 4.3 [read-off] |
| primaries correctly matched, π at 2 GeV/c | — | — | ≈ 0.55 | Fig. 4.3 [read-off] |

### 4.5 PID efficiency and contamination

With matching done, the Bayesian PID of §3.1 uses t_TOF as the discriminating variable [PPR-II 2005, §5.4.4.3]. The PPR reports two different efficiencies, and they must not be confused:

- **algorithmic PID efficiency** (Fig. 4.7): correctly identified over tracks of that species associated with a TOF signal — measures the PID decision alone;
- **overall PID efficiency** (Fig. 4.8): correctly identified over generated primaries — includes tracking, dead space, decays, interactions, matching and PID.

In central Pb–Pb [PPR-II 2005, §5.4.4.3]:

- algorithmic: pions above 95%, roughly flat for 0.5 < p < 6 GeV/c; **kaons and protons at most 85% and momentum dependent** (report text; protons reach ≈ 0.88 in the figure);
- contamination: pions from a few percent to 30% (mostly kaons); protons from a few percent to 15% (mostly pions); kaons varying between about 20% and 10% over 0.5 < p < 3 GeV/c (mostly pions; not monotonic in the figure);
- at low momentum both inefficiency and contamination come mainly from track–TOF mis-association, at high momentum from the shrinking separation power;
- overall: about 1600 primary pions and about 100 kaons and protons are reconstructed and correctly identified per central HIJING event.

![PPR PID efficiency/contamination](tof_ppr2_fig5_108.png)

*Figure 4.7 — Algorithmic PID efficiency (open) and contamination (shaded, split by the species it comes from) versus momentum, central Pb–Pb, for (a) pions, (b) kaons, (c) protons. Pions above 0.95; kaons and protons "at most 85%" in the report text, momentum dependent — in the figure kaons peak at ≈ 0.85 and protons reach ≈ 0.88 near 2.25–3.5 GeV/c [read-off]. [PPR-II 2005, Fig. 5.108]*

![PPR overall PID efficiency](tof_ppr2_fig5_109.png)

*Figure 4.8 — Overall PID efficiency per generated primary (tracking, dead space, decays, interactions, matching and PID combined), central Pb–Pb. [read-off] Pions ≈ 0.55–0.58 for 1.5–4 GeV/c; kaons peaking at ≈ 0.42 near 2–2.5 GeV/c; protons ≈ 0.45–0.5 near 2–2.5 GeV/c. The "at most 85%" of Fig. 4.7 does not apply here. [PPR-II 2005, Fig. 5.109]*

![PPR kaon PID vs resolution](tof_ppr2_fig5_110.png)

*Figure 4.9 — Kaon algorithmic PID efficiency (a) and contamination (b) for TOF resolutions of 80 ps (open), 60 ps (light) and 120 ps (dark), central Pb–Pb. [read-off] At 120 ps the kaon efficiency falls below the 80 ps curve from about 2 GeV/c; at 60 ps it stays above it. High-momentum PID depends on the time resolution. [PPR-II 2005, Fig. 5.110]*

![PPR kaon PID vs multiplicity](tof_ppr2_fig5_111.png)

*Figure 4.10 — Kaon algorithmic PID efficiency (a) and contamination (b) for dN_ch/dη = 2000 (dark), 5000 (open), 8000 (light), 80 ps. [read-off] Efficiency at 1.5 GeV/c ≈ 0.93 / 0.87 / 0.83, at 0.5–0.75 GeV/c ≈ 0.82 / 0.62 / 0.56; above about 2.3 GeV/c the three agree (≈ 0.7 at 2.5 GeV/c). Contamination at 0.5–0.75 GeV/c ≈ 0.09 / 0.22 / 0.31, converging to ≈ 0.35–0.4 at 3.25–3.5 GeV/c. Multiplicity matters most at low momentum, where mis-associated tracks dominate. [PPR-II 2005, Fig. 5.111]*

![PPR PID in pp](tof_ppr2_fig5_114.png)

*Figure 4.11 — PID efficiency (open) and contamination (shaded) in minimum-bias pp for (a) pions, (b) kaons, (c) protons, (d) electrons. [read-off] Pions ≈ 0.97–1.0 over 0.5–6 GeV/c, contamination rising to ≈ 0.24 above 4.5 GeV/c; kaons ≈ 0.94–0.98 up to 1.75 GeV/c, ≈ 0.82 at 2.5 GeV/c, ≈ 0.5 at 3–3.5 GeV/c, contamination ≈ 0.02 below 2 GeV/c and ≈ 0.2–0.25 near 3 GeV/c; protons ≈ 0.95–1.0 for 1–3.5 GeV/c, ≈ 0.77 above 4.5 GeV/c, contamination below 0.08; electrons ≈ 0.92 at 0.3–0.5 GeV/c falling to ≈ 0.66 at 0.6–0.7 GeV/c and ≈ 0.17 at 0.7–0.8 GeV/c, with contamination rising from ≈ 0.13 to ≈ 0.43 and ≈ 0.9. Text: above 90% over a considerable fraction of the momentum range even for kaons; the clean pp environment may allow low-momentum electron identification. [PPR-II 2005, Fig. 5.114]*

**Caveats stated by the report itself** [PPR-II 2005, §5.4.4.2–5.4.4.3]: contamination levels depend on the HIJING particle ratios — comparable π, K, p yields above about 1.5 GeV/c, as indicated by RHIC, would substantially improve kaon identification; for this reason the report also gives mistag probabilities at a fixed 85% identification efficiency (Fig. 5.112, not reproduced). The recovery step of §4.2 is noted as even more necessary with the reduced TRD acceptance foreseen for start-up.

### 4.6 A second PPR study: full kaon efficiency for φ → K⁺K⁻

The physics chapter of the same report studied kaon identification for φ → K⁺K⁻ in central Pb–Pb with dN_ch/dη = 6000 and B = 0.4 T, defining the **full efficiency** as identified kaons over generated kaons — detection, tracking and PID together [PPR-II 2005, §6.2.5.1, report pp. 300–302].

![PPR full kaon efficiency with TOF](tof_ppr2_fig6_130.png)

*Figure 4.12 — Full kaon efficiency with TOF versus p_t in four η intervals, central Pb–Pb, B = 0.4 T. [read-off] Fitted maxima ≈ 0.21 (0.7 < abs(η) < 0.9), ≈ 0.31 (0.5–0.7), ≈ 0.38 (0.3–0.5), ≈ 0.36 (abs(η) < 0.3), near p_t ≈ 1.3–1.5 GeV/c. Text: the maximum full efficiency does not exceed 40% in either TPC or TOF; the TPC and TOF kaon regions overlap for 0.35 < p_t < 0.75 GeV/c. [PPR-II 2005, Fig. 6.130]*

Two independent PPR studies — different field, binning and variable — agree that at best about 40% of primary kaons in central Pb–Pb, at the optimal momentum, were expected to end up TOF-identified; at other momenta much less (Fig. 4.8: ≈ 0.14 at 0.5–0.75 GeV/c, ≈ 0.19 at 3.25–3.5 GeV/c [read-off]) (Appendix A.11).

---

## 5. Run 1 and Run 2 (2009–2018)

### 5.1 Readout

Triggered readout: HPTDC buffers with a 7.7 µs latency and a 600 ns matching window per trigger; barrel trigger rates of a few kHz [ALICE 2026 TOF-Run3, §1.2].

### 5.2 Reconstruction and matching

Tracks found in the TPC and prolonged into the ITS were refitted outwards, matched to TRD tracklets at R ≈ 290 cm, then propagated to TOF and matched to TOF clusters; detectors outside the TPC did not update the kinematics [ALICE 2014 Perf, §6]. The algorithm is the one designed in the PPR (§4.2). The closest-signal distance cut was about 10 cm in pp and 3 cm in Pb–Pb [ARCHITECT], consistent with the PPR design (9 cm / 3 cm) and with the AliRoot source defaults listed in TOF_Reconstruction_SourceIndex §2; that table and the production (OCDB) values belong to TOF_Reconstruction_SourceIndex.

### 5.3 Calibration and resolution

- **Run 1.** Stable operation with a total resolution of about 80 ps [Akindinov 2013]; 80 ps for pions near 1 GeV/c in Pb–Pb 0–70% [ALICE 2014 Perf, §7.3]. The time-slewing correction was a fitted parameterisation of time versus ToT for groups of 8 channels (a 5th-order polynomial) [Carnesecchi 2019].
- **Run 2.** A channel-by-channel time-slewing calibration replaced it. The resolution went from about 84 ps with the earlier ("standard") calibration to about 56 ps in Pb–Pb at 5.02 TeV; the paper states that the slewing correction gives a 50% improvement on the time resolution, and that in 2017 88% of the channels had an RMS below 20 ps [Carnesecchi 2019]. The 56 ps was obtained at the end of Run 2 [ALICE 2026 TOF-Run3]. `[computed]` 56 / 84 = 0.67; which quantity the "50%" refers to is not stated (Appendix A.13).

Linked only (public status `[VERIFY]`): ALICE performance plots of TOF β versus momentum in Pb–Pb, pp and p–Pb at 5.02 TeV, group "TOF performance figures", alice-figure.web.cern.ch node 748.

---

## 6. Run 3 (2022–)

### 6.1 What changed

The detector electronics were upgraded (DRM2) and refurbished, with relatively limited interventions; data-quality, reconstruction, calibration and analysis software was rewritten for O² [ALICE 2026 TOF-Run3]. No replacement of chambers is reported; the Run 1 MRPCs show no observable degradation after 15 years [Strazzi 2024]. There is no standalone Run 3 TOF design report; readout constraints are in [RO-TDR 2013], the as-built upgrade in [ALICE 2024 LS2].

### 6.2 Continuous readout with a periodic trigger

A periodic trigger at a fixed bunch crossing, asynchronous to collisions, three per LHC orbit, with a matching window equal to the trigger period, so that all hits are read out and associated to collisions offline. The latency cannot exceed half an orbit; the trigger rate is capped by the HPTDC readout time in the TRM [ALICE 2026 TOF-Run3, §1.2].

The paper gives the numbers in three places that do not agree exactly `[CONFLICT-3]`:

| Where in [ALICE 2026 TOF-Run3] | Statement |
|---|---|
| text, §1.2 | operating point f_T = 3 / t_orbit ≈ 33 kHz; matching window m_w = 1 / f_T |
| Fig. 2 caption | trigger at fixed bunch crossing, f = 33.4 kHz; "asynchronous trigger rate of ∼ 33 kHz and a matching window of 28.8 µs" |
| Fig. 2 diagram | latency 29.9 µs; matching window 29.8 µs; LHC orbit 89 µs |

This page does not choose a value. The window actually programmed is a readout-configuration fact, to be taken from the TOF readout settings or the authors; the arithmetic consistency check is in Appendix A.6.

![HPTDC programming Run 1/2](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/ro_tickz_run2.png)
![HPTDC programming Run 3](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/ro_tickz_run3.png)
![Allowed trigger frequency vs window](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/tofCR.png)

*Figure 6.1 — Run 1/2 programming (7.7 µs latency, 600 ns matching window); Run 3 programming (three asynchronous triggers per orbit, 29.9 µs latency, consecutive windows covering the orbit); allowed trigger-frequency/window combinations with the HPTDC limits and the working point near 33 kHz. [ALICE 2026 TOF-Run3, Fig. 2]*

### 6.3 Calibration chain

![Run 3 calibration chain](tof_plot_calibration_chain.png)

*Figure 6.2 — The three Run 3 calibration stages [ALICE 2026 TOF-Run3, §1.3]; plot made for this page.*

1. **DCS:** active-channel map at the start of the run, with timestamped updates when channels switch off, stored in the CCDB.
2. **Synchronous (EPN farm):** first time-calibration objects from matched tracks; decoding-error rates recorded so that simulation can be anchored to data conditions; precision limited by statistics and by the trackers being calibrated at the same time.
3. **Asynchronous:** a dedicated calibration pass on 10% of the full statistics, before the full reconstruction.

| Calibration | Granularity | How |
|---|---|---|
| TOF/ALICE clock shift relative to the LHC clock | every 5 minutes | from matched tracks |
| channel offsets | per channel, per run | peak of t_TOF − t_exp(π) |
| time slewing | per channel versus ToT, several runs combined | zero at ToT = 12.5 ns; statistical uncertainty < 10 ps |
| active-channel map | per run, updated when channels switch off | DCS → CCDB |

About 100 entries per calibration parameter and about 150k channels require about 5 × 10⁶ pp collisions, reached in about 15 minutes at 500 kHz with 1% synchronous reconstruction [ALICE 2026 TOF-Run3]; `[computed]` 500 kHz × 1% × 900 s = 4.5 × 10⁶. Noise in empty bunch slots about 0.1 Hz/cm².

![Clock shift](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/phase.png)
![Time slewing](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/timeSlewingAll.png)

*Figure 6.3 — TOF clock alignment in 5-minute intervals over one run; time-slewing corrections versus ToT for all channels with one channel overlaid. [ALICE 2026 TOF-Run3, Figs. 3–4]*

### 6.4 Measured time resolution, 2022 pp at 13.6 TeV

About 10⁹ events at about 500 kHz, each with a reconstructed vertex whose FT0A/FT0C timing matches the bunch crossing; tracks with ≥ 4 ITS hits (≥ 2 in the first three layers), ≥ 70 of 152 TPC crossed rows, χ²/NDF < 2, DCA within 7σ, TOF-matched [ALICE 2026 TOF-Run3, §2].

| Method | Selection | σ_TOF |
|---|---|---|
| two-track ΔΔt, reference | 0.6 < p < 0.7 GeV/c, abs(η) < 0.5 | 80.6 ± 0.4 ps |
| two-track ΔΔt | 1.4 < p < 1.5 GeV/c, abs(η) < 0.5 | **74.7 ± 2.3 ps** |
| t_TOF − t_exp − t_ev(FT0) | 1.4 < p < 1.5 GeV/c, abs(η) < 0.5 | **72.8 ± 0.5 ps** |
| t_TOF − t_exp − t_ev(FT0) | 1.4 < p < 1.5 GeV/c, full η (figure label abs(η) < 0.8) `[CONFLICT-7]` | 77.9 ± 0.8 ps |

Mean flat in η–φ to within 5 ps; width slightly worse at larger abs(η). The collaboration expects to approach the 56 ps of Run 2 [ALICE 2026 TOF-Run3, §3]. Run 3 proceedings quote about 68 ps without stating the selection [Strazzi 2024].

![ΔΔt at 1.4–1.5 GeV/c](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/DeltaDeltafinale.png)
![FT0 method](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/slice_10.png)
![Resolution vs momentum](https://alice-publications.web.cern.ch/sites/default/files/papers/12796/ResVSpt_and_sigma_vs_pt.png)

*Figure 6.4 — ΔΔt distribution at 1.4–1.5 GeV/c with separated pion and kaon peaks (σ_TOF = 74.7 ± 2.3 ps); t_TOF − t_exp − t_ev(FT0) at 1.4–1.5 GeV/c (σ = 77.9 ± 0.8 ps); resolution versus momentum, from about 100 ps at 0.5 GeV/c to better than 80 ps. [ALICE 2026 TOF-Run3, Figs. 9–11]*

**Not published for Run 3:** matching efficiency, mismatch fraction, Pb–Pb performance. The Run 3 paper analyses only tracks already matched to TOF ("Only tracks with a TOF match are considered"), so its timing result certifies neither matching efficiency nor purity.

---

## 7. Matching efficiency and mismatch across the eras

### 7.1 Which efficiency? — definition before number

Several distinct quantities are all called "TOF efficiency". Each has its own value range:

| Quantity | What it measures | Typical value | Source |
|---|---|---|---|
| intrinsic MRPC efficiency | a usable signal when a particle crosses an active pad | 98–99% | [Carnesecchi 2019; ALICE 2014 Perf] |
| active-channel fraction | channels read out and powered | 93% (2017 average) | [Carnesecchi 2019] |
| acceptance / findability | the track reaches an active pad at all (momentum threshold, dead space, decays, material) | ≈ 0.60 of primary pions, central Pb–Pb [MC] | [PPR-II 2005, Fig. 5.103] |
| matching efficiency | tracks with a TOF match / a reference set of tracks — **the reference set is part of the definition** | 0.55–0.97 depending on the reference set | table below |
| match purity, 1 − C_m | correct matches / all accepted matches | 0.76–0.97 momentum-integrated or at 2 GeV/c; ≈ 0.69 for pions at 0.5 GeV/c, central Pb–Pb [MC] | [PPR-II 2005, Figs. 5.102, 5.105–5.106] |
| algorithmic PID efficiency | correct identity / tracks with a TOF signal | π > 0.95; K, p at most ≈ 0.85 (text) [MC] | [PPR-II 2005, Fig. 5.108] |
| overall PID efficiency | correct identity / generated primaries | π ≈ 0.55, K ≈ 0.4, p ≈ 0.45 [MC] | [PPR-II 2005, Fig. 5.109] |

High matching efficiency can coexist with poor purity: a loose window raises both the efficiency and the fake fraction. A sentence such as "TOF efficiency is 85%" is incomplete until it says which row it means, with which denominator, for which collision system and momentum.

**Three different "85%" in TOF discussions.** (1) The PPR algorithmic PID efficiency ceiling for kaons and protons (Fig. 4.7) — not the overall efficiency. (2) The fixed 85% identification efficiency at which the PPR quotes mistag probabilities (its Fig. 5.112). (3) The architect's reading of the Run 1/2 high-p_T matching-efficiency plateau in the published p–Pb curves [ARCHITECT]. They are unrelated numbers.

The matching-efficiency definitions in use:

| Definition (Fig. 1.1) | Numerator | Denominator | Source |
|---|---|---|---|
| A — PPR ε_m (simulation) | correctly matched tracks | TPC tracks that leave a hit on TOF | [PPR-II 2005, Eq. 5.15] |
| C — PPR fraction correctly matched (simulation) | correctly matched primaries | generated primaries, abs(θ − 90°) < 45° | [PPR-II 2005, Fig. 5.103] |
| B — Run 1 (2010–2012) | TPC tracks with a detectable TOF signal | all TPC tracks | [Alici 2012; ALICE 2011 900GeV] |
| B — Run 1 p–Pb 2013 | TPC tracks matched, including geometric acceptance | TPC tracks | [ALICE 2014 Perf, Fig. 37] |
| B — Run 2 | tracks matched with a TOF signal | tracks reconstructed in the inner detectors | [Carnesecchi 2019, §2.2] |
| Run 3 | none published | — | — |

The PPR ε_m excludes everything lost before TOF; all the data definitions include it. The data definitions count any TOF signal, correct or not; the PPR counts only correct matches.

### 7.2 What limits it

- **Low momentum.** Below about 0.3 GeV/c tracks curl and never reach TOF [Carnesecchi 2019; PPR-II 2005]; below about 0.7 GeV/c energy loss and multiple scattering dominate [ALICE 2014 Perf, §7.3].
- **High momentum.** Dead space between sectors (about 15% of the acceptance), inactive modules and channels, MRPC efficiency (98.5%) [ALICE 2014 Perf, §7.3; PPR-II 2005; Carnesecchi 2019].
- **Material.** 0.18 absorption lengths in front of TOF, mostly TRD [PPR-II 2005]. Completing the TRD in Long Shutdown 1, together with tracking changes, lowered the 2016 p–Pb efficiency below about 4 GeV/c compared with 2013 [Carnesecchi 2019]; it is not MRPC ageing [Jacazio 2018].
- **Multiplicity.** In simulation ε_m falls from about 0.835 to 0.75 and contamination rises from about 0.03 to 0.24 between peripheral and central Pb–Pb [PPR-II 2005, Fig. 5.105, read-off].
- **Extrapolation through the TRD.** TRD tracking alone stops a sizeable fraction of tracks; the recovery step raised the matching efficiency by a factor 1.3–2 [PPR-II 2005, §5.4.4.2].

### 7.3 Quantitative evidence by period

| Period, system | Statement | Label | Source |
|---|---|---|---|
| Simulation 2005 | see §4.4 table | MC [read-off] | [PPR-II 2005] |
| 2009–2010, pp 900 GeV, partial TRD | losses: acceptance ≈ 15%, dead/noisy channels ≈ 10%, TRD material ≈ 8%; validated with TPC dE/dx | MC, data-validated | [ALICE 2011 900GeV] |
| same | `[computed]` 0.85 × 0.90 × 0.92 = 0.70 if the losses factorise | computed | |
| 2010, Pb–Pb 2.76 TeV | requiring a TOF hit cuts the overall track efficiency by about 30% | MEASURED | [ALICE 2013 PbPb-PID] |
| 2010–2011 | matching efficiency, data vs MC with 98% pad efficiency — good agreement | MEASURED + MC | [Alici 2012, Fig. 2] |
| 2013, p–Pb 5.02 TeV | matching efficiency incl. acceptance, data vs MC — plateau not yet read off | MEASURED + MC | [ALICE 2014 Perf, Fig. 37] |
| 2013 vs 2016, p–Pb | 2016 lower below about 4 GeV/c — values not given in the text; figure not yet read off | MEASURED | [Carnesecchi 2019, Fig. 2a; Jacazio 2018, Fig. 2] |
| Run 2, pp 13 TeV | TPC→TRD and TRD→TOF matched fractions — not yet read off | MEASURED | [ALICE 2018 TRD, Fig. 25] |
| Run 1/2, high p_T | plateau about 0.85 in the official p–Pb performance figures (architect's reading); 0.8–0.85 (GPT1:MIWikiAI reading) | reading of published figures, `[VERIFY]` | [ARCHITECT]; [ALICE 2014 Perf, Fig. 37]; [Carnesecchi 2019, Fig. 2a] |
| Run 1, MC-based tracking variant (unpublished) | about 90% saturation, set by geometrical acceptance; extra information used against fakes; not used in official reconstruction | [ARCHITECT] | |
| Run 3 | **no published value** | — | — |

![TOF matching efficiency p–Pb 2013](https://alice-publications.web.cern.ch/sites/default/files/papers/716/TOFmatchingEff-8498.png)

*Figure 7.1 — TOF matching efficiency including the geometric acceptance factor, TPC tracks, p–Pb at 5.02 TeV (2013), data versus simulation; plateau reflects dead space, inactive modules and the 98.5% MRPC efficiency. [ALICE 2014 Perf, Fig. 37]*

![TPC→TRD→TOF, pp 13 TeV](https://alice-publications.web.cern.ch/sites/default/files/papers/3740/match_eff_456-90218.png)

*Figure 7.2 — Fraction of tracks matched TPC→TRD and further TRD→TOF versus p_T, pp at 13 TeV (Run 2) — the Run 2 baseline for the TRD–TOF chain. [ALICE 2018 TRD, Fig. 25]*

### 7.4 Mismatch

- **Simulation:** contamination from about 3% (peripheral) to about 24% (dN/dη ≈ 5400), mainly from tracks that never reached TOF; in pp about 7–8% with the loose 9 cm cut [PPR-II 2005, Figs. 5.105–5.106, read-off].
- **pp data, Run 1:** below 1% wrong associations with a weak criterion [ALICE 2011 900GeV]. The definition differs: the PPR counts tracks that did not reach TOF but were matched anyway.
- **Pb–Pb data, Run 1:** with 10⁴ hits (very central Pb–Pb) pad occupancy 6.7% and about 6.5% of hits mismatched [ALICE 2014 Perf, §7.3] `[VERIFY: 10⁴ / 152,928 = 6.5%, so the two percentages may be swapped]`; analyses fitting TOF times add a mismatch template [ALICE 2013 PbPb-PID].
- **Pb–Pb data, Run 2:** β versus momentum shows points at non-physical values "due to mismatched tracks at TOF" [Carnesecchi 2019, Fig. 5]; no fraction is quoted.
- **Data-driven corrections:** light-nuclei analyses correct TPC–TOF matching efficiency and validate the material budget with data [ALICE 2020 nuclei pPb; ALICE 2020 d pp] (reported by GPT1:MIWikiAI, not read here); they do not by themselves measure the random fake-match fraction.
- **Run 3:** no published value. Continuous readout adds a candidate source — hits from a collision neighbouring in time — that a Run 3 study must address `[VERIFY: no source yet]`.

### 7.5 Simulation versus data

Run 1 and Run 2 publications show data and simulation side by side with good agreement [Alici 2012; ALICE 2014 Perf, Fig. 37]. The same closure is the minimum for any Run 3 efficiency claim.

### 7.6 Why the Run 3 matching efficiency matters now

An internal 2026 measurement suggests a Run 3 high-p_T matching efficiency well below the Run 1/2 level [ARCHITECT, unpublished]. For a decay with two TOF-identified daughters the single-track efficiency enters squared: `[computed]` 0.85² = 0.72 against 0.55² = 0.30, about 2.4 times more data for the same yield. Before any comparison, the numbers must use one definition from §7.1, the same denominator and the same collision system; the PPR curves of §4 (Figs. 4.2 and 4.3) are the two pre-data references. The investigation itself — data, settings, hypotheses and checks — is in **TOF_Matching_Performance_Debugging**.

---

## 8. Where TOF lives in the software

The implementation index is **TOF_Reconstruction_SourceIndex**: raw data and digits, calibration objects, clusters, propagation to TOF, matching windows and candidate ranking, path length and expected times, event time, PID response, the analysis data model and MC truth for matching — mapped one-to-one between AliRoot/AliPhysics (Run 1/2) and AliceO2/O2Physics (Run 3), pinned at a commit. Its purpose is to show what changed in meaning between the two software generations, not to list directories. The match data class `MatchInfoTOF` is already indexed in `../code/O2/DataFormats_Reconstruction.md`.

---

## 9. Open items and decisions for the architect

1. **Published figures in the PDF.** Upload the PDFs of [ALICE 2026 TOF-Run3] (arXiv:2511.10311), [ALICE 2014 Perf] (arXiv:1402.4476), [Carnesecchi 2019] (arXiv:1806.03825), [Jacazio 2018] (arXiv:1809.00574) and [ALICE 2018 TRD] (arXiv:1709.02743); their figures will be cropped into the PDF as for the PPR.
2. **Read-off of data curves.** Plateau values of [ALICE 2014 Perf, Fig. 37], [Carnesecchi 2019, Fig. 2a], [Jacazio 2018, Fig. 2] and [ALICE 2018 TRD, Fig. 25], once embedded.
3. **CONFLICT-3.** The Run 3 matching window actually programmed (TOF readout configuration or the authors).
4. **Design reports.** TOF TDR and Addendum for `[CONFLICT-1]` (strip count, PHOS window) and the MRPC design values.
5. **Licence.** PPR figures (© CERN), Run 3 paper figures and alice-figure performance plots before any public release.
6. **Commit.** Commit this file and its figures, rebuild the PDF from the commit, record the PDF SHA-256 in the review manifest.

---

## 10. Source inconsistencies

| ID | Topic | Values | Status |
|---|---|---|---|
| CONFLICT-1 | MRPC strips | 1593 (four sources) vs 1638 | open — this page's inference: central modules omitted in front of PHOS; but 1638 − 1593 = 45 strips is three central modules of 15 strips, while the PPR simulation removed five; count per module `[VERIFY]` |
| CONFLICT-2 | Radius | ~3.7 m vs 3.8 m vs 379.5 cm | **resolved** — extent 370–399 cm [ALICE 2014 Perf]; 3.8 m is the average distance |
| CONFLICT-3 | Run 3 matching window | 28.8 µs (Fig. 2 caption) vs 29.8 µs (Fig. 2 diagram) vs m_w = 1/f_T with f_T = 3/t_orbit ≈ 33 kHz (text) or 33.4 kHz (caption) | **open** — not resolved by arithmetic; needs the readout configuration or the authors (A.6) |
| CONFLICT-4 | Design resolution | 150 ps (TDR-era figure, 1999 readout requirement) vs 80 ps | **resolved** — the baseline moved: PPR Vol. II (2005) assumed 80 ps overall including a 50 ps start time [PPR-II 2005, Table 5.13] |
| CONFLICT-5 | FT0 fit function | q-Gaussian (stale search snapshot) vs Double EMG | **resolved** — Double EMG in both current versions |
| CONFLICT-6 | FT0 event-time resolution, Run 3 pp | ≈ 16 ps (16.40 ± 0.05 ps fit) [ALICE 2026 TOF-Run3] vs 17 ps [Melikyan 2024] | both quoted — different data sets; not a TOF quantity |
| CONFLICT-7 | Run 3 77.9 ps selection | "averaged over the full η range" (text) vs abs(η) < 0.8 (Fig. 10 label) | open — minor; both quoted |

---

## 11. Literature list

Read depth: **full**; **section** = the TOF-relevant sections; **text** = full text read as quotes through a web fetch tool, figures not seen; **abstract**; **not read** = identifiers verified only.

### 11.1 Design reports and overviews

| Key | Reference | Read depth |
|---|---|---|
| [TOF TDR 2000] | ALICE Collaboration, ALICE Time-Of-Flight system (TOF): Technical Design Report, CERN-LHCC-2000-012, ALICE-TDR-8, CDS 430132 | not read |
| [TOF TDR Add 2002] | ALICE Collaboration, Addendum to the TOF TDR, CERN-LHCC-2002-016, CDS 545834 | not read |
| [PPR-I 2004] | ALICE Collaboration, Physics Performance Report Vol. I, J. Phys. G 30 (2004) 1517 | abstract |
| [PPR-II 2005] | ALICE Collaboration, ALICE: Physics Performance Report, Vol. II, CERN-LHCC-2005-030; J. Phys. G 32 (2006) 1295, DOI 10.1088/0954-3899/32/10/001 | **§5.4.4 (TOF) full**, report pp. 100–111; §6.2.5.1 (φ → K⁺K⁻ kaon efficiency), pp. 300–302 |
| [ALICE 2008 JINST] | ALICE Collaboration, The ALICE experiment at the CERN LHC, JINST 3 (2008) S08002 | not read |
| [RO-TDR 2013] | ALICE Collaboration, Upgrade of the ALICE Readout & Trigger System, CERN-LHCC-2013-019, ALICE-TDR-015, CDS 1603472 | not read |
| [O2-TDR 2015] | ALICE Collaboration, Upgrade of the Online–Offline Computing System, CERN-LHCC-2015-006, ALICE-TDR-019, CDS 2011297 | indexed in Module 1 |
| [ALICE 2024 LS2] | ALICE Collaboration, ALICE upgrades during the LHC Long Shutdown 2, JINST 19 (2024) P05062, arXiv:2302.01238 | not read |

### 11.2 TOF performance papers

| Key | Reference | Read depth |
|---|---|---|
| [Akindinov 2004 HPTDC] | A. Akindinov et al., NIM A 533 (2004) 178 | not read |
| [Akindinov 2010a] | A. Akindinov et al., commissioning and 2008 cosmic-ray data, NIM A 615 (2010) 37 | abstract |
| [Akindinov 2010b] | A. Akindinov et al., 2009 cosmic-ray data, Eur. Phys. J. C 68 (2010) 89 | abstract |
| [Alici 2012] | A. Alici, The MRPC-based ALICE TOF detector: status and performance, arXiv:1203.5976 | sections 4–5 |
| [Akindinov 2013] | A. Akindinov et al., Performance of the ALICE TOF detector at the LHC, Eur. Phys. J. Plus 128 (2013) 44, DOI 10.1140/epjp/i2013-13044-x | abstract |
| [Alici 2014] | A. Alici, Particle identification with the ALICE TOF detector at the LHC, NIM A 766 (2014) 288 (proceedings) | abstract |
| [ALICE 2014 Perf] | ALICE Collaboration, Performance of the ALICE Experiment at the CERN LHC, Int. J. Mod. Phys. A 29 (2014) 1430044, arXiv:1402.4476 (CDS 1648854, reported by GPT1:MIWikiAI) | sections 6, 7.3 |
| [ALICE 2017 t0] | ALICE Collaboration, Determination of the event collision time with the ALICE detector at the LHC, Eur. Phys. J. Plus 132 (2017) 99, arXiv:1610.03055 | abstract |
| [Jacazio 2018] | N. Jacazio, PID performance of the ALICE-TOF detector at Run 2, PoS LHCP2018 (2018) 232, arXiv:1809.00574 | text |
| [Falchieri 2018] | D. Falchieri, DRM2: the readout board for the ALICE TOF upgrade, PoS TWEPP-17 (2018) 081 | not read |
| [Carnesecchi 2019] | F. Carnesecchi, Performance of the ALICE TOF detector at the LHC, JINST 14 (2019) C06023, arXiv:1806.03825 (CDS 2623662, reported by GPT1:MIWikiAI) | text |
| [Strazzi 2024] | S. Strazzi, 15 Years Young: the ALICE TOF detector in LHC Run 3, RPC2024; NIM A 1077 (2025) 170521 | abstract |
| [ALICE 2026 TOF-Run3] | ALICE Collaboration, Time resolution of the ALICE TOF detector with the first Run 3 pp collisions at √s = 13.6 TeV, Eur. Phys. J. Plus 141 (2026) 914, doi:10.1140/epjp/s13360-026-07626-4, arXiv:2511.10311 | **full text** (arXiv v2); figure images not seen; numbers re-checked as text 2026-10-17 |

### 11.3 Physics and other-detector papers with TOF performance content

| Key | Reference | Read depth |
|---|---|---|
| [ALICE 2011 900GeV] | ALICE Collaboration, Production of pions, kaons and protons in pp at √s = 900 GeV, arXiv:1101.4110 | TOF section |
| [ALICE 2013 PbPb-PID] | ALICE Collaboration, Centrality dependence of π, K, p production in Pb–Pb at 2.76 TeV, arXiv:1303.0737 | PID section |
| [ALICE 2016 Bayes] | ALICE Collaboration, Particle identification in ALICE: a Bayesian approach, Eur. Phys. J. Plus 131 (2016) 168, arXiv:1602.01392 | abstract |
| [ALICE 2018 TRD] | ALICE Collaboration, The ALICE TRD: construction, operation, and performance, NIM A 881 (2018) 88, arXiv:1709.02743 | abstract, captions |
| [Melikyan 2024] | Y. Melikyan for ALICE, Status and performance of the ALICE FIT detector, arXiv:2410.10617 | abstract |
| [Charm study 2003] | Charm production and in-medium energy loss with ALICE — a performance study, arXiv:nucl-ex/0311004 | TOF PID section |
| [ALICE 2020 nuclei pPb] | ALICE Collaboration, Multiplicity dependence of light (anti-)nuclei production in p–Pb at 5.02 TeV, Phys. Lett. B 800 (2020) 135043, arXiv:1906.03136 | not read (reported by GPT1:MIWikiAI) |
| [ALICE 2020 d pp] | ALICE Collaboration, (Anti-)deuteron production in pp collisions at 13 TeV, Eur. Phys. J. C 80 (2020) 889 | not read (reported by GPT1:MIWikiAI) |

Software sources are listed in TOF_Reconstruction_SourceIndex.

---

## Appendix A. Closure checks

| # | Check | Result |
|---|---|---|
| A.1 | 1593 × 96 = 152,928 channels | CLOSED `[computed]` |
| A.2 | 1593 × 7.4 × 120 cm² = 141.5 m² vs 141 m² | CLOSED `[computed]` |
| A.3 | 96 × 2.5 × 3.5 cm² = 840 cm² of pads in an 888 cm² strip | consistent (pads span 120 × 7.0 cm of 120 × 7.4 cm) |
| A.4 | PPR budget: 80 / 120 / 60 ps nominal vs 78.9 / 122.6 / 62.8 ps quadrature | CLOSED within rounding `[computed]` |
| A.5 | 500 kHz × 1% × 15 min = 4.5 × 10⁶ vs "about 5 × 10⁶ collisions" | CLOSED `[computed]` |
| A.6 | Run 3 matching window. `[computed]` LHC orbit 3564 × 24.95 ns = 88.92 µs (diagram: 89 µs), one third = 29.64 µs; 1 / 33.4 kHz = 29.94 µs. Printed window: 28.8 µs (caption), 29.8 µs (diagram); printed latency 29.9 µs. | OPEN — CONFLICT-3. Neither printed window value equals either computed period; the printed latency equals 1/33.4 kHz. This check does not decide the conflict. (v0.3 used an orbit of 89.4 µs here, which was wrong.) |
| A.7 | Run 2: electronics sqrt(2·20² + 10² + 15²) = 33.5 ps (TDC enters twice); residual sqrt(56² − 33.5²) ≈ 45 ps holds MRPC, calibration, tracking and event-time terms together | consistent with MRPC < 50 ps; the MRPC term alone is not separable from the published numbers |
| A.8 | sqrt(72.8² − 16²) = 71.0 ps | supports "FT0 contribution negligible" |
| A.9 | early Run 1: 0.85 × 0.90 × 0.92 = 0.70 vs "about 30% loss" in 2010 Pb–Pb | two independent statements agree on ≈ 70% |
| A.10 | PPR central Pb–Pb pions: with-hit ≈ 0.60 × ε_m ≈ 0.92 = 0.55 vs correctly matched ≈ 0.55 [read-off] | CLOSED within read-off uncertainty `[computed]` |
| A.11 | PPR kaons, central Pb–Pb: overall PID efficiency peak ≈ 0.42 at 2–2.25 GeV/c (§5.4.4, 0.5 T, Fig. 5.109) vs maximum full efficiency ≤ 0.40 (§6.2.5.1, 0.4 T, Fig. 6.130) | two independent PPR studies agree at the 0.4 level — for the maxima, not averages |
| A.12 | TOF-only event time: PPR "possibly about 5 ps" in central Pb–Pb vs Run 2 data "better than 5 ps above about 600 tracks" | consistent |
| A.13 | Run 2: 84 → 56 ps is a factor 0.67; the paper states a "50% improvement" from the slewing correction | OPEN — which quantity improved by 50% is not stated |
| A.14 | TOF-only event time: σ_TOF / sqrt(n) with 80 ps and 30 tracks = 14.6 ps vs "about 30 ps with 30 tracks" in Run 1 | the simple scaling is optimistic by about a factor 2 at 30 tracks; quoted as an idealisation |

## Appendix B. Figure manifest

| Page figure | Source | File / URL | In PDF |
|---|---|---|---|
| 0.1 | made for this page | tof_plot_resolution_by_period.png | yes |
| 1.1 | made for this page, values from §2–§4 | tof_plot_measurement_chain.png | yes |
| 2.1 | [ALICE 2026 TOF-Run3] Fig. 1 | alice-publications …/papers/12796/2017-May-11-ALICE_RUN3_labels_HD.png | link |
| 3.1 | made for this page, data [PPR-II 2005] Table 5.13 | tof_plot_resolution_budget_ppr2.png | yes |
| 3.2 | [PPR-II 2005] Fig. 5.107 | tof_ppr2_fig5_107.png | yes |
| 3.3 | [ALICE 2026 TOF-Run3] Fig. 6 | …/12796/DeltaPiT0AC_vs_fP.png | link |
| 4.1–4.11 | [PPR-II 2005] Figs. 5.101–5.106, 5.108–5.111, 5.114 | tof_ppr2_fig5_101.png … tof_ppr2_fig5_111.png, tof_ppr2_fig5_114.png | yes |
| 4.12 | [PPR-II 2005] Fig. 6.130 | tof_ppr2_fig6_130.png | yes |
| 6.1 | [ALICE 2026 TOF-Run3] Fig. 2 | …/12796/ro_tickz_run2.png, ro_tickz_run3.png, tofCR.png | link |
| 6.2 | made for this page | tof_plot_calibration_chain.png | yes |
| 6.3 | [ALICE 2026 TOF-Run3] Figs. 3–4 | …/12796/phase.png, timeSlewingAll.png | link |
| 6.4 | [ALICE 2026 TOF-Run3] Figs. 9–11 | …/12796/DeltaDeltafinale.png, slice_10.png, ResVSpt_and_sigma_vs_pt.png | link |
| 7.1 | [ALICE 2014 Perf] Fig. 37 | …/papers/716/TOFmatchingEff-8498.png | link |
| 7.2 | [ALICE 2018 TRD] Fig. 25 | …/papers/3740/match_eff_456-90218.png | link |

PPR Vol. II figures were cropped from CERN-LHCC-2005-030 at 220 dpi: report pages 102–111, PDF pages 120–129 (Figs. 5.101–5.114), and report page 302, PDF page 320 (Fig. 6.130). The plotting scripts for the four plots made for this page are kept with the figures.

## Appendix C. Questions for the confirmation review

The review is narrow: it confirms the merge, it does not restart the three-candidate comparison.

1. Are design, simulated (MC) and measured values kept apart everywhere, including in Figs. 0.1 and 1.1?
2. Is the "at most 85%" attached only to the algorithmic PID efficiency (Fig. 4.7), and nowhere to the overall efficiency (Fig. 4.8)?
3. Are the PPR contamination and wrong-association statements in §4.3–§4.5 accurate against the report text?
4. Are the Run 1/2 matching-efficiency definitions in §7.1 described correctly, and is the 0.8–0.85 plateau marked as a reading still to be verified?
5. Is the 56 ps attributed to the Run 2 channel-by-channel calibration, and the 84 ps to the earlier one?
6. Is the Run 3 74.7 ± 2.3 ps presented as one estimator among four, not as the detector resolution?
7. Is CONFLICT-3 stated without choosing a value?
8. Does anything in this page belong to the SourceIndex (class names, defaults) or to the debugging document (2025/2026 runs, QA settings)?
9. Do the read-off values in the captions agree with the figures, within ±0.03?
10. Is the PDF identity page (version, commit, source SHA-256, figure counts) sufficient for the review manifest?

## Appendix D. What this version took from which candidate

| From | Taken | Not taken, and why |
|---|---|---|
| Claude5 v0.3 (baseline) | whole structure and text; literature list with read depth; closure checks; conflict register; PPR figures 5.101–5.110; Run 1/2 sections | §7.6 (2026 investigation) and the `qaMatchEff` reconnaissance → debugging document; AliRoot parameter table and software map → SourceIndex; wrong orbit length in A.6 → corrected |
| GPT1:MIWikiAI v0.2 | three-document architecture; measurement chain (now Fig. 1.1); efficiency taxonomy and "which efficiency?" rule (§7.1); what-belongs-here rule; review questions (Appendix C); Run 2 operation facts and the double-stack MRPC description (checked against [Carnesecchi 2019]) | its attribution of "at most 85%" to the overall PID efficiency of Fig. 5.109 — the report attaches it to the algorithmic efficiency of Fig. 5.108; its Run 2 "point-by-point" slewing wording — the paper says channel-by-channel; its PID-reach values for 100 ps — source not checked |
| Claude9 v0.2 | PPR Figs. 5.111 and 5.114; σ_reco ≈ 30 ps; Bayesian priors; the PPR caveats; the §6.2.5.1 kaon full-efficiency study (Fig. 6.130 added); FT0 16 vs 17 ps conflict; Run 3 event selection and calibration-stage details — all checked against the sources | "m_w = 1/f_T = 28.8 µs, three triggers cover one orbit" — inconsistent (3 × 28.8 µs = 86.4 µs ≠ 88.9 µs) and not flagged; read-off ε_m ≈ 0.5 at 0.5 GeV/c and C_m ≈ 0.2 for pions in Fig. 5.102 — re-read as ≈ 0.63 and ≈ 0.30 |

---

## Changelog

- **v0.4 (2026-10-17)** — Merge of three candidates on the v0.3 baseline, as decided in the GPT4:MIWikiAI review summary and by the architect. Applied the four required corrections: (1) "at most 85%" attached only to the algorithmic PID efficiency, with a note on the three different 85% values; (2) three-document split — the 2026 investigation moved to TOF_Matching_Performance_Debugging v0.1, software map and AliRoot parameters to TOF_Reconstruction_SourceIndex v0.1; (3) CONFLICT-3 stated with all printed values and no chosen value, and the v0.3 orbit length (89.4 µs) corrected to 88.92 µs; (4) one PDF with all local figures embedded and an identity page. Added: measurement-chain figure (1.1); efficiency taxonomy (§7.1); Run 2 operation and calibration facts from [Carnesecchi 2019]; event-time result from [Jacazio 2018]; PPR σ_reco, priors and caveats; PPR Figs. 5.111, 5.114 and 6.130; CONFLICT-6 and CONFLICT-7; closure checks A.11–A.13; Appendices C and D. Pion read-offs of Fig. 5.102 refined. Before release, an independent check (separate agent, not the drafter) re-derived the PPR figure values from the vector data, recomputed every closure check and re-read the three arXiv papers: no wrong number found; 6 imprecisions and 18 cosmetic issues fixed — notably the A.7 electronics sum (TDC enters twice: 33.5 ps, not 27 ps), the CONFLICT-1 inference (five removed modules in the PPR layout vs three needed for 1593 strips), kaon "40%" stated as a maximum, Run 2 MRPC 98–99% traced to the Run 1 paper, page ranges, and citations moved to the sources that contain them; new closure check A.14.
- **v0.3 (2026-10-17)** — PPR Vol. II TOF section (§5.4.4) read in full and added with nine of its figures; four plots; companion PDF. Resolved CONFLICT-4, gave CONFLICT-1 a likely cause. Correction: v0.2 said the simulated TOF matching performance was in PPR Vol. I; it is in Vol. II.
- **v0.2 (2026-10-17)** — rewritten for readability; literature list integrated; embedded ALICE figures.
- **v0.1 (2026-10-17)** — first candidate draft.

*Claude5:MIWikiAI (architecture Opus5.5) · 2026-10-17 · Quota: no session-block signals observed.*
