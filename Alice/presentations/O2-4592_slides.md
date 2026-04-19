---
title: "O2-4592 — Time series, skimmed data QA, performance parameterization, time/track selection for physics analysis"
wiki_id: O2-4592
wiki_class: transcript-index
jira: O2-4592
slug: o2-4592
date: "[VERIFY] — resolve from source deck metadata"
venue: "[VERIFY] — resolve from source deck metadata"
source_url: "https://docs.google.com/presentation/d/1yGXMqA9vVIXAG8mv1TlOIOax-BuFhsXWsJ2JlRw757c"
slide_count: 216
authors: [Marian Ivanov, Marian Ivanov jr., Matthias Kleiner, Markus Fasel, Marwin Hemmer]
service_work: [Rahul Verma, Yash Patley]
source_fingerprint:
  upstream:
    - id: O2-4592-deck
      url: https://docs.google.com/presentation/d/1yGXMqA9vVIXAG8mv1TlOIOax-BuFhsXWsJ2JlRw757c
      slide_count: 216
      last_synced: 2026-04-19
      sha_at_sync: "unknown — Google Slides, no hash available"
indexed_by: Claude (ALICE-Wiki ingestion session)
indexed_on: 2026-04-19
review_status: DRAFT
review_cycle: 2
summary_review_panel: [Claude3-Reviewer-v0 (cycle 1), Claude-self-lint (cycle 2)]
hard_constraints_checked: false
known_verify_flags:
  - front-matter date/venue
  - slide 66 arithmetic discrepancy (0.6-3 cm vs 0.6-5 cm ITS resolution)
  - link reachability (not audited)
---

# O2-4592 — Slide-by-slide index

**How to query this file**
- By slide number: `^## Slide 72\b`
- By topic tag: `#v-shape`, `#c1c2-fluctuation`, `#ifc-distortion`, `#ctf-tagging`, …
- By data path / run: search for `LHC23zzh`, `LHC24ar`, `544116`, `559901`, …
- By code / command: search for `alien.py`, `tree->`, `float getSystematicIFC0`, `df["`
- Reused content: `#reused` (evergreen) or `#backup-duplicate` (near-identical repeat)

**Canonical content map** (3-category schema: `canonical` = authoritative source; `pure-duplicates` = byte/content-identical repeats; `evolved` = later slides that *update* the canonical — readers relying on the map must visit these, they are NOT skippable repeats).

| Block | canonical | pure-duplicates | evolved (must-visit) |
|---|---|---|---|
| TPC residual distortion (concept diagram) | 5 | 14, 29, 185 | — |
| Data flow | 4 | 36 | — |
| IFC systematic error + `getSystematicIFC0` code | 51 (description) + 52 (code) [multi-canonical] | 69 | — |
| Global residual bias correction | 55 | 65 | — |
| ITS-TPC sector-edge model | 53 | — | 66 `[VERIFY]` — states ITS resolution as 0.6-5 cm vs 0.6-3 cm in slide 53; which is current? |
| Run2 sector-2 line-charge model | 86 (link-only) | — | 106 (expanded: adds feedback-loop physics + Run3 working hypothesis) |
| PbPb apass2 C1&C2 fluctuation | 84 | 111, 176 | 156 (cut proposal updated 10-2000 → 20-10000) |
| TPC PID "pseudo-invariances" | 30 | 186 | — |
| TS variables + granularity | 90 (67 bins, apass2) | 178 | 154 (67 → 87 bins for apass3) |
| TS availability + rolling stats | 110 | 155, 179 | — |
| Usage in AO2D / cut variation | 104 | — | 157, 180 (1-20 TF granularity update) |
| dEdx TS TF selection | 92 | 181 | — |
| Eff TS TF selection | 93 | 182 | — |
| TS aggregation flow + file sizes | 158 | 183 | — |
| TS 2023 apass3 DCAr C1&C2 | 159 (findings absorbed from 184 — see slide 159 body) | — | 184 (historical record; finding promoted per Karpathy compounding) |
| A-side V-shape fluctuation (high rate 38 kHz) | 115 | 177 | — |
| TPC→ITS Δ maps at vertex | 25 | 70 | — |
| DCA bias decomposition (sector × Δsector × q/pT) | 27 | 73 | — |
| N clusters decomposition | 26 | 72 | — |

**Reading guide:**
- `pure-duplicates` column → safely skip if you've read the canonical.
- `evolved` column → **must visit** even if you've read the canonical. The slide carries a real content update.
- `[VERIFY]` → pending factual confirmation. Tracked in "Open items" at bottom.

---

## Slide 1 — Title
Performance parameterization and expert QA: Marian Ivanov & Marian Ivanov jr.; skimmed data preparation: Matthias Kleiner, Marian Ivanov; EMCAL data preparation: Markus Fasel, Marwin Hemmer, Marian.
**Tags:** #title #team

## Slide 2 — Outlook
Deck covers: TPC + combined tracking TS & skimmed data; request to enable TS/skim in simulation production; TS maps motivation example; performance maps example; usage in post-reco / tracking / V0 / cascades / calorimeters (plans); correction maps usage; status. Disclaimer: plots illustrate performance at different points in time; calibration & tracking perf improving toward intrinsic resolution.
**Tags:** #outlook #disclaimer

## Slide 3 — Motivation
Run 3 tracking/reco performance not yet stable: affected by calibration imperfections, running-condition variations, rate, local occupancy, detector-response fluctuations, bugs. Imperfections vary in time and space with different time granularity. Performance is defined by imperfections, not intrinsic resolution. Only a limited range of effects is represented in MC. Not all effects mitigable. Residuals not simulatable precisely due to CPU + incomplete understanding → parameterize consequences instead. Skim + TS used for monitoring, correction, and future MC/data remapping.
**Tags:** #motivation #reused #mc-data-remapping

## Slide 4 — Performance parameterization / correction — Data flow
`reco → sampled skim | time series → groupby stats → derived perf maps (bias mean/median, σ/RMS, count) → Δ track-param maps → Δ combined-track maps (Run1-like) → tracking + V0/Cascade/Calorimeter post-correction → (detector) physics analysis`.
TS extraction started Nov 2023, now integral to reco. "Expert" skimming started Jan 2024. MC setup to be prepared.
**Tags:** #data-flow #reused

## Slide 5 — TPC residual distortion parameterization (canonical)
TPC Δ correction — 5 track params at vertex (DCA) and at TPC→ITS reference layer (R≈60 cm) — extracted using skimmed data. For now not enough information in AO2D. Tabulated correction (space, time) will be applied for post-correction: track-param improvement, efficiency recovery, physics systematic studies. Reference layers: Δ TPC→ITS at R≈60 cm, Δ TPC→ITS at DCA, Δ TPC→TOF at TOF layer, Calorimeter E/p.
**Tags:** #tpc-distortion #reused #ao2d #evergreen-diagram

## Slide 6 — Combined Track "analytical" post-correction — Options
Two approaches: (1) Kalman-gain approximation — parameterize Kalman gain matrix, update with Δ params. (2) Numerical algorithm — derive combined-track derivatives wrt tabulated TPC biases (Run1/Run3 style): simulate track with ITS points (N layers, X0, cluster resolution), dual refit with ideal vs distorted TPC params, take difference. Correction applied per-track or as functional map on grid (NN in future). In Run1 both options used. Δs interpret as track correction assuming ideal ITS/TOF/EMCAL alignment + stability; residual misalignment (elliptical deformation) to be added later, possibly with EMCAL constraints + ML.
**Links:** AliTPCCorrection::FitDistortedTrack → github.com/alisw/AliRoot/blob/master/TPC/TPCbase/AliTPCCorrection.cxx#L1820-L1987 · MakeDistortionMap → AliTPCCorrectionDemo.C
**Tags:** #post-correction #kalman-gain #run1-algorithm

## Slide 7 — Section header: Skimmed data
**Tags:** #section-header #skimmed-data

## Slide 8 — Expert data skimming for "Interactive analysis"
Triggers: flat-pT Tsallis O(10⁻³); minimum bias (since Feb); high dEdx. Sampling weights + triggers stored for later renormalization. Variables: subset for TPC + combined tracking; output for apass2; new triggers, variable Δ track param at R=60 cm added; considering pushing well-compressed Δ to AO2D. Later Run2-style full-reco-object dumps for replay. Analysis time: O(s) on PROOF (30 CPU) for LHC23zzh; O(min) standard grouping in RDataFrame (server, O(100) cores) + TStatToolkit.
**Command:** `alien.py find /alice/data/2023/LHC23zzh TimeseriesTrackTPCmerging*Stage_5*time_series_tracks_0.root apass2`
**Tags:** #skimmed-data #triggers #proof #rdataframe #tstat-toolkit

## Slide 9 — Section header: Time series with TF granularity
**Tags:** #section-header #time-series

## Slide 10 — Example TS — TPC→ITS matching (V-shape fluctuation)
High DCA fluctuations → ⟨χ²TPCITS⟩ increases → TPC→ITS matching eff drops. Effect depends on charge and q/pT (error estimator + DCA bias are q/pT-dependent): at q/pT ~ −4 1/GeV eff stable (track aligned with ExB); at q/pT ~ 1 1/GeV ~40% oscillation (0.7 ↔ 0.5). Similar dEdx oscillations. V-shape correction implemented; part of new reco production after Feb 2024. Quality varies in time — fraction affected must be corrected or rejected (analysis-dependent).
**Tags:** #v-shape #tpc-its-matching #efficiency #qpt-dependence

## Slide 11 — TS — DCA bias vs rate/time & tgl
STD of mean DCA decreases over time. Bias vs inclination angle due to insufficient space granularity in calibration. Charge q/pT dependence from angular mis-alignment with SC ExB vector. Tgl range −0.9…0.9. A-side vs C-side shown.
**Data:** `/alice/data/2023/LHC23zzh/544116/cpass2/0140/TimeseriesTPCmerging/Stage_5/001`
**Tags:** #dca-bias #rate-dependence #tgl-dependence #ExB

## Slide 12 — TS — fluctuation charge-q/pT dependence (Dec 2023 preproductions)
Comparison CPass7 (Lumi scaling) vs CPass8 (IDC scaling). IDC scaling reduces SC fluctuation. Systematic DCA bias → time-dependent eff, with correlated time & q/pT variation in TPC→ITS matching. Imperfect map scaling → rate-dependent bias. Differences between passes significant; q/pT and Bz dependent.
**Tags:** #cpass7 #cpass8 #idc-scaling #lumi-scaling #dca-bias #efficiency

## Slide 13 — Section header: Skimmed data → multi-dim performance & correction maps
**Tags:** #section-header

## Slide 14 — TPC residual distortion parameterization (repeat)
See Slide 5.
**Tags:** #tpc-distortion #backup-duplicate #reused

## Slide 15 — N-dim performance parameterization (decomposition)
Python groupby / RDataFrame for multi-dim space statistics (like Run2 nd-histograms). RootInteractive dashboards enable: space grouping (residual calibration) and residual-occupancy grouping (intrinsic resolution). Dashboards: SkimmedG2G0, SkimmedOccu. Correction maps + dashboards + reports part of production. Skim GRID production initiated Jan 2024; MC setup TBD.
**Links:** dashboard_SkimmedG2G0 / dashboard_SkimmedOccu (indico 1243783, contrib 5695996)
**Tags:** #nd-maps #groupby #rootinteractive #dashboards

## Slide 16 — Local groupby stats summary (DCAr example)
Median = local bias estimator (residual distortions); σ = fluctuation (multiple scattering + space-point resolution). Binnings: G0 (q/pT 10 × tgl 10 × side A/C), DSec (+ average sector ÷ 10), Sec (+ sector 180 bins). Run1/Run2 used ND-histograms; Run3 uses groupby stats.
**Data:** GSI pre-production PbPb_Scan/TPCrateScan/V3/<run>_v8/
**Tags:** #groupby #dca-bias #binning #run1-compat

## Slide 17 — Local groupby stats — DCAr numbers
Small bins (q/pT, tgl, sector, side). σ of local bias: σy ≈ 0.42 cm, σz ≈ 0.6 cm (residual miscalibration indicator; further smearing expected with finer subsector binning). Mean of σ within bin (stat fluctuation): σy ≈ 0.51 cm, σz ≈ 0.33 cm. Deviation from "ideal" ≈ 0.1 cm mainly from occupancy + residual SC fluctuation (SC fluctuation almost fully mitigated Feb 2024). Groupby stats also obtained for σ(DCA) vs occupancy (cluster overlaps).
**Data:** GSI pre-production 544116.38kHz_v5
**Tags:** #dca-resolution #cluster-overlap #sc-fluctuation

## Slide 18 — Performance decomposition — rate dependence
Stochastic fluctuation contribution ⟨dar_tpc_std⟩ monotonous with rate & occupancy (cluster merging, SC fluctuation, sector 1&2 extras). Factor ~2 worse resolution at higher rates vs Run2-like 50 Hz PbPb reference (3 → 6 mm). Systematic contribution (residual miscalibration): std(⟨dar_tpc_mean⟩) 1.5 → 5 mm. Effect angular-dependent (diffusion, occupancy, SC all larger at tgl≈0 = full drift).
**Tags:** #rate-dependence #occupancy #stochastic-vs-systematic #cpass1

## Slide 19 — Performance maps — DCA bias/resolution & eff observation
Strong DCA bias at sector edges, up to 1 cm. DCA resolution + TPC→ITS matching eff strongly depend on local occupancy (= Ntracks in TPC drift region). C-side ⟨DCA⟩10−0 vs sector vs rate (CPass8/IDC scaling). ⟨dar_tpc_std⟩ vs occupancy vs rate (pT<1).
**Tags:** #sector-edge #dca-bias #occupancy #cpass8

## Slide 20 — Section header: Performance summary tree, dashboards, functional composition
**Tags:** #section-header

## Slide 21 — Perf maps GroupBy — RDataFrame / Python implementation
Primary groupby (sampled skim) → Nvars × NSpace × 4D/5D histograms → Nvars × NSpace × Nstat × 3D/4D performance maps → secondary groupby (Python) → RootInteractive dashboards + ROOT trees. Multi-dim space: `<varDet>, Sector(0-18), q/pT, tgl, <varSpace>` or `<varDet>, dsector(0-1), q/pT, tgl, <varSpace>`. Input selection: TPC-only, or ITS+TPC refit. Large datasets → RDataFrame primary; Python Modin as alternative.
**Links:** gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes → JIRA/O2-4592/skimmedO2DataDraw.C#L170-352 · makePerformance.py#L55-153 · makePerformanceData.sh#L23-32
**Tags:** #groupby #rdataframe #modin #nd-maps

## Slide 22 — Perf maps GroupBy (continued) — varDet / space / stats
varDet: ΔParam at vertex (at R=60 cm in new skimming), QA (Ncl TPC/ITS, χ²s, matching χ²), dEdx vars & ratios, event properties (local mult, collision mult, …). Space vars: `<>`, 1/dEdx, Time (Orbit) and per-bin derived (`<Mult>`, `<Ncl>`, `<χ²>`, …). Stats: Mean, Median, RMS, LTS, Gaussian fit.
**Tags:** #groupby #statistics #var-list

## Slide 23 — Summary Python pandas → ROOT tree
Separate trees per bin granularity; Python rebinning (merge, merge_asof) + ML regression (TODO). Separate RootInteractive dashboards. ROOT trees + HTML → performance web pages (Run2-style). Trees: `DSec`, `DSecITS`, `DSecMult`, `DSecMultITS`, `DSecOrbit`, `DSecOrbitITS`, `Sec`, `SecITS`, `SecMult`, `SecMultITS`, `SecOrbit`, `SecOrbitITS`, …
**Data:** `df_trees.root` at eos/user/m/mivanov/public/NOTES/JIRA/O2-4592/alice/data/2023/LHC23zzh/apass2
**Tags:** #tree-names #root-trees #export

## Slide 24 — ROOT perf trees — example queries (high-pT)
Resolution (mean of RMS) vs multiplicity (occupancy) and time (IR). Factor-2 modulation of resolution vs occupancy for high-pT tracks. RootInteractive allows more sophisticated queries + normalization.
**Data:** `/alice/data/2023/LHC23zzh/apass2`
**Tags:** #queries #high-pt #resolution #occupancy

## Slide 25 — TPC→ITS track Δ maps at vertex (RootInteractive) (canonical)
ND Δ map: projection for high-pT; A-side sectors 0–3 with |pT|>2. Regular structures at sector boundaries. Granularity/fitting: average structure fitted independently with finer granularity. Decomposition strategy: regular + delta components → simplifies ML fitting. Δ maps as lookup table.
**Tags:** #delta-maps #sector-boundary #rootinteractive #factorization

## Slide 26 — Perf maps decomposition — Number of clusters
Regular structure at sector edges (tracks crossing/near dead zones → shorter cluster counts). Deviations from missing pads/FECs. Factorized repr simplifies functional deps. Projections: `<NCL> vs sector vs q/pT`, `<NCL> vs Δsector×20 vs q/pT`, `<NCL>-<Ncl>dsec vs sector vs q/pT`. Filter: `hasITS, Ncl>80, |q/pT|<1, C side, |tgl|<1`.
**Tags:** #ncl #decomposition #factorization #dead-zone

## Slide 27 — DCA bias decomposition — dcar
Regular structure at sector edges (selection bias + correction imperfection). Deviations from missing pads/FECs → selection bias. Factorized: `<DCAr> vs sector vs q/pT`, `<DCAr> vs Δsector×20 vs q/pT`, `<DCAr>-<DCAr>dsec vs sector vs q/pT`. Data: LHC23zzh/pass2.
**Tags:** #dca-bias #decomposition #sector-edge

## Slide 28 — Section header: Performance map usage in post-reco and physics analysis (Plans)
**Tags:** #section-header #plans

## Slide 29 — TPC residual distortion parameterization (repeat)
See Slide 5.
**Tags:** #tpc-distortion #backup-duplicate #reused

## Slide 30 — TPC PID parameterization and "pseudo-invariances" (canonical)
TPC dEdx in 4 regions (stacks 0–3) with 2 estimators `<Qmax>`, `<Qtot>`. Regions should align via single-element `<Q>` scaling — imperfect, non-linear needed (transfer function differs by region due to angular dist., pad length, dead-zone fraction, occupancy, baseline bias). Define invariance I(rate, occupancy, position, angle, 1/dEdx) = 1. In Run3 deviation from invariances significantly higher than Run2. Invariances: `<<Qmaxi>/<Qtoti>>`, `<<Qmaxi>/<Qmaxj>>`, `<<Qtoti>/<Qtotj>>`, `<<Q>/<QMIP>>`. Tabulated correction applied in post-correction to improve PID.
**Tags:** #pid #dedx #invariances #tpc-stacks

## Slide 31 — Efficiency / track / collision recovery in AO2D
Update collision + collision times using corrected TPC time (tag fake TPC-ITS matches via corrected time). Propagate TPC-only tracks to primary vertex + correct all 5 params (spatial+temporal). Re-update with primary vertex: match ITS tracks not previously matched via χ² in corrected space + Δtime; mark "gold pairs" + weights. Non-gold/secondary: update TPC with closest non-utilized ITS standalone at innermost+middle points (χ² in space + kinematics + Δtime). Best-pair selection via ML cost function (improved Run1/Run2 TPC/ITS tracking). Also delta-param correction to already-connected TPC+ITS tracks.
**Links:** Reference presentation `docs.google.com/presentation/d/1CbL0PQZkDPZ_YRL9t4PlASfuXvcpcVALm7TDZErjRXA` · Run1/Run2 TPC-ITS proceeding: sciencedirect.com/science/article/abs/pii/S0168900206008126
**Tags:** #efficiency-recovery #ao2d #collision-time #gold-pair #ml

## Slide 32 — ML-based algorithm
ML algorithm combining local performance (local bias + resolution) + track properties. Motivation: insufficient precision during reco, improve MC/data matching, enable alternative algorithms for efficiency/resolution + systematic-error estimation in data and MC.
**Tags:** #ml-correction #mc-data-remapping

## Slide 33 — V0 / EMCAL post-processing in AO2D
Correction maps from skimmed data — high space & time granularity, based on track matching at vertex + TPC-ITS boundary. EMCAL/V0 stats insufficient to extract differential corrections directly → use precise track correction maps. Analytical: Kalman-gain or Run1-type (previous slide) — successfully used in Run2 optimization (Marian, Gregoris) for q/pT, pT scaling, material budget; correction params changed in time. ML: track bias/correction maps at decay radius as input.
**Links:** indico.cern.ch/event/991463 (invariant-mass bias)
**Tags:** #v0 #emcal #cascade #post-correction #run2-reference

## Slide 34 — V0/EMCAL post-processing — ML-based
ML for V0/Cascade/calorimeter lacks data + time granularity to learn imperfections alone. Include contributing-track imperfection at specific position/time as additional ML input. Inputs: track kine (φ, q/pT, tgl) + track bias at moment/position. Targets: Δ invariant mass, Δ pointing angle, Δ DCA, Δ E/p → Δ q/pT. Cost: normalized delta — MSE or MAE.
**Tags:** #ml-correction #v0 #emcal #targets

## Slide 35 — Correction maps usage in post-reconstruction
Data format + query params in post-reco/analysis TBD. Integrate high-spatial-granularity correction maps with high-temporal-granularity TS. Combining algo via functional composition (already used in track-based V0 correction + SC fluctuation weight calibration). Start with map-lookup; transition to ML (like PID) later.
**Tags:** #functional-composition #post-correction #sc-fluctuation

## Slide 36 — Data flow — status (repeat of 4)
See Slide 4.
**Tags:** #data-flow #backup-duplicate #reused

## Slide 37 — Conclusion
Tracking performance varies in space + time. Highly granular performance maps needed. Data to be corrected with matching granularity. MC represents only subset of effects → treat MC same way, extract TS + expert skim for MC. Benchmark multiple MC/data remapping methods.
**Tags:** #conclusion #mc-data-remapping

## Slide 38 — Section header: Backup & Additional information
**Tags:** #section-header #backup

## Slide 39 — Section header: Expert skimmed data — Outlier tagging + Simple queries
Prototyping using PROOF.
**Tags:** #section-header #proof #outlier-tagging

## Slide 40 — Low-dEdx "fake" η≈0 tracks
Low-dEdx "induced signal" mostly at sector cross and sector boundaries. Outlier in dEdxMax/dEdxTot. dEdx selection islands: `(dEdxMaxTPC > 20 && dEdxMaxTPC/dEdxTotTPC > −0.4)`.
**Tags:** #induced-signal #fake-tracks #eta0 #dedx-cut #sector-cross

## Slide 41 — Low-dEdx "fake" η≈0 tracks (repeat of 40)
Same cut formula. **Tags:** #backup-duplicate #induced-signal

## Slide 42 — Fraction of accepted tracks (dEdx cut) — time evolution
Relative fraction of accepted high-pT tracks using dEdx cut increasing in time.
**Tags:** #time-evolution #dedx-cut #accepted-fraction

## Slide 43 — Expert QA — Common mode and dEdx position/multiplicity bias (header)
DCA bias at sector boundaries + tracking modification. For meeting 07.02.2024 (Ivanov, Ivanov jr., Kleiner).
**Tags:** #section-header #common-mode #sector-boundary

## Slide 44 — Low-dEdx fake η≈0 tracks (analysis)
Problem with η≈0, high-pT tracks localized to narrow TPC regions with high capacitive coupling. Sharp distribution smeared by linear dep of spot position wrt q/pT (geometrical): `sin(φ) ~ (q/pT) × Radius`. `Qpt : dsector(φ)` for dEdx outliers shown.
**Tags:** #capacitive-coupling #induced-signal #geometry

## Slide 45 — Induced-signal cut dEdx — analysis on MB skim
Two islands at η≈0: induced noise (`dEdxMax < 20`), induced crosstalk (`log(dEdxMax/dEdxTot) < −0.4`). 2D cut combining both preferable. Appropriate dEdx cuts should be implemented in tracking (current dev branch), or better via correlated-noise cuts tagging individual cluster spikes at "induction time bins".
**Links:** github.com/AliceO2Group/AliceO2/pull/12640#issuecomment-1921641368
**Tags:** #induced-signal #dedx-cut #mb-trigger #cluster-spike

## Slide 46 — TPC-ITS matching efficiency with dEdx cut
dEdx ratio cut → sector-boundary + η=0 + high-pT spike almost disappears. Primary tracks (|DCA|<5 cm) + dEdx outlier rejection → matching eff at high-pT ~ 80 → 70%.
**Data:** `/lustre/alice/DETdata/tpcTimeSeries//alice/data/2023/LHC23zzh/*/apass1/`
**Tags:** #tpc-its-matching #efficiency #dedx-cut #primary-selection

## Slide 47 — Expert QA — dEdx position/multiplicity bias (CM investigation)
Expected dEdx bias in low-gain (signal < threshold) or high capacitive coupling (common-mode overcorrection) regions. dEdxMax and dEdxTot affected differently. High gradient at sector edges/crossings. Linear q/pT dep: crossing angle ~ sin(φ) × (q/pT) × Radius (slope IROC vs OROC differs — radial dep). Combined dEdx bias −10% to +2%. Goal: optimize CM correction params at high-occupancy regions.
**Tags:** #common-mode #dedx #sector-edge #iroc-oroc #occupancy

## Slide 48 — Expert QA — dEdx position/multiplicity bias (continued)
dEdx bias influenced by mult + sector-edge position (q/pT ~ 0.2 1/GeV example). Occupancy-impact variation across regions. To optimize CM params, account for: CM overcorrection at high capacitive coupling (positions 0, 0.5, 1); signal-below-threshold (affecting Qtot) in low-gain regions; Δ fit parameterized by occupancy.
**Tags:** #common-mode #threshold #qtot #occupancy

## Slide 49 — dEdx and edge bias observation in MC
Pilot MC production at GSI (limited stats). Dedicated MC generator needed (Run1/Run2-style integrated into Grid production for software validation) — offline team contacted. CM capacitive coupling NOT simulated. dEdx + DCA bias at sector edges observed. Not all electrons reach active sector (some end in dead zones). Position bias toward chamber center.
**Links:** its.cern.ch/jira/browse/O2-4612 comment 5753074
**Tags:** #mc #cm-not-simulated #dead-zone #sector-edge #edge-bias

## Slide 50 — Sector boundary DCA bias(es) — MC vs data
DCA bias amplitude in data is rate-dependent → distinguish local occupancy (tracking/clustering) vs mean rate (maps imperfection). Comprehensive rate+occupancy scan in MC recommended. Effects: Track-survivor bias (ITS or min-length req; MC+data); distortion calibration imperfection (data only); cluster-survivor bias at edge (MC+data); fake bias (fake clusters inside active volume; MC+data, MC scan not yet available).
**Tags:** #mc-vs-data #sector-boundary #rate-dependence #cpass8

## Slide 51 — IFC systematic error + cluster masking (canonical)
Rate-dependent σ error + masking in IFC to cover map imperfection (high-gradient distortion at IFC; exponential approximation). Mask innermost radii with σ_errmask = 5 cm; `maskError=5 cm`, `minDist=2 cm`. Exponential decay: `err0=3 cm`, `slope=1/5 cm`.
**Links:** gitlab.cern.ch/alice-tpc-offline/alice-tpc-notes/.../JIRA/ATO-630/ATO-630_ErrParam.C#L132-151
**Tags:** #ifc #systematic-error #cluster-masking #ato-630

## Slide 52 — IFC systematic error — code (canonical code listing)
C++ function `getSystematicIFC0(int sector, int row, int y, float z, float err0=3, float slope=0.2, float minDist=2, float maskError=5)`: get local UV via splines, convert to pad/time, transform to xyz, compute `r=sqrt(x²+y²)`; `rIFC=83`; if `r−rIFC < minDist` return `maskError`; else return `err0*exp(-(r-rIFC)*slope)`. Test drawing: `TF2 *ferrIFC = new TF2("ferrIFC","getSystematicIFC0(0,x,0,y,3,0.2)",0,64,0,250)`. To be ported to O2.
**Tags:** #ifc #code #tf2 #exponential-decay #port-to-o2

## Slide 53 — ITS-TPC sector-edge systematic error calibration/correction (canonical)
Δy bias 0–3 cm (IR-dependent); Δdeadzone ~3 cm; O(0.6–3 cm) ITS resolution. Ion SC gap at sector boundary (Δdeadzone). Electrons from dead zone focused symmetrically to sector centers → effectively reducing dead-zone size. Big distortion gradient at boundary smeared by ITS extrapolation uncertainty. ExB generates left-right asymmetry in electron arrival: `Δrφ ~ ωτ(0.3) Δr`; at high IR comparable to dead-zone size (asymmetric bias). Sector-edge distortions need calibration + visualization at granularity finer than gradient; mitigable via analytical model. Sector-edge + occupancy degradation are critical for physics analysis.
**Tags:** #sector-edge #dead-zone #ExB #omega-tau #analytical-correction

## Slide 54 — Edge-effect treatment in reconstruction
Tails + fake clusters → clusters misassigned in reco. Impact occupancy-dependent (fake probability scales with rate). Mitigation options: modify edge-cluster handling; track cuts to remove clusters in dead zones; Run1-style "virtual charge" — effectiveness to be quantified. Track position + distorted track position used to assign σ or mask cluster in dead zone.
**Tags:** #edge-clusters #dead-zone #virtual-charge #fake-clusters

## Slide 55 — Global residual bias correction via global minimization (canonical)
If needed: address residual Δsystematic after latest calibration by adapting distortion maps. Empirical minimization on track residuals (Run1 MI track-based calibration approach); also used for V-shape correction + global linear fits for Δvdrift using TS. Global linear minimization in multidim: ΔR, ΔRφ, Δz + Δtrack and 5 track params (P0–P4) across 4 layers (vertex, ITS outer, TOF). No code mod needed — CCDB content modification only. Empirical scaling: `ΔR = ar(R,Z) + br(R,Z)*ΔR`; `ΔRφ = ar(R,Z) + br(R,Z)*ΔRφ`.
**Tags:** #global-min #empirical-scaling #ccdb #vdrift #v-shape

## Slide 56 — Common mode optimization scan
Goal: avoid overcorrection (est. 10-15%) by CM param optimization. Laser calibration confirmed perf at low occupancies (well-defined baseline). Originally not approved; now critical for upcoming IR scan. Challenges: dEdx bias (not CM-related) affects both high + low occupancy (signal-below-threshold correction); capacitive coupling + occupancy (primary CM effect); combined dEdx effect varies within 12%.
**Links:** RootInteractive tutorial indico 1135398 (DSP section)
**Tags:** #common-mode #scan #rootinteractive #laser-calibration

## Slide 57 — Common mode optimization rate scan — proposal
Preparation: get starting values from existing perf via RootInteractive functional decomposition (static + occupancy parts; set occupancy part to 0). Scan tests: no correction, current default, "half" correction, new from analysis above. Rate scan: rapid ramp-up preferred with occupancy estimators in analysis (skimmed data). Target 0–50 kHz PbPb equivalent.
**Tags:** #common-mode #rate-scan #proposal #50khz

## Slide 58 — Sector (φ) distribution for high-pT (ptTPC>2)
Several patterns in sector distribution. Even with ITS req, enhancement at sector edge visible. "Outlier pT" vs "fake matches" — outlier pT: using TPC-only pT at sector boundaries.
**Code:** `tree->SetAlias("qptSel","abs(qpt)<0.5")`
**Data:** `/lustre/alice/DETdata/tpcTimeSeries//alice/data/2023/LHC23zzh/*/apass1/`
**Tags:** #sector-distribution #high-pt #fake-matches

## Slide 59 — Sector (φ) distribution high-pT (ptTPC+ITS>2)
Using qpt_tpcits — flatter φ dist but still ~20% more high-pT tracks on left sector edge.
**Code:** `tree->SetAlias("qptSel","abs(qpt)<0.5&&nClITS>5&&abs(qpt_ITSTPC)<0.2&&tgl>0");`
**Tags:** #sector-distribution #qpt-itstpc

## Slide 60 — Sector spectra pT<0.5 GeV
Low-pT → low matching eff. Suspicious shape of matching eff vs sector in data. Geometrical cut should be wider for low pT. Compare with MC + multiplicity dep. `TPC→ITS eff vs qpt:dsector(108 cm)`, `Ntrack(ITS+TPC) vs qpt:dsector(108 cm)`.
**Tags:** #low-pt #matching-efficiency #geometrical-cut

## Slide 61 — TPC→ITS matching for primary candidates
Data: LHC23zzh apass1.
**Tags:** #matching-efficiency #primary

## Slide 62 — TPC→ITS eff vs nContributors and occupancy
Matching eff depends on occupancy; only weak dependence on collision multiplicity ("centrality"). Occupancy estimator from reco data, definable same way in AO2D.
**Data:** `/lustre/alice/DETdata/tpcTimeSeries//alice/data/2023/LHC23zzh/*/apass1/`
**Tags:** #occupancy #ncontrib #centrality #ao2d-estimator

## Slide 63 — TPC→ITS matching vs occupancy (Run 544123) high-pT
For high-pT (|pT|>1), eff determined by local occupancy of tracks in drift region. Modulation within run relatively small.
**Data:** Run 544123
**Tags:** #high-pt #occupancy #run-544123

## Slide 64 — Section header: Backup
**Tags:** #section-header #backup

## Slide 65 — Global residual bias correction (repeat of 55)
See Slide 55.
**Tags:** #global-min #backup-duplicate

## Slide 66 — ITS-TPC sector-edge (evolved — [VERIFY] wording diff)
Near-identical content to Slide 53, except ITS resolution stated as **O(0.6–5 cm)** vs. **O(0.6–3 cm)** in slide 53. `[VERIFY]` which figure is current — tracked in Open items.
**Tags:** #sector-edge #evolved #verify #dead-zone

## Slide 67 — Δdeadzone (visual/header only)
**Tags:** #section-header #dead-zone

## Slide 68 — ITS+TPC high-gradient space/time calibration (2)
Fit unbinned residuals with parabolic Δ fit to minimize MS contribution from ITS tracks (using prev TPC calibration). Combined ITS+TPC tracks for map updates. Intrinsic TPC+ITS resolution ≈ 0.025–0.05 cm vs ~cm for ITS extrapolation → enables calibration of sub-cm (mm-scale) gradient structures. Outlier detection simpler (esp. combinatorial-bg clusters). Factor 100–1000 less data needed. TPC+ITS Δ approx fit algorithm: gen Δ₀ tree (ΔR, ΔRφ) → correct with 3D maps → get Δ₁ → fit parabola to Δ₁ (zero at ITS midpoint ~20 cm) → store Δ₀, Δ₁, Δ₁fit. Originally for distortion fluctuation (Run2/Run3: time fluct, charging-up, stack boundaries).
**Tags:** #parabolic-fit #its-tpc-residual #charging-up #stack-boundary #mm-scale

## Slide 69 — IFC systematic error + code (repeat of 51, 52)
See slides 51–52. **Tags:** #ifc #backup-duplicate

## Slide 70 — TPC→ITS track Δ maps at vertex (repeat of 25)
See Slide 25. **Tags:** #delta-maps #backup-duplicate

## Slide 71 — TPC→ITS χ² matching — factorization (PbPb apass2)
In pass2: χ² variation mostly due to mean-variation within sector. Deterioration at sector boundaries in all sectors (1.2 → 2.6) — dominant effect. Relatively small within-sector variation from other TPC imperfections.
**Data:** JIRA/O2-4592/alice/data/2023/LHC23zzh/apass2
**Tags:** #chi2 #tpc-its-matching #factorization #apass2

## Slide 72 — N clusters decomposition (repeat of 26)
See Slide 26. **Tags:** #ncl #backup-duplicate

## Slide 73 — DCA bias decomposition (repeat of 27)
See Slide 27. **Tags:** #dca-bias #backup-duplicate

## Slide 74 — (Blank / placeholder)
**Tags:** #blank

## Slide 75 — Section header: Z/time characterization
**Tags:** #section-header

## Slide 76 — Section header: Time series QA
**Tags:** #section-header

## Slide 77 — C-side DCA oscillation
C-side DCA distribution has spikes (seen in FFT). Regular oscillation sub-0.1 cm (comparable to intrinsic resolution); less frequent spikes O(0.25 cm) to be filtered in analysis. Bias similar across tgl bins. Similar algorithm (fit boundary potential of analytical model) applicable to C side.
**Tags:** #c-side #fft #oscillation #analytical-model

## Slide 78 — Section header: Time series in physics analysis
Time Frame selection / tagging focus. Team: Ivanov, Ivanov jr., Kleiner; service work: Rahul Verma, Yash Patley.
**Tags:** #section-header #tf-selection #service-work

## Slide 79 — Outlook — TS in physics analysis
TS + perf parameterization in parametric space+time for track/event selection + later post-correction. Questions: imperfections in data (C1&C2 + draft physical model), TS variables, CTF tagging for reco (apass1), TF selection variation for analysis cuts (tracking/eff/PID), AO2D/Hyperloop usage options.
**Tags:** #outlook #questions

## Slide 80 — Goals — TF physics selection
Intrinsic DCA resolution for high-pT ≈ 0.1–0.2 cm. Goal: tag and remove TF intervals with bias >> intrinsic resolution + quantify impact on biases and correlated eff loss. Later use for post-correction.
**Tags:** #goal #intrinsic-resolution #dca-resolution

## Slide 81 — Imperfections in Data — time development
V-shape + sector-edge fluctuation: O(cm), not in MC. Outlier handling imperfect → integrity issues. Hardware oscillations in sectors 1&2 above 25 kHz (O(1-3 cm)) not covered by correction models. Calibration may fail occasionally. PID impact beyond distortion correction.
**Tags:** #imperfections #v-shape #c1c2 #pid

## Slide 82 — Correlated biases in tracking / eff / PID
Imperfections create correlated biases NOT emulated by simple smearing in MC. MC should be remapped in space + time to capture correlation. QA + tagging at granularity of effect or smaller.
**Tags:** #correlated-bias #mc-smearing #remapping

## Slide 83 — TPC-C ROC 1&2 distortion fluctuation — 2023 PbPb 38 kHz (example)
Distortion 1&2 cannot be corrected by current algorithm (defined by local SC density fluctuation). RMS of IDC0 measures fluctuation (IDC changes with pad-collected charge affected by distortion, which fluctuates with SC). Sectors 1&2 (+ others) affected for physics above 25 kHz. Need detailed TS to calibrate temporal evolution in 1&2.
**Tags:** #c1c2-fluctuation #idc0-rms #25khz-onset #sc-density

## Slide 84 — PbPb apass2 — C1&C2 fluctuation (2023) (canonical)
Discrete fluctuation in C1&2 (+ smaller in other sectors) at PbPb rates >25 kHz. O(0.5 cm) fluctuations in other sectors too. Proposed cut: `Δ DCAR10-2000 (cm)` & `Δ DCAR2000-RUN (cm)`. Shown: DCAR rolling 10 TF vs sector, DCAR rolling 20000 TF, Δ DCAR rolling 10-20000.
**Tags:** #c1c2-fluctuation #rolling-window #cut-proposal #apass2

## Slide 85 — Digital current fluctuation — IDC0_RMS sectors 1&2
Onset of distortion fluctuation in 1&2 at ~25 kHz. Fluctuation at 38 kHz ~2× smaller than at 50 kHz. B-field dependent.
**Tags:** #idc0-rms #onset #50khz #b-field

## Slide 86 — Run2 — long time-range fluctuation at sector 2 model (canonical)
Run2 line-charge fit. **Link:** indico.cern.ch/event/605126/contributions/2538484/attachments/1441002/2218550/DistortionAnalitycalModelsForTB_06042017_v2.pdf
**Tags:** #run2-reference #line-charge #physical-model

## Slide 87 — TPC→ITS matching eff — apass2 — 38 kHz
Sector-boundary distortion fluctuation → matching-eff fluctuation. Distortion is NOT the only cause — ITS responsible for part. TS TF tag based on QA regardless of cause. DCAr C-side (color=sector), orbit number vs time, eff A vs eff C.
**Tags:** #tpc-its-matching #38khz #its-contribution

## Slide 88 — Problem example — C12 + others — apass2 vs apass3 (544121, ~28 kHz)
Matching eff increases in time (occupancy decreasing). Distortion/eff fluctuation decreases in time. Spike at time 120. apass3 correction fails in some intervals.
**Data:** `/alice/data/2023/LHC23zzh/apass2/544121`, `/alice/data/2023/LHC23zzh/apass3/544121`
**Tags:** #apass2-vs-apass3 #544121 #28khz #correction-failure

## Slide 89 — TPC→ITS matching — Run 544116 (38 kHz)
Difference between Standalone and Afterburner efficiency. Correlated A+C side efficiency decrease due to ITS chips fluctuation. With missing chips, Afterburner mostly used.
**Tags:** #standalone-afterburner #its-chips #544116

## Slide 90 — TS — Variables to Use (canonical)
1 TF granularity, 1D array per TF (128 bins total): Sector 3×18 bins, eta 30 bins, q/pT 18 bins, occupancy 20 bins, integral. Key variables (63 variables, 39 kB/TF): tracking bias DCA + TPC→ITS matching Δ, matching eff, dEdx biases, multiplicity estimators. Post-processing uses groupby + rolling window (typically ±10 TF).
**Tags:** #variables #granularity #1tf #63vars #rolling-window

## Slide 91 — Example summary tree (LHC24ar)
Analysis summary tree. DCA: `mDCAr_comb_{A,C}_{Median,RMS}`, `mDCAz_comb_{A,C}_{Median,RMS}`. ITS-TPC matching: `mITSTPC{Afterburner,Standalone}.mITSTPC_{A,C}_{Chi2Match,MatchEff}`. TPC-ITS: `mTSITSTPC.mDCAr_{A,C}_{Median,NTracks,RMS}`, `mTSITSTPC.mDCAz_*`. dEdx: `mdEdx{QMax,QTot}.mLogdEdx_{A,C}_{Median,RMS}`. Detector-study variable list longer.
**Data:** `/alice/data/2024/LHC24ar/cpass0/56016x`
**Tags:** #lhc24ar #cpass0 #tree-schema #variable-names

## Slide 92 — dEdx TS TF selection — fluctuation (canonical)
Dead band around long-time average: `ΔdEdx<10>-<10000>`. Cut value as part of cut variation — e.g. 2%.
**Data:** `/alice/data/2024/LHC24ar/cpass0/56016x`
**Tags:** #dedx #tf-selection #dead-band #2-percent

## Slide 93 — Eff TPC→ITS TS TF selection — fluctuation (canonical)
Dead band around long-time average: `ΔEff<10>-<10000>`. Cut value as part of cut variation — e.g. 5%.
**Tags:** #efficiency #tf-selection #dead-band #5-percent

## Slide 94 — Section header: CTF tagging of bad intervals (2024) apass1
**Tags:** #section-header #ctf-tagging #apass1 #lhc24ar

## Slide 95 — PbPb 2024 CPass0 — DCA bias TS time selection
Reject runs with |median bias|>0.6 cm (correlated with lower TPC→ITS matching).
**Code:** `dfG.query("abs(`mTSITSTPC.mDCAr_A_Median_median`)<0.6 & abs(`mTSITSTPC.mDCAr_A_Median_median`)<0.6")[["run"]].to_csv("run.csv")`
**Tags:** #cpass0 #run-rejection #0-6cm #pandas-query

## Slide 96 — Bad CTF tagging — fluctuation
Tag on fluctuation: bias in phi bin < threshold. `DCA10TF - DCA10000TF` to tag fluctuation minus long-term median (residual bias removed later with better calibration). Bad-TF threshold 0.3 cm example. Logical OR of bad conditions in individual phi intervals (sectors).
**Tags:** #ctf-tagging #0-3cm #logical-or #phi-bin

## Slide 97 — CTF tagging — rejection fraction for apass1
Reject CTF with local bias >2-3σ of DCA bias. Options: 0.3, 0.5, 0.6 cm. apass1 uses hardwired cut; further refinement in physics analysis.
**Tags:** #rejection-fraction #apass1 #cut-options

## Slide 98 — TF tagging for apass1 reconstruction
High rate → large fraction rejected; low rate → smaller fraction.
**Tags:** #tf-tagging #rate-dependence #rejection

## Slide 99 — Example — CTF tagging in reco (LHC24ar/apass1/559901)
Data with DCA fluctuation >0.5 cm (from CPass0 10% sampling) removed from CTF list. Selection works well; TF boundary oscillations observed (TFs not tagged due to random 10% sampling — known effect). TF boundaries to be removed in physics. Selection O(0.3 cm) more appropriate to reduce matching-eff impact. CCDB entry under prep.
**Data:** `/lustre/alice/users/miranov/NOTESData/alice-tpc-notes/JIRA/ATO-628/MLFit/alice/data/2024/LHC24ar/apass1/559901/timeSeries_CTFTagging.root`
**Tags:** #559901 #ato-628 #10-percent-sampling #ccdb-prep

## Slide 100 — DCAr bias TS — q/pT dependence (example fill)
DCA bias q/pT-dependent — ±1.5σ effect in DCA → 1.5σ pT bias (residual radial distortion). WIP: quantify + calibrate with TOF pT bias (tracks, V0, cascade). Bias is occupancy/rate dependent — smooth evolution. Jumps in TS from different calibration intervals with suboptimal rate scaling.
**Data:** `LHC24ar/559901, 559902, 559903` · `fill559900`
**Tags:** #dcar-bias #qpt-dependence #tof-calibration #radial-distortion

## Slide 101 — DCAr bias TS — tgl × qpT dependence
TPC→ITS + TPC→TOF matching to improve in post-correction (WIP). TPC DCAz bias O(1–3σ). Combination of drift velocity + radial distortion. Bias larger at higher inclination + larger q/pT.
**Data:** LHC24ar/559901, 559902, 559903
**Tags:** #dcaz-bias #drift-velocity #inclination

## Slide 102 — Distortion — low-frequency fluctuation modulation
Regular distortion fluctuation on C side absent on A side (0.1 cm, q/pT + tgl-dependent). Small vs other systematics. VHV to check.
**Tags:** #low-freq #vhv #c-side-only

## Slide 103 — Usage in AO2D / Hyperloop — options, plans
Summary trees exported: 141 MB with 1 TF granularity per fill. Cut variation + sensitivity studies. Categories based on Nσ vs intrinsic resolution (tracking bias DCA, eff, PID). New AO2D columns to add (like dEdx correction) — PR not yet approved. Plan to restart with service work (Rahul, Yash) in new year.
**Tags:** #ao2d #hyperloop #141mb #pull-request #service-work

## Slide 104 — Usage in AO2D / Hyperloop — detailed (canonical)
Sensitivity to deficiencies varies across analyses. Adapting to biases: TS bits (1 TF) for dynamic slice adjustment; O(2-3) bias/eff categories. PID: activate/deactivate time intervals + PID categories. Visualization: pT spectra + PID spectra per category → standard plots demonstrate impact of cut variations.
**Tags:** #cut-variation #categories #pid-selection #pt-spectra

## Slide 105 — (Blank / placeholder)
**Tags:** #blank

## Slide 106 — Run2 sector-2 long-range fluctuation model (evolved — expanded)
Evolved from slide 86 (which was link-only). Adds:
- Solving diff eqs with positive electron feedback; expanding channels (more ions) → more electrons collected.
- Stochastic feedback from charge-deposition fluctuation in small channel.
- In Run2 origin extracted by distortion-map → E-field → SC density → model fit.
- Hotspots visible toward high rates with different time/space characterization.
- Run2 source: sticky wires.
- **Run3 working hypothesis:** dead-zone charge focused to sensitive region.
**Link:** Same as slide 86
**Tags:** #evolved #run2-reference #sticky-wires #dead-zone-source #positive-feedback

## Slide 107 — TS — TPC→ITS problems "due to ITS"
Not all TPC→ITS matching problems from TPC. Quantized matching eff in particular φ regions on both TPC sides — due to ITS.
**Tags:** #its-problems #phi-region #quantized-efficiency

## Slide 108 — C1&C2 cluster-track residuals — distortion fluctuation (MAE)
MAE(38 kHz - 8 kHz) and MAE(27 kHz - 8 kHz) vs φ and R. Full symbol = C1&C2 region; empty = rest. 27 vs 38 kHz differ in amplitude AND radial extension. Radial extension NOT simple scaling of standard radial distortion.
**Tags:** #mae #c1c2 #cluster-track-residual #radial-extent

## Slide 109 — Usage in AO2D — options (detail)
Categories for simplicity. Option 1: on-the-fly calculation (fresh, flexible; bottleneck = data volume — 40 kB/TF full TS). Option 2: pre-prepared TS with "trigger bitmask" (cache-style). Hybrid: on-the-fly + pre-prepared. Prototyping phase → option 2 first.
**Tags:** #bitmask #on-the-fly #prototyping #40kb-per-tf

## Slide 110 — TS Availability & Utilization (canonical)
TS as tree structures since Nov 2023 for all reco productions. Soon auto-generated for real data + MC. Post-processing: groupby + rolling stats (±10 TF). Fluctuation identifiers: `effA_median_20TF(qp, tgl, occu, sector)`, `effA_median_10000TF(qp, tgl, occu, sector)`, `diff_median_20_10000TF(...)`, `diff_median_100000_RUN(...)`. Sharp cuts separate fluctuations from consistent long-term metrics. Challenges: track angle (charging-up, V-shape), q/pT granularity (time dep roughly linear in q/pT), sector-specific granularity.
**Tags:** #availability #rolling-stats #fluctuation-detect #diff-median

## Slide 111 — PbPb apass2 — C1&C2 fluctuation (high rate 38 kHz) (repeat of 84)
See Slide 84. **Tags:** #c1c2 #backup-duplicate #38khz

## Slide 112 — PbPb apass2 — not only C1&C2 (high rate 38 kHz)
Discrete fluctuation in C1&2 at >25 kHz. Onset of problems in other sectors. O(0.5 cm) fluctuations in other sectors too. Same cut proposal.
**Tags:** #c1c2 #other-sectors #apass2 #38khz

## Slide 113 — PbPb apass2 — C side fluctuation (low rate 8 kHz)
At low rate C1&2 fluctuation disappears — only O(0.1 cm) regular pattern from VHV. Occasional "strange" fluctuations simultaneously on A and C.
**Tags:** #8khz #low-rate #vhv #a-c-coincidence

## Slide 114 — PbPb apass2 — A-side fluctuation (low rate 8 kHz)
V-shape fluctuation → correlated fluctuation in all A-side sectors. Occasional "strange" fluctuations on A+C side simultaneously ("V-shape oscillation bubble").
**Tags:** #v-shape #a-side #8khz #bubble

## Slide 115 — PbPb apass2 — A-side fluctuation (high rate 38 kHz) (canonical)
V-shape → correlated fluctuation in all A-side sectors. New patterns at high rate. Other sector-specific fluctuations to be filtered with "severity" bitmask (e.g. sector ~6, low-freq variation in subset of sectors).
**Tags:** #v-shape #severity-bitmask #38khz #a-side

## Slide 116 — PbPb apass2 — A-side fluctuation (high rate, detail)
New patterns emerge at IR>25 kHz; low-freq fluctuations in pairs of sectors. Filtering via "severity" bitmask.
**Tags:** #severity-bitmask #low-freq #sector-pairs

## Slide 117 — Selection categories
Intrinsic DCA resolution high-pT ≈ 0.1–0.15 cm. **Max single-sector** (event-shape, flow, fluctuation systematics): coding bias > 0.2, 0.4, 0.6, 0.8 cm. **Max per-side** (general): coding bias > 0.15, 0.3, 0.45, 0.6 cm.
**Tags:** #selection-categories #intrinsic-resolution #per-sector #per-side

## Slide 118 — TS in physics analysis — status & plans
TS + skim available since 2023. Option 2 WIP — analysis bitmask not released. TS not sorted — O(10 GB) per fill to sort + split. Too much CPU for time-sort. Sorting/groupby/splitting in post-merging, WIP. Pandas groupby hits memory limit → trying Modin. If still slow → C++ implementation. Discussion with AOT, WG4: TS stored per long interval (run, O(hour)); dimensions = Category Type (Delta/Eff/PID) + Severity Type — not [begin,end] maps. Evgeny/Igor unaware of "custom CCDB" for event selection; Xiaozhi + Ionut collaboration on CCDB physics-analysis example.
**Tags:** #status #modin #pandas-limits #ccdb-custom #wg4 #aot

## Slide 119 — Section header: TS analysis — observations, apass2/apass3 comparison
**Tags:** #section-header #apass2-vs-apass3

## Slide 120 — Event Selection Proposal Summary — Zoom discussion
Proposed event-selection framework: Track Matching Category (max bias threshold per sector/side); Track Efficiency Category; Track dEdx Category; Occupancy Selection (exclude high-occupancy TPC). V-shape is NOT sole fluctuation source — other important fluctuations. TS analysis preferred over simple time-interval tagging. Validate intervals via cut variation, not exclude.
**Tags:** #event-selection #categories #zoom-meeting #v-shape-not-only

## Slide 121 — Goal — improvement areas
Distortion calibration: sector-boundary + other fluctuations. Reco issues: missing ITS chips + hardware anomalies (currently tagged at 3s granularity — TBC). Data techniques: MC/data remapping + tagging. MC/data anchoring: some effects anchored correctly, some not (bugs, insufficient granularity, not derived from first principles). TS for general-purpose MC in next MC.
**Tags:** #improvement-areas #anchoring #3s-granularity

## Slide 122 — TPC primary-candidate selection for TS
|DCAr|<5 cm, |DCAz|<5 cm, Ncl>80, |tgl|<1, pT>0.2 GeV.
**Tags:** #primary-selection #cuts #definitions

## Slide 123 — TPC→ITS matching eff — apass2 — 38 kHz (repeat of 87)
See Slide 87. **Tags:** #backup-duplicate

## Slide 124 — C12 apass2 vs apass3 (repeat of 88)
See Slide 88. **Tags:** #backup-duplicate

## Slide 125 — TPC→ITS "due ITS" (repeat of 107)
Plus: fraction of missing chips + parameterization vs rate/occupancy to be added.
**Tags:** #backup-duplicate #its-chips

## Slide 126 — TPC→ITS matching Run 544116 38 kHz (repeat of 89)
See Slide 89. **Tags:** #backup-duplicate

## Slide 127 — Section header: PbPb 2024 time series
**Tags:** #section-header #pbpb-2024

## Slide 128 — TPC→ITS matching eff apass2/apass3
A/C-side matching eff vs time and rate (`<nTracks>` in drift) — ~12% decrease of single-track eff with rate. Strong rate dependence + slight C-side improvement in apass3 vs apass2.
**Tags:** #12-percent-drop #rate-dependence #apass2-apass3

## Slide 129 — C1&2 side — matching eff apass2/apass3 comparison
C1&2 oscillation/fluctuation in efficiency.
**Tags:** #c1c2 #efficiency #apass2-apass3

## Slide 130 — TPC→ITS matching efficiency — time evolution PbPb
Situation evolving in time.
**Tags:** #time-evolution #pbpb

## Slide 131 — TPC→ITS matching eff — rate & q/pT dep (PbPb apass3)
Eff heavily dep on rate + occupancy. Pronounced q/pT dep for given charge; most pronounced at +¼ GeV. Eff line vs rate highly non-linear. Residual distortion + track matching?
**Tags:** #qpt-dependence #non-linear #apass3

## Slide 132 — TPC→ITS Standalone (apass2/apass3)
Eff strongly time + occupancy dependent. Total occupancy defines tracking perf (eff, bias, resolution).
**Tags:** #total-occupancy #standalone

## Slide 133 — Section header: TPC + TPC+ITS performance at high occupancy
**Tags:** #section-header #high-occupancy

## Slide 134 — TPC track + cluster occupancy fluctuation
Performance driven by "occupancy". Cluster overlaps → worse cluster+track resolution, ~linear with occupancy. Track occupancy → increased fake rate in ITS↔TPC combinatorial matching; linear for small range then non-linear divergence. TPC drift time ~100 μs. At 50 kHz, ~5 collisions overlap within drift time. Occupancy primarily pile-up driven, NOT single-collision multiplicity. Example local cluster occupancy = clusters in narrow TPC time region (250 cm / 31 bins).
**Tags:** #occupancy #cluster-overlap #pile-up #drift-100us #31-bins

## Slide 135 — (Blank / placeholder)
**Tags:** #blank

## Slide 136 — Cluster Δy MAE error fit — analytical formula in reco
Local occupancy (31 bins) `o15x = Ncl/lx` dominant term in MAE resolution; high-Δ cutoff in reco. Impact strongly charge-dependent — for high q much smaller rate-dependence. IR not relevant in resolution fit (large occupancy spread for given IR).
**Code:**
```
df["o15x"] = df["o15"]/df["xx"]
df["o15xaq"] = df["o15x"]*(df["avgCharge"]**2)
df["asnp"] = np.abs(df["snp"])
varList0 = ["o15x","asnp"]
varList1 = ["o15x","asnp","rate"]
varList2 = ["o15x","asnp","rate","avgCharge"]
varList3 = ["o15x","asnp","rate","avgCharge","o15xaq"]
```
**Fit coefficients (Ridge regression):**
- F0: `[9.39e-05, 0.026]`
- F1: `[9.06e-05, 0.0255, 3.02e-07]`
- F2: `[9.99e-05, 0.0347, 4.55e-07, 0.759]`
- F3: `[3.87e-05, 0.0334, 4.6e-07, 0.328, 0.00199]`
**Tags:** #mae #ridge-regression #analytical-formula #cluster-overlap #coefficients

## Slide 137 — ITS ↔ TPC matching as function of occupancy
Fake-match rate ↑ with occupancy. Search area ~ kMS² × (dEdx/pT²). At high occupancy fakes dominate. Non-linear occupancy dep due tracks competing for hits. χ² matching criterion: larger χ² → more likely fake. Combinatorial matching with likelihood preferred. Residual biases in matching linear in qpT + fake rate → affect χ².
**Tags:** #fake-match #combinatorial-matching #likelihood #chi2

## Slide 138 — Combined ITS+TPC expected resolution vs pT + rate (canonical)
TPC residual distortion + occupancy worsening in pT-resolution formulas. Resolution <2 GeV largely unaffected. Linear worsening <10 GeV; saturation at 30–40 GeV. Rough K0 invariant mass description for pT_track ~ 0.5×pT_K0.
**Links:** Interactive dashboard indico 1358443/4835781/dashboard_CombResol.html · Jupyter notebook gitlab .../JIRA/ATO-628/trackingPerformanceBias.ipynb
**Data:** PbPb 39 kHz, Dec 2023
**Tags:** #resolution-model #pt-resolution #k0 #ato-628 #dashboard

## Slide 139 — Combined ITS+TPC resolution vs pT, rate, occupancy
Dashboard updated to include TPC occupancy. Collision multiplicity NOT major factor; interaction rate has some influence; PRIMARY = pileup occupancy within TPC → maps to K0, D0 resolution. 2 snapshots: qpT resolution vs occupancy (tracks 5–50 GeV) with color = collision mult vs IR.
**Tags:** #pile-up-occupancy #k0 #d0 #dashboard

## Slide 140 — DCA resolution decomposition vs occupancy
Stochastic fluctuation `<dcar_tpc_std>` monotonic with rate + occupancy (cluster merging, SC fluctuation, sectors 1&2). At high occupancy cluster occupancy dominates. Run3 resolution worse than Run2 primarily due to higher occupancy. At high occupancy cluster overlap dominates regardless of avg rate.
**Tags:** #dca-resolution #stochastic #run2-vs-run3

## Slide 141 — TPC→ITS matching vs occupancy Run 544123 high-pT (repeat of 63)
**Tags:** #backup-duplicate

## Slide 142 — dEdx bias/std vs occupancy
dEdx bias + resolution (after GroupSec correction) strongly occupancy-dependent. dEdxMax less sensitive than dEdxTot. Slopes similar across rates (MIP corrected per rate independently). Q: can we improve dEdx with tracklet algorithm using local track info + modified tracking?
**Tags:** #dedx #groupsec #occupancy #mip-correction

## Slide 143 — Summary
Bitmask for cut variation ready — to be exported to CCDB. MC TS high priority — some reco-side actions preferable (mostly occupancy part).
**Tags:** #summary #bitmask #mc-ts-priority

## Slide 144 — New variables for skimmed data
Validate reco + covariance matrix setting + prepare MC/data remapping. Δ of TPC + vertex constraint — combined track params at vertex: Covar TPC (0,1) at vertex; Δ P2, P3, P4; Covar TPC+Vertex (2,3,4); Covar TPC+ITS (2,3,4). ITS+TPC - TOF Δ to be added.
**Tags:** #new-variables #covariance #vertex-constraint #tof-delta

## Slide 145 — Production scans
Produce perf parameterization for 2022/2023/2024.
**Data:** `/lustre/alice/DETdata/tpcTimeSeries/alice/data/<year>/<period>/<run>/<pass>` e.g. `.../2023/LHC23n/536262/apass3/2100/TimeseriesTPCmerging/Stage_5/001/o2_timeseries_tpc.root`
Per period / per fill outputs:
- `map.root` 3.9G (Mar 29)
- `df_trees.root` 467M (Mar 29)
Flow: skim → histograms → maps → python pkl → reports. RED = batch farm, O(n tracks); GREEN = server at start.
**Tags:** #production-scan #data-paths #pkl #batch

## Slide 146 — Summary info
Mean, median of RMS for time interval (period/fill/subfill): mean/median eff per category-tracks (<2, >2, >5 GeV); mean/median DCAr resolution per category-tracks. STD on mean values.
**Tags:** #summary-stats #categories #period-fill-subfill

## Slide 147 — Section header: q/pT bias fit
**Tags:** #section-header #qpt-bias

## Slide 148 — q/pT bias fit — vs tgl and sector boundary
`q/√pT` fitted via power law; Δqpt as function of tgl + relative position wrt sector boundaries (color-coded visualization). Intrinsic q/pT resolution ~ 0.0007 1/GeV. MC: fit bias comparable with intrinsic resolution. Data: q/pT bias linear in tgl (alignment?), >> intrinsic — not seen in MC at low or high IR. Bias strongly correlated with distance to sector boundaries, intensifying with IR. Consistent with DCA + angular-bias QA. First attempt; global fit (DCA + Δ track-param + E/P) planned.
**Code:** `TF1 *f2 = new TF1("f2","[0]*abs(x-[1])**[2]",-0.3,0.3);`
**Data:** MC LHC24d2b (Anchor 544013–544185); LHC23zzh/544123 (IR~15 kHz); LHC23zzh/544121 (IR~27 kHz)
**Tags:** #qpt-bias #power-law #mc-vs-data #alignment #0-0007-intrinsic

## Slide 149 — DCA bias tgl — occupancy evolution
Residual DCA bias rate + tgl + position dependent. Roughly linear in q/pT and rate. Low rate: step at acceptance-map boundary. Residual DCA bias related to q/pT residual bias.
**Data:** Run 544116 (IR~38 kHz), Run 544124 (IR~8 kHz), LHC23zzh rate scan
**Tags:** #dca-bias #rate-scan #544116 #544124 #acceptance-boundary

## Slide 150 — Δ q/pT bias sector(φ) + ITS "gap" region (apass3)
Δq/pT bias 0.002 1/GeV in ITS-gap region (intrinsic ~0.0007) — same region as combined-track DCA bias (sector boundary 0→18 and 8→9). Strongly tgl-dependent → gap + alignment bias varies with tgl + vz. Propose adding vz as new calibration dimension (4D maps in prep). TPC studies show radial distortions in sectors appear non-physical — likely ITS bias. q/pT bias fit assumes constant shift (valid only at very high pT); more sophisticated model needed for q/pT-dep DCA bias.
**Data:** `/alice/data/2023/LHC23zzh/apass3/544121`
**Tags:** #its-gap #sector-boundary #4d-maps #vz-dimension #ito-0-002

## Slide 151 — New variables in TS (PR link)
**Link:** github.com/AliceO2Group/AliceO2/pull/12928
**Tags:** #pull-request #new-variables

## Slide 152 — Section header: 2023-2024 TS production summary for QA + physics
**Tags:** #section-header #2023 #2024

## Slide 153 — Outlook — TS production summary
TS variables + time granularity; TS aggregation separating biases vs fluctuations; derived stats (10000 TF) observations; 2023 + 2024 TS observations; next steps → default reports + physics analysis.
**Tags:** #outlook #aggregation

## Slide 154 — TS — Variables to Use (evolved — apass3 87 bins)
Evolved from canonical slide 90 with apass3 granularity update. Granularity: 1D array per TF — size **67 (apass2) → 87 bins (apass3)**. Sector 18 bins × time. Eta 10–30 bins × time / side. q/pT 18 bins. Occupancy 20 bins. Integral bin. Variables (63 vars, 39 kB/TF): tracking biases (DCA + TPC→ITS match Δ); matching eff TPC→ITS; dEdx biases; mult estimators; detector QA (Ncl, χ²). Post-processing: groupby + rolling window ±10 TF.
**Tags:** #evolved #apass2-67bins #apass3-87bins #granularity #variables

## Slide 155 — TS Availability (repeat of 110)
See Slide 110. **Tags:** #backup-duplicate

## Slide 156 — PbPb apass2 — C1&C2 (evolved — cut proposal updated)
Content as slide 84 plus **updated cut proposal**: `Δ DCAR20-10000` and `Δ DCAR10000-RUN` (vs. `Δ DCAR10-2000` and `Δ DCAR2000-RUN` in canonical 84). Rolling window widened 10 TF → 20 TF on short side and 2000 TF → 10000 TF on long side.
**Tags:** #evolved #c1c2 #cut-update #20-10000

## Slide 157 — Variation in Physics Analysis Cuts (evolved — 1-20 TF granularity)
Evolved from canonical slide 104 with **1-20 TF granularity** added (canonical 104 specified 1 TF only).
**Tags:** #evolved #cut-variation #1-20tf

## Slide 158 — TS aggregation + postprocessing flow (canonical)
Flow: TS creation (Grid with reco + MC) → transfer to GSI (Marian) → data aggregation + derived-variable definition (GSI, Marian) → CCDB creation for analysis (GSI, Marian) → default reports (in aggregation jobs as post-processing — year + period summaries).
**Data volumes:**
- Summary grouping 10000 TF ~ 2.4 GB/year/pass
- Detailed grouping 20 TF ~ 1.2 TB/year/pass
- CCDB with selection mask TBD (fraction of vars at byte precision)
**File sizes:**
- `timeSeries10000_apass1.root` 1.3 GB
- `timeSeries10000_apass2.root` 176 MB
- `timeSeries10000_apass3.root` 2.4 GB
- `timeSeries10000_apass4.root` 1.8 GB
**Tags:** #aggregation-flow #gsi #ccdb #data-volumes #file-sizes

## Slide 159 — TS 2023 (GB10000) — TPC DCAr apass3 (canonical)
C1&C2 fluctuations in PbPb: visible in mean + std, ~4% of total time affected. Sector A fluctuations in pp — under investigation. Similar fluctuations in apass3 and apass4. Likely data or calibration issue — specifically **problem in the reference distortion map** (finding absorbed from later slide 184 per Karpathy-compounding; canonical map shows evolution). Plots: ΔDCAr (cm) C/A side, σDCAr > 0.2 cm per side.
**Tags:** #2023 #apass3 #c1c2 #4-percent-time #pp-a-side #reference-map-problem
**Provenance:** finding on reference distortion map added 2026-04-19 during review cycle 1; original canonical content stated only "Most probably in data or calibration".

## Slide 160 — TS 2023 (GB10000) — TPC DCAr apass4
Same pattern as apass3. C1&C2 PbPb ~4% total time. Other-sector fluctuations <1% of time. Sector-A in pp under investigation. PbPb apass4 only apass4_test available.
**Tags:** #2023 #apass4 #apass4-test #1-percent

## Slide 161 — A-side steps in some periods (apass3, apass4)
Bug in TS extraction? Or serious problem. Very similar structure apass3 vs apass4. To understand. Effect present before TS aggregation.
**Data:** `alice/data/2023/LHC23f/535087/apass4/1200/TimeseriesTPCmerging/Stage_5/001/o2_timeseries_tpc.root`
**Tags:** #bug-hypothesis #a-side-step #535087 #lhc23f

## Slide 162 — 2024 first TS random observation
Incorrect sector binning applied (intended 3 bins/sector; currently 1 bin/sector) — DPG script to fix. Sector modulation: DCA focused on A side, particularly A11. Tangential bias ~ 0.2 cm (1σ intrinsic at very high pT). q/pT bias ~ ±0.6 cm (1σ). Stronger modulation over time for positive charges (IDC-scaling imperfection) as expected for ExB.
**Data:** `/lustre/alice/users/miranov/NOTESData/alice-tpc-notes/JIRA/O2-4592/alice/data/2024/LHC24af/apass1/550858r`
**Tags:** #2024 #lhc24af #550858 #a11 #binning-bug #dpg-script #idc-scaling #ExB

## Slide 163 — TS 2024 — TPC DCAr apass1+cpass0
A11±1 fluctuation. RMS > 0.2 cm in 0.3% of cases. Systematic bias visible during RMS fluctuation. Hotspots in higher-trip-rate sector A00. Systematic bulk distortion bias 0–0.4 cm (2σ resolution).
**Tags:** #2024 #a11 #a00 #trip-rate #0-3-percent

## Slide 164 — Section header: Preparation for PbPb 2024 (postponed)
**Tags:** #section-header #pbpb-2024 #postponed

## Slide 165 — Distortion calibration — remaining issues
Reference: intrinsic DCA resolution ~0.15 cm high-pT and 1 cm at 0.2 GeV. **Sector edges distortion fluctuation**: onset 25 kHz, mostly C1&C2, ~1.5 cm, → ITS matching loss. Solution: new calibration based on TS + analytical models. **DCA bias (q/pT bias)**: linear in q/pT × rate; 1.5σ (1.5 cm at 0.2 GeV) at 38 kHz. Solution: method improvement or effective Δ correction. **Edge bias at IFC**. Solution: tracks biased at edges → modify TPC-ITS + TPC-TPC sector-boundary matching for dual-sided calibration sample with precise interpolation. Rate-dependent.
**Tags:** #remaining-issues #25khz-onset #1-5cm #tpc-tpc-matching #interpolation

## Slide 166 — Reconstruction modification
TRD-like algorithm to reduce algo sensitivity to occupancy. Improve TPC-TPC + TPC-ITS matching via track combinator → improve matching eff + calibration sample for distortion correction.
**Tags:** #reco-modification #trd-like #track-combinator

## Slide 167 — Open questions from last meeting
Had to leave earlier — questions unanswered again. 3 open: (1) **Distortion fluctuation onset — Run1/Run2 experience for Run3**: sector-boundary fluctuation shows similar pattern (feedback loop); Run1/Run2 was wire scratch, Run3 something different; different time scales + onsets Run2 vs Run3. (2) **Occupancy impact on cluster resolution**: σy scales with occupancy smoothly across radius (not step-function) → "positive" common-mode impact on cluster resolution negligible vs local overlaps; dEdx impact likely significant (need to differentiate CM vs overlap). (3) **Occupancy fluctuation PbPb vs pp**.
**Tags:** #open-questions #feedback-loop #wire-scratch #cm-vs-overlap

## Slide 168 — (Blank)
**Tags:** #blank

## Slide 169 — (Blank)
**Tags:** #blank

## Slide 170 — Cluster resolution occupancy dependence — smooth with radius
**Tags:** #cluster-resolution #smooth #radial-profile

## Slide 171 — (Blank)
**Tags:** #blank

## Slide 172 — Section header: Service work + reconstruction/calibration modification
**Tags:** #section-header #service-work

## Slide 173 — Outlook — high rate / high occupancy prep
Service work for combined tracking+calibration+MC — TS + QA/QC parameterization (2 candidates from India institutes). Prep for high-rate high-occupancy PbPb: (1) resolution worsening — Run1 TRD-like algo in progress; (2) matching-eff worsening — better track combinator (Run1/Run2) e.g. central events 10% eff loss vs peripheral; (3) distortion-map biases — edge biases (input selection), sector-boundary fluctuation (onset ~25 kHz); (4) PID — linear worsening bias + resolution.
**Links:** indico 1395807/contrib 5866948/snapshot · indico 1417779 (update on TS usage)
**Tags:** #outlook #high-occupancy #run1-trd #trk-combinator #10-percent-central

## Slide 174 — Section header: TS + expert QA service work
**Tags:** #section-header #service-work

## Slide 175 — Service work: combined reconstruction + PID
New candidates (C++/Python/O2 analysis skills) recommended by Pritam (former GSI service worker on Run2 pass2 expert QA): Rahul Verma <rahul.verma@cern.ch>, Yash Patley <yash.patley@cern.ch>. Crucial for: QA with time granularity + perf parameterization for corrections, MC/data remapping, physics analysis. Relevant for pp reference data taking. 2 sources: TS (high time granularity → fluctuation) + expert skim (high parametric-space granularity: q/pT, φ, tgl, occupancy, rate). Data + MC reports aggregated for remapping. Combined granular maps for correction + remapping + event selection + cut variation.
**Tags:** #rahul-verma #yash-patley #pritam #service-work #pp-reference

## Slide 176 — PbPb apass2 — C1&C2 (repeat of 156, 84)
**Tags:** #backup-duplicate #c1c2

## Slide 177 — PbPb apass2 — A-side (repeat of 115)
**Tags:** #backup-duplicate #v-shape

## Slide 178 — TS Variables (repeat of 154)
**Tags:** #backup-duplicate

## Slide 179 — TS Availability (repeat of 110, 155)
**Tags:** #backup-duplicate

## Slide 180 — Variation in physics analysis cuts (pure-duplicate of 157)
Pure repeat of evolved slide 157 (itself evolved from canonical 104). No new content.
**Tags:** #backup-duplicate

## Slide 181 — dEdx TS TF selection (repeat of 92)
**Tags:** #backup-duplicate #dedx

## Slide 182 — Eff TS TF selection (repeat of 93)
**Tags:** #backup-duplicate #efficiency

## Slide 183 — TS aggregation flow (repeat of 158)
**Tags:** #backup-duplicate #aggregation-flow

## Slide 184 — TS 2023 apass3 DCAr (evolved — finding absorbed into 159)
Same as slide 159 plus the concluding note: "problem in the reference distortion map". Per Karpathy compounding, this finding has been **promoted into canonical slide 159** above. This entry is retained for historical provenance.
**Tags:** #evolved #absorbed-into-159 #reference-map-problem

## Slide 185 — TPC residual distortion (repeat of 5)
**Tags:** #backup-duplicate #tpc-distortion

## Slide 186 — TPC PID pseudo-invariances (repeat of 30)
**Tags:** #backup-duplicate #pid #invariances

## Slide 187 — Section header: TPC→ITS Δ maps at vertex
**Tags:** #section-header

## Slide 188 — Section header: Reconstruction modification
**Tags:** #section-header

## Slide 189 — (Blank)
**Tags:** #blank

## Slide 190 — Section header: Default summary TS plot
**Tags:** #section-header

## Slide 191 — Maximal information approach
Run1/Run2 reconstruction much better than Run3 because optimized for performance. Run1/Run2 eff for findable tracks, V0, kink decays close to 100%. Run3 V0-finder central-vs-peripheral factor 10 eff drop. Goal: import Run1 algo to recover eff + resolution.
**References (workshops/conferences):**
- CHEP 2003: TPC tracking + PID high density (M.Ivanov, K.Safarik, Y.Belikov, J.Bracinik) — www-conf.slac.stanford.edu/chep03; proc arxiv.org/physics/0306108
- CHEP 2004: Track reco high density (TPC+ITS+Kink+V0)
- CHEP 2006: TRD tracking — indico 408139/contrib 979783
- Time05: Workshop on Tracking in High Multiplicity Environments — lhcb.physik.unizh.ch/time05
- Tracking Workshop 2012 / 2014 — indico.gsi.de/conferenceDisplay.py?confId=1469 / confId=2715
**Tags:** #run1-recovery #chep-2003 #chep-2004 #chep-2006 #time05 #v0-finder

## Slide 192 — Global reconstruction
Run3 TPC reco effective but global reco suffers from lack of info. Resolution dep on occupancy via cluster overlap dominates high-rate worsening → TRD-like refit. Port Run1 track combinator: matching under primary hypothesis (select gold tracks) then secondary hypothesis.
**Tags:** #global-reco #trd-like-refit #track-combinator #gold-tracks

## Slide 193 — Tracking performance — occupancy dependence
Limited precision in cluster unfolding — significant improvement not feasible: cluster shape depends on local track properties (association during tracking); even with known track, shape has high fluctuation. Unfolded clusters → significantly worse position/PID resolution + bias. Cluster overlaps (random) worsen perf along trajectory. Improvement: combine track/tracklet/cluster info in track refit.
**Links:** CHEP 2003 proceedings inspirehep.net/literature/621229 · CHEP 2006 slides + proceedings indico 408139
**Tags:** #cluster-unfolding #tracklet #run1-reference

## Slide 194 — Cluster(s) - tracklet association + cluster joining during refit
No raw-digit access in refit — cluster-finder unfolding should be optimized for high-pT small-angle shape. Can join "fake split" clusters if consistent with expected track shape. Split clusters for highly inclined tracks rejoinable during refit. Rejoined clusters wider than isolated → need optimal weights for track/tracklet refit via statistical estimators of local + global track properties.
**Tags:** #cluster-joining #fake-split #refit-weights

## Slide 195 — Improving tracking — combining track/tracklet/cluster info
Combined info significantly improves tracking. Local tracklet-angle error depends on lever arm. Sensitive to local overlaps — few pad-rows unreliable. Using full track info → excellent angular resolution. Robust tracklet fit: 1-param fit via median or LTS minimization. LTS error estimation. Δ angle (tracklet-track) scales tracklet error above Nσ outlier region.
**Tags:** #tracklet-fit #lts #median-fit #angular-resolution

## Slide 196 — Section header: TOF information
**Tags:** #section-header #tof

## Slide 197 — TOF info in AO2D + expert skim
Info for ML: ΔY, ΔZ (increasing search road); integral time (per hypothesis) + length (Δ); integral material budget after TPC; flags for multi-cluster-to-track. Usage — conditional tracking as post-correction: ΔY/ΔZ correct for wrong mass hypothesis (tracking mass + TOF PID) — recover TPC crossing points; adjust for electron bremsstrahlung; compensate imperfect drift velocity + distortion. Conditional correction for deep secondaries (decay radius + mother mass). Background probability: absorption/decay.
**Tags:** #tof #ao2d #conditional-tracking #bremsstrahlung #deep-secondary

## Slide 198 — TOF matching — residual coding in AO2D trackQA table
Precision determined by MS. Extrapolation errors (dX, dY): ~ linear in αMS (exact value depends on material budget). `αMS ~ α0 (+) q/pT · 1/β`. Coding in AO2D: dX, dY coded with σ/4 precision → 2 × 1 Byte (or 2 × 4 bits after compression). MAE dZ vs q/pT × (dEdx/MIP), MAE dZ vs q/pT. Low vs high-pT `dZ:dY` plots shown.
**Tags:** #tof-residual #trackqa #sigma-over-4 #multiple-scattering

## Slide 199 — (Blank)
**Tags:** #blank

## Slide 200 — TODO
Standard overview reports in time + parametric space as part of std QA reports. Finish CCDB entry for analysis event + track cuts (originally planned).
**Tags:** #todo #qa-reports #ccdb-entry

## Slide 201 — z / radius (visual labels only)
**Tags:** #visual-only

## Slide 202 — (Blank)
**Tags:** #blank

## Slide 203 — (Blank)
**Tags:** #blank

## Slide 204 — Section header: Sampling triggers + Downsampling
**Tags:** #section-header #downsampling #triggers

## Slide 205 — Downsampling triggers (cut sets table)
| Cut set | PID selection | Kinematic selection | Intended use |
|---|---|---|---|
| PID-tight | Very strict | Loose | Validate kinematic fits |
| Kinematic-tight | Loose | Very strict | Parameterise PID biases + resolution |
| Balanced (n-σ) | Moderate | Moderate | Yield studies |
| Open cut | Minimal | Minimal | Efficiency corrections |
| MB selection | — | — | Validate all above |
**Tags:** #cut-sets #trigger-table #n-sigma #mb

## Slide 206 — Derived data sets
Downsampled triggers. Tables: Track, trackExtra, trackQA (full); V0 topologies (basic info for selection: DCA, pointing angle, momenta); collision info; occupancy table (for now too much memory).
**Tags:** #derived-tables #v0-topology #occupancy-table #memory

## Slide 207 — Downsampling using PDF (groupby, histograms)
N sets of histograms define PDF: `pdf_normi(x,y,z) * rndm < fractioni`. One variable = occupancy: `pdf(occu, pT) ~ pdf(occu) * pdf(pT)`. Histograms have limited stats → PDF fluctuates.
**Tags:** #pdf-downsampling #histograms #occupancy-weighting

## Slide 208 — Check 1 — pT spectra with weighting
Compare pT spectra of tracks + V0 with weighting.
**Code:**
```
tree->Draw("V0.pt>>hisMB(100,0,10)","(1/weightmb)*isMB")
tree->Draw("V0.pt>>hisHPT(100,0,10)","(1/weighthpt)*isHpt")
```
**Tags:** #weighting #v0-pt #validation

## Slide 209 — Section header: TS 2025/2024 fluctuation comparison
**Tags:** #section-header #2025 #fluctuation-comparison

## Slide 210 — Time series — storage + naming convention
GB ±10 TFs merged per file at GSI. GB 10000 TF merged per period at GSI lustre + alien with aliEn naming:
- Lustre: `/lustre/alice/users/miranov/NOTESData/alice-tpc-notes/JIRA/O2-4592/<alien_path>`
- Alien: `/alice/cern.ch/user/t/tpcdrop/timeSeriesDerived/<alien_path>`
- Example: `alice/data/2025/LHC25ac/apass1/timeSeries10000.root`

Variable naming: `<var><statTF><statGB>` where var = kinematical/dEdx/QA; statTF = per-TF stat (Mean/Median/rms); statGB = groupby stat (10 or 10000 TF, Median/std).

**ROOT style / setup snippet:**
```
.x $NOTES/aux/NimStyle.C
SetStyle(0);
gStyle->SetOptTitle(1)
timeSeries->SetAlias("qpt","(subentry-92)*5/8.")
```
**Tags:** #storage-paths #alien #naming-convention #variable-naming #2025

## Slide 211 — LHC25ac TS GB 10000 TF — DCA bias
Significant DCA modulation (Median_Median) within fills (bg/"signal"), more pronounced A-side but also visible C-side → needs time- and IDC-dependent calibration. DCA fluctuation (Median_std) more pronounced C-side — origin under investigation (IFC instability indication — IFC current noisy C-side, not A-side).
**Data:** `/lustre/alice/users/miranov/NOTESData/alice-tpc-notes/JIRA/O2-4592/alice/data/2025/LHC25ac/apass1/figPresentation`
**Code:**
```
TFile f("../timeSeries10000.root")
timeSeries->SetMarkerStyle(25); timeSeries->SetMarkerColor(2)
timeSeries->Draw("mTSITSTPC.mDCAr_C_Median_std:qpt","indexType==2&&mTSITSTPC.mDCAr_A_Median_std<0.1","prof")
timeSeries->SetMarkerColor(1)
timeSeries->Draw("mTSITSTPC.mDCAr_A_Median_std:qpt","indexType==2&&mTSITSTPC.mDCAr_A_Median_std<0.1","profsame")

timeSeries->SetMarkerStyle(1); TCanvas c("","",1200,500)
timeSeries->SetMarkerColor(1)
timeSeries->Draw("mTSITSTPC.mDCAr_A_Median_median:time","indexType==4&&mTSITSTPC.mDCAr_A_Median_std<0.1","")
timeSeries->GetHistogram()->GetXaxis()->SetTimeDisplay(1); gPad->Draw();
timeSeries->SetMarkerColor(2)
timeSeries->Draw("mTSITSTPC.mDCAr_C_Median_median:time","indexType==4&&mTSITSTPC.mDCAr_A_Median_std<0.1","same")
gPad->SaveAs("dca_bias_time_AC.png")
```
**Tags:** #lhc25ac #apass1 #2025 #ifc-instability #dca-modulation #idc-calibration

## Slide 212 — Section header: TS example slides
**Tags:** #section-header

## Slide 213 — Section header: LHC25ah cpass0
**Tags:** #section-header #lhc25ah #cpass0

## Slide 214 — LHC25ah cpass0 (visual)
**Tags:** #lhc25ah #cpass0

## Slide 215 — LHC25ah apass1 — fluctuation + residual calibration bias
Strong time / q/pT / tgl dependence; A-side largest bias (IFC modulation); C-side also affected (IFC CE modulation). Use time-dependent calibration; interim: homogeneous time coverage (skip first hour) → keep bias ≤ 0.2 cm (~1σ). DCA vs time vs sector (color).
**Tags:** #lhc25ah #apass1 #ifc-modulation #ifc-ce-modulation #skip-first-hour #0-2cm

## Slide 216 — LHC25ah apass1 — fluctuation + calibration bias (detail)
Same narrative as 215. Plots: DCA A-side vs time vs q/pT (color); DCA A-side vs time vs tgl (color); DCA C-side vs time vs tgl (color); DCA A-side vs time vs q/pT (color). Interim: skip first hour → bias ≤ 0.2 cm.
**Tags:** #lhc25ah #apass1 #dca-plots #interim-strategy

---

## Open items `[VERIFY]`

Tracked pending items. Addressable before DRAFT → APPROVED.

| ID | Severity | Cycle | Item | Status | Proposed resolution |
|---|---|---|---|---|---|
| V-1 | P2 | 1 | Front-matter `date` and `venue` unresolved | open | Fetch metadata from original talk announcement (venue likely ALICE offline / TPC weekly; look up date from indico event list) |
| V-2 | P2 | 1 | Slide 66 vs slide 53: ITS resolution stated as 0.6-5 cm vs 0.6-3 cm respectively | open — needs Marian | Confirm current figure. Likely 0.6-3 cm original; 0.6-5 cm later update reflecting worse high-occupancy ITS performance; needs source confirmation |
| V-3 | P2 | 1 | External URL reachability not audited (Google Docs, gitlab.cern.ch, indico, github) | **partial — cycle 2** | Inventory + categorization built in sibling file `O2-4592_link_audit.md`; reachability polling deferred (web_fetch tool limited to user-provided URLs). Cycle 3 target: run `curl -I` sweep in network-enabled session, fill in `last_checked`/`last_status` columns |
| V-4 | P2 | 1 | Slide 184 finding promoted into canonical 159 per P2-7 — Marian approval pending | open — needs Marian | Confirm Karpathy-compounding edit is acceptable; if strict historical faithfulness preferred, revert and mark 184 as `#evolved` separately |
| V-5 | P3 | 1 | Several slides marked `#blank` (74, 105, 135, 168, 169, 171, 189, 199, 202, 203) — intentional or true blanks? | deferred | Pass while building decks 2-10: if pattern recurs, establish convention |
| V-6 | P3 | 2 | `#reused` tag used 7× in body but predates 3-category schema | documented | Marked deprecated in Tag taxonomy appendix. Retrofit deferred per no-retrofit policy; lint catches drift on new writes |

## Related wiki pages

(Per Karpathy compounding — add links as sibling concept pages are built.)

- Detector overviews:
  - `../detectors/tpc.md` — TPC overview (touched throughout this deck)
  - `../detectors/its.md` — ITS overview (slides 31, 46, 87, 89, 107, 125, 137, 150)
  - `../detectors/tof.md` — TOF (slides 101, 196–198)
  - `../detectors/emcal.md` — EMCAL (slide 33)
  - `../detectors/trd.md` — TRD (slides 166, 173)
- Sibling presentations (when indexed):
  - Other O2-4592 series talks on TPC distortion + skimmed data
  - PWGPP tracking performance talks (service-work related — Verma, Patley)
- Methodology / reference:
  - `../methods/rootinteractive.md` — dashboard framework (slides 15, 21, 56, 138)
  - `../methods/groupby-performance-maps.md` — the primary-skim → N-dim-maps workflow
  - `../references/run1-tpc-reco.md` — CHEP 2003/2004/2006 refs (slides 191, 193)

## Tag taxonomy

Controlled vocabulary for this file. Retrofit of body tags deferred — this appendix declares the intended set so future lint runs can flag drift.

### Hardware / detector
`#tpc` `#its` `#tof` `#emcal` `#trd` `#ifc` `#oroc` `#iroc`

### Phenomena
`#distortion` `#v-shape` `#c1c2-fluctuation` `#sector-edge` `#dead-zone` `#induced-signal` `#charging-up` `#ExB` `#sticky-wires` `#capacitive-coupling`

### Performance
`#dca-bias` (use as umbrella; `#dcar-bias`, `#dcaz-bias` deprecated — merge into `#dca-bias`)
`#dca-resolution` `#matching-efficiency` `#fake-match` `#qpt-bias` `#occupancy` `#cluster-overlap` `#intrinsic-resolution` `#resolution-model`

### Methods
`#groupby` `#rdataframe` `#rootinteractive` `#rolling-window` `#nd-maps` `#factorization` `#kalman-gain` `#ml-correction` `#post-correction` `#mc-data-remapping`

### Workflow
`#time-series` `#skimmed-data` `#ctf-tagging` `#tf-selection` `#ao2d` `#ccdb` `#production-scan` `#cut-variation` `#selection-categories`

### Data / period
`#pbpb-2023` `#pbpb-2024` `#pbpb-2025` `#apass1` `#apass2` `#apass3` `#apass4` `#cpass0` `#cpass1` `#cpass7` `#cpass8` `#lhc23zzh` `#lhc24ar` `#lhc24af` `#lhc25ac` `#lhc25ah`

### Reuse / meta
`#canonical` `#evolved` `#backup-duplicate` `#absorbed-into-<N>` `#section-header` `#backup` `#blank` `#reference-numbers` `#open-question` `#verify`

### Notation conventions (controlled)
- Use `q/pT` (slash + capital T) for the physical quantity in prose.
- Use `qpt` (lowercase, no slash) only when quoting code literals (e.g. `tree->SetAlias("qptSel",...)`). 
- Full-text search should match both; controlled body usage follows above.

### Deprecated / merge-on-sight
- `#distortion-fluctuation` → `#distortion` + context tag
- `#cm-not-simulated` `#cm-vs-overlap` → `#common-mode` + note
- `#dcar-bias` `#dcaz-bias` → `#dca-bias`
- `#reused` → 7× in body predates the 3-category schema. On canonical slides replace with `#canonical`; on duplicate/evolved slides drop (the `#backup-duplicate` / `#evolved` tags carry the semantics). Retrofit deferred per no-retrofit policy; lint should flag on new writes.

---

**Review trail**
- 2026-04-19 — Ingested from Google Slides HTML export. Slide-by-slide index created.
- 2026-04-19 — Review cycle 1: Claude3-Reviewer-v0 filed 7 × P2. Addressed:
  - P2-1: Canonical reuse map upgraded to 3-category schema (`canonical` / `pure-duplicates` / `evolved`).
  - P2-2: Content-drift cases ledgered in Open items above.
  - P2-3: Front-matter expanded with `wiki_class`, `source_fingerprint`, review status.
  - P2-4: Related wiki pages section added (links resolve as sibling pages are built).
  - P2-5: Tag taxonomy appendix added (no retrofit; forward-going lint target).
  - P2-6: `TBD` → `[VERIFY]` in front-matter; tracked in Open items V-1.
  - P2-7: Slide 184 finding absorbed into canonical slide 159 (Karpathy compounding, option a). Slide 184 retained as historical-record entry. Marian approval pending (V-4).
- 2026-04-19 — Review cycle 2: self-lint + V-3 partial resolution.
  - Cycle-2 lint confirmed: 216/216 slides present; canonical/evolved annotations consistent with the 3-category map; 17 canonical + 6 evolved slides tagged in body match the map header.
  - Cycle-2 finding V-6 (new P3): `#reused` tag (7× in body) predates the 3-category schema. Documented as deprecated in Tag taxonomy appendix; retrofit deferred.
  - V-3 partial: URL inventory + categorization produced as sibling file `O2-4592_link_audit.md` (15 distinct external refs). Independent reachability polling deferred — `web_fetch` tool in this session is limited to user-provided URLs (same constraint Claude3-Reviewer-v0 and ClaudeOpus47 declared). Cycle 3 auditor should run a `curl -I` sweep in a network-enabled session.
- **Status:** DRAFT → awaiting V-1, V-2, V-4 resolution (3 items need Marian input or cycle-3 audit).
