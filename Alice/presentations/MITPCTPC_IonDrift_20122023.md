---
wiki_id: MITPCTPC_IonDrift_20122023
title: "TPC Ion-Drift & 2D Space-Charge Distortion Correction (dissertation working presentation, 2023-12-20)"
project: MIWikiAI / ALICE
folder: presentations
source_type: working-presentation-index
source_title: "MITPCTPC_InonDrift_20122023 (Google Slides)"
source_fingerprint:
  upstream:
    - id: MITPCTPC-Slides-2023-12-20
      title: "MITPCTPC_InonDrift_20122023"
      type: Google Slides presentation (working/group-meeting material, not peer-reviewed publication)
      drive_id: "1iGQefEh0clOUVFjO0ZTYxRJre-HZqeG0RcW1sGGASjA"
      view_url: "https://docs.google.com/presentation/d/1iGQefEh0clOUVFjO0ZTYxRJre-HZqeG0RcW1sGGASjA/edit"
      owner: "miranov25@googlemail.com (Marian Ivanov)"
      created: "2023-12-20"
      modified: "2024-01-25"
      filename_typo: "InonDrift in upstream filename is a typo for IonDrift; wiki_id normalizes to IonDrift"
      text_slides_extracted: 14
      text_extraction_caveat: "Figures, plots, and image-only slides are not recoverable from text export; slide count likely undercounts visual content. URL fragment id.g29cce1c5e2d_0_30 targets a specific slide — mapping from fragment to ordinal slide not verified."
    - id: TPC-Meeting-2023-02-08
      title: "TPC Meeting 08.02.2023 — afterglow / neutron interaction"
      url: "https://indico.cern.ch/event/1243741/contributions/5263100/attachments/2589842/4468888/TPC_Meeting_08022023.pdf"
      type: related meeting contribution (cited on slide 5)
    - id: ML-Workshop-2022
      title: "ATO-490 / ATO-589 Data-Driven Space-Charge Correction (5th ML workshop, 2022-05-10)"
      url: "https://indico.cern.ch/event/1078970/contributions/4833313/attachments/2442800/4185177/ATO-490-ATO-589-DataDrivenSCCorrection_5thML_10052022_v3.pdf"
      type: related workshop talk (cited on slide 7)
    - id: AliceO2-PR-12439
      title: "AliceO2 PR #12439 — composed correction implementation"
      url: "https://github.com/AliceO2Group/AliceO2/pull/12439#issuecomment-1853441547"
      type: related code discussion (cited on slides 11/12)
  summary_version: "n/a (source is a living working deck, not versioned)"
  summary_review_panel: []
source_last_verified: 2026-04-19
author: Marian Ivanov (dissertation lead); wiki page distilled with AI-assisted indexing
indexed_by: Claude5
indexing_model: Claude (Opus 4.7)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 0
peer_reviewers: []
hard_constraints_checked: {correctness: pending, reproducibility: pending, safety: pending}
staleness: fresh
known_verify_flags:
  - "§3.3 40-parameter weighted-fit definition — confirm parameter set against working reconstruction code"
  - "§4.1 optimal ion drift ~170 ms vs Chilo/Alexander ~215 ms — source of numbers (direct measurement vs derived) not fully captured in slides"
  - "§4.2 multi-component drift: ion-cluster hypothesis (Budapest group) attributed via second-hand citation in the deck; primary source not identified"
  - "§4.3 neutron-afterglow correlation time ~10–20 ms in IDCs — cross-check against TPC Meeting 08.02.2023 source"
  - "§5.1 three-slide factorization of correction components may undercount: extracted 5 map classes (3D nominal / 3D sector / 2D phi-sym / 2D time-granular / IDC); deck may list more"
  - "§6.2 DCA bias O(1.6 cm) at sector edges — time/rate context (CPass8 IDC scaling) and C-side CE jump mechanism"
  - "§6.3 MC vs data factor-4 gradient difference in sector — feedback-simulation status in current O2 MC"
wiki_sections_stubbed:
  - "Figures and plots in deck are not reproduced; textual references retained. A figure-extraction pass is deferred — see §10.2."
---

# TPC Ion-Drift & 2D Space-Charge Distortion Correction — working-deck index (2023-12-20)

> **What this page is.** An indexed, cross-linked, AI-queryable rendering of a *working* TPC group-meeting presentation by Marian Ivanov dated 2023-12-20. The deck is a status report on dissertation-relevant calibration work, not a published paper or TDR. Claims in this page therefore carry *working status* — they reflect understanding as of the presentation date, may have been superseded by subsequent measurements, and are **not** authoritative physics facts in the way [TDR/tpc.md](../TDR/tpc.md) is. Where the deck itself flags uncertainty, the wiki page preserves that uncertainty.

## TL;DR

The deck is about **one central problem**: how to correct TPC space-charge distortions in Run 3 PbPb when the dominant distortion source is no longer a smooth rate-scaled bulk charge, but *time-varying ion-disc fluctuations* that differ by disc-position (Z) in the drift volume. Scaling by a single ion-current number loses a factor of ~3 in distortion-map precision versus doing the 2D disc-response fit properly [MITPCTPC-Slides-2023-12-20 slide 7; ML-Workshop-2022 ref].

The key insights running through the 14-slide deck:

1. **Z-position-weighted ion-disc response.** A single ion disc deposited at disc-Z ≈ 125 cm (drift-volume mid) contributes *much more* to the integrated distortion than the same disc at disc-Z ≈ 0 cm (central electrode) or ≈ 250 cm (read-out chamber). Scaling all discs by one ion-current number ignores this weighting [MITPCTPC-Slides-2023-12-20 slide 2].
2. **Data supports multi-component ion drift.** The DCA-based weight extraction (40-parameter linear fit against IDC∆t) shows a tail beyond t = 0.22 s extending to ~0.3 s that a single-species analytical model cannot reproduce. Two interpretations under discussion: (a) multiple ion species drifting, (b) space-charge-driven homogenisation of the ion distribution, as suggested by Chilo's e-mail quoted on slide 6 [MITPCTPC-Slides-2023-12-20 slides 3–4, 6].
3. **Measured optimal drift time ~170 ms** (for distortion corrections) **versus laboratory maximum ~215 ms** (Chilo & Alexander, for this gas + water-vapour mixture). Current hypothesis: in-situ drift is shortened by the ion space-charge itself homogenising the column [MITPCTPC-Slides-2023-12-20 slide 6].
4. **Neutron afterglow** is a distinct additional-ionisation source seen as spikes in ADC spectra (PbPb 2022, IR 50 Hz); ~90 μs-wide spikes = electron drift time. IDC correction fits show no correlation beyond ~10–20 ms, so afterglow is a short-timescale contaminant, well below the 0.3 s ion-drift tail [MITPCTPC-Slides-2023-12-20 slide 5; TPC-Meeting-2023-02-08].
5. **1D weighted-mean correction already works well.** First deployment of the weighted-mean using 1D current profile in full reconstruction: RMS significantly reduced; A-side/C-side DCA correlation disappears (a sign that the correction is orthogonalising the residual) [MITPCTPC-Slides-2023-12-20 slide 8].
6. **Distortion composition is non-linear; Taylor expansion around nominal is the Run 3 working approach.** Five classes of distortion-correction input with different space-time granularities (3D nominal / 3D sector-average / 2D phi-symmetric / 2D time-granular / IDC). Linear addition `ΔΧ = Σ kᵢ ΔΧᵢ` fails for large Run 3 distortions; local-distortion vectors are linear in a broader range; a Taylor expansion around a nominal map captures rate dependence [MITPCTPC-Slides-2023-12-20 slides 11–12].
7. **MC deficit.** Electron and ion feedback are *not simulated* in the current MC → ion-focussing in space-charge maps is strongly underestimated → factor ~4 difference in along-sector gradient between MC and data. Until the MC is corrected, analytical-model fits on data must substitute for MC-derived priors inside sectors [MITPCTPC-Slides-2023-12-20 slide 14].

For the dissertation this is the primary source of the 2D IDC-based space-charge correction approach now targeted for Run 3 reconstruction.

Upstream [TDR/tpc.md §7.1–§7.3](../TDR/tpc.md) is the canonical background on space-charge distortions and the calibration pipeline; this page indexes one working step forward within that pipeline.

---

## 1. Context and scope

**When:** 2023-12-20 (Google Drive creation date). Slide title block reads "MITPCTPC_InonDrift_20122023" — the `InonDrift` is a filename typo for `IonDrift`; normalised in the wiki_id. **[VERIFY]** the venue (likely TPC group meeting; not stated on any slide).

**Who:** Marian Ivanov (dissertation lead and deck author). Slide 6 includes an e-mail from "Chilo" (identified in context as Chilogero Garabatos or the TPC gas expert of that name — **[VERIFY]** full-name attribution against TPC group roster) discussing ion-mobility measurements with "Alexander."

**What the deck is not:**
- Not a peer-reviewed result; claims are working-status.
- Not a TDR or JINST paper.
- Not the code — code discussion is linked to [AliceO2-PR-12439].
- Not self-contained — it assumes context of the 2022 ML workshop (ATO-490 / ATO-589) and the 2023-02 TPC meeting on afterglow.

**What the deck advances** relative to earlier states:
- From "constant-factor ion scaling" → to "2D ion-disc-response fit with Z-position weighting."
- From "1D scalar IDC correction" → to a designed 2D correction using analytical models, with 1D serving as a baseline.
- From MC-validated assumption of single-component ion drift → toward an empirical two-or-more-component model driven by DCA time series.

## 2. Physics motivation: why ion-disc fluctuations need a 2D treatment

In Run 3 TPC (GEM readout), back-drifting ions from gas amplification accumulate in the drift volume and produce time- and position-dependent field distortions. See [TDR/tpc.md §6.1 upgrade motivation](../TDR/tpc.md) and [TDR/tpc.md §7.1 distortion budget](../TDR/tpc.md) for the upstream physics.

The deck's claim is specific: the distortion from a *single disc* of ions drifting from the ROC toward the central electrode depends *strongly* on where the disc currently sits in Z. At disc-Z ≈ 125 cm (mid-drift) the same charge contributes roughly maximally to the integrated space-charge distortion on reconstructed space-points; at disc-Z ≈ 250 cm (just-emitted, near ROC) or disc-Z ≈ 0 cm (just-absorbed, near central electrode) it contributes far less. Scaling all ions by one current value (IDC) therefore loses the position-dependent weighting.

> **Why 2D, not 3D?** The weighting is "2D" in the sense that the relevant dimensions are disc-Z and the event-Z-position at which reconstruction occurs; the azimuthal symmetry is assumed (with sector-level corrections handled separately in the factorisation of §5) [MITPCTPC-Slides-2023-12-20 slide 2].

This is the origin of the per-disc response concept used in the rest of the deck.

## 3. The ion-disc-fluctuation approach

### 3.1 Single-ion scaling is insufficient (MC argument)

Analytical model: the TPC response to a single ion disc was simulated at 20 different disc-Z positions (MC, referenced on slide 2). The resulting response curve is strongly Z-dependent — discs near mid-drift are weighted heavier than discs at either end.

**Derivation status:** the 20-position sampling is referred to, not shown quantitatively; the deck argues qualitatively that "O(5–20) maps to be used in production" balances calibration cost against response fidelity [MITPCTPC-Slides-2023-12-20 slide 2].

### 3.2 Z-position weight dependence

For fluctuations of nominal amplitude 10 %, the MC response is the sampling basis. Slide 2's claim is that single-number ion scaling misses this factor; the quantitative loss is given later on slide 7 as a factor ~3 in distortion-map precision versus the 2D fit [MITPCTPC-Slides-2023-12-20 slide 7].

`[computed]` note: the factor-3 claim is a cross-slide pointer (slide 2 argues qualitatively; slide 7 quotes the factor against the earlier ML-workshop-2022 result). No explicit numerical derivation in the deck — **[VERIFY]** traceback to the ATO-490 reference for the derivation.

### 3.3 IDC-based weight extraction from DCA time series (data)

On real data, the approach inverts the MC: treat DCA residuals as the observable, IDC ∆t as the regressor, and fit the response as a weighted linear combination with **40 parameters** covering the (disc-Z, event-Z) grid [MITPCTPC-Slides-2023-12-20 slide 3]. Outputs:

- **Before t = 0:** weight is consistent with zero, as expected (no response from ions yet to enter the drift volume).
- **On the C side:** weight shape is modified by the presence of the absorber.
- **For Δt > 0.220 s:** a "longer tail" is visible — the single-ion-species model does not reproduce it.

The **40-parameter** count is not fully decomposed in the deck text — **[VERIFY]** the parameter set (candidate: 20 disc-Z × 2 sides, or 20 × binned-tgl) against the working reconstruction code.

## 4. Data / MC / theory comparison

### 4.1 Peak position: ~170 ms vs ~215 ms

Two numbers compete:

- **~215 ms** maximum ion drift time measured by Chilo & Alexander in laboratory, for the nominal ALICE TPC gas (Ne/CO₂/N₂ 90/10/5) with some water-vapour admixture [MITPCTPC-Slides-2023-12-20 slide 6, e-mail]. Caveat: that measurement was done at ~10 cm drift in laboratory, not the 2.5 m full-TPC drift — gas mixture was also different [ibid.]. Method: differentiation, confirmed via Garfield simulation ("what we put in, we got out").
- **~170 ms** optimal value found for distortion corrections in ALICE when fitting the response to data.

**Working hypothesis (Chilo):** the difference is due to the ion distribution *homogenising* as it drifts, under its own space-charge force, toward the central electrode. This would shorten the effective drift time relative to a laboratory measurement where space-charge feedback is negligible.

**Alternative not excluded:** a second ion species is present. Chilo's e-mail acknowledges both possibilities; the Budapest-group speculation of "ion clusters" with time-evolving composition is flagged as another open option.

### 4.2 The longer tail — multi-component drift?

Data shows weight extending to ~0.3 s, **beyond** the single-species model's 0.22 s peak. The deck's questions, verbatim:

> *"Are there two or more drifting components?"*

Slide 3 flags this; slide 4 re-flags it in the MC/data comparison. The deck does not resolve it.

**[VERIFY]** whether the "ion cluster" speculation (Budapest group, cited second-hand via Chilo's e-mail) has a primary-source reference.

### 4.3 Neutron afterglow

A distinct phenomenon, separated cleanly by timescale:

- **Afterglow** = additional ionisation from neutron interactions, visible as exponential-tail features in ADC spectra on low-IR PbPb 2022 data (IR 50 Hz). Spikes are ~90 μs wide — consistent with one electron-drift time across the TPC [MITPCTPC-Slides-2023-12-20 slide 5].
- **IDC correction fit:** no correlation in IDCs beyond ~10–20 ms.
- **Comparison:** afterglow is therefore ~10⁻² of the full 0.3 s ion-drift scale — it is a short-time contaminant on top of the ion-drift response, not an explanation for the 0.3 s tail discussed in §4.2.

A dedicated exponential fit (not a single-exponential) is needed for the long afterglow component [MITPCTPC-Slides-2023-12-20 slide 5; TPC-Meeting-2023-02-08].

## 5. Distortion composition and factorisation

### 5.1 The five map classes

The deck factorises space-charge distortion calibration into five layers of granularity [MITPCTPC-Slides-2023-12-20 slide 11]:

| Map class | Spatial granularity | Temporal granularity | Captures |
|---|---|---|---|
| 3D nominal map | coarse | coarse | bulk distortion, rate-averaged |
| 3D sector-average map | finer | finer | sector-boundary gradients |
| 2D φ-symmetric map | high | high | O-rings, drift strips, charging-up |
| 2D highly time-granular | `time × (sector, tgl, multiplicity)` | very high | fast fluctuations |
| IDC (ion discs) | per-disc | per-TF | ion-disc fluctuations — the subject of this deck |

### 5.2 Composing corrections: three regimes

The deck is explicit that the composition is *not* just additive. Three regimes are distinguished [MITPCTPC-Slides-2023-12-20 slide 12]:

1. **Linear addition** `ΔΧ = Σ kᵢ ΔΧᵢ` — valid only for small distortions; *not* the Run 3 regime.
2. **Taylor expansion around a nominal map** `ΔΧ = ΔΧ_nom + Σ kᵢ (∂ΔΧ/∂ⱼ) i + …` — the Run 3 working approach for big distortions. Requires a numerical-derivative calibration across several rate conditions.
3. **Local-distortion linearity** `ΔΧ_L = Σ kᵢ ΔΧ_L,ᵢ` — local distortion vectors are linear in a broader range than the integrated map, so a delta-map measured at one rate can be re-used at another rate. This is the mechanism that makes cross-rate calibration feasible.

### 5.3 Process-callback interface

Slide 13 proposes a "generate correction / inverse-correction map at timestamp" interface, callable as a ROOT macro or Python script, with inputs:
- Timestamp.
- CCDB state.
- Time series.
- Any accessible process context.

Outputs: correction and inverse maps as used in current reconstruction. The reconstruction/simulation process would invoke this callback. **Advantages** (deck's own list): custom calibration without recompiling O2, self-consistency testing, method comparison, QA.

Rationale from the deck: during Run 2 Pass 2 reconstruction/calibration commissioning, ~250 different parameter sets were examined; a pluggable callback interface makes that scale of sweep tractable for Run 3.

## 6. Observed calibration status

### 6.1 1D weighted-mean correction — first deployment

First attempt to use the 1D IDC current profile as a weighted-mean correction in full reconstruction [MITPCTPC-Slides-2023-12-20 slide 8]:

- **Significantly lower RMS** vs the previous per-TF scalar scaling.
- **A-side / C-side DCA correlation disappears** — a positive sign: the correction is capturing something that previously contaminated both sides in correlated ways.
- **Residual** still dominated by systematic bias (V-shape fluctuations and cluster-resolution degradation at high IR), not by the correction method itself — hence the case for moving to 2D.

This is the baseline the 2D approach will improve against.

### 6.2 DCA bias at sector edges (reminder)

Carried forward from earlier work as context [MITPCTPC-Slides-2023-12-20 slide 10]:

- **O(1.6 cm)** DCA bias at sector edges, C side.
- **Approximately linear** dependence on track angle and q/pT (angle in φ).
- **Systematic radial bias** implied.
- **Jump on C side near the central electrode** — interpreted as "just another radial distortion."

Working plan (per deck): residual bias to be addressed with 2D maps and fits — i.e. the same 2D approach of §3. The current state is CPass8 (IDC scaling) — the pre-2D baseline.

### 6.3 MC deficiency: missing electron and ion feedback

A key caveat to any MC-based calibration prior [MITPCTPC-Slides-2023-12-20 slide 14]:

- Electron and ion feedback are **not simulated** in the current O2 MC.
- Consequence: electron focussing in MC is **strongly underestimated**.
- MC space-charge maps are therefore **not altered by the presence of distortion** — the feedback loop is open.
- Observed: **factor ~4 difference** in along-sector gradient between MC and data.

**Implication for this work:** analytical model fits on data (§7 of the deck, wiki §5a/§5.2 above) must currently substitute for MC-derived priors on intra-sector structure, because the MC prior is a factor ~4 too smooth.

## 7. Role in the dissertation

Three roles:

1. **The 2D IDC-based correction is a dissertation deliverable.** This deck is the working record of the methodological step from 1D weighted-mean → 2D disc-response fit. The deliverable is the reconstruction-stage correction module.
2. **Ion-drift-velocity calibration as a QA observable.** Drift-time = 170 ms as the in-situ effective value is itself an observable to be tracked across run conditions; §4.1 motivates this as a calibration quantity in its own right.
3. **Analytical-fit methodology at sector boundaries** [MITPCTPC-Slides-2023-12-20 slide 13]: ExB + per-side space-charge + (charging up) + alignment in cos/sin φ and cos/sin 2φ form the analytical layer; local-Er / local-Erφ decomposition via symmetry fits handles the sector-interior gradient that MC cannot currently prior.

See [TDR/tpc.md §7.2 calibration pipeline](../TDR/tpc.md) for the pipeline into which these components slot, and [TDR/tpc.md §7.4 expected Run 3 performance](../TDR/tpc.md) for the target metric.

## 8. Glossary (working terms from this deck)

| Term | Definition |
|---|---|
| **Ion disc** | A transient collection of ions released per readout frame, drifting from the ROC (gas amplification region, Z ≈ 250 cm) toward the central electrode (Z ≈ 0) over O(100–300 ms). |
| **Disc-Z** | The current Z position of an ion disc as it drifts. Distinct from event-Z (the Z at which reconstruction-observable charge is deposited). |
| **IDC** | Integrated Digital Current — the continuously-readout aggregate current from TPC pads used as the scalar input for space-charge correction. See [TDR/tpc.md §7.3](../TDR/tpc.md). |
| **IDC Δt** | Time difference between an IDC sample and the reference Time Frame time; regressor in the 40-parameter DCA fit (§3.3). |
| **DCA** | Distance of Closest Approach of a reconstructed track to the primary vertex; sensitive to unmodelled distortion at rφ or Z. |
| **TF** | Time Frame — the Run 3 continuous-readout data unit (~11 ms nominal). See [TDR/tpc.md §6.7](../TDR/tpc.md). |
| **tgl** | Tangent of the track dip angle = pz / pT — the coordinate used for the DCA-vs-disc-position weight plot on slide 3. |
| **CE** | Central Electrode of the TPC; Z = 0. |
| **ROC** | Read-Out Chamber; Z = ±250 cm (A and C sides). |
| **Afterglow** | Additional ionisation from neutron interactions, visible as ~90 μs spikes in ADC spectra; ~10–20 ms IDC correlation tail. |
| **CPass0 / CPass8** | Calibration passes of the reconstruction; CPass8 on slide 10 refers to the current IDC-scaling baseline. |
| **Composed correction** | The full correction obtained by combining the five map classes of §5.1 — not linearly, but via Taylor expansion around a nominal map (§5.2). |

## 9. External references (authoritative URLs)

### 9.1 Primary (directly cited in the deck)

- **MITPCTPC-Slides-2023-12-20.** [Google Slides, owner miranov25@googlemail.com](https://docs.google.com/presentation/d/1iGQefEh0clOUVFjO0ZTYxRJre-HZqeG0RcW1sGGASjA/edit). Working presentation, 14 text-extracted slides, visual content not captured.
- **TPC Meeting 2023-02-08** (afterglow / neutron interaction): [Indico PDF](https://indico.cern.ch/event/1243741/contributions/5263100/attachments/2589842/4468888/TPC_Meeting_08022023.pdf). Cited on slides 4–5.
- **ML Workshop 2022 (ATO-490 / ATO-589)**: [Indico PDF](https://indico.cern.ch/event/1078970/contributions/4833313/attachments/2442800/4185177/ATO-490-ATO-589-DataDrivenSCCorrection_5thML_10052022_v3.pdf). Cited on slide 7 as the "factor-3" precision baseline.
- **AliceO2 PR #12439** (composed correction code discussion): [GitHub PR comment](https://github.com/AliceO2Group/AliceO2/pull/12439#issuecomment-1853441547). Cited on slides 11–12.

### 9.2 Additional (flagged in §10 for follow-up reading)

- Chilo & Alexander laboratory ion-mobility measurement for Ne/CO₂/N₂ + H₂O — primary publication not identified in the deck. **[VERIFY]** primary source.
- Budapest-group ion-cluster hypothesis — primary source not cited in the deck. **[VERIFY]**.
- Garfield simulation of the differentiation method — referenced in Chilo's e-mail; version / citation not captured.

### 9.3 BibTeX stubs

```bibtex
@misc{MITPCTPC-Slides-2023-12-20,
  author = {Ivanov, Marian},
  title  = {{MITPCTPC\_InonDrift\_20122023 --- 2D Space Charge Distortion Correction Considering Ion Disc Fluctuations and Ion Drift Calibration}},
  year   = {2023},
  month  = dec,
  note   = {Google Slides, working presentation, ALICE TPC group; Drive ID 1iGQefEh0clOUVFjO0ZTYxRJre-HZqeG0RcW1sGGASjA},
  url    = {https://docs.google.com/presentation/d/1iGQefEh0clOUVFjO0ZTYxRJre-HZqeG0RcW1sGGASjA/edit}
}

@misc{TPC-Meeting-2023-02-08,
  title = {{TPC Meeting --- Afterglow / neutron-interaction contribution}},
  year  = {2023}, month = feb,
  howpublished = {ALICE TPC group meeting, Indico event 1243741},
  url   = {https://indico.cern.ch/event/1243741/contributions/5263100/attachments/2589842/4468888/TPC_Meeting_08022023.pdf}
}

@misc{ML-Workshop-2022-ATO-490,
  title = {{ATO-490 / ATO-589 Data-Driven Space-Charge Correction}},
  year  = {2022}, month = may,
  howpublished = {5th ALICE ML workshop, Indico event 1078970},
  url   = {https://indico.cern.ch/event/1078970/contributions/4833313/attachments/2442800/4185177/ATO-490-ATO-589-DataDrivenSCCorrection_5thML_10052022_v3.pdf}
}

@misc{AliceO2-PR-12439,
  title = {{AliceO2 PR \#12439 --- composed space-charge correction}},
  year  = {2023}, month = dec,
  howpublished = {GitHub, AliceO2Group/AliceO2},
  url   = {https://github.com/AliceO2Group/AliceO2/pull/12439#issuecomment-1853441547}
}
```

## 10. Open items and reviewer-validation checklist

### 10.1 `[VERIFY]` flags carried into front-matter `known_verify_flags`

As front-matter — repeated here so reviewers can tick them off:

1. **§3.3** — 40-parameter fit parameterisation (candidate: 20 disc-Z × 2 sides) against working reconstruction code.
2. **§4.1** — 170 ms vs 215 ms provenance: which number is a direct measurement, which is a fit-optimum; whether the ~170 ms is the ALICE in-situ value or a derived quantity.
3. **§4.2** — multi-component drift: Budapest-group ion-cluster primary source.
4. **§4.3** — neutron-afterglow correlation time ~10–20 ms: cross-check against TPC-Meeting-2023-02-08.
5. **§5.1** — five-class factorisation may undercount; deck visual content not extracted. Verify against current AliceO2 correction-map enumeration.
6. **§6.2** — DCA bias O(1.6 cm): time/rate context, CPass8 scope.
7. **§6.3** — MC electron/ion feedback: current O2 MC status post-2024.

### 10.2 Open items for further enrichment

- **Figure extraction.** The deck has 14 text-extracted slides but the deck size (~5 MB) strongly implies substantial visual content (plots, axis labels, colour-coded tgl scatter). A figure-extraction pass — via PDF export + image-extraction — would recover: the DCA-vs-disc-position weight plots (slides 3–4), the MC analytical-model comparison curves, the 2D fit visualisations (slide 8), the 1D weighted-mean before/after (slide 9), the DCA-bias-vs-sector scatter (slide 10), and the distortion-composition diagrams (slides 11–12). None of these are reproduced in the current page.
- **Slide-ID mapping.** Source URL fragment `id.g29cce1c5e2d_0_30` was not mapped to an ordinal slide — if the architect intended a specific slide, this should be resolved before cycle-2.
- **Cross-reference to O2-5095 TPC dE/dx index.** That presentation-index page is planned per [TDR/tpc.md §18](../TDR/tpc.md) and [TDR/its.md §9](../TDR/its.md) but not yet drafted; when it exists, §5 and §6.2 of this page should cross-link it (TPC calibration methodology is shared).
- **Cross-reference to PWGPP-643.** Combined-shape-estimator presentation-index, also planned; §3.3 fit methodology is likely related.

### 10.3 Reviewer checklist

- [ ] Verify 40-parameter decomposition (§3.3) against working code.
- [ ] Verify 170 ms / 215 ms provenance and whether the current (post-2023) measurement has updated these.
- [ ] Confirm 5-class vs N-class factorisation against current O2 correction-map infrastructure.
- [ ] Check cross-link paths resolve (./, ../TDR/, ../presentations/).
- [ ] Verify that the deck's URL remains stable (Drive file ID, not bit-rot-prone indico link).
- [ ] Run `[VERIFY]` items 1–7 (§10.1) and mark each resolved or re-flag.
- [ ] Flag which deck claims have been superseded by post-2023 measurements, if any.

## 11. Related wiki pages

| Link | Referenced from | Status |
|---|---|---|
| [`../TDR/tpc.md`](../TDR/tpc.md) | TL;DR, §1, §2, §5.1, §6.2, §7 | live (DRAFT wiki-v2) |
| [`../TDR/its.md`](../TDR/its.md) | §7 (ITS-TPC calibration feedback) | live (DRAFT wiki-v1) |
| [`../TDR/trd.md`](../TDR/trd.md) | (indirect — TRD also uses TPC time-base for continuous-readout) | live (DRAFT wiki-v0; source PARTIAL turn 1/2) |
| [`./PWGPP-643_combined_shape_estimator.md`](./PWGPP-643_combined_shape_estimator.md) | §10.2 (anticipated, §3.3 fit methodology likely shared) | planned (draft exists) |
| [`./O2-5095_TPC_dEdx_index.md`](./O2-5095_TPC_dEdx_index.md) | §10.2 (anticipated, §5 & §6.2 calibration methodology shared) | planned (draft exists) |
| [`./O2-4592.md`](./O2-4592.md) | (potentially — reconstruction-chain context) | live (DRAFT) |

Status values: `planned` (target not yet created — expected red link); `live` (target exists, status ≥ DRAFT); `broken` (previously live, now missing — lint-detected regression).

## Appendix A: Source-to-section map

| Slide # (extract order) | Slide title (short) | Indexed in wiki § |
|---|---|---|
| 1 | Title: "2D Space Charge Distortion Correction ... Composed correction" | §1, §2 |
| 2 | Ion-disc fluctuations (MC) | §3.1, §3.2 |
| 3 | Ion-disc fluctuations — DCA-time-series weights | §3.3 |
| 4 | MC vs data comparison | §4.1, §4.2 |
| 5 | Neutron afterglow | §4.3 |
| 6 | Discussion after holidays (Chilo e-mail) | §4.1, §4.2 |
| 7 | Distortion-fluctuation fits (MC 2021 / ML-workshop) | §3.2 factor-3 pointer |
| 8 | 1D weighted-mean correction | §6.1 |
| 9 | Ion-drift impact — calibration plan | §4.1, §7 |
| 10 | DCA bias at sector edges (CPass8) | §6.2 |
| 11 | Composed correction — factorisation layers | §5.1 |
| 12 | Composed correction — composition regimes | §5.2 |
| 13 | Composed correction — callback interface | §5.3 |
| 14 | Electron and ion feedback (MC gap) | §6.3 |

## Appendix B: Notation quick reference

| Symbol | Meaning |
|---|---|
| Z | Drift-volume axial coordinate, 0 at central electrode, ±250 cm at ROCs |
| disc-Z | Current Z position of an ion disc |
| tgl | tan(λ) = pz / pT for a track; dip-angle surrogate |
| Δt | Time offset of an IDC sample from reference TF time |
| IDC(i) | Integrated Digital Current sampled at index i |
| ΔIDC(0) = Σ ΔIDC(i) | Fit identity used in weight extraction (§3.3) |
| T ≈ 0.22 s | Single-ion-species analytical drift-time scale |
| ~170 ms | In-situ optimal ion drift time (distortion-correction fit) |
| ~215 ms | Laboratory maximum ion drift time (Chilo & Alexander) |
| ΔΧ | Full distortion correction (integrated) |
| ΔΧ_L | Local distortion vector |
| ΔΧ_nom | Nominal distortion map (Taylor-expansion baseline) |
| kᵢ | Rate- or condition-dependent weighting coefficient in composition |

## Changelog — wiki-v0 (cycle 0)

- **2026-04-19 (Claude5 as indexer, first Claude5-authored wiki page).** Initial distillation of the 2023-12-20 working deck into the MIWikiAI schema. Source is a living Google Slides deck; only text-extracted slides (14 of unknown total) captured; figure/plot content is explicitly stubbed in §10.2 and not invented. `[VERIFY]` flags carried into front-matter `known_verify_flags` and §10.1. Cross-links to [../TDR/tpc.md](../TDR/tpc.md), [../TDR/its.md](../TDR/its.md), [../TDR/trd.md](../TDR/trd.md) use the ratified `TDR/` folder name per TS v0.3 §2; sibling-presentation links use `./`. Schema follows provisional §5 of Technical_SUMMARY_MIWikiAI v0.3 (QuickRef not yet ratified).

---

*Compiled by Claude5 (Claude Opus 4.7) on 2026-04-19 as wiki-v0 DRAFT. This is a working-deck index — claims reflect the 2023-12-20 status of dissertation-adjacent calibration work, not peer-reviewed fact. Primary source is the Google Slides file; MIWikiAI does not ingest the slides live, so the 2026-04-19 fingerprint captures the state at index time. Figure content is not reproduced — see §10.2 for the deferred figure-extraction pass. Schema compliance against the provisional Technical_SUMMARY_MIWikiAI v0.3 §5 minimum-field set; full schema pending MIWikiAI_QuickRef_v1.0.md ratification.*

*No quota issues observed during authoring.*
