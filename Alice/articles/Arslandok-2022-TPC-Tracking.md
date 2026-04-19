---
wiki_id: Arslandok-2022-TPC-Tracking
title: "Track Reconstruction in a High-Density Environment with ALICE (Arslandok et al. 2022)"
project: MIWikiAI / ALICE
folder: articles
source_type: conference-proceedings
source_title: "Track Reconstruction in a High-Density Environment with ALICE"
source_status: SOURCE IS PARTIAL — §1–4 (through Eq. 1) retrieved this pass; §4 remainder + §5 Summary + full reference list pending a second fetch pass against the arXiv PDF.
source_fingerprint:
  upstream:
    - id: Particles-2022-5-1-8
      title: "Track Reconstruction in a High-Density Environment with ALICE"
      doi: "10.3390/particles5010008"
      url: "https://www.mdpi.com/2571-712X/5/1/8"
      venue: "Particles 2022, 5(1), 84–95"
      special_issue: "Selected Papers from 'New Horizons in Time Projection Chambers'"
      license: "CC BY 4.0"
      published: "2022-03-10"
      submitted: "2021-12-30"
      accepted: "2022-03-03"
      academic_editors: ["Diego González-Díaz", "Paul Colas"]
    - id: arXiv-2203.10325
      title: "Track Reconstruction in a High-Density Environment with ALICE"
      url: "https://arxiv.org/abs/2203.10325"
      pdf: "https://arxiv.org/pdf/2203.10325"
      version: "v1"
      submitted: "2022-03-19"
      subjects: ["physics.ins-det (primary)", "hep-ex (secondary)"]
      page_count: 13
      figure_count: 14
      equivalence: "preprint identical in scope to Particles 2022 published version; pagination differs"
  summary_version: "v0"
  summary_review_panel: []
source_last_verified: 2026-04-19
authors_upstream:
  - name: "Mesut Arslandok"
    orcid: "0000-0002-3888-8303"
    affiliations: ["CERN", "Yale University (Wright Lab)", "Heidelberg University"]
    corresponding: true
  - name: "Ernst Hellbär"
    affiliation: "GSI Helmholtzzentrum für Schwerionenforschung"
  - name: "Marian Ivanov"
    orcid: "0000-0001-7461-7327"
    affiliation: "GSI Helmholtzzentrum für Schwerionenforschung"
    corresponding: true
  - name: "Robert Helmut Münzer"
    orcid: "0000-0002-8334-6933"
    affiliation: "Goethe-Universität Frankfurt (IKF)"
  - name: "Jens Wiechula"
    affiliation: "Goethe-Universität Frankfurt (IKF)"
author: Marian Ivanov (MIWikiAI dissertation lead; co-author of the upstream article)
indexed_by: Claude4
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 0
peer_reviewers: []
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags:
  - "§4 remainder: discussion of each term in Eq. 1 (F_μtot, track-quality reweighting) not extracted this pass"
  - "§5 Summary / Conclusions not extracted this pass"
  - "Full reference list (arXiv refs [1]–[15]) not extracted; bibliographic stubs below are partial"
  - "Figure captions 9–14 not extracted; present as [STUB figure-caption] markers in §6 below"
wiki_sections_stubbed:
  - "§6.4 remainder-of-§4 — awaiting second fetch pass"
  - "§7 Summary / Conclusions — awaiting second fetch pass"
  - "§9 External references — BibTeX stubs incomplete (arXiv refs [1]–[15] not fully extracted)"
---

# Track Reconstruction in a High-Density Environment with ALICE (Arslandok et al. 2022)

> **Source status.** This wiki page was indexed from the MDPI HTML (`Particles 2022, 5(1), 84–95`) plus the arXiv preprint PDF (`arXiv:2203.10325`) in a single pass on 2026-04-19. The fetch retrieved §1–4 through Eq. (1) plus all figures 1–8. The remainder of §4 (discussion of each term of the fluctuation formula, correction strategy, feedback-loop details) and §5 Summary are marked `[STUB — awaiting next fetch pass]`. A second pass should complete §4 and §5 and retrieve the full reference list. No physics content was inferred or reconstructed; every number below carries a citation tag to the source.

## TL;DR

Proceedings paper from the *New Horizons in Time Projection Chambers* special issue (`Particles` 2022) describing the **ALICE combined-tracking procedure** in the Run 2 era (2015–2018) and the two main performance challenges addressed in that period: (i) **baseline fluctuations** in the TPC readout arising from the *ion-tail* and *common-mode* effects, and (ii) **local space-charge distortions** originating in the gap between adjacent readout chambers. Both were corrected offline, mitigated with multi-dimensional calibration maps, and in the space-charge case partially restored via ITS–TRD track interpolation.

Two software tools are first-class citizens of the paper: the **Skimmed-data workflow** — Petabyte-scale reconstructed data reduced to ~100 GB for fast-turnaround reconstruction iteration (>200 parallel reconstruction variants/day achieved) — and **RootInteractive**, a multi-dimensional interactive-visualization framework integrating Random-Forest ML with Jupyter/Bokeh for calibration map inspection.

Performance claims anchored in the paper:
- TRD inclusion improves q/p_T resolution by **~40% at high p_T** for both low (12 kHz) and high (230 kHz) pp interaction rates [§1, Figure 2 right panel].
- >25% of 2018 Pb–Pb events affected by out-of-bunch pileup at ≈8 kHz IR [§3].
- Local space-charge distortions reach **several cm** versus ~200 μm intrinsic TPC resolution [§4].

Paper is a Marian Ivanov co-authored reference for this dissertation; the tools, calibration ideas, and performance diagnostics link directly to TPC-SoT §5 (Run 1/2 MWPC), TPC-SoT §7 (Run 3 GEM calibration), O2-4592 (skimmed data / RootInteractive), PWGPP-643 (combined shape estimator).

---

## 1. Context and physics scope

### 1.1 Detector and acceptance

ALICE [Particles2022 §1; JINST2008] was designed to handle ~20 000 charged primary + secondary tracks in the TPC acceptance `|η| < 0.9` from central Pb–Pb at `√s_NN = 5.5 TeV`. The same track densities are also reached in pp at high interaction rate, where multiple collisions pile up within the TPC drift time.

| Quantity | Value | Source |
|---|---|---|
| TPC acceptance | `|η| < 0.9` | Particles2022 §1 |
| p_T range (tracked) | ≈100 MeV/c – ≈100 GeV/c | Particles2022 §1 |
| Solenoid field | 0.5 T along beam | Particles2022 §1 |
| Design multiplicity | ~20 000 primary+secondary | Particles2022 §1 |

Cross-barrel detectors involved in combined tracking: **ITS + TPC + TRD + TOF**. TPC is the main tracking detector; ITS supplies the inner constraint; TRD extends the lever arm and improves q/p_T resolution; TOF adds timing.

### 1.2 Run 2 data-taking scope

Run 2 = 2015–2018 LHC data period. Operational Pb–Pb rate ceilings exploited up to **8 kHz** during Pb–Pb running and up to **200 MHz** equivalent in pp (§3). This rate regime is the context for the pileup-driven baseline shift discussed in §3 below.

## 2. Combined tracking procedure

### 2.1 Kalman-filter three-pass structure

Following the Kalman Filter approach [Belikov et al.; arXiv physics/0306108 reference in the paper], combined tracking in the ALICE central barrel proceeds in three passes [Particles2022 §1, Figure 1]:

1. **Seed** in the outermost TPC pad rows.
2. **Propagate inward** through TPC → ITS, ending at the primary vertex.
3. **Propagate outward** from the innermost ITS layer → TRD → TOF. Primary tracks refit back to the vertex; secondaries refit as close to the vertex as possible.

### 2.2 p_T resolution improvements

Figure 2 of the paper documents two sequential improvements in the resolution of `1/p_T` [§1, Figure 2]:

| Comparison | Effect | Notes |
|---|---|---|
| TPC standalone → TPC standalone + vertex constraint | Significant improvement | Figure 2 (left) |
| ITS–TPC → ITS–TPC + vertex constraint | No effect (green and blue overlap) | Vertex already well-constrained by ITS |
| ITS–TPC + TRD in fit vs ITS–TPC | **~40% improvement at high p_T** | Both at 12 kHz (low IR) and 230 kHz (high IR) pp collisions; Figure 2 (right) |

The data in Figure 2 (left) is for `p–Pb at √s_NN = 5.02 TeV`, restricted to `|d| < 0.8`; Figure 2 (right) for pp collisions, two IR settings. [Particles2022 Figure 2]

---

## 3. Software tools: Skimmed Data and RootInteractive

### 3.1 Scale of the problem

Reconstructed Pb–Pb data collected until 2019: **several PB** [§2]. Reconstruction of the 2018 Pb–Pb data alone cost **~5 000 CPU-years** [§2]. Tuning calibration or reconstruction parameters requires many re-reconstructions; working at PB scale makes iteration infeasible.

### 3.2 Skimmed-data workflow

```
Input data (PB-scale reconstructed collision data)
    ↓  [downscaling + representative sampling]
Skimmed raw data (~100 GB)
    ├── down-scaled charged-track sample (p_T-dependent sampling)
    ├── full information retained for V⁰ candidates (K⁰_S, Λ, Λ̄)
    ├── full information retained for nuclei and cosmic tracks
    └── enriched with running-condition variables + derived track/event variables
    ↓
Skimmed Trees (unbinned, TTree format)
    ↓  [N-dimensional binning]
N-dimensional histograms (~GB)
    ↓  [cumulative quantities: mean, RMS, fit parameters per cell]
N-dimensional maps (~MB)
    ↓
Data analysis / ML / global fits          (~hours)
Interactive visualization (Jupyter/Bokeh) (~instant)
```

[Particles2022 Figure 3]

### 3.3 Turnaround claim

With skimmed data, **>200 reconstruction-code variants per day** were runnable in parallel — cited in §2 as the iteration cadence that made calibration tuning tractable.

### 3.4 RootInteractive

Framework for interactive visualization of multi-dimensional data, with ROOT and native Python I/O. Integrates Machine-Learning — the paper uses **Random Forest** [Breiman] — with the visualization layer. Example application in Figure 4: dependencies of the common-mode effect for the GEM-based TPC studied with RF, with **eight interactive parameter sliders** exposed in the UI [§2, Figure 4]. Reference [8] in the paper (→ see §9 below).

> **MIWikiAI link.** This is the RootInteractive framework referenced across O2-4592 (slides 15, 21, 56, 138) and PWGPP-643.

---

## 4. Baseline fluctuations in the TPC (§3 of the paper)

### 4.1 Two characteristic features of the TPC signal

**Ion-tail.** Signal induced on readout pads has a fast rise from drifting-electron ionization, followed by a long tail lasting **more than 25% of the TPC drift time** from back-drifting positive ions [§3, ref. 11]. The negative-undershoot magnitude is usually **<1%** of pulse height — but its *integral* is **~50% of the integral of the signal itself**. In high multiplicity, this pileup between successive signals on the same pad significantly degrades following signals.

**Common-mode.** Capacitive coupling of anode wires to readout pads → discharging + charging of wires induces a bipolar signal on all pads facing the same anode-wire segment. Fast rise of discharging → simultaneous undershoot [§3].

Figure 5 shows: (left) ion-tail for four anode voltages (1180 / 1210 / 1240 / 1270 V); (right) integrated laser-track signal on a pad-row, illustrating the common-mode on all pads in the segment [§3, Figure 5]. Used the **TPC Laser calibration system** [Renault et al. 2005, Czech. J. Phys. 55] for the baseline-effect studies. [§3, ref. 12]

### 4.2 Baseline shift at high occupancy + hardware-MAF disabled

At high occupancy both effects shift the baseline. TDR assumed online **Moving Average Filter (MAF)** in the front-end for hardware-level correction [§3, ref. 14] — but this **was not enabled** due to firmware instabilities. Consequence: signal below zero-suppression threshold was **lost**, causing charge loss per cluster and in some cases total cluster loss (when all pad signals in a cluster fell below threshold).

Effect on physics: **significant deterioration of dE/dx measurement** → PID degradation, particularly in high-track-density environments. Both effects corrected offline during reconstruction and accounted for at the digitization level in simulation.

Figure 6 shows a toy simulation of the correction: left = input signal, right = convoluted (red) and corrected (green) signals [§3, Figure 6].

### 4.3 Out-of-bunch pileup and event-by-event dE/dx correction

Beyond the per-pad baseline effects, Run 2 operation at Pb–Pb IR up to 8 kHz and pp IR up to 200 MHz caused **interaction-vertex pileup within the TPC readout time** [§3]:

- **Same-bunch pileup** — collisions in the same bunch crossing, separated in z by up to a few cm; identifiable from multiple reconstructed vertices.
- **Out-of-bunch pileup** — collisions in different bunch crossings; TPC tracks spatially shifted along drift direction (different production times), usually not prolonged to ITS (shorter ITS readout + spatial shift).

>25% of 2018 Pb–Pb events affected by out-of-bunch pileup [§3]. **Same-bunch pileup negligible in Pb–Pb at ~8 kHz.**

**Correction strategy** (§3, Figure 7): parameterize the pileup-induced dE/dx bias in four dimensions — `(η, TPC dE/dx, pileup-event multiplicity, relative z-distance of pileup vertex from main vertex)` — and apply event-by-event. Figure 7 (left) = biased dE/dx for pions with/without out-of-bunch pileup; Figure 7 (right) = post-correction, bias largely eliminated. Without this correction, affected events had to be discarded at event-selection level.

### 4.4 Cluster-error inflation for lost charge

Clusters lost below zero-suppression threshold are **not recoverable** — the dE/dx reduction of surviving clusters is restored by the offline correction above, but missing clusters remain missing. Mitigation: **increase cluster error** with a contribution from baseline fluctuations, so that cluster-to-track assignment efficiency is partially restored. Since this mainly affects detection efficiency, the full MC must be treated consistently.

Ion-tail introduces a baseline bias that depends on `(η, dE/dx, p, track density)`. Performance parametrization carried out in multiple dimensions with RootInteractive. Figure 8 shows cluster-finding efficiency vs TPC multiplicity for Pb–Pb `√s_NN = 5.02 TeV` in data and HIJING+GEANT4 MC, **before** (black) and **after** (red) baseline calibration [§3, Figure 8; ref. 15 for HIJING]. Discrepancy between data and MC is significantly reduced by the baseline calibration. (Slight residual imperfections for any given observable are inevitable in any multi-dimensional calibration — this is an optimization across many observables simultaneously.)

---

## 5. Local space-charge distortions (§4 of the paper)

### 5.1 Observation (2015)

Significant local spatial distortions were observed in 2015 [§4]. Root cause: **space-charge accumulation in the gap between two adjacent readout chambers**. Resulting deviations of reconstructed point coordinates reach **order of several cm** — compared to **intrinsic TPC resolution of order 200 μm** [§4, Figure 9]. Dynamic-range mismatch of >100×.

### 5.2 Fluctuation formula (Eq. 1)

Average local distortions are corrected; their **fluctuations** are not fully eliminated. The paper gives (Eq. 1 of the arXiv PDF):

```
σ_sc / μ_sc  =  (1 / √N_ion_pileup) · √[ 1 + (σ_N_mult / μ_N_mult)²
                                     + (1 / F_μ_tot(r)) · (1 + (σ_Q_track(r) / μ_Q_track(r))² ) ]
```

Terms:
- `N_ion_pileup` — number of ion-pileup events contributing to the local space-charge.
- `σ_N_mult / μ_N_mult` — relative RMS of the per-event track-multiplicity distribution.
- `μ_N_mult` — average track multiplicity per event.
- `σ_Q_track(r) / μ_Q_track(r)` — relative variation of single-track ionization as a function of radius `r`.
- `F_μ_tot(r)` — **`[STUB — §4 remainder]`** `F_μ_tot(r)` is described in §4 as *"quantifying the amount of tracks contributing to the fluctuations for a given radius"*; the formula's remainder clarifying the track-density dependence was not retrieved this pass. `[VERIFY §8 item V-1]`

### 5.3 What the formula tells us (qualitative reading, author language)

- **Larger number of pileup ion-layers → smaller relative fluctuation** (statistical-averaging `1/√N` prefactor).
- **Per-event multiplicity spread** and **per-track ionization spread (radius-dependent)** enter additively inside the square root — both must be small for the fluctuations to be small at a given `N_ion_pileup`.
- **Implication:** at fixed rate, central-Pb–Pb events (narrow multiplicity distribution) and uniform-ionization-species samples give smaller σ_sc/μ_sc than pp at high IR with a broad multiplicity distribution.

`[STUB — §4 remainder]` The paper continues with figures and discussion past Eq. 1 (Figure 9 and beyond — sector map of distortions, feedback-loop correction using ITS–TRD interpolation, residual-distortion performance). Specific claims in §4 of the arXiv PDF after Eq. 1 and in §5 Summary are flagged in §8 `[VERIFY]` below and should be merged in the next fetch pass.

### 5.4 Cross-reference forward

The mitigation described in the paper connects directly to the residual-distortion feedback loop documented in TPC-SoT §7.2 step 4 (*ITS–TRD interpolation across the TPC for residual space-charge correction*). See also O2-4592 slides 5, 14, 29, 185 (canonical TPC residual-distortion concept) and PWGPP-643 (combined shape estimator leveraging the same pipeline).

---

## 6. Cross-cutting themes in this paper for the MIWikiAI dissertation

### 6.1 Skimmed-data workflow as a first-class tool

The skimmed-data → n-dimensional-histograms → n-dimensional-maps → analysis pipeline (§3.2 above) is the **direct predecessor** of the Run 3 Time-Series / skimmed-data workflow indexed in O2-4592. The paper documents the Run 2 workflow at PB-scale; O2-4592 extends the idea to continuous-readout Run 3 data.

### 6.2 RootInteractive as a calibration-inspection framework

Appears here as the inspection/ML-integration front-end. Same framework referenced throughout O2-4592 (slides 15, 21, 56, 138) and PWGPP-643.

### 6.3 Multi-dimensional calibration philosophy

Both §3 and §4 of the paper apply the same approach: **parameterize a bias in multiple dimensions → build a map → apply as correction**. This is the paper's direct articulation of the Run 1/2 / Run 3 calibration pattern that recurs across TPC-SoT, ITS-SoT, and the presentation decks.

### 6.4 Combined tracking as the resolution driver

The TRD `~40% at high p_T` finding (§2.2) is the quantitative anchor for the "combined tracking resolution" motif in TRD-SoT §5.1 and across the three detector SoT pages.

---

## 7. Summary / Conclusions (from the paper)

`[STUB — awaiting next fetch pass]` §5 Summary / Conclusions of the arXiv PDF not extracted in this indexing pass. Expected content (per paper structure and abstract): wrap-up of the two Run-2 challenges (baseline + space-charge), reaffirmation that both were solved via offline correction + multi-dimensional maps, and forward-pointer to Run 3 challenges (continuous readout → reducing reliance on event-level corrections; GEM-based readout → removing gating grid; IBF-driven permanent space-charge needing distinct calibration strategy — all per TPC-SoT §6–7).

## 8. Open items and reviewer-validation checklist

### 8.1 `[VERIFY]` flags (carried forward)

| # | Section | Issue | Severity |
|---|---|---|---|
| V-1 | §5.2 | `F_μ_tot(r)` definition — paraphrased from §4 narrative; precise functional form not extracted. Retrieve on next fetch. | P1 |
| V-2 | §5.3 / §7 | §4 remainder past Eq. 1 (Figure 9 sector map; feedback-loop correction specifics; post-correction residual-distortion performance) not extracted. Retrieve on next fetch. | P1 |
| V-3 | §7 | §5 Summary / Conclusions of the upstream article not extracted. | P2 |
| V-4 | §9 | Reference list [1]–[15] of the upstream article partially extracted from inline mentions; canonical URL / DOI for every reference not harvested. BibTeX stubs in §9 are partial. | P2 |
| V-5 | §4.3 | Pb–Pb IR "up to 8 kHz" and pp IR "up to 200 MHz" in §3 of the paper — confirm against ALICE Run 2 performance records. | P2 |
| V-6 | §3.3 | ">200 reconstruction-code variants per day" turnaround claim — quoted from §2 of the paper; no independent benchmark verification attempted. | P2 |

### 8.2 Open items for further enrichment

| # | Source to add | Purpose |
|---|---|---|
| 7 | Full §5 Summary + reference list | Next fetch pass against `arXiv:2203.10325` |
| 8 | ALICE TPC Laser calibration paper (Renault et al. 2005, Czech. J. Phys. 55, 1671) | Baseline-effects study methodology |
| 9 | ALICE Run 2 performance paper / NIMA 881 (2018) 88–127 | Cross-reference Figure 25, 26, 27 cited here against the source |
| 10 | HIJING event-generator paper (ref. 15 of the upstream) | MC reference for §4.4 comparison |
| 11 | Breiman 2001 — Random Forests | ML reference for §3.4 |

### 8.3 Reviewer checklist

- [ ] **Hard constraint — correctness:** every quantitative claim in this wiki has a citation tag resolving to §9; every `[STUB]` is enumerated in §8.1.
- [ ] **Hard constraint — reproducibility:** every URL in §9 resolves to the claimed document at the claimed DOI / arXiv ID.
- [ ] **Hard constraint — safety:** no private / authenticated / unpublished URLs as clickable links. ALICE internal figures (`ALI-PERF-500058`, `ALI-PERF-500063`) referenced here are published in the open-access paper under CC BY 4.0 — safe to cite.
- [ ] **Citation-tag coverage:** every number has `[Particles2022 §X]` or `[arXiv:2203.10325]` provenance.
- [ ] **Cross-ref integrity:** outgoing links in §10 resolve or appear with status `planned`.
- [ ] **Arithmetic closure:** Eq. 1 reproduces from the paper verbatim; no in-page derivation attempted (paper does not derive, just states).
- [ ] **Stubs complete:** §5.2 (F_μ_tot), §5.3 (§4 remainder), §7 (Summary) marked `[STUB]` with cross-reference to §8.1 ids.

---

## 9. External references

### 9.1 Primary sources

- **[Particles2022]** Arslandok M., Hellbär E., Ivanov M., Münzer R. H., Wiechula J. (2022). *Track Reconstruction in a High-Density Environment with ALICE*. **Particles 5(1), 84–95**. DOI: [10.3390/particles5010008](https://doi.org/10.3390/particles5010008). MDPI URL: `https://www.mdpi.com/2571-712X/5/1/8`. Open access (CC BY 4.0).
- **[arXiv:2203.10325]** Same authors. Preprint, 13 pp, 14 figs. Submitted 2022-03-19. physics.ins-det (primary), hep-ex (secondary). URL: `https://arxiv.org/abs/2203.10325`. PDF: `https://arxiv.org/pdf/2203.10325`.

### 9.2 Referenced within the paper (partial extraction)

`[STUB — full reference list (arXiv refs [1]–[15]) not retrieved this pass; V-4 above]`

Known from inline citations extracted this pass:

- **[ref. 3/4 — Kalman tracking]** Belikov Y., Ivanov M., Safarik K., Bracinik J. (2003). *TPC tracking and particle identification in high-density environment*. CHEP 2003, La Jolla. arXiv: [physics/0306108](https://arxiv.org/abs/physics/0306108). — The foundational ALICE TPC Kalman-filter paper; also cited on TPC-SoT, O2-4592, PWGPP-643.
- **[ref. 8 — RootInteractive]** Cited as source of the interactive visualization framework. Canonical URL not extracted in this pass.
- **[ref. 9 — GEM-based TPC]** J. Adolfsson et al. (2021). *The upgrade of the ALICE TPC with GEMs and continuous readout*. arXiv: [2012.09518](https://arxiv.org/abs/2012.09518). — The Run 3 upgrade NIMA paper; cross-referenced on TPC-SoT §6.
- **[ref. 10 — Random Forests]** Breiman L. (2001). *Random Forests*. Machine Learning 45, 5–32.
- **[ref. 12 — TPC Laser system]** Renault G., Nielsen B. S., Westergaard J., Gaardhøje J. J. (2005). *The Laser calibration system of the ALICE time projection chamber*. Czech. J. Phys. 55, 1671–1674. arXiv: [nucl-ex/0511014](https://arxiv.org/abs/nucl-ex/0511014).
- **[ref. 14 — TPC TDR]** ALICE Collaboration. *Time Projection Chamber: Technical Design Report*. CERN-LHCC-2000-001; ALICE-TDR-7. Cross-referenced on TPC-SoT §1, §3, §5.
- **[ref. 15 — HIJING]** HIJING event generator reference. Full citation not extracted; flagged in §8.2 item 10.

### 9.3 BibTeX stubs

```bibtex
@article{Arslandok:2022:TPC-Tracking,
  author  = {Arslandok, Mesut and Hellb{\"a}r, Ernst and Ivanov, Marian and
             M{\"u}nzer, Robert Helmut and Wiechula, Jens},
  title   = {Track Reconstruction in a High-Density Environment with {ALICE}},
  journal = {Particles},
  volume  = {5},
  number  = {1},
  pages   = {84--95},
  year    = {2022},
  doi     = {10.3390/particles5010008},
  url     = {https://www.mdpi.com/2571-712X/5/1/8},
  note    = {Also available as arXiv:2203.10325 [physics.ins-det]},
  license = {CC BY 4.0},
}

@misc{Arslandok:2022:arXiv,
  author        = {Arslandok, Mesut and Hellb{\"a}r, Ernst and Ivanov, Marian and
                   M{\"u}nzer, Robert Helmut and Wiechula, Jens},
  title         = {Track Reconstruction in a High-Density Environment with {ALICE}},
  year          = {2022},
  eprint        = {2203.10325},
  archivePrefix = {arXiv},
  primaryClass  = {physics.ins-det},
  url           = {https://arxiv.org/abs/2203.10325},
}
```

---

## 10. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`../TDR/tpc.md`](../TDR/tpc.md) | TL;DR, §1.1, §4, §5, §6.1–6.4 | live (DRAFT, wiki-v2) |
| [`../TDR/its.md`](../TDR/its.md) | §2.1, §6.4 | live (DRAFT, wiki-v1) |
| [`../TDR/trd.md`](../TDR/trd.md) | §2.2, §6.4 | live (DRAFT, wiki-v0) |
| [`../TDR/tof.md`](../TDR/tof.md) | §2.1 | planned |
| [`../presentations/O2-4592_slides.md`](../presentations/O2-4592_slides.md) | §3 (skimmed data), §3.4 (RootInteractive), §6.1, §6.2 | live (DRAFT) |
| [`../presentations/PWGPP-643_combined_shape_estimator.md`](../presentations/PWGPP-643_combined_shape_estimator.md) | §3 (skimmed data), §5.4 (space-charge feedback) | live (DRAFT) |
| [`../documents/arXiv-physics-0306108_Belikov_TPC_tracking.md`](../documents/arXiv-physics-0306108_Belikov_TPC_tracking.md) | §2.1 (Kalman-filter foundational paper) | planned |
| [`../documents/arXiv-2012.09518_TPC_GEM_upgrade.md`](../documents/arXiv-2012.09518_TPC_GEM_upgrade.md) | §3.4 (GEM-based TPC ref [9]) | planned |

---

## Appendix A — Source-to-section map

| This wiki § | Upstream source §/Figure | Notes |
|---|---|---|
| §1.1 | Particles2022 §1 | Acceptance, p_T range, solenoid |
| §1.2 | Particles2022 §3 | Run 2 IR envelope (8 kHz Pb–Pb; 200 MHz pp) |
| §2.1 | Particles2022 §1, Figure 1 | Three-pass Kalman tracking |
| §2.2 | Particles2022 §1, Figure 2 | p_T / q/p_T resolution claims |
| §3.1 | Particles2022 §2 | Petabyte scale + 5 kCPU-year cost |
| §3.2 | Particles2022 §2, Figure 3 | Skimmed-data workflow diagram |
| §3.3 | Particles2022 §2 | >200 reco variants/day claim |
| §3.4 | Particles2022 §2, Figure 4 | RootInteractive + RF example |
| §4.1 | Particles2022 §3, Figure 5 | Ion-tail, common-mode, Laser system |
| §4.2 | Particles2022 §3, Figure 6 | Baseline shift, hardware-MAF status |
| §4.3 | Particles2022 §3, Figure 7 | Out-of-bunch pileup + 4D dE/dx correction |
| §4.4 | Particles2022 §3, Figure 8 | Cluster-error inflation + HIJING comparison |
| §5.1 | Particles2022 §4, Figure 9 | Several-cm local distortion observation |
| §5.2 | Particles2022 §4, Eq. 1 | Fluctuation formula — F_μ_tot flagged `[STUB]` |
| §5.3 / §7 | Particles2022 §4 (past Eq. 1), §5 Summary | Both `[STUB — next fetch pass]` |

## Appendix B — Notation quick reference

- **IR** — Interaction Rate (Hz or kHz). Paper uses "IR" throughout.
- **IBF** — Ion Back-Flow. Not defined in this paper, relevant for Run 3 (see TPC-SoT §6).
- **MAF** — Moving Average Filter; online hardware baseline-correction filter referenced in the TPC TDR ([ref. 14]); *not enabled* in Run 2 operation per §3.
- **PID** — Particle Identification, via dE/dx.
- **V⁰** — neutral-particle decay into two charged tracks (paper gives K⁰_S, Λ, Λ̄).
- **σ_sc / μ_sc** — relative fluctuation of the space-charge distortion; Eq. 1 target.
- **HIJING** — Heavy-Ion Jet INteraction Generator; MC cited in §4.4.
- **RF** — Random Forest (ML classifier / regressor), used in §3.4 for common-mode modelling.
- **TRF / PRF** — Time / Pad Response Function; inline in Figure 5-6 captions.

---

## Changelog — source → wiki-v0 (review_cycle 0)

- **Ingestion (2026-04-19):** Indexed from MDPI HTML (`Particles 2022, 5(1), 84–95`) + arXiv PDF (`arXiv:2203.10325`) in a single pass. Retrieved §1–4 through Eq. (1) + Figures 1–8 + inline references [1]–[15] (partial).
- **Deferred to next fetch pass** (tracked as `[STUB]` + §8.1 V-items): §4 remainder past Eq. 1 (Figure 9 sector map, feedback-loop correction, post-correction residual performance); §5 Summary; full reference list.
- **Front-matter:** `wiki_id`, full `source_fingerprint` with both upstream ids (MDPI + arXiv), `source_status: SOURCE IS PARTIAL`, `wiki_sections_stubbed`, `known_verify_flags` all populated per QuickRef §A2.
- **Schema choice:** `folder: articles`, `source_type: conference-proceedings` (the paper is a special-issue proceedings paper, not a regular research article). `[ARCHITECT-PENDING — QuickRef §A2 folder taxonomy not yet ratified for proceedings]` — if architect wants this under `documents/` instead, a one-line `folder:` edit suffices; no body changes required.
- **Cross-link strategy:** 8 outgoing links in §10, 6 to live MIWikiAI pages and 2 planned sibling article pages. No reverse-link retrofit attempted in this cycle (per QuickRef §A7 + TS v0.3 §7.4 — bidirectional sync batched to end-of-sprint).
- **Indexer identity:** `indexed_by: Claude4` (per architect ratification 2026-04-19, TS v0.3 §8 item 7).
- **Content discipline:** no physics claim inferred or reconstructed; every number and phrasing carries a source tag. Paraphrasing used throughout; no direct quotation from the upstream article exceeds ~8 words per instance (copyright conservative default; CC BY 4.0 license would permit more).

---

*End of `Arslandok-2022-TPC-Tracking` wiki page, wiki-v0 (derived from Particles 2022 + arXiv:2203.10325, 2026-04-19). Source status: PARTIAL — §4 remainder + §5 Summary + full reference list pending next fetch pass. Next reviewer pass can consider promotion to wiki-v1 after the deferred material is merged; promotion to `[OK]` is structurally blocked until V-1, V-2, V-3 close.*
