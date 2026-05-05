---
doc_id: MIWikiAI_Quick_Reference_Card
doc_type: team-quick-reference-card
project: MIWikiAI
version: v0.5.6 (2026-05-05 evening)
status: DRAFT — refines v0.5.5 §§4.11-4.16 per 3-Opus approval synthesis (Claude1+Claude2+Claude10); 7 non-blocking amendments + new §4.0 unifying principle; awaits architect ratification
companion_doc: ./Technical_SUMMARY_MIWikiAI_v0_5_5.md  # v0.5.5 companion still binds; v0.5.6 changes are clarifications only
inherits_from:
  - Organization-structure-v1_27.md (general 16-team contract)
  - MTTU_Reviewer-v1_22.md (reviewer mechanics, all teams)
  - Coder_Quick_Reference_Card_v1_28.md (coder mechanics, all teams)
  - Reviewer_Quick_Reference_Card_v1_29.md (reviewer mechanics, all teams; Rule 13 covers Main Reviewer synthesis)
  - Main_Reviewer_Quick_Reference_Card.md (Main Reviewer mechanics — Coverage Matrix, finding traceability, raw-input retention; new in 2026-05-01)
scope: MIWikiAI-specific deltas only — wiki authoring, advisor consumption, label vocabulary, section-ownership review model
audience:
  - MIWikiAI Coders (Claude8, Claude9, future)
  - MIWikiAI Reviewers (pool: Claude1-2 Opus for judgment-heavy sections; Sonnet1-6 + Gemini1-6 for mechanical sections — section assignments per cycle, see §4.7 + §4.8)
  - MIWikiAI Main Reviewer (Opus; rotates per architect direction; cycle-3 forward NOT Claude7, NOT Claude1)
  - MIWikiAI Advisors (any AI agent consuming MIWikiAI pages to answer queries)
  - Architect (ratification authority)
date: 2026-05-03
prior_version: v0.5.3 (2026-05-03 morning) — superseded by v0.5.4 same-day after Claude1 advisory feedback
revision_note: "v0.5.4 supersedes v0.5.3 same day after Claude1 (Aspect A primary, advisory) feedback on the dimension-only assignment model. Three additive sections + one §4.7 update: §4.7 reframed to three-dimensional assignment (reviewer × section × aspect); §4.8 NEW — 2+2+1 deep section coverage rule (2 Sonnet + 2 Gemini + 1 Opus per artifact section, every reviewer reads full document but deep-validates owned sections); §4.9 NEW — convergence handling rule for divergent section-owner findings (3-of-5 elevates; 2-of-5 with Opus dissent → UNCERTAIN deferred to architect); §4.10 NEW — sprint finding cap lifted to 5 for cycle-3 to accommodate multi-section ownership. Origin: 2026-05-03 architect direction after observing Sonnet/Gemini individual unreliability on judgment tasks; redundant deep coverage as structural defense (same governance pattern as Main Reviewer truncation rule, applied at section level). No semantic changes to v0.5.3 §2.7, §3, §4.5, §4.6 rules; this is purely additive plus §4.7 reframing."
---

# MIWikiAI Quick Reference Card v0.5

Binding rules for the MIWikiAI team. Inherits cross-team rules from Organization-structure, MTTU_Reviewer, and the general Coder/Reviewer QRCs. **Specifies only the MIWikiAI deltas.** When this document and a general document conflict, the general document wins on cross-cutting concerns (identity persistence, anti-fabrication, reviewer rotation); this document wins on MIWikiAI-specific concerns (wiki authoring, advisor consumption, label vocabulary).

For the full motivation, schema history, team roster, and pipeline narrative, see `Technical_SUMMARY_MIWikiAI_v0_5_4.md`. This card is the binding distillation.

---

## 1. Scope and inheritance

**MIWikiAI is one of 16 teams in the project.** It produces AI-queryable wiki pages distilled from ALICE physics sources (TDRs, JINST papers, presentations, code modules, articles), and is responsible for the AI advisor that consumes those pages.

**Inherited from general docs (apply unchanged):**

| Concern | Source | Notes |
|---|---|---|
| Reviewer ID persistence | Organization-structure §Identity Persistence | Each reviewer's assigned ID (e.g. `Claude9` for Coder, `Claude7` for Main Reviewer) appears verbatim in all reports. Drift to model-version strings is a P0 violation. |
| Verdict grammar | MTTU_Reviewer v1.22 | `[OK]` / `[!]` / `[X]` / `[?]`; `[X] BLOCKED — REVIEW NOT POSSIBLE: <reason>` for missing preconditions OR (NEW v1.22) for incomplete synthesis |
| Six-section reviewer report template | MTTU_Reviewer v1.22 | whole-doc / primary aspect / secondary aspect / validation log / summary / red-team disposition |
| Sprint mode | MTTU_Reviewer v1.22 | max 3 findings per reviewer in sprint cycles, `[!]` or `[OK]` only |
| Anti-fabrication baseline | Coder_QRC v1.28 | every claim traceable to a source |
| P0/P1/P2 grading | MTTU_Reviewer v1.22 | P0 = blocking, P1 = significant, P2 = advisory |
| **Main Reviewer synthesis discipline** (NEW 2026-05-01) | **Main_Reviewer_Quick_Reference_Card.md + Reviewer_QRC v1.29 Rule 13** | **Coverage Matrix MUST begin every summary; every reviewer cited; every submitted finding mapped to output status; raw inputs retained or linked. Codified after MIWikiAI cycle-1 truncation incident (Common_utilities_API v0.1: 3 of 9 reviewers cited).** |

**Specified here (MIWikiAI-specific):**

§2 wiki authoring layer. §3 label vocabulary. §4 reviewer specifics for MIWikiAI artifacts. §5 advisor team rules.

---

## 2. Wiki authoring layer

### 2.1 Three artifact classes

| Class | Purpose | Examples |
|---|---|---|
| `source-of-truth` | indexes a TDR / JINST paper | `TPC_SourceOfTruth.md`, `ITS_SourceOfTruth.md`, `TRD_source_of_truth.md` |
| `transcript-index` | indexes a presentation / deck | `O2-6344_materialbudget*.md`, `ATO-630_*.md` |
| `software-index` | indexes a code repository module | `AliceO2_overview.md`, `Common_utilities.md`, `Framework_DPL.md`, `DataFormats_Reconstruction.md` |

### 2.2 Two-file pattern for software-index pages (NEW v0.5)

Every software-index page has two files when API depth is added:

| File | Role | Size |
|---|---|---|
| `<Module>.md` | overview + narrative + cross-refs (existing tier-0+1 hybrid) | ~500-800 lines |
| `<Module>_API.md` | counter-driven deep API reference (per-symbol template) | ~500-3000 lines |

The overview is hand-authored; the API page is counter-driven (see §2.4).

**Naming convention.** Wiki page paths mirror the AliceO2 directory tree:

| AliceO2 path | Overview wiki page | API wiki page |
|---|---|---|
| `Common/` | `Common_utilities.md` | `Common_utilities_API.md` |
| `DataFormats/Reconstruction/` | `DataFormats_Reconstruction.md` | `DataFormats_Reconstruction_API.md` |
| `Detectors/Base/` | `Detectors_Base.md` (planned) | `Detectors_Base_API.md` (planned) |
| concept spans directories (e.g. magnetic field) | concept-page cross-references | `Field_API.md` (planned) |

### 2.3 Three-tier advisor escalation

Pages are organized so an AI advisor can escalate cheaply:

```
Tier 0 (overview .md)  →  always loaded for routing
        ↓ if insufficient
Tier 1 (_API.md)        →  loaded when query targets a specific symbol family
        ↓ if insufficient
Tier 2 (source code)    →  fetched on-demand via tool, only what is needed
```

Authoring obligation: tier-0 pages must contain enough orthogonal metadata to answer trivial queries without descent. Tier-1 pages must answer non-trivial structured queries without source-fetch. Tier-2 (source) is reserved for line-precise facts.

### 2.4 Counter-pipeline integration (binding for `_API.md`)

Every `_API.md` file is driven by counter-pipeline output. The pipeline (`MIWikiAI_Counter_Pipeline.md`, scripts in `scripts/`) produces:

- `usage.csv` — one row per logical symbol, 13 columns including `prod_usage_count`, `match_confidence`, `name_uniqueness`, `header_basename_collision`
- `breakdown.tsv` — top-K caller files per symbol + ALL ambiguous symbols

The `_API.md` front-matter MUST include:

```yaml
counter_baseline:
  pipeline_version: v0.5
  aliceo2_sha: <40-char SHA>
  baseline_run_date: <ISO8601>
  filter_scope: <awk filter expression used>
  usage_csv: <path>
  breakdown_tsv: <path>
counter_signals_per_symbol:
  - prod_usage_count
  - prod_reachable
  - churn_12m
  - workflows_direct
  - header_basename_collision
  - name_uniqueness
  - match_confidence
```

### 2.5 Per-symbol orthogonal metadata axes (NEW v0.5, architect Q2 direction)

In addition to counter signals, each symbol entry encodes orthogonal axes so the advisor answers trivial questions from front-matter without descending into body:

| Axis | Values | What it tells the advisor |
|---|---|---|
| `is_static` | true / false | control plane (static methods on registry) vs data plane (instance-bound) |
| `is_template` | true / false | regex-counter caveat applies (template instantiations not counted) |
| `is_ambiguous` | true / false | route via breakdown.tsv; same-bare-name in N>1 files |
| `risk_class` | `link-error` / `silent-drop` / `runtime-config` / `operational-timing` / `none` | what failure-mode class the symbol belongs to |
| `caller_breadth` | `wide` / `narrow` / `unique` | how many files reference it; rough cost-of-change estimate |

These five axes are ORTHOGONAL to `prod_usage_count`. They encode *why* the symbol matters, not *how often* it is used.

### 2.6 Per-symbol section template (rigid)

```markdown
### `<bare_name>` — <one-line semantics>

**Defined in:** `<full path>:L<line>`
**Namespace:** `<full qualified parent>`
**Signal:** prod_usage_count=N, confidence=high|medium|low|ambiguous,
            churn_12m=N, workflows_direct=N, collision=true|false,
            uniqueness=unique|ambiguous
**Axes:** is_static=Y/N, is_template=Y/N, is_ambiguous=Y/N,
          risk_class=<class>, caller_breadth=<width>

<2-4 sentences of semantics — VERBATIM from source comments OR
[ARCHITECT-MARIAN-PARAPHRASE] / [FABRICATED — illustrative only]
when source comments absent>

**Top callers in production** (top 5 from breakdown.tsv):
- `<file>` (N references) — <brief context>
[...]

**Signature** [VERBATIM <header>:L<line>]:

\`\`\`cpp
<verbatim signature>
\`\`\`

**Worked example** [VERBATIM <caller>:L<line>]:

\`\`\`cpp
<3-8 lines copied verbatim from real .cxx>
\`\`\`

**See also:** `<related symbol>`, `<related symbol>`

**Failure modes:** <inline OR cross-ref to §5>
```

The template is rigid by design: machine-greppable, predictable for advisors.

### 2.7 Prose-vs-VERBATIM consistency obligation (NEW v0.5.3)

A `[VERBATIM]` block alone does NOT certify the surrounding prose. The prose paragraphs immediately above and below a `[VERBATIM]` block are an independent failure surface — they can silently contradict the verbatim content while every label remains technically correct.

**Origin event:** `Common_utilities_API.md v0.2` contained a `[VERBATIM ConfigurableParam.h:L139-L156]` block correctly showing the `EParamProvenance` enum with 3 values (`kCODE`, `kCCDB`, `kRT`). The prose paragraph immediately below that block claimed the enum had 6 values, naming three fabricated entries (`kRTF`, `kCCDBPRIO`, `kEXIM`) that do not exist anywhere in the AliceO2 source tree. The fabrication survived the 13-reviewer cycle-2 panel because:

- Aspect-B reviewers verified the [VERBATIM] tag matched source — it did
- Aspect-F reviewers built failure-mode descriptions on top of the prose — they trusted it
- No reviewer aspect was explicitly responsible for prose-vs-VERBATIM divergence

The fabrication was discovered only during v0.3 re-verification by the Coder, after architect direction to re-check all citations. Without that re-verification it would have shipped to advisors.

**Coder obligation:** when authoring or editing prose adjacent to a `[VERBATIM]` block, the Coder must read the [VERBATIM] block content and confirm the prose does not extend, generalize, or contradict it. If the prose says something not present in the [VERBATIM] block, the Coder must either (a) extend the [VERBATIM] block to cover the new claim, (b) attach a separate `[ARCHITECT-MARIAN-PARAPHRASE]` or `[FABRICATED]` label to the new claim, or (c) remove the new claim.

**Reviewer obligation:** Aspect-C reviewer (see §4.7) is the explicit prose-vs-VERBATIM consistency owner. The check is binary: read every [VERBATIM] block, then read the surrounding 3-5 paragraphs, then ask "does the prose say anything not in the verbatim?" Any extension, generalization, or contradiction is a P0 finding.

**Why this is not absorbed into §3.2:** §3.2 prohibits silent paraphrase of caller-code patterns (workflow examples). §2.7 prohibits silent extension of verbatim source semantics in adjacent prose. Both are anti-fabrication rules; the failure surfaces are different. §3.2 protects worked examples; §2.7 protects everything else.

---

## 3. Label vocabulary (BINDING — anti-silent-paraphrase rule)

### 3.1 The four labels

When a wiki page presents content with provenance implications, that content MUST carry exactly one label:

| Label | Meaning | Reviewer cross-check obligation |
|---|---|---|
| `[VERBATIM <path>:L<line>]` | content copied unchanged from a real file at the cited line range | reviewer verifies file exists and content matches |
| `[ARCHITECT-MARIAN-VERIFIED]` | architect (Marian Ivanov) confirmed from operational experience | reviewer accepts as authoritative; cannot independently verify |
| `[ARCHITECT-MARIAN-PARAPHRASE]` | architect-authored prose in own words, from memory or experience | reviewer accepts; flag if prose contradicts a `[VERBATIM]` source elsewhere |
| `[FABRICATED — illustrative only]` | Coder invented for illustration, no source backing | **reviewer MUST cross-check; flag plausibility (correct / mildly off / implausible); architect ratifies or removes** |

Labels apply to: code excerpts, prose claims about behavior, failure modes, design rationale, anything that could be sourced.

### 3.2 Anti-silent-paraphrase rule (P0 violation if broken)

When a wiki page cites production-caller code, the Coder MUST EITHER:
- produce a `[VERBATIM <path>:L<line>]` quote from the actual file, OR
- explicitly mark the example `[FABRICATED — illustrative only]`

**Silent paraphrase** (presenting invented patterns as if drawn from real callers, without label) is a P0 governance violation. This rule was ratified after `Common_utilities_API.md v0.1` was found to contain unlabeled paraphrased patterns presented as workflow-derived (architect Q4 direction, 2026-04-30).

### 3.3 Source-access protocol

If the Coder lacks access to a source file needed for verbatim citation:

1. **The Coder MUST request it** from the architect (zip, grep output, or filesystem path on Alma) **before authoring the example**.
2. The Coder MUST NOT silently fall back to invented patterns. Falling back is the P0 violation in §3.2.
3. If the architect cannot provide the source within a reasonable interval, the Coder labels the example `[FABRICATED — illustrative only]` and proceeds. This makes the gap visible to reviewers and to the advisor.

### 3.4 Reviewer cross-check on FABRICATED

Reviewers handling a `_API.md` page MUST flag every `[FABRICATED — illustrative only]` instance in their primary aspect. The reviewer report notes whether the fabrication is:

- **plausibly correct** — pattern matches typical usage; no concern
- **mildly off** — would compile but missing a detail; needs adjustment
- **implausible** — would not compile, would be wrong, or would mislead advisor

Architect ratifies or removes implausible fabrications. Coder updates with verbatim source on next cycle.

### 3.5 Reviewer source-access protocol (NEW v0.5.2)

Symmetric to the Coder source-access protocol in §3.3. **If a reviewer lacks information needed to evaluate a claim, the reviewer MUST request it before producing a finding on that claim.**

Concretely:

1. If the artifact cites a source file (`upstream:` front-matter) the reviewer cannot open, the reviewer requests the file from Coder or architect — does not produce a finding on cited content without verifying the citation.
2. If the artifact cites counter-pipeline output (`counter_baseline:` block) the reviewer does not have, the reviewer requests `usage.csv` + `breakdown.tsv` for the cited SHA.
3. If the artifact references a governance rule the reviewer does not have access to (e.g. an Organization-doc version), the reviewer requests it.
4. If the reviewer cannot obtain the missing source within the review timeline, the reviewer **flags `[?]` UNCERTAIN** for findings dependent on it. Producing a confident finding on uninspected source is a **P1 violation**.
5. **Inventing or guessing** to fill an evidence gap is a **P0 violation** — the same fabrication standard as the Coder side.

> *Origin: cycle-1 cross-cutting lesson. Sonnet3 caught real bugs (line drift, undercount) by red-team source-fetching; Gemini2 produced a hallucinated anchor-failure finding that would have broken a working cross-reference. The difference: source access. This rule binds the productive pattern.*

---

## 4. Reviewer-side specifics for MIWikiAI artifacts

### 4.0 Governance principle: silent omission of evidence is P0/P1 (NEW v0.5.6)

The rules in this section are special cases of a single underlying principle: **silent omission of evidence, validation, or context is a governance violation**, regardless of whether the omitted thing is reviewer findings (cycle-1 truncation rule), source citations (§3.2), prefilter coverage scope (§4.11), local validation (§4.12, §4.16), version markers (§4.14), or format changes (§4.15).

The rules cohere because they share this principle. New rules added to §4 in future versions should test against this principle — if a proposed rule is forbidding a class of *silent omission*, it belongs here; if it is forbidding something else, it likely belongs elsewhere in the QRC.

**Existing instances mapped to this principle:**

- §4.11 (prefilter ratchet) — forbids silent omission of prefilter coverage scope from PASS verdicts
- §4.12 (local-convergence) — forbids silent omission of pre-delivery validation
- §4.13 (cycle-N+1 carry-forward) — forbids silent omission of prior-cycle CONV findings from current-cycle dispatch
- §4.14 (version-marker consistency) — forbids silent omission of body-version markers when front-matter is updated
- §4.15 (format-change approval) — forbids silent omission of format changes that would otherwise look like content changes
- §4.16 (architect data, not mocks) — forbids silent omission of source-data origin from delivery messages
- §3.2 (anti-silent-paraphrase rule) — predecessor of this principle, applied to source citation specifically

> *Origin: 2026-05-05 Claude2 cross-cutting observation in QRC v0.5.5 ratification synthesis. Worth promoting from "rule rationale" to "governance principle" because it explains why §§4.11-4.16 are mutually reinforcing and provides a test for future rule additions. v0.5.5 was the first QRC version where every new rule had measured outcome backing it; v0.5.6 extracts the unifying principle that those rules instantiate.*

---

In addition to the general MTTU_Reviewer rules:

**For Main Reviewer synthesis on MIWikiAI artifacts**, the binding card is `Main_Reviewer_Quick_Reference_Card.md` (Organization-level, 2026-05-01 first issuance). Its Coverage Matrix, finding-traceability table, and raw-input-retention rules apply unchanged to MIWikiAI Main Reviewer reports. **MIWikiAI Main Reviewer summaries that cite a subset of received reviewer reports without explicit Coverage Matrix accounting are P0 governance violations** — codified after Common_utilities_API v0.1 cycle-1 truncation incident (3 of 9 reports cited in initial summary; corrected after architect challenge). See also Reviewer_QRC v1.29 Rule 13.

### 4.1 Software-index page review aspects (NEW v0.5)

When reviewing `_API.md` files, reviewers verify:

| Check | Source of ground truth |
|---|---|
| All `[VERBATIM <path>:L<line>]` quotes match the cited source at the cited lines | architect-uploaded source files OR direct `git show` |
| Counter signals in front-matter and per-symbol entries match `usage.csv` | `usage.csv` from the cited counter run |
| Caller lists match `breakdown.tsv` top-K for each symbol | `breakdown.tsv` from the cited counter run |
| Anchor mechanics resolve (every cross-link `#anchor` reaches a real heading) | render the markdown, click links |
| Per-symbol template fidelity (every symbol section follows §2.6) | this QRC §2.6 |
| Orthogonal axes (§2.5) populated for every symbol | this QRC §2.5 |
| `[FABRICATED]` label cross-check per §3.4 | reviewer's primary-aspect knowledge |

### 4.2 Ambiguous-symbol handling

Symbols with `name_uniqueness=ambiguous` (defined in N>1 files, e.g. `Instance`, `getName`, `clear`) emit `prod_usage_count=-1`. Reviewers verify:

- Coder did not flatten ambiguous symbols into a single fictitious "primary case"
- Disambiguation subsection lists all defining classes
- Top-callers from `breakdown.tsv` are categorized by likely defining-class context

### 4.3 Counter-baseline staleness

Reviewers check whether the `counter_baseline.aliceo2_sha` in front-matter matches the current pinned SHA. SHA drift is P2 (advisory) unless a quoted line number conflicts with current source — then P1.

### 4.4 Standardized review bundle (NEW v0.5.2)

Every `_API.md` artifact dispatched for cycle-2+ panel review MUST be accompanied by a **standardized review-bundle zip** named `<artifact_name>_v<version>_review_bundle.zip`. This standardizes evidence distribution so every reviewer sees the same evidence base.

**Required bundle contents:**

| Path in zip | Content |
|---|---|
| `MANIFEST.md` | one-page index listing every file with its role |
| `artifact/<artifact_name>.md` | the artifact under review |
| `self_review/PHASE_<N>_*_CycleZero_*.md` | Coder cycle-0 self-review |
| `prior_review/<previous_consolidated_summary>.md` | Main Reviewer summary from cycle N-1 (if cycle ≥ 2) |
| `prompts/<reviewer_prompts>.md` | aspect-keyed reviewer prompts (this cycle) |
| `source/*.zip` or `source/*.txt` | all source files cited in `upstream:` front-matter |
| `counter/usage.csv`, `counter/breakdown.tsv` | counter-pipeline outputs cited in `counter_baseline:` |
| `governance/MIWikiAI_QRC_v<version>.md` | binding MIWikiAI rules for this review |
| `governance/Reviewer_QRC_v<version>.md` | inherited reviewer mechanics |
| `governance/Main_Reviewer_QRC.md` | inherited Main Reviewer rules |
| `governance/MTTU_Reviewer_v<version>.md` | inherited reviewer protocol |

**Coder produces the bundle.** Architect verifies completeness before dispatch.

**Why this rule exists:**
- Reviewer findings are only as good as the evidence each reviewer had access to
- Different reviewers assembling context from random uploads → spurious divergence in findings (looks like reviewer disagreement, is actually evidence asymmetry)
- The Coder cannot demonstrate "I gave you everything" without a manifest
- Review reproducibility (can a future reviewer verify the cycle?) requires the same evidence base

**Compliance:**
- Cycle-2+ dispatch without a complete review bundle is a P1 process violation
- Cycle-3+ on `_API.md` artifacts is the first compliance window for this rule (cycle-2 of `Common_utilities_API.md` predates this rule)

> *Origin: 2026-05-02 architect direction during cycle-2 dispatch of Common_utilities_API.md v0.2 — observed need for standardized evidence distribution.*

### 4.5 Dispatch document required contents (NEW v0.5.3)

Every cycle-2+ dispatch ships a **dispatch document** (the reviewer prompts) inside `prompts/` of the review bundle. The dispatch document MUST contain all 10 items below in the order shown. Items are numbered for cross-reference.

| # | Item | Purpose | Failure mode if missing |
|---|---|---|---|
| 1 | **Reviewer assignment table** at the top — every reviewer ID mapped to primary aspect, optional secondary aspect | Reviewer reads one row, knows their job | Reviewer asks "what aspect am I?" or skips review |
| 2 | **Aspect coverage check** — explicit count showing each aspect has ≥3 reviewers and ≥1 Opus on judgment-heavy aspects (C, E, F per §4.7) | Architect verifies coverage at a glance | Aspects under-covered, findings missed |
| 3 | **ID-drift warning** — "use the ID assigned in §0; do not sign as model name" | Defends Identity Persistence rule | Reports signed `ClaudeOpus47` not `Claude5` |
| 4 | **Bundle-incomplete handling** — what reviewer does if MANIFEST is missing, source files missing, dispatch count `N` not set | Reviewer cannot proceed silently with broken bundle | Spurious findings or no findings |
| 5 | **Steps-in-order list** — find your row → read artifact → run aspect checks → verify against source → pick top 3 → write report → save | Reviewer follows a procedure, not a narrative | Reviewer misses steps |
| 6 | **Per-aspect concrete checks** — 4-6 items per aspect, each with explicit pass/fail criterion and (where applicable) a `bash`/`sed`/`grep` command to run | Reviewer does not invent the test | Reviewer guesses or skips |
| 7 | **Source-extraction guide per aspect** — which aspects need source extracted, which need only the artifact + counter | Reviewer does not waste time extracting source they don't need | Reviewer extracts everything or nothing |
| 8 | **Report template** — copy-paste-fill markdown skeleton with the 6 sections from MTTU_Reviewer | Reviewer does not invent format | Reports diverge from template, Main Reviewer cannot synthesize |
| 9 | **Save path + deadline** — explicit absolute path; reviewer deadline + Main Reviewer deadline as separate values | Reviewer knows where and when | Reports land in wrong place or late |
| 10 | **Main Reviewer subsection** — segregated, only Main Reviewer reads; specifies where reviewer reports come from, what counts as "cited" in Coverage Matrix, anti-truncation rule | Main Reviewer has dedicated instructions, not buried in reviewer prose | Main Reviewer truncation incident #3 |

**Coder produces the dispatch document.** It is the Coder's responsibility, not the architect's or the Main Reviewer's. The Coder authors it as part of producing the cycle's review bundle.

**Compliance:** A dispatch document missing any of items 1, 3, 5, 8, 9, 10 is a P0 process violation by the Coder — the dispatch is unusable for reviewers and must be reissued. Items 2, 4, 6, 7 are P1 — dispatch can proceed but reviewer effort is wasted.

**Anti-pattern (BANNED).** A dispatch document that opens with governance preamble (rotation history, anti-truncation reminder, what-changed-in-this-version explanation) before telling the reviewer what to do. Reviewers skim. Action must come in the first screen of the document.

> *Origin: 2026-05-02 cycle-3 dispatch of Common_utilities_API.md v0.3. Initial dispatch document opened with §0 "Read-this-first for ALL reviewers" containing 80 lines of governance commentary before §1 "What you are reviewing." Architect smoke-test: zero reviewers produced reports. Document was rewritten action-first (§0 reviewer assignment table → what reviewing → what to produce → steps → aspects → template → path/deadline) over three iterations. The 10-item required-contents list above is the post-mortem distillation.*

### 4.6 Pre-dispatch smoke test (NEW v0.5.3, REQUIRED for cycles ≥ 3)

Before a full N-way dispatch on cycles 3 and later, the architect runs a **single-reviewer smoke test** with one Sonnet or one Gemini reviewer using the proposed dispatch document and the proposed bundle. The smoke-test reviewer's experience surfaces dispatch-document problems before the full panel sees them.

**Smoke-test outputs:**

- Reviewer can / cannot follow the document end-to-end
- Reviewer report conforms / does not conform to template
- Aspect checks are concrete enough / too vague to act on
- Source extraction works / fails
- Bundle is complete / has gaps

**Smoke-test failure (any "cannot" or "does not" above) → Coder revises the dispatch document and bundle, then either:**

- (a) Re-runs smoke test with same or different smoke-test reviewer, or
- (b) Architect signs off on the revision and full dispatch proceeds

**Smoke-test pass → full dispatch proceeds.**

**Smoke-test reviewer is COUNTED in the cycle's reviewer roster.** Their aspect coverage and findings are valid for the cycle. The smoke test is not a separate cost; it is the first reviewer of the cycle, plus a feedback loop to the Coder before the rest dispatch.

**Smoke-test reviewer should be Sonnet or Gemini, not Opus.** Opus is reserved for the Coder, Main Reviewer, and Aspects C/E/F. Using Opus for smoke testing wastes the project's Opus budget.

**Compliance:** Cycle-3+ dispatch without a documented smoke-test pass is a P1 process violation. v0.3 of `Common_utilities_API.md` is the first compliance instance.

> *Origin: 2026-05-02 architect direction after observing zero reviewer outputs from initial cycle-3 dispatch attempt. The smoke-test pattern emerged organically — architect ran one reviewer manually, surfaced "what should reviewer do?" gaps, demanded prompt rewrite. Codified here so the next cycle does it deliberately rather than as recovery.*

### 4.7 Three-dimensional review assignment (REVISED v0.5.4)

Cycle-2+ reviews of `_API.md` artifacts use a **three-dimensional assignment model**. Every reviewer in the cycle gets a row defining all three dimensions:

```
reviewer_id × document_section × aspect_focus
```

**Dimension 1 — reviewer ID.** From the pool: Claude1-2 (Opus) + Sonnet1-6 + Gemini1-6 + optional GPT.

**Dimension 2 — document section (NEW v0.5.4).** A natural section of the artifact under review. For an `_API.md` file the natural sections are: §1 (purpose/scope), §2 (counter signals legend), §3 (family overview), §4 per-symbol entries (one section per symbol — typically 8-12), §5 (failure-mode index), §6 (cross-references). Section ownership means the reviewer **deep-validates that section: follows every link, verifies every citation against source, runs every aspect check on every line of the section.**

**Dimension 3 — aspect focus.** One of the six aspects from the §4.7-v0.5.3 taxonomy, kept unchanged:

| Aspect | What it covers | Mechanical or judgment? |
|---|---|---|
| **A — Document structure** | Front-matter schema, anchor mechanics, section count, cross-reference reachability | Mechanical |
| **B — VERBATIM citation accuracy** | Every `[VERBATIM <path>:L<line>]` matches source at cited line, content character-exact | Mechanical (sed/grep verification) |
| **C — Prose-vs-VERBATIM consistency** | Prose adjacent to [VERBATIM] does not extend, generalize, or contradict the block (per §2.7) | **Judgment** |
| **D — Counter signals** | `prod_usage_count`, `workflows_direct`, etc. in artifact match `usage.csv` and `breakdown.tsv`; wider-grep verification of suspicious zeros | Mechanical |
| **E — Worked examples** | [VERBATIM] examples compile and match source; [FABRICATED] examples are plausible (correct / mildly off / implausible) per §3.4 | **Judgment** |
| **F — Failure modes** | F1-F5 descriptions match actual failure semantics in source; labels (VERIFIED/PARAPHRASE) on correct bullets | **Judgment** |

**Reading the artifact (every reviewer):**

- **Full document:** every reviewer reads the whole artifact top-to-bottom for context, before deep-diving owned sections. Findings outside owned sections are valid but reported as "advisory cross-section observation" not as primary findings.
- **Owned sections:** deep validation per §4.8. Follow every link. Verify every citation. Run every aspect-check on every line.

**Opus-budget allocation rule (kept from v0.5.3, refined for section model):**

- **Coder = Opus** (always)
- **Main Reviewer = Opus** (always)
- **Per-section Opus = the 1-of-5 in the 2+2+1 coverage** (§4.8). The Opus reviewer's role on a section is **judgment-aspect work** (C, E, F) — *not* mechanical replication of what Sonnet/Gemini did. The Opus reviewer reads the Sonnet/Gemini findings on their owned section first, then asks: "do these mechanical facts add up to a semantic claim the prose is making?" That is the §2.7 prose-vs-VERBATIM check, applied at section ownership.
- **Smoke-test reviewer = Sonnet or Gemini** (§4.6, unchanged)

**Compliance:** Using Opus on a section to redo mechanical aspect-A/B/D checks the Sonnet/Gemini reviewers on that section already did is a P2 advisory (Opus budget waste). Using Sonnet/Gemini alone on a section without the 1 Opus from the 2+2+1 pattern is a P1 violation (judgment-aspect coverage missing on that section).

> *Origin: 2026-05-02 architect direction during cycle-3 dispatch (Opus budget pressure observed). 2026-05-03 Claude1 advisory: redundant deep section coverage (2 Sonnet + 2 Gemini + 1 Opus per section) is structurally stronger than dimension-only assignment because convergence among 5 independent reviewers on the same section is high signal regardless of model class. Same governance pattern as Main Reviewer truncation rule (multiple independent reviewers catch what one missed), applied at section level.*

### 4.8 2+2+1 deep section coverage (NEW v0.5.4)

Every natural section of an `_API.md` artifact under cycle-2+ review receives **2 Sonnet reviewers + 2 Gemini reviewers + 1 Opus reviewer = 5 deep-validation reviewers** as section owners. All 5 deep-validate: follow every link in the section, verify every [VERBATIM] citation, run every aspect-check on every line.

**Why 5 redundant deep reviewers per section:**

- Sonnet and Gemini are individually less reliable on judgment tasks than Opus
- Convergence across 5 independent reviewers on the same section is much stronger signal than any single reviewer's report, regardless of model class
- This is the same governance pattern as the Main Reviewer truncation rule (multiple independent reviewers catch what one missed) — applied at the section level
- The 2 Sonnet + 2 Gemini split protects against single-model-class systematic error (e.g. a Gemini-pair flagging the same false-positive when Sonnet pair sees through it; or a Sonnet-pair missing the same fabrication that Gemini catches)
- The 1 Opus per section is the judgment-aspect anchor (C, E, F)

**Pool sufficiency check.** With 14 reviewers (Sonnet1-6 + Gemini1-6 + Claude1-2) and 5 reviewers per section, each reviewer owns ~5 sections (75 reviewer-sections / 14 reviewers ≈ 5.4). For a typical `_API.md` with 14 natural sections (§1, §2, §3, §4 × 11 symbols, §5, §6) the pool covers all sections at 2+2+1 depth.

**Section-rotation rule.** Each reviewer's owned sections rotate per cycle so no reviewer always owns §4-getName (for example). The Coder produces the section-assignment table per cycle as part of the dispatch document (§4.5 item 1).

**Architect can adjust the per-section count** (e.g. lift to 3+3+1 for a high-stakes cycle, or drop to 2+1+1 if the pool is small). The 2+2+1 above is the default.

**Compliance:** Cycle-2+ dispatch without 2+2+1 section coverage on every section is a P1 violation. The Coder's dispatch document must include the section-assignment table that demonstrates compliance.

> *Origin: 2026-05-03 Claude1 advisory + architect ratification. Math worked out: 15-reviewer pool (Claude1 + Claude2 + Sonnet1-6 + Gemini1-6 + Coder/Main_Reviewer reserved) covers ~14 natural sections at 5-deep without overload.*

### 4.9 Convergence handling for divergent section-owner findings (NEW v0.5.4)

With 5 reviewers per section, **divergence is expected and useful** — but the Main Reviewer needs an explicit rule to synthesize divergent findings without being whipsawed by pairs of less-reliable reviewers producing the same false-positive.

**Convergence rules for section-owner findings (5 reviewers per section under §4.8):**

| Convergence pattern | Disposition | Severity in synthesis |
|---|---|---|
| **3-of-5 reviewers flag the same finding** (regardless of model class) | Elevated to consideration; included in CONV-N entries | At reported severity (typically P1) |
| **2-of-5 with Opus dissent** | UNCERTAIN — defer to architect ratification; flagged in synthesis but not auto-elevated | Reported as UNCERTAIN-N |
| **2-of-5 without Opus dissent (e.g. 2 Geminis agree, Opus silent)** | Provisional finding; included in synthesis at reported severity but flagged as "needs architect spot-check" | At reported severity, "spot-check" tag |
| **1-of-5 single-reviewer finding** | P2 default unless cited source verifies the finding directly | P2 (advisory) — "single-reviewer" tag |
| **1-of-5 single-reviewer with verbatim source citation that confirms the finding** | Treat as 3-of-5 equivalent (the source IS the convergence) | At reported severity |

**Why this rule exists:**

- Sonnet and Gemini, when they go wrong, often go wrong in the same way (training-data correlations). 2 Geminis flagging the same false-positive is a real risk.
- Opus dissent is high-signal: the Opus reviewer is the judgment anchor (§4.7), so explicit Opus disagreement on a 2-of-5 cluster is a strong indicator the cluster is a false-positive.
- A single reviewer with a verbatim-source-backed finding is not "single" in the epistemic sense — the source backs them up. Treating verbatim-source-backed singletons as advisory would discard real findings.

**Main Reviewer obligation.** When synthesizing cycle output, the Main Reviewer applies §4.9 to every section's owner findings before the cross-section synthesis. The Coverage Matrix per Main_Reviewer_QRC must distinguish CONV-N (≥3 reviewers), UNCERTAIN-N (2-of-5 Opus-dissent), and single-reviewer findings.

**Compliance:** A Main Reviewer synthesis that auto-elevates 2-of-5 findings without distinguishing Opus-dissent vs Opus-silent cases is a P1 process violation (false-positive cascade risk). A synthesis that drops single-reviewer findings without checking for verbatim-source backing is a P2 advisory.

> *Origin: 2026-05-03 Claude1 advisory refinement #2 — protect against Gemini-pair / Sonnet-pair false-positive cascades while preserving the value of redundant section coverage.*

### 4.10 Sprint finding cap raised for multi-section ownership (NEW v0.5.4)

The general MTTU_Reviewer sprint-mode rule caps reviewer reports at 3 findings. Under the §4.8 section-ownership model, each reviewer owns ~5 sections, making a 3-finding cap too tight (one finding per ~1.7 owned sections does not cover real defect density at deep validation).

**Cycle-3 specific rule:** sprint finding cap **raised to 5** for cycle-3 of `Common_utilities_API.md v0.3` and any cycle using §4.8 2+2+1 section coverage. The 5-finding cap permits up to one finding per owned section without forcing reviewers to drop legitimate observations.

**Default cap going forward:**

- Cycles **using §4.8 section ownership:** sprint cap = 5 findings per reviewer
- Cycles **using dimension-only assignment** (the v0.5.3 model): sprint cap = 3 findings per reviewer (MTTU baseline)

**Compliance:** A reviewer producing more than 5 findings under §4.8 is asked by Main Reviewer to triage to top-5 before synthesis. A reviewer producing fewer than 5 is fine — the cap is a ceiling, not a quota.

> *Origin: 2026-05-03 Claude1 advisory refinement #1. Math: 5 owned sections × ~0.7-1.0 findings per section at deep validation depth ≈ 3.5-5 findings per reviewer. Cap of 5 covers the upper end.*

---

### 4.11 Prefilter ratchet rule (NEW v0.5.5)

Once a defect class is encoded into the prefilter (`prepare_review.py`) and verified by ≥1 cycle's panel, that defect class is the prefilter's responsibility going forward. Reviewers MUST NOT re-perform the mechanical check globally; they cite the prefilter result and use freed attention for judgment-aspect work in owned sections (§4.7 Aspects C, E, F).

**Specifically:** if `preprocessed/<check>.txt` reports PASS, the corresponding QRC obligation (anchor resolution, VERBATIM character-exact diff, counter-signal CSV match, known-fabrication scan) is discharged at the global level. Reviewers re-perform these checks only within owned sections, and only as needed to construct findings.

**Rationale:** repeated mechanical checks across 14+ reviewers per cycle is wasted effort. The prefilter scales linearly with artifacts; reviewer attention is the scarce resource and must be redirected to work the prefilter cannot do (semantic prose-vs-source consistency, plausibility judgment, failure-mode validation).

**Backslide protection:** if a panel discovers the prefilter is wrong (false PASS or false FAIL), the cycle's Main Reviewer flags it for the next prefilter sprint. Until the next sprint closes, that check is treated as advisory, not authoritative — but the *default position* remains "trust prefilter PASS."

**Coverage caveat (NEW v0.5.6, Claude2 R-1):** PASS means *"every defect class encoded in prefilter v_N passed"*; it does NOT mean *"this artifact is correct"*. The prefilter version's coverage list MUST be visible — `prepare_review.py` documents its current coverage list in module-level comments, and Main Reviewer synthesis cites the prefilter version used. A reviewer who reads PASS without knowing the coverage list may infer correctness when only "encoded-classes-pass" is established. This is the structural reason §4.11's freed attention must redirect to *judgment work*, not vanish — judgment work is the coverage Tier-3 (semantic) the prefilter cannot do.

> *Origin: 2026-05-04 Claude10 cycle-4 synthesis §3 (prefilter coverage gaps surfaced by cycle-4 panel finding 4 confirmed gaps in v1.2; v1.3 closed all 4). Confirmed: empirical evidence cycle-3 → cycle-4 shows Sonnet panel using prefilter PASS verdicts produced more findings on a smaller artifact, validating the freed-attention thesis. Coverage caveat added 2026-05-05 (Claude2 R-1) to prevent "PASS = correct" misreading.*

---

### 4.12 Coder local-convergence rule (NEW v0.5.5) [MUST]

The Coder MUST run all available validation locally and reach convergence (PASS or known-acceptable FAIL) BEFORE notifying the architect of delivery. If a "drop or fix" engineering decision arises during Coder work where the math is unambiguous (e.g., 5-second one-time fix vs 70-minute-per-cycle ongoing cost), the Coder fixes; surfacing such decisions to the architect as a menu is a **P1 process violation**.

**Required pre-delivery checks:**

1. Unit tests pass (paste pytest output in delivery message)
2. Prefilter run against architect's most recent uploaded source data (paste prefilter output)
3. Manual self-checks for known regression classes (paste each grep result)

**Forbidden:**

- "Looks good to me" delivery without paste-evidence
- Surfacing solvable engineering decisions to architect as choice menus
- Continuing iteration after architect notification when local validation could have caught the issue

**Solvability tiebreaker (NEW v0.5.6, Claude2 R-2):** when the Coder is unsure whether a decision is solvable locally, the default is **solve, not escalate**. Escalating-to-be-safe surfaces decisions to architect that the Coder could have resolved with one additional iteration, costing architect time and breaking the §4.12 discipline. The asymmetry with §4.15 (format-vs-content) is intentional: solvable engineering work stays with Coder; format-vs-content boundary cases go to architect (per §4.15 tiebreaker).

> *Origin: 2026-05-04 Claude9 v1.0 → v1.1 → v1.2 trajectory. Three iterations shipped untested code that broke on architect's terminal; root cause was Coder framing engineering choices as architect decisions. Codifies the discipline that empirically closed the loop in cycle-4.*

---

### 4.13 Cycle-N+1 must close cycle-N CONV-flagged P0 and P1 findings (NEW v0.5.5, REFINED v0.5.6)

Every cycle's dispatch document MUST include the prior cycle's CONV-elevated findings as named stakes in §5 (cycle-stakes section). This prevents regression of fixes already established by panel convergence.

**What carries forward (REFINED v0.5.6, Claude10 O-1):** *all CONV-elevated findings of severity P0 or P1, regardless of overall-artifact verdict*. Earlier v0.5.5 phrasing said "the prior cycle's `[X]` and `[!]` CONV-IDs" which conflated artifact-level verdicts with finding-level severity. The correct rule is severity-driven: a P1 CONV finding inside an `[OK]`-verdict artifact still carries forward; a P2 finding inside an `[X]`-verdict artifact does not.

**Rationale:** cycle-3's CONV-C (F2 mechanism inversion) survived into v0.4 because the v0.4 dispatch §5 named-stakes list did not explicitly include it; reviewers had no clear cue to re-check that mechanism, so the regression was missed by 13 of 15 reviewers (v0.4 → v0.5 cycle-4 caught it via Sonnet1 + Claude10/Opus3 only).

**Coder-side compliance:** The Coder, when authoring the cycle-N+1 dispatch document, copies the prior cycle's CONV-elevated P0 and P1 findings into §5 verbatim with one-line summary of the fix that v_N+1 must preserve.

**Main Reviewer-side compliance (NEW v0.5.6, Claude1 OBS-2):** Main Reviewer of cycle-N+1 explicitly checks the carry-forward list in synthesis Coverage Matrix. *Missing carry-forward check is a P1 governance violation by Main Reviewer*, parallel to §4.5 dispatch-document violations. This converts the carry-forward from a Coder-only obligation into a two-sided obligation.

**ARCHITECT-REVISITING status (NEW v0.5.6, Claude2 R-3):** if architect intentionally revisits a prior CONV decision (e.g., new evidence has surfaced or original convergence was on insufficient data), the dispatch §5 carries the finding with status `ARCHITECT-REVISITING` rather than `CARRY-FORWARD`. This is not a regression — it is a deliberate re-examination. Reviewers treat ARCHITECT-REVISITING findings as open questions, not as defects.

> *Origin: 2026-05-04 cycle-4 finding CONV-ε (F2 inversion) — same defect cycle-3 panel had already flagged as CONV-C. Closing this loop prevents the regression-of-fixes failure mode. Refinements 2026-05-05 from QRC v0.5.5 ratification synthesis (Claude1+Claude10+Claude2 convergent on three angles).*

---

### 4.14 Body markers and front-matter version must agree before commit (NEW v0.5.5) [MUST]

The Coder's cycle-zero self-review MUST include a `grep` for body version markers (`End of v...`, `### N.M v0.X pilot scope`, `review_cycle:`) and confirm each matches the front-matter `source_status:` and `version:` fields. Mismatched markers are a **P0 governance violation** and BLOCKER for dispatch.

**Required cycle-zero greps:**

```bash
ARTIFACT=Alice/code/O2/<artifact>.md
grep "^source_status:" "$ARTIFACT"           # must show current version
grep "End of v" "$ARTIFACT"                  # must match
grep "review_cycle:" "$ARTIFACT"             # must match dispatch cycle
grep -E "^### [0-9.]+ v[0-9.]+ pilot" "$ARTIFACT"  # must match
```

**Rationale:** v0.4 carried v0.1 body markers (`review_cycle: 0`, `### 1.4 v0.1 pilot scope`, `End of v0.1 pilot.`) while front-matter said `source_status: DRAFT v0.4`. Cycle-4 Sonnet5 declined to review under this collapse; correct disciplined response, but the defect should never have shipped.

**Compliance:** dispatch-time pre-flight by architect runs the same greps; mismatch blocks dispatch.

**Note on grep coverage (NEW v0.5.6, Claude2 R-4):** the grep list above is *illustrative, not exhaustive*. The rule applies to **any version marker that appears in the artifact**, including patterns not yet seen. New patterns surfaced by future cycles are added to the cycle-zero greps and ideally encoded in the prefilter (`prepare_review.py`). The structural rule (body markers must agree with front-matter) outranks any specific pattern list.

> *Origin: 2026-05-04 cycle-4 CONV-α (5+ reviewer convergence). v0.4 body-vs-front-matter version collapse was mechanical and should have been caught by Coder cycle-zero self-review. Codifying the grep checks makes it impossible to skip.*

---

### 4.15 Format changes require architect approval (NEW v0.5.5)

The Coder's authority covers **content** (correcting, extending, restructuring symbol descriptions, examples, failure modes). Format-level changes — replacing 35 [VERBATIM] tags with code-comments, restructuring per-symbol templates, dropping `**Axes:**` blocks, renaming required Signal-block fields — are **governance changes** that require architect approval and a corresponding QRC amendment.

**Anti-pattern signature:** Coder revises an artifact and writes "rebuilding the per-symbol sections from cleaner verbatim source extracts" in revision_history while silently dropping all bracket-tagged `[VERBATIM <path>:L<a>-L<b>]` labels in favor of `// VERBATIM from <path> L<a>-L<b>` code-comments.

**Required:** if the Coder believes a format change is warranted, the Coder proposes the change in the cycle-zero self-review (or pre-delivery message) with rationale and waits for architect ratification before committing the change to the artifact.

**Compliance:** prefilter v1.3 §3.3 detects label-format regressions and emits a WARN/FAIL when body has fenced code blocks but zero QRC-compliant `[VERBATIM <path>:L<a>-L<b>]` brackets. This catches accidental drift; deliberate drift is a §4.15 violation.

**Format-vs-content tiebreaker (NEW v0.5.6, Claude2 R-5):** when the Coder is unsure whether a change is format-level or content-level, **ask the architect**. This is the explicit asymmetry with §4.12 (where the default is *solve, not escalate*): solvable engineering work stays with Coder; format-vs-content boundary cases escalate. The asymmetry is intentional — engineering work is local and reversible; format changes propagate across all artifacts and across all reviewer attention, making them governance-scale decisions.

> *Origin: 2026-05-04 cycle-4 CONV-γ (4-reviewer convergence). v0.4 Coder dropped 35 [VERBATIM] tags as part of "v0.3 → v0.4 rewrite" without architect approval. Empirically defeated the prefilter (which counted only 4 occurrences, all front-matter prose; body checking was vacuous in v1.2) and degraded reviewer Aspect-B mechanical work for 12+ reviewers.*

---

### 4.16 Coder local validation MUST use architect data, not synthetic mocks (NEW v0.5.5) [MUST]

Before any artifact, script, or governance-document delivery, the Coder MUST run all validation checks (prefilter, unit tests, manual self-greps) against the **architect's most recently uploaded source data**. The Coder's first validation step is to extract any `source/source.zip` or equivalent from recent architect uploads.

**Forbidden:**

- Synthesizing mock source files for character-exact validation
- Reconstructing source content from session memory or prior cycle reports for VERBATIM diff
- Building mock source trees for validation when architect has uploaded a real `source.zip`
- Skipping local validation with the rationale "the architect will catch it"
- Delivering with a passed prefilter run when the prefilter ran against anything other than architect-provided source

**Required:**

- First step of any artifact validation: check architect's recent uploads for source bundles; extract them
- If real source is unavailable, Coder either (a) explicitly requests it from architect before proceeding, or (b) flags affected content with `[VERBATIM-PLACEHOLDER <path>:L<a>-L<b> — architect, please verify]` and marks the relevant prefilter check as known-pending in delivery message
- Delivery message MUST identify the source-data origin (e.g., "tested against `source.zip` from architect's bundle uploaded 2026-05-05 11:26 UTC")

**Anti-pattern signature** (this is what failed in cycle-4 v0.5 → v0.5.1): Coder builds synthetic mock source matching the artifact's claims, prefilter PASSes (against the mock), delivery happens, real-source run on architect's machine FAILs. The synthetic source is **circular validation** — it confirms the artifact agrees with itself, not that the artifact agrees with the source.

**Compliance:** Coder's pre-delivery message must paste the prefilter output AND identify the source root used. If the source root is anything other than an architect-provided path or extracted bundle, that is a §4.16 violation.

**Partial-coverage handling (NEW v0.5.6, Claude2 R-6):** if architect-provided source covers only some of the cited files, the Coder uses real source for covered files and `[VERBATIM-PLACEHOLDER <path>:L<a>-L<b> — architect, please verify]` for uncovered files. Delivery message MUST identify coverage explicitly: *"covered files: X, Y; uncovered (placeholder): Z"*. This avoids the binary "have source / don't have source" framing that hid partial-coverage cases under v0.5.5.

**Stale-upload forbidden (NEW v0.5.6, Claude10 O-2):** validating against an older architect upload when a newer one exists in recent context is a §4.16 violation. Same circular-validation failure mode as synthetic mocks: the Coder validates against data that does not represent current ground truth. The Coder MUST use the most-recent architect upload — if uncertain which is most recent, the Coder asks before validating, not after.

> *Origin: 2026-05-05 v0.5 → v0.5.1 incident. Coder built synthetic ConfigurableParam.h matching v0.5's claimed VERBATIM blocks; prefilter PASSed against the synthetic source; real-source run on architect's machine caught one of three reconstructions wrong (getValueAs lambda form misremembered). Architect surfaced: "we agreed you will use my data — why you did not do it?" The agreement was not codified; this section codifies it.*

---

## 5. Advisor team layer

### 5.1 Three-tier consumption (binding for advisor implementations)

When an MIWikiAI advisor receives a query, it MUST follow the three-tier escalation:

1. Read the relevant overview file(s) first — tier 0
2. If the overview alone is insufficient, load the relevant `_API.md` file(s) — tier 1
3. If tier 1 is insufficient, fetch source code via tool — tier 2

Skipping tier 0 (going straight to source) is permitted only when the query explicitly targets line-precise source facts.

### 5.2 Label preservation

When the advisor cites content from MIWikiAI pages, the advisor MUST preserve the label. Specifically:

- `[VERBATIM <path>:L<line>]` content can be quoted as authoritative
- `[ARCHITECT-MARIAN-VERIFIED]` content can be quoted as authoritative
- `[ARCHITECT-MARIAN-PARAPHRASE]` content can be quoted, attributed to architect
- `[FABRICATED — illustrative only]` content MUST be quoted with the FABRICATED warning preserved; advisor MUST NOT present it as authoritative

Advisors that strip labels when citing violate the consumption contract.

### 5.3 Three-condition test pattern (Phase 0.2 PILOT)

Phase 0.2 advisor evaluation runs every test query in three conditions:

| Condition | What advisor sees |
|---|---|
| A. baseline | overview pages only |
| B. +API | overview + `_API.md` pages |
| C. +API+source | B plus source-fetch tool access |

Each query × condition produces one architect-graded result on a 0-3 scale (0=wrong, 1=partial, 2=usable with edits, 3=architect-equivalent). Phase 0.3 may add condition D (pure-RAG over source corpus) for a four-way comparison.

### 5.4 Token-budget logging (NEW v0.5, Phase 0.3 prep)

Each query × condition logs the token count loaded into advisor context. This is the substrate for parameter-scan benchmarking (architect Q2 direction). Format in `pilot_results.md`:

```markdown
| Query | A baseline | B +API | C +API+src |
|-------|-----------|--------|------------|
| Q1    | 5K        | 8K     | 22K        |
```

### 5.5 Query-quality benchmarking (planned)

The benchmarking framework (Phase 0.3+) measures three orthogonal axes:

- **Quality:** 0-3 grade per query (architect-supplied; same scale as Phase 0.2 pilot)
- **Speed:** wall-clock time per query
- **Tokens:** context tokens loaded per query

Adding a pure-RAG condition gives a four-way comparison: pure RAG vs wiki-only vs three-tier vs three-tier-plus-source.

---

## 6. Versioning

This QuickRef and `Technical_SUMMARY_MIWikiAI` evolve together with the same version number. Architect ratifies them as a pair. Cross-reference each other in front-matter. When one changes, the other changes (or explicit `no-changes` annotation).

---

## 7. Changelog

- **v0.5.6 (2026-05-05 evening).** Refines v0.5.5 §§4.11-4.16 per 3-Opus approval synthesis (Claude1 + Claude2 + Claude10 unanimous APPROVE-AS-IS for v0.5.5; eight non-blocking refinements consolidated here). New §4.0 governance principle (silent omission of evidence is P0/P1) — Claude2's cross-cutting observation promoted to architectural payoff. §4.11 PASS-coverage caveat (PASS means encoded-classes-pass, not artifact-correct; Claude2 R-1). §4.12 solvability tiebreaker (default is solve-not-escalate; Claude2 R-2). §4.13 severity-driven carry-forward terminology + Main Reviewer-side P1 obligation + ARCHITECT-REVISITING status (Claude1 OBS-2 + Claude10 O-1 + Claude2 R-3, three angles merged). §4.14 grep list illustrative-not-exhaustive (Claude2 R-4). §4.15 format-vs-content tiebreaker (when in doubt, ask architect — opposite of §4.12 by design; Claude2 R-5). §4.16 partial-coverage + stale-upload handling (Claude2 R-6 + Claude10 O-2). All eight refinements are single-line or short-paragraph clarifications to existing rules; no new rules introduced; no rule semantics changed. Companion `Technical_SUMMARY_MIWikiAI` v0.5.5 still binds (v0.5.6 introduces no new architectural model). Compiled by Claude9 against architect's real v0.5.5 (extracted from `/home/claude/qrc_v055.md` MD5 ce3e8c99f34065ad95f2928bff6f6dd3 — per §4.16 itself). Architect ratification pending.

- **v0.5.5 (2026-05-05).** Adds six Coder-side and panel-side discipline rules (§§4.11-4.16) surfaced by cycle-4 panel synthesis on `Common_utilities_API.md v0.4`. §4.11 prefilter ratchet rule (mechanical checks discharged at global level by prefilter; reviewers redirect attention to judgment work). §4.12 Coder local-convergence rule (run all validation locally before architect notification; do not surface solvable engineering decisions as menus). §4.13 cycle-N+1 must close cycle-N CONV-flagged P0 findings (carry-forward list mandatory in dispatch §5). §4.14 body markers and front-matter version must agree (cycle-zero greps required). §4.15 format changes require architect approval (Coder authority is content; format = governance). §4.16 Coder local validation MUST use architect data, not synthetic mocks (extraction of architect's most-recent source.zip is first validation step; circular validation against reconstructed source is forbidden). All six origins traceable to specific cycle-3 or cycle-4 incidents — see each section's *Origin* note. Companion `Technical_SUMMARY_MIWikiAI` v0.5.5 in same bump.

- **v0.5.4 (2026-05-03 afternoon).** Supersedes v0.5.3 same day after Claude1 (Aspect A primary, advisory) feedback on the dimension-only assignment model. §4.7 reframed to **three-dimensional review assignment** (reviewer × document_section × aspect_focus) — every reviewer reads the full artifact for context but deep-validates owned sections. §4.8 NEW — **2+2+1 deep section coverage** (2 Sonnet + 2 Gemini + 1 Opus per natural section of the artifact); rationale: redundancy across 5 independent reviewers on the same section is structurally stronger than dimension-only assignment, protecting against single-model-class systematic error and same-direction false-positives. §4.9 NEW — **convergence handling for divergent section-owner findings** (3-of-5 elevates; 2-of-5 with Opus dissent → UNCERTAIN deferred to architect; 2-of-5 without Opus dissent → "spot-check" tag; 1-of-5 with verbatim source backing treated as 3-of-5 equivalent); origin: protect against Gemini-pair / Sonnet-pair false-positive cascades. §4.10 NEW — **sprint finding cap raised to 5** for cycles using §4.8 section ownership (covers ~5 sections × ~0.7-1.0 findings per section at deep validation; baseline 3-cap from MTTU keeps for dimension-only cycles). No changes to v0.5.3 §2.7, §3, §4.5, §4.6 rules; this is purely additive plus §4.7 reframing. Companion `Technical_SUMMARY_MIWikiAI` v0.5.4 in same bump.

- **v0.5.3 (2026-05-03 morning).** Codifies dispatch-document discipline learned during cycle-3 dispatch attempts on `Common_utilities_API.md v0.3` (2026-05-02 to 2026-05-03). Four new sections: §2.7 prose-vs-VERBATIM consistency obligation (origin: v0.2 silent fabrication of EParamProvenance enum survived 13-reviewer panel because no aspect was explicitly responsible for prose-vs-VERBATIM divergence; discovered only during v0.3 re-verification); §4.5 dispatch-document required contents (10-item list, action-first anti-pattern banned); §4.6 pre-dispatch smoke test required for cycles ≥3 (single Sonnet or Gemini reviewer surfaces gaps before full panel sees them); §4.7 six standard review aspects A-F with Opus-budget allocation rule (Aspects A, B, D = mechanical, Sonnet/Gemini sufficient; C, E, F = judgment, Opus required). Reviewer pool target updated: Claude1-2 Opus + Sonnet1-6 + Gemini1-6 = 14 reviewers, 12 mechanical + 2 Opus, with optional GPT capacity. No semantic changes to v0.5.2 rules; this is purely additive. Companion `Technical_SUMMARY_MIWikiAI` v0.5.3 in same bump.

- **v0.5.2 (2026-05-02).** Two new binding rules learned from cycle-1/cycle-2 experience: §3.5 reviewer source-access protocol (symmetric to Coder §3.3 — reviewer requests source if missing rather than producing finding without verification; cycle-1 Sonnet3-vs-Gemini2 contrast is the origin); §4.4 standardized review-bundle requirement (every `_API.md` cycle-2+ dispatch ships a `<artifact>_review_bundle.zip` with MANIFEST + artifact + self-review + sources + counter + governance, so every reviewer reviews against the same evidence). Both rules bind cycle-3+ on `_API.md` artifacts. Companion `Technical_SUMMARY_MIWikiAI` v0.5.2 in same bump.

- **v0.5.1 (2026-05-01).** Three additive alignments to Organization docs received same day (MTTU_Reviewer v1.22, Reviewer_QRC v1.29, Main_Reviewer_QRC first issuance): §1 inheritance table updated to new doc versions; §1 inheritance table adds Main Reviewer synthesis discipline as inherited (NEW 2026-05-01); §4 explicit cross-reference to Main Reviewer card with Coverage-Matrix-MUST-begin requirement codified for MIWikiAI artifacts. No semantic changes to v0.5 rules; only inheritance pointers and one cross-reference paragraph added. Companion `Technical_SUMMARY_MIWikiAI` v0.5.1 in same bump.
- **v0.5 (2026-05-01, superseded same day).** First issuance. Codifies: 4-label vocabulary (§3); anti-silent-paraphrase P0 rule (§3.2); source-access protocol (§3.3); `_API.md` sibling pattern (§2.2); three-tier escalation (§2.3); counter-pipeline integration contract (§2.4); orthogonal-metadata axes (§2.5, architect Q2 direction); rigid per-symbol template (§2.6); reviewer specifics for software-index pages (§4); advisor consumption rules (§5). Replaces the "QuickRef pending Claude4" placeholder that had been carried in Technical_SUMMARY since v0.1.

---

*MIWikiAI Quick Reference Card v0.5.6 — issued 2026-05-05 evening, superseding v0.5.5 (same day, 11:26 UTC) after 3-Opus approval synthesis (unanimous APPROVE-AS-IS for v0.5.5). v0.5.6 consolidates 8 non-blocking refinements: new §4.0 governance principle + 7 amendments to §§4.11-4.16. No rule semantics changed; no new rules; clarifications and tiebreakers only. Compiled by Claude9 against architect's real v0.5.5 (MD5 ce3e8c99f34065ad95f2928bff6f6dd3). Companion to `Technical_SUMMARY_MIWikiAI_v0_5_5.md` (no Tech_SUMMARY bump needed — v0.5.6 changes are clarification-class). Architect ratification pending.*
