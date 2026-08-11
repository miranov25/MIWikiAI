---
doc_id: DataFormats_AO2D
doc_type: software-index-overview
project: MIWikiAI / AO2DAI
version: v0.5.1 (2026-08-10)
status: DRAFT — bounded v0.5.1 closure revision over the AO2DAI-authored v0.5 draft; consolidated F-1–F-5 documentation/schema/API corrections are incorporated, while exact source pins, generated standard_aod registry evidence, physical AO2D reconciliation, fixture execution, final ADF pin/oracles, and MIWikiAI publication validation remain required before ratification
introduction_only: false
ao2d_role: authoritative-human-semantic-reference-candidate
canonical_for: AO2DAI AO2D semantics/code-writing
canonical_format: Markdown
generated_companion: HTML
technical_owner: AO2DAI
formal_publication_owner: MIWikiAI
adf_integration_owner: ADF
review_assignment_doc: PENDING — v0.5.1 focused closure delta dispatch not yet issued
review_basis:
  - "Claude5 MIWikiAI Main Reviewer — DataFormats_AO2D v0.4.2 consolidated review summary revision 2, 2026-08-08"
  - "Fable5_1:AO2D — DataFormats_AO2D v0.4.2 consolidated review summary, 2026-08-08"
  - "GPT3:AO2D — DataFormats_AO2D v0.4.2 official approval, 2026-08-08"
  - "Fable5_1:AO2D — DataFormats_AO2D v0.5 official consolidated review summary, 2026-08-10"
validation_ownership:
  formal_and_governance: MIWikiAI
  o2_o2physics_and_physical_ao2d_semantics: AO2DAI
  adf_public_api_and_integration: ADF
purpose:
  - Human-readable introduction to ALICE O2 AO2D and ASoA architecture
  - Authoritative semantic reference candidate for AO2DAI reviewers and coders
  - Human teaching spine for the standard/base AO2D model before PWG-specific examples
  - Design basis for generated C++ → Python / AliasDataFrame metadata
scope:
  - Generic AliceO2 ASoA semantics required for AO2DAI
  - Standard/base AO2D backbone declared in Framework/Core/include/Framework/AnalysisDataModel.h
  - Table, column, index, self-index, index-table, version, join, concat and index-equivalence concepts
  - Source-grounded V0/cascade examples as a downstream PWG stress test
  - Source-vs-file reconciliation and relation-aware slicing/remapping contracts
  - Registry schema needed for C++/Arrow → Python/ADF mapping
out_of_scope_initially:
  - Exhaustive prose catalogue of every AliceO2/O2Physics table and column
  - Full all-PWG generated registry
  - Full production AO2D source-vs-file reconciliation as already-certified content
  - Automatic translation of arbitrary C++ dynamic-column lambdas into Python
  - A second parallel human authoritative-reference document
source_inconsistencies:
  - "Exact architect-selected AliceO2 and O2Physics 40-character Git commit SHAs are still pending. Current dev/master reads are orientation/current-upstream evidence, not ratification pins."
  - "The v0.2 local ASoA/ASoA.cxx/LFStrangenessTables snapshots remain reproducible snapshot evidence and are not assumed to originate from a later clone commit merely because content overlaps."
  - "The pilot LF-derived AO2D evidence does not physically validate the standard/base AnalysisDataModel.h backbone; a representative standard-AO2D fixture is required for v0.5.1 ratification."
  - "The ADF public register_subframe API shape and asymmetric-key capability are source-verified against candidate bundle SHA-256 27c190153090115e9b3e8cc26a616382702c7611f9ca84c9a67547f3885c4147 / candidate HEAD 5690d949253dda1b2fbf3fee5c400ef850b178e2; the final ADF ratification pin and full expression-surface oracle remain pending."
  - "The v0.5 review reports a cross-validated generated census of 82 standard AnalysisDataModel.h symbols. The exact delivered 82-row appendix is not bundled with this drafting workspace, so v0.5.1 records the census and requires the generated standard_aod artifact to be attached and mechanically checked rather than transcribing an unavailable list by hand."
source_fingerprint:
  local_snapshots:
    - path: Framework/Core/include/Framework/ASoA.h
      sha256: a400462e4c635808b0fa15abd4d1dafbda3d51c856c9f838869c69f09d49e922
      verification: SNAPSHOT-VERIFIED — upstream commit reconciliation pending
    - path: Framework/Core/src/ASoA.cxx
      sha256: bd44c48a634e91b82d0541c61d849e1a6a792ed3f3016347a7408b66b45b34fd
      verification: SNAPSHOT-VERIFIED — upstream commit reconciliation pending
    - path: PWGLF/DataModel/LFStrangenessTables.h
      sha256: 2a9b56e7bca657e3efb1064b7e6e38643af123784f9d9a7b353db2036e8bc852
      verification: SNAPSHOT-VERIFIED — upstream commit reconciliation pending
  upstream_orientation:
    - repository: https://github.com/AliceO2Group/AliceO2
      branch: dev
      commit_verified: PENDING
      source_read_2026_08_10:
        - Framework/Core/include/Framework/AnalysisDataModel.h
        - Framework/Core/include/Framework/ASoA.h
        - Framework/Core/src/ASoA.cxx
    - repository: https://github.com/AliceO2Group/O2Physics
      branch: master
      commit_verified: PENDING
      source_read_2026_08_10:
        - PWGLF/DataModel/LFStrangenessTables.h
provenance_status: "DRAFT — bracketed MIWikiAI provenance labels identify literal/fabricated source-like content. Bold semantic descriptors identify authority. Current-upstream claims are explicitly separated from snapshot-exact claims."
revision_note: "v0.5.1 is the bounded AO2DAI closure revision requested by the v0.5 consolidated review. It adds the default O2 V0/cascade layer before the LF/O2Physics extensions; strengthens the standard family overview and exhaustive standard_aod registry obligation; corrects equivalence/index-table registry taxonomy; publishes the source-verified ADF register_subframe contract with native asymmetric keys and a full expression-surface oracle; and adds extractor/fixture hazards from F-5 without changing the approved architecture."
---

# DataFormats_AO2D — ALICE O² ASoA and AO2D authoritative semantic reference

> **DRAFT VALIDATION SPLIT — v0.5.1**
>
> - **AO2DAI** owns substantive AliceO2/O2Physics semantics, standard/base AO2D coverage, producer/task closure, physical AO2D reconciliation, slicing/remapping, and the generated semantic registry.
> - **ADF** validates only the ADF-facing public API and adapter behavior.
> - **MIWikiAI** validates document class, provenance/status grammar, source-pinning discipline, canonical Markdown, generated HTML, navigation and readability.
> - Nothing marked **AO2DAI VALIDATION REQUIRED** or **ADF VALIDATION REQUIRED** is frozen fact.

## What this document is for

A new reviewer or coder should be able to read this page without prior ALICE software knowledge and understand:

1. what ALICE and O² are and why AO2D exists;
2. what Structure of Arrays / ASoA means;
3. how the standard AO2D backbone is organized: **BCs → Collisions → Tracks → detector/MC/index families**;
4. how persistent, expression and dynamic columns differ;
5. how scalar, slice, array and self indices work;
6. how index equivalence and index tables differ from ordinary index columns and positional joins;
7. how `soa::Join` and `soa::Concat` differ;
8. why current aliases do not necessarily mean “highest version”;
9. how logical source declarations map to ROOT trees/branches and why actual-file evidence remains independent;
10. how V0 and cascade tables extend the standard model in O2Physics;
11. how a relation-aware slicer preserves and remaps identities after compaction;
12. how one generated evidence model should drive this Markdown, the Python loader, slicer, verifier and ADF adapter.

This page is intended to become the **single human-facing authoritative AO2DAI semantic reference for AO2D code writing**. The generated machine-readable registry is not a competing authority: it is the executable representation of the same evidence model.

## AO2DAI non-negotiable invariants

1. **C++ declarations define semantic relation targets and declared views.**
2. **The AO2D file defines what is physically present.**
3. **A pinned reference source does not retroactively define a historical file version.** Source, producer provenance and file must be reconciled.
4. **Equal row counts never create a semantic join.** They can discover a candidate only.
5. **Branch spelling never establishes the final relation target when declaration metadata exists.**
6. **Exact dtypes are contracts.** Never infer them from observed values alone.
7. **Raw invalid index values are physical provenance; logical applicability is derived separately.**
8. **Partition identity is part of globalized Python relation identity unless a single partition is processed in strict isolation.**
9. **Slicing/compaction requires deterministic old→new remapping.** Retaining a target row is not enough.
10. **Unresolved semantics fail closed.** A verifier may not report complete preservation while a required relation is unresolved.
11. **One canonical evidence model feeds documentation, loader, slicer and verifier.**
12. **Python ports of dynamic/expression quantities require explicit equivalence validation.**
13. **A current alias is a source-selected alias, not a promise that the numerically highest version is selected.**
14. **Relation/table mechanism is source-declared.** `DECLARE_SOA_INDEX_TABLE*` must not be misclassified as an ordinary scalar/slice/array/self index column.

## Semantic status descriptors and MIWikiAI provenance labels

**O2 SOURCE FACT** — source-derived semantics, with evidence state stated nearby.

**AO2DAI BINDING RULE** — AO2DAI implementation/safety policy. Architect ratification may still be required at freeze.

**PROPOSED DESIGN** — project implementation shape, not an O² semantic fact.

**AO2DAI VALIDATION REQUIRED** — O2/O2Physics/physical-file item to be validated before freeze.

**ADF VALIDATION REQUIRED** — ADF API/integration item to be validated by ADF.

Source-like text uses MIWikiAI labels:

- `[VERBATIM <path>:Lx-Ly]` — character-exact against the named snapshot bytes; line ranges are **snapshot-relative** until an architect-selected commit is pinned;
- `[FABRICATED — illustrative only]` — invented schematic code/text;
- architect-originated labels when applicable.

Unmarked prose is orientation/explanation. Normative claims carry a semantic descriptor.

---

# 1. ALICE, O² and AO2D

## 1.1 ALICE

ALICE (A Large Ion Collider Experiment) is CERN's LHC experiment optimized for heavy-ion physics. Runs 3 and 4 use a high-rate continuous-readout computing model and the O² (“Online-Offline”) software/computing system.

Orientation:

- https://alice-o2-project.web.cern.ch/
- https://github.com/AliceO2Group/AliceO2

## 1.2 O² and O2Physics

A useful mental split is:

```text
AliceO2
  ├─ Framework / DPL / ASoA infrastructure
  ├─ standard analysis data model
  ├─ detector/reconstruction formats and algorithms
  └─ simulation / calibration / common services

O2Physics
  ├─ analysis tasks and workflows
  ├─ helper-table producers
  ├─ PWG-specific data models
  └─ derived-data workflows
```

O2Physics can declare tables, indices, joins and dynamic columns using the same ASoA machinery from AliceO2.

## 1.3 Why AO2D exists

O² analysis uses a **relational collection of flat columnar tables** rather than a single nested event object. Bunch crossings, reconstructed collisions, tracks, detector signals, MC truth, helper data and reconstructed candidates live in distinct tables and are related by explicit indices or declared positional views.

The persistent analysis product is conventionally `AO2D.root`. The official O² analysis documentation identifies the standard tables extracted from AO2D with declarations in `Framework/Core/include/Framework/AnalysisDataModel.h`.

Orientation:

- https://aliceo2group.github.io/analysis-framework/docs/basics-tasks/Introduction.html
- https://aliceo2group.github.io/analysis-framework/docs/datamodel/ao2dTables.html

## 1.4 One-sentence definition

> **AO2D is the persistent ROOT representation of O² analysis-table data: versioned columnar tables and persistent/index columns are stored physically, while higher-level source-declared semantics such as extended views, positional joins and dynamic columns must be reconstructed from authoritative source/producer evidence.**

Keep three layers separate:

```text
physics/reconstruction objects
          ↓
logical O² ASoA model (Arrow-oriented tables, indices, views)
          ↓
physical AO2D ROOT representation (DF_* / O2* trees / branches)
```

AO2DAI reconstructs the logical layer from the physical file using the source model and producer provenance.

---

# 2. Structure of Arrays and ASoA

## 2.1 AoS versus SoA

Array-of-Structures:

```text
track[0] = {x0, y0, z0, pt0}
track[1] = {x1, y1, z1, pt1}
```

Structure-of-Arrays:

```text
x  = [x0,  x1,  ...]
y  = [y0,  y1,  ...]
z  = [z0,  z1,  ...]
pt = [pt0, pt1, ...]
```

Columnar analysis reads a small set of columns across many rows efficiently.

## 2.2 What ASoA adds

`Framework/Core/include/Framework/ASoA.h` provides a typed C++ interface over Arrow-oriented columnar data:

```text
Arrow columns
    ↓
ASoA typed Table<T...>
    ↓
row iterator / getters such as track.pt(), collision.posZ(), track.collision()
```

The framework type system carries table identity, column type, index targets and view composition.

## 2.3 A table is not a row-wise serialized C++ object

An O² analysis table is a collection of rows and columns. Filtering, joins, slicing/preslicing and index dereferencing operate on columnar tables/views. Python should therefore reconstruct **related DataFrames/tables**, not nested objects guessed from ROOT names.

---

# 3. Three representations of the same information

## 3.1 C++ declaration layer

**PROPOSED DESIGN.**

[FABRICATED — illustrative only]

```cpp
DECLARE_SOA_COLUMN(...)
DECLARE_SOA_INDEX_COLUMN(...)
DECLARE_SOA_DYNAMIC_COLUMN(...)
DECLARE_SOA_TABLE(...)
using SomeView = soa::Join<TableA, TableB>;
```

This layer carries semantic declarations.

## 3.2 In-memory analysis layer

ASoA observes/combines Arrow tables and exposes typed iterators, getters, filters, slices and joins.

## 3.3 Physical AO2D layer

AO2D persists compatible table/column content to ROOT objects. The mapping from descriptions/versions and column labels to ROOT tree/branch identifiers belongs to the physical-I/O implementation plus the file actually written.

## 3.4 Why all three are required

```text
pinned source declarations
       +
actual AO2D schema/values
       +
producer/source provenance
       ↓
reconciled AO2D registry
       ↓
Python / AliasDataFrame graph
```

Current source alone cannot prove what an older file contains; file names alone cannot prove semantic relation targets.

---

# 4. How an O² table is defined

## 4.1 Persistent columns

`DECLARE_SOA_COLUMN(Name, getter, Type)` declares a stored column with a source type. Persistent column type is part of the contract and maps through Arrow/I/O machinery.

**AO2DAI BINDING RULE:** preserve exact source/file dtype. Never route integral identity through `float64` or infer dtype from small observed values.

## 4.2 Row/global index versus external relation index

`o2::soa::Index<>` provides row/view identity semantics. It is not the same as an external `fIndex...` relation column.

```text
globalIndex()          = identity/position of this row in its table/view
external index column  = relation from this row to another row/table family
```

## 4.3 Dynamic columns

**O2 SOURCE FACT.** A dynamic column is computed from other columns/parameters and does not create a persistent AO2D branch by itself.

For Python:

```text
C++ dynamic column
  → dependencies
  → return type
  → observable formula
  → Python/NumPy implementation
  → C++↔Python equivalence test
```

## 4.4 Expression columns

O² distinguishes expression columns from dynamic callback columns. Expression columns are declarative computed columns that participate in the framework's table construction/materialization semantics.

**AO2DAI BINDING RULE:** Python need not reproduce the C++ implementation mechanism, but must reproduce observable values, dtype and provenance.

## 4.5 Marker/metadata types

Compile-time markers and table metadata are not automatically physics columns. The registry records them as metadata where they affect identity or interpretation.

## 4.6 Table identity and versions

**O2 SOURCE FACT — current-upstream, commit pin pending.** Current `AnalysisDataModel.h` declares `BCs_000`, versioned `BCs_001`, then selects `using BCs = BCs_001`; similarly it declares collision versions and selects `Collisions_001`.

This demonstrates three different concepts:

1. versioned source types;
2. a source-selected current alias;
3. the version physically present in a particular file.

They must not be conflated.

### A critical counterexample: current alias does not mean “highest numeric version”

**O2 SOURCE FACT — current-upstream, commit pin pending.** `AnalysisDataModel.h` declares both `McCaloLabels_000` and `McCaloLabels_001`, but currently defines:

```cpp
using McCaloLabels = McCaloLabels_000;
```

Therefore the correct rule is:

> **A current alias is whatever the source explicitly selects. Never infer it by choosing the numerically highest declared version.**

This is load-bearing for a parser/generator.

## 4.7 Stored, extended/full views and aliases

**O2 SOURCE FACT — current-upstream, commit pin pending.** The track family illustrates physical/logical distinctions:

- stored `StoredTracksExtra_*` versions;
- extended `TracksExtra_*` versions;
- `using StoredTracksExtra = StoredTracksExtra_002`;
- `using TracksExtra = TracksExtra_002`;
- convenience positional view `FullTracks = soa::Join<Tracks, TracksExtra>`.

The source also contains declarations such as a full/versioned TracksExtra table whose physical identity is encoded by description/origin/version arguments. A registry must retain these identities separately rather than assuming one C++ alias equals one ROOT tree.

Required fields include:

```text
cpp_symbol
entity_kind
stored_type
extended_or_view_type
current_alias_target
origin
description
version
physical_tree_if_any
source_identity
validation_status
```

---

# 5. How tables are connected

AO2DAI must preserve distinct relation mechanisms rather than collapse all of them into “join”.

## 5.1 External scalar index

**O2 SOURCE FACT — snapshot-exact; commit reconciliation pending.**

[VERBATIM Framework/Core/include/Framework/ASoA.h:L2896-L2899]

Snapshot SHA-256: `a400462e4c635808b0fa15abd4d1dafbda3d51c856c9f838869c69f09d49e922`

```cpp
    bool has_##_Getter_() const                                                                                                 \
    {                                                                                                                           \
      return *mColumnIterator >= 0;                                                                                             \
    }                                                                                                                           \
```

For normal scalar external indices:

```text
logical applicability: stored value >= 0
physical provenance:   preserve the stored raw value
```

A negative value is not a live normal scalar reference. Different negative values remain physical provenance.

## 5.2 Relation target comes from C++ metadata

The generated scalar-index type carries target metadata such as `binding_t` / `index_targets`.

**AO2DAI BINDING RULE:** branch spelling can locate a candidate declaration but cannot be final semantic authority when source metadata exists.

## 5.3 Physical index-label families — external and self are different

**O2 SOURCE FACT — snapshot/current-upstream source verified; commit pin pending.**

External and self-index macros do **not** share one universal naming rule.

| Relation kind | Source-level physical label rule | Important distinction |
|---|---|---|
| external scalar | `fIndex<Label><Suffix>` | suffix slot exists |
| external slice | `fIndexSlice<Label><Suffix>` | suffix slot exists |
| external array | `fIndexArray<Label><Suffix>` | suffix slot exists |
| self scalar | `fIndex<Label>` | no external suffix slot |
| short self scalar | label derives from `#Name` | no token-pasted plural `s` |
| self slice | `fIndexSlice<Label>`; short form uses an underscore-prefixed source name | self-specific macro rule |
| self array | `fIndexArray<Label>`; short form uses an underscore-prefixed source name | self-specific macro rule |

**AO2DAI BINDING RULE:** a generator must classify the source macro family first, then derive physical labels from that family. Applying external-index rules to self indices is incorrect.

## 5.4 Slice indices

A slice relation references a contiguous target range.

**AO2DAI BINDING RULE:** after filtering/compaction, reconstruct a slice only if retained targets remain a valid contiguous output range. Otherwise fail or use an explicitly approved alternative representation.

## 5.5 Array indices

An array index references multiple target rows.

**AO2DAI BINDING RULE:** dependency closure and remapping are element-wise. “Non-flat branch → skip” is not correctness preserving.

## 5.6 Self indices

A self relation targets the same logical table family. Scalar, array and slice self relations share the same-family target semantics but have different storage/remapping behavior.

**O2 SOURCE FACT — current-upstream, commit pin pending.** `AnalysisDataModel.h` provides a standard MC example:

- scalar self indices: `Mother0`, `Mother1`, `Daughter0`, `Daughter1`;
- self array: `Mothers`;
- self slice: `Daughters`.

**AO2DAI BINDING RULE:**

- scalar self → remap one value through the table's old→new map;
- self array → remap every element;
- self slice → enforce the same contiguity rule as any slice.

## 5.7 C++-type index equivalence

`DECLARE_EQUIVALENT_FOR_INDEX` declares index-binding compatibility between C++ table types. It is neither a foreign key nor a positional join.

For the reviewed LF V0/cascade snapshot, the eight validated equivalence pairs remain:

```text
V0Indices      ↔ V0Cores
V0TrackXs      ↔ V0Cores
V0TrackXs      ↔ V0Indices
CascIndices    ↔ CascCores
CascIndices    ↔ CascBBs
CascCores      ↔ CascBBs
KFCascIndices  ↔ KFCascCores
TraCascIndices ↔ TraCascCores
```

These do not create new positional families beyond the source-declared join families.

## 5.8 Description/version- and label/version-keyed index equivalence

**O2 SOURCE FACT — current-upstream, commit pin pending.** Current `AnalysisDataModel.h` contains 14 `DECLARE_EQUIVALENT_FOR_INDEX_NG` declarations. They include both version compatibility and shape/family compatibility, for example:

```text
COLLISION/0   ↔ COLLISION/1
TRACK/0       ↔ TRACK_IU/0
TRACKEXTRA/0  ↔ TRACKEXTRA/1
TRACKEXTRA/1  ↔ TRACKEXTRA/2
HMPID/0       ↔ HMPID/1
MFTTracks/0   ↔ MFTTracks/1
```

Two details are load-bearing for a generator:

1. `TRACK/0 ↔ TRACK_IU/0` is **not** merely cross-version compatibility; it relates differently described table shapes.
2. `MFTTracks/0 ↔ MFTTracks/1` demonstrates that the `_NG` literal key can be based on a source **label** (`MFTTracks`) rather than the physical description string (`MFTTRACK`). A resolver that assumes every `_NG` string is `description/version` resolves only a subset of the declared edges.

**AO2DAI BINDING RULE:** preserve the declaration syntax separately from the resolved equivalence key. Do not reconstruct the key from normalized names, and do not case-fold source strings.

Registry representation:

```text
relation_kind: index_equivalence
declaration_form: classic_cpp_type | ng_string_key
key_form: cpp_type | description_version | label_version
left_declared
right_declared
left_resolved_key
right_resolved_key
key_case_policy: byte_exact
source_macro
source_identity
validation_status
```

For `_NG`, the literal source key is preserved byte-for-byte. Case-sensitive examples such as `MFTTracks` and physical-description spellings such as `Run2OTFV0` are not normalized by the registry.


## 5.9 `DECLARE_SOA_INDEX_TABLE*` — a distinct matching-table mechanism

**O2 SOURCE FACT — source/snapshot reviewed; final commit pin pending.** `DECLARE_SOA_INDEX_TABLE_NG` carries an explicit boolean `exclusive` property. The ordinary index-table macro expands with `exclusive = false`; the `_EXCLUSIVE` form expands with `exclusive = true`.

Current `AnalysisDataModel.h` declares eleven standard matching/index-table symbols for Run-2/Run-3 BC/collision/detector matching, including multi-collision variants.

Examples include:

```text
Run2MatchedExclusive
Run2MatchedSparse
Run3MatchedExclusive
Run3MatchedSparse
MatchedBCCollisionsExclusive
MatchedBCCollisionsSparse
MatchedBCCollisionsExclusiveMulti
MatchedBCCollisionsSparseMulti
Run3MatchedToBCExclusive
Run3MatchedToBCSparse
Run2MatchedToBCSparse
```

“Sparse” is part of several concrete table names/usages; it is **not** the generic framework property paired with `exclusive`. The registry therefore stores the source boolean instead of inventing `mode = exclusive | sparse`.

An index table is also not itself an ordinary relation-column kind. It is a generated **table/entity** built from a key table plus index columns. If the graph needs edges from it, those edges are represented separately.

Required record:

```text
entity_kind: index_table
exclusive: true | false
source_declared_name
source_macro
key_table
index_columns
array_index_columns_if_any
edge_kinds_if_generated
source_identity
validation_status
```

**Extractor hazard — macro indirection.** Current standard declarations use helper lists such as `INDEX_LIST_RUN2` / `INDEX_LIST_RUN3`. A text scanner must preserve the original macro form and mark unresolved list expansion as `compiler_resolution_required`; it must not silently treat an unresolved macro identifier as one index column.

**AO2DAI BINDING RULE:** do not force an index table into the ordinary scalar/slice/array/self relation-column enumeration.

---

# 6. Positional joins: `soa::Join`

## 6.1 Semantic meaning versus runtime compatibility

`soa::Join<T1,T2,...>` is a source-declared positional side-by-side view.

Two implementation evidence bases have been reviewed:

- the SHA-256-pinned v0.2 `ASoA.cxx` snapshot demonstrates a `std::shared_ptr<arrow::Table>` path that rejects unequal row counts through `canNotJoin()`;
- current AliceO2 `dev` contains `ArrowTableRef` paths that reject incompatible `ArrowRange` offset/size values.

**AO2DAI VALIDATION REQUIRED:** enumerate exactly which paths exist at the architect-selected commit before freeze.

The semantic rule is independent of those runtime checks:

```text
source declares positional relation
        ↓
member tables have shared row identity in that view
        ↓
runtime/file compatibility checks validate realization
```

Never reverse this logic.

## 6.2 Equal rows do not create a join

Incorrect:

```text
A, B and C have equal row counts → therefore semantic join
```

Correct:

```text
source/producer proves lockstep relation → file row/range/order checks validate it
```

## 6.3 Source-proven versus unresolved positional candidates

`SOURCE_PROVEN_POSITIONAL` — established by an explicit `soa::Join`, reviewed producer/task lockstep evidence, or another accepted source mechanism.

`POSITIONAL_CANDIDATE_UNRESOLVED` — file evidence suggests lockstep (for example equal counts) but source closure is incomplete.

This is the documentation/registry state corresponding to the phase proposal's `EMPIRICALLY_COMPATIBLE_ONLY` proof class until closure.

### Conservative unresolved-candidate policy

**AO2DAI BINDING RULE — selected by AO2DAI; architect ratification pending at freeze.**

For unresolved candidates:

1. calculate each member's ordinary retention mask;
2. form the **union** of member masks;
3. apply the same union mask/order to every candidate member;
4. retain `POSITIONAL_CANDIDATE_UNRESOLVED` in the registry/manifest;
5. do not create an ADF semantic join merely because shared retention was used.

This is deliberately over-retentive and prevents silent under-grouping.

---

# 7. `soa::Concat`, filters and preslicing

## 7.1 `soa::Concat`

**O2 SOURCE FACT — source-verified, commit pin pending.** The reviewed implementation derives a concatenated schema from the field-set intersection/common fields across inputs.

Therefore `Concat` is not a union-of-all-columns operation. A column missing from one member can disappear from the result schema.

## 7.2 Filtered views

Filtered tables carry a selection into an underlying table. Filtered-row position and underlying/global index must not be interchanged without the framework mapping.

## 7.3 Preslice/grouping

Preslice mechanisms group rows by index values. For AO2DAI, preserving the underlying relation and index/remapping semantics is the prerequisite; high-level grouping can be layered on afterward.

---

# 8. How tables are filled

## 8.1 Reconstruction and base AO2D

Reconstruction/calibration produces the base analysis information persisted into AOD/AO2D.

## 8.2 Analysis tasks produce additional tables

O² tasks can declare output tables through `Produces<TableType>` and append rows in `process()`.

[FABRICATED — illustrative only]

```cpp
Produces<o2::aod::SomeTable> output;

void process(...)
{
  output(value1, value2, ...);
}
```

Orientation source: https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/ANALYSIS.md

## 8.3 Base, helper, PWG and derived data

Useful categories:

1. standard/base tables in `AnalysisDataModel.h`;
2. standard helper-produced tables;
3. O2Physics/PWG-specific tables;
4. derived-data tables intentionally written by workflows.

A declaration existing in current source does not guarantee that table is present in every AO2D.

---

# 9. Physical AO2D storage

## 9.1 ROOT paths and partitions

AO2D paths commonly look schematically like:

```text
DF_<id>/O2<table>
```

The semantic model and physical I/O mapping are separate evidence layers.

## 9.2 Physical naming rules

Snapshot/current source establishes physical label families such as:

```text
persistent column → f<Name>
external scalar  → fIndex<Label><Suffix>
external slice   → fIndexSlice<Label><Suffix>
external array   → fIndexArray<Label><Suffix>
self scalar      → fIndex<Label> with self-specific macro rules
self slice       → fIndexSlice<Label> with self-specific macro rules
self array       → fIndexArray<Label> with self-specific macro rules
```

Tree description/version naming belongs to the writer/output implementation and must be commit-pinned.

## 9.3 `DF_*` partition identity

Identical local row numbers can occur in different `DF_*` partitions.

**AO2DAI BINDING RULE:** globalized Python relation keys include partition identity unless one partition is processed in strict isolation.

`globalIndex()` is not automatically a cross-file/cross-partition stable physics-object identifier.

## 9.4 Physical names are not complete semantics

An `fIndex...` branch is strong evidence of an index-like field, but exact target/equivalence/view semantics still come from source metadata and producer evidence.

## 9.5 Historical file reality

If current source selects version N while a file contains version M, the file is not automatically wrong. Record:

```text
reference source identity/version
actual persisted tree/version
producer/source provenance if known
reconciliation status
```

---

# 10. Standard/base AO2D data model — the primary concrete teaching spine

The standard/default AO2D layer in AliceO2 is the foundation. O2Physics tables are extensions built on top of standard objects and relations.

The official O² table documentation groups the standard AO2D model into broad families such as General, Tracks, Detectors, Strangeness, Indices, MonteCarlo, Run2 and Others. v0.5.1 uses that family view for human orientation while reserving exhaustive symbol-level truth for the generated `standard_aod` registry.

## 10.1 Compact family map

| Standard family | Representative source identities / shapes | Human meaning / topology |
|---|---|---|
| Event / BC | `BCs_*`, `Timestamps`, `BCFlags` | bunch-crossing identity, timing, trigger/event-root information |
| Collisions | `Collisions_*` | reconstructed collision/vertex; collision → BC |
| Tracks | `Tracks`, `TracksIU`, `TracksCov*`, `StoredTracksExtra_*`, `TracksExtra_*`, `FullTracks`, QA variants | track parameters, covariance/extras, track → collision, positional convenience views |
| Ambiguity | `AmbiguousTracks`, MFT/Fwd variants | tracks not uniquely assigned to one collision; BC slice/range precedent |
| Detectors / forward | HMPID, calorimeter/CPV, ZDC, FV0, FT0, FDD, MFT/Fwd families | detector payloads and detector↔BC/track relations |
| Standard strangeness | `V0s_*`, `Cascades_*`, `Decay3Bodys`, `TrackedV0s`, `TrackedCascades`, `Tracked3Bodys` | **default O2 V0/cascade/3-body identities** used as targets by extensions |
| Monte Carlo | `McCollisions*`, `McParticles*`, reconstruction-label tables, HepMC tables | MC event/particle graph, self-relations, reconstructed↔MC labels |
| Matching / indices | `Run2Matched*`, `Run3Matched*`, `MatchedBCCollisions*` | explicit generated index-table entities for BC/collision/detector matching |
| Provenance / compatibility | `Origins`, Run-2 compatibility tables such as `Run2OTFV0s` | dataframe provenance and historical compatibility |

This matrix is intentionally compact. The code-driving inventory is generated.

## 10.2 Event backbone: bunch crossings and timestamps

**O2 SOURCE FACT — current-upstream, commit pin pending.** Current source declares:

- `BCs_000`;
- versioned `BCs_001`;
- `using BCs = BCs_001`;
- `Timestamps`;
- `BCsWithTimestamps = soa::Join<aod::BCs, aod::Timestamps>`.

The source describes `BCs` as the root for tables pointing to a bunch crossing.

```text
BC identity/time structure ≠ reconstructed collision identity
```

## 10.3 Collision backbone

Current source defines versioned `Collisions_*` tables containing vertex/time information and `collision::BCId`.

```text
BCs
 ↑
 │ collision::BCId
Collisions
```

The collision→BC relation is source-declared; ambiguity logic may still expose additional compatible BCs.

## 10.4 Track backbone

Core relation:

```text
Collisions
    ↑
    │ track::CollisionId
Tracks
```

The standard source contains persistent track parameters plus expression/dynamic quantities such as `Phi`, `Eta`, `Pt` and momentum components.

At overview level distinguish:

- `Tracks` and `TracksIU`;
- covariance families;
- `StoredTracksExtra_*` versus extended `TracksExtra_*`;
- `FullTracks = soa::Join<Tracks, TracksExtra>`;
- optional QA and related track payloads.

### Extractor hazard: alias name does not prove entity kind

**O2 SOURCE FACT — current-upstream, commit pin pending.**

```cpp
using TracksQAVersion = TracksQA_003;
using TracksQA = TracksQAVersion::iterator;
```

A plural-looking alias can resolve to an iterator. The registry therefore records the resolved C++ entity kind.

## 10.5 Ambiguous-track precedent

`AmbiguousTracks` provides a standard slice/range relation for tracks not uniquely assigned to one collision.

This is important because:

1. slice relations are part of the standard model, not an LF-only special case;
2. unexplained negative indices must not be assigned invented semantics without checking the surrounding source-defined ambiguity model.

## 10.6 Standard detector families

Representative standard families include HMPID, calorimeter/CPV, ZDC, FV0, FT0, FDD, MFT and forward-track content.

The human rule is simple: detector names do not define relation semantics. The registry obtains relations from index declarations, index tables, joins and producer evidence.

## 10.7 Monte-Carlo backbone

```text
McCollisions
     ↑
     │ mcparticle::McCollisionId
McParticles
   ↖ ↑ ↗
 self mother/daughter relations

reconstructed tables
     ↓ labels
MC label tables
```

The standard MC model demonstrates scalar external relations plus scalar self, self-array and self-slice relations.

The `McCaloLabels` counterexample in §4.6 remains load-bearing: source-selected “current” alias is not guaranteed to be the highest declared version.

## 10.8 Standard matching/index tables

The `indices` area uses `DECLARE_SOA_INDEX_TABLE*` for BC/collision/detector matching. Treat those as explicit generated entities with an `exclusive` boolean and source-resolved key/index-column list, not as ordinary relation columns.

## 10.9 Origins / dataframe provenance

**O2 SOURCE FACT — current-upstream, commit pin pending.** `Origins` contains `DataframeID`, documented as the dataframe ID commonly reflected in AO2D directory names such as `DF_XXX`.

This is provenance information; it does not remove the need for explicit partition identity in globalized Python keys.

## 10.10 Run-2 compatibility and source spelling

Run-2 compatibility tables can coexist with Run-3/4 data. Preserve exact source strings and case.

A concrete current-source example is `Run2OTFV0s` with physical description `Run2OTFV0`. The registry must preserve the source spelling byte-for-byte and must not uppercase/lowercase keys as a semantic normalization step.

## 10.11 Default O2 strangeness layer — V0, cascade and 3-body objects

**O2 SOURCE FACT — current-upstream, commit pin pending.** The standard `AnalysisDataModel.h` contains the default strangeness identities on which O2Physics extensions build:

- `V0s_000`, `V0s_001`, `V0s_002`, with current `V0s = V0s_002`;
- `Cascades_000`, `Cascades_001`, with current `Cascades = Cascades_001`;
- `Decay3Bodys`;
- `TrackedV0s`, `TrackedCascades`, `Tracked3Bodys`.

The default topology is already relational:

```text
Collisions
   ↑             ↑
   │             │
  V0s ← daughter Tracks
   ↑
   │ cascade::V0Id
Cascades ← bachelor Track
```

`Decay3Bodys` points to one collision and three tracks. The strangeness-tracking tables point back to standard V0/cascade/3-body objects.

### Extractor cycle guard

Current source contains a self-alias form equivalent to:

```cpp
using Decay3Bodys = Decay3Bodys;
```

A resolver must not recurse forever. Record an explicit outcome such as:

```text
alias_resolution: self_alias
cycle_guard_triggered: true
resolved_entity_kind: table
```

and preserve the underlying declaration as the authoritative table identity.

## 10.12 Default O2 versus O2Physics derived/extended layer

**ARCHITECT DIRECTION — 2026-08-10:** describe both layers: default data in O2, derived data in O2Physics as extensions.

This distinction is central:

```text
AliceO2 / AnalysisDataModel.h
    aod::V0s, aod::Cascades, ...
          ↑ targets / base objects
O2Physics / LFStrangenessTables.h
    V0Indices + V0TrackXs + V0Cores -> V0Datas
    CascIndices + CascBBs + CascCores -> CascDatas
```

`aod::V0s` and `V0Datas` are **not synonyms**. The former is a standard/default AO2D table family; the latter is an O2Physics positional joined view over LF-derived tables.

Likewise, standard `aod::Cascades` and LF `CascDatas` are different layers.

## 10.13 Standard-table inventory and the 82-symbol review census

The v0.5 review independently cross-validated a generated census of **82 standard `AnalysisDataModel.h` symbols** and measured that the v0.5 prose named only 36 of them.

v0.5.1 adopts the correct division of labor:

- the narrative contains the family map and load-bearing examples above;
- the generated `standard_aod` namespace is **exhaustive for the pinned `AnalysisDataModel.h` source identity**;
- the generated inventory is attached/published alongside the registry and may be rendered as a generated appendix/table;
- the inventory is generated, never manually transcribed as code-driving truth.

**Evidence availability note:** the consolidated review reports that the cross-validated 82-row appendix was delivered by reviewers, but that exact appendix is not present in this drafting workspace. Therefore this revision records the reviewed count and hard requirement; it does not fabricate an unavailable 82-row list. Before ratification, the generated inventory must be attached and its row/symbol count mechanically reconciled to the selected pinned source.

## 10.14 What v0.5.1 does not hand-maintain

The human narrative does not manually duplicate every column, expression or table declaration. Exhaustive standard symbol/table/column metadata belong in the generated canonical registry and generated appendix.

---

# 11. PWG worked example: V0 data in `LFStrangenessTables.h`

LF now appears **after** the standard/base model because V0/cascade data reference standard objects such as tracks and collisions.

## 11.1 V0 relations

**Layer distinction.** The LF/O2Physics V0 data model extends the standard O2 layer described in §10.11. In particular, LF declarations can carry a `V0Id` whose target is the standard `aod::V0s` family.

`aod::V0s` is therefore a base/default standard table identity; `V0Datas` is an LF joined/derived view. Code and documentation must not collapse those names.

The `v0data` declarations include positive/negative daughter tracks, collision/V0 relations and several optional derived/MC references.

Relation targets come from the C++ declarations, not substring matching on physical branch names.

## 11.2 V0 positional view

**O2 SOURCE FACT — snapshot-exact; commit reconciliation pending.**

[VERBATIM PWGLF/DataModel/LFStrangenessTables.h:L1078]

Snapshot SHA-256: `2a9b56e7bca657e3efb1064b7e6e38643af123784f9d9a7b353db2036e8bc852`

```cpp
using V0Datas = soa::Join<V0Indices, V0TrackXs, V0Cores>;
```

Conceptually:

```text
V0Indices ┐
V0TrackXs ├─ positional V0Data view
V0Cores   ┘
```

## 11.3 V0 dynamic quantities

V0 core views expose many derived kinematic quantities. Python ports should be generated/implemented selectively and validated against C++ semantics, not treated as persisted branches.

---

# 12. PWG worked example: cascade data

## 12.1 Cascade relations

Cascade source declarations relate cascade rows to V0s, daughter/bachelor tracks, collisions and alternative cascade representations.

## 12.2 Cascade positional views

**O2 SOURCE FACT — snapshot-exact; commit reconciliation pending.**

[VERBATIM PWGLF/DataModel/LFStrangenessTables.h:L1745-L1747]

Snapshot SHA-256: `2a9b56e7bca657e3efb1064b7e6e38643af123784f9d9a7b353db2036e8bc852`

```cpp
using CascDatas = soa::Join<CascIndices, CascBBs, CascCores>;
using KFCascDatas = soa::Join<KFCascIndices, KFCascCores>;
using TraCascDatas = soa::Join<TraCascIndices, TraCascCores>;
```

These declarations prove the positional families. Equal file row counts merely validate/candidate-check realization.

---

# 13. Source hierarchy — what is authoritative for what?

| Question | Primary authority | Secondary evidence |
|---|---|---|
| What does an ASoA index/join/concat/dynamic column mean? | pinned `ASoA.h` / `ASoA.cxx` | official O² docs |
| What standard tables/columns/indices exist? | pinned `AnalysisDataModel.h` | generated docs / compiler metadata |
| What PWG V0/cascade declarations exist? | pinned `LFStrangenessTables.h` + dependencies | generated registry |
| What does an index target? | `binding_t` / `index_targets` / compiler-resolved type | branch spelling as diagnostic only |
| Which index types are equivalent? | `DECLARE_EQUIVALENT_FOR_INDEX*` | registry |
| What is a positional family? | explicit `soa::Join` or reviewed producer/task lockstep evidence | file compatibility checks |
| How does source map to ROOT tree/branch names? | pinned writer/reader/tree/index-builder implementation | actual AO2D schema |
| What is actually in this file? | fingerprinted AO2D itself | source reference |
| What produced it? | workflow/producer source + provenance | docs/dependency finder |
| What should Python expose? | reconciled registry + AO2DAI policy; ADF adapter contract for ADF surface | convenience aliases |

## 13.1 No-heuristic final authority

Forbidden final-authority inferences include:

- equal row count → semantic join;
- branch contains `Track` → target is `Tracks`;
- plural alias → table;
- highest version number → current alias;
- all negative indices → normalize to `-1`;
- value happens to fit in float → `float64` safe;
- same local row number in another partition → same object.

Heuristics may discover candidates; unresolved candidates remain fail-closed.

---

# 14. Source files the registry must index

## 14.1 Tier A — generic and standard/base semantics

Mandatory source families include:

| Source | Role |
|---|---|
| `Framework/Core/include/Framework/ASoA.h` | table/column/index/self/index-table/join/concat machinery |
| `Framework/Core/src/ASoA.cxx` | runtime join/concat/slicing helpers |
| `Framework/Core/include/Framework/AnalysisDataModel.h` | **mandatory standard/base AO2D model** |
| `Framework/Core/include/Framework/ArrowTypes.h` | C++ ↔ Arrow type mapping |
| `Framework/Core/include/Framework/DataTypes.h` | framework data types |
| `Framework/Core/include/Framework/DataOutputDirector.h` + `Framework/Core/src/DataOutputDirector.cxx` | output/table naming/routing |
| `Framework/AnalysisSupport/include/Framework/TableTreeHelpers.h` + corresponding source | Arrow/table ↔ ROOT helpers |
| `Framework/AnalysisSupport/src/AODWriterHelpers.h` + `.cxx` | AO2D writing |
| `Framework/AnalysisSupport/src/AODReaderHelpers.h` + `.cxx` | AO2D reading |
| `Framework/Core/include/Framework/IndexBuilderHelpers.h` + source | index building |

**AO2DAI VALIDATION REQUIRED:** exact helper paths and commits must be frozen from the selected source checkout. The table above is the intended source inventory, not a substitute for commit-pinned path verification.

## 14.2 Tier B — LF V0/cascade

`PWGLF/DataModel/LFStrangenessTables.h` plus transitive data-model dependencies.

## 14.3 Tier C — producers and consumers

Data-model headers do not necessarily close all lockstep/derived physical families. Recursively index producer/task source when it establishes row identity, fills a physical table, or resolves provenance/version semantics.

## 14.4 Tier D — physical files

The final registry reconciles source against:

1. a **standard/base AO2D fixture** covering representative BC/collision/track/TrackExtra/MC/index families, preferably with multiple `DF_*` partitions;
2. the LF V0/cascade pilot file used by AO2DAI;
3. the full target AO2D where required for final acceptance/performance.

---

# 15. Generated canonical registry

The human page remains readable; exact code-driving records belong in generated evidence.

## 15.1 Required artifact and coverage

**PROPOSED DESIGN.**

`DataFormats_AO2D.json`

For v0.5.1 ratification it must be a **real generated artifact**, not a schema sketch.

Coverage policy:

- `standard_aod` — **exhaustive** for the complete pinned `Framework/Core/include/Framework/AnalysisDataModel.h` source identity;
- `o2physics_extensions` — bounded initially to the reviewed LF V0/cascade closure plus required dependencies/producers;
- `physical_files` — reconciliation records for the standard fixture and LF pilot when supplied.

The standard namespace is not “worked examples only”. Every declared standard table/entity required by the registry schema is emitted even if the human narrative does not mention it.

## 15.2 Registry header

```text
registry_schema_version
generator_name
generator_commit_or_fingerprint
generation_timestamp
AliceO2 source identity/fingerprint
O2Physics source identity/fingerprint
input AO2D/schema fingerprints
namespace_coverage
```

## 15.3 Symbol/entity record

```text
cpp_symbol
declared_target_text
resolved_target
entity_kind: table | stored_table | extended_table | iterator | alias | join_view | concat_view | index_table | other
alias_resolution: normal | self_alias | cycle | unresolved
resolution_method: parsed | compiler_resolved
origin
label
description
version
source_identity
source_location
validation_status
```

Resolvers must have cycle guards. A source self-alias is recorded explicitly rather than recursively followed forever.

## 15.4 Table record

```text
logical_type
stored_type_if_any
extended_or_view_type
current_alias
current_alias_target
current_alias_is_highest_declared_version: true | false | not_applicable
origin
label
description
version
persistent columns + exact source/Arrow/file dtypes
expression/dynamic columns
ordinary index columns
self indices
index-equivalence memberships
source-proven positional memberships
index-table memberships
physical AO2D tree candidate(s)
actual file tree/version
producer evidence
reconciliation status
```

Source/file physical dtype is recorded independently from any optional user conversion in Python/ADF.

## 15.5 Relation/index record

Ordinary relation-column `relation_kind` values include:

```text
external_scalar
external_slice
external_array
self_scalar
self_slice
self_array
index_equivalence
positional_join
positional_candidate
```

`index_table` is **not** one of these relation-column kinds; index tables have their own entity record (§15.6).

For index columns record:

```text
source table
getter / Id type
source macro family
physical label rule
storage type/shape
binding_t / index_targets
validity/empty rule
raw physical-value policy
partition scope
slicing/remapping policy
actual branch/dtype
validation status
```

For index equivalence record:

```text
declaration_form: classic_cpp_type | ng_string_key
key_form: cpp_type | description_version | label_version
left_declared
right_declared
left_resolved_key
right_resolved_key
key_case_policy: byte_exact
source identity/location
validation status
```

## 15.6 Index-table record

```text
entity_kind: index_table
exclusive: true | false
source_declared_name
source_macro
key_table
index_columns
array_index_columns
edge_kinds_if_generated
source_macro_expansion_status
source identity/location
physical table identity
validation status
```

Concrete names containing `Sparse` are preserved as source names but do not define the generic framework boolean.

## 15.7 Registry ↔ Markdown consistency

Every normative worked example in this Markdown must resolve to a registry record. The Markdown may be less exhaustive, never contradictory.

The generated standard inventory is also checked against the `standard_aod` registry namespace. Review-reported counts are evidence to reproduce, not hard-coded generator constants.

---

# 16. C++ → Python metadata bridge

## 16.1 Preferred architecture

**PROPOSED DESIGN.**

```text
pinned AliceO2 + O2Physics
       │
       ├─ independent declaration scanner A
       ├─ independent declaration scanner B / generated-doc census
       ├─ physical-I/O mapping extractor
       ├─ compiled metadata resolver
       │
       ▼
canonical DataFormats_AO2D.json
       │
   ┌───┴──────────────┐
   ▼                  ▼
DataFormats_AO2D.md   AO2DAI Python loader
                         │
                         ▼
                    AliasDataFrame
```

Two independent extraction routes are intentional: the v0.5 review found the same `_FULL` macro argument-order bug independently in two parsers.

## 16.2 Text extractor: discovery, not blind authority

Extract:

- table/version macros;
- stored/extended/current aliases;
- persistent/expression/dynamic columns;
- external and self index macro families;
- `DECLARE_SOA_INDEX_TABLE*`;
- `DECLARE_EQUIVALENT_FOR_INDEX*`;
- `soa::Join` / `soa::Concat` aliases;
- producer/task evidence required for lockstep closure.

Fail closed on unresolved template/preprocessor constructs.

### Parser hazards that must be explicit

1. **`DECLARE_SOA_TABLE_FULL` / `_FULL_VERSIONED` argument order is not the same as the simpler table macros.** Do not reuse one regex positional interpretation across all table macros.
2. **`INDEX_LIST_*` indirection** can hide several index columns behind one macro identifier. Preserve the source macro and require expansion/compiler resolution when the scanner cannot prove the list.
3. **Self aliases/cycles** such as the current `Decay3Bodys` self-alias require a cycle guard and explicit `self_alias` status.
4. **Alias entity kind** must be resolved; `TracksQA` is a demonstrated iterator-alias hazard.
5. **Case is semantic source evidence.** Preserve strings such as `Run2OTFV0` and `MFTTracks` byte-for-byte.
6. **Equivalence declaration form and resolved key are separate fields.**

Before registry freeze, two independent generator/census routes must agree on the pinned `standard_aod` symbol set, or the discrepancy is fail-closed.

## 16.3 Compiler-assisted resolution

A small C++ extractor built against the pinned O² source can emit resolved metadata such as:

```text
originals
columns_t
external_index_columns_t
binding_t
index_targets
table refs
entity kind
index equivalence
index-table exclusive flag
```

Compiler-assisted resolution is authoritative for constructs a text extractor cannot prove.

## 16.4 Macro rules are versioned source rules

Do not implement English-like assumptions such as “append `s` to pluralize”. Encode the exact macro expansion for the pinned source or defer to compiler resolution.

External and self-index naming rules are separate.

## 16.5 Dynamic/expression quantities

Only high-value quantities should be ported initially. Each port records source dependencies/type and must pass C++↔Python equivalence tests.

---

# 17. Mapping O² semantics to AliasDataFrame

| O² concept | AO2DAI / ADF representation | Contract |
|---|---|---|
| persistent table | logical ADF frame | preserve source/physical provenance |
| persistent column | pandas/Arrow-backed column | source/file dtype is authoritative; user conversion is separate |
| `o2::soa::Index<>` | row identity metadata | not a foreign relation |
| external scalar index | ADF subframe relation | source target + applicability + remap |
| slice index | range relation | contiguity-aware |
| array index | one-to-many relation | element-wise closure/remap |
| self index | same-frame relation | same-table remap |
| index equivalence | compatibility metadata | never flatten to join |
| `soa::Join` | **one logical row-aligned frame/view** | assemble row-aligned members; do not model the join itself as a subframe |
| unresolved positional candidate | no semantic ADF join | union-mask safety only |
| index table | explicit matching/index table entity | key/index columns preserved |
| `soa::Concat` | vertical combination | common-schema behavior |
| dynamic column | ADF alias/function | equivalence-tested, not physical branch |
| expression column | derived/materialized expression | observable semantics preserved |
| current alias | registry source alias | not “highest version” heuristic |
| `DF_*` partition | partition/provenance key | prevents cross-partition collision |

## 17.1 ADF consumes the registry, not this Markdown

AO2DAI resolves O² semantics into the canonical registry first. ADF receives those resolved records. It must not infer O² relation targets from branch/table names or from prose in this document.

## 17.2 Source-verified public subframe API shape

**ADF SOURCE FACT — candidate bundle verified; final ADF pin pending.** Candidate bundle SHA-256:

`27c190153090115e9b3e8cc26a616382702c7611f9ca84c9a67547f3885c4147`

contains the public method:

```python
parent.register_subframe(
    "Child",
    child,
    index_columns=["parent_key_1", "parent_key_2"],
    right_index_columns=["child_key_1", "child_key_2"],
)
```

The method/parameter names and support for `right_index_columns` are source-verified. The concrete key names above are illustrative AO2DAI adapter names.

`right_index_columns` means that **asymmetric parent/child key names are natively supported by the reviewed ADF API**. Symmetric normalized names are therefore not an ADF requirement.

**ADF VALIDATION REQUIRED:** execute the exact selected ADF pin and independently verify the AO2DAI relation shapes before ratification.

## 17.3 Native asymmetric keys versus optional symmetric normalized keys

AO2DAI may still choose a symmetric normalized key for persistence, manifest uniformity or an independently justified integration reason. That is an **AO2DAI adapter choice**, not a statement about what ADF requires.

Whichever path is selected must preserve:

- original physical parent/child key names and values;
- exact source/file dtypes;
- target identity;
- partition scope;
- applicability;
- old→new remap provenance;
- the selected adapter form in the manifest.

No lossy key conversion is permitted.

## 17.4 Required AO2DAI → ADF adapter sequence

1. Resolve the O² relation completely from `DataFormats_AO2D.json`.
2. Build/preserve physical keys and partition provenance.
3. Select native asymmetric keys or an explicitly justified symmetric normalized adapter.
4. Call `parent.register_subframe(...)` with parent `index_columns` and child `right_index_columns`.
5. Validate all relevant expression surfaces against independent pandas/NumPy/direct-read oracles.
6. Record the active ADF capability/adapter choice and source pin in the manifest.

For a source-declared `soa::Join`, step 4 is **not** the representation of the join itself: the joined members first become one row-aligned logical frame.

## 17.5 ADF capability matrix required at the gate

| Capability | Candidate-source evidence | Required ratification evidence |
|---|---|---|
| `register_subframe` public API | source-verified | execute at final ADF pin |
| asymmetric `right_index_columns` | source-verified | oracle with different parent/child key names |
| composite key list | source/API shape supports lists | multi-partition composite-key oracle |
| `eval` across subframe | capability to be executed | independent value oracle |
| `draw` expression | capability to be executed | returned-stat/value oracle |
| `selection=` using subframe data | capability to be executed | independent selected-row oracle |
| `group_by=` using subframe data | capability to be executed | independent grouped oracle |
| `facet_by=` using subframe data | capability to be executed | independent facet membership/statistics oracle |
| persistence/reload if used by AO2DAI | separately gated | roundtrip relation + dtype + provenance oracle |

The permanent contract is the selected public behavior at the final ADF pin, not historical bug behavior.

---

# 18. Source-versus-file reconciliation

## 18.1 Status vocabulary

Minimum statuses:

```text
SOURCE_MATCHED
SOURCE_VERSION_MISMATCH
SOURCE_UNRESOLVED
FILE_ONLY
SOURCE_ONLY
TYPE_MISMATCH
RELATION_UNVERIFIED
SOURCE_PROVEN_POSITIONAL
POSITIONAL_CANDIDATE_UNRESOLVED
INDEX_EQUIVALENCE_UNVERIFIED
INDEX_TABLE_UNVERIFIED
```

## 18.2 File inspection

For every `DF_*` and persisted object:

- partition identity;
- ROOT object class;
- tree name/version;
- row count;
- branch names and typenames;
- index shape;
- raw value range/invalid pattern;
- candidate equal-row groups as diagnostic only;
- source/file fingerprint.

## 18.3 Source comparison

Compare:

- description/origin/version;
- current alias target;
- stored/extended/view identity;
- exact dtype;
- ordinary/self index target;
- index equivalence;
- index-table identity;
- positional relation evidence;
- producer/task provenance;
- physical naming rule.

## 18.4 Pilot LF file versus standard fixture

The existing pilot measurements are valuable for O2Physics/derived-data behavior, but they do not substitute for a standard/base AO2D fixture.

**AO2DAI VALIDATION REQUIRED:** provide a representative standard fixture containing BC/collision/track/TracksExtra/MC/index-table content across more than one partition where practical.

## 18.5 Negative-value open question

Multiple negative values were measured in pilot scalar-index branches. Their existence is evidence; their magnitude must not be assigned semantics without source/producer evidence.

The standard `AmbiguousTracks` mechanism is a reminder to search for explicit auxiliary ambiguity relations before inventing an encoding model.

---

# 19. Relation-aware slicing and small-file development

A reduced AO2D is valuable for fast coding, but slicing is a semantic transformation.

## 19.1 Source-proven positional family

Apply one mask/order to every persisted member of a source-proven positional family.

## 19.2 Unresolved positional candidate

Apply the conservative union-mask policy from §6.3 and preserve unresolved status.

## 19.3 Dependency closure

If a retained row has a live reference, retain the target according to relation kind; iterate transitively to a fixed point.

Closure alone is insufficient after compaction.

## 19.4 Old→new remapping

After final retention is known:

```text
old target row
    ↓ deterministic map per partition/table
new target row
    ↓
rewrite retained relation
```

- scalar external/self → one value;
- array external/self → every element;
- slice external/self → only if valid contiguous output range.

A live source reference absent from the final target map is an error, not an excuse to synthesize a negative sentinel.

## 19.5 Slice contiguity

If arbitrary retention breaks a slice's contiguity, fail or use an explicitly approved alternative representation. Never fabricate a plausible contiguous pair.

## 19.6 Exact slicing manifest

Per partition/table record:

```text
source row count
retained source row IDs
old→new row map
rewritten scalar/self indices
rewritten array indices
reconstructed/refused slices
source-proven positional masks
unresolved-candidate union masks
validation status
```

## 19.7 Minimum acceptance fixtures

Before the slicer is trusted:

1. scalar external remap after deleting earlier parent rows;
2. scalar self-index remap;
3. array-index element remap;
4. self-array remap;
5. transitive closure + remap;
6. contiguous slice retained and reconstructed;
7. broken slice rejected/approved fallback;
8. **source-proven positional family** proving one shared mask/order across all members;
9. unresolved equal-row candidate proving union-mask safety without semantic promotion;
10. multi-partition fixture proving no cross-partition relation collision;
11. index-table fixture covering at least one `exclusive=true` and one `exclusive=false` table, including a concrete multi-index/array-index case.

Fixture 8 is intentionally explicit: prior review execution found that absence of a positional-family test can allow real slicer corruption. All eleven fixtures are specified but remain **execution-pending** until §24.3 evidence is attached.

---

# 20. v0.5.1 ratifiable scope

v0.5.1 retains the v0.5 standard/base teaching spine and closes the review-identified schema/API gaps. Its ratifiable generated scope is now stricter than the human prose scope.

Ratifiable scope requires:

1. ALICE/O²/AO2D orientation;
2. generic ASoA semantics needed by AO2DAI;
3. standard/base backbone worked examples from `AnalysisDataModel.h`:
   - BC/timestamp;
   - collisions;
   - tracks/extra/cov/full;
   - ambiguity;
   - representative detector families;
   - MC and labels;
   - origins/provenance;
   - index tables;
4. all relation classes in §5 and positional/concat semantics;
5. LF V0/cascade worked examples;
6. source/file reconciliation;
7. slicing/remapping safety contract;
8. C++→registry→Python architecture;
9. generated `DataFormats_AO2D.json` complete for every normative worked example/safety rule above;
10. ADF integration contract validated by ADF.

Not required for v0.5.1:

- prose description of every standard column;
- all O2Physics PWGs;
- automatic Python translation of every dynamic column;
- all-PWG generated registry;
- full Python clone of ASoA.

---

# 21. Reader paths

## New AO2DAI reviewer

Read §§1–10, then §§13 and 19. You should be able to reject common unsafe inferences before reading LF-specific details.

## AO2DAI coder

Read §§1–20. Treat §§5–7, 10, 13–19 as implementation contracts, subject to declared validation gates.

## AO2DAI source reviewer

Must directly read the pinned `AnalysisDataModel.h`, `ASoA.h/cxx`, relevant physical-I/O helpers, LF source and producer/task closure required for each claim being certified.

## ADF reviewer

Review only §§17.1–17.3 plus ADF-related gate items: public API, normalized keys, provenance/dtype preservation and executable oracle tests.

## MIWikiAI reviewer

Review front matter, provenance labels, source identities, canonical-byte fingerprint, Markdown/HTML consistency, navigation and readability. MIWikiAI source-read confirms documentation grounding but does not replace AO2DAI semantic/physical sign-off.

---

# 22. Authoritative orientation links

These mutable links are orientation only until commit-anchored pins are selected.

- ALICE O² Project: https://alice-o2-project.web.cern.ch/
- AliceO2: https://github.com/AliceO2Group/AliceO2
- O2Physics: https://github.com/AliceO2Group/O2Physics
- Analysis Framework: https://aliceo2group.github.io/analysis-framework/
- Standard AO2D tables: https://aliceo2group.github.io/analysis-framework/docs/datamodel/ao2dTables.html
- Table I/O: https://aliceo2group.github.io/analysis-framework/docs/tutorials/tablesIO.html
- Current-orientation `AnalysisDataModel.h`: https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/AnalysisDataModel.h
- Current-orientation `ASoA.h`: https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/include/Framework/ASoA.h
- Current-orientation `ASoA.cxx`: https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/src/ASoA.cxx
- Current-orientation `LFStrangenessTables.h`: https://github.com/AliceO2Group/O2Physics/blob/master/PWGLF/DataModel/LFStrangenessTables.h

---

# 23. Glossary

**ALICE** — A Large Ion Collider Experiment at CERN's LHC.

**O² / O2** — ALICE Online-Offline software/computing system.

**AOD / AO2D** — analysis object data / conventional ROOT file carrying O² analysis tables.

**ASoA** — AliceO2 typed Structure-of-Arrays analysis abstraction.

**Persistent column** — stored table data.

**Dynamic column** — computed callable view; not its own persisted branch.

**Expression column** — declarative computed column with framework expression/materialization semantics.

**External index** — relation to another target table family.

**Self index** — relation to the same logical table family.

**Index equivalence** — source-declared compatibility for index binding; not a join.

**Index table** — generated matching table built from a key table and index columns, e.g. exclusive/sparse matching.

**`SOURCE_PROVEN_POSITIONAL`** — positional relation established by source/producer evidence.

**`POSITIONAL_CANDIDATE_UNRESOLVED`** — file-discovered lockstep candidate awaiting source closure.

**`soa::Join`** — positional side-by-side source-declared view.

**`soa::Concat`** — vertical combination with pinned common-schema behavior.

**Old→new remap** — deterministic source-row to compacted-output-row mapping.

---

# 24. Required work before ratification

## 24.1 Architect/source identity

1. Name the 40-character AliceO2 and O2Physics reference commits.
2. Decide whether those commits are provenance of old snapshots or intentionally new baselines.
3. Supply canonical source bytes/fingerprints for ratification.

## 24.2 AO2DAI semantic/source validation

1. Read pinned `AnalysisDataModel.h`, `ASoA.h/cxx`, physical-I/O helpers and LF/producer sources.
2. Reconcile all current-upstream statements to the chosen commits.
3. Census ordinary/self indices, both equivalence mechanisms and all standard index tables in the bounded scope.
4. Validate physical naming/version rules.
5. Generate canonical `DataFormats_AO2D.json` with exhaustive `standard_aod` coverage and bounded LF extension coverage.
6. Attach/reproduce the review-reported standard inventory census using two independent extraction routes; discrepancies fail closed.
7. Verify Markdown ↔ registry equality for every normative example.

## 24.3 Physical-file validation

1. Fingerprint and reconcile the standard/base fixture.
2. Fingerprint and reconcile the LF pilot file.
3. Validate producer/task positional closure.
4. Execute all §19.7 slicing fixtures.

## 24.4 ADF validation

1. Pin ADF source/version.
2. Validate public relation/subframe API and normalized-key behavior.
3. Replace/retain schematic §17.2 according to tested public API.
4. Verify exact dtype, partition and provenance preservation.
5. Run independent oracles for `eval`, draw expressions, `selection=`, `group_by=` and `facet_by=` across representative AO2D subframe relations.
6. Record native-asymmetric versus normalized-key adapter choice and capability matrix at the selected pin.

## 24.5 MIWikiAI formal/publication validation

1. Validate front matter and document class.
2. Validate source labels and canonical-byte fingerprint.
3. Verify exact `[VERBATIM]` blocks against supplied snapshot/source bytes.
4. Generate and visually inspect HTML (UTF-8 title, TOC, anchors, code blocks, tables).
5. Confirm Markdown is canonical and HTML is generated from it.

---

# 25. v0.5.1 revision summary

v0.5.1 is the bounded AO2DAI closure revision requested by the consolidated v0.5 review. It does not redesign the approved architecture.

Review-finding closure:

- **F-1:** adds the standard/default O2 V0/cascade/3-body layer (`V0s`, `Cascades`, `Decay3Bodys`, tracked variants) and explicitly distinguishes it from O2Physics LF `V0Datas` / `CascDatas`;
- **F-2:** adds a compact standard family map, records the independently cross-validated 82-symbol review census, and makes the generated `standard_aod` namespace exhaustive; the exact 82-row reviewer appendix must still be attached/reproduced rather than transcribed from memory;
- **F-3:** separates equivalence declaration form from resolved key, adds `label_version`, preserves byte-exact/case-sensitive keys, changes index-table taxonomy to `entity_kind=index_table` + `exclusive: bool`, removes `index_table` from ordinary relation kinds, and requires exhaustive standard coverage;
- **F-4:** replaces invented ADF relation pseudocode with the source-verified `register_subframe(..., index_columns, right_index_columns)` public API shape, records native asymmetric-key support, maps `soa::Join` to one row-aligned logical frame, and requires full `eval`/draw/selection/group/facet oracles;
- **F-5:** adds self-alias cycle guarding, exact source-case preservation (`Run2OTFV0`), `INDEX_LIST_*` compiler-resolution handling, snapshot-relative VERBATIM clarification, physical-dtype-versus-user-conversion separation, `_FULL` argument-order hazards, and two-generator cross-validation.

**Ownership:** AO2DAI remains substantive owner; ADF validates its own integration surface; MIWikiAI performs the final formal/publication check.

**Ratification status:** DRAFT until §24 is discharged.

# End of `DataFormats_AO2D` v0.5.1 DRAFT
