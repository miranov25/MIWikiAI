[Opus5_2:AO2D] [AO2DAI] [Coder] [DataFormats_AO2D_v0_5] [!]

# Official review — `DataFormats_AO2D` v0.5 DRAFT

**Reviewer:** `Opus5_2:AO2D` — AO2DAI, Coder
**Date:** 2026-08-10
**Reviewed:** `DataFormats_AO2D_v0_5.md` (1588 lines) + generated `DataFormats_AO2D_v0_5.html`
**Verdict:** **`[!] APPROVED_WITH_COMMENTS`** — approved as the architecture; **one bounded v0.5.1 required**
**P0:** 0 · **P1:** 3 · **P2:** 4
**Architecture:** APPROVED — the base-model-first restructure is right and I would not undo it
**Source-read declaration:** all claims below re-executed against the four architect snapshots I hold:
`ASoA.h` `a400462e…`, `ASoA.cxx` `bd44c48a…`, `LFStrangenessTables.h` `2a9b56e7…`,
`AnalysisDataModel.h` `57501b929d12c5dd659ca46cb6350b8046c1bcca639f63798f21fb6e94ba9632`.

**Disclosure:** v0.5 is nominally AO2DAI-authored and I am AO2DAI's coder, but I did not write it and
was not consulted on it. I review it as a recipient, not a co-author. My incentive runs toward
approving a document that hands me work I have already declared — I have tried to correct for that by
grounding every finding in an executed check rather than a reading.

---

## 1. What v0.5 closed — verified, not read

Every residual item carried out of the v0.4.2 cycle is discharged, and I checked each one rather than
taking the change log's word for it.

**My own v0.4.2 P1 is CLOSED, by Resolution A.** All three `[VERBATIM]` blocks now carry line ranges
*and* the snapshot SHA-256 beside them. §5.1 `ASoA.h:L2896-L2899`, §11.2
`LFStrangenessTables.h:L1078`, §12.2 `…:L1745-L1747` — all three resolve byte-exact against the named
hashes on first attempt. This is the outcome `Fable5_1` argued for and I initially argued against; the
drafter chose correctly. It also retires the four-way self-contradiction: the labels, the grammar in
§"Semantic status descriptors", §24.5.3 and §25 now agree.

| v0.4.2 residual | v0.5 disposition | Verified |
|---|---|---|
| `[VERBATIM]` line references (7 of 12 reviewers) | §5.1/§11.2/§12.2 restored **with snapshot hashes** | ✔ all three exact |
| Self-index naming rules differ (`Opus5_1` P1-2) | §5.3 table + §9.2 + §16.4 binding rule | ✔ matches `ASoA.h` macro bodies |
| `McCaloLabels` counterexample (`Opus5_1` P1-3, `Fable5_1` F-15, 3rd raise) | §4.6 with the rule stated as normative | ✔ L2117/L2119/L2121 exact |
| `DECLARE_SOA_INDEX_TABLE` sixth relation kind (mine) | §5.9 + §10.7 + §15.6 + `relation_kind` enum + fixture 11 | ✔ 11 instances, all 11 symbols correct |
| Positional-family fixture (mine, from execution) | §19.7 fixture 8, with the provenance note | ✔ |
| Standard-model spine ahead of LF | §10 promoted, §§11–12 demoted to worked example | ✔ structurally |
| `_NG` "not merely cross-version" | §5.8 | ✔ 14 `_NG` + 3 classic |
| `TracksQA` entity-kind hazard | §10.3 + §15.3 `resolution_method` | ✔ L771–772 |
| Conservative union-mask policy | §6.3 | ✔ matches AO2DAI selection |
| LF eight equivalence pairs | §5.7 | ✔ L1938–1945, all eight, correct order |

Also spot-verified and correct: `BCs_000`/`BCs_001`/`using BCs = BCs_001` (L47/L51/L58); `Timestamps`
L68; `BCsWithTimestamps` L71; the "Root of data model" comment quoted in §10.1 is the literal source
comment; `StoredTracksExtra = StoredTracksExtra_002` L676; `TracksExtra = TracksExtra_002` L677;
`FullTracks` L696; `Origins`/`DataframeID` L1780–1786 including the `DF_XXX` comment §10.8 paraphrases.

**Zero source-citation drift, fourth consecutive revision.** That record is now the most reliable
property this document has.

---

## 2. P1 findings

### P1-1 — §5.8's `MFTTracks/0 ↔ MFTTracks/1` example is **label-keyed, not description-keyed**, and the registry schema has no slot for it

§5.8 states the `_NG` mechanism is description/version keyed and mandates
`key_form: cpp_type | description_version`. It then offers six examples, the last being
`MFTTracks/0 ↔ MFTTracks/1`.

Thirteen of the fourteen `_NG` edges are description-keyed. **This one is not.** The MFT track tables
are declared:

```cpp
L902  DECLARE_SOA_TABLE_FULL(StoredMFTTracks_000,  "MFTTracks", "AOD", "MFTTRACK", …)
L912  DECLARE_SOA_TABLE_FULL_VERSIONED(StoredMFTTracks_001, "MFTTracks", "AOD", "MFTTRACK", 1, …)
```

`"MFTTracks"` is the **label** (argument 2 of `_FULL`); the **description** is `"MFTTRACK"`. No table in
the header has description `"MFTTracks"` — I checked. So

```cpp
L2074  DECLARE_EQUIVALENT_FOR_INDEX_NG("MFTTracks/0", "MFTTracks/1");
```

is keyed on a string that the document's own `description_version` resolver **cannot resolve**.

**Why this is P1 and not cosmetic.** The document's purpose is to drive a generator. A generator built
exactly to §5.8 resolves 13 of 14 `_NG` edges and dead-ends on the fourteenth. §16.2 says "fail closed
on unresolved constructs," so the good outcome is a hard stop on a legitimate source declaration; the
bad outcome is a silent drop, because a missing equivalence edge produces no error — it produces an
index binding that is quietly rejected later, or accepted where it should not be. And §5.8 presents
this exact edge as an **example of the rule**, which teaches the wrong resolver.

**Fix:** add `label_version` to the `key_form` enum in §5.8 and to §15.5's `relation_kind` record; and
either drop `MFTTracks/0 ↔ MFTTracks/1` from the example list or keep it and label it as the
exception, which is more useful. One sentence plus one enum value.

This is almost certainly an upstream inconsistency rather than a documentation error — but the
document is what my generator will be built from, so it has to carry the exception.

### P1-2 — The standard model's own `V0s`, `Cascades`, `Decay3Bodys` and strangeness-tracking tables are absent, while §§11–12 teach LF V0/cascade

`AnalysisDataModel.h` declares, in the base model:

```cpp
L1661/1664/1667  V0s_000 / V0s_001 / V0s_002   "V0"           →  using V0s = V0s_002;
L1685/1687       Cascades_000 / Cascades_001   "CASCADE"      →  using Cascades = Cascades_001;
L1701            Decay3Bodys                   "DECAY3BODY"
L1729            TrackedCascades               "TRACKEDCASCADE"
L1743            TrackedV0s                    "TRACKEDV0"
L1757            Tracked3Bodys                 "TRACKED3BODY"
```

**None of these six appears anywhere in v0.5.** Meanwhile §11 is titled "PWG worked example: V0 data in
`LFStrangenessTables.h`" and §12 "PWG worked example: cascade data."

A reader following the document's own Reader Path — §§1–10 first, then LF — learns the base model
without learning that the base model *has* V0s and cascades, then meets `V0Datas` and `CascDatas` in
§§11–12 framed as the O2Physics extension. The relationship between `aod::V0s` (base, an index table
into `Tracks` written by reconstruction) and `aod::V0Datas` (LF, a positional join over
`V0Indices`/`V0TrackXs`/`V0Cores` produced downstream) is the single most confusable pair of names in
the whole model, and v0.5 introduces one without the other.

This is not a completeness nit. It is the one place where the base-model-first restructure — v0.5's
headline change — is incomplete in a way that actively misleads, and it sits directly under the
document's stated purpose #10 ("how V0 and cascade tables extend the standard model in O2Physics").
You cannot explain the extension without the thing being extended.

**Fix:** one short §10.x subsection — six table names, the base-vs-derived distinction, and one
sentence on `V0s` vs `V0Datas`. Twenty minutes.

### P1-3 — §10 has no table inventory, and the coverage is 44 %

I counted mechanically. `AnalysisDataModel.h` declares **82 table symbols** — 71 data tables
(`DECLARE_SOA_TABLE` ×39, `_VERSIONED` ×15, `_FULL` ×13, `_FULL_VERSIONED` ×4) plus 11 index tables.

**v0.5 names 36 of 82 (44 %) even counting version-stripped base names. 39 distinct base names never
appear in the document at all:**

```
AmbiguousFwdTracks   AmbiguousMFTTracks   BCFlags           CPVClusters        CaloTriggers
Calos                Cascades             Decay3Bodys       FDDs               FDDsExtra
FT0s                 FT0sExtra            FV0As             FV0AsExtra         FV0Cs
FwdTrkCls            HepMCHeavyIons       HepMCPdfInfos     HepMCXSections     McFwdTrackLabels
McMFTTrackLabels     Pmds                 Run2BCInfos       Run2OTFV0s         Run2TrackExtras
StoredFwdTracks      StoredFwdTracksCov   StoredMFTTracks   StoredMFTTracksCov StoredMcParticles
StoredTracks         StoredTracksCov      StoredTracksCovIU StoredTracksIU     TRDsExtra
Tracked3Bodys        TrackedCascades      TrackedV0s        Zdcs
```

§10.5 handles the entire detector surface — HMPID, calorimeters, CPV, ZDC, FV0 A/C, FT0, FDD, forward
and MFT — as a nine-item bullet list of *family concepts*, with **not one table name, description
string, row granularity, or key relation**. §10.9 does the same for Run-2 compatibility. §10.10 then
declares this deliberate: "the human narrative should not become a hand-maintained dump."

**I agree with §10.10's principle and disagree that it licenses the current state.** There is a large
gap between a hand-maintained dump of every column and *no inventory at all*. What is missing is the
one-line-per-table layer: symbol, description, current alias, and what one row is. That layer is not
hand-maintained — it is generated, which is exactly what §15 already requires the project to build.

Concretely, the document fails its own §21 Reader Path. "New AO2DAI reviewer: read §§1–10 … you should
be able to reject common unsafe inferences." A reviewer who has read §§1–10 cannot answer "does the
base model have a ZDC table, and what is one row of it?" — and that is the question an overview exists
to answer.

**Fix:** generate the inventory rather than write it. I have produced it as a deliverable alongside
this review — `AO2D_standard_table_overview_APPENDIX.md`, all 82 symbols with description, version,
source-selected current alias and the source's own `//!` one-liner, generated from the hashed snapshot
in a few seconds. It is a candidate §10.11 / Appendix S. It is also, usefully, a first executable slice
of the §15 registry: if the generator can emit this table it can emit `DataFormats_AO2D.json`.

---

## 3. P2 findings

**P2-1 — `using Decay3Bodys = Decay3Bodys;` (L1704) is a self-referential alias and will hang a naive
resolver.** The source declares the table `Decay3Bodys` and then aliases the name to itself with the
comment "this defines the current default version." §15.4's field
`current_alias_is_highest_declared_version: true | false | not_applicable` has no defined value for a
self-alias, and an alias-resolution pass that follows `current_alias_target` transitively self-loops
here. Add a cycle guard to §16.2's extractor rules and a `self_alias` value to §15.4.

**P2-2 — description strings are not reliably uppercase, so key normalisation is unsafe.** `Run2OTFV0s`
is declared `DECLARE_SOA_TABLE(Run2OTFV0s, "AOD", "Run2OTFV0", …)` — mixed case, the only such
description in the header. Combined with P1-1's `MFTTracks`, this is a class, not a one-off: an
extractor that upper-cases description keys for matching will silently mis-key two entities. §9.2
should state that description strings are compared byte-exact and never case-normalised.

**P2-3 — §5.9's index tables hide their index columns behind macro indirection.** Four of the eleven
are declared as e.g. `DECLARE_SOA_INDEX_TABLE(Run2MatchedSparse, BCs_001, "MA_RN2_SP", INDEX_LIST_RUN2)`
— the index-column set arrives as the token `INDEX_LIST_RUN2`, not a list. §15.6's `index_columns`
field is therefore unpopulatable by text extraction for those four; §16.2's fail-closed rule saves
correctness but leaves the registry incomplete on a mandated §20 item. Worth one sentence in §5.9 and
an explicit note that index tables are a compiler-resolution candidate rather than a scanner one.
Related: the key table differs *within* one family — `Run2MatchedExclusive` keys on `BCs`,
`Run2MatchedSparse` on `BCs_001` — so §15.6's `key_table` must record the exact declared type, not the
family.

**P2-4 — §14.1 lists two headers under `src/`.** `Framework/AnalysisSupport/src/AODWriterHelpers.h` and
`…/src/AODReaderHelpers.h` are given as header paths in a `src/` directory. That may be correct
upstream, but it is the same shape as the `TableTreeHelpers` path error three reviewers flagged in
v0.4.2 (F-5), and §14.1's own note already concedes the paths need freezing. I cannot verify these
without the pinned checkout — flagging so the pin pass checks all four rather than the one already
known.

---

## 4. HTML companion

Generated from the Markdown, structurally consistent with it, UTF-8 title and code blocks intact. No
findings. Confirming that the Markdown is canonical and the HTML derived from it remains MIWikiAI's
§24.5 item, not mine.

---

## 5. Answers to the three questions

### Is it approved?

**Yes — `[!] APPROVED_WITH_COMMENTS`, zero P0.** The architecture is right, the base-model-first
restructure is the correct move, every v0.4.2 residual is genuinely closed, and the fourth consecutive
revision shows zero source-citation drift. I would build against this document.

### Do we need a next revision?

**Yes — one bounded v0.5.1, and it should not go to a full panel.** Estimated two to three hours:

1. P1-1 — `label_version` key form + fix or flag the `MFTTracks` example (15 min)
2. P1-2 — base-model V0s/Cascades subsection in §10 (20 min)
3. P1-3 — attach the generated table inventory as §10.11 / Appendix S (paste; the generation is done)
4. P2-1 … P2-4 — four sentences and two enum values (30 min)

All four P1/P2 groups are corrections to rules the document states or gaps in the inventory it claims
to provide — none is an architecture change, and none needs a new reviewer opinion. The remaining §24
items are evidence gates that no revision can close: the two 40-character commits (fifth cycle now),
the canonical bytes and fingerprint, the standard-base fixture, the ADF seat.

I would rather fix these four in a v0.5.1 than inherit them, and I say that as the person who inherits
them either way.

### Are the AO2D tables well described enough to get an overview?

**No — this is the document's weakest surface, and it is the one thing v0.5 was written to fix.**

The mechanisms are described very well. How a table is *declared*, how indices bind, how versions and
aliases work, why equal row counts prove nothing — all of that is now genuinely good, better than the
upstream documentation, and I would send a new coder here first.

The **tables themselves** are not. Forty-four percent are named; thirty-nine base names never appear;
the entire detector surface is nine bullet words; and the base model's own V0/cascade tables are
missing while a whole section teaches the LF ones. A reader finishing §10 knows *how to reason about*
any AO2D table and cannot list what tables exist.

That gap is cheap to close and should not be closed by writing prose. The inventory is a generated
artifact — 82 rows, symbol, description, version, source-selected alias, and the source's own one-line
purpose comment. I have generated it and attached it. Paste it in, and §10 goes from a good
explanation of mechanisms to an overview a reviewer can actually navigate.

---

**Reviewer:** `Opus5_2:AO2D` — AO2DAI, Coder
**Date:** 2026-08-10
**Verdict:** `[!] APPROVED_WITH_COMMENTS` · **v0.5.1 required, ~2–3 h, no panel** · **Attached:**
`AO2D_standard_table_overview_APPENDIX.md` (82 rows, generated from `57501b92…`)
