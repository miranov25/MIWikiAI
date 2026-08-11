# [Opus5_1:AO2D] [AO2DAI] [REVIEWER — own-team] [PHASE_0_1 / DataFormats_AO2D v0.5] [!]

**Date:** 2026-08-10
**Artifact:** `DataFormats_AO2D` v0.5 DRAFT (1,588 lines) + generated HTML companion

**Answers to the three questions:**

1. **Approved?** **Yes — `[!]`, as the official DRAFT. Publish it.** Not ratified; §24 gates that correctly and honestly.
2. **Next revision needed?** **Yes — one, and it is a content addition, not a correction.** 0 P0 / 3 P1 / 4 P2.
3. **Are the AO2D tables well described for an overview?** **No — and this is the one real gap in an otherwise strong revision.** §10 describes the *architecture* well and never gives an *inventory*. Detail in §4, with the missing inventory supplied in the appendix.

---

## 1. Source-read declaration

| File | SHA-256 | Use |
|---|---|---|
| `AnalysisDataModel.h` | `57501b929d12c5dd659ca46cb6350b8046c1bcca639f63798f21fb6e94ba9632` | verify all §10 claims; full table census |
| `ASoA.h` | `a400462e4c635808b0fa15abd4d1dafbda3d51c856c9f838869c69f09d49e922` | §5.1 VERBATIM block, §5.3 naming rules |
| `LFStrangenessTables.h` | `2a9b56e7bca657e3efb1064b7e6e38643af123784f9d9a7b353db2036e8bc852` | §11/§12 blocks, LF→standard index targets |

---

## 2. Every new claim verifies. Fourth consecutive revision with zero citation drift.

| v0.5 claim | Result |
|---|---|
| §10.1 `BCs_000` / `BCs_001` / `using BCs = BCs_001` / `Timestamps` / `BCsWithTimestamps` | ✅ L47, L51, L58, L71 |
| §10.2 `collision::BCId`, versioned `Collisions_*` | ✅ L82; `Collisions_000`/`_001` confirmed |
| §10.3 `track::CollisionId`; Tracks/IU/Cov/StoredTracksExtra/TracksExtra/FullTracks | ✅ L124, L602, L632, L665-667, L676-677, L696 |
| §10.3 `TracksQA = TracksQAVersion::iterator` hazard | ✅ L771-772 |
| §10.4 `AmbiguousTracks` + BC slice | ✅ L1034, L1037 |
| §10.6 MC backbone: `McCollisionId`, self mother/daughter, `Mothers`, `Daughters`, label tables | ✅ L1928, L1932-1937, L2085, L2130 |
| §10.7 / §5.9 **eleven** index-table symbols, listed by name | ✅ **all eleven match exactly, name for name** |
| §10.8 `Origins` / `DataframeID` "usually found in directory name … i.e. `DF_XXX`" | ✅ L1780, L1783 — the prose tracks the source comment closely |
| §4.6 `using McCaloLabels = McCaloLabels_000` counterexample | ✅ L2117/2119/2121 |
| §5.8 fourteen `_NG`, incl. `TRACK/0 ↔ TRACK_IU/0` as a *shape* edge, not cross-version | ✅ — and the caution against calling the whole set "cross-version" is a real sharpening |

### Findings from my prior reviews that landed correctly

- **My P1-2 (self-index naming)** — §5.3's table now separates external from self, with "no external suffix slot", "no token-pasted plural `s`", and the underscore-prefixed short slice/array forms. Correct as verified.
- **My P1-3 (`McCaloLabels`)** — §4.6 states the rule properly and invariant 13 promotes it. Good.
- **My P2-2 (`AmbiguousTracks`)** — §10.4, and used well: as the *precedent* for investigating unexplained negative values before inventing an encoding. That is better than how I proposed it.
- **Resolution A adopted** — §5.1 carries `:L2896-L2899`, §11.2 `:L1078`, §12.2 `:L1745-L1747`, each with its snapshot SHA-256 stated separately. And §5.1's block now shows the true 4-space indentation *and* the continuation backslashes — **it is character-exact this time.** My P2-1 closes.
- **§19.7** now has eleven fixtures including the source-proven positional family (8), multi-partition (10) and index-table (11).

This is the strongest revision the document has had, and the base-model-first restructure is executed the way the panel asked for.

---

## 3. P1 findings

### P1-1 — There is no table inventory anywhere in the document

This is the direct answer to your third question and the main gap.

§10 teaches **architecture** — `BCs → Collisions → Tracks`, the MC graph, index tables, ambiguity — and it teaches it well. What it never does is **list the tables**. A reader who finishes §10 still cannot answer "what tables are in a standard AO2D?"

The document is deliberate about this: §10.10 refuses to become "a hand-maintained dump of every expression column, detector branch or matching table," and defers exhaustive records to the generated registry. **The refusal is right; the consequence is not.** The registry does not exist yet (§15.1 requires it for ratification). So at this moment the reader gets *neither* prose overview *nor* generated catalogue.

There is a middle level the document skips: not a column dump, but a **table-level inventory** — one row per declared table with description, origin, version and current alias. That is ~70 rows for the standard model, mechanically derivable, and it is precisely what converts "architecture" into "overview."

I generated it from the header; it is in the appendix. It should be dropped into §10 as a single table, or generated into the registry and rendered.

### P1-2 — The standard V0/cascade tables are never named, and the LF examples index into them

`AnalysisDataModel.h` declares standard-model tables that v0.5 never mentions anywhere:

```
V0s_000 / V0s_001 / V0s_002   (AOD, "V0")
Cascades_000 / Cascades_001   (AOD, "CASCADE")
Decay3Bodys                   (AOD, "DECAY3BODY")
TrackedV0s / TrackedCascades / Tracked3Bodys
```

This matters more than an omission, because **the LF worked examples in §§11–12 resolve their index targets into these tables.** `v0data::V0Id` comes from `DECLARE_SOA_INDEX_COLUMN(V0, v0)`, whose target is `V0s` — the standard table. `cascdata::CascadeId` targets `Cascades`. So the LF→standard edge, which is the whole reason §11 was moved *after* §10, runs through tables the spine never introduces.

The concrete risk is name conflation: a reader meeting `aod::V0s` in code and `V0Datas` in §11 has nothing in this document telling them these are different objects at different layers. That is exactly the class of confusion the document exists to prevent, and §11's opening sentence — "V0/cascade data reference standard objects such as tracks and collisions" — understates it: they also reference standard *V0* and *cascade* objects.

**Fix:** name the standard V0/cascade/3-body family in §10 (it belongs alongside §10.4), and add one sentence to §11.1 stating that `V0Id`/`CascadeId` target the standard tables.

### P1-3 — No end-to-end worked example from declaration to physical branch

The document has all three layers and never walks one object through them. §9.2 gives the naming rules abstractly; §10 gives architecture; §18.3 lists what to compare. But nothing shows a single concrete chain:

```
DECLARE_SOA_INDEX_COLUMN(BC, bc)  in namespace collision
        → column type collision::BCId, target aod::BCs, storage int32_t
        → physical branch label  fIndexBCs
        → inside tree  DF_<id>/O2collision
        → reconciled against the file's actual branch and dtype
```

For a document whose stated purpose is that a reader "should be able to read this page without prior ALICE software knowledge," one fully worked chain is worth more than several pages of rules. It is also the smallest thing that would let a coder self-check an extractor. `collision::BCId` is the right candidate because §10.1 and §10.2 already set it up.

---

## 4. Is the AO2D table set well described for an overview? — the long answer

**Architecture: yes, and notably better than v0.4.2.** The `BCs → Collisions → Tracks` spine, the MC relation graph, the ambiguity model, the index-table mechanism and the stored/extended/alias distinction are all clearly explained and correctly grounded. §10.3's "extractor hazard" and §4.6's alias counterexample are the kind of thing a reader could not get from the source docs.

**Inventory: no.** Three concrete symptoms:

1. **§10.5 lists detector acronyms, not tables.** "HMPID matching/data versions; calorimeter cells/triggers and CPV-related data; ZDC; FV0 A/C; FT0; FDD; forward and MFT track families." A reader cannot learn from this that the calorimeter tables are `Calos` (`CALO`) and `CaloTriggers` (`CALOTRIGGER`), that FT0 is `FT0s` + `FT0sExtra`, or that ZDC is `Zdcs_000`/`Zdcs_001`. §10.5's own framing — "a human reader needs family-level orientation, not every branch" — is right, but *table names are not branches*. They are the family level.

2. **Version multiplicity is invisible.** The document explains versioning beautifully in the abstract and never shows the reader that `TracksQA` has four declared versions, `V0s` three, and `BCs`/`Collisions`/`FDDs`/`HMPID`/`McCollisions`/`McCaloLabels`/`Zdcs`/`Run2BCInfos`/`Run2TrackExtras`/`Cascades`/`StoredTracksExtra`/`StoredMFTTracks`/`StoredMcParticles` two or three each. That distribution *is* the argument for §9.5 and §18, and it is currently only asserted.

3. **§10.9 Run-2 compatibility names no tables** — `Run2BCInfos_000/_001` and `Run2TrackExtras_000/_001` exist and are the concrete instance of the lesson being taught.

**One honest caveat on my own extraction, which is itself a finding.** When I generated the appendix inventory, 17 of 70 rows came out mangled — the `DECLARE_SOA_TABLE_FULL*` forms place the *label* in argument 2 and the origin in argument 3, whereas the plain form has origin in 2 and description in 3. My quick parser applied one rule to both. **That is the same defect Opus5_2 disclosed in his generator** (23 phantom `O2aod` trees), reproduced independently on first contact with this header. It is strong support for Fable5_1's cross-validation rule, and it is worth a sentence in §16.2 as a named extractor hazard alongside the `TracksQA` one — the two are the same class.

---

## 5. P2

**P2-1** — §14.1 lists `Framework/AnalysisSupport/src/AODWriterHelpers.h` and `AODReaderHelpers.h`. `TableTreeHelpers.h` was correctly moved to `include/Framework/` this revision; the other two still show headers under `src/`. Possible (AliceO2 does use private headers in `src/`), but it should be verified at the pin rather than carried by analogy.

**P2-2** — §4.4 still gives no instance count for expression columns; there are **44** in the standard header. One number turns an abstract distinction into a concrete one.

**P2-3** — §10.5's detector list would be materially more useful ordered by *relation to the backbone* (which families carry a `BCId`, which carry a `CollisionId`, which are reached only via index tables) rather than by detector name. That is the architectural lesson §10.5 states in its last sentence but does not organize around.

**P2-4** — §5.9 lists the eleven index tables but not what distinguishes exclusive from sparse in practice. One clause — exclusive requires a unique match, sparse admits misses — would make §15.6's `mode` field self-explanatory.

---

## 6. Approval

**Approved. `[!]`. Publish v0.5 as the official DRAFT.**

The restructure the panel asked for has been done properly: the standard model is the spine, LF is a downstream stress test, and the ordering now matches the dependency direction. Every new source claim verifies exact, including all eleven index-table names — the fourth consecutive revision with zero citation drift, which is a real record for this project. Resolution A was implemented correctly and §5.1 is character-exact for the first time.

**One more revision is needed, and it is additive.** P1-1 through P1-3 are all "add content," not "fix errors" — a table inventory, the standard V0/cascade family, and one end-to-end worked chain. I estimate that at a few hours against the header, and the inventory is already generated below.

I would grade the next revision `[OK]` if those three land, independent of the ratification gates in §24, which are correctly declared and blocked on inputs no drafter controls.

---

## Appendix — standard AO2D table inventory (§10's missing table)

Extracted from `AnalysisDataModel.h` @ `57501b92…`. **70** `DECLARE_SOA_TABLE*` declarations carrying (name, origin, description). Plain-form rows below; the 17 `_FULL` forms need the argument-order-aware pass described in §4 and are listed separately.

| Description | Table(s) | Ver |
|---|---|---|
| `BC` | `BCs_000`, `BCs_001` | 0,1 |
| `BCFLAG` | `BCFlags` | — |
| `TIMESTAMPS` | `Timestamps` | — |
| `ORIGIN` | `Origins` | — |
| `COLLISION` | `Collisions_000`, `Collisions_001` | 0,1 |
| `AMBIGUOUSTRACK` | `AmbiguousTracks` | — |
| `AMBIGUOUSFWDTR` | `AmbiguousFwdTracks` | — |
| `AMBIGUOUSMFTTR` | `AmbiguousMFTTracks` | — |
| `TRACKQA` | `TracksQA_000…_003` | 0-3 |
| `FWDTRKCL` | `FwdTrkCls` | — |
| **`V0`** | **`V0s_000`, `V0s_001`, `V0s_002`** | 0-2 |
| **`CASCADE`** | **`Cascades_000`, `Cascades_001`** | 0,1 |
| **`DECAY3BODY`** | **`Decay3Bodys`** | — |
| `CALO` / `CALOTRIGGER` | `Calos`, `CaloTriggers` | — |
| `CPVCLUSTER` | `CPVClusters` | — |
| `ZDC` | `Zdcs_000`, `Zdcs_001` | 0,1 |
| `FV0A` / `FV0AEXTRA` / `FV0C` | `FV0As`, `FV0AsExtra`, `FV0Cs` | — |
| `FT0` / `FT0EXTRA` | `FT0s`, `FT0sExtra` | — |
| `FDD` / `FDDEXTRA` | `FDDs_000`, `FDDs_001`, `FDDsExtra` | 0,1 |
| `HMPID` | `HMPID_000`, `HMPID_001` | 0,1 |
| `TRDEXTRA` | `TRDsExtra` | — |
| `PMD` | `Pmds` | — |
| `MCCOLLISION` | `McCollisions_000`, `McCollisions_001` | 0,1 |
| `MCTRACKLABEL` / `MCCOLLISLABEL` | `McTrackLabels`, `McCollisionLabels` | — |
| `MCCALOLABEL` | `McCaloLabels_000`, `McCaloLabels_001` — **alias selects `_000`** | 0,1 |
| `MCFWDTRACKLABEL` / `MCMFTTRACKLABEL` | `McFwdTrackLabels`, `McMFTTrackLabels` | — |
| `HEPMCHEAVYION` / `HEPMCPDFINFO` / `HEPMCXSECTION` | `HepMCHeavyIons`, `HepMCPdfInfos`, `HepMCXSections` | — |
| `RUN2BCINFO` | `Run2BCInfos_000`, `Run2BCInfos_001` | 0,1 |
| `RUN2TRACKEXTRA` | `Run2TrackExtras_000`, `Run2TrackExtras_001` | 0,1 |

**`_FULL` forms** (label ≠ origin ≠ description; re-extract with the argument-order-aware parser): `StoredTracks`, `StoredTracksIU`, `StoredTracksCov`, `StoredTracksCovIU`, `StoredTracksExtra_000/_001/_002`, `StoredFwdTracks`, `StoredFwdTracksCov`, `StoredMFTTracks_000/_001`, `StoredMFTTracksCov`, `StoredMcParticles_000/_001`, `TrackedV0s`, `TrackedCascades`, `Tracked3Bodys`.

**Index tables** (§5.9, all eleven verified): `Run2MatchedExclusive`, `Run2MatchedSparse`, `Run2MatchedToBCSparse`, `Run3MatchedExclusive`, `Run3MatchedSparse`, `Run3MatchedToBCExclusive`, `Run3MatchedToBCSparse`, `MatchedBCCollisionsExclusive`, `MatchedBCCollisionsSparse`, `MatchedBCCollisionsExclusiveMulti`, `MatchedBCCollisionsSparseMulti`.

---

*Opus5_1:AO2D, 2026-08-10. All claims verified this session against the three artifacts in §1. The parser caveat in §4 is a defect in my own extraction, disclosed because it reproduces a known generator hazard.*
