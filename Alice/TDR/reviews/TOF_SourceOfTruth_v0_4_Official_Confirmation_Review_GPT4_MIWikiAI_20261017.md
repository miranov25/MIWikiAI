# Official Confirmation Review — `TOF_SourceOfTruth_v0_4`

**Reviewer:** GPT4:MIWikiAI  
**Reviewer architecture/model:** GPT-5.6 Sol  
**Team:** MIWikiAI  
**Date:** 2026-10-17  
**Review type:** Narrow v0.4 confirmation / convergence review  
**Review scope:** Verify that the approved three-candidate consolidation was implemented correctly, check the v0.4 scientific/document boundaries and review artifact, and decide whether v0.4 can be approved as the new TOF SourceOfTruth baseline.

## Inputs reviewed

1. `TOF_SourceOfTruth_Candidate_Comparison_Official_Review_Summary_GPT4_MIWikiAI_20261017.md`
2. `TOF_SourceOfTruth_v0_4_Claude5.md`
3. `TOF_SourceOfTruth_v0_4_Claude5.pdf`
4. The PPR Vol. II TOF material already supplied in this review cycle, used for a narrow independent cross-check of the matching/PID definitions and the P1-01 correction.

### Artifact fingerprints independently checked

- v0.4 Markdown SHA-256: `b0d1f8168da64cf2b4432d63029e39b9f4302a22ae6d9166efff6e095e7052f1`
- v0.4 PDF SHA-256: `7ea08416cdfc633d6aee8121152f6145b93517ec625da6b43a7f80d8cbe981fc`
- Prior GPT4 comparison-review SHA-256: `3d9cffdaf539de1c98c03a4eb9c2fbef39a1787ca775c55cb9e07f59515066c5`

The Markdown SHA-256 agrees with the source SHA-256 printed on the v0.4 PDF identity page.

## Executive verdict

**[!] APPROVED_WITH_RELEASE_CONDITIONS**

I approve **`TOF_SourceOfTruth_v0_4` as the consolidated scientific/content baseline**. The v0.4 merge is successful and implements the important corrections and document-boundary decisions from the previous official review.

I do **not** yet approve the currently uploaded PDF bytes as the final canonical review/release artifact, because the previous P1-04 requirement is only partially closed: the PDF still contains linked placeholders for several published Run-1/Run-2/Run-3 figures that were explicitly required to be embedded for the self-contained review artifact, and the source is still marked as not yet committed.

This is **not a request for another scientific rewrite or a v0.5**. The remaining work is a mechanical release/freeze step. After the required figures are embedded, the committed source is used to rebuild the PDF, and the commit/PDF hash are recorded, **v0.4 may be frozen without restarting the broad scientific review**.

## Confirmation against the four required corrections

### P1-01 — Correct the PPR-II “85%” attribution

**PASS.**

The error identified in the GPT1 donor candidate has been corrected cleanly. v0.4 explicitly separates:

- **algorithmic PID efficiency** — PPR Fig. 5.108, where the report text states that kaon/proton efficiencies are generally lower and “at most 85%”; and
- **overall PID efficiency** — PPR Fig. 5.109, where tracking, dead space, decays/interactions, matching and PID are combined and the kaon/proton efficiencies are much lower.

The source text, Fig. 4.7/4.8 captions, §7.1 taxonomy and the “three different 85%” explanation are mutually consistent. I independently rechecked the relevant PPR Vol. II text in this review cycle; the v0.4 attribution is correct.

### P1-02 — Enforce the three-document architecture

**PASS.**

The v0.4 front matter and opening section now make the split explicit:

1. `TOF_SourceOfTruth` — stable literature-backed detector/physics/performance facts;
2. `TOF_Reconstruction_SourceIndex` — software implementation and mutable parameters;
3. `TOF_Matching_Performance_Debugging` — the current 2025/2026 investigation.

The mutable `qaMatchEff` reconnaissance and detailed 2026 debugging material have been removed from the SourceOfTruth. §7.6 retains only a short motivation, a simple two-track-efficiency consequence, and a pointer to the debugging document. That is an acceptable stable-context boundary and does not reopen the previous scope problem.

### P1-03 — Keep the Run-3 trigger/matching-window discrepancy unresolved

**PASS.**

v0.4 records all three conflicting presentations (text definition, 28.8 µs caption value, 29.8 µs diagram value), explicitly refuses to choose one, corrects the earlier wrong orbit arithmetic, and moves the authoritative resolution to the readout configuration/authors. Appendix A.6 is correctly treated as a consistency check, not as a mechanism for overriding the source.

### P1-04 — One self-contained review PDF with artifact identity

**PARTIAL — RELEASE BLOCKER, NOT A SCIENTIFIC BLOCKER.**

The artifact handling is substantially improved:

- one PDF exists;
- the PDF has an identity page;
- the exact source SHA-256 is printed and independently matches the uploaded Markdown;
- generation date and figure counts are stated;
- the figure manifest is present;
- all locally held PPR/derived figures are embedded;
- the PDF renders cleanly across all 27 pages with no observed clipping or broken layout.

However, the PDF itself states that **17 figures are embedded while 12 published ALICE figure images remain links**, and pages 6, 9, 17–19 and 21 visibly contain “Published ALICE figure — not embedded in this PDF” placeholders. These include Run-3 timing/calibration figures and the Run-1/Run-2 matching-reference figures. The prior official review explicitly required the key measured-performance figures needed for scientific judgement to be embedded before final approval.

Also, the identity page states **“MIWikiAI commit: not yet committed”**. This must be replaced by the committed source identity in the freeze artifact. The PDF SHA-256 may remain external to the PDF, but it must be recorded in the release/review manifest.

## Answers to the v0.4 confirmation-review questions

1. **Design / MC / measured separation:** **PASS.** The labels and narrative are consistently separated, including the summary plot and measurement-chain figure.
2. **“At most 85%” only for algorithmic PID efficiency:** **PASS.** This is now explicit and correctly separated from overall PID efficiency.
3. **PPR matching contamination / wrong-association semantics:** **PASS.** The definitions, two contamination sources, own-secondary statement, and recovery-step discussion agree with the PPR material checked in this review.
4. **Run-1/Run-2 matching definitions and 0.8–0.85 plateau:** **PASS WITH OPEN READ-OFF.** The denominator definitions are clear, and the plateau is explicitly marked as a reading still requiring figure-level verification rather than being promoted to a settled number.
5. **Run-2 84 ps → 56 ps attribution:** **PASS.** v0.4 distinguishes the earlier calibration from the channel-by-channel calibration and does not disguise the unresolved “50% improvement” wording.
6. **Run-3 74.7 ± 2.3 ps treatment:** **PASS.** It is presented as one estimator among the tabulated methods, not as a universal detector number.
7. **CONFLICT-3 without forced resolution:** **PASS.** Correctly left open.
8. **SourceOfTruth / SourceIndex / Debugging boundary:** **PASS.** No material scope regression found. The remaining §7.6 motivation is acceptable.
9. **Read-off values versus figures:** **PASS for the embedded PPR figures within the stated read-off precision.** The externally linked Run-1/2/3 figures cannot receive the same self-contained figure-level confirmation until they are embedded.
10. **Identity page / review manifest sufficiency:** **PARTIAL.** Source hash and figure counts are good; the missing committed MIWikiAI identity and final PDF hash in the manifest remain to be closed.

## Additional review observations

### Scientific/document quality

The consolidation is materially better than any of the three donor candidates. In particular:

- Fig. 1.1 makes the denominator problem visually explicit and is worth keeping;
- the efficiency taxonomy in §7.1 prevents the common “TOF efficiency = X%” ambiguity;
- the PPR expected-performance section now separates matching efficiency, contamination, per-primary matching and overall PID efficiency correctly;
- the Run-1/Run-2/Run-3 narrative is compact without collapsing incompatible definitions;
- unresolved claims remain visibly tagged instead of being silently normalized;
- the literature read-depth table and closure-check appendix are appropriate for MIWikiAI SourceOfTruth governance.

### Open scientific items do not block v0.4 baseline approval

`CONFLICT-1`, `CONFLICT-3`, `CONFLICT-7`, the Run-1/Run-2 plateau read-offs, and the remaining `[VERIFY]` items are clearly disclosed. They are legitimate open items, not hidden contradictions. v0.4 is suitable to serve as the working SourceOfTruth baseline while those are resolved in later controlled revisions.

### Minor non-blocking artifact observation

The PDF metadata timestamp and the human-readable generation timestamp appear to use different timezone conventions. This does not affect the scientific content or byte identity, but the final reproducible build should ideally normalize the build timezone/metadata for cleaner provenance.

## Required release/freeze actions

Before declaring the **PDF artifact** canonical, perform only the following bounded steps:

1. Embed the key published ALICE figures currently represented as links, at minimum the Run-1/Run-2 matching-reference figures and the Run-3 timing/calibration figures needed to judge the corresponding statements.
2. Commit the v0.4 Markdown and figure set to MIWikiAI.
3. Rebuild the PDF from that exact commit without changing scientific content.
4. Record the commit identity, source SHA-256 and final PDF SHA-256 in the review/release manifest.
5. Perform a mechanical render check of the rebuilt PDF. A new broad scientific review is **not required** unless the content changes.

## Approval decision

**Scientific/content merge:** **APPROVED**  
**v0.4 as the new MIWikiAI TOF SourceOfTruth baseline:** **APPROVED**  
**Current uploaded PDF as final canonical release artifact:** **APPROVED CONDITIONALLY — freeze after P1-04 mechanical closure**  
**Need for v0.5 before using v0.4 as the baseline:** **NO**

The next substantive work can proceed from v0.4. The document should not return to a three-candidate comparison.

---

**Signed:** GPT4:MIWikiAI  
**Reviewer architecture/model:** GPT-5.6 Sol  
**MIWikiAI official v0.4 confirmation review**  
**2026-10-17**
