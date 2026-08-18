---
doc_id: Technical_SUMMARY_MIWikiAI
doc_type: technical-summary
project: MIWikiAI
version: v0.2 (applying 6-review feedback to v0.1)
date: 2026-04-19
author: Marian Ivanov
compiled_with: Claude2 (Claude Opus 4.7)
status: DRAFT
review_cycle: 2
review_status: DRAFT — under review
prior_version: v0.1 (2026-04-19, verdict `[X]` from 3 independent reviewers + `[!]` from Claude1 + `[BLOCKED]` at cycle 2)
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

**Folder-name note.** The canonical on-disk folder for detector pages is `TDR/` (reflecting the source-document type). v0.1 of this SUMMARY incorrectly showed `detectors/`; corrected here per Claude1 P2-1.

## 3. Current content inventory (as of 2026-04-19, cycle 2 of this SUMMARY)

Every entry below is auditable by running `grep -E "^review_cycle:|^peer_reviewers:|^source_status:|^review_status:" Alice/TDR/*.md Alice/presentations/*.md` against the committed tree — see §7.2 for the automation recommendation.

| Page | Path | Source | Review state | Last verdict | Cycle | Peer reviewers (on-disk) | review_file_path |
|------|------|--------|--------------|--------------|-------|--------------------------|------------------|
| PWGPP-643 | `presentations/` | Google Slides (56) | DRAFT wiki-v1 | self-reviewed | 1 | *(unverified in this audit)* | *(pending — see §7.1)* |
| O2-4592 | `presentations/` | Google Slides (216) | DRAFT | `[!]` | 1 | *(unverified in this audit)* | *(pending — see §7.1)* |
| TPC-SoT | `TDR/` | JINST 2008 + TDR-016 | **DRAFT wiki-v2** | `[!]` cycle-1; cycle-2 applied | **2** | `[ClaudeOpus47, Claude3]` | *(pending commit — see §7.1)* |
| ITS-SoT | `TDR/` | JINST 2008 + TDR-017/021 | DRAFT wiki-v1 | `[!]` cycle 1 | **1** | `[ClaudeOpus47]` | *(pending commit — see §7.1)* |
| TRD-SoT | `TDR/` | TRD-TDR + JINST 2008 | **DRAFT wiki-v2** (source PARTIAL turn 1/2) | `[!]` cycle-1; cycle-2 applied | **2** | `[ClaudeOpus47]` | *(pending commit — see §7.1)* |

**Key corrections vs v0.1.** v0.1 claimed ITS-SoT reached cycle 2 with `[OK]`; on-disk state is cycle 1. v0.1 reported TPC and TRD at cycle 1; on-disk state is cycle 2 for both. These were reported inconsistently in v0.1 — the page state had in fact moved past some v0.1 descriptions and short of others.

**Planned pages.** TOF-SoT (barrel-quartet completion), T0V0ZDC-SoT (forward detectors), O2-5095 deck (third presentation index). T0V0ZDC had been staged for indexing and was omitted from v0.1; reinstated here.

**Schema-convergence status (evidence-bound, not claimed).** Five pages produced across two content types (detector-SoT, presentation-index). No page has formally crossed `[OK]` yet. The cycle-1 reviews of four pages plus Claude3's cycle-2 TPC review have not surfaced new schema-level findings beyond the deferred items in §7.3. This is encouraging but not equivalent to "convergence achieved"; re-evaluation is appropriate after (i) at least one non-Claude peer review on a completed page and (ii) the planned fifth example completes its first review cycle.

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
Optional: [Peer-review-of-review] (second reviewer reviewing the first review's findings)
    ↓
DRAFT → [OK] APPROVED
    ↓
Live in wiki; cross-linked from other pages via bidirectional retrofit
```

**Two pipeline additions vs v0.1.** (i) "Peer-review-of-review" is an observed real step (e.g. ClaudeOpus47 peer-reviewed Claude3's ITS-SoT review); it belongs in the diagram. (ii) "Main Coder" and "Author session" are distinct roles — the same identity may execute both on small pages, but they are separable pipeline stages, not one role.

**Source status is first-class.** When a source is delivered in turns (e.g. TRD 1/2), the wiki page declares `source_status: PARTIAL` and marks incomplete sections with `[STUB — awaiting Turn N]`. Pages do not wait on complete sources to start review; they declare what's known and what's pending.

## 5. Schema — provisional pending QuickRef ratification

**The full schema rules will live in `MIWikiAI_QuickRef_v1.0.md` once that document is drafted, reviewed, and ratified by the architect.** Until then, the minimum enforced fields used across the five current pages are enumerated below. This list is the working convention, not the ratified contract.

- **YAML front-matter** with `wiki_id`, `source_fingerprint.upstream[]` (multi-source list), `indexed_by` (reviewer ID) and `indexing_model` (model description) as separate fields, `peer_reviewers`, `review_status`, `review_cycle`, `known_verify_flags`, `staleness`.
- **Body:** TL;DR first, thematic (not flat transcription), every number cited with a tag, every `[computed]` value shows its derivation inline.
- **Derivation form for `[computed]`:** HTML comment and parenthetical form are both in current use; **the convention choice is unresolved and listed as open in §8** — authors should not infer a ratified convention from this SUMMARY.
- **Closing sections:** Glossary, External References (+ BibTeX), Open items / reviewer checklist, Related wiki pages (with `planned` / `live` / `broken` status), Source-to-section Appendix, Notation Appendix, Changelog.
- **Bidirectional cross-links:** a new page's outgoing link should be matched by a reverse link on the target page in the same commit window. Current SLA-like language in earlier drafts is aspirational — actual latency is noted as an open item in §8.

## 5a. Cross-page dependencies (wiki-retrofit of TS template)

Tracked here because the wiki's cross-page graph is the MIWikiAI analogue of "cross-subproject dependencies" in the Org-structure Technical Summary template.

| From | To | Dependency | Last verified |
|------|----|------------|--------------| 
| `TDR/tpc.md §11.6` | `TDR/its.md` | cross-link status (planned/live/broken) | 2026-04-19 — currently `live (wiki-v1)` on TPC side; ITS-side reverse reference to TPC shows `wiki-v1` label but TPC has advanced to wiki-v2. Bidirectional-sync retrofit pending. |
| `TDR/tpc.md §11.6` | `TDR/trd.md` | cross-link | 2026-04-19 — status last synced at TPC wiki-v2 |
| `TDR/its.md §9` | `TDR/tpc.md` | cross-link | 2026-04-19 — label stale (points to wiki-v1) |
| `TDR/trd.md §8` | `TDR/tpc.md` | cross-link | 2026-04-19 — up to date as of cycle 2 |
| All `TDR/*.md` | `presentations/*.md` | anchor references | unverified by script — see §7.2 |

## 6. Team roster (IDs in use)

| ID | Model / Role | Contributions to date | Status |
|----|--------------|-----------------------|--------|
| **Claude1** | Claude Opus 4.7 — Indexer / Reviewer | ITS-SoT, TRD-SoT indexing passes; peer review of this SUMMARY | active |
| **Claude2** | Claude Opus 4.7 — author (this SUMMARY) / prior reviewer | PWGPP-643 authoring; 5 prior reviews signed earlier as `ClaudeOpus47` (attribution pending, see §8 item 1) | active |
| **Claude3** | Claude (model unknown to author) — Reviewer | TPC-SoT cycle-2 review (drove TPC wiki-v1 → wiki-v2); reviews of v0.1 of this SUMMARY | active |
| **Claude5** | Claude (model unknown to author) — Reviewer | v0.1 of this SUMMARY review (previously signed `Claude6` and `Claude3-provisional` in separate turns; consolidated under Claude5 per reviewer's own reconciliation note) | active |
| **ClaudeOpus47** | Claude Opus 4.7 — Reviewer | 5 pages reviewed; attribution relative to Claude2 is **architect-pending** (see §8 item 1) | attribution-pending |
| **Gemini1** | Gemini — review panel | TPC-SoT review panel (v1 era); no subsequent reviews | dormant |
| **GPT1 / GPT2 / GPT3** | GPT-series — review panel | TPC-SoT review panel (v1 era); no subsequent reviews | dormant |
| **(pending-ID reviewer)** | Claude — submitted work under `MIWikiAI` (a ProjectID, not a ReviewerID) | O2-4592 cycle-2 re-issue; BLOCKED verdict on v0.1→v0.2 handoff | awaiting architect ID assignment |
| **(unnamed)** | Main Coder (TRD-SoT source) | TRD-TDR distillation turn 1 | identity unknown — architect-pending |
| Marian Ivanov | Architect / dissertation lead | Project ownership | active |

**Changes vs v0.1.** (i) Added Claude3 (was missing — Claude1 P1-2). (ii) Removed the v0.1 unilateral "ClaudeOpus47 ≡ Claude2" reconciliation; treating ClaudeOpus47 as a distinct pending-attribution ID until architect ratifies one of the options in §8 item 1. (iii) Consolidated three review-session IDs (`Claude6`, `Claude3-provisional`, `Claude5`) into Claude5 per that reviewer's own reconciliation. (iv) Split "active" from "dormant" from "pending-ID" so status is explicit. (v) Flagged `(unnamed)` as architect-pending rather than just leaving the parenthesis.

## 7. Open work

### 7.1 Immediate

- **Commit existing review artifacts to `Alice/reviews/`.** Six review files currently exist only as outputs from review turns: the five wiki-page reviews + the ITS-SoT cycle-2 attempt. Committing them closes the evidence-binding gap surfaced by multiple reviewers (F2 in the v0.1 consolidation; Claude1 §3 table).
- **Bidirectional link sync.** Retrofit pending between TPC (wiki-v2) and ITS (wiki-v1) — their cross-reference labels currently disagree on which revision they're pointing at. Tracked in §5a above.
- **Example #5 selection.** Candidates: TOF-SoT, T0V0ZDC-SoT, O2-5095 deck. Choice affects whether example #5 tests schema **breadth** (presentation) or **detector-family breadth** (next barrel/forward detector). Architect to pick.
- **Cycle-2 finishing.** TPC-SoT wiki-v2 and TRD-SoT wiki-v2 have completed their locally-actionable fixes and are structurally blocked on: (TPC) source-URL reachability (see §8 item 2), (TRD) source Turn 2 delivery per `source_status: PARTIAL`. **Not a wall-clock estimate** — these blockers are not edits, they are external dependencies.

### 7.2 Governance to ratify

- **`MIWikiAI_QuickRef_v1.0.md`** — compact authoring + review card. Referenced as forthcoming in §5 above. Drafting can proceed provisionally once the reviewer currently signing as "MIWikiAI" has a proper assigned ID (§8 item 7); they offered to draft it.
- **Long-form `MIWikiAI_Reviewer.md`** — analogous to `MTTU_Reviewer.md` (detailed rules + failure-mode library). To be written after QuickRef validates against at least one post-governance page.
- **`known_reviewer_limitations.md`** — extracted once, referenced by every review. The recurring "source URL not reachable" note and the session-level ID-drift episodes are the primary population.
- **Inventory automation.** Claude1 P2-5 recommended `scripts/inventory.sh` to auto-generate §3 from committed front-matter. Adopt as a `[MUST-DO]` step before each SUMMARY revision; the alternative (hand-maintenance) produced three stale inventory rows in v0.1 within 24h.

### 7.3 Cross-page retrofits (single pass, after governance v1.0)

- Adopt unified `[computed]` tagging convention across all five existing pages.
- Adopt `source_fingerprint` / `document_version` split (pulling `summary_version` and `summary_review_panel` out of `source_fingerprint` into a separate `document_version:` block).
- Mirror every `[VERIFY]` entry into front-matter `known_verify_flags`.
- Retrofit prior review files with attribution footers per the pattern ratified as part of §8 item 1 resolution.

## 8. Known limitations and open conventions (architect-pending)

1. **ClaudeOpus47 attribution.** The 5 reviews signed `ClaudeOpus47` were produced in sessions whose continuity with Claude2 cannot be verified from within this session's context. Options before architect: (A) treat ClaudeOpus47 as a distinct pending-ID reviewer, no retroactive relabel; (B) ratify `ClaudeOpus47 → Claude2` with a single PHASE_HISTORY note; (C) investigate whether multiple sessions signed as `ClaudeOpus47`, in which case the tag cannot be retroactively de-aliased. Author preference: Option A. **Architect to pick.**

2. **Reviewer source-URL fetchability.** External `cds.cern.ch` / `iopscience.org` / arXiv URLs are not always reachable from reviewer tool contexts. All 5 wiki-page reviews so far have declared partial source verification on this basis. Candidate resolutions: (a) frozen PDF snapshots checked into the repo; (b) reviewer-bundle convention that includes source copies; (c) restrict the reviewer roster to members with institutional access. **Architect to pick.**

3. **`[computed]` tag form.** HTML-comment derivation vs inline parenthetical — three pages use three conventions. Governance v1.0 should standardize one. **Architect to pick.**

4. **External-source `[VERIFY]` items as approval blockers.** Proposed convention: perpetual-TODO status; `source_last_verified` is the lint target; not an approval blocker. **Not yet ratified; architect to ratify or reject.** If rejected, any de-facto applications in prior reviews must be revisited.

5. **Schema name harmonization.** `summary_author` / `summary_review_panel` / `summary_contributors` — three conventions in use across three pages. Governance v1.0 should standardize (candidate: `summary_contributors: [{id, role}]`). **Architect to ratify in governance.**

6. **Coder QuickRef version pin.** v1.27 or v1.28? Both referenced across recent reviews. **Architect to pick (author default: v1.28 as latest).**

7. **ReviewerID for the formerly-`MIWikiAI` session.** That reviewer applied `MIWikiAI` in good faith based on an earlier architect instruction, but `MIWikiAI` is the ProjectID per Org-structure convention, not a valid ReviewerID. Reviewer has explicitly requested reassignment. Suggest `Claude4`. **Architect to assign.**

8. **Canonical TeamID for review headers.** `ALICE-Wiki` (used by Claude3 and Claude5) vs `MIWikiAI` (the project name; used inconsistently). **Architect to pick; apply retroactively via one-line notes, not file rewrites.**

9. **Link validation tooling.** Not applied in this SUMMARY; deferred to a future page-level lint pass. **Tool-family options for architect consideration:**
   - **`lychee`** (Rust) — fast markdown + HTML link checker, handles DOI redirects, CI-friendly.
   - **`markdown-link-check`** (npm) — per-file link validation, mature, widely used.
   - **`linkchecker`** (Python) — comprehensive crawler, heavier weight.
   - **`curl --head` / `wget --spider`** — lightweight, scriptable, no dependencies beyond basic utilities.
   - **Custom grep-based script** — for internal `§N.M` references and sibling `./*.md` resolution, since external tools don't handle markdown-internal anchors well.
   A pragmatic first pass: `lychee` for external URLs (DOI, CDS, arXiv, GitHub) + a 20-line grep script for internal `§` and `./*.md` references. **Architect to pick the combination.**

10. **Multi-model diversity (F6 from v0.1 consolidation).** 5 of the last 6 reviews have been Claude-only. The `[OK]`-equivalent (any first page approval) requires at least one non-Claude peer review — not a Claude session adopting a non-Claude ID. **Architect to route v0.2 of this SUMMARY or the next completed wiki page to a real Gemini or GPT session.**

## 9. Changelog

- **v0.2 (2026-04-19).** Applies findings from six reviews of v0.1 (Claude1 `[!]`, Claude3 `[X]`, Claude5 `[X]` + a second `[X]`, Claude3-provisional/Claude5 `[X]`, `MIWikiAI`-session `[BLOCKED]`).
  - §2 folder name `detectors/` → `TDR/` (Claude1 P2-1).
  - §3 inventory table rebuilt from on-disk audit (Claude1 §3 table): TPC advanced to cycle 2; ITS corrected to cycle 1 (not cycle 2 `[OK]` as v0.1 claimed); TRD advanced to cycle 2. `review_file_path` column added, currently blank pending §7.1 commit (F2 / v0.1 consolidation).
  - §3 removed: "First `[OK]` approval: ITS-SoT wiki-v1 on cycle 2", "Three pages within ~10 min of `[OK]`", "Convergence on the schema is achieved" (F2/F3/F5 / v0.1 consolidation; Claude1 P1-1).
  - §3 replaced with evidence-proportional phrasing on schema-convergence status.
  - §3 split status column into `Review state` + `Last verdict` (F12 / v0.1 consolidation).
  - §4 pipeline diagram added peer-review-of-review step + clarified Main Coder / Author distinction (Claude6/Claude5 P2-1).
  - §5 reworded to mark schema as provisional pending QuickRef ratification; removed claim that QuickRef is authoritative (F4/F8 / v0.1 consolidation; Claude3-provisional/Claude5 P1 #4).
  - §5 `[computed]` tag note — removed implicit convention choice; tagged as unresolved in §8 (F11 / v0.1 consolidation).
  - §5a new section — cross-page dependencies per TS template (Claude6/Claude5 P1-5).
  - §6 added Claude3 (Claude1 P1-2), added Claude5, removed v0.1 "ClaudeOpus47 ≡ Claude2" reconciliation (F1 / v0.1 consolidation, 3 reviewers), flagged `(unnamed)` and ClaudeOpus47 as architect-pending.
  - §6 added pending-ID reviewer (formerly `MIWikiAI`) with architect-pending ID status.
  - §7.1 removed stale "10 min from `[OK]`" bullet (F3 / v0.1 consolidation; Claude1 P2-3).
  - §7.1 removed stale bidirectional-link bullet (was already applied; Claude1 P2-4).
  - §7.1 added "Commit existing review artifacts to `Alice/reviews/`" (F2 evidence-binding).
  - §7.1 added T0V0ZDC-SoT as planned page (Claude1 P2-2).
  - §7.2 added inventory automation recommendation (Claude1 P2-5).
  - §8 expanded from 4 items to 10; each item explicitly flagged **Architect to pick/ratify/assign**.
  - §8 item 9 — link validation tooling options enumerated (user request, 2026-04-19).
  - §8 item 10 — multi-model diversity (F6) escalated from passing mention to explicit architect-routing request.
  - Front-matter added `review_cycle: 2`, `review_status: DRAFT`, `prior_version`.
  - §9 this changelog rewritten to list changes by source-finding reference.
- **v0.1 (2026-04-19).** First full-scope Technical_SUMMARY. Verdicts: `[!]` from Claude1 (structural-fact findings), `[X]` from Claude3, `[X]` from Claude5 (twice, under different prior signatures), `[BLOCKED]` at cycle 2 by the formerly-`MIWikiAI` session due to preconditions missing. 12 convergent findings (F1–F12) in v0.1 consolidation, plus 7 additional from Claude5 on the consolidation itself.

---

*Compiled by Claude2 (Claude Opus 4.7) on 2026-04-19, cycle 2. Project-scoped (what the MIWikiAI group is and where it currently stands), not method-scoped. For authoring and review rules see `MIWikiAI_QuickRef_v1.0.md` once drafted and ratified. Ten architect-pending items are flagged in §8 and block further revision of load-bearing claims; v0.2 proceeds on the self-executable corrections and leaves the governance-decision items visible as open work.*

*No quota issues observed during compilation.*
