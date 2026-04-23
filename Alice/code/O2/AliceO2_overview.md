---
wiki_id: O2_AliceO2_overview
title: "AliceO2 — the ALICE Run 3 Online-Offline computing framework: overview, motivation, and entry points"
project: MIWikiAI / ALICE
folder: code/O2
source_type: software-index
source_status: DRAFT v0.5 — cycle-1 micro-bump applying panel synthesis on v0.4; architect gate 1 pending
source_fingerprint:
  upstream:
    - id: AliceO2-GitHub-root
      title: "AliceO2Group/AliceO2 — repository root (dev branch)"
      url: "https://github.com/AliceO2Group/AliceO2"
      branch: "dev"
      commit_verified: "87b9775"
      commit_evidence: "PR #15202 (aalkin, DPL: Better detection for injected workflows, merged 2026-03-26); Claude5 confirmed 1:1 directory match at re-fetch 2026-04-23"
      role: "primary source for directory structure, README.md, doc/ contents"
      accessed: "2026-04-21, re-verified 2026-04-23 by Claude5"
    - id: AliceO2-GitHub-README
      title: "AliceO2 repository README.md"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/README.md"
      role: "primary source for repo scope statement, documentation pointers, build and issue-tracking narrative"
      accessed: "2026-04-21"
    - id: O2-Quickstart-Overview
      title: "Overview of the ALICE O² computing system (Newcomers' guide)"
      url: "https://aliceo2group.github.io/quickstart/overview.html"
      role: "primary source for why O² exists, requirements, compression factor, data-flow narrative"
      accessed: "2026-04-21"
    - id: O2-Quickstart-FairDPL
      title: "FairMQ and DPL (Newcomers' guide)"
      url: "https://aliceo2group.github.io/quickstart/fair-dpl.html"
      role: "primary source for the FairMQ/DPL/ALFA stack and what 'Device', 'Workflow', 'DataProcessor' mean in O²"
      accessed: "2026-04-21"
    - id: O2-Quickstart-Organisation
      title: "Code organisation (Newcomers' guide)"
      url: "https://aliceo2group.github.io/quickstart/organisation.html"
      role: "primary source for the AliceO2Group 10-repository map"
      accessed: "2026-04-21"
    - id: O2-Quickstart-WP
      title: "Work Packages (Newcomers' guide)"
      url: "https://aliceo2group.github.io/quickstart/wp.html"
      role: "primary source for the 17-work-package organization and WP responsibles"
      accessed: "2026-04-21"
    - id: O2-Quickstart-Landing
      title: "ALICE O² Quickstart landing page"
      url: "https://aliceo2group.github.io/"
      role: "primary source for quickstart navigation"
      accessed: "2026-04-21"
    - id: AliceO2-Doxygen-Published
      title: "AliceO2 Doxygen published documentation"
      url: "https://aliceo2group.github.io/AliceO2/"
      role: "primary source for published class documentation (Module 3 will cite class signatures from here)"
      accessed: "2026-04-21"
    - id: AliceO2-CMakeInstructions
      title: "doc/CMakeInstructions.md — CMake and CTest tips for AliceO2"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/doc/CMakeInstructions.md"
      size: "458 lines, 22.7 KB"
      role: "primary source for CMake authoring conventions (o2_add_library, o2_add_executable, o2_add_test, o2_target_root_dictionary)"
      accessed: "2026-04-21"
    - id: AliceO2-DoxygenInstructions
      title: "doc/DoxygenInstructions.md — Doxygen authoring conventions"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/doc/DoxygenInstructions.md"
      role: "primary source for README.md convention linking Doxygen pages via \\page and \\subpage tags"
      accessed: "2026-04-21"
    - id: O2-TDR
      title: "ALICE Technical Design Report — Upgrade of the Online-Offline computing system (CERN-LHCC-2015-006 / ALICE-TDR-019)"
      url: "https://cds.cern.ch/record/2011297"
      role: "authoritative ALICE-collaboration design document for O²; cited by URL and summary only"
      accessed: "2026-04-21"
    - id: O2-CHEP2023-arXiv
      title: "The O² software framework and GPU usage in ALICE online and offline reconstruction in Run 3 (Eulisse & Rohr, arXiv:2402.01205)"
      url: "https://arxiv.org/abs/2402.01205"
      role: "peer-reviewed reference for in-production O² architecture, synchronous/asynchronous phases, FLP/EPN layers, TF lengths, compression factors"
      accessed: "2026-04-21"
    - id: O2-FLP-CHEP2023
      title: "The new ALICE data acquisition system (O²/FLP) for LHC Run 3 (Costa et al., EPJ Web Conf. 295, 02029, 2024)"
      url: "https://cds.cern.ch/record/2919265"
      role: "peer-reviewed reference for FLP farm architecture, 200 nodes, 500 PCIe cards, 8000 optical links, 15 subdetectors"
      accessed: "2026-04-21"
    - id: CERN-Courier-ALICE-O2
      title: "ALICE ups its game for sustainable computing (CERN Courier, 2023)"
      url: "https://cerncourier.com/a/alice-ups-its-game-for-sustainable-computing/"
      role: "community-magazine narrative with quantitative data-flow figures; cross-referenced against peer-reviewed sources"
      accessed: "2026-04-21"
    - id: ALICE-Experiment-Web
      title: "ALICE O² project website"
      url: "https://alice-o2-project.web.cern.ch"
      role: "ALICE-collaboration entry point referenced by the repo README"
      accessed: "2026-04-21 (referenced, not crawled)"
  introduction_only:
    - id: O2RecoAI-TS-v1.3
      title: "Technical_Summary_O2RecoAI_v1.3 (2026-02-13)"
      author_team: O2RecoAI
      role: "NOT A PRIMARY SOURCE. Orientation document. Every claim carried forward has been re-verified against AliceO2 dev branch and tagged with a primary-source tag."
  summary_contributors: [{id: Claude8, role: indexer}]
source_inconsistencies:
  - id: CONFLICT-1
    topic: "Baseline for the 100× rate-increase multiplier (Run 1 vs Run 2)"
    description: "Run 3 records Pb–Pb at 50 kHz. Two primary sources use different baselines to state the 100× multiplier. Initial v0.3/v0.4 synthesis framed this as 'one source is physically wrong.' Claude5 F-new1 correction (2026-04-23), citing arXiv:2106.08353 (Kvapil et al., ALICE Central Trigger System for Run 3), establishes that both baselines are physically correct: Run 1 and Run 2 both had ALICE recorded Pb–Pb rates of approximately 1 kHz (TPC-readout-limited in both runs), so the 100× multiplier holds against either baseline."
    sources:
      - {id: O2-Quickstart-Overview, value: "100× Run 1 (2010–2012)", verbatim: "This will results in an event rate 100 times higher than during Run 1 (2010-2012)."}
      - {id: O2-CHEP2023-arXiv, value: "100× Run 2", verbatim: "100 times higher than during Run 2"}
      - {id: CERN-Courier-ALICE-O2, value: "continuous-readout without trigger (no explicit baseline multiplier)", verbatim: "recording Pb–Pb collisions at rates up to 50 kHz"}
    external_verification:
      - {id: Kvapil-ALICE-CTS, url: "https://arxiv.org/abs/2106.08353", role: "Peer-reviewed ALICE source not cited in wiki body; fetched by Claude5 for cycle-1 F-new1 verification", verbatim: "The designed interaction rate was 8 kHz for Pb–Pb and 100 kHz for pp collisions. The maximum readout rate was around 1 kHz due to the space-charge and bandwidth limitations of the Time Projection Chamber detector ... factor of up to about 100 with respect to LHC Runs 1 and 2"}
    physical_check: "Per Kvapil et al. (2021): ALICE recorded Pb–Pb rate was ~1 kHz in Run 1 AND Run 2 (both TPC-readout-limited). Therefore 50 kHz / 1 kHz = 100× applies equally against Run 1 or Run 2 baselines. The v0.3 synthesis argument '50/8 ≈ 6× vs Run 1' was incorrect because it compared a Run-2 INTERACTION rate (8 kHz) against the Run-3 RECORDED rate (50 kHz), which is apples-to-oranges."
    chosen: "Run 2 as canonical in-body phrasing"
    rationale: "Both sources are correct. Wiki adopts 'Run 2' as canonical because (i) arXiv:2402.01205 is peer-reviewed and is the more recent O² reference, and (ii) 'Run 2' is the more common convention in current ALICE collaboration documentation. The quickstart's 'Run 1' phrasing is NOT an editorial error; it uses a different but equally valid baseline. The [CONFLICT-1] inline marker exists so readers understand why two primary sources use different baselines."
    discovered_by: "Claude7 (D primary, cycle-1 v0.3 — initial flag), Claude2 (A secondary, cycle-1 v0.3 — concurrence), Claude4 (F primary, cycle-1 v0.3 — concurrence), Claude5 (F secondary, cycle-1 v0.4 — F-new1 reframe via external source fetch of Kvapil et al.), Claude1 (A primary, cycle-1 v0.4 — independent concurrence on reframe)"
  - id: CONFLICT-2
    topic: "TPC raw data rate"
    description: "Multiple sources cite slightly different values for the aggregate ALICE raw data rate."
    sources:
      - {id: O2-CHEP2023-arXiv, value: "3.5 TB/s (aggregate, §2 'The O² computing farm')"}
      - {id: O2-Quickstart-Overview, value: "3.4 TB/s (aggregate)"}
      - {id: CERN-Courier-ALICE-O2, value: "3.3 TB/s (TPC front-end only)"}
    chosen: "3.5 TB/s"
    rationale: "arXiv is the most recent peer-reviewed value and represents the in-production design target. CERN Courier's 3.3 TB/s is TPC-front-end only, not aggregate. Quickstart's 3.4 TB/s may reflect an earlier design estimate. Wiki uses 3.5 TB/s with [CONFLICT-2] marker in §1.1 and §2.1."
    discovered_by: "Claude7 (D primary), Claude4 (F primary)"
  - id: CONFLICT-3
    topic: "LHC Long Shutdown 2 end date"
    description: "Sources disagree whether LS2 ended in 2020 (original plan) or 2022 (actual)."
    sources:
      - {id: CERN-Courier-ALICE-O2, value: "2019–2022"}
      - {id: O2-Quickstart-Overview, value: "2019–2020"}
    chosen: "2019–2022"
    rationale: "CERN Courier is the more recent publication and reflects the actual delivered schedule (LS2 extended past its 2020 plan). Wiki uses 2019–2022 with [CONFLICT-3] marker in §1.1."
    discovered_by: "Claude1 A-primary (assignment), Claude2 A-secondary"
related_jira_tickets: []
indexed_by: Claude8
indexing_model: Claude Opus 4.7
indexed_on: 2026-04-21
source_last_verified: 2026-04-23
source_verification_depth: "repository root tree verified against GitHub dev branch (Claude8 2026-04-21; Claude5 re-verification 2026-04-23); README.md body verified; 5 quickstart pages fully fetched and cited; 2 doc/*.md files verified including block-quote verbatim (Claude4 fetch); 2 peer-reviewed papers (arXiv:2402.01205, EPJ Web Conf. 295) and 1 CERN Courier article cross-referenced for quantitative claims; external-fetch of arXiv:2106.08353 (Kvapil et al.) by Claude5 to disambiguate CONFLICT-1 rate-baseline framing; Doxygen landing confirmed; TDR and O² project website cited by URL."
review_status: READY_FOR_GATE_1
review_cycle: 1
v0_3_to_v0_4_synthesis_response: "Panel synthesis (Claude7, 2026-04-22) identified 8 convergent findings (CV-1 through CV-8) plus 2 from Claude5 cycle-1. CV-1, CV-4, CV-5, CV-6, CV-7, Claude5 #2, Claude5 #3, and Costa upstream[] promotion addressed in v0.4. CV-2 tag split ([AD] → [TDR] / [PP] / [CC]) architect-approved and applied. CV-3 schema variation (§2/§3 split) pending — proposal amendment drafted in Phase 0.1 v3. CV-8 (§4.2 CMake scope) — architect-sided-with-majority; §4.2 retained."
v0_4_to_v0_5_synthesis_response: "Panel cycle-1 on v0.4 (7 reviewers) produced synthesis (Claude7, 2026-04-23) identifying 8 new P1s (N1–N8) plus 7 carry-forward P2s (P2-a through P2-g). v0.5 applies all fixes per architect-ratified fix-list. CONFLICT-1 reframed per Claude5 F-new1 (arXiv:2106.08353 Kvapil et al. confirms quickstart is not in error; Run 1 and Run 2 had identical ~1 kHz ALICE recorded rates). source_inconsistencies schema architect-ratified for Phase 0.1 v3."
peer_reviewers_assigned: [Claude1, Claude2, Claude3, Claude4, Claude5, Claude6, Claude7]
peer_reviewers_reported: [Claude1, Claude2, Claude3, Claude4, Claude5, Claude6, Claude7]
review_assignment_doc: PHASE_0_1_Review_Module_1_AliceO2_Overview.md
hard_constraints_checked: {correctness: panel-reviewed, reproducibility: panel-reviewed, safety: verified}
staleness: fresh
searchable_keywords:
  - AliceO2
  - ALICE-O2
  - O2-framework
  - online-offline-computing
  - Run-3
  - Run-4
  - LHC-Long-Shutdown-2
  - continuous-readout
  - 50-kHz-PbPb
  - 3.5-TBps
  - FLP
  - EPN
  - time-frame
  - synchronous-reconstruction
  - asynchronous-reconstruction
  - Compressed-Time-Frame
  - CTF
  - DPL
  - Data-Processing-Layer
  - FairMQ
  - FairRoot
  - ALFA
  - GPU-reconstruction
  - TPC-tracking
  - Doxygen
  - aliBuild
  - CMake
  - o2_add_library
  - o2_add_executable
  - o2_add_test
  - AliceO2Group
  - ALICE-TDR-019
  - WP4
  - WP13
  - source-inconsistencies
  - CONFLICT-markers
known_verify_flags:
  - "Commit SHA pinned to 87b9775 (PR #15202, 2026-03-26); re-confirmed by Claude5 against HEAD of dev on 2026-04-23 as structurally 1:1 match for top-level directory layout. HEAD may have advanced; structurally stable."
  - "TDR (CERN-LHCC-2015-006) content cited by URL and summary only. Full TDR text is expected to be re-indexed as a separate MIWikiAI TDR/ wiki page."
  - "FLP and EPN node counts (200 FLPs / 350 EPNs, 8 GPUs/EPN) cited from arXiv:2402.01205 (2024) and Costa et al. (2024); may have evolved since paper submission."
wiki_sections_stubbed: []
---

# AliceO2 — the ALICE Run 3 Online-Offline computing framework

## TL;DR

- **AliceO2 is the software that takes raw detector data from the upgraded ALICE experiment at the LHC, compresses it on-the-fly, and reconstructs physics objects (tracks, vertices, PID) for both live data-taking and later offline analysis.** It is the single codebase replacing the historically separate online (HLT) and offline (AliRoot) systems that served ALICE in Runs 1–2. [QS: overview.html; PP: arXiv:2402.01205]
- **Why it exists.** For LHC Run 3 (2022–2025) and Run 4, ALICE upgraded to record minimum-bias Pb–Pb collisions at 50 kHz *without a hardware trigger* — a 100× rate increase over Run 2 [see CONFLICT-1; PP: arXiv:2402.01205]. This produces up to **3.5 TB/s** of raw data [see CONFLICT-2], which is physically impossible to store. O² compresses raw data by a factor of ~30 during live data-taking so only the reduced stream is written to permanent storage. [QS: overview.html §Requirements; CC: CERN Courier; PP: arXiv:2402.01205]
- **Architecture in one sentence.** Detector data flows from the front-end through custom PCIe readout cards into a farm of First Level Processors (**FLPs**, ~200 nodes) which assemble *time frames* (~2.8 ms of continuous data each), then across an InfiniBand fabric to a second farm of Event Processing Nodes (**EPNs**, ~350 nodes with 8 GPUs each) where synchronous reconstruction and TPC data compression produce a **Compressed Time Frame (CTF)** stored to disk. The same code base, scheduled differently, later performs asynchronous reconstruction off the stored CTFs to produce analysis data (AODs). [PP: arXiv:2402.01205; PP: Costa et al. 2024]
- **Software stack.** O² is built on two custom layers stacked on standard C++/Boost/STL: **FairMQ** (message-passing transport, developed by GSI's FairRoot team, shared via the ALFA collaboration) and the **Data Processing Layer (DPL)** on top of it (workflow abstraction; reconstruction is written as a DPL workflow). [QS: fair-dpl.html]
- **What the `AliceO2` repository contains.** The framework itself (`Framework/`), all detector-specific reconstruction, calibration and simulation code (`Detectors/`), GPU reconstruction (`GPU/`), data-format definitions (`DataFormats/`), shared utilities (`Common/`), and global algorithms like ITS–TPC–TRD–TOF track matching. Sibling AliceO2Group repositories (QualityControl, Monitoring, DataDistribution, etc.) provide complementary services. [GH: README.md §Scope; QS: organisation.html]
- **This MIWikiAI page in one sentence.** An entry-point index to `Alice/code/O2/` — repository map, build system, and pointers. Deep content on DPL, DataFormats, and Common lives in sibling wiki pages ([Module 2](./Framework_DPL.md), [Module 3](./DataFormats_Reconstruction.md), [Module 4](./Common_utilities.md)); per-detector content is deferred to wave 2.

## 1. Purpose and scope

### 1.1 What the ALICE experiment is, and why it needs new computing

ALICE — *A Large Ion Collider Experiment* — is one of the four large experiments at the CERN LHC. It is dedicated to the study of the quark–gluon plasma (QGP), the state of matter that existed in the first microseconds of the universe and that can be recreated briefly in ultra-relativistic heavy-ion (Pb–Pb) collisions [PP: arXiv:2402.01205, abstract; CC: CERN Courier]. ALICE records collisions at the LHC interaction point IP2.

The physics programme ALICE needs to address in Run 3 and Run 4 has three specific features that together drove a new computing model [QS: overview.html §Requirements]:

1. **High rate.** After the LHC Long Shutdown 2 (2019–2022 [see CONFLICT-3]), ALICE records minimum-bias Pb–Pb interactions at 50 kHz — roughly **100× the event rate of Run 2** [see CONFLICT-1; PP: arXiv:2402.01205]. Run 1 (2010–2012) and Run 2 (2015–2018) both had ALICE recorded Pb–Pb rates of approximately 1 kHz — limited in both runs by the TPC gating-grid readout. The 50 kHz / 1 kHz = 100× multiplier therefore applies against either baseline per [PP: arXiv:2106.08353]. Wiki adopts "Run 2" as canonical phrasing matching [PP: arXiv:2402.01205]; see [CONFLICT-1] for why primary sources use different baselines.
2. **Small signal, large background, impossible triggering.** Many physics observables of interest have a very small signal-to-noise ratio and a high background, which makes classical trigger-based data reduction inefficient or outright impossible.
3. **Continuous-readout detectors.** The Time Projection Chamber (TPC), ALICE's main tracking detector, has been upgraded with a GEM-based readout that operates *continuously*, not event-triggered; its inherent rate is below 50 kHz [QS: overview.html §Requirements; CC: CERN Courier].

These three together mean that everything the detector sees must be read out, all the time, without trigger selection — producing a raw data rate of up to **3.5 TB/s** [see CONFLICT-2; PP: arXiv:2402.01205 §2]. That is impossible to store. So the solution is not *"write everything to disk and reconstruct later"*; it is *"reconstruct and compress during data-taking, and only the compressed output is written."* That requires merging what used to be two independent software stacks — online (fast, limited) and offline (precise, slow) — into a single framework that runs in both modes.

> **Note on source conflicts.** This section contains three numerical / date claims where primary sources disagree. All three are documented in `source_inconsistencies:` front-matter and marked inline with `[CONFLICT-N]`. Readers who want to dig into the disagreement find the three sources, the verbatim quotes, and the resolution rationale there. This is the convention MIWikiAI will use whenever primary sources conflict — silent selection among disagreeing sources is forbidden.

### 1.2 What AliceO2 (the software) is

The name **O²** is short for "Online-Offline", capturing the central design choice: a unified computing system for both. The `AliceO2` GitHub repository (`https://github.com/AliceO2Group/AliceO2`) is the primary software product of the O² project [GH: README.md §Scope]. Directly from the repo's own README:

> *"The ALICE O2 software repository contains the framework, as well as the detector specific, code for the reconstruction, calibration and simulation for the ALICE experiment at CERN for Run 3 and 4. It also encompasses the commonalities such as the data format, and the global algorithms like the global tracking. Other repositories in AliceO2Group contain a number of large common modules, for instance for Monitoring or Configuration."* [GH: README.md §Scope]

Concretely that means `AliceO2` holds four layers of software stacked on each other:

| Layer | Examples of contents | Where it lives in the repo |
|---|---|---|
| **Framework** | DPL workflow engine, device / message abstractions | `Framework/` |
| **Common utilities and data model** | Physics constants, math helpers, magnetic-field abstraction, reconstruction data formats (Track, Vertex, Cluster, PID, RecoContainer, GlobalTrackID) | `Common/`, `DataFormats/` |
| **Detector-specific code** | Per-detector simulation, reconstruction, calibration, workflow wiring | `Detectors/` (the largest top-level directory) |
| **Global algorithms** | ITS–TPC–TRD–TOF track matching, primary vertexing, secondary vertexing, GPU TPC reconstruction | `Detectors/GlobalTracking/`, `Detectors/Vertexing/`, `GPU/` |

Governance of the framework itself (WP4) is led by Giulio Eulisse; reconstruction and calibration (WP13) is led by Ruben Shahoyan [QS: wp.html]. The project divides into 17 work packages across three sub-projects (FLP, EPN, PDP) — see [§8.3](#83-o-work-packages) for the full map.

### 1.3 What this wiki page is, and what it is not

This page is the **entry-point index** to `Alice/code/O2/` in the MIWikiAI wiki. A reader landing here should come away with:

- a clear picture of what AliceO2 is and why it looks the way it does;
- a repository map pointing to each top-level directory;
- understanding of the build system and documentation workflow;
- pointers to the three sibling wiki pages that index the framework layer in detail.

This page is **not**:
- a tutorial for writing your first DPL workflow (belongs in [Framework_DPL.md](./Framework_DPL.md));
- a catalogue of reconstruction data structures (belongs in [DataFormats_Reconstruction.md](./DataFormats_Reconstruction.md));
- a per-detector description (deferred to wave 2);
- a replacement for the ALICE O² Technical Design Report [TDR: ALICE-TDR-019, CERN-LHCC-2015-006] — that is the authoritative collaboration document for the project's design, and the MIWikiAI `TDR/` folder indexes it separately.

### 1.4 Phase context (MIWikiAI internal)

This is **Module 1 of Phase 0.1** per `PHASE_0_1_Proposal_AliceO2_Framework_Indexation.md` v3 (v3 supersedes v2 with three amendments prompted by this module's cycle-1 review: new primary-source tags, `[CONFLICT-N]` convention, and a ruling on the section-split question). Modules 2–4 (Framework_DPL, DataFormats_Reconstruction, Common_utilities) follow sequentially after architect approval of this module.

---

## 2. How the O² system works at a glance

*Schema note: this section + §3 together correspond to "§2 Directory layout" in Phase 0.1 proposal v2 §2.2. The split was introduced in v0.2 of this page to help human readers understand the context before the directory tree. Phase 0.1 proposal v3 formalizes this variation (see §1.4).*

This section is context, not scope: it exists so that a reader of any downstream wiki page understands where the software they're reading about actually runs. None of the computing-hardware layout lives in the `AliceO2` repository itself — the repo is the software that runs on these machines.

### 2.1 Data flow (simplified)

The production O² data flow, as described in `arXiv:2402.01205` and `aliceo2group.github.io/quickstart/overview.html`:

```
ALICE detectors (15 subdetectors, 8000 optical links)
           │  ~3.5 TB/s raw [CONFLICT-2]
           ▼
  Readout cards (500 custom PCIe, CRU / C-RORC)
           │
           ▼
  FLP farm — First Level Processors (~200 nodes, in CR1)
    — zero-suppression and partial data reduction
    — assembles time frames (~2.86 ms of continuous data each, nominal Pb–Pb)
           │  reduced to ~900 GB/s (single-source: CC CERN Courier)
           ▼
  FLP2EPN InfiniBand fabric
           │
           ▼
  EPN farm — Event Processing Nodes (~350 nodes, 8 GPUs each, in CR0)
    — synchronous reconstruction (calibration + TPC compression)
    — TPC tracking runs fully on GPUs
           │  reduced to ~130 GB/s (single-source: CC CERN Courier)
           ▼
  Compressed Time Frames (CTFs) → permanent storage
           │
           ▼  (hours to days later, when LHC has no beam)
  Asynchronous reconstruction on the same EPN farm
  + WLCG Grid sites
           │
           ▼
  Analysis Object Data (AOD) files for physics analysis
```

References for the quantitative numbers (what each source contributes is explicit):

- **3.5 TB/s raw data rate.** Cross-sourced in arXiv:2402.01205 §2 and, with different values (3.3, 3.4), in CERN Courier and quickstart respectively. See `source_inconsistencies[1]` / `[CONFLICT-2]`.
- **100× Run 2 rate.** arXiv:2402.01205 abstract. Quickstart uses Run 1 as baseline — see `source_inconsistencies[0]` / `[CONFLICT-1]` for why both baselines are physically valid.
- **~900 GB/s after FLP.** [CC: CERN Courier]. **Single-sourced** — awaiting independent confirmation (Costa et al. 2024 may contain a second value; Module 2 or wave-2 FLP page should cross-check). Not currently closure-check CLOSED.
- **~130 GB/s after EPN.** [CC: CERN Courier]. **Single-sourced**, same caveat as above.
- **~200 FLP nodes with 500 readout cards, 15 subdetectors, 8000 optical links.** arXiv:2402.01205; cross-confirmed in Costa et al. (2024) abstract.
- **~350 EPN nodes with 8 GPUs each; TPC reconstruction fully on GPU.** arXiv:2402.01205 §2.
- **Time Frame (TF) length is programmable.** Nominal Pb–Pb configuration uses 32 LHC orbits ≈ 2.86 ms per [PP: arXiv:2402.01205]. LHC orbit period = 89.4 μs. During 2022 high-rate proton stress tests, a longer 128-orbit TF (~11.5 ms) was used per [CC: CERN Courier].

### 2.2 Synchronous vs asynchronous reconstruction

A central O² design point is that the *same software* runs in two different schedules [PP: arXiv:2402.01205 §2; QS: overview.html]:

- **Synchronous** ("to LHC beam"). Runs during data-taking. Goals: (a) detector calibration (enough tracking to compute the calibrations needed for the next data block, e.g. TPC space-charge distortion maps) and (b) raw-data compression (especially TPC: lossy + lossless combination).
- **Asynchronous** (between LHC fills, or on Grid). Runs on the CTFs written by the synchronous pass. Goal: produce the final AODs used for physics analysis, using the final calibration constants.

Whether a given processing step is enabled is a matter of configuration, not of code path [PP: arXiv:2402.01205 §2]. Cuts and settings may differ between the two phases — synchronous cuts are tighter because the processing time budget is tight — but the algorithm implementations are shared.

### 2.3 Software stack summary

O² is built on three layers, described in detail in [`quickstart/fair-dpl.html`](https://aliceo2group.github.io/quickstart/fair-dpl.html):

1. **Standard C++ / Boost / STL** — the base; no ALICE-specific content.
2. **FairMQ** — asynchronous message-passing between parallel processes. Developed by the FairRoot team at GSI for the FAIR accelerator facility, and adopted for ALICE through the ALFA (ALICE + FAIR) collaboration. Each process is a *Device*; the available transports include `zeromq`, `shmem` (shared memory), `nanomsg`, and `ofi`. [QS: fair-dpl.html §FairMQ]
3. **Data Processing Layer (DPL)** — ALICE-authored abstraction on top of FairMQ. A user describes a processing topology as a *Workflow* where each step is a *DataProcessor*; DPL maps each DataProcessor to a FairMQ *Device* automatically. Reconstruction, data quality control, and all other data-processing tasks in O² are written as DPL workflows that run on both FLP and EPN, synchronously and asynchronously [QS: fair-dpl.html §DPL]. **DPL lives inside `Framework/Core/` in this repository** [GH: Framework/Core/].

Deeper treatment is planned in [Framework_DPL](./Framework_DPL.md) (Module 2) and [DataFormats_Reconstruction](./DataFormats_Reconstruction.md) (Module 3). The named concepts above (Device / Workflow / DataProcessor) are introduced here only at the level needed to read the rest of this page.

---

## 3. Repository layout

### 3.1 Top-level directory tree

At commit `87b9775` on branch `dev`, the root of `https://github.com/AliceO2Group/AliceO2` contains the following 24 directories and the standard repo-root files. Claude5 re-verified the directory list against `dev` HEAD on 2026-04-23 as structurally 1:1. The column *"What it is"* is the human explanation; *"Wiki page"* points to where it's indexed in MIWikiAI.

| Directory | What it is | Wiki page |
|---|---|---|
| `.github/` | GitHub Actions, issue/PR templates | — (tooling, not indexed) |
| `Algorithm/` | Small reusable algorithmic building blocks (parsers, frame iterators) that many detectors depend on | wave 2 |
| `CCDB/` | Client code and schemas for the Condition and Calibration Database — where every calibration object ALICE uses is versioned and served | wave 2 |
| `Common/` | Shared utilities: physics constants, math helpers, magnetic-field abstraction, geometry helpers | **[Common_utilities](./Common_utilities.md)** (Module 4) |
| `DataFormats/` | Data-model definitions. Subdivided: `Reconstruction/` (Track, Vertex, PID, Cluster base), `Detectors/` (per-detector cluster and digit formats), `GlobalTracking/` (RecoContainer, GlobalTrackID), `simulation/` (MCTrack, MCLabel) | **[DataFormats_Reconstruction](./DataFormats_Reconstruction.md)** (Module 3) covers `Reconstruction/` + `GlobalTracking/`; per-detector formats in wave 2 |
| `Detectors/` | Per-detector code — the largest top-level directory. Sub-structure: each detector has `base/`, `simulation/`, `reconstruction/` (ITS uses `tracking/` instead), `calibration/`, `workflow/`, `macro/`. Also houses `GlobalTracking/`, `GlobalTrackingWorkflow/`, `Vertexing/` which are cross-detector | **wave 2** (per-detector pages) |
| `EventVisualisation/` | Event-display / visualisation tooling | — (not planned for wiki) |
| `Examples/` | Tiny canonical example modules `Ex1`, `Ex2`, `Ex3`, `Ex4` referenced from `doc/CMakeInstructions.md` — these are what to read if you want to see the smallest working CMake module | referenced from [§4.2](#42-cmake-module-authoring-functions) |
| `Framework/` | The DPL framework itself. `Framework/Core/` is the heart — where DataProcessor, Workflow, Device and the rest of DPL lives | **[Framework_DPL](./Framework_DPL.md)** (Module 2) |
| `GPU/` | GPU reconstruction — primarily TPC tracking via `GPUCATracking` (a shared-source implementation that runs on CUDA, HIP, OpenCL, and CPU) | wave 2 |
| `Generators/` | Event generators (Monte Carlo) | wave 2 |
| `Steer/` | Steering / driver code orchestrating simulation and reconstruction | wave 2 |
| `Testing/` | Shared test infrastructure | — (cross-cutting) |
| `Utilities/` | Miscellaneous utilities that don't fit under `Common/` | wave 2 |
| `cmake/` | The O²-specific CMake helpers: `O2AddLibrary.cmake`, `O2AddExecutable.cmake`, `O2AddTest.cmake`, `O2TargetRootDictionary.cmake`. See [§4.2](#42-cmake-module-authoring-functions) | **this page**, §4.2 |
| `config/` | Run-time configuration files | — |
| `dependencies/` | External dependency vendor directories | — |
| `doc/` | Repository-level hand-written markdown documentation — CodeOrganization, CMakeInstructions, CMakeMigration, DoxygenInstructions, DEBUGGING. Indexed into Doxygen via `\page` / `\subpage` tags | **this page**, §3.3 and §4 |
| `macro/` | ROOT macros (user-level scripts) | wave 2 |
| `packaging/` | Build-system packaging helpers | — |
| `prodtests/` | Production-grade test workflows — simulate complete reconstruction pipelines | wave 2 |
| `run/` | Run-time scripts and configuration | — |
| `scripts/` | Shell helper scripts — e.g. `filter-warnings.sh`, called out in `README.md` | — |
| `tests/` | Top-level cross-cutting tests | — |
| `version/` | Version / release tagging helpers | — |

Repo-root files referenced elsewhere in this page:

| File | What it is | Why it matters here |
|---|---|---|
| `README.md` | The canonical one-page intro to the repo | primary source for §1.2, §4, §5 |
| `CMakeLists.txt` | Top-level CMake entry point | §4.1 |
| `COPYING` | GPL-3.0 license text | §5.4 |
| `CHANGELOG.md` | Release-level changelog | — |
| `DEBUGGING.md` | Debugging tips for developers | — |
| `codecov.yml` | Codecov CI configuration | §5.2 |
| `.clang-format`, `.clang-format-ignore`, `.clang-tidy`, `.cmake-format.py`, `.gitignore` | Formatting / lint config | §5.3 |
| `CODEOWNERS` | GitHub code-ownership map | — |
| `log.txt` | Purpose undocumented — see §6 | — (flagged, not load-bearing) |

Note: `Testing/` (directory) provides shared test harness, fixtures, and utilities; `tests/` (directory) contains the actual cross-cutting tests at the top level.

### 3.2 The wider AliceO2Group universe

AliceO2 is one of **10 repositories** in the `AliceO2Group` GitHub organisation [QS: organisation.html]. Understanding the split matters because several of them appear as link-time dependencies inside `AliceO2` module `CMakeLists.txt` files (e.g. `O2::Monitoring`, `AliceO2::InfoLogger`).

| # | Repository | What it provides | Doxygen |
|---|---|---|---|
| 1 | **AliceO2** | Framework + detector code (this repo) | [Yes](https://aliceo2group.github.io/AliceO2/) |
| 2 | [Control](https://github.com/AliceO2Group/Control) | Control and orchestration of DPL deployments (AliECS) | — |
| 3 | [Configuration](https://github.com/AliceO2Group/Configuration) | Configuration service used by FLP/EPN | [Yes](https://aliceo2group.github.io/Configuration/) |
| 4 | [Monitoring](https://github.com/AliceO2Group/Monitoring) | Client library pushing metrics to InfluxDB / Kafka | [Yes](https://aliceo2group.github.io/Monitoring/) |
| 5 | [DataDistribution](https://github.com/AliceO2Group/DataDistribution) | Time-frame building on FLPs and distribution to EPNs over InfiniBand | — |
| 6 | [InfoLogger](https://github.com/AliceO2Group/InfoLogger) | Logging infrastructure (O² equivalent of stderr + syslog combined) | [Docs](https://github.com/AliceO2Group/InfoLogger/blob/master/doc/README.md) |
| 7 | [QualityControl](https://github.com/AliceO2Group/QualityControl) | Data Quality Monitoring / Quality Assurance framework | [Yes](https://aliceo2group.github.io/QualityControl/) |
| 8 | [Readout](https://github.com/AliceO2Group/Readout) | The readout software running on FLPs | — |
| 9 | [ReadoutCard](https://github.com/AliceO2Group/ReadoutCard) | User-space driver for the custom PCIe readout cards | — |
| 10 | [WebUi](https://github.com/AliceO2Group/WebUi) | Web-based UI components for control / monitoring | — |

Plus two more that do not appear in the quickstart's 10-repo list but are referenced from the `AliceO2` README and used in daily work: [`O2DPG`](https://github.com/AliceO2Group/O2DPG) (data-production-grid helpers) and [`O2Physics`](https://github.com/AliceO2Group/O2Physics) (the analysis framework layered on top of `AliceO2`). These are out of scope for Phase 0.1 (they will get their own `code/O2DPG/` and `code/O2Physics/` folders in future phases).

### 3.3 The `doc/` directory

`doc/` contains the hand-written developer documentation that is *also* indexed into Doxygen via `\page` + `\subpage` tags [GH: DoxygenInstructions.md]. The files confirmed present during indexation:

| File | What it covers | Where it's used |
|---|---|---|
| `CodeOrganization.md` | The maintainers' view of module structure | cross-reference in §3.1 |
| `CMakeInstructions.md` | 458-line primary reference for CMake / CTest conventions: `o2_add_library`, `o2_add_executable`, `o2_add_test`, `o2_target_root_dictionary`, LABELS, parallel test execution | authoritative source for §4.2 |
| `CMakeMigration.md` | Historical — the transition from the older "buckets" CMake system to the current target-based one. Mostly of interest if you're reading very old pull requests | referenced from `CMakeInstructions.md` |
| `DoxygenInstructions.md` | How to write `README.md` files so they render both on GitHub and in the Doxygen output; `\page` and `\subpage` conventions | §4.3 |

The `doc/` directory may contain additional files at the pinned SHA — Module 2 will refine this when it indexes `Framework/Core/README.md` and neighbours.

---

## 4. Build system and development workflow

### 4.1 Build at a conceptual level

A new developer almost never runs CMake directly. The canonical workflow is [GH: README.md §Building / Installation]:

1. Install **aliBuild** (the ALICE-wide build tool, lives in the separate `alisw/alibuild` repository).
2. Follow the aliBuild O² tutorial at `http://alisw.github.io/alibuild/o2-tutorial.html`.
3. `aliBuild build O2 --defaults o2`.

aliBuild resolves external dependencies, materializes a reproducible toolchain, then drives CMake. For developer iteration inside an existing build tree, `cmake --build .` is used directly; Doxygen is built via `cmake --build . --target doc` [GH: README.md §Doxygen].

The top-level `CMakeLists.txt` descends into every top-level directory's own `CMakeLists.txt`, each of which calls the O² helper functions described next.

### 4.2 CMake module-authoring functions

Every module's `CMakeLists.txt` calls one or more of four canonical functions, defined in the `cmake/` helper scripts [GH: CMakeInstructions.md §Typical CMakeLists.txt]. These are the sanctioned ways to add a library, executable, or test to O². Understanding them is essential for anyone writing a new reconstruction component.

| Function | Helper file | Purpose |
|---|---|---|
| `o2_add_library` | `cmake/O2AddLibrary.cmake` | Define a library target. Dependencies listed via `PUBLIC_LINK_LIBRARIES`. Target is always `O2::targetName` (where `targetName` is the CMake target identifier, not necessarily the source basename) — you always use the fully qualified name when linking against it. Produces `libO2<Basename>.{so\|dylib}` in the build's `stage/lib/`. |
| `o2_add_executable` | `cmake/O2AddExecutable.cmake` | Define an executable target. `COMPONENT_NAME` argument is lowercased and used as part of the output binary name following the pattern `o2-<component>-<target>`. |
| `o2_add_test` | `cmake/O2AddTest.cmake` | Define a test. Boost.Test by default (opt out with `NO_BOOST`). `LABELS` lets you group tests; `INSTALL` copies the test into the install tree. Tests are runnable via `ctest -R` (regex name) or `ctest -L` (label). |
| `o2_target_root_dictionary` | `cmake/O2TargetRootDictionary.cmake` | Generate a ROOT dictionary for a library. Automatically adds `ROOT::RIO` as dependency. `LINKDEF` parameter is optional if the LinkDef file follows the `<targetBaseName>LinkDef.h` convention. |

The golden rule from `CMakeInstructions.md` [GH: §Typical CMakeLists.txt], reproduced verbatim including the author's original spelling:

> *"All direct dependencies must be explicitely defined with the `PUBLIC_LINK_LIBRARIES` keyword of the various `o2_xxx` functions. Note that despite the parameter name, the `PUBLIC_LINK_LIBRARIES` should refer to target names, not library names. You have to use the fully qualified `O2::targetName` and not the short `basename` you might have used to create the target."*

The four `Examples/Ex1` – `Examples/Ex4` subdirectories in the repo are the worked exercises that accompany `CMakeInstructions.md`. They are short (a handful of files each) and the best starting point for a new author.

### 4.3 Documentation workflow — README.md, Doxygen, and the subpage rule

Two documentation outputs coexist [GH: README.md §Doxygen]:

- **Repo markdown.** The `README.md` at the repo root, and one in each significant subdirectory. These are the primary human-facing documentation.
- **Doxygen-generated pages.** Built by `cmake --build . --target doc`, published online at `https://aliceo2group.github.io/AliceO2/`. The published Doxygen index is Module 3's primary source for class signatures.

The trick is that the `README.md` files are *also* the Doxygen prose. Each carries a Doxygen `\page` tag at the top and, if it has sub-documents, `\subpage` references to them [GH: DoxygenInstructions.md]. The tags are wrapped in HTML comments `<!-- doxy \page refModulename Module 'Modulename' /doxy -->` so GitHub renders the README cleanly (comment stripped) while Doxygen still picks up the tags.

The critical rule, quoted directly [GH: DoxygenInstructions.md]:

> *"When adding a new documentation page you must always add a `\subpage` declaration in an upper category page otherwise your page will pollute the "global" references in the left tab menu."*

This is why every new README.md added in the repository must be linked from a parent's `\subpage` — otherwise it breaks the Doxygen navigation tree.

### 4.4 Coding guidelines, formatting, and warnings

- **Coding guidelines** live in the separate [`AliceO2Group/CodingGuidelines`](https://github.com/AliceO2Group/CodingGuidelines) repository [GH: README.md §Coding guidelines]. The executable-name convention (`o2-<component>-<n>`) is documented there and enforced by a CI test.
- **Formatting** is via `clang-format` (configs `.clang-format` and `.clang-format-ignore` at the root) and `cmake-format` (config in `.cmake-format.py`) [GH: root files].
- **Compiler warnings** are currently minimal by default. Developers opt in by setting `ALIBUILD_O2_WARNINGS=1` at aliBuild time [GH: README.md §Enable C++ compiler warnings]:

  ```
  aliBuild build --debug -e ALIBUILD_O2_WARNINGS=1 --defaults o2 O2
  ```

  A helper `scripts/filter-warnings.sh` extracts unique warnings from a build log.

---

## 5. Build and CI integration

### 5.1 Continuous integration

Three CI build-status badges appear at the top of `README.md` [GH: README.md top, shield images]:

| Badge | What it runs |
|---|---|
| `build_O2_o2` | Linux O² build |
| `build_o2_macos` | macOS O² build |
| `build_o2checkcode_o2` | Code-check / lint / static-analysis build |

All three feed from `https://ali-ci.cern.ch/repo/...`. A failed CI badge on `dev` is a blocker for merging.

### 5.2 Test harness

`o2_add_test` integrates tests into CTest; tests can be filtered by name regex (`-R` / `-E`), by label (`-L` / `-LE`), and run in parallel (`-j N`). Full label list via `ctest --print-labels`. See `CMakeInstructions.md` §Ex4 for examples.

### 5.3 Code coverage

Coverage is configured in `codecov.yml` at the root; see also the quickstart's `advanced/coverage.html` page.

### 5.4 License and citation

GPL-3.0 [GH: COPYING]. The project has a persistent DOI `10.5281/zenodo.1493334` [GH: README.md top DOI badge].

### 5.5 Issue tracking

ALICE uses JIRA, project code **O2**: `https://its.cern.ch/jira/projects/O2`. A JIRA key (`O2-XYZ`) included in a commit message or PR title auto-links the GitHub activity to the ticket [GH: README.md §Issue tracking system]. The MIWikiAI wiki pages follow the same convention in their `related_jira_tickets:` front-matter field.

### 5.6 Release cadence

Nineteen tagged releases exist as of indexation. The latest visible tag is `daily-20240816-0200` (August 2024) [GH: Releases tab]. Daily snapshots follow the pattern `daily-YYYYMMDD-0200`. Stable-release cadence is irregular.

---

## 6. Known limitations and open items

- **SHA pinning granularity.** `commit_verified` is pinned to `87b9775` (PR #15202, 2026-03-26). Claude5 re-verified on 2026-04-23 that the top-level directory layout at `dev` HEAD is structurally 1:1 with the pinned SHA. The pinning remains valid for this module's claims.
- **Source inconsistencies (3 documented).** Three claims in this page are subject to primary-source disagreement: the Run-2-vs-Run-1 baseline for the 100× multiplier (CONFLICT-1), the aggregate raw data rate (CONFLICT-2), and the LS2 end date (CONFLICT-3). All three are catalogued in `source_inconsistencies:` front-matter with verbatim quotes, physical checks, and resolution rationale. This is the first application of the `[CONFLICT-N]` convention ratified in Phase 0.1 proposal v3.
- **Single-sourced numbers.** `~900 GB/s after FLP` and `~130 GB/s after EPN` (§2.1) are currently sourced only from [CC: CERN Courier]. Appendix A.6 marks them as single-sourced, not CLOSED. Module 2 or the future FLP wiki page should cross-check against Costa et al. (2024).
- **`doc/` directory completeness.** This page catalogues 4 files confirmed present in `doc/`. Additional markdown files may exist at the pinned SHA — Module 2 will refine when indexing `Framework/Core/README.md` and neighbours.
- **Node counts for FLP/EPN.** 200 FLP nodes, 350 EPN nodes, 8 GPUs/EPN cited from arXiv:2402.01205 (2024); non-load-bearing, may have evolved.
- **TDR not re-indexed here.** `ALICE-TDR-019 / CERN-LHCC-2015-006` is cited by URL as the authoritative design document. Its body content is to be indexed as a separate MIWikiAI `TDR/` wiki page.
- **Anchor freeze contract.** Per PHASE_0_1 §5.3, anchors in this page are frozen once Module 1 is approved. Downstream modules 2–4 rely on them for cross-links.
- **Log.txt in repo root.** Its purpose is not documented in `README.md`. Flagged for reviewer awareness; not load-bearing. Row added to §3.1 repo-root files table.

---

## 7. Cross-references to MIWikiAI wiki

| Link | Referenced from | Status |
|---|---|---|
| [`./Framework_DPL.md`](./Framework_DPL.md) | §1.2, §2.3, §3.1 (Framework/ row), §7 | planned — Module 2 of this phase |
| [`./DataFormats_Reconstruction.md`](./DataFormats_Reconstruction.md) | §1.2, §3.1 (DataFormats/ row) | planned — Module 3 |
| [`./Common_utilities.md`](./Common_utilities.md) | §1.2, §3.1 (Common/ row) | planned — Module 4 |
| [`../../TDR/tpc.md`](../../TDR/tpc.md) | §1.1 (TPC upgrade mention) | live (DRAFT wiki-v2) |
| [`../../TDR/its.md`](../../TDR/its.md) | §3.1 footnote (ITS detector) | live (DRAFT wiki-v1) |
| [`../../TDR/trd.md`](../../TDR/trd.md) | §3.1 footnote (TRD detector) | live (DRAFT wiki-v2) |
| [`../../TDR/O2.md`](../../TDR/O2.md) | none (page not linked inline; TDR referenced by [TDR] tag only) | **planned** — not yet created; TDR body indexation is a separate future task |
| [`../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md`](../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) | contextual — a real-world example of `Framework/Core/` use in calibration | live (DRAFT, cycle 0) |

---

## 8. External references

### 8.1 AliceO2 repository (primary, [GH])

| Topic | URL |
|---|---|
| AliceO2 repository root | https://github.com/AliceO2Group/AliceO2 |
| `README.md` | https://github.com/AliceO2Group/AliceO2/blob/dev/README.md |
| `doc/CodeOrganization.md` | https://github.com/AliceO2Group/AliceO2/blob/dev/doc/CodeOrganization.md |
| `doc/CMakeInstructions.md` | https://github.com/AliceO2Group/AliceO2/blob/dev/doc/CMakeInstructions.md |
| `doc/CMakeMigration.md` | https://github.com/AliceO2Group/AliceO2/blob/dev/doc/CMakeMigration.md |
| `doc/DoxygenInstructions.md` | https://github.com/AliceO2Group/AliceO2/blob/dev/doc/DoxygenInstructions.md |
| `cmake/O2AddLibrary.cmake` | https://github.com/AliceO2Group/AliceO2/blob/dev/cmake/O2AddLibrary.cmake |
| `cmake/O2AddExecutable.cmake` | https://github.com/AliceO2Group/AliceO2/blob/dev/cmake/O2AddExecutable.cmake |
| `cmake/O2AddTest.cmake` | https://github.com/AliceO2Group/AliceO2/blob/dev/cmake/O2AddTest.cmake |
| `cmake/O2TargetRootDictionary.cmake` | https://github.com/AliceO2Group/AliceO2/blob/dev/cmake/O2TargetRootDictionary.cmake |
| `Examples/Ex1` – `Examples/Ex4` | https://github.com/AliceO2Group/AliceO2/tree/dev/Examples |
| `Framework/Core/README.md` | https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/README.md |

### 8.2 Published documentation (primary, [QS] + [DX])

| Topic | URL |
|---|---|
| AliceO2 Doxygen published site | https://aliceo2group.github.io/AliceO2/ |
| Quickstart landing | https://aliceo2group.github.io/ |
| Quickstart — Overview | https://aliceo2group.github.io/quickstart/overview.html |
| Quickstart — FairMQ and DPL | https://aliceo2group.github.io/quickstart/fair-dpl.html |
| Quickstart — Work Packages | https://aliceo2group.github.io/quickstart/wp.html |
| Quickstart — Code organisation | https://aliceo2group.github.io/quickstart/organisation.html |
| Quickstart — Build packages | https://aliceo2group.github.io/quickstart/build.html |
| Quickstart — Development process | https://aliceo2group.github.io/quickstart/devel.html |
| Quickstart — Binaries | https://aliceo2group.github.io/quickstart/binaries.html |
| Quickstart — Getting help | https://aliceo2group.github.io/quickstart/help.html |
| Advanced — CMake | https://aliceo2group.github.io/advanced/cmake.html |
| Advanced — Doxygen | https://aliceo2group.github.io/advanced/doxygen.html |
| Advanced — Coverage | https://aliceo2group.github.io/advanced/coverage.html |
| Advanced — Coding Guidelines | https://aliceo2group.github.io/advanced/guideline.html |
| Advanced — Ninja | https://aliceo2group.github.io/advanced/ninja.html |
| Advanced — Release Process | https://aliceo2group.github.io/advanced/release-process.html |
| Advanced — IDEs | https://aliceo2group.github.io/advanced/ides.html |

### 8.3 O² work packages

From `aliceo2group.github.io/quickstart/wp.html`, the 17 work packages and their responsibles. Work packages most directly relevant to MIWikiAI wave 1 are in **bold**.

| WP | Description | Responsible |
|---|---|---|
| WP1 | Data Model | Mikolaj Krzewicki |
| WP2 | Data Flow and System Simulation | Iosif Legrand |
| WP3 | Common Tools and Software infrastructure | Dario Berzano |
| **WP4** | **O² Software Framework** (DPL) | **Giulio Eulisse** |
| WP5 | Data distribution and load balancing | Gvozden Neskovic |
| WP6 | Detector readout | Filippo Costa |
| WP7 | Data Quality Control | Barthélémy von Haller |
| WP8 | Control, Configuration and Monitoring | Vasco Barroso |
| WP9 | Event Display | Julian Myrcha |
| WP10 | CCDB | Costin Grigoras |
| WP11 | ALFA | Mohammad Al-Turany |
| WP12 | Detector Simulation | Sandro Wenzel |
| **WP13** | **Reconstruction and Calibration** | **Ruben Shahoyan** |
| WP14 | Analysis framework and facilities | Peter Hristov |
| WP15 | Data Management | Latchezar Betev |
| WP16 | Computing Room CR1 (FLP) | Ulrich Fuchs |
| WP17 | Computing Room CR0 (EPN) | Johannes Lehrbach |

### 8.4 ALICE-collaboration authoritative references

These are listed in `source_fingerprint.upstream[]` — three separate tags per Phase 0.1 v3: [TDR] for TDRs, [PP] for peer-reviewed papers, [CC] for CERN Courier / journalism.

| Document | Tag | Citation |
|---|---|---|
| O² Technical Design Report | [TDR] | ALICE Collaboration, "Upgrade of the Online-Offline computing system", CERN-LHCC-2015-006 / ALICE-TDR-019. https://cds.cern.ch/record/2011297 |
| O² software framework + GPU usage | [PP] | G. Eulisse, D. Rohr, arXiv:2402.01205 (2024). https://arxiv.org/abs/2402.01205 |
| O²/FLP data acquisition | [PP] | F. Costa et al., EPJ Web Conf. 295, 02029 (2024). https://cds.cern.ch/record/2919265 |
| ALICE Central Trigger System for Run 3 | [PP] | J. Kvapil et al., arXiv:2106.08353 (2021). https://arxiv.org/abs/2106.08353 (cited for CONFLICT-1 external verification) |
| CERN Courier — O² overview | [CC] | "ALICE ups its game for sustainable computing", CERN Courier, 2023. https://cerncourier.com/a/alice-ups-its-game-for-sustainable-computing/ |
| ALICE O² project web page | — | https://alice-o2-project.web.cern.ch |

### 8.5 External ecosystem and support

| Topic | URL |
|---|---|
| aliBuild tutorial for O² | http://alisw.github.io/alibuild/o2-tutorial.html |
| ALICE Talk (user support forum) | https://alice-talk.web.cern.ch |
| ALICE JIRA, project O² | https://its.cern.ch/jira/projects/O2 |
| License (GPL-3.0) | https://github.com/AliceO2Group/AliceO2/blob/dev/COPYING |
| DOI | https://doi.org/10.5281/zenodo.1493334 |
| FairRoot | https://github.com/FairRootGroup/FairRoot |
| FairMQ | https://github.com/FairRootGroup/FairMQ |

---

## Appendix A: Source-code-to-section map and structural closure checks

### A.1 Top-level directory count

**Claim.** §3.1 lists 24 top-level directories (excluding `.github/`).

**Primary evidence.** GitHub `dev` tree at commit `87b9775` enumerates 25 entries including `.github/`; 24 excluding. Claude5 re-verified against `dev` HEAD on 2026-04-23 as structurally 1:1.

**Result:** CLOSED ✓.

### A.2 AliceO2Group repository count

**Claim.** §3.2 lists 10 AliceO2Group repositories per `quickstart/organisation.html`.

**Primary evidence.** Quickstart page enumerates 10 repositories in a numbered list.

**Result:** CLOSED ✓.

### A.3 `doc/` file catalogue

**Claim.** §3.3 catalogues 4 files: CodeOrganization.md, CMakeInstructions.md, CMakeMigration.md, DoxygenInstructions.md.

**Primary evidence.** All 4 URLs return non-404. Claim is "at least these 4", not exhaustive.

**Result:** CLOSED ✓.

### A.4 CMake function enumeration

**Claim.** §4.2 lists 4 canonical module-authoring functions.

**Primary evidence.** `CMakeInstructions.md` §Typical CMakeLists.txt names exactly these 4. Helpers exist in `cmake/` with matching names.

**Result:** CLOSED ✓.

### A.5 Work-package count

**Claim.** §8.3 lists 17 work packages.

**Primary evidence.** `quickstart/wp.html` exhibits a 17-row table WP1–WP17.

**Result:** CLOSED ✓.

### A.6 Data-flow quantitative closure (REVISED in v0.4, refined in v0.5)

**v0.3 claim** reported these numbers as cross-validated across three sources and marked CLOSED. Panel review (Claude4 F-primary, Claude7 D-primary) showed this was premature. **v0.5 re-evaluation:**

| Number | Source 1 | Source 2 | Status |
|---|---|---|---|
| 3.5 TB/s raw | arXiv:2402.01205 §2 (3.5 TB/s) | Quickstart overview (3.4 TB/s) — CONFLICT | Cross-sourced but **conflicting** — see CONFLICT-2. Not CLOSED; resolved by choosing arXiv as authoritative. |
| 100× rate ratio | arXiv:2402.01205 abstract (vs Run 2) | Quickstart overview (vs Run 1) — different baselines, both valid | Cross-sourced with different baselines — see CONFLICT-1 for physical verification via external fetch of Kvapil et al. Both sources correct. |
| ~900 GB/s after FLP | CERN Courier | **none** | **Single-sourced** — not CLOSED. Cross-check deferred to Module 2 or FLP wiki page. |
| ~130 GB/s after EPN | CERN Courier | **none** | **Single-sourced** — not CLOSED. |
| Compression factor ~30 | Quickstart overview | (implicit in rate ratio) | Single-sourced quantitatively. |
| TF ~2.86 ms (nominal Pb–Pb, 32 orbits) | arXiv:2402.01205 §2 | CERN Courier | Cross-sourced ✓ CLOSED. |
| LHC orbit ~89.4 μs | CERN Courier | (textbook value) | CLOSED ✓. |
| 50 kHz Pb–Pb | arXiv:2402.01205 | CERN Courier + Quickstart overview | Triple-sourced ✓ CLOSED. |
| 200 FLP / 500 cards / 8000 links / 15 subdetectors | arXiv:2402.01205 | Costa et al. (2024) | Cross-sourced ✓ CLOSED. |
| 350 EPN / 8 GPUs | arXiv:2402.01205 §2 | (single-sourced quantitatively) | Single-sourced — not CLOSED. Cross-check to second source deferred. |

**Verdict:** of 10 numbers, 5 CLOSED, 3 single-sourced (not CLOSED; tracked in §6 "Known limitations"), 2 conflicting across primary sources (resolved via `source_inconsistencies` per `[CONFLICT-N]` convention).

---

## Appendix B: Notation

### B.1 Primary-source inline-tag grammar (updated in v0.4 per Phase 0.1 v3)

| Tag | Meaning |
|---|---|
| `[GH]` | AliceO2 GitHub repository. Citation format: `[GH: <path>]` or `[GH: README.md §<section>]`. |
| `[DX]` | AliceO2 Doxygen at `aliceo2group.github.io/AliceO2/`. (Not actively cited in this overview — Module 3 will.) |
| `[QS]` | AliceO2 Quickstart pages at `aliceo2group.github.io/` (overview, fair-dpl, organisation, wp, advanced, etc.). |
| `[AD]` | Narrow meaning: `alice-doc.web.cern.ch` entries only. Not used in this page. |
| `[TDR]` | ALICE Technical Design Reports. Format: `[TDR: ALICE-TDR-019]`. |
| `[PP]` | Peer-reviewed papers (arXiv preprints of published papers, EPJ, JHEP, etc.). Format: `[PP: arXiv:2402.01205]`. |
| `[CC]` | CERN Courier / community-magazine journalism. Authoritative within CERN but not peer-reviewed; lower tier than [PP]. |
| `[CONFLICT-N]` | Marker pointing to `source_inconsistencies[N]` in the front-matter, where verbatim quotes from disagreeing sources and the resolution rationale are recorded. Inline marker is read-only — the reader is expected to consult front-matter for the full conflict description. |

### B.2 Physics and computing acronyms

| Acronym | Meaning |
|---|---|
| **ALICE** | A Large Ion Collider Experiment |
| **LHC** | Large Hadron Collider (CERN) |
| **LS2** | Long Shutdown 2 of the LHC (2019–2022) |
| **O², O2** | Online-Offline computing system for Run 3 and Run 4 |
| **QGP** | Quark–Gluon Plasma (ALICE's primary physics target) |
| **TPC** | Time Projection Chamber — ALICE's main tracking detector |
| **ITS** | Inner Tracking System — 7-layer monolithic silicon pixel tracker |
| **TRD** | Transition Radiation Detector |
| **TOF** | Time-Of-Flight detector |
| **MFT** | Muon Forward Tracker |
| **GEM** | Gas Electron Multiplier (TPC Run-3 readout technology) |
| **FLP** | First Level Processor — first computing layer, in CR1 |
| **EPN** | Event Processing Node — second computing layer, in CR0 |
| **TF** | Time Frame — ~2.86 ms of continuous readout data (nominal Pb–Pb, 32 LHC orbits) |
| **CTF** | Compressed Time Frame — the persisted output of synchronous reconstruction |
| **AOD** | Analysis Object Data — output of asynchronous reconstruction |
| **HLT** | High Level Trigger (ALICE's Run-1/2 online reconstruction) |
| **CR0, CR1** | Counting Rooms 0 and 1 at the ALICE experimental site |
| **WLCG** | Worldwide LHC Computing Grid |
| **CCDB** | Condition and Calibration DataBase |

### B.3 Software acronyms

| Term | Meaning |
|---|---|
| **DPL** | Data Processing Layer — ALICE's workflow abstraction, lives in `Framework/Core/` |
| **FairMQ** | Message-passing library from FairRoot, transport layer beneath DPL |
| **FairRoot** | GSI-developed experiment-agnostic simulation/reconstruction framework |
| **ALFA** | ALICE + FAIR — the collaboration that shares FairMQ and related infrastructure |
| **aliBuild** | ALICE-wide build orchestrator (repo: `alisw/alibuild`) |
| **WP** | Work Package — O² project organizational unit (17 total) |
| **dev** | Main development branch of the AliceO2 Git repository |
| **Device** | In FairMQ: a single process. In DPL: a DataProcessor mapped to a FairMQ Device. |
| **Workflow** | In DPL: a programmatically-expressed topology of connected DataProcessors |
| **DataProcessor** | In DPL: one processing step; mapped to a FairMQ Device at runtime |

---

## Changelog

- **v0.5 — 2026-04-23 — cycle-1 micro-bump (finalizing gate-1 readiness).** Panel cycle-1 on v0.4 (7 reviewers) produced synthesis identifying 8 new P1s (N1–N8) plus 7 carry-forward P2s (P2-a through P2-g). v0.5 applies all fixes:
  - FIX-1/4: version and status bumps (v0.4 → v0.5, REVISION_FROM_CYCLE_1_SYNTHESIS → READY_FOR_GATE_1).
  - FIX-2: `known_errata` removed from O2-Quickstart-Overview upstream entry (Claude5 F-new1: quickstart is not in error).
  - FIX-3: CONFLICT-1 reframed from "sources disagree, one is wrong" to "sources use different baselines; both correct because Run 1 and Run 2 had identical ~1 kHz recorded rates" per Claude5's external fetch of arXiv:2106.08353 (Kvapil et al.).
  - FIX-5: v0.4→v0.5 synthesis response field added.
  - FIX-6 (N6): TF/orbit sentence split into nominal-32-orbit and stress-test-128-orbit configurations.
  - FIX-7 (N1): `Framework/Core/` DPL-location claim gets direct `[GH]` citation.
  - FIX-8 (N4): DoxygenInstructions quote semicolon removed, restored verbatim.
  - FIX-9 (N3): 5 missing quickstart pages added to §8.2 (Binaries, Getting help, Ninja, Release Process, IDEs).
  - FIX-10 (N5): §7 TDR/O2.md row corrected — not linked inline.
  - FIX-11 (N7): CONFLICT-2 arXiv citation refined to `§2` (number not in abstract).
  - FIX-12 (N8): attribution note added (see below).
  - FIX-13 through FIX-18: seven P2 carry-forwards (log.txt row, Testing/tests distinction, Semi-closed taxonomy, targetName vs basename, [CC] tag body application, peer_reviewers field split).
  Architect-ratified: CONFLICT-1 reframe; `source_inconsistencies` schema for Phase 0.1 v3. No re-review required; architect gate 1 reads v0.5 directly.
- **v0.4 — 2026-04-23 — revision after panel cycle-1 synthesis.** Panel of 5 reviewers (Claude2, Claude3 off-scope, Claude4, Claude5, Claude7) produced synthesis identifying 8 convergent findings. v0.4 addresses: CV-1 Run-1/Run-2 harmonization to Run 2 with [CONFLICT-1] marker and physical-check rationale; CV-2 tag split [AD]→[TDR]/[PP]/[CC] (architect-approved); CV-4 InputSpec/OutputSpec removal from §2.3; CV-5 CMakeInstructions block-quote restored verbatim including `explicitely` original spelling; CV-6 "shmem default in O² production" removed (unsupported by cited source); CV-7 Appendix A.6 rewritten honestly with single-sourced numbers tracked in §6; Claude5 #2 `.clang-format-ignore` added to §3.1 repo-root files table; Claude5 #3 Costa et al. (2024) promoted from §8.4-only to `source_fingerprint.upstream[]`. Two new `source_inconsistencies` entries added (CONFLICT-2 data rate, CONFLICT-3 LS2 dates). CV-3 schema split (§2/§3) pending — proposal amendment in Phase 0.1 v3. CV-8 (§4.2 CMake scope) architect-sided-with-majority; §4.2 retained. **Attribution note:** findings labeled "Claude5 #2" and "Claude5 #3" in this changelog entry were authored by Claude6; architect corrected ID assignment on 2026-04-21. No retroactive relabel per SUMMARY v0.3 §8 item 1 Option A.
- **v0.3 — 2026-04-21** — metadata update for 7-reviewer panel review; no body changes from v0.2.
- **v0.2 — 2026-04-21** — supersedes v0.1 per architect feedback (v0.1 too cryptic / AI-centric); added ALICE physics context, data-flow narrative, software-stack explanation, published-paper sources.
- **v0.1 — 2026-04-21** — initial draft, reference-index style. Withdrawn.

---

*Indexed by Claude8 on 2026-04-21; revised 2026-04-23 after panel cycle-1 synthesis (v0.4 → v0.5 per Claude7 fix-list). Team MIWikiAI. v0.5 READY_FOR_GATE_1 — architect approval gate 1 pending.*

*Quota: no session-block / quota-loss signals observed.*
