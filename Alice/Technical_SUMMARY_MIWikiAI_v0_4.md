---
doc_id: Technical_SUMMARY_MIWikiAI
doc_type: technical-summary
project: MIWikiAI
version: v0.4 (Phase 0.1 Module 1 review-cycle codification; §9 Review Process Canonical Workflow added; §6 roster expanded)
date: 2026-04-23
author: Marian Ivanov
compiled_with: Claude7 (Claude Opus 4.7)
status: DRAFT — architect-review requested
review_cycle: 4
review_status: DRAFT pending architect ratification + at least 1 panel cycle
prior_version: v0.3 (2026-04-19) — APPROVED FOR INDEXATION with architect A–E decisions ratified
supersedes: v0.3 with additive deltas; no prior decisions reversed
architect_ratifications_2026_04_19: [A=Option-A-default, B=deferred, C=override-F6-routing, D=CoderQRC-v1.28, E=TeamID-MIWikiAI, item-7=Claude4-assigned]
architect_ratifications_2026_04_23:
  - "Reviewer ID namespace: architect-ratified incremental numbering; IDs within MIWikiAI must be unique; Claude4, Claude6, Claude7, Claude8 active"
  - "CONFLICT-N inline marker convention + source_inconsistencies[] front-matter block ratified for Phase 0.1 v3 schema"
  - "Schema A/B split ratified: hub/overview pages (Schema A) may elide 'Key classes / types / functions'; module pages (Schema B) follow full Phase 0.1 §2.2 template"
  - "Tag split ratified: [AD] restricted to alice-doc.web.cern.ch only; new tags [TDR] (ALICE Technical Design Reports), [PP] (peer-reviewed papers), [CC] (CERN Courier / journalism)"
  - "Folder convention ratified: Alice/code/O2/ for AliceO2 framework; Alice/code/O2Physics/ and Alice/code/O2DPG/ for future waves"
  - "CONFLICT-1 reframed per Claude5 F-new1: Run 1 and Run 2 had identical ALICE recorded Pb–Pb rates (~1 kHz, TPC-readout-limited); the 100× multiplier applies against either baseline; neither primary source is in error"
---

# MIWikiAI — Technical SUMMARY

## 1. What MIWikiAI is

A group producing **AI-queryable wiki pages** distilled from ALICE physics sources (TDRs, JINST papers, presentations, code modules, articles). Every page is a **Karpathy-style compiled knowledge document** — thematic, sourced, machine-readable — intended to be fed directly to LLMs as a trusted knowledge base, replacing RAG over raw PDFs.

Distinct from RAG: RAG retrieves chunks from unstructured sources at query time. MIWikiAI compiles once; the entire wiki fits into a model context (target: Claude Opus 4.x, Sonnet 4.6, Gemini 2.5, GPT-5 class; current nine pages total ~500 kB of markdown) and answers questions by reading, not retrieval.

As of v0.4, MIWikiAI indexes three artifact classes: **source-of-truth** (TDR-based detector pages), **transcript-index** (presentation-based indexes), and **software-index** (code-repository indexes; introduced by Phase 0.1 Module 1). See §3 inventory.

## 2. Repository layout

```
MIWikiAI/Alice/
├── presentations/        # indexed from Google Slides / conference decks
├── TDR/                  # Source-of-Truth pages per ALICE subdetector
│                         #   (canonical folder name on disk; an eventual rename
│                         #    to `detectors/` is under consideration but not applied)
├── code/                 # software-index pages (new class, introduced 2026-04-21)
│   ├── O2/              # AliceO2 framework (Phase 0.1 active)
│   ├── O2Physics/       # planned, future wave
│   └── O2DPG/           # planned, future wave
├── documents/            # papers, JIRA tickets, arXiv refs
├── articles/             # articles consumed / produced
├── reviews/              # peer-review artifacts per page (see §3 and §7.1)
└── Technical_SUMMARY_MIWikiAI.md   # this file
```

**New in v0.4.** `code/` folder grew a three-subfolder structure (`O2/`, `O2Physics/`, `O2DPG/`) ratified by the architect on 2026-04-21 as part of Phase 0.1 kickoff. Previously `code/` was described as a placeholder for "reusable modules (e.g. quantile_fit_nd)"; that placeholder usage remains compatible — reusable modules without a subproject prefix sit at `code/` root.

## 3. Current content inventory (as of 2026-04-23, cycle 4 of this SUMMARY)

Every entry below is auditable by running `grep -E "^review_cycle:|^peer_reviewers:|^source_status:|^review_status:" Alice/TDR/*.md Alice/presentations/*.md Alice/code/O2/*.md` against the committed tree — see §7.2 for the automation recommendation.

`ClaudeOpus47¹` entries below carry attribution-pending status per §8 item 1.

### 3.1 Artifact classes

| Class | Definition | Current pages |
|---|---|---|
| **source-of-truth** | indexes a TDR / JINST paper / authoritative physics document; one page per detector or system | TPC-SoT, ITS-SoT, TRD-SoT |
| **transcript-index** | indexes a presentation / conference deck / meeting transcript | PWGPP-643, O2-4592, O2-6344, ATO-630 (offline-week deck), O2DistAI-ATO-628 (Phase 0.1 status deck) |
| **software-index** | indexes a software repository module; one page per module (or parent+fanout for large modules) | AliceO2_overview (Phase 0.1 Module 1, in cycle-1 review) |

### 3.2 Inventory

| Page | Class | Path | Source | Review state | Last verdict | Cycle | Peer reviewers (on-disk) |
|------|-------|------|--------|--------------|--------------|-------|--------------------------|
| PWGPP-643 | transcript-index | `presentations/` | Google Slides (56) | DRAFT wiki-v1 | self-reviewed | 1 | *(unverified)* |
| O2-4592 | transcript-index | `presentations/` | Google Slides (216) | DRAFT | `[!]` | 1 | *(unverified)* |
| O2-6344 | transcript-index | `presentations/` | Google Slides (61) — material budget + ITS/TRD alignment | DRAFT wiki-v1 (cycle-0 peer review by Claude8) | `[!]` | 1 | `[Claude8]` |
| ATO-630 OfflineWeek | transcript-index | `presentations/` | Google Slides (23) — ClusterErrParam workshop | DRAFT wiki-v1 | `[!]` | 1 | `[Claude2, Claude5, Claude7, Claude8]` |
| O2DistAI-ATO-628 Phase 0.1 | transcript-index | `presentations/` | Google Slides (17) — iterative ITS-TPC distortion calibration | DRAFT wiki-v1 | self-reviewed | 0 | `[Claude5]` |
| TPC-SoT | source-of-truth | `TDR/` | JINST 2008 + TDR-016 | DRAFT wiki-v2 | `[!]` cycle-1; cycle-2 applied | 2 | `[ClaudeOpus47¹, Claude3]` |
| ITS-SoT | source-of-truth | `TDR/` | JINST 2008 + TDR-017/021 | DRAFT wiki-v1 | `[!]` cycle-1 | 1 | `[ClaudeOpus47¹]` |
| TRD-SoT | source-of-truth | `TDR/` | TRD-TDR + JINST 2008 | DRAFT wiki-v2 (source PARTIAL turn 1/2) | `[!]` cycle-1; cycle-2 applied | 2 | `[ClaudeOpus47¹]` |
| **AliceO2_overview** | **software-index** | `code/O2/` | GitHub AliceO2 repo + quickstart + peer-reviewed papers | **DRAFT v0.4**; panel cycle-1 synthesis completed; **v0.5 fix-pass pending** | `[!]` (5 reviewers) + `[OK]` (2 reviewers) | 1 | `[Claude1, Claude2, Claude3, Claude4, Claude5, Claude6, Claude7]` |

¹ `ClaudeOpus47` attribution remains pending architect ratification; see §8 item 1. Treat as distinct pending-attribution reviewer ID per Option A default.

**Planned pages.** TOF-SoT, T0V0ZDC-SoT, O2-5095 deck (source-of-truth and transcript-index queue). Phase 0.1 Modules 2–4: `Framework_DPL.md`, `DataFormats_Reconstruction.md`, `Common_utilities.md` (software-index, sequential; gated on Module 1 approval).

**Schema-convergence status (evidence-bound).** Nine pages produced across three content types. Zero pages have formally crossed `[OK]` yet; this is by design during the indexation sprint (§7.1). AliceO2_overview cycle-1 panel review (7 reviewers on 7 aspects) is the first multi-reviewer panel in MIWikiAI history; its lessons are codified in §9.

## 4. Pipeline

```
Source (PDF / slides / code module / article)
    ↓
[Main Coder — distillation into source_of_truth markdown]
    ↓
[Author session (Claude / GPT / Gemini) — conversion to MIWikiAI schema]
    ↓
[Peer reviewer session] ←→ author response + revisions (cycle 0 → N)
    ↓
Optional: [Multi-reviewer panel — for high-stakes pages; see §9]
    ↓
Optional: [Main Reviewer synthesis + actionable fix-list]
    ↓
DRAFT → [OK] APPROVED  (deferred during indexation sprint per architect)
    ↓
Live in wiki; cross-linked from other pages via bidirectional retrofit
```

**Indexation-sprint mode (active 2026-04-19, ongoing).** During the sprint, pages commit as DRAFT with optional one-pass review (max 3 findings, `[!]` or `[OK]` verdicts only). Promotion to `[OK]` formal status is batched to end-of-sprint. Cross-page link sync, review-artifact commits, and governance ratification also batch to end-of-sprint. See §7.4.

**Phase 0.1 multi-reviewer panel mode (introduced 2026-04-21).** For software-index pages that will be templates for a multi-module wave, sprint-mode's 3-finding cap is lifted in favour of a 7-reviewer panel with aspect assignments, deep-validation checklists per aspect, and a Main Reviewer synthesizing findings into an actionable fix-list. See §9.

**Source status is first-class.** When a source is delivered in turns (e.g. TRD 1/2), the page declares `source_status: PARTIAL` and marks incomplete sections `[STUB — awaiting Turn N]`. Pages do not wait on complete sources to start review.

## 5. Schema — provisional pending QuickRef ratification

The full schema rules will live in `MIWikiAI_QuickRef_v1.0.md` once drafted (Claude4 authoring). v0.4 of this SUMMARY records convention deltas ratified in Phase 0.1:

### 5.1 Front-matter fields

Unchanged from v0.3 with these additions ratified in Phase 0.1 v3:

- **`source_inconsistencies:`** (optional, Phase 0.1 v3). A list of documented disagreements between primary sources. Each entry has `{id, topic, description, sources[] (with verbatim quotes), physical_check (optional), chosen, rationale, discovered_by}`. First applied in AliceO2_overview v0.4 (three CONFLICT entries). Inline body references use the `[CONFLICT-N]` marker; see §5.3.
- **`introduction_only:`** (optional, Phase 0.1 v3). A list of documents cited for context only — NOT primary sources. Each claim must be independently re-verified against a primary source before inclusion in body. Used in AliceO2_overview to demote O2RecoAI Technical Summary v1.3 from "authoritative" to "orientation document."
- **`source_fingerprint.upstream[].known_errata:`** (optional, Phase 0.1 v3). Sub-field on an upstream entry documenting known imperfections in that source without invalidating it as primary. Used when a primary source contains a minor error that the wiki corrects inline.
- **`source_fingerprint.upstream[].commit_verified:`** (required for GitHub sources, Phase 0.1 v3). Full SHA pin. Short SHAs are P2 findings; prefer 40-char SHA for reproducibility.
- **`review_assignment_doc:`** (optional). Pointer to the assignment document used for panel reviews (see §9.3).

### 5.2 Body conventions

- **TL;DR first**, thematic (not flat transcription), every number cited with a tag, every `[computed]` value shows its derivation inline.
- **Inline primary-source tags** (ratified in Phase 0.1 v3): `[GH]`, `[DX]`, `[QS]`, `[AD]`, `[TDR]`, `[PP]`, `[CC]` — see §5.3.
- **Closing sections:** Glossary, External References (+ BibTeX), Open items / reviewer checklist, Related wiki pages, Source-to-section Appendix, Notation Appendix, Changelog.

### 5.3 Inline tag grammar (ratified 2026-04-23)

| Tag | Meaning | Proximity to code |
|---|---|---|
| `[GH]` | AliceO2 GitHub repository (path + commit SHA) | highest |
| `[DX]` | AliceO2 Doxygen at aliceo2group.github.io/AliceO2/ | high |
| `[QS]` | AliceO2 Quickstart / code-organisation pages | high |
| `[AD]` | alice-doc.web.cern.ch entries only (narrow scope) | medium |
| `[TDR]` | ALICE Technical Design Reports (`[TDR: ALICE-TDR-019]`) | medium |
| `[PP]` | Peer-reviewed papers (arXiv preprints of published papers, EPJ, JHEP, etc.) (`[PP: arXiv:2402.01205]`) | medium |
| `[CC]` | CERN Courier / community-magazine journalism; authoritative within CERN but lower tier than `[PP]` | low |
| `[CONFLICT-N]` | Read-only marker pointing to `source_inconsistencies[N]` in front-matter | — |

**Historical note.** v0.3 and earlier used `[AD]` as a catch-all for any ALICE-documentation source beyond GitHub/Doxygen/quickstart, conflating TDRs, peer-reviewed papers, and journalism. Phase 0.1 v3 split this into `[TDR]` / `[PP]` / `[CC]` and restricted `[AD]` to its literal domain meaning. See Phase 0.1 Module 1 cycle-1 finding CV-2.

### 5.4 Schema variants (ratified 2026-04-23)

Phase 0.1 §2.2 template originally mandated sections `§1 Purpose → §2 Directory layout → §3 Key classes → §4 Interfaces → §5 Build and CI`. Experience with AliceO2_overview showed that hub/overview pages do not have "key classes / types / functions" content (that content belongs to module pages). Ratified split:

- **Schema A (hub / overview pages):** `§1 Purpose → §2 System context → §3 Repository layout → §4 Build workflow → §5 Build and CI → §6 Known limits → §7 Cross-refs → §8 External refs → Appendices`. Applied to `AliceO2_overview.md`.
- **Schema B (module pages):** full Phase 0.1 §2.2 template with `§3 Key classes / types / functions`. Will apply to `Framework_DPL.md`, `DataFormats_Reconstruction.md`, `Common_utilities.md`.

## 5a. Cross-page dependencies (TS-template retrofit)

| From | To | Dependency | Last verified |
|------|----|------------|--------------|
| `TDR/tpc.md §11.6` | `TDR/its.md` | cross-link status | 2026-04-19 — label stale (sync batched to §7.4) |
| `TDR/tpc.md §11.6` | `TDR/trd.md` | cross-link | 2026-04-19 — up to date at cycle 2 |
| `TDR/its.md §9` | `TDR/tpc.md` | cross-link | 2026-04-19 — label stale (sync batched) |
| `TDR/trd.md §8` | `TDR/tpc.md` | cross-link | 2026-04-19 — up to date at cycle 2 |
| `code/O2/AliceO2_overview.md §7` | `TDR/tpc.md`, `TDR/its.md`, `TDR/trd.md` | cross-link | 2026-04-23 — up to date |
| `code/O2/AliceO2_overview.md §7` | `presentations/O2-6344_*.md` | contextual cross-link | 2026-04-23 — up to date |
| `code/O2/AliceO2_overview.md §7` | `presentations/O2DistAI-ATO-628_*.md` | contextual cross-link | *(added in v0.5)* |
| All `TDR/*.md` | `presentations/*.md` | anchor references | unverified by script — §7.2 |
| `code/O2/AliceO2_overview.md` anchor set | future `code/O2/Framework_DPL.md`, `code/O2/DataFormats_Reconstruction.md`, `code/O2/Common_utilities.md` | **frozen** on Module 1 approval per Phase 0.1 §5.3 | pending Module 1 gate 1 |

## 6. Team roster (IDs in use)

**Architect ratification 2026-04-23:** Reviewer IDs increment sequentially within MIWikiAI; IDs must be unique within the team. Claude4, Claude6, Claude7, Claude8 all ratified active.

| ID | Model / Role | Contributions to date | Status |
|----|--------------|-----------------------|--------|
| **Claude1** | Claude Opus 4.7 — Indexer / Reviewer | ITS-SoT, TRD-SoT indexing passes; `[!]` review of v0.1 of this SUMMARY; Phase 0.1 Module 1 A-primary + D-secondary cycle-1 on v0.4 | active |
| **Claude2** | Claude Opus 4.7 — author (this SUMMARY, prior versions) / Reviewer | PWGPP-643 authoring; 5 prior reviews signed as `ClaudeOpus47¹`; Phase 0.1 Module 1 E-primary + A-secondary cycle-1 on v0.3 and v0.4 | active |
| **Claude3** | Claude (model per architect record) — Reviewer | TPC-SoT cycle-2 review (drove TPC wiki-v1 → wiki-v2); `[X]` on v0.1 of this SUMMARY; Phase 0.1 Module 1 B-primary + E-secondary cycle-1 on v0.4 | active |
| **Claude4** | Claude (model per architect record) — Reviewer / QuickRef author | O2-4592 cycle-2 re-issue; `[BLOCKED]` on v0.1→v0.2 preconditions; `[!]` on v0.2 post-architect-decisions; Phase 0.1 Module 1 F-primary + B-secondary cycle-1 on v0.3 and v0.4; `MIWikiAI_QuickRef v1.0` authoring assigned | active (ID ratified 2026-04-19) |
| **Claude5** | Claude (model per architect record) — Reviewer | `[X]` reviews on v0.1 of this SUMMARY and v0.1 consolidation; `[!]` on v0.2; Phase 0.1 Module 1 C-primary + F-secondary cycle-1 on v0.3 and v0.4; cycle-1 v0.4 F-new1 reframe via external source fetch (arXiv:2106.08353) | active |
| **Claude6** | Claude (model per architect record) — Reviewer | `[X]` review on v0.1 of this SUMMARY (governance-heavy); Phase 0.1 Module 1 G-primary + C-secondary cycle-1 on v0.4 | active (ID ratified 2026-04-23) |
| **Claude7** | Claude Opus 4.7 — Reviewer / Main Reviewer | Phase 0.1 Module 1 D-primary + G-secondary cycle-1 on v0.3 and v0.4; Main Reviewer synthesis on Module 1 cycle-1 v0.3 and v0.4; compiler of this SUMMARY v0.4 | active (ID ratified 2026-04-23) |
| **Claude8** | Claude Opus 4.7 — Coder / Indexer | Indexer for O2-6344 cycle-0; indexer for AliceO2_overview v0.1 → v0.5; author of Phase 0.1 proposal v1→v3; author of Phase 0.1 Module 1 Review Assignment doc | active (ID ratified 2026-04-23) |
| **ClaudeOpus47¹** | Claude Opus 4.7 — Reviewer | 5 wiki-page reviews (O2-4592, TPC-SoT, ITS-SoT cycles 1 & 2, TRD-SoT). Attribution relative to Claude2 pending per architect "I do not know" on 2026-04-19. Option A default applied. | attribution-pending (architect-deferred) |
| **Gemini1** | Gemini — review panel | TPC-SoT review panel (v1 era) | dormant |
| **GPT1 / GPT2 / GPT3** | GPT-series — review panel | TPC-SoT review panel (v1 era) | dormant |
| **(unnamed)** | Main Coder (TRD-SoT source) | TRD-TDR distillation turn 1 | architect-pending identity disclosure |
| Marian Ivanov | Architect / dissertation lead | Project ownership; all architect decisions | active |

**Changes vs v0.3.**

1. **Claude4, Claude6, Claude7, Claude8 ratified active** per architect statement 2026-04-23 on reviewer-ID namespace.
2. **Claude7 added** as Main Reviewer role (new function introduced in Phase 0.1 Module 1; see §9.4).
3. **Claude8 added** as Coder role distinct from Reviewer roles.
4. **Phase 0.1 Module 1 contributions** logged for Claude1–Claude7.
5. **Role types expanded:** Indexer, Reviewer, Coder, Main Reviewer, QuickRef author. Prior versions lumped these under "Reviewer".

## 7. Open work

### 7.1 Indexation sprint (active — start 2026-04-19)

**Working mode** unchanged from v0.3 except where noted:
- Commit pages as DRAFT; no `[OK]` promotion during sprint.
- Optional one-pass review per page (max 3 findings, `[!]` or `[OK]` verdicts) for transcript-index and source-of-truth classes.
- **Software-index class (Phase 0.1 pages)** uses multi-reviewer panel mode per §9; sprint-mode cap does not apply.

**Throughput (per Claude1):** 3–5 pages/day single-reviewer pace for transcript-index / source-of-truth. Software-index pages (Phase 0.1) are ~1 page/week including panel review.

### 7.2 Governance (end-of-sprint batch)

- `MIWikiAI_QuickRef_v1.0.md` — compact authoring + review card. Claude4 authoring. **Newly in scope for QuickRef v1.0 (from Phase 0.1):**
  - Inline-tag grammar (§5.3 of this SUMMARY)
  - `source_inconsistencies:` + `[CONFLICT-N]` conventions
  - Schema A/B variant rule
  - Review process canonical workflow (from §9)
  - Reviewer-ID architect-ratification rule
  - Red-team external-source-fetch rule for Aspect D
  - Changelog-names-finding-IDs convention
- Long-form `MIWikiAI_Reviewer.md` — after QuickRef validates.
- `known_reviewer_limitations.md` — populated with source-URL-fetchability + ID-drift episodes.
- `scripts/inventory.sh` — auto-generate §3 from committed front-matter (Claude1 P2-5).

### 7.3 Cross-page retrofits (end-of-sprint batch)

Unchanged from v0.3 with additions:
- `[computed]` tag convention unification across all pages.
- `source_fingerprint` / `document_version` schema split.
- Mirror `[VERIFY]` entries into front-matter `known_verify_flags`.
- Attribution-footer convention for historical reviews (once §8 item 1 resolves).
- **NEW (Phase 0.1):** retrofit older pages to apply the new tag split `[AD]` → `[TDR]`/`[PP]`/`[CC]` where appropriate.
- **NEW (Phase 0.1):** add `introduction_only:` field to pages that cite O2RecoAI TS v1.3 for context.

### 7.4 End-of-sprint gate (~10 working days from 2026-04-19 — revised to end-of-Phase-0.1-wave for software-index class)

1. Single governance pass: ratify QuickRef.
2. Identity retrofits in one commit.
3. Bidirectional cross-link sync across all pages.
4. TS v0.5 rebuilt from on-disk state via `scripts/inventory.sh`.
5. Revisit §8 items 1 (attribution), 10 (F6 routing) — both architect-deferred.
6. **NEW:** Promote exemplary patterns from §9 to QuickRef if additional panel cycles (on Modules 2–4) confirm they generalize.

### 7.5 Cross-team coordination (new in v0.4)

Contact Organization team to propose cross-team adoption of MIWikiAI-ratified conventions that appear useful beyond MIWikiAI scope. Scheduled: after **2–3 more panel review cycles** produce additional evidence (per architect 2026-04-23). See §10.

## 8. Known limitations and open conventions

Items 1–10 unchanged from v0.3. New and updated:

1. **ClaudeOpus47 attribution.** *Status 2026-04-19: architect-deferred. Revisit at §7.4 gate. Unchanged.*
2. **Reviewer source-URL fetchability.** *Partially addressed by §9.2 red-team external-source-fetch rule for Aspect D. Remaining systemic issue for reviewers without web_fetch access is still architect-deferred.*
3. **`[computed]` tag form.** *Still open. Governance v1.0 (QuickRef) to standardize.*
4. **External-source `[VERIFY]` items as approval blockers.** *Status 2026-04-19: architect-deferred. Unchanged.*
5. **Schema name harmonization.** *Still open. Governance v1.0 (QuickRef).*
6. **Coder QuickRef version pin.** ***v1.28 — architect-ratified 2026-04-19.***
7. **ReviewerID for the formerly-`MIWikiAI` session.** ***CLOSED 2026-04-19.***
8. **Canonical TeamID for review headers.** ***`MIWikiAI` — architect-ratified 2026-04-19.***
9. **Link validation tooling.** *Still open. Recommended first pass: `lychee` + 20-line grep for internal anchors.*
10. **Multi-model diversity (F6).** *Status 2026-04-19: architect-deferred. Unchanged.*
11. **NEW — `source_inconsistencies:` schema field.** ***Architect-ratified 2026-04-23*** for Phase 0.1 v3 as an optional front-matter field. First applied in AliceO2_overview v0.4 (CONFLICT-1/2/3). Structure documented in §5.1. Formal QuickRef entry pending.
12. **NEW — `[CONFLICT-N]` inline marker convention.** ***Architect-ratified 2026-04-23*** for Phase 0.1 v3. Read-only marker pointing to front-matter `source_inconsistencies[N]`. Not a clickable anchor.
13. **NEW — Primary-source tag split `[AD]` → `[TDR]` / `[PP]` / `[CC]`.** ***Architect-ratified 2026-04-23*** for Phase 0.1 v3. Documented in §5.3. Retroactive migration of older pages batched to §7.3.
14. **NEW — Schema A/B variant for software-index pages.** ***Architect-ratified 2026-04-23*** for Phase 0.1 v3. Hub/overview pages (Schema A) may elide `§ Key classes / types / functions`; module pages (Schema B) use the full template. Documented in §5.4.
15. **NEW — `Alice/code/O2/` folder convention.** ***Architect-ratified 2026-04-21*** for Phase 0.1. Subprojects `O2Physics/` and `O2DPG/` reserved for future waves.
16. **NEW — Reviewer-ID incremental-unique convention.** ***Architect-ratified 2026-04-23.*** IDs increment sequentially (Claude1, Claude2, …); IDs within MIWikiAI must be unique. When a reviewer is onboarded, architect assigns the next free ID; reviewers never self-assign. See §9.5 for the identity-persistence rule that operationalizes this.
17. **NEW — Coder revision must include content delta.** Observation from Phase 0.1 Module 1: v0.2 → v0.3 submission was metadata-only and wasted a review round. **Rule:** a revision bump (v0.N → v0.(N+1)) must include at least one body or schema content change addressing reviewer findings. Metadata-only re-submissions require a patch-number bump (v0.N → v0.N.1) with explicit `METADATA_ONLY` label. Flag for QuickRef v1.0.

## 9. Review Process Canonical Workflow (NEW in v0.4)

This section codifies the review process as practiced through Phase 0.1 Module 1 (v0.1 → v0.4 → pending v0.5). The goal is to reduce wall-clock cycle time for Modules 2–4 by making the working pattern explicit.

### 9.1 Review modes

MIWikiAI supports three review modes, selected per page class and stakes:

| Mode | When | Reviewers | Findings cap | Output |
|---|---|---|---|---|
| **Sprint one-pass** | Transcript-index and source-of-truth pages during indexation sprint | 1 (optional) | 3 per reviewer | inline verdict `[!]` / `[OK]` |
| **Cycle review** | Any page needing deeper verification | 1–2 | no cap | per-reviewer report |
| **Multi-reviewer panel** | Software-index pages that are templates for a multi-module wave; any page with physics-critical load-bearing claims | 6–7 on aspect pairs | 3 per reviewer per aspect | 7 per-aspect reports + Main Reviewer synthesis + actionable fix-list |

Sprint one-pass and cycle review modes were already operational in v0.3. Multi-reviewer panel mode is new in Phase 0.1.

### 9.2 Aspect-split panel design

The 7-aspect split operationalized in Phase 0.1 Module 1 covers:

| Aspect | Scope | Primary role |
|---|---|---|
| A — Physics and ALICE context | §1.1 physics claims, data-flow narrative | domain-knowledge verification |
| B — Software architecture | FairMQ / DPL / ALFA / CMake claims | technical-correctness verification |
| C — Repository structure | §3 directory tree, AliceO2Group map, scope boundaries | structure verification |
| D — Primary-source citations | Every `[GH]` / `[DX]` / `[QS]` / `[PP]` / `[TDR]` / `[CC]` tag; verbatim-quote integrity | source fidelity |
| E — Schema and front-matter | PHASE_N §2.1 field compliance; anchor mechanics; tag grammar | schema compliance |
| F — Quantitative closure | Every number; cross-source validation | arithmetic + closure |
| G — Cross-references and external links | §7 cross-ref table; §8 URL tables; `[CONFLICT-N]` round-trip | link integrity |

Each reviewer gets **one Primary aspect and one Secondary aspect**. Secondary re-checks ≥ half of the primary's `[crit]` items.

**Link triple-coverage:** Aspects D, E, G combined give every URL at least three independent reviewer checks.

**Red-team external-source-fetch rule (new in v0.4, arising from Phase 0.1 Module 1 cycle-1):** Aspect D primary **MUST** fetch at least one peer-reviewed source that is NOT currently cited in the wiki body — for example, a sibling peer-reviewed paper in the same field — to guard against primary-source echo-chamber errors. This rule was added after Claude5's Phase 0.1 Module 1 cycle-1 F-new1 catch: Claude5 fetched arXiv:2106.08353 (Kvapil et al., not cited in the wiki) and found that four prior reviewers had independently converged on an incorrect physics framing. Without the external fetch, the panel would have approved the error.

### 9.3 Assignment document (PHASE_N_Review_Module_M template)

The Phase 0.1 Module 1 review-assignment document (`PHASE_0_1_Review_Module_1_AliceO2_Overview.md`) authored by Claude8 established a reusable template:

1. **§1 What every reviewer does** — whole-document read + assigned-aspect deep-validation.
2. **§2 Finding grammar** — P0/P1/P2 severity; `[OK]` / `[!]` / `[X]` / `[X] BLOCKED` verdicts.
3. **§3 Assignment table** — per-reviewer Primary + Secondary aspect.
4. **§4 Per-aspect deep-validation checklists** — with `[crit]` priority markers.
5. **§5 Output format** — per-reviewer report filename, section structure, validation log format.
6. **§6 Time budget** — explicit estimates to prevent runaway review duration.
7. **§7 Reminders** — scope discipline; introduction_only convention; architect-authority scope.
8. **§8 Acceptance gate** — reports routed to architect for synthesis.

Claude8's v0.3 assignment doc is the template. For Modules 2–4 of Phase 0.1, and for any future multi-reviewer panel review, reuse this structure with aspect definitions adjusted to the module at hand.

### 9.4 Main Reviewer role (new)

When a panel produces 6–7 independent reports, a Main Reviewer synthesizes them into a single architect-facing artifact. The Main Reviewer is:

- **A panel member** (not a separate authority). Typically one of the Aspect primaries (D, F, or E) with synthesis skill.
- **Produces two outputs:**
  1. **Review Summary** — convergent findings, disagreements, verdict aggregation.
  2. **Actionable Fix-List** — numbered edits with file:section/anchor, current text, replacement text, severity, finding-ID. This goes directly to the Coder.
- **Does NOT replace reviewer reports.** Raw reports remain on record. The synthesis is a reading aid, not a substitute.

Main Reviewer responsibility was operationalized in Phase 0.1 Module 1 (Claude7 for cycles 1 on v0.3 and v0.4).

### 9.5 Reviewer-ID persistence (new)

Per architect ratification 2026-04-23 (§8 item 16):

1. **Architect assigns ID** when a reviewer session is onboarded. Reviewers never self-assign.
2. **Reviewer echoes assigned ID** in the first line of every review report: `[ClaudeN] [MIWikiAI] [Reviewer] [artifact_id] [verdict]`.
3. **No retroactive relabel** per Option A default (SUMMARY v0.3 §8 item 1): if a reviewer ID drift occurred in prior commits, document the correction in the affected page's changelog; do not rewrite prior artifacts.
4. **ID collisions within MIWikiAI are forbidden.** Cross-team collisions (e.g. another team also using "Claude1") are handled by the `[MIWikiAI]` team token.

### 9.6 Cycle cadence and hygiene

**Observed wall-clock pattern (Phase 0.1 Module 1):**

| Cycle | Scope | Duration |
|---|---|---|
| v0.1 | Coder first draft | 1 author-session |
| Architect rejection | "Too cryptic / AI-for-AI" | 1 turn |
| v0.2 | Coder redraft with human-readable physics context | 1 author-session |
| Cycle-1 on v0.2 | Sparse (1 reviewer's initial findings) | 2 turns |
| v0.3 | Metadata-only re-submission (WASTE — see §8 item 17) | 1 turn |
| Cycle-1 on v0.3 | Full panel, 5 of 7 reports returned | ~3 days in-session |
| Synthesis on v0.3 | Main Reviewer produces 8 CV items + architect-decision list | 1 turn |
| v0.4 | Coder applies CV fixes + adopts new conventions | 1 author-session |
| Cycle-1 on v0.4 | Full panel, 7 of 7 reports returned, 1 substantive mis-framing caught | ~2 days in-session |
| Synthesis on v0.4 + fix-list | Main Reviewer | 1 turn |
| v0.5 (pending) | Coder applies fix-list | 1 author-session |
| Architect gate 1 | — | 1 turn |

**Efficiency lessons for Modules 2–4:**

1. **Skip metadata-only re-submissions.** v0.2 → v0.3 wasted ~1 day. Rule codified in §8 item 17.
2. **Deep-fetching discipline catches real errors.** Claude5's F-new1 on v0.4 saved the architect from ratifying a factually wrong CONFLICT-1 framing.
3. **Architect decisions made during panel save cycles.** Two decisions (tag split, Schema A/B) were made mid-cycle-1 and applied in v0.4 instead of requiring a separate v0.5 for governance. Encourage batching.
4. **Main Reviewer synthesis + actionable fix-list is the Coder's primary input.** Prose synthesis without a fix-list forces the Coder to re-derive the fix, which is error-prone.
5. **Per-module kickoff note** (per Phase 0.1 §3.4) prevents late-stage fanout decisions and schema questions — use for Modules 2–4.

### 9.7 Empirical reviewer-count recommendations

Evidence from Phase 0.1 Module 1 cycles 1 on v0.3 and v0.4:

| Finding class | Reviewers needed |
|---|---|
| URL resolution, tag grammar, schema compliance, cross-reference integrity | 2 (primary + secondary of any aspect) |
| Verbatim quote integrity | 2 |
| Quantitative closure | 3 (Aspect F primary + secondary + at least one external source fetch) |
| **Physics-critical load-bearing claims** | **4+ with at least 1 red-team external fetch outside current citations** |

Rationale for the 4+ requirement: v0.3 cycle-1 had Claude2 (A), Claude4 (F), Claude7 (D) independently concur on a CONFLICT-1 framing that was physically incorrect. None had fetched a peer-reviewed source outside the wiki's current citations. Claude5 on v0.4 broke the echo chamber by fetching arXiv:2106.08353. Without that fetch, the error would have been ratified.

### 9.8 Main Reviewer checklist

When synthesizing 6–7 reviewer reports:

1. **Tally verdicts** into a panel table.
2. **Group findings into Convergent (CV-N)**: same issue independently flagged by ≥ 2 reviewers.
3. **Group findings into New (N-N)**: issues flagged by exactly one reviewer that merit action.
4. **Identify disagreements** — findings where two reviewers concluded differently. Architect-decision items.
5. **Carry forward P2s** — non-blocking items to batch with P1 fixes.
6. **Produce actionable fix-list** (see §9.4). One row per edit. No prose synthesis in the fix-list itself.
7. **Delivery:** one markdown file with Review Summary (PART 1) + Architect Rulings (PART 2) + Actionable Fix-List (PART 3). Store in `reviews/` folder per page.

## 10. Cross-team coordination — Organization message outline (new in v0.4)

**Trigger:** send after 2–3 additional panel cycles (Modules 2, 3, and/or 4 of Phase 0.1) confirm that the Phase 0.1 conventions generalize. Per architect 2026-04-23.

**Scope of the message:** propose Organization-level adoption for cross-team compatibility of:

1. **Artifact class registry** — software-index as a third class beyond source-of-truth and transcript-index.
2. **`source_inconsistencies:` schema field** — for any team indexing primary sources with potential disagreements.
3. **`[CONFLICT-N]` inline marker convention** — cross-team parser compatibility.
4. **Reviewer-ID architect-ratification rule** — prevents cross-team ID namespace collisions.
5. **Red-team external-source-fetch rule** — applies wherever physics claims are indexed.
6. **Review assignment document template** — reusable across teams doing panel reviews.
7. **Three-artifact review-cycle pattern** — Review Request + Panel Reports + Main Reviewer Synthesis + Fix-list.

**NOT proposed for Organization-level adoption** (remains MIWikiAI-internal):
- Specific reviewer IDs (Claude1 … Claude8) — scoped by `[MIWikiAI]` team token.
- Specific page schemas — classes vary per team.
- Sprint-mode and indexation-sprint conventions — MIWikiAI-internal workflow.

## 11. Changelog

- **v0.4 (2026-04-23).** Phase 0.1 Module 1 review-cycle evidence folded in; §9 Review Process Canonical Workflow added; §6 roster expanded with Claude4/6/7/8 active + new role types (Main Reviewer, Coder); §8 items 11–17 added (Phase 0.1 ratifications + coder-revision-delta rule); §5 schema section expanded with new front-matter fields, tag grammar, Schema A/B; §3 inventory updated with software-index class + 4 new pages (O2-6344, ATO-630, O2DistAI-ATO-628, AliceO2_overview); §7.5 cross-team coordination added; §10 Organization message outline added.
- **v0.3 (2026-04-19).** Architect decisions A–E ratified into §8; mechanical fixes from 3 approval reviews; §6 roster split Claude5/Claude6; Claude4 promoted from pending; indexation sprint working mode. *See v0.3 prior_version record.*
- **v0.2 (2026-04-19).** Applied findings from six reviews of v0.1. `[!]` verdicts from Claude1 / Claude5 / Claude5 / Claude4.
- **v0.1 (2026-04-19).** First full-scope Technical_SUMMARY. Multiple reviews at cycle 0.

---

*Compiled by Claude7 (Claude Opus 4.7) on 2026-04-23, cycle 4. Project-scoped. Phase 0.1 Module 1 panel-review evidence from two full cycles (on v0.3 and v0.4) folded in. Architect ratifications 2026-04-23 applied. For authoring and review rules see `MIWikiAI_QuickRef_v1.0.md` once drafted (Claude4 authoring). Seven governance items remain open and batched to end-of-sprint (§7.4) by explicit architect deferral; seven new items ratified in Phase 0.1 (§8 items 11–17). §3 inventory regeneration via `scripts/inventory.sh` still pending.*

*No quota issues observed during compilation.*
