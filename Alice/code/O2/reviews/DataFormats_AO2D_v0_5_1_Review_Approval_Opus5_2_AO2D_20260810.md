[Opus5_2:AO2D] [AO2DAI] [Coder] [DataFormats_AO2D_v0_5_1] [!]

# Official review and approval — `DataFormats_AO2D` v0.5.1

**Reviewer:** `Opus5_2:AO2D` — AO2DAI, Coder
**Date:** 2026-08-10
**Reviewed:** `DataFormats_AO2D_v0_5_1.md` — 1733 lines
**MD5:** `4099c40c9b0299364169b3c0148b6990`
**SHA-256:** `cde55f12047363328611adc6ac2c7c90fb65698c037e153e396d001bfa99cd7e`
**Consolidation reviewed:** `Fable5_1:AO2D` Main-Reviewer summary, 2026-08-10 (12 reviewers / 13 artifacts)

**Verdict: `[!]` APPROVED.** Approve v0.5.1 as the official draft. **Zero P0. Every one of my v0.5
findings is closed, three of them better than I asked.** The single residual, F-2, is an
artifact-attachment gap rather than a drafting defect — **I have re-delivered the missing artifact with
this review, which closes it.** Two carry-forward items are recorded below; neither blocks Sprint 1.

**Source-read declaration:** every claim below re-executed against the four architect snapshots —
`ASoA.h` `a400462e…`, `ASoA.cxx` `bd44c48a…`, `LFStrangenessTables.h` `2a9b56e7…`,
`AnalysisDataModel.h` `57501b92…`.

---

## 1. Do I agree with the consolidation?

**Yes**, on findings, adjudication and sequencing. `Fable5_1`'s F-1…F-5 set is complete against what I
filed, the Appendix A′ adjudication of the overview dispute is fair to both camps, and Appendix B's
next-step ordering is right.

**One correction to the record.** The Q3 table states my review context as *"COI disclosed (prior
drafting input)."* That inverts what I disclosed. My v0.5 review §0 says: *"v0.5 is nominally
AO2DAI-authored and I am AO2DAI's coder, but I did not write it and was not consulted on it. I review
it as a recipient, not a co-author."* The conflict I declared is that v0.5 hands me work I have already
committed to, which biases me **toward approving**, not that I drafted the text. A conflict record that
says the opposite of the declaration is worse than no record, so please correct it in the audit trail.

---

## 2. Closure verification — executed, not read

| ID | Fix | Verified |
|---|---|---|
| **F-1** | §10.11 default strangeness layer + §10.12 default-versus-derived, with the architect line quoted as `ARCHITECT DIRECTION` | ✔ `V0s_000/001/002` → `V0s_002`, `Cascades_000/001` → `Cascades_001`, `Decay3Bodys`, the three tracked variants; topology diagram matches the source index chain `Cascades → V0s → Tracks` |
| **F-3a** | `label_version` added to `key_form`; `MFTTracks` retained as the labelled exception | ✔ §5.8 L497/L503 |
| **F-3b** | `declaration_form: classic_cpp_type \| ng_string_key` separated from resolved key | ✔ L511 — **better than my finding**; I asked only for the enum value |
| **F-3c/d** | `exclusive: true \| false`; `index_table` removed from ordinary `relation_kind` | ✔ §5.9 L528, L556 |
| **F-3f** | `key_case_policy: byte_exact`; `Run2OTFV0` and `MFTTracks` named as non-normalizable | ✔ L505, L517, L523, §10.10 |
| **F-5** | self-alias cycle guard + `self_alias`; `INDEX_LIST_*` → `compiler_resolution_required`; `_FULL` argument order named as a hazard class; snapshot-relative `[VERBATIM]` parenthetical | ✔ §10.11, L567, L1290–1291, L136 |
| **F-2** | 82-symbol census recorded; artifact **not attached** | ✖ open — see §3 |

**`GPT2`'s F-3c is a genuine improvement on my §5.9 finding and I want it credited.** I proposed
`mode: exclusive | sparse`. The source says otherwise:

```cpp
ASoA.h:3342  #define DECLARE_SOA_INDEX_TABLE_NG(_Name_, _Key_, _Version_, _Desc_, _Exclusive_, ...)
ASoA.h:3346      static constexpr bool exclusive = _Exclusive_;
ASoA.h:3374/3375 DECLARE_SOA_INDEX_TABLE            → _NG(..., false, ...)
ASoA.h:3377/3378 DECLARE_SOA_INDEX_TABLE_EXCLUSIVE  → _NG(..., true,  ...)
```

`exclusive` is a real `constexpr bool` on the generated type; "sparse" is a naming convention in the
table symbols, not a framework property. My formulation would have invented a taxonomy the framework
does not have. v0.5.1 §5.9 states this correctly.

I did not verify F-4 against ADF source — the ADF surface is not mine and four ADF reviewers now hold
that seat. I note only that §17.2/§17.3 now match the API shape I measured independently while testing
the PyROOT-free Stage-2 path (`register_subframe(..., index_columns=…, right_index_columns=…)`, with
asymmetric keys native), and that §17.3's premise correction — symmetric normalized keys are an AO2DAI
adapter choice, never an ADF requirement — is right.

---

## 3. F-2 — the artifact exists; it did not reach the drafter

v0.5.1 §10.13 and front-matter line 48 record, honestly, that the cross-validated 82-row appendix
*"is not bundled with this drafting workspace"* and therefore decline to transcribe it by hand.

**Declining to fabricate an unavailable list is exactly right, and I want that judgement on the
record.** Hand-transcribing 82 rows would have produced a document that looks complete and is not
mechanically checkable — the failure mode this project has spent five revisions learning to avoid.

But the artifact is not unavailable. I generated and delivered it on 2026-08-10. It is in the project
at `claude/AO2D_standard_table_overview_APPENDIX_Opus5_2_AO2D_20260810.md`, and it is attached again
to this review. 82 rows: symbol, description, version, source-selected current alias, and the source's
own `//!` purpose comment, generated from `AnalysisDataModel.h` @ `57501b92…`.

**So F-2 is not a drafting failure. It is a distribution failure — the fifth in this project's
history, and the same class as the canonical-bytes problem that has run for five revisions.** A
reviewer produced the exact artifact the revision needed; the revision was drafted without it. That is
worth one line in the QRC alongside the canonical-bytes rule: *review deliverables travel with the
consolidation, not only the findings.*

With the appendix attached and its row count mechanically reconciled against the pinned header, F-2
closes and my verdict becomes `[OK]`.

---

## 4. Two carry-forwards — new scope, not defects

Neither is a criticism of v0.5.1; both arrived after the v0.5 review closed.

### 4.1 The architect's second 2026-08-10 directive did not land

Two directives were issued the same day. §10.12 carries the first verbatim
(*"default data in O2, derived data in O2Physics as extensions"*). The second —
***"Some derived data are written standalone. For the AO2D we will have to open another file"*** —
appears nowhere in v0.5.1. The only cross-file sentence in the document is the incidental L724 note
that `globalIndex()` is not a cross-file identifier.

This changes v0.5.1's own invariant 8: with two files, relation identity is keyed by
**(file, dataframe, row)**, not (dataframe, row). The source-declared bridge already exists on both
sides — `Origins` (`AnalysisDataModel.h` L1780–1784) and `StraOrigins` (`LFStrangenessTables.h`
L41–46) are the same shape, same `uint64_t DataframeID`, same comment. My sprint-plan note carries the
six registry consequences.

### 4.2 The two consumption modes are still undescribed

Underneath the architect's "written standalone" is a distinction the document does not make. LF's own
comments state it: `V0Indices` is *"index table when using AO2Ds"*; `V0CoresBase` is *"viable with
AO2Ds **or derived**"*. **AO2D mode** has base tables present and `V0Datas` formable; **derived
(`Stra`) mode** replaces the base backbone with `StraCollisions`/`StraOrigins`/`straCollision`, and
`DECLARE_SOA_TABLE_STAGED` (6 uses) is what lets one core table serve both.

This is load-bearing for the deadline work, because the pilot file is pure `Stra` mode — all 23 trees
derived, no base backbone — and it is why zero of the eleven row-aligned families I measured matched
any declared `soa::Join`. In derived mode the header's declared Joins do not describe the file, so
`SOURCE_PROVEN_POSITIONAL` is reachable only through Tier-C producer source.

**Recommendation:** fold 4.1 and 4.2 into the ratification pass rather than opening a v0.5.2 now.
Sprint 1 does not wait on them — I carry both in the loader and slicer regardless — and re-cutting the
document before the registry and fixtures exist would spend a cycle on text that the evidence will
reshape anyway.

---

## 5. Verdict

## `[!] APPROVED` — approve v0.5.1 as the official draft

| Question | Answer |
|---|---|
| Approve v0.5.1 | **YES** |
| P0 | **0** |
| My v0.5 findings | **all closed**; F-3b/c and F-5's hazard framing improve on what I filed |
| Consolidation | **agreed**, with one COI-record correction (§1) |
| Residual | **F-2 only** — artifact attached with this review; closes to `[OK]` on reconciliation |
| Another drafting cycle before Sprint 1 | **NO** |
| Carry-forwards | cross-file identity; AO2D-mode vs `Stra`-mode → ratification pass |
| Ratification | still gated by §24 — the two commits, the registry, the 11 fixtures, the standard fixture, the ADF pin |

Five revisions, zero source-citation drift, and this cycle the panel corrected me twice on substance.
That is the process working.

---

**Reviewer:** `Opus5_2:AO2D` — AO2DAI, Coder · 2026-08-10
**Attached:** `AO2D_standard_table_overview_APPENDIX_Opus5_2_AO2D_20260810.md` (82 rows, closes F-2)
