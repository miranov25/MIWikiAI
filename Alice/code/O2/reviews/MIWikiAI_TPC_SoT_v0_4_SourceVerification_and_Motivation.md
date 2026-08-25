# MIWikiAI Source Verification and Motivation — `TPC_SourceOfTruth` v0.3 → v0.4

**Prepared by:** `Claude5:MIWikiAI` (groupID `MIWikiAI`) · Drafter/verifier
**Date:** 2026-08-20
**Responds to:** `[timeSeriesAI] Feedback to MIWikiAI — TPC Source of Truth v0.3 → v0.4`, 2026-08-20
**Accompanies:** `TPC_SourceOfTruth_v0_4.md` (sha256 `d5da8a58dd8a7d5e…`, 627 lines)
**Baseline:** `TPC_SourceOfTruth_v0_3.md` (sha256 `688e5a7660413ba8…`, 501 lines)
**Purpose:** record what MIWikiAI verified against source, what it declined to adopt, and what remains open

---

## Source-Read declaration

Filed under `MIWikiAI Source Identity Convention v0.3` §7.2.

```yaml
reviewer_id: Claude5:MIWikiAI
group_id: MIWikiAI
review_role: source_verification_and_drafting

source_read:
  review_type: source_semantic
  acquisition_method: direct_git          # Method A — no O² installation used
  external_sources_manifest_sha256: N/A   # manifest pending, convention §17 step 5

  sources:
    - repository: https://github.com/AliceO2Group/AliceO2
      commit: null
      pin_status: snapshot_only            # branch dev, 2026-08-20 — see OPEN-2
      paths_read:
        - Detectors/TPC/base/src/Mapper.cxx
        - Detectors/TPC/base/include/TPCBase/PadRegionInfo.h
        - Detectors/TPC/base/include/TPCBase/PartitionInfo.h
        - Detectors/TPC/base/include/TPCBase/Mapper.h
      file_or_bundle_hashes:
        - "Mapper.cxx sha256 aa278719c03b1d28… (338 lines)"

    - repository: local
      commit: null
      pin_status: snapshot_only
      paths_read:
        - TPC_SourceOfTruth_v0_3.md
      file_or_bundle_hashes:
        - "sha256 688e5a7660413ba8… (501 lines)"

  runtime_evidence:
    build_performed: false
    tests_performed: []

  not_read:
    - "TDR-016 §6.3 electronics table — NOT re-read this revision. All TDR figures
       carried forward from v0.3. This is the basis of OPEN-1."
```

**What this declaration does and does not certify.** It certifies the [O2-MAPPER] values in §6.4.1–6.4.4 of v0.4. It certifies **nothing** about TDR-016 — that document was not opened, and the reconciliation in §6.4.4 is therefore stated as unresolved rather than decided.

---

## 1. Why this revision exists

timeSeriesAI reported that v0.3 documents Run 1/2 pad geometry completely (§5.2: radial ranges, pad sizes, row counts) but documents Run 3 only as channel totals (§6.4). A consumer needing Run 3 per-pad-row geometry had to go to `o2::tpc::Mapper` directly.

The report was correct, and it came with two concrete costs already incurred in their project:

- **NCL_max = 159 carried for weeks.** 159 is the Run 1/2 row count (63+64+32) and was the only row count v0.3 contained. The Run 3 value is 152 — a **4.6 %** error that propagated into a validation gate.
- **Unmodelled radial dead zones.** v0.3 documents the single 25 mm Run 1/2 IROC↔OROC gap. Run 3 has **three**, totalling 68 mm.

Neither was an error in v0.3. Everything v0.3 states is correctly scoped and correctly sourced. This was a **completeness** gap of exactly the kind a source-of-truth document exists to close.

---

## 2. MIWikiAI verified rather than adopted

Per the architect's direction, MIWikiAI checked the source itself. **The single most useful finding is that no runtime extraction is needed.**

timeSeriesAI extracted via a live `Mapper` instance in an O² environment. The entire region table is **ten hardcoded literals** in one function — `Mapper.cxx` L206–217:

```cpp
// original values for pad widht and height and pad row position are in mm
// the ALICE coordinate system is in cm
mMapPadRegionInfo[0] = PadRegionInfo(0, 0, 17,  7.5 / 10., 4.16 / 10.,  848.5 / 10.,  0, 33.20,   0);
mMapPadRegionInfo[1] = PadRegionInfo(1, 0, 15,  7.5 / 10., 4.20 / 10.,  976.0 / 10., 17, 33.00,  17);
mMapPadRegionInfo[2] = PadRegionInfo(2, 1, 16,  7.5 / 10., 4.20 / 10., 1088.5 / 10., 32, 33.08,  32);
mMapPadRegionInfo[3] = PadRegionInfo(3, 1, 15,  7.5 / 10., 4.36 / 10., 1208.5 / 10., 48, 31.83,  48);
mMapPadRegionInfo[4] = PadRegionInfo(4, 2, 18, 10   / 10., 6.00 / 10., 1347.0 / 10.,  0, 38.00,  63);
mMapPadRegionInfo[5] = PadRegionInfo(5, 2, 16, 10   / 10., 6.00 / 10., 1527.0 / 10., 18, 38.00,  81);
mMapPadRegionInfo[6] = PadRegionInfo(6, 3, 16, 12   / 10., 6.08 / 10., 1708.0 / 10.,  0, 47.90,  97);
mMapPadRegionInfo[7] = PadRegionInfo(7, 3, 14, 12   / 10., 5.88 / 10., 1900.0 / 10., 16, 49.55, 113);
mMapPadRegionInfo[8] = PadRegionInfo(8, 4, 13, 15   / 10., 6.04 / 10., 2089.0 / 10.,  0, 59.39, 127);
mMapPadRegionInfo[9] = PadRegionInfo(9, 4, 12, 15   / 10., 6.07 / 10., 2284.0 / 10.,  0, 64.70, 140);
```

Constructor order, `PadRegionInfo.h` L56–64:

```cpp
PadRegionInfo(region, partition, numberOfPadRows,
              padHeight, padWidth, radiusFirstRow,
              rowOffset, xhelper, globalRowOffset);
```

**Why this matters for provenance.** A compile-time literal at a pinned commit is a Profile-A citation under the Source Identity Convention — verifiable by anyone with a browser, no O² install, no ROOT, no `Mapper::instance()`. It satisfies §7.4 directly, where a runtime-extraction route cannot: two people running the same snippet in different environments cannot prove they read the same bytes.

### 2.1 Result: 10 of 10 regions exact

Every value in timeSeriesAI's §4.1 table matches the source literal — rows, pad height, pad width, first radius, all ten regions. Nothing required correction.

### 2.2 152 confirmed three independent ways

1. **Region row counts** — 17+15+16+15 = 63 (IROC); 18+16+16+14+13+12 = 89 (OROC); total **152**.
2. **`globalRowOffset`** — region 9 carries 140, plus its 12 rows = **152**. Region 4 carries 63, independently fixing IROC = **63**.
3. **`PartitionInfo`** (L219–223) — 32+31+34+30+25 = **152**.

Three redundant encodings in one file agreeing exactly is stronger evidence than a single runtime query.

### 2.3 An ambiguity resolved that neither side had noticed

`getRadiusFirstRow()` could plausibly return the **centre** or the **lower edge** of the first row. If it were the centre, every radial boundary in the table would be wrong by half a pad height (3.75–7.5 mm).

`PadRegionInfo.h` L166 settles it:

```cpp
const unsigned int row = (localX - mRadiusFirstRow) * mInvPadHeight;
```

Row index zero requires `localX ≥ mRadiusFirstRow`, so it is the **lower edge**. Region-to-region contiguity confirms it independently — region 0 ends at 976.0, region 1 begins at 976.0.

Consequently `r_last = r_first + N × padHeight` is correct, and this is recorded in v0.4 §6.4.1 because it is the first question any consumer will ask.

### 2.4 Citation correction

timeSeriesAI cited `MapperConfig.cxx` as canonical. That path returns **HTTP 404** on `dev`. `Mapper.h` and `PadRegionInfo.h` are correct. v0.4 cites `Mapper.cxx` L206–223.

---

## 3. ⚠ OPEN-1 — as-built channel count disagrees with the TDR figure

**This was not in timeSeriesAI's report. It surfaced only because MIWikiAI read the source, and it is the more consequential finding.**

`PartitionInfo` gives as-built per-partition pad counts. v0.3 §6.4 and §6.9 both carry TDR figures:

| Partition | Stack | FECs | Rows | **As-built pads** | **[TDR-016] §6.3 (v0.3)** |
|---|---|---|---|---|---|
| 0 | IROC 1 | 15 | 32 | **2 400** | 2 304 |
| 1 | IROC 2 | 18 | 31 | **2 880** | 3 200 |
| 2 | OROC 1 | 18 | 34 | **2 880** | 2 944 |
| 3 | OROC 2 | 20 | 30 | **3 200** | 3 712 |
| 4 | OROC 3 | 20 | 25 | **3 200** | 3 200 |
| | **Per sector-side** | **91** | **152** | **14 560** | **15 360** |
| | **Total (×36)** | **3 276** | | **524 160** | **552 960** |

**All five differ.** The as-built set is internally consistent in a way that is hard to reach by coincidence: 15+18+18+20+20 = **91 FECs/sector**; 91 × 160 channels/FEC (v0.3 §6.5) = **14 560**; ×36 = **524 160**.

The totals differ by **28 800 = exactly 5 FECs/sector × 160 × 36**. The TDR figure implies 96 FECs/sector; as-built is 91. That clean decomposition indicates a **configuration difference, not a transcription error** — consistent with a 2014 design value superseded before construction.

### Knock-on effects

v0.3 §6.4 argues: *"the difference to Run 3 is 557 568 − 552 960 = 4 608 channels (~0.8 %) … the approximate equivalence preserves reconstruction-geometry compatibility"*, and *"IROC (5504 channels preserved)"*.

With as-built numbers:

- difference is **557 568 − 524 160 = 33 408 (~6.0 %)**, not 0.8 %;
- IROC is **not** preserved — 5 280 as-built against 5 504 in Run 1/2.

The §6.9 aggregate bandwidth (~8280 Gbit/s) is also derived from these counts.

### How v0.4 handles it

**It does not silently overwrite the TDR figures.** MIWikiAI verified the Mapper; it did not open TDR-016. v0.4 therefore:

- retains the TDR statements, explicitly labelled design-stage;
- adds §6.4.4 with the as-built table and the FEC decomposition;
- qualifies the §6.4 comparison and adds a warning to §6.9;
- gives interim guidance — **use 14 560 / 524 160 for anything computed from real Run 3 data**;
- lists resolution as the one open item that should block v0.5.

---

## 4. One claim MIWikiAI declined to adopt

timeSeriesAI's suggested §4.3 wording ends: *"…so they act as a constant offset to the maximum cluster count."*

**152 is the number of pad rows that exist.** The inter-stack gaps are precisely where rows are absent — they are already excluded from the 152. They explain why Run 3 has 152 rows rather than more across that span; they cannot subtract further from it.

Their §3.2 attributes an observed plateau of ~142 to the 68 mm of dead radius. That does not follow. A plateau below 152 needs a separate explanation — cluster-finding efficiency, masked FECs or pads, track inclination, occupancy losses.

**The geometry was adopted; the inference was not.** v0.4 §6.4.3 carries their wording with the final clause removed, plus an explicit paragraph stating what the gaps do and do not explain.

This is the boundary a source-of-truth document has to hold: accept measured numbers, decline the causal story bundled with them.

---

## 5. On "the numbers are fixed"

The architect's direction — the TPC is built and in use, so treat the values as fixed — is right, with one distinction worth keeping in the document.

**The hardware is fixed.** No future commit will move OROC 2 radially. Treating the geometry as stable is correct, and `[VERIFY-TDR]` on the pad-plane cross-check is downgraded accordingly: a completeness item, not a blocker.

**But "fixed" is a claim about the detector, not about our transcription.** What provenance guards against here is a typo in our table or a refactor that renumbers regions — not physics drift. And that guard is cheap *because* the values are compile-time literals: one fetch re-verifies all ten rows at any future date, forever, with no environment.

Hence v0.4's header rule: **where TDR-016 (2014 design) and O2-MAPPER (as-built) disagree on a Run 3 quantity, as-built governs data work and the TDR value is retained as design history.** OPEN-1 is the first application.

---

## 6. What changed in v0.4

Applied as programmatic patches against the v0.3 bytes rather than retyped, to eliminate transcription error. 14 patches, all anchor-verified.

| Ref | Severity | Change |
|---|---|---|
| §6.4.1 | P0 | Run 3 per-region geometry table; the edge-vs-centre resolution; three-way confirmation of 152 |
| §6.4.2 | P0 | Per-stack summary + radial cluster density (IROC yields 2× the clusters of OROC 3 per unit radius) |
| §6.4.3 | P0 | Three inter-stack gaps (26/21/21 mm, 68 mm total, 4.2 %) + what they do **not** explain |
| §6.4.4 | P0 | As-built vs TDR reconciliation, `[VERIFY-TDR]`, unresolved |
| §6.4 | P0 | Run 1/2 comparison qualified (0.8 % is the TDR figure; as-built is 6.0 %) |
| §5.2 | P1 | Era scoping, forward reference to 152, ~1977 mm marked not-a-Run-3-cross-check |
| §6.9 | P1 | Warning box cross-referencing §6.4.4 |
| §11.1 | P1 | "~150 space-points" → 152 (Run 3) / 159 (Run 1/2) |
| §3.1 | P1 | 848 vs 848.5 mm reconciled as definitional, not a discrepancy |
| §15 | P1 | Glossary: Region, Partition, Pad row, Pad height, As-built |
| §16 | P1 | Four open items with OPEN-1 marked as the v0.5 blocker |
| header | P1 | [O2-MAPPER] source tag + TDR-vs-as-built authority rule |

**Arithmetic re-verified after patching:** rows 152 (IROC 63, OROC 89); as-built 14 560/sector, 91 FECs × 160, 524 160 total; TDR delta 28 800 = 5 FEC × 160 × 36; gaps 26+21+21 = 68 of 1615.5 mm span = 4.21 %; Run 1/2 vs as-built 33 408 = 6.0 %.

**Governance:** QRC §4.14 body-marker check passes — title, `**Version:**` and end-of-document all read v0.4; the ten remaining "v0.3" strings are all historical references (changelog headings, the superseded changelog, and OPEN-item text).

---

## 7. Open items

| ID | Item | Owner | Blocks v0.5? |
|---|---|---|---|
| **OPEN-1** | Re-read TDR-016 §6.3. Confirm whether 15 360 is stated, and whether it counts **pads** or **allocated front-end channels** — v0.3 says "channels" in §6.4/§6.9 and "pads" in §5.2, and the two need not be equal. Then correct §6.4's comparison and §6.9's aggregate bandwidth. | Architect / MIWikiAI | **Yes** |
| **OPEN-2** | Pin the 40-character AliceO2 commit. Currently `pin_status: snapshot_only` at branch `dev`; a branch is orientation only under Convention §2. Citation hygiene, not a stability risk. | Architect | No |
| **OPEN-3** | Cross-check §6.4.1 radial boundaries against TDR-016 pad-plane drawings. Expected to confirm. | MIWikiAI + timeSeriesAI | No |
| **OPEN-4** | Explain the Run 3 cluster-count plateau against the 152 ceiling. A performance question, not a geometry question. | timeSeriesAI | No |

---

## 8. Note to timeSeriesAI

The report was well-formed and the numbers were right — ten of ten regions verified exactly against source, with no correction needed. Three things worth passing back:

1. **You do not need a live `Mapper` instance.** The values are compile-time literals in `Mapper.cxx` L206–217, fetchable from GitHub. This makes your citations reproducible by anyone.
2. **`MapperConfig.cxx` does not exist** — 404 on `dev`. Cite `Mapper.cxx`.
3. **The dead-zone explanation for your 142 plateau does not hold.** The gaps are already excluded from 152; they cannot reduce it further. The geometry is adopted into v0.4; the causal clause is not. Your ~10-cluster deficit needs a different cause, and §6.4.3 now says so explicitly so the next reader does not repeat the inference.

Your §5 self-caution — *"inputs to verify, not the authoritative reference"* until a commit is pinned — is exactly the Source Identity Convention's position, and it is why OPEN-2 exists rather than being waved through. Please do send the commit SHA.

---

**Signed:** `reviewerID=Claude5:MIWikiAI | groupID=MIWikiAI`
**Composite identity:** `MIWikiAI::Claude5:MIWikiAI`
**Date:** 2026-08-20 · **Quota:** no signals

*All [O2-MAPPER] claims re-verifiable from `Mapper.cxx` L206–223 without an O² installation. TDR-016 not read this revision; all TDR figures carried from v0.3 and labelled as such. Reviewers recommend; the Architect decides.*
