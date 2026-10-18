[GPT1:MIWikiAI] [MIWikiAI] [Official Review Summary] [TOF_SourceOfTruth v0.4] [!] APPROVED_WITH_RELEASE_CONDITIONS

# Official Review Summary — `TOF_SourceOfTruth_v0_4`

**Reviewer:** GPT1:MIWikiAI  
**Project:** MIWikiAI / TOF  
**Date:** 2026-10-17  
**Review type:** official consolidation / internal-baseline approval  
**Target:** `TOF_SourceOfTruth_v0_4_Claude5.md` and generated PDF  
**Additional context:** 2026-10-17 Mattermost discussion with Ruben Shahoyan and Francesco Noferini; TrackReference source-audit review material.

## 1. Executive decision

**Scientific/document content: APPROVED.**

**Internal MIWikiAI commit: APPROVED NOW.**

**Final frozen/self-contained public PDF: NOT YET FROZEN.**  
The remaining issue is packaging/provenance, not a scientific rewrite: several published Run-1/Run-2/Run-3 figures are still external links, and the PDF must be rebuilt after the MIWikiAI commit so that the final commit identity and PDF hash can be recorded.

Therefore:

> **Commit v0.4 now as the working/internal TOF SourceOfTruth baseline. Do not call the present PDF the final frozen archival release.**

No v0.5 scientific rewrite is required before this internal commit.

## 2. Panel synthesis

The independent reviews converge on the scientific content:

- GPT1:MIWikiAI found **0 P0 / 0 P1**, approved v0.4 for commit, and explicitly stated that no content revision is required before committing.
- GPT4:MIWikiAI approved v0.4 as the consolidated scientific/content baseline; its remaining condition concerns the final self-contained PDF/release freeze.
- Claude7:MIWikiAI and Claude5:MIWikiAI, both advisory because of model/drafter overlap, also approved the content while asking for the remaining linked figures to be embedded before the final frozen review artifact.

The apparent disagreement is therefore procedural, not scientific:

- **Can the Markdown be committed as an internal baseline? — YES.**
- **Is the currently uploaded PDF already the final frozen self-contained review artifact? — NO.**

## 3. Relation to the new Mattermost discussion

The new exchange with Ruben Shahoyan and Francesco Noferini does **not** invalidate the SourceOfTruth document. It reinforces why the document must keep different efficiency definitions separate and why the current high-pT efficiency question belongs in the dedicated debugging/MC study.

The discussion now contains three distinct pieces of information:

1. the historical/published Run-1/Run-2 matching-performance material;
2. Francesco's expert factorized estimate,
   `0.96 × 0.94 × 0.90 × 0.85 ≈ 0.69`,
   using MRPC efficiency, PHOS holes, dead space and TRD loss;
3. Marian's historical TrackReference/TOF-tracking recollection, including possible recovery of decays/high-MS tracks with additional TRD information.

These are **not yet one common efficiency definition** and should not be forced into one number.

Francesco's ~70% estimate is valuable and should be recorded in the debugging study as an expert decomposition/hypothesis. It is not yet a new canonical SourceOfTruth value unless its factors and denominator are tied to source/MC evidence.

Likewise, the ~85% historical value should remain explicitly tied to the observable/selection from which it is obtained; it must not be promoted to a universal "ideal TOF matching efficiency."

## 4. TrackReference / MC interpretation

The reviewed TrackReference source audit supports using TrackReferences as the technical basis for a future truth-level efficiency decomposition. It does **not** by itself establish the numerical TOF efficiency.

The next MC study should explicitly decompose, as functions of momentum, species and geometry:

1. **reachability / findability**
   - reaches the TOF radius;
   - crosses active TOF acceptance;
   - produces a TOF hit;
2. **physical losses before TOF**
   - PHOS/open geometry;
   - dead space;
   - TRD/material interactions;
   - weak decays;
   - strong multiple scattering / trajectory deformation;
3. **matching outcome**
   - true TOF association;
   - unmatched but truth-reachable;
   - wrong/fake association;
4. **recoverable categories**
   - TRD-confirmed continuation;
   - kink/decay topology;
   - high-MS trajectories;
   - cases where extra information improves efficiency without an unacceptable fake rate.

This is the correct place to test Marian's old TOF-tracking recollection quantitatively.

## 5. Consistency with the intended document family

The present architecture remains correct:

- `TOF_SourceOfTruth` — stable detector description, literature, definitions, expected and measured performance;
- `TOF_Reconstruction_SourceIndex` — AliRoot/AliceO2/O2Physics implementation and mutable reconstruction parameters;
- `TOF_Matching_Performance_Debugging` — current Run-3 discrepancy, Mattermost hypotheses, MC truth decomposition and parameter studies.

The new Mattermost exchange belongs mainly in the third document, with only a short cross-reference from the SourceOfTruth if desired.

## 6. Required commit status

For the immediate commit, I recommend retaining an explicit working/internal status such as:

```yaml
status: APPROVED_INTERNAL_BASELINE
freeze_status: NOT_FINAL_PUBLIC_RELEASE
next_validation:
  - MC TrackReference efficiency decomposition
  - remaining published-figure embedding
  - post-commit PDF rebuild and hash freeze
```

Do **not** remove currently open `[VERIFY]` / conflict markers merely to make the page look finished.

## 7. Release actions after commit

After the Markdown and figure assets are committed:

1. record the 40-character MIWikiAI commit;
2. rebuild the PDF from that exact committed tree;
3. record the Markdown SHA-256 and final PDF SHA-256;
4. run the repository/link checker from the clean committed tree;
5. embed/cache the remaining key published figures when practical and permitted;
6. freeze a later self-contained PDF without reopening the broad scientific review unless the scientific text changes.

## 8. Final verdict

**[!] APPROVED_WITH_RELEASE_CONDITIONS**

### Approved now

- v0.4 scientific/document content;
- internal MIWikiAI commit;
- use as the temporary/working TOF SourceOfTruth baseline;
- immediate continuation to MC TrackReference efficiency decomposition.

### Not yet claimed

- a final universal numerical TOF matching-efficiency ceiling;
- resolution of the ~70% versus ~85% discussion;
- a quantitatively validated TRD-assisted recovery efficiency;
- final frozen/self-contained public PDF.

**Recommendation:** **commit v0.4 now as an internal approved baseline.**  
Do not rewrite it before the MC study. Use the future TrackReference-based MC study to disentangle the efficiency losses and then revise the SourceOfTruth only where the new quantitative evidence warrants it.

---

**Signed:** GPT1:MIWikiAI  
**Reviewer architecture/model:** GPT-5.6 Sol  
**Date:** 2026-10-17
