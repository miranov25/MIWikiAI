# DISPATCH — Cycle-3 review of `Common_utilities_API.md` v0.3

**This is the only document you need.** Two sections: what you run, what you send.

---

## §1. What you run

Three commands. Copy-paste, no edits needed.

```bash
# 1. Install v1.1 of the prefilter (one-time, only if you haven't already)
cd /Users/miranov25/github/MIWikiAI
unzip -o /path/to/prepare_review_v1_1.zip
pip install --break-system-packages mistletoe pytest

# 2. Verify v1.1 by running self-tests (one-time)
bash scripts/prepare_review.sh --test
# Expected: 14 passed

# 3. Build the reviewer bundle
rm -rf reviewer_bundle/
bash scripts/prepare_review.sh \
    --artifact Alice/code/O2/Common_utilities_API.md
```

**Expected final output:**

```
=== Pre-flight summary ===
Tool: prepare_review.py v1.1
PASS: anchor_check
PASS: verbatim_check
PASS: counter_check
PASS: prose_fabrication_check

RESULT: all pre-flight checks PASS. Bundle ready for dispatch.
Bundle: reviewer_bundle/Common_utilities_API_review_bundle.zip
```

If you see anything other than 4× PASS, **stop** and paste the output to Claude9. Don't dispatch.

---

## §2. What you send to each reviewer

Send these two attachments to each of the 15 reviewers (Sonnet1-Sonnet6, Gemini1-Gemini6, Opus1-Opus3):

**Attachments:**
1. `reviewer_bundle/Common_utilities_API_review_bundle.zip`
2. `PHASE_0_2_Pilot_CommonUtilsAPI_v0_3_ReviewerPrompts.md` (the dispatch prompt I produced earlier — you have it in `/mnt/user-data/outputs/`)

**Message body** (copy-paste this exactly, replacing `<YourID>`):

> Hi <YourID>,
>
> Cycle-3 review of `Common_utilities_API.md` v0.3.
>
> Two attachments:
> 1. `Common_utilities_API_review_bundle.zip` — extract this; contains artifact + governance + counter + source + preprocessed/ pre-flight checks
> 2. `PHASE_0_2_Pilot_CommonUtilsAPI_v0_3_ReviewerPrompts.md` — the dispatch prompt; **read this first** to find your section assignments
>
> All 4 prefilter checks PASSED — preprocessed/summary.txt confirms. You can trust:
> - All anchor links resolve
> - All [VERBATIM] citations match source
> - All Signal-block counter signals match usage.csv
> - No fabricated identifiers in main prose
>
> The cycle-2 EParamProvenance fabrication (kRTF, kCCDBPRIO, kEXIM) is fixed in v0.3.
> Confirmation: `preprocessed/prose_fabrication_check.txt` shows 3 occurrences in
> `revision_history:` front-matter only — these document the fix, not assertions.
>
> **Find your row in §0 of the dispatch prompt for your section assignments.**
> Sprint cap: 5 findings. Save your report to `Alice/code/O2/reviews/Common_utilities_API_v0_3_Review_<YourID>.md`.
> Deadline: 24 hours.
>
> Reply "received" when bundle extracts cleanly.

---

## §3. If reviewers ask questions you don't want to answer

Three common ones, with copy-paste answers:

**Q: "I see kCCDBPRIO mentioned at L45-47, is that a fabrication?"**
A: No. Lines 45-47 are inside the `revision_history:` block of front-matter (the file's YAML metadata, not main prose). They document that the fabrication was removed in v0.3. The prefilter v1.1 correctly classifies these as front-matter disclosure. The main body of the artifact has zero occurrences.

**Q: "The artifact in my repo is v0.1, not v0.3."**
A: Pull from the architect's branch / the file at MD5 `82e3372e032939e5d89934320b4405b5` (639 lines). v0.1 had the EParamProvenance fabrication; v0.3 corrected it.

**Q: "Should I run my own VERBATIM/counter checks?"**
A: Yes for your owned sections per dispatch prompt §4. The prefilter pre-flight covers structural correctness for every section; deep-dive Aspect-A through Aspect-F validation is your job for owned sections only.

---

## §4. After reviews come in

Architect drops the 15 reports into `Alice/code/O2/reviews/`. Designate Main Reviewer (NOT Claude7, NOT any of Opus1/Opus2/Opus3 from the panel — pick fresh). Main Reviewer synthesizes per QRC v0.5.4 §4.9 convergence rules + Main_Reviewer_QRC discipline.

That's the whole flow. End of document.
