# The ALICE Transition Radiation Detector (TRD) — Source of Truth v0.3

```
PDF read: yes, cer-2275567.pdf (188 pp, full text extracted via pdftotext);
          partial, 2008_JINST_3_S08002.pdf §6 (pending separate pass).
Coder:    Main Coder Claude2. PDF-verification pass this revision.
Status:   DRAFT — Turn 1 delivers §§1–5. Turn 2 will deliver §§6–10 + full changelog.
```

**Scope:** TRD as deployed from Run 1 through Run 3, with its readout and trigger evolution. Intended as the normative reference for the dissertation chapter; every numerical claim carries a primary-source tag referencing section, table, or page (no raw `pdftotext` line numbers — they do not survive re-extraction).

**Primary sources:**
- `[TRD-TDR]` — ALICE Collaboration, *Technical Design Report of the Transition Radiation Detector*, CERN/LHCC 2001-021 / ALICE TDR 9 (3 October 2001). Table 1.1 is the authoritative parameter summary.
- `[JINST2008]` — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002, §6 (TRD). Partial read; full-pass deferred.
- `[TDR-019]` — ALICE Collaboration, *Technical Design Report for the Upgrade of the Online-Offline Computing System*, CERN-LHCC-2015-006 / ALICE-TDR-019 (2015). Used for Run 3 continuous-readout interface.
- `[VERIFY]` tag = claim not yet cross-checked against a primary source.

---

## BibTeX entries required in `bibliography.bib`

```bibtex
@techreport{ALICE-TRD-TDR,
  author = "{ALICE Collaboration}",
  title = "{Technical Design Report of the Transition Radiation Detector}",
  institution = "CERN", number = "CERN-LHCC-2001-021, ALICE-TDR-9",
  year = "2001", month = "Oct"
}
@article{JINST2008,
  author = "{ALICE Collaboration}", title = "{The ALICE experiment at the CERN LHC}",
  journal = "JINST", volume = "3", pages = "S08002", year = "2008",
  doi = "10.1088/1748-0221/3/08/S08002"
}
@techreport{ALICE-TDR-019,
  author = "{ALICE Collaboration}",
  title = "{Technical Design Report for the Upgrade of the Online-Offline Computing System}",
  institution = "CERN", number = "CERN-LHCC-2015-006, ALICE-TDR-019", year = "2015"
}
```

---

## 1. Purpose and role of the TRD

The Transition Radiation Detector occupies the radial range **2.90 m to 3.68 m** inside the ALICE central barrel [TRD-TDR Table 1.1], sandwiched between the TPC (outer radius ~2.5 m) and the TOF (inner radius ~3.7 m). It consists of **540 radial drift chambers** organised as 18 supermodules × 5 stacks in z × 6 layers in r [TRD-TDR §1; Table 1.1]. The TRD provides three complementary functions that together motivated its construction:

**(1) Electron identification** for momenta above the regime where TPC dE/dx alone separates electrons from hadrons (p ≳ 1 GeV/c). The principal physics motivation is heavy quarkonia (J/ψ, Υ) reconstructed via their dielectron decay, and open heavy-flavour measurements via semileptonic electron channels. The TRD complements the TPC rather than replacing it: below ~1 GeV/c the TPC dE/dx 1/β² region already separates electrons cleanly from pions, but above that momentum the curves cross and TPC dE/dx alone becomes statistical.

**(2) Tracking.** The six-layer drift-chamber stack contributes to the global ALICE track fit. Each layer provides up to 15 drift-time samples (see §4), which combine into a single **tracklet** — a short straight-line segment internal to one chamber. Matched across six layers, TRD tracklets extend the barrel track lever arm from the TPC outer radius to ~3.7 m, improving σ(p_T)/p_T at high transverse momentum and providing a rigid external constraint on TPC space-charge distortions (§5.5 below).

**(3) Fast Level-1 trigger** (Run 1 and Run 2). On-detector electronics reconstructs tracklets in ~6 µs after the collision. Tracklets are aggregated by the off-detector Global Tracking Unit (GTU), which issues L1 triggers on high-p_T tracks, jets, and electron candidates. This was unique among ALICE central-barrel subdetectors during triggered operation; in Run 3 the L1 role is dissolved because continuous readout records every collision (§5.4).

**Acceptance summary:** |η| < 0.9 [TRD-TDR §1, p. 23; Table 1.1], full azimuth (18 supermodules, 20° each), active area **736 m²** [TRD-TDR §1, p. 27], gas volume **~27 m³** of Xe/CO₂ [TRD-TDR §1, p. 23; Table 1.1].

## 2. Transition radiation — physics principle

### 2.1 Emission mechanism

Transition radiation is electromagnetic radiation emitted when a charged particle crosses the interface between two media with different dielectric constants. The radiation spectrum is dominated by soft X-rays (photon energies of a few keV for high-γ particles), and the total emitted energy per interface is proportional to the particle's Lorentz factor γ = E/mc².

**Why γ drives the electron/pion separation:** at the same momentum p, two particles with masses m₁ and m₂ have Lorentz factors in the ratio γ₁/γ₂ = m₂/m₁. For electrons and pions, this ratio is m_π/m_e ≈ **275**. At p = 1 GeV/c this means γ_e ≈ 2000 while γ_π ≈ 7 — an enormous disparity. Electrons emit transition radiation efficiently above γ ≈ 1000, while pions at the same momentum are still far below the emission threshold, emitting essentially none.

### 2.2 Formation zone and radiator design

TR emission from a single interface is small — typically α × 1/137 photons emitted per crossing, and the photons are strongly forward-peaked. Efficient TR generation therefore requires many interfaces per radiator. The radiator must satisfy two competing constraints:

- **Dense interfaces for yield:** the emission from successive interfaces adds coherently within the **formation zone** ζ ≈ γλ/(2π), which at γ = 2000 and λ ~ 0.2 nm (5 keV photon) is of order hundreds of micrometres. Interfaces closer together than ζ interfere; interfaces further apart than ζ add incoherently.
- **Low material budget:** TR photons are easily reabsorbed in the radiator itself before reaching the detector gas. The radiator must be dense enough to maximise interface density yet thin enough in radiation length to preserve the transition radiation.

**ALICE TRD solution:** each of the six layers carries a **4.8 cm radiator** built as a fibre/foam sandwich [TRD-TDR Table 1.1; §14]. The fibres provide high interface density at low mean density; the foam provides mechanical rigidity. Measurements in test beams demonstrated yield of roughly one to two detected TR photons per minimum-ionising electron per layer, sufficient for ~100× pion rejection over six layers at 90% electron efficiency.

### 2.3 Photon detection in the drift gas

TR photons enter the drift chamber and are absorbed in the xenon component of the **Xe/CO₂ (85/15)** gas mixture [TRD-TDR §1, p. 23]. Xenon is chosen for its high atomic number (Z = 54): the photoelectric cross-section scales approximately as Z⁵ in the few-keV range, giving xenon an absorption length of about 1–2 cm at 5 keV `[VERIFY: Xe absorption-length reference]`. Absorption deposits the full photon energy locally as a compact cluster of ionisation electrons. These cluster charges superimpose on the primary ionisation trail of the traversing particle (~275 electrons per cm in Xe/CO₂ 85/15 [TRD-TDR §1, p. 23]), appearing as a characteristic peak near the radiator-side end of the drift-time distribution.

The sorting between pion (no TR) and electron (TR present) is therefore a **pattern-recognition problem in the charge-vs-drift-time distribution**, not a simple integrated-charge discrimination. The 15 time bins of the drift-time readout (§4) are precisely what enables this discrimination — a single integrated dE/dx value per track, as an all-in-one calorimeter would provide, is substantially less powerful.

## 3. Chamber design

### 3.1 Overall structure

The 540 readout chambers are radial multiwire proportional chambers with cathode-pad readout. Chambers are arranged in a gently curved **projective geometry**: chamber width increases with radius, and adjacent chambers align radially to the interaction point so that high-p_T tracks cross a single chamber cleanly [TRD-TDR §1, p. 27]. The largest individual chamber measures 120 × 159 cm² [TRD-TDR Table 1.1]; supermodules span the full 6-layer radial depth and half the z range.

Each chamber comprises, in order along the drift direction from outside inwards:
1. **Radiator**, 4.8 cm of fibre/foam sandwich [TRD-TDR §14].
2. **Drift region**, 3.0 cm [TRD-TDR Table 1.1], bounded by the radiator on one side and the anode wire plane on the other, with a uniform drift field of **700 V/cm (0.7 kV/cm)** [TRD-TDR Table 1.1].
3. **Amplification region**, 0.7 cm [TRD-TDR Table 1.1], containing the anode wire grid at 5 mm pitch [TRD-TDR §4.3].
4. **Cathode pad plane** with 144 pads in the rφ direction per chamber and 12 to 16 pad rows in z depending on layer and stack position [TRD-TDR §1; Table 1.1]. Pads are typically 6–7 cm² in area [TRD-TDR §1, p. 27].

### 3.2 Gas and drift dynamics

**Gas composition.** Xe/CO₂ 85/15 by volume [TRD-TDR §1]. Xenon provides transition-radiation absorption through the photoelectric effect; CO₂ quenches ultraviolet photons from ionisation avalanches and stabilises the gain. The total chamber gas volume of the full detector is ~27 m³ [TRD-TDR §1, p. 23] — substantial because xenon is expensive, which motivated dedicated recirculation and purification systems.

**Drift velocity.** v_d = **1.5 cm/µs** [TRD-TDR §1; §4.1.1]. The TDR states explicitly: *"We have chosen a drift velocity of 1.5 cm/µs"* [TRD-TDR §4.1.1], corresponding to a drift time of **2.0 µs** over the 3.0 cm drift region. The Lorentz angle at the nominal ALICE magnetic field is approximately 8° at B = 0.4 T [TRD-TDR §1, p. 27]; the ALICE operational field is 0.5 T, so the as-deployed Lorentz angle is slightly larger `[VERIFY: operational Lorentz angle]`.

**Gas gain.** Nominal design: **5 × 10³** [TRD-TDR §1, p. 27]. Prototype measurements achieved gain of 8000 at an anode voltage U_a = 1420 V [TRD-TDR §4.6.1], with the TDR recommending an operational ceiling not exceeding 10⁴. Run 1/2 as-operated values `[VERIFY: TRD operations note]`.

**Primary ionisation.** A minimum-ionising particle liberates approximately **275 electrons per cm** in Xe/CO₂ 85/15 [TRD-TDR §1, p. 27]. Combined with the 3 cm drift region, this means ~825 primary electrons per track per chamber before gas gain. The TR photon absorption adds a localised cluster of several hundred to a thousand additional electrons at the radiator-side end of the drift profile for electron-emitted photons.

**Diffusion.** Negligible over the drift distance at the operating drift field [TRD-TDR Table 1.1].

### 3.3 Total pad count

The full detector contains **1 156 032 pads ≈ 1.16 × 10⁶** [TRD-TDR §4.4]. Arithmetic from the pad-plane layout: 144 pads per row (rφ direction) × 70–76 rows per layer (z direction, layer-dependent) × 6 layers × 18 supermodules. This is the largest channel count among ALICE central-barrel detectors in Run 1–2 and remains so in Run 3.

### 3.4 Material budget

**Total six-layer stack: 14.3% X₀** [TRD-TDR Table 1.1]. Per-layer ≈ **2.4% X₀**. The 4.8 cm fibre/foam radiator accounts for the dominant fraction of the per-layer budget; remaining contributions come from the chamber gas envelope, cathode pad plane, support structure, and on-chamber front-end electronics.

*Footnote:* TRD-TDR §1 prose states *"less than 14%"* as a rounded figure; Table 1.1 gives the precise design value 14.3%. v0.3 cites the table as the authoritative normative source; the prose figure is consistent within rounding.

## 4. Readout electronics

### 4.1 On-chamber front-end architecture

Each readout chamber carries its front-end electronics directly on the back of the pad plane, organised into **Multi-Chip Modules (MCMs)**. The MCM is the physical package; its internal architecture comprises three distinct functional elements that must not be conflated:

- **PASA** — the PreAmplifier/ShAper ASIC. A charge-sensitive preamp followed by a semi-Gaussian shaper, one channel per readout pad. Shaping time is matched to the 2 µs drift window.
- **ADC** — a 10-bit analog-to-digital converter, one per channel, clocked at **10 MHz** [TRD-TDR Ch. 7].
- **TRAP** — the TRD digital tracklet processor chip. Receives the digitised samples from the ADC, performs on-chip filtering (tail cancellation of the long ion-drift signal tail), stores the samples in time-bin memory, and computes a straight-line tracklet within the chamber using a built-in linear-fit unit.

The MCM provides digital communication with the off-detector readout and trigger systems. Each MCM handles a small group of pads — of order 16–18 channels — and the tracklet computation is local to the chamber.

### 4.2 Time sampling

Drift-time information is recorded as **15 time bins of 133 ns** spanning the 2 µs drift window [TRD-TDR §4.5; Table 1.1]. The relationship to the 10 MHz ADC clock requires care:

- The ADC clock runs at 10 MHz (i.e. 100 ns intervals).
- Only 15 bin samples at 133 ns effective spacing are stored per drift window after on-chip filtering and decimation.
- 15 × 133 ns = 1.995 µs ≈ 2 µs, covering the full drift region.

The 133 ns bin spacing is the post-processing storage width, **not** the raw ADC rate [TRD-TDR §4.5]. Per-bin charge is the primary observable for both tracking (charge-weighted pad-row centroid gives the rφ position; drift-time gives the z position) and for electron identification (the TR photon absorption appears as a peak in a specific bin range).

### 4.3 On-detector trigger path

TRAP tracklet outputs from all six layers within a single z-stack are shipped off-detector to the **Global Tracking Unit (GTU)**, which matches tracklets across layers into three-layer and six-layer track candidates. The GTU computes a crude p_T estimate (precision limited by the short 80 cm radial lever arm of the TRD alone) and applies programmable trigger logic [TRD-TDR Ch. 7]:

- **High-p_T hadron trigger** — single-track p_T threshold.
- **Electron candidate trigger** — tracklet-level electron-likelihood (from charge profile) combined with the p_T threshold.
- **Jet trigger** — multi-tracklet topologies.

The trigger decision latency is ~6 µs from collision, which fits within the ALICE Level-1 budget. This was one of the principal functions of the TRD during Run 1/2 triggered operation.

### 4.4 Run 3 continuous readout

In Run 3 the TRD migrated to continuous readout as part of the global O² transition [TDR-019]. The TRAP chips stream tracklet and time-sample data continuously to Common Readout Units (CRUs), and the GTU's L1 trigger role is dissolved because every collision is recorded. The TRD's electron-ID function remains, performed entirely offline, and the TRD continues to provide the outer reference space-points for the TPC space-charge distortion calibration (§5.5).

## 5. Role in the reconstruction chain

### 5.1 Tracking

The TRD defines the outer boundary of the ALICE central-barrel Kalman track fit for |η| < 0.9. Each matched tracklet contributes ~400 µm rφ spatial resolution [TRD-TDR Ch. 11]. Six matched tracklets extend the lever arm from the TPC outer radius (~2.5 m) to ~3.7 m — a relative increase of ~48% — and the effect on σ(p_T)/p_T is most visible at high transverse momentum (p_T ≳ 10 GeV/c), where the TPC resolution alone begins to degrade because the helix curvature becomes small relative to single-point resolution.

### 5.2 Electron identification

TR photon detection layered on top of truncated-mean dE/dx is the primary electron-hadron separation tool above p ≈ 1 GeV/c. The TDR design goal is **factor 100 pion rejection at 90% electron efficiency** at isolated-track multiplicity; at the design high-multiplicity of dN_ch/dy = 8000 the expected rejection is ~50 [TRD-TDR §1]. Run 1/2 as-measured values `[VERIFY: TRD performance paper]`. Combined with TPC dE/dx, TOF time-of-flight (useful up to ~5 GeV/c for e/π), and in some analyses EMCal, the barrel delivers e/π separation across 0.1–20 GeV/c.

### 5.3 Level-1 trigger (Run 1 / Run 2)

TRAP tracklets → GTU combinatorial matching → L1 issue to the Central Trigger Processor. Trigger classes enabled include jet triggers that drove much of the Run 2 high-p_T hadron programme, and dielectron triggers for Υ and J/ψ studies. The trigger p_T precision is deliberately crude (single-stack lever arm only); its role is to enrich the recorded sample, not to provide the final p_T measurement.

### 5.4 Run 3 reconstruction role

With continuous readout, the L1 trigger role is dissolved and the TRD becomes an offline-only contributor to tracking, electron ID, and — critically for this dissertation — space-charge calibration of the TPC.

### 5.5 Cross-detector role in this dissertation

- **TPC space-charge calibration anchor.** The ITS–TRD track-interpolation method is the backbone of the Run 3 TPC residual distortion correction (see TPC SoT v0.3 §7.2, step 4). ITS provides the inner reference (precision vertexing), TRD provides the outer reference (~3.7 m lever arm). Any residual drift-field distortion in the TPC appears as a mismatch between the TPC space-points and the ITS–TRD extrapolation. The quality of TRD alignment and timing therefore propagates directly into the quality of TPC distortion maps — which is the principal calibration subject of this dissertation.
- **Momentum cross-check.** For tracks with good six-layer TRD match, the TRD independent p_T (combined with ITS inner points) provides a cross-check of the TPC-driven p_T, useful in isolating TPC-specific systematics.
- **PID complement.** TRD electron ID is used both as a primary signal selector (quarkonia, heavy-flavour leptons) and as an electron veto in hadron analyses.

### 5.6 Cross-detector dependencies (summary)

| TRD ↔ | Role |
|---|---|
| TPC | outer tracking extension; residual-distortion calibration reference |
| ITS | inner reference for the ITS–TRD interpolation across the TPC |
| TOF | PID cross-check at lower p_T; shared L1 trigger architecture Run 1/2 |
| GTU / CTP | L1 trigger path Run 1/2 |
| O² / CRU | continuous readout Run 3 |

---

*End of Turn 1 (§§1–5, ~2,650 words). Turn 2 will add §§6–10: performance summary table, alignment and calibration detail, operational history, expanded glossary (~25 entries per Claude3 request), open-items list, and the full changelog v0.2 → v0.3 mapping every P0 / P1 fix applied with before/after citation.*
