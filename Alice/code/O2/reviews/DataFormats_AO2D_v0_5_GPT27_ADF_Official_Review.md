[GPT27:ADF] [AliasDataFrame] [REVIEWER] [DataFormats_AO2D_v0_5_ADF_INTEGRATION] [!]

# Official ADF-Side Review — `DataFormats_AO2D` v0.5

**Review date:** 2026-08-10  
**Reviewer:** `GPT27:ADF`  
**Canonical document:** `DataFormats_AO2D_v0_5.md`  
**Generated companion:** `DataFormats_AO2D_v0_5.html`  
**Markdown MD5:** `3acbb75cd64d0e9b137e1e6b7bf54731`  
**Markdown SHA-256:** `f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19`  
**HTML MD5:** `5ca768f8c13ac3736a8b567a33ae2d7e`  
**HTML SHA-256:** `41aea8de7322e82569d5a33384ef5665b5a6cbec7078614d35b31319afea1180`  
**Declared canonical Markdown SHA-256 in HTML:** `f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19` — **MATCH**

**ADF-side verdict:** **`[!] APPROVED_WITH_COMMENTS`**  
**ADF integration direction:** **APPROVED**  
**Full document ratification:** **NOT YET**  
**Next revision required before ratification:** **YES — bounded v0.5.1 / equivalent, no architecture rewrite**

---

# 1. Executive decision

From the AliasDataFrame side, I approve the architecture and the semantic mapping in `DataFormats_AO2D` v0.5.

The document has become a useful AO2D orientation reference. In particular, the decision to put the **standard/base `AnalysisDataModel.h` backbone before the LF V0/cascade specialization** is correct. A new ADF/AO2DAI coder can now understand the main conceptual graph:

```text
BCs
  ↓
Collisions
  ↓
Tracks
  ↓
detector / matching / MC / helper families

plus:

V0 / Cascade PWG tables
  ↓
relations back to standard collisions and tracks
```

The page also correctly separates:

- source semantics from physical AO2D storage;
- external indices from row/global identity;
- scalar/slice/array/self indices;
- ordinary index columns from index-equivalence and index-table mechanisms;
- source-proven positional joins from equal-row-count heuristics;
- physical AO2D evidence from current source declarations;
- AO2DAI semantic discovery from the ADF adapter layer.

No ADF-side architectural rewrite is required.

However, v0.5 is **not yet ratifiable**. The document itself correctly marks the remaining work in §24. The ADF-specific reason is straightforward: §17.2 is still deliberately schematic and labelled `ADF VALIDATION REQUIRED`. The exact public ADF adapter must be pinned and executed before this page can become the frozen code-writing authority.

---

# 2. Direct answers

## Is it approved?

**ADF side: yes, with comments.**

I approve:

- the concept mapping in §17;
- the normalized-key adapter idea;
- ADF not discovering O² semantics on its own;
- exact physical/source dtype and provenance preservation at the AO2D adapter boundary;
- partition identity as part of Python relation identity;
- source-driven relation semantics;
- the generated-registry → AO2DAI loader → ADF architecture.

I do **not** approve v0.5 as a fully ratified/frozen wiki page yet, because the ADF public call and executable oracles are still intentionally unresolved.

## Do we need the next revision?

**Yes, but only a bounded revision.**

A v0.5.1-style correction should close the ADF integration items and incorporate the final source/registry validation results. It does not need another conceptual rewrite.

## Are AO2D tables well described to get an overview?

**Yes.**

The standard/base AO2D tables are now described well enough for a new reviewer or coder to understand the architecture and major families.

The document is intentionally **not** an exhaustive hand-maintained table catalogue. That is the right design: the human page explains the topology and mechanisms, while `DataFormats_AO2D.json` is intended to carry exact code-driving records.

For an overview, the coverage is strong. For exact code generation, the generated registry is still required.

---

# 3. ADF integration review

## 3.1 §17.1 — “ADF does not discover O² semantics”

**APPROVED.**

This is the correct ownership boundary.

ADF should receive already-resolved information such as:

```text
logical child table
relation target
parent key
child key / normalized key
partition identity
applicability
dtype
provenance
relation kind
```

ADF must not infer O² semantics from:

- tree names;
- branch spelling;
- equal row counts;
- guessed pluralization;
- “highest version” heuristics.

This boundary is essential for keeping ADF general-purpose rather than embedding AliceO2-specific semantics into ADF core.

## 3.2 §17 mapping table

**APPROVED conceptually.**

The mapping is suitable for ADF integration:

| O² semantic concept | ADF-side treatment |
|---|---|
| persistent logical table | ADF frame |
| external scalar relation | subframe/relation adapter |
| positional source join | source-proven logical combined view |
| dynamic/expression quantity | ADF alias/function after equivalence validation |
| partition identity | explicit relation/provenance key |
| index equivalence | metadata, not an automatic join |
| unresolved positional candidate | no semantic ADF join |

The document correctly avoids forcing every O² mechanism into one generic “join”.

## 3.3 §17.2 — executable ADF call

**NOT YET FROZEN — this is the principal ADF-side ratification item.**

The current example is explicitly fabricated:

```python
register_relation(...)
```

That is appropriate in a draft, because it prevents readers from mistaking pseudocode for an existing public API.

Before ratification, replace it with a tested call against the selected ADF source.

The first production adapter should use the public `register_subframe(...)` contract, with the exact accepted relation-key strategy.

The evidence must cover at least:

```text
eval
alias evaluation/materialization
selection=
group_by=
facet_by=
draw expression
nested subframe access
missing-key behavior
duplicate-key refusal/policy
partition-isolation oracle
```

This is important because historical ADF evidence shows that direct relation lookup and all draw/expression slots have not always exercised asymmetric relation names uniformly.

## 3.4 §17.3 — symmetric normalized keys

**APPROVED and recommended for the first AO2DAI production adapter.**

The rule is semantically clean:

```text
physical parent key  ┐
                     ├─ AO2DAI normalized logical key → ADF relation
physical child key   ┘
```

provided AO2DAI preserves:

- both original physical key names and values;
- exact physical dtype;
- source target identity;
- partition scope;
- applicability;
- old→new remapping provenance.

This does not alter O² semantics; it is an adapter representation.

The wiki wording may remain general, but the executable AO2DAI integration section should reflect the production strategy selected by the current AO2DAI proposal rather than leave coders to invent a different key convention.

---

# 4. Dtype and provenance contract

## ADF-side assessment: APPROVED with one scope clarification

For AO2D ingestion and relations, statements such as:

> preserve exact source/file dtype

are correct.

They refer to **physical source data and relation identity**, not to every later user-requested ADF conversion.

That distinction should remain explicit so this wiki does not accidentally conflict with ADF's standards-first conversion policy:

```text
AO2D physical value / key
    → preserve source/file contract

user later asks ADF for a new dtype
    → ADF conversion policy applies
```

The current document is already mostly written this way; no major edit is required.

---

# 5. Are the tables sufficiently described?

## Yes — the overview is now strong

Section 10 is the strongest improvement in v0.5.

It gives a useful teaching spine:

### Event backbone

```text
BCs
↓
Timestamps / BC views
↓
Collisions
```

### Track backbone

```text
Collisions
↓
Tracks
├─ TracksExtra / StoredTracksExtra
├─ covariance/IU families
├─ FullTracks positional view
└─ detector / QA extensions
```

### MC backbone

```text
McCollisions
↓
McParticles
├─ external McCollision relation
├─ self mother/daughter relations
└─ reconstructed-label families
```

### Standard matching/index families

The page explicitly identifies `DECLARE_SOA_INDEX_TABLE*` as a different mechanism from ordinary index columns. This is necessary for a correct AO2D registry.

### LF specialization

V0 and cascade are correctly presented after the base model and connected back to standard collision/track concepts.

This is enough to answer the important overview questions:

- what are the main AO2D entity families?
- what is stored?
- what is derived?
- how are tables related?
- which joins are positional?
- what is an index table?
- what does a physical ROOT branch prove or not prove?
- how do V0/cascade fit into the standard model?

## Suggested nonblocking readability enhancement

A future revision could add one compact “AO2D topology at a glance” table:

| Logical family | Typical source type | Main parent/relation | Mechanism | Typical physical role |
|---|---|---|---|---|
| BC | `BCs_*` | root/event backbone | table | persisted |
| Collision | `Collisions_*` | BC | scalar external index | persisted |
| Track | `Tracks*` | Collision | scalar external index | persisted/view |
| TrackExtra | `StoredTracksExtra*` / `TracksExtra*` | Track | positional view | persisted + extended |
| MC particle | `McParticles*` | McCollision + self relations | external/self | persisted/view |
| V0 | LF V0 families | Collision + daughter tracks | indexed + positional | PWG-specific |
| Cascade | LF cascade families | Collision + bachelor + V0 | indexed + positional | PWG-specific |

This is **P2 only**. The current narrative already provides a good overview.

---

# 6. Ratification blockers versus comments

## P1 — must close before v0.5 ratification

### ADF-P1-1 — exact public ADF adapter is still schematic

**Location:** §17.2, §24.4.

Required:

- pin exact ADF source/version;
- replace or retain the schematic only after public-API testing;
- execute normalized-key/subframe behavior;
- run independent relation/query/draw oracles.

This is already honestly declared by the document, so it is not a design error. It is an incomplete ratification item.

### ADF-P1-2 — ADF slot/surface coverage must be part of the executable oracle

The final ADF adapter test must not prove only:

```text
adf.eval("Child.x")
```

It must also cover all ADF expression-bearing surfaces AO2DAI intends to use, especially:

```text
draw expression
selection
group_by
facet_by
aliases
nested relations
```

The recent ADF phase history is exactly why a direct lookup alone is not enough evidence.

## P2 — nonblocking

### ADF-P2-1 — add the topology-at-a-glance table

Useful for MTTU/readability, not required for semantic correctness.

### ADF-P2-2 — state the physical-dtype versus explicit-conversion distinction once

This prevents readers from interpreting AO2D's exact physical dtype contract as a ban on deliberate ADF user conversions.

---

# 7. Work outside ADF ownership that still blocks full ratification

The document correctly assigns these elsewhere:

- exact AliceO2/O2Physics commit pins;
- current-upstream → pinned-source reconciliation;
- generated `DataFormats_AO2D.json`;
- standard/base AO2D physical fixture;
- LF pilot-file reconciliation;
- producer/task closure;
- slicing/remapping fixtures;
- MIWikiAI publication validation.

Therefore an ADF `[OK]` alone could never make the full v0.5 document ratified.

---

# 8. Markdown / HTML consistency

The uploaded Markdown SHA-256 is:

```text
f0d53e0b76a8086ee558feaabc6876478c0163bf499a05d797d076d5cb232f19
```

The HTML header/footer declares the same canonical Markdown SHA-256.

**Result: PASS.**

This is a useful publication-integrity check. Formal HTML/navigation review still belongs to MIWikiAI.

---

# 9. Final answers

```text
ADF integration architecture:                APPROVED
ADF semantic ownership boundary:             APPROVED
Normalized-key concept:                      APPROVED
AO2D physical dtype/provenance mapping:       APPROVED
Standard/base table overview:                GOOD / SUFFICIENT
V0/cascade placement in the overview:        APPROVED
Markdown ↔ HTML canonical hash:               PASS

Executable ADF public API section:            NOT YET FROZEN
Exact ADF source pin:                         REQUIRED
Full slot/surface ADF oracle:                 REQUIRED
Generated registry:                           REQUIRED for full code-writing authority
Full document ratification:                   NOT YET

Canonical ADF-side verdict:                  [!] APPROVED_WITH_COMMENTS
Need next revision:                           YES — bounded
Need conceptual rewrite:                      NO
```

# Official approval statement

**From the AliasDataFrame side, I approve `DataFormats_AO2D` v0.5 as the correct architecture and overview candidate.**

The AO2D tables and relation mechanisms are now described well enough to give a new reviewer or coder a useful overview, and the standard/base model is correctly more prominent than the LF worked example.

A bounded next revision is still required before ratification. The main ADF-side task is to replace the schematic §17.2 integration with the exact tested public ADF adapter, including normalized-key and complete expression-slot/surface oracles.

No new broad architecture review is required for that correction.
