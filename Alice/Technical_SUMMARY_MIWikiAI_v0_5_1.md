---
doc_id: Technical_SUMMARY_MIWikiAI
doc_type: technical-summary
project: MIWikiAI
version: v0.5.1 (2026-05-01)
status: DRAFT — paired update with MIWikiAI_QRC v0.5.1; awaits architect ratification
quick_reference: ./MIWikiAI_Quick_Reference_Card_v0_5_1.md
prior_version: v0.5 (2026-05-01) — superseded same day after new Organization docs received
supersedes: v0.5 with three additive alignments to Organization-doc updates (MTTU_Reviewer v1.22, Reviewer_QRC v1.29, Main_Reviewer_QRC first issuance). No semantic v0.5 content changes.
date: 2026-05-01
revision_note: "v0.5.1 aligns with Organization docs received 2026-05-01: §6 roster Claude7 Main Reviewer entry now references Main_Reviewer_QRC card; §9 Review Process discipline reinforcement now points to the canonical card instead of being free-floating prose; §11 cross-team adds Main Reviewer card to Organization adoption record."
author: Marian Ivanov
compiled_with: Claude9 (Claude Opus 4.7, MIWikiAI reviewer-ID Claude9, Coder role for this artifact)
review_cycle: 0
review_status: cycle-0 self-review pending; awaits panel dispatch
architect_ratifications_2026_04_19: [A=Option-A-default, B=deferred, C=override-F6-routing, D=CoderQRC-v1.28, E=TeamID-MIWikiAI, item-7=Claude4-assigned]
architect_ratifications_2026_04_23:
  - "Reviewer ID namespace: architect-ratified incremental numbering; IDs unique within MIWikiAI; Claude4, Claude6, Claude7, Claude8 active"
  - "CONFLICT-N inline marker convention + source_inconsistencies[] front-matter block ratified for Phase 0.1 v3 schema"
  - "Schema A/B split ratified: hub/overview pages may elide 'Key classes / types / functions'; module pages follow full Phase 0.1 §2.2 template"
  - "Tag split ratified: [AD] alice-doc.web.cern.ch only; [TDR] [PP] [CC] introduced"
  - "Folder convention: Alice/code/O2/, code/O2Physics/, code/O2DPG/"
architect_ratifications_2026_04_30:
  - "PHASE_0_2_Pilot_Proposal v0.2 APPROVED — proceed to Common_utilities_API.md prototype"
  - "11-symbol scope for ConfigurableParam pilot (8 named + 3 supporting accepted)"
  - "Q1 F5 CCDB-priority operationally verified — local CCDB caching queued as future infrastructure-page topic"
  - "Q2 orthogonal-metadata-axes direction binding for v0.2+ of API pages"
  - "Q3 getName section required as standalone per CONV-1; namespace handling in counter pipeline confirmed correct"
  - "Q4 anti-silent-paraphrase rule binding (P0); source-access protocol mandatory; new label vocabulary ratified"
  - "Counter Pipeline v0.5 ratified; commit 52858e3"
  - "MIWikiAI_QuickRef v0.5 first-issuance + Technical_SUMMARY v0.5 paired update commissioned"
---

# MIWikiAI — Technical SUMMARY v0.5

## 1. What MIWikiAI is

A team producing **AI-queryable wiki pages** distilled from ALICE physics sources (TDRs, JINST papers, presentations, code modules, articles), and operating an AI advisor that consumes those pages to answer physicist queries. Every page is a **Karpathy-style compiled knowledge document** — thematic, sourced, machine-readable — intended to be fed directly to LLMs as a trusted knowledge base, complementing source-fetch tools.

Distinct from pure RAG over unstructured sources: MIWikiAI compiles wiki pages once, and the wiki itself is the curated retrieval substrate. The wiki's value-add over source-only RAG is the *conventions, rationale, and operational failure-mode prose* that source code does not carry.

As of v0.5, MIWikiAI indexes three artifact classes — source-of-truth (TDR-based), transcript-index (presentation-based), software-index (code-repository-based) — and is in the middle of Phase 0.2: building counter-driven `_API.md` deep-reference companions to the software-index overview pages. The first such companion (`Common_utilities_API.md`) is in cycle-1 review.

MIWikiAI is one of 16 teams in the project. It is responsible for documentation production *and* the AI advisor that consumes the documentation.

## 2. Repository layout

```
MIWikiAI/Alice/
├── presentations/        # transcript-index pages
├── TDR/                  # source-of-truth pages per ALICE subdetector
├── code/                 # software-index pages
│   ├── O2/              # AliceO2 framework — Phase 0.1 + 0.2 active
│   ├── O2Physics/       # planned, future wave
│   └── O2DPG/           # planned, future wave
├── articles/             # articles consumed / produced
├── reviews/              # peer-review artifacts per page
├── trackingQA/           # tracking quality material
├── PHASE_0_2_Proposal.md # current pilot test plan
├── Technical_SUMMARY_MIWikiAI_v0_5.md    # this file
└── MIWikiAI_Quick_Reference_Card_v0_5.md # binding rules

MIWikiAI/scripts/         # counter pipeline (NEW since v0.4)
├── parse_o2dpg.sh        # stage 1: O2DPG → invocation TSV
├── resolve_proto.sh      # stage 2: AliceO2 + O2Physics CMakeLists → catalogue
├── seed_join.sh          # stage 3: invocations + catalogue → seed
├── reachable.sh          # stage 4: seed → include-graph closure
├── symbols.sh            # stage 5: reachable → ctags TSV
├── count.sh              # stage 6: symbols + reachable → usage.csv
├── breakdown.sh          # stage 7: usage.csv → per-symbol per-file breakdown
└── MIWikiAI_Counter_Pipeline.md  # pipeline doc, v0.5 ratified
```

**New since v0.4.**
- `scripts/` directory: counter pipeline (six composable Bash scripts + breakdown sidecar) that produces empirical-usage substrate for software-index API pages.
- `PHASE_0_2_Proposal.md`: pilot test plan for advisor evaluation; v0.2 ratified 2026-04-30.
- `MIWikiAI_Quick_Reference_Card_v0_5.md`: binding rules document — first issuance — replaces the "QuickRef pending" placeholder.

## 3. Current content inventory (as of 2026-05-01, cycle 0 of this SUMMARY v0.5)

### 3.1 Artifact classes

| Class | Definition | Current pages |
|---|---|---|
| **source-of-truth** | indexes a TDR / JINST paper / authoritative physics document | TPC-SoT, ITS-SoT, TRD-SoT, FIT-SoT (2 versions), T0V0ZDC-SoT |
| **transcript-index** | indexes a presentation / conference deck / meeting transcript | PWGPP-643, O2-4592, O2-6344, ATO-630 (workshop deck), O2DistAI-ATO-628 (Phase 0.1), MITPCTPC-IonDrift, O2RecoAI-TrackingPerformance |
| **software-index — overview** | indexes a software repository module (tier-0+1) | AliceO2_overview, Common_utilities, DataFormats_Reconstruction, Framework_DPL |
| **software-index — _API** (NEW v0.5) | counter-driven deep API companion to overview (tier-1) | Common_utilities_API (DRAFT v0.1, in cycle-1 review) |
| **pipeline / doc** | governance + tooling documents | MIWikiAI_Counter_Pipeline (v0.5), PHASE_0_2_Proposal (v0.2), this Technical_SUMMARY, MIWikiAI_QuickRef |

### 3.2 Inventory (key entries)

| Page | Class | Status | Cycle | Reviewers |
|------|-------|--------|-------|-----------|
| AliceO2_overview | software-index — overview | DRAFT v0.5 (Module 1 fixes pending) | 1 | 7-reviewer panel cycle 1 |
| Common_utilities | software-index — overview | DRAFT v0.2 (Module 4) | 2 | panel-approved with carry-forwards |
| DataFormats_Reconstruction | software-index — overview | DRAFT v0.2-rev1 (Module 3) | 2 | panel-approved with 2 P2 carry-forwards |
| Framework_DPL | software-index — overview | DRAFT v0.2 (Module 2) | 2 | panel-approved |
| **Common_utilities_API** | **software-index — _API** | **DRAFT v0.1** — in cycle-1 review (9 reviewers reported) | 1 | Claude1, Claude2, Claude7, Sonnet1-3, Gemini1-3 — `[!]` APPROVED WITH COMMENTS |
| MIWikiAI_Counter_Pipeline | pipeline doc | v0.5 RATIFIED, commit 52858e3 | 2 | Claude7+Claude2+Sonnet3+Sonnet4+Sonnet4-2 cycle-2 |
| PHASE_0_2_Proposal | governance | v0.2 RATIFIED 2026-04-30 | 1 | Claude1+Claude2+Claude7 |
| TPC-SoT, ITS-SoT, TRD-SoT, T0V0ZDC-SoT, FIT-SoT | source-of-truth | various draft states | 1-2 | various |

**Phase 0.2 in flight.** `Common_utilities_API.md` v0.1 received 9-reviewer panel feedback on 2026-04-30 (1 P0, 18 P1, 25 P2 raw; 24 unique items after dedup). Coder Claude9 producing v0.2 with consolidated fix list. Two more `_API.md` files queued: `DataFormats_Reconstruction_API.md`, `Detectors_Base_API.md` (latter requires new overview parent).

## 4. Pipeline

```
                     ┌────────────────────┐
                     │  Source materials   │
                     │ TDR / slides / code │
                     └──────────┬──────────┘
                                ↓
           ┌──────────────── 4.1 ──────────────────┐
           │  Distillation into source_of_truth    │
           │  markdown (Main Coder)                │
           └──────────────────┬────────────────────┘
                              ↓
           ┌──────────────── 4.2 ──────────────────┐
           │  Conversion to MIWikiAI schema        │
           │  (Author session)                     │
           └──────────────────┬────────────────────┘
                              ↓
           ┌──────────────── 4.3 ──────────────────┐
           │  For software-index pages: counter    │  [NEW v0.5]
           │  pipeline produces usage.csv +         │
           │  breakdown.tsv as authoring substrate  │
           │  (scripts/, see §4a)                   │
           └──────────────────┬────────────────────┘
                              ↓
           ┌──────────────── 4.4 ──────────────────┐
           │  _API.md companion authoring          │  [NEW v0.5]
           │  (per-symbol rigid template + verbatim│
           │  worked examples + label vocabulary)  │
           └──────────────────┬────────────────────┘
                              ↓
           ┌──────────────── 4.5 ──────────────────┐
           │  Cycle-0 self-review (Coder)          │
           └──────────────────┬────────────────────┘
                              ↓
           ┌──────────────── 4.6 ──────────────────┐
           │  Panel review (3-9 reviewers per     │
           │  aspect assignment)                   │
           └──────────────────┬────────────────────┘
                              ↓
           ┌──────────────── 4.7 ──────────────────┐
           │  Main Reviewer synthesis →            │
           │  consolidated fix list                │
           └──────────────────┬────────────────────┘
                              ↓
                  Coder revises → next cycle, OR
                  Architect ratifies → live in wiki
                              ↓
           ┌──────────────── 4.8 ──────────────────┐
           │  Phase 0.2 advisor evaluation:        │  [NEW v0.5]
           │  3-condition test (overview / +API /  │
           │  +API+source) × 5 queries × 0-3 grade │
           └────────────────────────────────────────┘
```

### 4a. Counter pipeline (NEW v0.5, see `MIWikiAI_Counter_Pipeline.md`)

Six-stage Bash pipeline + sidecar producing empirical usage signals as input to `_API.md` authoring:

| Stage | Script | Input → Output |
|---|---|---|
| 1 | `parse_o2dpg.sh` | O2DPG tree → `o2dpg_invocations.tsv` (~700 rows) |
| 2 | `resolve_proto.sh` | AliceO2 CMakeLists → `catalogue_o2.tsv` (~570 rows) |
| 3 | `seed_join.sh` | invocations + catalogue → `seed.txt` (~140 sources) |
| 4 | `reachable.sh` | seed + AliceO2 → `reachable.txt` (~1569 files, 13-iter convergence) |
| 5 | `symbols.sh` | reachable → `symbols.tsv` (~106k ctags rows) |
| 6 | `count.sh` | symbols + reachable → `usage.csv` (13 cols, ~780 logical symbols) |
| 7 | `breakdown.sh` | usage.csv → `breakdown.tsv` (top-K callers + ALL ambiguous) |

End-to-end runtime ~10 seconds. v0.5 ratified after cycle-2 panel review with R-1 (GPUCA filter) and R-2 (breakdown ambiguous coverage) fixes. Counter signals feed every `_API.md` page's front-matter and per-symbol entries.

## 5. Schema — ratified to QuickRef v0.5

The full binding schema lives in `MIWikiAI_Quick_Reference_Card_v0_5.md` — first issuance, paired with this Technical_SUMMARY. The QuickRef supersedes the "schema provisional pending QuickRef" status carried since v0.1. Highlights of the schema (full detail in QRC §2-3):

### 5.1 Front-matter fields (binding)

Inherited from v0.4:
- `source_inconsistencies:` (CONFLICT-N convention)
- `introduction_only:` (orientation-document demotion)
- `source_fingerprint.upstream[].known_errata:`
- `source_fingerprint.upstream[].commit_verified:` (40-char SHA)
- `review_assignment_doc:`

New in v0.5 (binding for `_API.md` files only):
- `counter_baseline:` block (pipeline_version, aliceo2_sha, baseline_run_date, filter_scope, usage_csv, breakdown_tsv)
- `counter_signals_per_symbol:` list
- Per-symbol orthogonal axes: `is_static`, `is_template`, `is_ambiguous`, `risk_class`, `caller_breadth`

### 5.2 Body conventions (additive in v0.5)

- Two-file pattern for software-index pages: `<Module>.md` (overview) + `<Module>_API.md` (deep API)
- Three-tier advisor escalation: tier-0 overview → tier-1 API → tier-2 source-fetch
- Per-symbol rigid template (machine-greppable; QRC §2.6)
- **Label vocabulary (BINDING):** `[VERBATIM <path>:L<line>]` / `[ARCHITECT-MARIAN-VERIFIED]` / `[ARCHITECT-MARIAN-PARAPHRASE]` / `[FABRICATED — illustrative only]`
- **Anti-silent-paraphrase rule (P0 violation if broken):** see QRC §3.2

### 5.3 Inline tag grammar (carried from v0.4)

`[GH]`, `[DX]`, `[QS]`, `[AD]`, `[TDR]`, `[PP]`, `[CC]` — see v0.4 §5.3 for definitions; unchanged in v0.5.

## 6. Team roster (IDs in use)

**Architect ratifications:** Reviewer IDs increment sequentially within MIWikiAI; IDs unique within team. Roster is **dynamic** — reviewer pool rotates per review cycle; aspect coverage (≥3 reviewers per aspect, ≥1 Opus per subgroup) is the binding requirement, not fixed reviewer-to-aspect assignment. Snapshot below dated **2026-04-29** (deep-code-check pool expanded to Claude1-6 + Sonnet1-4 + Gemini1-3 = 13 reviewers; pool may evolve).

| ID | Role | Phase 0.1 / 0.2 contributions | Status |
|----|------|-----------------------|--------|
| **Claude1** | Reviewer (Main Reviewer for Common_utilities_API v0.1 cycle-1b) | Module 1 A-primary, Module 4 review, Counter Pipeline cycle-1, Phase 0.2 Proposal cycle-1 + cycle-2, Common_utilities_API cycle-1 | active |
| **Claude2** | Reviewer / Coder | Module 1 E-primary, Module 4 B-primary (registration patterns), Counter Pipeline cycle-1, Phase 0.2 Proposal cycle-1, Common_utilities_API cycle-1 | active |
| **Claude3** | Reviewer | TPC-SoT cycle-2, Module 1 B-primary | active |
| **Claude4** | Reviewer | Module 1 F-primary, governance items | active |
| **Claude5** | Reviewer | recent assignment to deep-code-check pool 2026-04-29 | active |
| **Claude6** | Reviewer | Module 1 G-primary; deep-code-check pool 2026-04-29 | active |
| **Claude7** | Main Reviewer (cross-cycle) — synthesis discipline binding per `Main_Reviewer_Quick_Reference_Card.md` (Organization-level, 2026-05-01) | Module 1 D-primary + Main Reviewer synthesis, Counter Pipeline cycles 1-2, Phase 0.2 Proposal cycles 1-2, Common_utilities_API cycle-1 (synthesized 9-reviewer panel; cycle-1 truncation incident on first pass corrected after architect challenge — origin entry for new Organization-level Main Reviewer card) | active |
| **Claude8** | Coder | AliceO2_overview v0.1-v0.5 indexing, Phase 0.1 Module 1 review assignment doc | active |
| **Claude9** | Coder (THIS DOCUMENT'S AUTHOR) | Counter Pipeline (cycles 0-2, full authorship), PHASE_0_2_Proposal (v0.1+v0.2 authorship), Common_utilities_API v0.1 authorship + v0.2 in flight, MIWikiAI_QRC + Technical_SUMMARY v0.5/v0.5.1 authorship | active |
| **Sonnet1** | Reviewer | Common_utilities_API cycle-1 C-primary | active |
| **Sonnet2** | Reviewer | Common_utilities_API cycle-1 B-secondary, C-secondary | active |
| **Sonnet3** | Reviewer | Counter Pipeline cycle-2 (R-1 + R-2 findings), Common_utilities_API cycle-1 D-primary (red-team) | active |
| **Sonnet4** | Reviewer | Counter Pipeline cycle-2, PHASE_0_2_Proposal cycle-1 | active |
| **Gemini1** | Reviewer (limited) | Common_utilities_API cycle-1 B-secondary | active (verbatim-citation requirement; UNCERTAIN-not-FAIL discipline) |
| **Gemini2** | Reviewer (limited) | Common_utilities_API cycle-1 G-primary (link mechanics) | active (E/F-aspect restriction per cycle-2 lesson) |
| **Gemini3** | Reviewer (limited) | Common_utilities_API cycle-1 F-primary (quantitative consistency) | active |
| Marian Ivanov | Architect / dissertation lead | All architect decisions | active |

**Dynamic pool note (2026-04-29):** the deep-code-check pool for `_API.md` artifacts was expanded from 9 to 13 (Claude1-6 + Sonnet1-4 + Gemini1-3). Coverage rule: **per cycle, ≥3 reviewers per aspect, ≥1 Opus per subgroup.** Aspect mapping is decided per-review by the architect or Main Reviewer based on artifact-specific expertise needs; not fixed in the roster. Reviewers cycle in and out across reviews. Opus reviewers are most expensive but mandatory for first-line aspect coverage; Sonnet/Gemini provide cross-check breadth.

**Changes vs v0.4:**
1. Claude9 attribution corrected — Coder for counter pipeline cycles 0-2 (was incorrectly attributed to Claude5 in v0.5; Claude5 is a Reviewer, not Coder).
2. Sonnet1-4 listed as active (panel use; v0.4 lumped them under "review panel" historically).
3. Gemini1-3 listed as active with explicit limitation flags from cycle-2 governance lessons (verbatim-citation requirement; F/E-aspect restriction; UNCERTAIN-not-FAIL discipline) — see §8 item 18 for governance trail.
4. Roster declared **dynamic** with snapshot date 2026-04-29; aspect mapping decided per review, not fixed in roster.
5. ClaudeOpus47¹ attribution-pending entry retained pro forma; no new contributions since v0.4.

## 7. Open work

### 7.1 Phase 0.1 — Module-by-module software-index overview review (CLOSING)

Modules 1-4 reviewed and gate-approved with carry-forwards. Module 5 (next) panel-recommended downsizing to 8 reviewers (5 Sonnet + 2 Opus + 1 Gemini restricted to F-aspect).

### 7.2 Phase 0.2 — `_API.md` companion authoring + advisor pilot test (ACTIVE)

- `Common_utilities_API.md` v0.1 produced; cycle-1 review complete (9 reviewers, `[!]` APPROVED WITH COMMENTS, 24-item fix list)
- v0.2 in flight by Coder Claude9 (estimated 5-6 hours work)
- After v0.2 ratifies: pilot test runs (5 queries × 3 conditions × 2 advisor harness passes = 30 graded results; architect grading time 90-120 min)
- Two more `_API.md` files queued: `DataFormats_Reconstruction_API.md` (counter scope + source already provided 2026-05-01); `Detectors_Base_API.md` (requires new overview parent)

### 7.3 Phase 0.3 — Scope expansion based on pilot results (PLANNED)

Failure pattern from Phase 0.2 advisor pilot determines priority order:
- Likely first: `Field_API.md` + `Detectors_Base_API.md` to cover sim-vs-reco field differences
- Likely next: `Reconstruction_Tutorials.md` for Kalman-from-points worked example
- Pure-RAG fourth condition added to advisor test for parameter-scan benchmarking

### 7.4 Counter pipeline — clang AST upgrade (DEFERRED to v1.0)

Identified during Phase 0.1 cycle-2: regex+ctags pipeline has structural limits (template instantiation invisibility, common-noun-method false positives, multi-class same-bare-name ambiguity). clang AST upgrade is the right fix. ~3-5 days work; deferred until current pipeline output is operationally insufficient.

### 7.5 Local CCDB caching (NEW infrastructure-page topic per architect Q1 2026-04-30)

Architect Q1 confirmed CCDB-priority-vs-job-init timing as operationally observed failure mode. Local CCDB caching identified as future infrastructure improvement; deserves a dedicated wiki page when prioritized.

### 7.6 End-of-sprint gate

Promotion of all DRAFT pages to `[OK]` formal status batched to end-of-Phase-0.2-pilot. Cross-page link sync, review-artifact commits, governance ratifications batched together.

## 8. Known limitations and open conventions

(Items 1-17 carried from v0.4 unchanged.)

- 18. **Gemini reliability constraints** (NEW v0.5). Cycle-2 lesson: Gemini reviewers must use verbatim citation; flag UNCERTAIN rather than FAIL when contradicting other reviewers; restricted primarily to E/F aspects. Codified in MIWikiAI_QRC v0.5 §4.
- 19. **Ambiguous-symbol counter handling** (NEW v0.5). Counter pipeline marks symbols defined in N>1 files as `name_uniqueness=ambiguous` with `prod_usage_count=-1`. `_API.md` pages handle these via dedicated disambiguation subsections cross-referenced to `breakdown.tsv`.
- 20. **Anti-silent-paraphrase rule** (NEW v0.5, P0 violation). Codified in QRC §3.2 after Common_utilities_API v0.1 cycle-1 architect Q4 reaction. Source-access protocol mandatory before authoring; FABRICATED label required for unsourced examples.
- 21. **Three-tier advisor escalation** (NEW v0.5). Overview → API → source-fetch. Skipping tier 0 only allowed for line-precise source queries. Label preservation by advisor when citing.
- 22. **Orthogonal-metadata-axes per symbol** (NEW v0.5, architect Q2 direction). Five axes: is_static, is_template, is_ambiguous, risk_class, caller_breadth. Trivial advisor queries answered from front-matter alone.

## 9. Review Process Canonical Workflow (carried from v0.4 §9)

§9.1-§9.8 unchanged from v0.4 in substance. Two refinements ratified during Phase 0.1/0.2:

- **§9.4 Main Reviewer discipline (CODIFIED v0.5.1).** Main Reviewer rules previously stated as free prose in v0.5 are now codified at Organization level in `Main_Reviewer_Quick_Reference_Card.md` (first issuance 2026-05-01). Binding rules: (a) Coverage Matrix MUST begin every summary listing every reviewer received; (b) every submitted finding maps to output status (represented / merged / rejected with reason / out of scope); (c) convergence claims name the contributing reviewers; (d) raw inputs retained or linked for audit; (e) architect concerns get dedicated section, never merged into general P0/P1/P2. Selective truncation (omission of reviewer input regardless of intent) is structurally prevented by Coverage Matrix requirement. Origin: Common_utilities_API v0.1 cycle-1 truncation incident — Main Reviewer cited 3 of 9 received reports; corrected after architect challenge. **MIWikiAI inherits these rules; future Main Reviewer summaries on MIWikiAI artifacts that violate them are P0 governance violations.** Cross-reference: Reviewer_QRC v1.29 Rule 13.

- **§9.7 Reviewer-count empiricism (REINFORCED v0.5).** Phase 0.2 Proposal review (3 reviewers) and Common_utilities_API v0.1 (9 reviewers) bracket the useful range. 9 reviewers is *not* over-engineering when convergence-weighted findings produce 24 distinct items; 3 reviewers is sufficient for governance documents but insufficient for content-bearing artifacts.

## 10. Advisor team (NEW v0.5)

MIWikiAI is responsible for the AI advisor consuming MIWikiAI pages. Binding rules in MIWikiAI_QRC v0.5 §5; summarized here.

### 10.1 Three-tier consumption

Advisor receives query → reads tier-0 overview pages → escalates to tier-1 `_API.md` if insufficient → escalates to tier-2 source-fetch tools if insufficient. Skipping tier 0 only when query targets line-precise source facts.

### 10.2 Label preservation

Four labels (`[VERBATIM]`, `[ARCHITECT-MARIAN-VERIFIED]`, `[ARCHITECT-MARIAN-PARAPHRASE]`, `[FABRICATED — illustrative only]`) MUST be preserved by the advisor when citing wiki content. FABRICATED content MUST carry the warning when quoted; advisor MUST NOT present FABRICATED content as authoritative.

### 10.3 Three-condition test pattern (Phase 0.2 pilot, framework for ongoing benchmarking)

Every test query runs in three conditions:
- A. baseline (overview only)
- B. +API (overview + `_API.md`)
- C. +API + source-fetch tool

Architect grades 0-3 per query × condition. Phase 0.3 may add condition D (pure RAG over source corpus) for four-way comparison.

### 10.4 Benchmarking framework (Phase 0.3+)

Three orthogonal axes: quality (0-3 architect grade), speed (wall-clock per query), tokens (context tokens per query). Logged in `pilot_results.md` per query × condition. Substrate for parameter-scan optimization (architect Q2 direction).

### 10.5 Vector-DB-vs-wiki comparison (planned)

Once `_API.md` corpus exceeds ~50 pages, embedding-backed retrieval over the wiki itself becomes useful (vs. preloading entire wiki). Phase 1.0+. Wiki content remains the curated substrate; embedding adds selectivity at scale. Pure-RAG-over-source comparison runs in Phase 0.3 as condition D.

## 11. Cross-team coordination

(Items 1-7 carried from v0.4 §10 unchanged.)

8. **Label vocabulary** (NEW v0.5, candidate for Organization-level adoption). Four-label scheme has cross-team applicability where wiki authoring + AI advisor consumption + verbatim source citation overlap.

9. **Counter-pipeline pattern** (NEW v0.5, partially generalizable). The pipeline produces empirical usage signals from a CMake-based codebase; method generalizes to other code-based wiki teams.

10. **Main Reviewer synthesis discipline** (RECEIVED 2026-05-01). The MIWikiAI cycle-1 truncation incident (Common_utilities_API v0.1: 3 of 9 reviewer reports cited in initial summary) was the origin event for `Main_Reviewer_Quick_Reference_Card.md` — first issuance, Organization-level. Selective truncation defined; Coverage Matrix MUST-begin requirement; finding-level traceability table; raw-input retention. MIWikiAI inherits these rules unchanged from v0.5.1 forward. See QRC v0.5.1 §1 inheritance table and §4.

NOT proposed for Organization-level adoption (remains MIWikiAI-internal):
- Specific reviewer IDs (Claude1-9, Sonnet1-4, Gemini1-3) — scoped by `[MIWikiAI]` team token
- Page-class taxonomy (source-of-truth / transcript-index / software-index)
- Counter-pipeline scripts — MIWikiAI-internal tooling

## 12. Changelog

- **v0.5.1 (2026-05-01).** Three additive alignments to Organization documents received same day. (a) Front-matter inheritance pointers updated: MTTU_Reviewer v1.21→v1.22, Reviewer_QRC v1.27→v1.29, Main_Reviewer_QRC added (first issuance 2026-05-01). (b) §6 Claude7 Main Reviewer entry now references canonical Main Reviewer card. (c) §9.4 Main Reviewer discipline reinforcement now CODIFIED — points to the canonical Organization-level card instead of being free-floating prose; explicit P0 violation classification for MIWikiAI Main Reviewer summaries that omit Coverage Matrix or unmapped findings. (d) §11 cross-team item 10 added recording Organization adoption of MIWikiAI cycle-1 truncation incident as origin event. No semantic changes to v0.5 rules.

- **v0.5 (2026-05-01).** Paired update with `MIWikiAI_Quick_Reference_Card_v0_5.md` (first issuance). Phase 0.2 in flight: Common_utilities_API v0.1 → v0.2 in cycle-1 review; PHASE_0_2_Proposal v0.2 ratified; counter pipeline v0.5 ratified. §3 inventory adds Phase 0.2 artifacts + scripts/ tree. §4 pipeline now includes counter substrate (4a) and advisor evaluation (4.8). §5 schema ratified to QRC v0.5; new front-matter `counter_baseline:` block + per-symbol orthogonal axes; binding label vocabulary. §6 roster expanded with Claude5, Claude9, Sonnet1-4, Gemini1-3 (active assignments). §7 Phase 0.1 closing, Phase 0.2 active, Phase 0.3 planned, clang AST deferred to v1.0. §8 items 18-22 added (Gemini constraints, ambiguous handling, anti-paraphrase, three-tier escalation, orthogonal axes). §9 Main Reviewer discipline reinforced after truncation incident. §10 Advisor team section added. §11 cross-team adds label vocabulary + counter-pipeline pattern as candidates.
- **v0.4 (2026-04-23).** Phase 0.1 Module 1 review-cycle evidence; §9 Review Process Canonical Workflow added; §6 roster expanded with Claude4/6/7/8 active.
- **v0.3 (2026-04-19).** Architect decisions A-E ratified; indexation-sprint mode.
- **v0.2 (2026-04-19).** Six-review v0.1 fix-pass.
- **v0.1 (2026-04-19).** First full-scope Technical_SUMMARY.

---

*Compiled by Claude9 (Claude Opus 4.7, MIWikiAI reviewer-ID Claude9, Coder role for this artifact) on 2026-05-01 (v0.5.1) with minor in-place corrections 2026-05-02 (Coder ID corrected to Claude9; reviewer pool snapshot dated 2026-04-29; aspect mapping declared per-cycle, not fixed). Paired with `MIWikiAI_Quick_Reference_Card_v0_5_1.md`. Phase 0.2 in flight; Common_utilities_API v0.2 in production. Awaits architect ratification.*

*No quota issues observed during compilation.*
