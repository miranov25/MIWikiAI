# Cycle-3 review of `Common_utilities_API.md` v0.3 — what to do

**Governance:** Bound to `MIWikiAI_Quick_Reference_Card_v0_5_4.md` (in `governance/` of the bundle). You should have already received and read v0.5.4 before this prompt — confirm to architect if not.

This prompt operates under v0.5.4 §4.7 (three-dimensional review assignment), §4.8 (2+2+1 deep section coverage), §4.9 (convergence handling), §4.10 (sprint cap = 5).

**Reviewer pool:** Sonnet1-Sonnet6, Gemini1-Gemini6, Opus1-Opus3 (15 reviewers total) + Main Reviewer (TBD, separate). All reviewers find their own assignments in §0 below.

---

## §0. Reviewer assignment table — find your row

Every reviewer below owns 4-5 sections. **Read the entire artifact for context, then deep-validate your owned sections** (follow every link in those sections, verify every [VERBATIM] citation against source, run aspect-checks on every line).

Each owned section has 5 reviewers in total: **2 Sonnet + 2 Gemini + 1 Opus** (per QRC v0.5.4 §4.8). Convergence rules per §4.9.

**Section catalog (14 natural sections of v0.3):**

| ID | Document section | Approx. line range in artifact |
|---|---|---|
| S1 | §1 Purpose & scope + §2 Counter signals legend (incl. orthogonal axes) | 180-253 |
| S2 | §3 Family overview (3 classes, control/data plane) | 254-283 |
| S3 | §4 `ConfigurableParam` — base class + EParamProvenance enum + F1+F2 | 286-345 |
| S4 | §4 `ConfigurableParamHelper` — CRTP base + final overrides + F3+F4 | 346-412 |
| S5 | §4 `ConfigurableParamPromoter` — Promoter variant + SimConfig FABRICATED example | 413-457 |
| S6 | §4 `Instance` — ambiguous symbol disambiguation + worked examples | 458-518 |
| S7 | §4 `getName` — sKey accessor + O2ParamDef macro + FABRICATED example | 519-593 |
| S8 | §4 `updateFromString` — CLI override entry point + impl + worked examples | 594-655 |
| S9 | §4 `setValue` — string-key + templated overload + getValueAs<T> inline | 656-760 |
| S10 | §4 `writeINI` — persistence + impl + worked examples | 761-820 |
| S11 | §4 `printKeyValues` — virtual + CRTP overrides + ambiguous | 821-882 |
| S12 | §4 `getProvenance` — diagnostic + FABRICATED example | 883-915 |
| S13 | §4 `printAllKeyValuePairs` — registry dump + FABRICATED example | 916-958 |
| S14 | §5 Failure-mode summary index + §6 Cross-references | 959-984 |

### Section-by-section owner table (5 reviewers per section)

| Section | Sonnet pair | Gemini pair | Opus |
|---|---|---|---|
| S1 | Sonnet1, Sonnet2 | Gemini3, Gemini4 | Opus1 |
| S2 | Sonnet3, Sonnet4 | Gemini5, Gemini6 | Opus2 |
| S3 | Sonnet5, Sonnet6 | Gemini1, Gemini2 | Opus3 |
| S4 | Sonnet1, Sonnet3 | Gemini2, Gemini4 | Opus1 |
| S5 | Sonnet2, Sonnet4 | Gemini1, Gemini5 | Opus2 |
| S6 | Sonnet1, Sonnet5 | Gemini1, Gemini3 | Opus3 |
| S7 | Sonnet3, Sonnet5 | Gemini4, Gemini6 | Opus1 |
| S8 | Sonnet4, Sonnet6 | Gemini2, Gemini6 | Opus2 |
| S9 | Sonnet2, Sonnet6 | Gemini3, Gemini5 | Opus3 |
| S10 | Sonnet1, Sonnet4 | Gemini2, Gemini5 | Opus1 |
| S11 | Sonnet3, Sonnet6 | Gemini3, Gemini6 | Opus2 |
| S12 | Sonnet2, Sonnet5 | Gemini1, Gemini4 | Opus3 |
| S13 | Sonnet4, Sonnet5 | Gemini4, Gemini5 | Opus1 |
| S14 | Sonnet1, Sonnet6 | Gemini1, Gemini6 | Opus2 |

### Per-reviewer ownership — find your row

| Reviewer | Sections owned | Count |
|---|---|---|
| **Sonnet1** | S1, S4, S6, S10, S14 | 5 |
| **Sonnet2** | S1, S5, S9, S12 | 4 |
| **Sonnet3** | S2, S4, S7, S11 | 4 |
| **Sonnet4** | S2, S5, S8, S10, S13 | 5 |
| **Sonnet5** | S3, S6, S7, S12, S13 | 5 |
| **Sonnet6** | S3, S8, S9, S11, S14 | 5 |
| **Gemini1** | S3, S5, S6, S12, S14 | 5 |
| **Gemini2** | S3, S4, S8, S10 | 4 |
| **Gemini3** | S1, S6, S9, S11 | 4 |
| **Gemini4** | S1, S4, S7, S12, S13 | 5 |
| **Gemini5** | S2, S5, S9, S10, S13 | 5 |
| **Gemini6** | S2, S7, S8, S11, S14 | 5 |
| **Opus1** | S1, S4, S7, S10, S13 | 5 |
| **Opus2** | S2, S5, S8, S11, S14 | 5 |
| **Opus3** | S3, S6, S9, S12 | 4 |
| **Main Reviewer** | (synthesis only — see §9) | — |

If your ID is not in the table above, the architect did not assign you. Do not produce a report.

**Use the ID assigned to you above.** Do not sign your report as a model name (e.g. `ClaudeOpus47`, `Claude Sonnet 4.5`, `Gemini 3 Pro`). Identity drift to model strings is a P0 governance violation per QRC v0.5.4 §1.

**If the bundle is incomplete** (missing MANIFEST, missing source files needed for verification, missing `governance/MIWikiAI_Quick_Reference_Card_v0_5_4.md`): do NOT produce normal review. Save a `[X] BLOCKED — bundle incomplete` report to the path in §7. Notify architect.

### Opus role on owned sections (per QRC v0.5.4 §4.7)

Opus reviewers (Opus1, Opus2, Opus3) read the Sonnet/Gemini findings on each owned section first, then focus on judgment-aspect work: aspects C (prose-vs-VERBATIM consistency), E (FABRICATED example plausibility), F (failure-mode semantics). **Opus does not replicate mechanical aspect-A/B/D work** — that is what the Sonnet/Gemini pairs do. Opus asks: *"do these mechanical facts add up to a semantic claim the prose is making?"* That is the §2.7 prose-vs-VERBATIM check applied at section ownership.

---

## §1. What you are reviewing

`artifact/Common_utilities_API.md` (v0.3) — a software-API reference page for the ConfigurableParam family in AliceO2. ~984 lines, governance-bound to MIWikiAI_QRC v0.5.4 (§2.6 per-symbol template, §3 label vocabulary, §2.7 prose-vs-VERBATIM consistency, §3.5 reviewer source-access).

## §2. What you must produce

**One markdown file**, named:

```
Common_utilities_API_v0_3_Review_<YourID>.md
```

Saved to the path in §7. Use the template in §6.

Maximum **5 findings** (sprint cap raised per §4.10 because you own multiple sections — was 3 in dimension-only cycles).

## §3. Steps

1. **Find your row in §0 above.** Note your owned sections.
2. **Read the entire artifact once**, top to bottom (~984 lines, ~25 minutes). This is for context — do not deep-validate yet.
3. **Read `governance/MIWikiAI_Quick_Reference_Card_v0_5_4.md`** §2.6, §2.7, §3, §3.5 if you have not already. These are the binding rules you check against.
4. **Read `preprocessed/summary.txt` and the four `preprocessed/<check>.txt` files** — the prefilter has already done mechanical verification across the entire artifact. See §3.5 below.
5. **For each owned section:** run the deep-validation checks in §4 below. Follow every link in your owned sections. The prefilter results from step 4 tell you which mechanical aspects are already verified globally; spend your effort on the judgment-aspect work and on owned-section-specific deep validation.
6. **Pick your top 5 findings** across all owned sections (sprint cap = 5 per §4.10). Drop lower-priority items if you have more.
7. **Write the report** using the template in §6.
8. **Save it** to the path in §7. Notify the architect when complete.

---

## §3.5 How to use the prefilter results in `preprocessed/`

The bundle ships with `preprocessed/` containing four pre-flight check outputs and a summary. **The prefilter has already done all the mechanical verification work that previous cycles required reviewers to repeat 14 times.** Use it.

### What the prefilter has already done for you

`preprocessed/summary.txt` — one line per check, PASS / FAIL / SKIP:

```
=== Pre-flight summary ===
Tool: prepare_review.py v1.1
PASS: anchor_check
PASS: verbatim_check
PASS: counter_check
PASS: prose_fabrication_check
```

The four detail files contain the evidence:

| File | What was verified | If PASS, you can skip |
|---|---|---|
| `preprocessed/anchor_check.txt` | Every `[label](#anchor)` link resolves to a heading slug in the artifact | Aspect-A anchor verification globally |
| `preprocessed/verbatim_check.txt` | Every `[VERBATIM <path>:Lx-Ly]` cites a real source file with valid line range | Aspect-B path-and-range verification globally |
| `preprocessed/counter_check.txt` | Every `**Signal:** prod_usage_count=N, workflows_direct=M, churn_12m=K` matches `usage.csv` for the owning symbol heading | Aspect-D global counter cross-check |
| `preprocessed/prose_fabrication_check.txt` | Known-fabricated identifiers (cycle-2 EParamProvenance class: kCCDBPRIO, kRTF, kEXIM) are absent from main body. Front-matter occurrences (revision_history) are correctly classified as disclosure. | Aspect-C global fabrication scan for the cycle-2 class |

### What the prefilter does NOT do (this is your job)

The prefilter is mechanical. It cannot do judgment work. **For your owned sections**, you still need to:

- **Aspect-B character-level diff** — the prefilter confirms the cited line range exists; **you** verify the quoted code matches the source character-for-character (whitespace, comments, line breaks). This catches CONV-A2-class cross-file substitution defects.
- **Aspect-C semantic prose-vs-VERBATIM** — the prefilter catches the *known* fabrication term list. **You** read the prose paragraphs above and below each [VERBATIM] block and judge whether the prose extends, generalizes, or contradicts the block (per QRC v0.5.4 §2.7). New fabrication classes get caught here.
- **Aspect-D wider-grep verification** for `[VERIFY-*-wider-grep]` flagged symbols — counter pipeline can have known blind spots; the prefilter trusts `usage.csv`. **You** run wider greps where the artifact flagged uncertainty.
- **Aspect-E [FABRICATED] example plausibility** — the prefilter doesn't parse FABRICATED examples. **You** judge plausibility per QRC §3.4 (correct / mildly off / implausible).
- **Aspect-F failure-mode semantics** — the prefilter doesn't read failure-mode text. **You** verify F1-F5 descriptions match actual failure semantics in source and that labels (VERIFIED/PARAPHRASE/ARCHITECT-MARIAN-VERIFIED) are correct.

### How to read each prefilter file

**If the file says PASS:** the global mechanical verification is complete for that aspect. You do not re-run it. Cite the prefilter result in your report's Validation log:
> *"Aspect-A anchor verification: relied on prefilter `preprocessed/anchor_check.txt` (PASS, X anchor links scanned)."*

**If the file says FAIL:** the prefilter found candidate findings. Read the file, identify the lines, **verify the finding yourself** (the prefilter can be wrong), and if confirmed, include it in your report citing the prefilter as discovery source. Sprint cap of 5 still applies.

**If the file says SKIP:** the prefilter could not check (typically because source root was unavailable). Do the verification manually for owned sections.

### What this means for your time budget

Without prefilter, each reviewer spent ~10-15 min on mechanical Aspect-A/B/D checks. With prefilter, **that work is done once globally**. Spend the saved time on Aspect-C/E/F judgment work in your owned sections, where the prefilter cannot help.

> *Per QRC v0.5.5 §4.11 (proposed prefilter ratchet rule): mechanical checks live in the prefilter, not the panel. If you find yourself re-running anchor/VERBATIM-path/counter-signal verification globally that the prefilter already did, you are duplicating retired work.*

---

## §4. Deep-validation checks for owned sections

Apply ALL six aspect-checks to every owned section (per QRC v0.5.4 §4.7 aspect taxonomy). The Opus reviewer on each section focuses on aspects C, E, F (judgment); Sonnet/Gemini reviewers cover all six but prioritize A, B, D (mechanical). All five reviewers per section produce findings, then §4.9 convergence rules apply.

**For mechanical aspects A, B, D (Sonnet/Gemini priority):** the prefilter has done the global cross-check (per §3.5). Your job is owned-section-specific validation only — verify the citations / claims relevant to your owned sections are correct, with the prefilter result as your starting point.


### A — Document structure

For your owned sections only:

1. Front-matter consistency: do front-matter fields (`upstream:`, `known_verify_flags:`, `peer_reviewers_assigned:`, `revision_history:`) reference the section content correctly?
2. Anchor mechanics: do `#anchor` cross-links FROM your owned section, or TO your owned section from elsewhere, resolve correctly? (test: GitHub markdown lowercases heading text, replaces spaces with `-`, strips backticks for the anchor)
3. Heading depth and structure: §4 entries are `###` (level 3); subsections like `getValueAs<T>` inside `setValue` are `####` (level 4). Verify your owned `###` sections are at the right level.
4. Cross-reference reachability: every "See also: ..." link in your owned sections points to a real heading.

### B — VERBATIM citation accuracy

For every `[VERBATIM <path>:L<line>]` block in your owned sections:

```bash
unzip source/common_utils.zip -d /tmp/cu/
unzip source/cp_callers.zip -d /tmp/ca/

# Example: verify §4 ConfigurableParam (S3) at L139-L156
sed -n '139,156p' /tmp/cu/Common/Utils/include/CommonUtils/ConfigurableParam.h
```

1. Open the cited source file. Verify the quoted code matches at the cited line range character-exact (whitespace, comments, line breaks).
2. If line offset by ≥3 lines → P1 finding (line drift). If content differs from source → P0 finding (broken citation).
3. **Specific high-priority verifications** (cycle-3 stakes — see §5 below):
   - S3 (ConfigurableParam) Signature block at L139-L156: enum has exactly 3 values `kCODE`, `kCCDB`, `kRT`. If you see `kRTF`, `kCCDBPRIO`, or `kEXIM` in the [VERBATIM] block → **P0 finding**.
   - S5 (ConfigurableParamPromoter) Signature at L208-L215: template parameters are `<typename P, typename Base>` — P first. → **P0** if reversed.
   - S7 (getName) macro at L324-L336: `static constexpr char const* const sKey = key;`. → **P0** if shown as `static std::string`.

### C — Prose-vs-VERBATIM consistency (per QRC v0.5.4 §2.7)

**Critical for Opus reviewers; required for all reviewers.** This is the cycle-2 silent-fabrication detection gap.

For every [VERBATIM] block in your owned section: read the 3-5 prose paragraphs immediately above and below. Ask: **does the prose say anything that the [VERBATIM] block does not say?**

1. Numeric extension: prose says "6 values" when [VERBATIM] shows 3 → P0
2. Naming extension: prose names `kCCDBPRIO` when [VERBATIM] shows only `kCODE`, `kCCDB`, `kRT` → P0
3. Type description extension: prose calls something a `std::string` when [VERBATIM] shows `const char*` → P1
4. Behavioral extension: prose describes a mechanism (e.g. "CCDB priority flips that") when [VERBATIM] does not show that mechanism → P0 if architectural claim, P1 if commentary

**Specific cycle-3 stakes (re-check even if S3 is not your owned section):** v0.2 prose claimed `EParamProvenance` had 6 values listing kRTF/kCCDBPRIO/kEXIM. v0.3 corrected. Verify NO prose anywhere in the artifact mentions kRTF, kCCDBPRIO, or kEXIM:

```bash
grep -n "kCCDBPRIO\|kRTF\|kEXIM" /tmp/cu/Common/Utils/include/CommonUtils/ConfigurableParam.h
# Should return ZERO matches in source.

grep -n "kCCDBPRIO\|kRTF\|kEXIM" artifact/Common_utilities_API.md
# Should return ZERO matches in v0.3 (only mentions in revision_history / cycle-0 self-review where the deletion is documented).
```

If you find these names asserted in prose as if they exist → P0.

### D — Counter signals

For your owned sections:

1. Verify `prod_usage_count`, `workflows_direct`, `churn_12m` figures shown in your sections match `counter/usage.csv` and `counter/breakdown.tsv`:
   ```bash
   grep "^ConfigurableParam," counter/usage.csv
   grep "^ConfigurableParam	" counter/breakdown.tsv | head -10
   ```
2. Top-callers tables in your owned sections match the breakdown.tsv top-N rows.
3. **For S13 (printAllKeyValuePairs):** prod_usage_count=0 is flagged `[VERIFY-printAllKeyValuePairs-wider-grep]`. Run the wider grep:
   ```bash
   grep -rn "printAllKeyValuePairs" /tmp/ca/ /tmp/cu/
   ```
   If real callers exist, prod_usage_count=0 is wrong → P1. If no real callers, the 0 is correct.

### E — Worked examples (FABRICATED + VERBATIM)

For your owned section:

1. Every `[VERBATIM]` worked example: extract source, verify match at cited line.
2. Every `[FABRICATED — illustrative only]` worked example: judge plausibility per QRC §3.4 (correct / mildly off / implausible).
3. **The 4 [FABRICATED] examples in v0.3 (per cycle-0 self-review):**
   - S5 (Promoter) at line ~442 — SimConfig pattern. Cross-check: `Common/SimConfig/src/SimConfig.cxx` (not in bundle — note as "could not verify" if so).
   - S7 (getName) at line ~577 — `auto name = p->getName();`. **Verify it says `auto`, not `auto&` (CONV-7 fix). If still `auto&` → P0** (does not compile, returns rvalue).
   - S12 (getProvenance) at line ~900 — typical CLI pattern. Cross-check real call sites at `ConfigurableParam.cxx:L458, L543`:
     ```bash
     sed -n '455,465p;540,550p' /tmp/cu/Common/Utils/src/ConfigurableParam.cxx
     ```
   - S13 (printAllKeyValuePairs) at line ~943 — workflow-init dump.

**Bonus (Opus reviewers especially):** if you find a real production caller for any FABRICATED example, propose promoting it to [VERBATIM] in your report.

### F — Failure modes (F1-F5)

For your owned sections (especially S3, S4, S14):

1. F1 (link-error / missing O2ParamImpl) at S3 — verify against macro at `ConfigurableParam.h:L324-L339`.
2. F2 (CCDB / CLI override-priority) at S3 — REWRITTEN in v0.3. Verify "last write wins by call order" is consistent with `setValue` impl at `ConfigurableParam.cxx:L225-L237` and `fromCCDB` semantics. **kCCDBPRIO must NOT appear** → P0 if it does.
3. F3 (silent serialization drop) at S4 — verify `[ARCHITECT-MARIAN-VERIFIED]` label.
4. F4 (CRTP type mismatch) at S4 — verify against helper template at `ConfigurableParamHelper.h:L77-L85`.
5. F5 (CCDB-late-arrival timing) at S14 — three labeled bullets (Symptom = VERIFIED, Probable mechanism = PARAPHRASE, Mitigation = VERIFIED). Verify labels are correct per CONV-3 fix. → P1 if labels missing/wrong.

### Source-extraction needed?

| Aspect | Need to extract source? |
|---|---|
| A — Structure | No, artifact only |
| B — VERBATIM | **Yes** (extract `source/common_utils.zip` and `source/cp_callers.zip`) |
| C — Prose-vs-VERBATIM | Yes (same extraction as B) |
| D — Counter signals | Counter files in `counter/` only; optional source extract for §13 wider-grep |
| E — Worked examples | **Yes** (same extraction as B) |
| F — Failure modes | **Yes** (`common_utils.zip`) |

If you only own sections that need no source (very rare in this cycle), say so in your validation log.

---

## §5. Cycle-3 stakes you should know

v0.3 corrected three substantive silent fabrications from v0.2 that no cycle-2 reviewer caught:

1. **EParamProvenance enum: 3 values, not 6.** kRTF, kCCDBPRIO, kEXIM did not exist in source. Affects S3.
2. **ConfigurableParamPromoter parameter order:** `<P, Base>` not `<Base, P>`. Affects S2 + S5.
3. **O2ParamDef sKey type:** `static constexpr char const* const`, not `static std::string`. Affects S7.

These corrections are the v0.3 substance under review. **Treat S2, S3, S5, S7 as fresh content** — do not assume cycle-2 approval carries over to these sections. If any of the three fabrications still appears in v0.3 prose anywhere, **P0 finding** — call it out.

---

## §6. Report template (copy this, fill it in, save it)

```markdown
[<YourID>] [MIWikiAI] [Reviewer] [Common_utilities_API_v0.3] [<verdict>]

# Cycle-3 review of Common_utilities_API.md v0.3
**Reviewer:** <YourID>
**Owned sections:** <list from §0 of this prompt>
**Date:** 2026-05-XX
**Verdict:** [OK] | [!] | [X]

## 1. Whole-document findings (advisory cross-section)
<Anything noticed during full-document read that is outside owned sections.
Or "None.">

## 2. Owned-section findings (max 5 total across all owned sections)

### Finding 1 [P<N>] — Section S<N>
**What:** <what is wrong>
**Where:** §<heading> at line <range> of artifact (or `path:Lline` for source-side claims)
**Aspect:** <A | B | C | D | E | F>
**Evidence:** <what you fetched/checked to confirm>
**Recommendation:** <what should change in v0.4>

### Finding 2 [P<N>] — Section S<N>
...

(Up to Finding 5)

## 3. Validation log

### Prefilter usage (per §3.5 of dispatch prompt)
- `preprocessed/summary.txt` read: <yes/no>
- `anchor_check.txt`: <PASS / FAIL / SKIP> — relied on globally: <yes/no>
- `verbatim_check.txt`: <PASS / FAIL / SKIP> — relied on for path-and-range globally: <yes/no>; character-level diff done in owned sections: <yes/no>
- `counter_check.txt`: <PASS / FAIL / SKIP> — relied on globally: <yes/no>
- `prose_fabrication_check.txt`: <PASS / FAIL / SKIP> — relied on for cycle-2 term list globally: <yes/no>; semantic Aspect-C done in owned sections: <yes/no>

### Per-section coverage
For each owned section, briefly state:
- Aspects checked: A, B, C, D, E, F (or subset, with reason)
- Source files extracted/fetched: <list>
- [VERBATIM] citations re-verified character-for-character: <count> of <total in section>
- [FABRICATED] examples cross-checked: <count> of <total in section>
- Counter signals: deferred to prefilter (<yes/no>) or re-checked locally (<yes/no, why>)

### Bundle integrity
- MIWikiAI_QRC v0.5.4 read: <yes/no>
- Source ZIPs extracted: <yes/no>
- Counter files used: <yes/no>

## 4. Summary
<3-line summary of findings and verdict.>

## 5. Red-team source fetch disposition
<Files fetched from source/ for verification, plus any external sources consulted.
If none beyond bundle, say "Bundle contents only.">

## 6. Convergence note (if applicable)
<If during review you noticed your finding aligns with a finding another reviewer is likely to make on the same section (e.g. an obvious P0), say so. Helps Main Reviewer's §4.9 convergence accounting.>
```

---

## §7. Where to send your report

Save: `/Users/miranov25/github/MIWikiAI/Alice/code/O2/reviews/Common_utilities_API_v0_3_Review_<YourID>.md`

Notify the architect (Marian) when complete.

## §8. Deadlines

- **Reviewers (15 of you):** 24 hours from dispatch
- **Main Reviewer:** 48 hours from dispatch (24h after reviewer deadline)

Architect overrides at dispatch time if different.

---

## §9. If you are the Main Reviewer

**Where you find the 15 reviewer reports:** the architect drops them all into `/Users/miranov25/github/MIWikiAI/Alice/code/O2/reviews/` before notifying you. Read every file matching `Common_utilities_API_v0_3_Review_*.md`. Count must equal 15 (the dispatch count). If less, issue `[X] BLOCKED — only K of 15 reports received` and stop.

You produce one file:

`PHASE_0_2_Pilot_CommonUtilsAPI_v0_3_Cycle3_OfficialReviewSummary.md`

Saved to the same `/reviews/` directory. Required structure per QRC v0.5.4 + Main_Reviewer_QRC:

1. **Coverage Matrix** (FIRST element). Rows = 15 reviewers. Columns: ReviewerID, Sections owned, Verdict, # findings reported, Cited in synthesis (yes/no with finding IDs).

2. **Per-section convergence table** (per §4.9). For each section S1-S14, list all findings from the 5 owners. Apply §4.9 convergence rules:
   - 3-of-5 converge → CONV-N entry
   - 2-of-5 with Opus dissent → UNCERTAIN-N (defer to architect)
   - 2-of-5 without Opus dissent → "spot-check" tag
   - 1-of-5 with verbatim source backing → CONV-equivalent
   - 1-of-5 without source backing → P2 advisory, "single-reviewer" tag

3. **Cross-section synthesis:** convergent findings spanning multiple sections (e.g. labeling errors, structural issues).

4. **Architect-Originated Concerns** (separate section if applicable).

5. **Verdict + ratification packet:** ratify v0.3 / require v0.4 / require v0.4 with named blockers.

**Anti-truncation rule:** every dispatched reviewer must appear in the Coverage Matrix AND be cited in the synthesis body (per §4.9 disposition). If you can't synthesize all 15 reports in available context, issue `[X] BLOCKED — context exhausted, multi-pass required` rather than silently dropping reports. Cycle-1 and cycle-2 v1 both hit this; do not be the third.

**Sprint cap = 5** for cycle-3 reviewers (§4.10). Convergent findings (≥3 reviewers) elevate to CONV regardless. Single-reviewer findings stay P2 unless verbatim-source-backed.

---

End of cycle-3 dispatch prompt. Quota: no session-block signals observed (Coder side).
