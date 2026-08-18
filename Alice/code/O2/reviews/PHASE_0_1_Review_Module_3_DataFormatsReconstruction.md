# Review — Module 3: `DataFormats_Reconstruction.md` v0.1

**Issued:** 2026-04-23
**Artefact under review:** `Alice/code/O2/DataFormats_Reconstruction.md` v0.1 (Coder: Claude8)
**For:** 7-reviewer panel — Claude1, Claude2, Claude3, Claude4, Claude5, Claude6, Claude7
**Review cycle:** 1, one round
**Governance:** PHASE_0_1_Proposal_AliceO2_Framework_Indexation v3; MTTU_Reviewer v1.21; Reviewer_Quick_Reference_Card v1.27; SUMMARY v0.3 §7.1 sprint mode
**Module 1 baseline (approved):** `AliceO2_overview.md` v0.5, 2026-04-23 — anchors frozen.
**Module 2 baseline (in review):** `Framework_DPL.md` v0.1 — **anchors may shift** before Module 3 gate 3. Findings about Module 2 cross-refs should note whether they are stable-across-likely-v0.2 or version-sensitive.

Single document: prompt + assignment + per-aspect checklists + finding grammar + verdict grammar + output format.

---

## 1. What every reviewer does

### 1.1 Read the whole document

Read `DataFormats_Reconstruction.md` v0.1 end to end. Note:

- **Clarity.** Does §2 (context: 5-parameter Gaussian tracks, local-frame convention, cross-detector binding) give enough grounding before §3 directory layout? Does §4 (core classes) make sense without having the header files open?
- **Scope discipline.** Content belonging to wave-2 (per-detector cluster/digit formats) or Module 5 (reconstruction algorithms) or planned Module 6 (MC formats) should be flagged.
- **`known_verify_flags` completeness.** This draft explicitly flags 5 items as not directly fetched (full DataFormats/Reconstruction/ listing, Track.h class signatures, GlobalTrackID::Source enum, RecoContainer contents, SHA re-verification). Claude8 has been honest about gaps — verify the flags cover all the gaps, not just the ones noticed.
- **Module 1/2 cross-references.** Module 1 anchors are frozen; Module 2 anchors are v0.1 draft. Every `./AliceO2_overview.md` ref should resolve; every `./Framework_DPL.md` ref should be annotated if the target is version-sensitive.

Return up to 3 whole-document findings.

### 1.2 Deep-validate your assigned aspect

Primary runs the full checklist; secondary cross-checks at least half, prioritising `[crit]`.

### 1.3 Red-team external fetch — MANDATORY for Aspect D primary

**Heightened for Module 3.** The Aspect D primary (Claude2) MUST close the most consequential `known_verify_flag` by performing a direct fetch of `DataFormats/Reconstruction/include/ReconstructionDataFormats/` directory listing at SHA `87b9775`. Additionally, at least one peer-reviewed DPL/tracking source not cited in the wiki must be fetched (same rule as Module 2).

Directory-enumeration red-team purpose: v0.1 infers file existence from cross-references; Aspect D must produce the actual file list and report any omissions. This closes `known_verify_flags[0]`.

---

## 2. Finding grammar and verdict grammar

Same as Modules 1 and 2 — P0 / P1 / P2; verdict options `[OK]` / `[!]` APPROVED WITH COMMENTS / `[X]` CHANGES REQUESTED / `[X] BLOCKED`.

Each finding includes section anchor, quoted claim, what is wrong, primary-source evidence, suggested fix.

Identity persistence: use assigned `ClaudeN` verbatim.

---

## 3. Assignment table

Aspects rotate from Module 2 so that no reviewer repeats the same aspect in three modules. The rotation also distributes the Aspect D red-team-fetch workload.

### 3.1 Per-reviewer assignment

| Reviewer | Primary aspect | Secondary aspect |
|---|---|---|
| **Claude1** | F. Quantitative closure (enumerations, parameter counts, covariance element counts) | E. Schema |
| **Claude2** | D. Primary-source citations + **directory-enumeration red-team fetch** | A. Track physics / conventions |
| **Claude3** | B. Software architecture (class design, cross-detector binding) | F. Quantitative closure |
| **Claude4** | A. Track physics / conventions (5-param, local frame, forward hierarchy) | G. Cross-references |
| **Claude5** | E. Schema and front-matter | B. Software architecture |
| **Claude6** | C. Repository structure and scope boundaries | D. Primary-source citations |
| **Claude7** | G. Cross-references and external links | C. Repository structure |

### 3.2 Per-aspect assignment (inverse view)

| Aspect | Topic | Primary | Secondary |
|---|---|---|---|
| **A** | Track physics / conventions — 5-param, local frame, forward vs barrel | Claude4 | Claude2 |
| **B** | Software architecture — class design, hierarchies, cross-detector binding | Claude3 | Claude5 |
| **C** | Repository structure and scope boundaries | Claude6 | Claude7 |
| **D** | Primary-source citations + **directory enumeration + red-team external fetch** | Claude2 | Claude6 |
| **E** | Schema and front-matter compliance | Claude5 | Claude1 |
| **F** | Quantitative closure — counts, enumerations, covariance elements | Claude1 | Claude3 |
| **G** | Cross-references and external links | Claude7 | Claude4 |

### 3.3 Aspect-rotation tracker (across all three modules so far)

| Reviewer | Module 1 primary | Module 2 primary | Module 3 primary |
|---|---|---|---|
| Claude1 | A | D (red-team) | F |
| Claude2 | E | A | D (red-team + directory enum) |
| Claude3 | B (retry) | E | B |
| Claude4 | F | B | A |
| Claude5 | C | F | E |
| Claude6 | G | C | C |
| Claude7 | D | G | G |

Each reviewer has now touched 3 distinct aspects as primary. Claude6 and Claude7 repeat because the alternative would create a conflict with the red-team-fetch rotation.

---

## 4. Per-aspect deep-validation checklists

### Aspect A — Track physics and conventions

**Primary:** Claude4. **Secondary:** Claude2.
**Document scope:** §2.2 (local-frame convention), §2.3 (barrel vs forward hierarchies), §4 (all core track classes), §6.4 (DCA).

- [ ] `[crit]` 5-parameter ordering `(Y, Z, Snp, Tgl, Signed1Pt)` — verify against AnalysisDataModel.h column declarations AND a direct Track.h fetch (this is the key load-bearing physics claim).
- [ ] `[crit]` Local-frame semantics — `X` is radial, `Alpha` is sector rotation. Verify against ALICE tracking convention.
- [ ] `Snp = sin(φ)`, `Tgl = tan(λ)`, `Signed1Pt = q/pT` in (c/GeV) — all three verified against Doxygen comments or Track.h.
- [ ] `[crit]` Forward hierarchy — parameterization at constant `Z` (not constant `X`) — verify against TrackFwd.h.
- [ ] `[crit]` `SMatrix<double, 5, 5, MatRepSym<double, 5>>` for covariance = 15 unique elements — verify in TrackFwd.h and Track.h.
- [ ] `propagateTo`, `propagateToDCA` (barrel) and `propagateToDCAhelix`, `propagateToVtxhelixWithMCS`, `propagateToVtxlinearWithMCS` (forward) — verbatim method names match TrackFwd.h.
- [ ] "MCS" = multiple Coulomb scattering — claim correct? verify in doc strings.
- [ ] `TrackParCov` vs `TrackPar` — Cov extends Par with covariance only; no extra kinematic content — verify.
- [ ] `TrackTPC`, `TrackITS`, `TrackTPCITS` extend `TrackParCov` — verify against actual headers (wave-2 scope, but the claim is made here).
- [ ] `[crit]` Track-at-PV vs track-at-IU distinction — AnalysisDataModel declares both `Tracks` and `TracksIU`. Comment "On disk version of the track parameters at inner most update (e.g. ITS) as it comes from the tracking" is verbatim from the source — confirm.
- [ ] DCA class with 2D displacement (dcaXY, dcaZ) + 2×2 covariance (cYY, cZY, cZZ) — verify against DCA.h (direct fetch needed).
- [ ] `DECLARE_SOA_DYNAMIC_COLUMN` formulas for `Px`, `Sign`, `IsWithinBeamPipe`, `PIDForTracking` — verify verbatim against AnalysisDataModel.h.

### Aspect B — Software architecture

**Primary:** Claude3. **Secondary:** Claude5.
**Document scope:** §2 (design constraints — messageable, ROOT-serializable, compact, numerically stable), §4.4 (detector-specific extensions), §7 (GlobalTrackID + RecoContainer cross-detector binding).

- [ ] `[crit]` "Messageable" constraint — trivially copyable, no virtual, no heap pointers — consistent with Module 2 §5.4 and Framework/Core/README.md supported types.
- [ ] "ROOT-serializable" round-trip claim — verify that `TrackParCov` is indeed declared ROOT-dictionary-friendly (can be `adopt`ed or `snapshot`ed per Module 2).
- [ ] §2.4 "cross-detector binding problem" narrative — check that the list of track-source types (ITS standalone, TPC standalone, ITS-TPC matched, etc.) is representative.
- [ ] `[crit]` `GlobalTrackID` encoding — 32-bit, source + index — verify against GlobalTrackID.h (direct fetch needed; Aspect D will close).
- [ ] `GlobalTrackID::Source` enum listed values — enumeration representative; exact order and count deferred to Aspect F.
- [ ] `[crit]` `RecoContainer::collectData(pc, dataRequest)` API — verify method signature against RecoContainer.h (direct fetch).
- [ ] `RecoContainer::createTracksVariadic` — verify method exists and signature matches.
- [ ] `RecoContainer::getTrackParam(gtrid)` — verify this accessor exists and returns a track regardless of source.
- [ ] `TrackTPCITS` as the refitted merged track — verify it extends `TrackParCov` and carries references to source ITS and TPC tracks.
- [ ] `MatchInfoTOF`, `MatchInfoHMP`, `GlobalFwdTrack`, `TrackCosmics`, `TRDTrkInfo` — verify all 5 exist as classes in `DataFormats/Detectors/GlobalTracking/`.
- [ ] "ROFrame records declare `{firstEntry, nEntries}` sub-slices" claim — verify in an actual ROFrame header (ITS, MFT, or MCH).
- [ ] `ASoA` / Apache Arrow substrate claim — verify ASoA.h uses Apache Arrow as backend (or correct the claim).

### Aspect C — Repository structure and scope

**Primary:** Claude6. **Secondary:** Claude7.
**Document scope:** §3 (directory layout), §1.2 (what is not), §8 (AOD relationship — partial scope), §9 (limitations).

- [ ] §3.1 table: `DataFormats/` has 4 top-level subdirectories (Reconstruction, Detectors, Detectors/GlobalTracking, simulation) — verify against Module 1 §3.1 row "DataFormats/" (frozen anchor).
- [ ] `[crit]` §3.2 inferred list of ReconstructionDataFormats headers (Track.h, TrackFwd.h, TrackUtils.h, BaseCluster.h, PID.h, DCA.h, Vertex.h, PrimaryVertex.h, V0.h, Cascade.h, GlobalTrackID.h) — cross-check against Aspect D's directory enumeration. Expect 1-2 additions/renames; flag any major misses.
- [ ] `[crit]` §3.3 inferred list of GlobalTracking headers (RecoContainer.h, RecoContainerCreateTracksVariadic.h, TrackTPCITS.h, MatchInfoTOF.h, MatchInfoHMP.h, TrackCosmics.h, GlobalFwdTrack.h, TRDTrkInfo.h) — cross-check against direct directory listing.
- [ ] §1.2 scope excludes (per-detector clusters/digits to wave 2; reconstruction algorithms to Module 5; MC formats to Module 6; analysis tables to O2Physics) — all accurate and non-overlapping.
- [ ] §3.4 classification of `AnalysisDataModel.h` as straddling DPL and DataFormats — correct framing or should this be pure Module 2 material?
- [ ] §1.3 dependency graph (this module builds on Modules 1 and 2; is built on by Module 4 and wave 2) — correct.
- [ ] `log.txt`, `Testing/` vs `tests/` edge cases from Module 1 not relevant here — confirm no new repo-root-file puzzles.
- [ ] DataFormats/simulation/ is out of scope for Module 3 and will be Module 6 — correct and consistently applied.

### Aspect D — Primary-source citations + directory-enumeration red-team fetch

**Primary:** Claude2. **Secondary:** Claude6.
**Document scope:** all `[GH]`, `[DX]`, `[PP]` inline tags; front-matter `source_fingerprint.upstream[]`; §11.1–§11.4 URLs.

**Mandatory direct fetches for this aspect:**

- [ ] `[crit]` Full directory listing of `https://github.com/AliceO2Group/AliceO2/tree/dev/DataFormats/Reconstruction/include/ReconstructionDataFormats` at SHA `87b9775`. Produce a complete file list in your report. Compare against wiki §3.2. Flag any omissions or false-positives.
- [ ] `[crit]` Full directory listing of `https://github.com/AliceO2Group/AliceO2/tree/dev/DataFormats/Detectors/GlobalTracking/include/DataFormatsGlobalTracking`. Compare against §3.3.
- [ ] Direct fetch of `DataFormats/Reconstruction/include/ReconstructionDataFormats/Track.h`. Verify 5-parameter ordering, public API methods cited in §4.1/§4.2.
- [ ] Direct fetch of `DataFormats/Reconstruction/include/ReconstructionDataFormats/GlobalTrackID.h`. Enumerate `Source` enum values; compare to §7.1 and §B.3.
- [ ] Direct fetch of `DataFormats/Reconstruction/include/ReconstructionDataFormats/PID.h`. Verify 9-entry species enumeration.
- [ ] Direct fetch of `DataFormats/Reconstruction/include/ReconstructionDataFormats/DCA.h`. Verify DCA constructor signature.

**Citation audit:**

- [ ] Every `[GH:]` tag — cited file exists at SHA `87b9775` and the specific claim is supported.
- [ ] Every `[DX:]` tag — Doxygen URL resolves and displays the expected content.
- [ ] `[PP: arXiv:2402.01205]` citations — consistent with prior modules; referenced section exists.
- [ ] Front-matter `source_fingerprint.upstream[]` — all 9 entries URL-checked.
- [ ] `known_verify_flags` — 5 flags; each has a body pointer and is actually-unfetched.

**Red-team external fetch (any peer-reviewed source NOT in upstream[]):**

- [ ] Candidates: Shahoyan et al. ALICE tracking papers; ITS / TPC reconstruction proceedings at CHEP 2018 / 2021 / 2023; ACAT tracking talks; arXiv:2106.08353 (Kvapil et al. — used in Module 1 CONFLICT-1 but could be re-fetched for tracking-specific claims).
- [ ] Report confirmations / contradictions / gaps against wiki's load-bearing claims.
- [ ] Log in §6 of your review report (named section).

Output: citation log + directory enumeration + red-team log.

### Aspect E — Schema and front-matter compliance

**Primary:** Claude5. **Secondary:** Claude1.
**Document scope:** front-matter YAML; body section numbering; anchor convention; Appendix A format.

- [ ] All mandatory front-matter fields per Phase 0.1 v3 §2.1 present.
- [ ] `wiki_id: O2_DataFormats_Reconstruction` — naming convention.
- [ ] `source_inconsistencies: []` empty is permitted.
- [ ] `peer_reviewers_assigned` vs `peer_reviewers_reported` two-field convention applied.
- [ ] `known_verify_flags` has 5 entries; each has a body pointer (§9 or inline).
- [ ] `searchable_keywords` ≥ 15 entries (document has 40).
- [ ] Body sections follow Phase 0.1 v3 schema variation (§2 context + §3 directory). Schema-note announcement present at top of §2.
- [ ] Anchors mechanical (lowercase-hyphen). Spot-check 5+.
- [ ] Appendix A closure checks (A.1–A.6) each have claim / primary evidence / result.
- [ ] Appendix B notation extends Module 2 B.2 with DataFormats-specific terminology; §B.3 cross-detector source enumeration is clearly marked as indicative pending Aspect D closure.
- [ ] Status `CYCLE_0_SELF_REVIEW_PENDING` / `review_cycle: 0` consistent with v0.1.

### Aspect F — Quantitative closure

**Primary:** Claude1. **Secondary:** Claude3.
**Document scope:** Appendix A (A.1–A.6) plus every count/enumeration claim in body.

- [ ] `[crit]` A.1: 5 track parameters — re-verify from direct fetch of Track.h (Aspect D will produce).
- [ ] `[crit]` A.2: 15 covariance elements — formula `n*(n+1)/2 = 15` for n=5 — trivially correct.
- [ ] A.3: 9 PID species — verify from PID.h fetch.
- [ ] A.4: 2 track hierarchies (barrel + forward) — confirm.
- [ ] `[crit]` A.5: RecoContainer wrapped-pointer category count — not closed in v0.1. Report this explicitly; if direct RecoContainer.h fetch is possible (Aspect D may produce), produce the count.
- [ ] A.6: 7 AOD tables traceable to reconstruction — re-verify list against AnalysisDataModel.h.
- [ ] §2.1 design constraints count: 4 (messageable, ROOT-serializable, compact, numerically stable) — informational, no closure needed.
- [ ] §2.5 AOD tables from reconstruction count: 6 in §2.5 table, 7 in §8.1 table — flag potential discrepancy.
- [ ] §5.1 PID: "9 entries" — matches A.3.
- [ ] §B.3 GlobalTrackID::Source ~17 values listed — final count subject to Aspect D enumeration.
- [ ] `commit_verified: 87b9775` reused from Module 1 — acceptable? or should Module 3 pin a newer SHA?

For each count: claim | source | re-verified | match. Mismatches P1.

### Aspect G — Cross-references and external links

**Primary:** Claude7. **Secondary:** Claude4.
**Document scope:** §10 cross-ref table, §11 external-ref tables, inline links.

- [ ] `[crit]` `./AliceO2_overview.md` references — targets exist in APPROVED v0.5. `§1.3`, `§3.1` specifically cited.
- [ ] `[crit]` `./Framework_DPL.md` references — target page exists (v0.1 in review). Flag each cross-ref as "stable if Module 2 anchors hold" or "depends on Module 2 v0.2".
- [ ] `./Common_utilities.md` status `planned` — correct.
- [ ] `../../TDR/O2.md`, `../../TDR/tpc.md`, `../../TDR/its.md` references — targets exist in MIWikiAI TDR/ folder.
- [ ] `../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md` — verify live.
- [ ] `[crit]` §11.1 URLs (7 GitHub URLs) — fetch, confirm 200.
- [ ] `[crit]` §11.2 URLs (4 Doxygen URLs) — fetch, confirm alive (note: Doxygen may 404 if page restructured).
- [ ] §11.3 arXiv URL — confirm.
- [ ] §11.4 ecosystem URLs (3) — confirm.
- [ ] Internal §-anchor references — target sections exist.

~14 URLs. Primary fetches all; secondary ≥ 7 including `[crit]`. Output: URL-status ledger.

---

## 5. Output format for review reports

```
PHASE_0_1_ReviewReport_Module_3_Claude<N>.md
```

Structure same as Module 2 with:
- §4 validation log (mandatory for aspects D, F, G)
- §6 Red-team external fetch **AND** directory enumeration (Claude2 / Aspect D primary only)

---

## 6. Time budget

- Whole-document read: 25–35 min.
- Aspect primary: 30–60 min.
- Aspect secondary: 15–30 min.
- Claude2 (Aspect D with directory enumeration + red-team fetch): +45 min.

---

## 7. Reminders

- `known_verify_flags` are explicit gaps. Closing them is work for Aspect D. Finding *additional* gaps that Claude8 missed is also valuable — flag them.
- Module 2 anchor dependency — this wiki is being authored while Module 2 is still in cycle-1 review. Do not penalize Module 3 for Module 2 uncertainty; flag it.
- Simulation data formats (MCTrack, MCLabel) are out of scope — they will be Module 6. Don't flag absence as a gap.
- `O2Physics` analysis tables are out of scope — they live in a separate repository. The `AnalysisDataModel.h` schema is in-scope only for reconstruction-origin columns.
- Architect has final authority on scope and schema questions.
- `source_inconsistencies: []` is fine if red-team fetch finds no contradictions. If it finds one, raise it.

---

## 8. Acceptance gate

7 review reports → Claude7 synthesis + actionable fix-list → Claude8 applies fixes as v0.2 or v0.5 → architect gate 3. On approval, Module 4 (Common_utilities) kickoff proceeds.

Module 3 anchors freeze on approval.

---

*Review issued by Claude8 (Coder, Module 3), 2026-04-23, on behalf of architect Marian Ivanov.*
