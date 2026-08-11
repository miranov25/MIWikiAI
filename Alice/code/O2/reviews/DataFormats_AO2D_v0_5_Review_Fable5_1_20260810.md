# [Fable5_1:AO2D] [AO2DAI] [Reviewer] [PHASE_0_1_AO2D / DataFormats_AO2D v0.5] [!]

# Official Review — `DataFormats_AO2D` v0.5 DRAFT (first AO2DAI-authored revision; first review on canonical bytes)

**Reviewer:** Fable5_1:AO2D · **Date:** 2026-08-10
**Reviewed:** the canonical files themselves — a first in five revisions.
**OFFICIAL FINGERPRINTS (recorded per my standing offer):**
- `DataFormats_AO2D_v0_5.md` — SHA-256 `f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19`, MD5 `3acbb75cd64d0e9b137e1e6b7bf54731`, 1,587 lines / 59,350 B
- `DataFormats_AO2D_v0_5.html` — SHA-256 `41aea8de7322e82569d5a33384ef5665b5a6cbec7078614d35b31319afea1180`, MD5 `5ca768f8c13ac3736a8b567a33ae2d7e`

**Verdict:** `[!]` **APPROVED as the official v0.5 DRAFT** — every mechanical check that has blocked four cycles now PASSES on real bytes; the full v0.4.2 residue is implemented; the base-model spine is real and well-built. **One P1 content gap** (§3 below — the base V0/Cascade family itself), bounded to one subsection; small P2 set. No architecture change requested; ratification stays gated on §24 by design.

---

## 1. Mechanical checks — ALL PASS, executed on canonical bytes (F-1 and F-2 both CLOSED)

| Check | Result |
|---|---|
| Version-marker grep (every non-v0.5 occurrence classified) | **PASS** — 9 hits, all legitimate (review_basis citations, historical v0.2 snapshot references, revision-note comparisons). QRC §4.14 satisfied. |
| `[VERBATIM]` label grammar | **PASS — Resolution A executed**: all three labels carry `:L2896-L2899` / `:L1078` / `:L1745-L1747`, snapshot SHA stated separately; grammar, labels and §24.5 are mutually consistent (the four-way contradiction is gone); prefilter-checkable. |
| `[VERBATIM]` §5.1 byte-diff | **BYTE-EXACT** vs clone content (identical to snapshot content for this block): 4-space indentation, ~col-128 padding, trailing `\` — all preserved. The three-cycle §5.1 saga is closed. |
| `[VERBATIM]` §11.2 (`V0Datas`) byte-diff | **BYTE-EXACT** |
| `[VERBATIM]` §12.2 (`CascDatas`/`KFCascDatas`/`TraCascDatas`) byte-diff | **BYTE-EXACT** |
| HTML title | **PASS** — `DataFormats_AO2D v0.5 — ALICE O² ASoA and AO2D semantic reference`, clean UTF-8 (em-dash and O² correct); 132 anchors present. |

## 2. Content check — the complete v0.4.2 residue is implemented, and verified against source

| Residue item | v0.5 disposition | Verified |
|---|---|---|
| F-3 self-index naming rules | §5.3 table now has the self rows — **re-verified this session against ASoA.h**: external `"fIndex" _Label_ _Suffix_` (:2841) vs self `"fIndex" _Label_` no-suffix (:2922); short self `#_Name_` stringified (:2976); self slice/array short forms `"_" #_Name_` (:3040/:3110). Exact. | ✅ |
| F-4 `McCaloLabels` counterexample | §4.6 dedicated sub-heading + new invariant 13 — "current alias is a source selection, never highest-version" | ✅ |
| F-14 `INDEX_TABLE` sixth relation kind | New §5.9 (11 symbols listed — matches my ADM.h read :2222–2246), invariant 14, `entity_kind: index_table` + §15.6 record + `INDEX_TABLE_UNVERIFIED` status + §19.7 fixture 11 | ✅ |
| F-15 positional-family fixture | §19.7 fixture 8, explicitly motivated by the slicer-corruption find; suite expanded 7→11 (adds self-array, multi-partition, index-table) | ✅ |
| F-11 `AmbiguousTracks` precedent | §10.4 + §18.5 — exactly the "search for source-defined ambiguity tables before inventing encodings" framing | ✅ |
| F-8 `_NG` shape note | §5.8: "not every edge is cross-version — `TRACK/0 ↔ TRACK_IU/0` is a shape edge" | ✅ |
| TracksQA / `entity_kind` | §10.3 + §15.3 + §16 extractor contract | ✅ |
| Snapshot-provenance correction (Opus5_2/§C.1) | front matter now states snapshots are "not assumed to originate from a later clone commit merely because content overlaps" | ✅ |
| Join evidence bases | §6.1 keeps the two bases separate with the enumerate-at-pin gate | ✅ |

## 3. Findings

### P1-1 — The base V0/Cascade/Decay3Body family is missing from the §10 spine — and it is the most phase-relevant base family
Grep on the canonical bytes: **zero** occurrences of `V0s_00x`, `Cascades_00x`, `Decay3Body`, `TrackedCascade`. §10 covers BC/Collisions/Tracks/Ambiguous/detector/MC/index-tables/Origins/Run-2 — but not the **base** `"AOD","V0"` / `"AOD","CASCADE"` tables (`AnalysisDataModel.h` :1661–1776 at my clone): `V0s_000/_001/_002` (current `V0s_002`, with `V0Type` + dynamic selectors `IsStandardV0/IsPhotonV0/IsCollinearV0`), `Cascades_000/_001` (current `Cascades_001`), `Decay3Bodys` (Track0/_1/_2 suffixed indices), and the strangeness-tracking tables (`TrackedCascades`/`TrackedV0s`/`Tracked3Bodys`). These are **the AO2D-file V0/cascade objects themselves** — the LF §11–12 tables are *derived* strangeness outputs that reference them — so for a V0-primary/cascade-primary phase this is the one base family the loader will touch first, and it also happens to be a compact worked example of versioned index-tables-with-dynamic-columns. **Fix: one §10.x subsection (+ one line in §20.3's backbone list).** This was point 2 of the v0.4.1 base-model recommendation; everything else from that recommendation landed.

### P2 (fold into the same touch or the gate)
1. **F-9 still open:** §4.7 alludes to the four-strings declaration but does not quote `DECLARE_SOA_TABLE_FULL_VERSIONED(StoredTracksExtra_001, "TracksExtra", "AOD", "TRACKEXTRA", 1, …)` — three cycles of reviewers agree it is the best §4.7 illustration available.
2. **Claude5-F4 still open:** §4.4/§4.7 still describe extended tables loosely; the mechanical rule (*extended = stored + expression columns; different declaration macros, not a naming convention*) is one sentence.
3. §10.5's detector-family list is name-only; one clause per family naming its principal BC/collision/track edge would complete the overview at negligible cost (optional — the registry covers the rest).
4. §22's orientation links remain mutable-branch URLs — commit-anchor at pinning (carried).

## 4. Answers to the architect's three questions

**Q1 — Is it approved? YES — `[!]` approved as the official v0.5 DRAFT**, on canonical, fingerprinted bytes (record above), with all four previously-blocking mechanical classes closed in one revision: bytes circulated, Resolution A executed and consistent, byte-exact VERBATIM ×3, clean HTML. This is also the first revision where the review could be *completed* rather than conditioned.

**Q2 — Do we need a next revision? One bounded touch, then no.** Add P1-1's base V0/Cascade/Decay3Body subsection (plus P2-1/P2-2 while the file is open — all three are transcription with line evidence supplied). Call it v0.5.1 or fold it into the dispatch as a pre-freeze edit; **no re-panel, no architecture change.** After that, what remains is *evidence generation*, not document revision: the two pins + provenance decision (fifth cycle on the critical path), the standard-AO2D fixture (§18.4), the generated `DataFormats_AO2D.json` under the two-generator cross-validation rule, the §19.7 fixtures, and the ADF seat's §17/§24.4 items.

**Q3 — Are the AO2D tables well described for an overview? Yes — genuinely, for the first time.** A new reader now gets the correct mental model in one pass: the BC→Collision→Track relation spine with diagrams, the stored/extended/current-alias machinery with the honest `McCaloLabels` counterexample, ambiguity as a designed feature rather than a mystery, the MC graph with all three self-index kinds, index tables as their own mechanism, `Origins`/`DF_` provenance, and the Run-2 lesson — with the two-layer split (§10.10) keeping prose at family level and pushing exhaustiveness to the registry, exactly as the panel specified. The single material gap is P1-1: the base V0/Cascade family — ironically the one this phase is about. With that subsection added, §10 is a complete and, in my assessment, ratification-grade overview of the standard AO2D model at the human-narrative level.

## 5. Recommendation

Apply the one-subsection P1-1 fix (+P2-1/2), re-fingerprint, and issue the focused validation dispatch — including the ADF seat. The document side of this project has converged; the critical path is now entirely evidence: **pins, fixture, registry, executed slices, ADF API.**

Reviewers recommend. The architect decides.

*— Fable5_1:AO2D · AO2DAI · 2026-08-10*
