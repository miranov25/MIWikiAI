---
doc_id: Technical_SUMMARY_MIWikiAI
doc_type: technical-summary
project: MIWikiAI
version: v0.3 (architect A–E decisions ratified into §8; mechanical fixes from 3 approval reviews)
date: 2026-04-19
author: Marian Ivanov
compiled_with: Claude2 (Claude Opus 4.7)
status: DRAFT — architect-approved for indexation
review_cycle: 3
review_status: APPROVED FOR INDEXATION (3 × `[!]` verdicts, zero P0, zero substantive P1)
prior_version: v0.2 (2026-04-19) — `[!]` APPROVED WITH COMMENTS from 3 reviews (2 distinct reviewer sessions: Claude3, Claude5, plus Claude4 re-review post-ID-assignment)
architect_ratifications_2026_04_19: [A=Option-A-default, B=deferred, C=override-F6-routing, D=CoderQRC-v1.28, E=TeamID-MIWikiAI, item-7=Claude4-assigned]
---

# MIWikiAI — Technical SUMMARY

## 1. What MIWikiAI is

A group producing **AI-queryable wiki pages** distilled from ALICE physics sources (TDRs, JINST papers, presentations, code modules, articles). Every page is a **Karpathy-style compiled knowledge document** — thematic, sourced, machine-readable — intended to be fed directly to LLMs as a trusted knowledge base, replacing RAG over raw PDFs.

Distinct from RAG: RAG retrieves chunks from unstructured sources at query time. MIWikiAI compiles once; the entire wiki fits into a model context (target: Claude Opus 4.x, Sonnet 4.6, Gemini 2.5, GPT-5 class; current five pages total ~300 kB of markdown) and answers questions by reading, not retrieval.

## 2. Repository layout

```
MIWikiAI/Alice/
├── presentations/        # indexed from Google Slides / conference decks
├── TDR/                  # Source-of-Truth pages per ALICE subdetector
│                         #   (canonical folder name on disk; an eventual rename
│                         #    to `detectors/` is under consideration but not applied)
├── code/                 # reusable modules (e.g. quantile_fit_nd)
├── documents/            # papers, JIRA tickets, arXiv refs
├── articles/             # articles consumed / produced
├── reviews/              # peer-review artifacts per page (see §3 and §7.1)
└── Technical_SUMMARY_MIWikiAI.md   # this file
```

## 3. Current content inventory (as of 2026-04-19, cycle 3 of this SUMMARY)

Every entry below is auditable by running `grep -E "^review_cycle:|^peer_reviewers:|^source_status:|^review_status:" Alice/TDR/*.md Alice/presentations/*.md` against the committed tree — see §7.2 for the automation recommendation.

ClaudeOpus47¹ entries below carry attribution-pending status per §8 item 1.

| Page | Path | Source | Review state | Last verdict | Cycle | Peer reviewers (on-disk) | review_file_path |
|------|------|--------|--------------|--------------|-------|--------------------------|------------------|
| PWGPP-643 | `presentations/` | Google Slides (56) | DRAFT wiki-v1 | self-reviewed | 1 | *(unverified in this audit)* | *(pending — see §7.1)* |
| O2-4592 | `presentations/` | Google Slides (216) | DRAFT | `[!]` | 1 | *(unverified in this audit)* | *(pending — see §7.1)* |
| TPC-SoT | `TDR/` | JINST 2008 + TDR-016 | **DRAFT wiki-v2** | `[!]` cycle-1; cycle-2 applied | **2** | `[ClaudeOpus47¹, Claude3]` | *(pending commit — see §7.1)* |
| ITS-SoT | `TDR/` | JINST 2008 + TDR-017/021 | DRAFT wiki-v1 | `[!]` cycle 1 | **1** | `[ClaudeOpus47¹]` | *(pending commit — see §7.1)* |
| TRD-SoT | `TDR/` | TRD-TDR + JINST 2008 | **DRAFT wiki-v2** (source PARTIAL turn 1/2) | `[!]` cycle-1; cycle-2 applied | **2** | `[ClaudeOpus47¹]` | *(pending commit — see §7.1)* |

¹ `ClaudeOpus47` attribution is pending architect ratification; see §8 item 1. Treat as distinct pending-attribution reviewer ID per Option A default.

**Planned pages.** TOF-SoT, T0V0ZDC-SoT, O2-5095 deck. Sequence at architect discretion. Indexation run starting 2026-04-19 will extend this list.

**Schema-convergence status (evidence-bound).** Five pages produced across two content types. No page has formally crossed `[OK]` yet. Cycle-1 reviews of four pages plus Claude3's cycle-2 TPC review have not surfaced new schema-level findings beyond the items deferred in §7.3. Re-evaluation of convergence appropriate after (i) at least one additional cycle reaches `[OK]` (deferred per architect B = documents not priority now), (ii) the indexation sprint produces 5+ additional pages against the current exemplars without schema-level drift.

## 4. Pipeline

```
Source (PDF / slides / code / article)
    ↓
[Main Coder — distillation into source_of_truth markdown]
    ↓
[Author session (Claude / GPT / Gemini) — conversion to MIWikiAI schema]
    ↓
[Peer reviewer session] ←→ author response + revisions (cycle 0 → N)
    ↓
Optional: [Peer-review-of-review]
    ↓
DRAFT → [OK] APPROVED  (deferred during indexation sprint per architect)
    ↓
Live in wiki; cross-linked from other pages via bidirectional retrofit
```

**Indexation-sprint mode (active 2026-04-19).** During the current sprint, pages commit as DRAFT with optional one-pass review (max 3 findings, `[!]` or `[OK]` verdicts only). Promotion to `[OK]` formal status is batched to end-of-sprint. Cross-page link sync, review-artifact commits, and governance ratification also batch to end-of-sprint. See §7.4.

**Source status is first-class.** When a source is delivered in turns (e.g. TRD 1/2), the page declares `source_status: PARTIAL` and marks incomplete sections `[STUB — awaiting Turn N]`. Pages do not wait on complete sources to start review.

## 5. Schema — provisional pending QuickRef ratification (batched to end-of-sprint)

The full schema rules will live in `MIWikiAI_QuickRef_v1.0.md` once drafted, reviewed, and ratified by the architect. Until then, the minimum enforced fields used across the five current pages (TPC-SoT / ITS-SoT / TRD-SoT / O2-4592 / PWGPP-643 as exemplars) are:

- **YAML front-matter** with `wiki_id`, `source_fingerprint.upstream[]` (multi-source list), `indexed_by` (reviewer ID) and `indexing_model` (model description) as separate fields, `peer_reviewers`, `review_status`, `review_cycle`, `known_verify_flags`, `staleness`.
- **Body:** TL;DR first, thematic (not flat transcription), every number cited with a tag, every `[computed]` value shows its derivation inline.
- **Derivation form for `[computed]`:** HTML-comment and inline-parenthetical forms both in current use; convention choice tagged as open in §8 item 3.
- **Closing sections:** Glossary, External References (+ BibTeX), Open items / reviewer checklist, Related wiki pages, Source-to-section Appendix, Notation Appendix, Changelog.
- **Bidirectional cross-links:** desired in-commit, batched to end-of-sprint per §7.4.

## 5a. Cross-page dependencies (TS-template retrofit)

| From | To | Dependency | Last verified |
|------|----|------------|--------------| 
| `TDR/tpc.md §11.6` | `TDR/its.md` | cross-link status | 2026-04-19 — label stale (sync batched to §7.4) |
| `TDR/tpc.md §11.6` | `TDR/trd.md` | cross-link | 2026-04-19 — up to date at cycle 2 |
| `TDR/its.md §9` | `TDR/tpc.md` | cross-link | 2026-04-19 — label stale (sync batched) |
| `TDR/trd.md §8` | `TDR/tpc.md` | cross-link | 2026-04-19 — up to date at cycle 2 |
| All `TDR/*.md` | `presentations/*.md` | anchor references | unverified by script — §7.2 |

## 6. Team roster (IDs in use)

| ID | Model / Role | Contributions to date | Status |
|----|--------------|-----------------------|--------|
| **Claude1** | Claude Opus 4.7 — Indexer / Reviewer | ITS-SoT, TRD-SoT indexing passes; `[!]` review of v0.1 of this SUMMARY | active |
| **Claude2** | Claude Opus 4.7 — author (this SUMMARY) / prior reviewer | PWGPP-643 authoring; 5 prior reviews signed as `ClaudeOpus47¹` | active |
| **Claude3** | Claude (model per architect record) — Reviewer | TPC-SoT cycle-2 review (drove TPC wiki-v1 → wiki-v2); `[X]` on v0.1 of this SUMMARY | active |
| **Claude4** | Claude (model per architect record) — Reviewer | O2-4592 cycle-2 re-issue; `[BLOCKED]` on v0.1→v0.2 preconditions; `[!]` on v0.2 post-architect-decisions. Previously signed `MIWikiAI` before the 2026-04-19 "proper numbers" ratification. | active (ID ratified by architect 2026-04-19) |
| **Claude5** | Claude (model per architect record) — Reviewer | `[X]` reviews on v0.1 of this SUMMARY and on the v0.1 consolidation document; `[!]` on v0.2. Previously signed `Claude3-provisional`; consolidated to Claude5 per reviewer's own reconciliation. | active |
| **Claude6** | Claude (model per architect record) — Reviewer | `[X]` review on v0.1 of this SUMMARY (governance-heavy, distinct from Claude5's `[X]` on v0.1 per finding-count evidence) | active |
| **ClaudeOpus47¹** | Claude Opus 4.7 — Reviewer | 5 wiki-page reviews (O2-4592, TPC-SoT, ITS-SoT cycles 1 & 2, TRD-SoT). Attribution relative to Claude2 is pending per architect "I do not know" on 2026-04-19. Option A default applied: distinct pending-attribution ID, no retroactive relabel. | attribution-pending (architect-deferred) |
| **Gemini1** | Gemini — review panel | TPC-SoT review panel (v1 era) | dormant |
| **GPT1 / GPT2 / GPT3** | GPT-series — review panel | TPC-SoT review panel (v1 era) | dormant |
| **(unnamed)** | Main Coder (TRD-SoT source) | TRD-TDR distillation turn 1 | architect-pending identity disclosure |
| Marian Ivanov | Architect / dissertation lead | Project ownership; architect decisions A–E on 2026-04-19 | active |

**Changes vs v0.2.** (i) Split Claude5 and Claude6 as distinct reviewers per Claude5 P1-1 (finding-count evidence: Claude6 had 6 P1/6 P2; Claude5 had 7 P1/7 P2; different sessions). (ii) Promoted formerly-`MIWikiAI` reviewer to `Claude4` per architect "proper numbers" ratification; closed §8 item 7. (iii) All "architect-pending" flags that architect actually decided are updated to their ratified state.

## 7. Open work

### 7.1 Indexation sprint (active — start 2026-04-19)

**Working mode per architect instructions** (A–E of 2026-04-19):
- Commit pages as DRAFT; no `[OK]` promotion during sprint.
- Optional one-pass review per page (Claude-only acceptable per architect C override of F6); max 3 findings per review, `[!]` or `[OK]` verdicts only.
- Review files for prior 5 pages commit **with signatures intact** (no retroactive relabel per architect A = Option A default — Claude5 C5 guidance). Commit-message should reference §8 item 1.
- QuickRef drafting can proceed in parallel (Claude4 to draft per their earlier offer); authorship ID already ratified (Claude4).

**Per-page workflow (from Claude1 operational guidance, condensed):**
1. Pick source; choose exemplar (presentation → match O2-4592; detector SoT → match TPC-SoT / ITS-SoT).
2. New author session; produce DRAFT.
3. Commit to `presentations/<slug>.md` or `TDR/<slug>.md` with required front-matter.
4. Optional review pass (max 3 findings).
5. Apply cheap fixes → wiki-v1; next presentation.

**Throughput target (per Claude1):** 3–5 pages / day single-reviewer pace.

### 7.2 Governance (end-of-sprint batch)

- `MIWikiAI_QuickRef_v1.0.md` — compact authoring + review card. Drafting can proceed now (decoupled from ID-assignment per Claude4 V-T4); authorship ID = Claude4 per ratification.
- Long-form `MIWikiAI_Reviewer.md` — after QuickRef validates.
- `known_reviewer_limitations.md` — populated with source-URL-fetchability + ID-drift episodes.
- `scripts/inventory.sh` — auto-generate §3 from committed front-matter (Claude1 P2-5).

### 7.3 Cross-page retrofits (end-of-sprint batch)

- `[computed]` tag convention unification across all pages.
- `source_fingerprint` / `document_version` schema split.
- Mirror `[VERIFY]` entries into front-matter `known_verify_flags`.
- Attribution-footer convention for historical reviews (once §8 item 1 resolves).

### 7.4 End-of-sprint gate (~10 working days from 2026-04-19)

1. Single governance pass: ratify QuickRef.
2. Identity retrofits in one commit.
3. Bidirectional cross-link sync across all pages.
4. TS v0.4 rebuilt from on-disk state via `scripts/inventory.sh`.
5. Revisit §8 items 1 (attribution), 10 (F6 routing) — both architect-deferred with sprint-length scope.

## 8. Known limitations and open conventions

1. **ClaudeOpus47 attribution.** *Status 2026-04-19: architect consulted; decision deferred ("I do not know"). ClaudeOpus47 remains a distinct pending-attribution ID. No retroactive relabel. Revisit at §7.4 gate.* (Claude5 C3)
2. **Reviewer source-URL fetchability.** Candidate resolutions: (a) frozen PDF snapshots in repo; (b) reviewer-bundle with source copies; (c) institutional-access reviewer roster. Architect-deferred; revisit at §7.4 gate.
3. **`[computed]` tag form.** HTML-comment vs inline parenthetical. Governance v1.0 (QuickRef) to standardize.
4. **External-source `[VERIFY]` items as approval blockers.** *Status 2026-04-19: deferred per architect B ("do not care about documents now").* Revisit at §7.4 gate.
5. **Schema name harmonization** (`summary_author` / `summary_review_panel` / `summary_contributors`). Governance v1.0 (QuickRef) to standardize.
6. **Coder QuickRef version pin.** ***v1.28 — architect-ratified 2026-04-19.***
7. **ReviewerID for the formerly-`MIWikiAI` session.** ***CLOSED 2026-04-19: assigned `Claude4` per architect "proper numbers" ratification.*** Claude4 now active in §6 roster.
8. **Canonical TeamID for review headers.** ***`MIWikiAI` — architect-ratified 2026-04-19.*** Retroactive correction of prior `[ALICE-Wiki]` headers not required; future reviews use `[MIWikiAI]`.
9. **Link validation tooling.** Options for end-of-sprint decision:
   - `lychee` (Rust) — fast markdown + HTML link checker, handles DOI redirects, CI-friendly.
   - `markdown-link-check` (npm) — per-file validation, mature, widely used.
   - `linkchecker` (Python) — comprehensive crawler, heavier weight.
   - `curl --head` / `wget --spider` — lightweight, scriptable.
   - Custom grep-based script — for internal `§N.M` references and sibling `./*.md` resolution.
   Pragmatic first pass: `lychee` + 20-line grep for internal anchors.
10. **Multi-model diversity (F6).** *Status 2026-04-19: deferred per architect C ("ignore him; proper numbers"). Claude-only review during sprint is acceptable. Watch-item (Claude5 C4): every new Claude-authored page raises the Claude-only ratio. Minimum proposal for sprint: route one page to an actual Gemini or GPT session at any time; not blocking.* Revisit at §7.4 gate.

## 9. Changelog

- **v0.3 (2026-04-19).** Folds architect decisions A–E of 2026-04-19 into §8 + applies mechanical fixes from three approval reviews (Claude5 `[!]`, Claude5 `[!]` on consolidation, Claude4 `[!]` post-ID-assignment). Zero substantive P1s remaining.
  - §8 items 1, 4, 6, 8, 10 marked with architect ratification dates and outcomes (Claude4 V-T1; Claude5 C1/C2/C3).
  - §8 item 7 CLOSED — Claude4 assigned per architect "proper numbers" (resolves formerly-`MIWikiAI` ID ambiguity).
  - §6 roster: split Claude5 from Claude6 as distinct reviewers (Claude5 P1-1 — finding-count evidence). Promoted Claude4 from pending-ID to active.
  - §3: footnote marker `¹` on `ClaudeOpus47` entries pointing to §8 item 1 (Claude5 P1-2).
  - Front-matter `prior_version` clarified to "2 distinct reviewer sessions" (Claude4 V-T2).
  - §7.1 added explicit commit-message guidance for historical reviews per Claude5 C5 (signatures intact, reference §8 item 1).
  - §7.2 decoupled QuickRef drafting from ID resolution (Claude4 V-T4).
  - §7.1 reorganized into indexation-sprint working mode per Claude1 operational guidance + architect D/E ratifications.
  - §7.4 added end-of-sprint gate explicitly.
  - Front-matter adds `architect_ratifications_2026_04_19` field — session-loss-resilient record of decisions (Claude4 V-T2 / Claude5 session-loss note).
  - `review_status: APPROVED FOR INDEXATION` promoted in front-matter.
- **v0.2 (2026-04-19).** Applied findings from six reviews of v0.1. `[!]` verdicts from Claude1 / Claude5 / Claude5 / Claude4 on the revision; architect decisions A–E recorded in this thread arrived post-compilation of v0.2 and motivated v0.3.
- **v0.1 (2026-04-19).** First full-scope Technical_SUMMARY. `[!]` from Claude1, `[X]` from Claude3, `[X]` from Claude5 (previously signed Claude3-provisional), `[X]` from Claude6, `[BLOCKED]` at cycle 2 by formerly-`MIWikiAI` (now Claude4).

---

*Compiled by Claude2 (Claude Opus 4.7) on 2026-04-19, cycle 3. Project-scoped. Architect decisions A–E ratified into §8 on 2026-04-19; indexation sprint active from same date. For authoring and review rules see `MIWikiAI_QuickRef_v1.0.md` once drafted (Claude4 authoring). Five governance items remain open and batched to end-of-sprint (§7.4) by explicit architect deferral. §3 inventory will be regenerated automatically in v0.4 via `scripts/inventory.sh` once available.*

*No quota issues observed during compilation.*
