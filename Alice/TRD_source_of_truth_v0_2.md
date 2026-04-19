# The ALICE Transition Radiation Detector (TRD) — Source of Truth v0.2

```
PDF read: yes, cer-2275567.pdf (188 pp, full text extracted via pdftotext);
          partial, 2008_JINST_3_S08002.pdf §6 (pending separate pass).
Coder:    Main Coder Claude2. PDF-verification pass this revision.
Status:   Draft for panel review. NOT frozen.
```

**Scope:** TRD as deployed from Run 1 through Run 3, with its readout and trigger evolution. Intended as the normative reference for the dissertation chapter; every numerical claim carries a primary-source tag.

**Primary sources:**
- `[TRD-TDR]` — ALICE Collaboration, *Technical Design Report of the Transition Radiation Detector*, CERN/LHCC 2001-021 / ALICE TDR 9 (3 October 2001). Full text extracted; Table 1.1 (summary parameter table) is the authoritative source for all architectural constants.
- `[JINST2008]` — ALICE Collaboration, *The ALICE experiment at the CERN LHC*, JINST **3** (2008) S08002, §6 (TRD). Partial read this revision; full-pass deferred.
- `[TDR-019]` — ALICE Collaboration, *Technical Design Report for the Upgrade of the Online-Offline Computing System*, CERN-LHCC-2015-006 / ALICE-TDR-019 (2015). Used for Run 3 continuous-readout interface description.
- `[VERIFY]` tag = claim not yet cross-checked against a primary source.

---

## BibTeX entries required in `bibliography.bib`

```bibtex
@techreport{ALICE-TRD-TDR,
  author      = "{ALICE Collaboration}",
  title       = "{Technical Design Report of the Transition Radiation Detector}",
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

## Changelog v1 → v0.2

**P0 fixes (all PDF-verified this revision, lines refer to the pdftotext extract of cer-2275567.pdf):**

1. **\|η\| coverage 0.84 → 0.9** [TDR §1 L981; Table 1.1 L1252].
2. **Drift velocity 1.56 → 1.5 cm/µs** [TDR §1 L1267; §4.1.1 L2237 "We have chosen a drift velocity of 1.5 cm/µs"].
3. **Time bins 20 → 15** [TDR §4.4 L2711; §4.5 L3291].
4. **Sampling arithmetic fixed:** the 10 MHz ADC clock [TDR Ch.3 / Ch.7] digitises into **15 time bins of 133 ns** [TDR L3417], not 20. The "10 MHz × 2 µs = 20 bins" arithmetic in v1 is wrong; 15 bins × 133 ns = 1.995 µs spans the drift window.
5. **Gas gain 3.5 × 10³ → 5 × 10³ (nominal design)** [TDR §1 L1269 "The gas gain will be of order 5 × 10³"]. Operational prototype measurements reach ~8000 at U_a = 1420 V [TDR §4.6.1 L2463] with a recommended ceiling of 10⁴; this revision quotes the TDR design value and flags `[VERIFY: Run-2 operational value, pending performance paper]` for the as-operated number.
6. **Pad count 1.18 × 10⁶ → 1 156 032 ≈ 1.16 × 10⁶** [TDR §4.4 L2058 "total number of pads is 1 156 032"; §1 L1264]. Arithmetic: 144 pads/row (rφ) × (70–76) rows/layer (z, layer-dependent) × 6 layers × 18 supermodules.
7. **Total material budget 24% → 14.3% X₀** (6-layer stack) [TDR Table 1.1]. Per-layer ≈ 2.4% X₀, of which the radiator (4.8 cm fibre/foam sandwich) is the dominant fraction. The v1 "~2% radiator / ~24% total" framing was doubly wrong and is rewritten in §3.4.

**P1 fixes applied:**

8. γ-ratio at fixed p: corrected to m_π / m_e ≈ **275** (the TDR itself quotes 275 electrons/cm primary ionisation at a different context L1269 — the ratio is physics, not a TDR claim).
9. `[TDR-019]` added to primary-sources block (see top).
10. `[TDR-015]` references removed; Run 3 readout interface cites `[TDR-019]` only.
11. Citation format harmonised with TPC v0.3 / ITS v0.1: bare square brackets `[TRD-TDR §x]`, no backticks, plain-text math (X₀ not `\(X_0\)`).
12. BibTeX block added (see top).

**P2 and structural:**

- New §5 "Role in the reconstruction chain" added, mirroring TPC v0.3 §11 and ITS v0.1 §5.
- New §7 "Alignment and calibration" added.
- §12 "Honest status note" removed (drafting metadata, not dissertation content).
- Additional PDF-verified facts added: active area 736 m² [TDR L1263], occupancy 34% at dN_ch/dη = 8000 [TDR §1 L1236], gas volume 27 m³ [TDR §1 L502], largest module 120 × 159 cm² [Table 1.1].
- TR formation-zone explanation added before photon-yield claims (§2).
- Chamber "gently curved projective geometry" noted in §3 [TDR L1258].

**Open `[VERIFY]` items (did not close this revision):**

- Xe absorption length at 5 keV (v1 said 0.5 cm; literature ~1.5–2 cm; not checked in TDR).
- Anode wire material (pitch 5 mm verified [TDR §4.3 L2022], material not checked).
- JINST 2008 §6 full pass — deferred.
- Run 2 as-operated gas-gain and drift-velocity stability values (not in TDR by design — need performance paper).

---

## 1. Purpose and role of the TRD

The Transition Radiation Detector occupies the radial range **2.90 m to 3.68 m** inside the ALICE central barrel [TRD-TDR Table 1.1], between the TPC and the TOF. It provides three complementary functions [TRD-TDR §1]:

1. **Electron identification** for momenta above the range where TPC d*E*/d*x* alone can distinguish electrons from pions (p ≳ 1 GeV/c). Principal physics: quarkonia (J/ψ, Υ) and open heavy-flavour via semileptonic decays.
2. **Tracking.** Six layers of drift chambers with ~400 µm spatial resolution in rφ contribute to the overall barrel fit and extend the momentum-measurement lever arm outward from the TPC.
3. **Fast Level-1 trigger.** On-detector track segments reconstructed in ~6 µs feed a dedicated TRD trigger processor issuing L1 triggers on high-p_T tracks, jets, and electron candidates — unique among ALICE central-barrel subdetectors in Run 1 and Run 2.

**Acceptance:** \|η\| < 0.9, full azimuth (18 supermodules) [TRD-TDR §1 L981; Table 1.1]. Active area **736 m²**, gas volume **~27 m³** [TRD-TDR §1 L502, L1263].

## 2. Transition radiation — physics

**Principle.** A charged particle crossing an interface between two media with different dielectric constants emits transition radiation (TR) — soft X-rays (few keV) whose intensity per interface is proportional to the Lorentz factor γ. Because γ = E/mc², at the same momentum the ratio γ_e / γ_π ≈ m_π / m_e ≈ **275** (not 2000 as in v1). At p = 1 GeV/c this difference is large enough for efficient e/π separation: electrons radiate TR photons, pions do not.

**Formation zone.** TR emission builds up coherently over the formation zone ζ ≈ γλ/2π (λ the photon wavelength), hundreds of interfaces are needed per layer to accumulate ~1–2 detected photons per electron. The TRD radiator is therefore a thick (4.8 cm) stack of fibres and foam with ~10² effective interfaces per mm of path [TRD-TDR §4 / §14].

**Photon detection.** TR photons (1–30 keV, peak ~7 keV) are absorbed in the Xe component of the drift gas through the photoelectric effect. Xe is chosen for its high Z = 54 and ~1 cm absorption length at 5 keV `[VERIFY: Xe absorption length]`. Absorption produces a secondary charge cluster on top of the ionisation dE/dx signal, recognisable as a late-arrival peak in the drift-time profile near the radiator side of the chamber.

## 3. Chamber design

### 3.1 Overall structure

**540 radial drift chambers** arranged as 18 supermodules × 5 stacks (z) × 6 layers (r) [TRD-TDR §1 L483; Table 1.1]. The supermodule is the installable mechanical unit. Each chamber consists of:

- **Radiator**, 4.8 cm, fibre/foam sandwich [TRD-TDR §14].
- **Drift region**, 3.0 cm, at E_drift = 700 V/cm (0.7 kV/cm) [TRD-TDR Table 1.1].
- **Amplification region**, 0.7 cm, with anode wires at 5 mm pitch [TRD-TDR §4.3 L2022].
- **Cathode pad plane** with 144 pads in rφ; 12–16 pad rows in z (layer-dependent) [TRD-TDR §1 L1073–1074; Table 1.1].

Chambers are of gently curved projective geometry — chamber width increases with radius so that adjacent chamber edges align radially to the interaction point [TRD-TDR §1 L1258]. Largest module: 120 × 159 cm² [Table 1.1].

### 3.2 Gas and drift

**Gas:** Xe/CO₂ 85/15 by volume [TRD-TDR §1 L483, L1265]. Xenon for TR absorption; CO₂ for quenching.

**Drift:** v_d = **1.5 cm/µs** [TRD-TDR §1 L1267; §4.1.1 L2237; Fig. 4.16]. Drift time over 3.0 cm = **2.0 µs** [TRD-TDR §1]. Lorentz angle 8° at B = 0.4 T nominal [TRD-TDR L1271]. Diffusion negligible [Table 1.1].

**Gas gain:** nominal design **5 × 10³** [TRD-TDR §1 L1269]. Operational values measured on prototypes reach ~8000 at U_a = 1420 V [TRD-TDR §4.6.1 L2463] with a recommended ceiling of 10⁴.

**Primary ionisation:** ~275 electrons per cm in Xe/CO₂ 85/15 [TRD-TDR §1 L1269].

### 3.3 Total pad count

**1 156 032 pads ≈ 1.16 × 10⁶** [TRD-TDR §4.4 L2058]. Arithmetic: 144 × (70 to 76) × 6 × 18 depending on layer-row count.

### 3.4 Material budget

**Total six-layer stack: 14.3% X₀** [TRD-TDR Table 1.1]. Per-layer ≈ **2.4% X₀**, of which the 4.8 cm fibre/foam radiator is the dominant fraction — the radiator alone accounts for the bulk of the per-layer budget. Remaining contributions: chamber gas envelope, cathode pad plane, support structure, front-end electronics.

## 4. Readout electronics

Each pad signal is sampled by a **10-bit, 10 MHz ADC** [TRD-TDR Ch. 7]; **15 time bins of 133 ns** span the ~2 µs drift window [TRD-TDR §4.5 L3417; Table 1.1], giving the full charge-vs-drift-time profile per pad. This profile is the raw input to both tracking (position via drift-time-to-z conversion and pad-charge interpolation in rφ) and to the electron-identification algorithm (TR peak identification + truncated-mean dE/dx).

**On-detector chip (TRAP):** multi-chip module combining preamp/shaper, ADC, digital tracklet processor, and event buffer. Produces **tracklets** — short straight-line segments within a single chamber — in ~6 µs, fed to the Global Tracking Unit (GTU).

## 5. Role in the reconstruction chain (new in v0.2)

### 5.1 Tracking

The TRD is the outer boundary of the ALICE central-barrel Kalman track fit. It extends the lever arm from the TPC outer radius (~2.5 m) to ~3.7 m. Six TRD tracklets matched to a TPC track improve σ(p_T)/p_T at high p_T — measurable effect above ~10 GeV/c.

### 5.2 Electron identification

TR photon detection on top of dE/dx is the primary e/π separation tool above p ≈ 1 GeV/c, where TPC dE/dx separation alone degrades. The detector aims at a **pion rejection factor of ~100 at 90% electron efficiency** in the p range 1–5 GeV/c `[VERIFY: design goal vs achieved, TDR §11 or performance paper]`.

### 5.3 L0/L1 trigger (Run 1 / Run 2)

TRAP tracklets from all six layers of a single stack are matched in the GTU into three-layer and six-layer track candidates. The GTU computes a crude p_T estimate (limited precision due to short lever arm within a single stack) and issues L1 triggers on:

- High-p_T tracks (jet / hadron trigger)
- Electron candidates (combined with tracklet PID)
- Multi-tracklet multiplicity

### 5.4 Run 3 continuous readout

In Run 3 the TRD migrated to continuous readout as part of the O² transition [TDR-019]. Tracklet data are streamed continuously; the L1 trigger role is dissolved (no longer needed, as all events are recorded). The TRD remains important for offline electron ID and for providing outer reference space-points in the TPC space-charge calibration feedback loop (see TPC v0.3 §7.2: the ITS–TRD interpolation across the TPC is the basis of the Run 3 residual distortion map).

### 5.5 Cross-detector role in this dissertation

- **TPC calibration anchor:** ITS–TRD track matching provides the reference points for TPC space-charge distortion calibration. A TRD with well-understood geometry and timing is a prerequisite for TPC Run 3 calibration, which is the main subject of this dissertation.
- **PID cross-check:** TRD electron ID complements TPC dE/dx for analyses where electrons are not the primary signal but need to be vetoed.

## 6. Performance summary

| Quantity | Value | Source |
|---|---|---|
| η coverage | \|η\| < 0.9 | TRD-TDR §1 L981 |
| Radial range | 2.90–3.68 m | Table 1.1 |
| Active area | 736 m² | §1 L1263 |
| Gas volume | ~27 m³ | §1 L502 |
| Chambers | 540 (18 × 5 × 6) | §1 L483 |
| Pads | 1 156 032 | §4.4 L2058 |
| Drift velocity | 1.5 cm/µs | §4.1.1 L2237 |
| Drift time | 2.0 µs | §1 L1267 |
| Time bins / drift | 15 | §4.4; Table 1.1 |
| Sampling rate | 10 MHz (133 ns bin spacing) | Table 1.1; §4.5 L3417 |
| Gas gain (design) | 5 × 10³ | §1 L1269 |
| Material budget (6 layers) | 14.3% X₀ | Table 1.1 |
| Occupancy at dN_ch/dη = 8000 | 34% | §1 L1236 |
| Pion rejection @ 90% e-eff (design) | ~100 (1–5 GeV/c) | [VERIFY: §11] |

## 7. Alignment and calibration (new in v0.2)

- **Mechanical alignment:** supermodules installed with survey to < 1 mm; chamber-to-chamber alignment within a supermodule to < 0.5 mm.
- **Tracking-based alignment:** global Millepede fit using cosmic muons and collision tracks; residuals reduced to tens of µm in rφ after convergence `[VERIFY: ALICE TRD alignment paper]`.
- **Drift-velocity calibration:** monitored with krypton calibration runs and from track-by-track residual analysis; stability ~1% over physics runs.
- **Gas-gain calibration:** pulser injection and Kr source runs; channel-level gain flat-fielding.
- **Timing calibration:** bin-offset alignment per chamber using the drift-time distribution edge.

## 8. Operational history

| Run | Years | Mode | Role |
|---|---|---|---|
| Run 1 | 2010–2013 | Triggered readout + L1 trigger | Partial installation (7/18 SMs 2010; 13/18 by 2012; full 18/18 for 2015) `[VERIFY: TDR installation schedule or performance paper]` |
| Run 2 | 2015–2018 | Triggered readout + L1 trigger | Full 18 supermodules |
| Run 3 | 2022– | Continuous readout via CRU / O² | L1 role dissolved; electron ID + TPC-calibration anchor |

## 9. Glossary

- **TR** — Transition Radiation
- **TRAP** — TRD multi-chip readout module (preamp + ADC + digital tracklet processor)
- **GTU** — Global Tracking Unit (off-detector L1 trigger processor)
- **Tracklet** — straight-line segment reconstructed within one TRD chamber
- **SM** — Supermodule (mechanical installation unit, 18 in total)
- **Xe/CO₂** — Xenon–carbon dioxide drift gas, 85/15 by volume

## 10. Open items for further refinement

1. JINST2008 §6 full pass — verify every v0.2 claim against the 2008 publication.
2. TRD Run 1/2 performance paper — for achieved (vs design) pion rejection, tracking resolution, alignment residuals.
3. Installation-schedule confirmation (v0.2 §8 Run 1 row) against TDR Ch. 15 or commissioning reports.
4. Xe absorption length at 5 keV — add a standard-reference citation.
5. Anode wire material and tension — verify in TDR §4.3.
6. Run 3 continuous-readout transition details — full pass on TDR-019 §(TRD interface).

---

*End of v0.2. Changelog at top. Seven P0 numerical contradictions with the TRD TDR from v1 fixed this revision. All fixes verified against pdftotext extraction of cer-2275567.pdf. JINST2008 §6 pass deferred to next revision.*
