# O2 Monte Carlo / MC-truth Source Index — Phase_0_1 Draft

**Project:** O2MCAI  
**Reviewer / technical owner:** `GPT3:O2MCAI`  
**Date:** 2026-09-20  
**Intended handoff:** MIWikiAI  
**Status:** Technical draft; semantic indexing complete for the Phase_0_1 scope, with one provenance-closure item described below.

## 1. Authority, scope, and review anchor

The primary authority for this index is the **AliceO2 source repository**:

- Repository: `https://github.com/AliceO2Group/AliceO2`
- Repository role: ALICE O2 framework plus detector-specific reconstruction, calibration, simulation, common DataFormats, and global algorithms.
- Provisional fixed review anchor: `5d1f5199b8e690a0fa257cb152ec2943e0071bea`
- Moving source also read during this review: AliceO2 `dev` source pages and contemporary AliceO2 Doxygen source pages available on 2026-09-20.

### Important provenance qualification

The semantic review below was performed against actual AliceO2 source exposed through the current `dev` GitHub pages and AliceO2 Doxygen source pages. The public commit history exposed the full anchor SHA above, but this review environment did **not** permit retrieval of raw files at that exact SHA. Therefore this document does **not** claim that every statement has already been byte-differenced against `5d1f5199b8e690a0fa257cb152ec2943e0071bea`.

Before the document is labelled **source-certified at the pinned commit**, run the supplied `phase_0_1_verify_aliceo2_source.sh` in a real AliceO2 checkout. It verifies the commit, extracts every indexed file with `git show`, and emits per-file SHA-256/size/line-count evidence.

This separation is deliberate: the semantic source indexing is useful now, while exact-byte provenance must not be fabricated.

## 2. Source-first architecture map

```text
generator / event input
      |
      |  TParticle + generator-specific / HepMC status
      v
O2 simulation stack / transport
      |
      +--> MCTrack -------------------------------+
      |      particle kinematics, ancestry,       |
      |      transport process/status, hit mask   |
      |                                           |
      +--> TrackReference                         |
      |      transport waypoints / detector state |
      |                                           |
      +--> MCEventHeader                          |
             event/generator/HepMC metadata       |
                                                  v
detector hits/digits/clusters  <---- MCCompLabel {source,event,track}
      |                                 |
      |                     MCTruthContainer[data index] -> labels
      |                                 |
      +---------------------------------+
                                        v
                              MCKinematicsReader
                         labels -> tracks / header / refs
                                        |
                                 MCTrackNavigator
                               ancestry / primary logic
                                        |
                                        v
                              AOD producer helpers
                                        |
             +--------------------------+--------------------------+
             v                          v                          v
        McCollisions               McParticles               MC label tables
        HepMC aux tables      remapped genealogy/status    reco row -> McParticle
```

O2 MC truth is not one class or one ID. It is a chain of contracts connecting:

1. a **simulation particle record** (`MCTrack`);
2. an **event namespace** (source ID + event ID);
3. compact **truth labels** pointing into that namespace (`MCCompLabel`);
4. object-to-truth **association containers** (`MCTruthContainer`);
5. a **kinematics resolver** (`MCKinematicsReader`);
6. ancestry/primary **navigation semantics** (`MCTrackNavigator`);
7. and a separate **analysis representation** in AO2D (`McCollisions`, `McParticles`, label tables).

## 3. Core source index

### 3.1 `MCTrack`

**Source:** `DataFormats/simulation/include/SimulationDataFormat/MCTrack.h`

`MCTrackT<_T>` is the lightweight persisted simulation-particle record used in place of retaining a full `TParticle` object for the MC kinematics output. `MCTrack` is the `float` specialization.

The record carries initial momentum; production/start position and time; PDG code and weight; first/second mother identifiers; first/last daughter identifiers; transport production process; storage/transport state; detector hit mask; and generator-status information.

The reviewed source packs several transport properties into `mProp`; it defines a 22-bit detector hit mask and a compact process/status layout. The detector-ID-to-hit-bit mapping is not implicit in the integer itself: the event header owns the lookup needed to interpret detector hit bits.

`MCTrack::isPrimary()` is a **simulation-record criterion**: it accepts tracks whose process is `TMCProcess::kPPrimary`, or tracks with both mother IDs negative. This is not a safe synonym for every other API called “physical primary” in O2.

A second important distinction is **generator status vs transport process**. For primary input particles the `MCTrack` constructor can preserve generator status. Transport-created secondaries instead carry transport-production process semantics. The AO2D layer later makes this distinction explicit with flags and dynamic getters.

### 3.2 `TrackReference`

**Source:** `DataFormats/simulation/include/SimulationDataFormat/TrackReference.h`

`TrackReference` is a transport waypoint/reference associated with an MC track. It records MC track number, position, momentum, accumulated track length, transport time of flight, detector identifier, user identifier, and `SimTrackStatus`.

The constructor taking `TVirtualMC` samples the current transport state. `SimTrackStatus` captures VMC transition/state information such as entering, inside, exiting, stopped/alive/new status.

**Semantic consequence:** a `TrackReference` is not a second particle identity. It is a state/reference **along the transport history of a particle** and must be interpreted together with its track ID and event/source namespace.

### 3.3 `MCEventHeader`

**Source:** `DataFormats/simulation/include/SimulationDataFormat/MCEventHeader.h`

`o2::dataformats::MCEventHeader` extends the FairRoot MC event header with O2-specific metadata. It is the event-level partner of the per-particle `MCTrack` vector.

The reviewed source exposes event position/time inherited from the event header, embedding file/event information, `MCEventStats`, detector-ID ↔ MCTrack hit-bit lookup, a typed key/value store (`putInfo`, `hasInfo`, `getInfo`), and generator/HepMC-oriented `MCInfoKeys`.

`MCInfoKeys` covers generator name/version and process identifiers, event weights, accepted/attempted event counts, generated cross section and uncertainty, impact parameter/event-plane information, participant/collision/spectator counters, PDF metadata, signal-process/event-scale and MPI-style metadata.

A representative source producer is `Generators/src/GeneratorHepMC.cxx`: it writes HepMC generator/version information into `MCEventHeader`, imports cross-section/PDF/heavy-ion information, and uses `MCGenHelper` to encode particle tracking/status.

### 3.4 Generator and status encodings

**Source:** `DataFormats/simulation/include/SimulationDataFormat/MCGenProperties.h`

Two encodings must be kept separate.

`MCGenStatusEncoding` represents generator/HepMC status in a 32-bit value. The reviewed source supports a tagged encoding containing HepMC status, generator-specific status, reserved bits, and an encoding sentinel. Backward compatibility is explicit: untagged values are treated as the legacy status representation rather than silently reinterpreted.

`MCGenIdEncoding` compactly represents generator ID, source ID, and sub-generator ID. The source stores the sub-generator ID with an offset so that “no sub-generator” remains representable.

`ParticleStatus.h` and `MCGenHelper` own transport/storage-related state used when converting generator particles to transport input. `MCTrack` stores process and selected state in its compact properties.

**Indexing rule:** do not merge these into one “status code”:

| Layer | Meaning |
|---|---|
| generator/HepMC status | status assigned by event generator / HepMC representation |
| transport process | `TMCProcess` describing how a transported secondary was produced |
| transport/storage state | whether the particle is kept/transported/inhibited etc. |
| AO2D status/flags | analysis-layer projection distinguishing generator-produced and transport-produced rows |

### 3.5 `MCCompLabel`: compact truth identity

**Source target:** `DataFormats/simulation/include/SimulationDataFormat/MCCompLabel.h`

The semantically important identity exposed to consumers is:

```text
(sourceID, eventID, trackID)
```

`MCKinematicsReader::getTrack(const MCCompLabel&)` resolves exactly those three components to an `MCTrack`. Detector tests and reconstruction consumers construct/read labels in the same source/event/track sense.

Labels also carry state needed by downstream matching (valid/set/noise/fake semantics are used by consumers).

**Phase_0_1 restraint:** the exact packed bit allocation of `MCCompLabel` is deliberately **not documented here**. The identity/navigation semantics are validated from the reader and consumers, but the direct pinned `MCCompLabel.h` bytes are part of the provenance-closure item.

### 3.6 `MCTruthContainer`: data object -> one or more truth objects

**Source:** `DataFormats/simulation/include/SimulationDataFormat/MCTruthContainer.h`

`MCTruthContainer<TruthElement>` provides an external truth association rather than forcing truth fields into every detector object.

```text
data object index -> [truth element 0, truth element 1, ...]
```

`MCTruthHeaderElement` stores the offset/index into the truth payload, while APIs such as `addElement(...)` and `getLabels(dataindex)` implement one-to-many truth association.

The common detector pattern is:

```text
digit / cluster ordinal
       |
       v
MCTruthContainer<MCCompLabel>
       |
       +--> zero, one, or multiple MCCompLabel values
```

This is why **truth identity** (`MCCompLabel`) and **truth association multiplicity** (`MCTruthContainer`) should be indexed as separate concepts.

`ConstMCTruthContainer` and `IOMCTruthContainerView` are supporting representations for read-only access / ROOT I/O. Detector code such as the TPC cluster-native helper includes these explicitly when persisting cluster truth.

### 3.7 `MCTrackNavigator` and `MCGenHelper`

**Source:** `DataFormats/simulation/include/SimulationDataFormat/MCUtils.h`

`o2::mcutils::MCTrackNavigator` is a lightweight navigation helper operating on a container of `MCTrack` objects. The reviewed source exposes mother/daughter navigation, locating the first primary ancestor, primary/decay-chain relations, and physical-primary / keep-physics decisions.

These are higher-level physics/navigation predicates. They must not be replaced by a naive check of `MCTrack::isPrimary()`.

`MCGenHelper` is a generator-to-transport bridge. Generator code uses it to encode particle status/tracking information before the simulation stack consumes the particle.

### 3.8 `MCKinematicsReader`

**Sources:**

- `Steer/include/Steer/MCKinematicsReader.h`
- `Steer/src/MCKinematicsReader.cxx`

`o2::steer::MCKinematicsReader` is the main consumer-facing resolver for persisted MC kinematics. It supports digitization-context based source/event layout and direct MC-kinematics input.

The core navigation is:

```text
MCCompLabel
   -> getSourceID()
   -> getEventID()
   -> getTrackID()
   -> MCTrack
```

The reader also provides all tracks for a source/event, release of a source/event track cache, `MCEventHeader` retrieval, track-reference retrieval by source/event/track, and source/event counts/context.

This is the central bridge that makes compact detector labels navigable back to event kinematics without embedding full MC objects in detector outputs.

### 3.9 Simulation DataFormat family

The current `DataFormats/simulation/include/SimulationDataFormat/` inventory includes at least:

```text
BaseHits.h
ConstMCTruthContainer.h
DigitizationContext.h
InteractionSampler.h
IOMCTruthContainerView.h
LabelContainer.h
MCCompLabel.h
MCEventHeader.h
MCEventLabel.h
MCEventStats.h
MCGenProperties.h
MCTrack.h
MCTruthContainer.h
MCUtils.h
O2DatabasePDG.h
ParticleStatus.h
PrimaryChunk.h
StackParam.h
TrackReference.h
```

Phase_0_1 grouping:

| Group | Principal files |
|---|---|
| particle/event truth state | `MCTrack.h`, `MCEventHeader.h`, `MCEventStats.h` |
| truth identity / association | `MCCompLabel.h`, `MCEventLabel.h`, `MCTruthContainer.h`, `ConstMCTruthContainer.h`, `IOMCTruthContainerView.h`, `LabelContainer.h` |
| generator/transport semantics | `MCGenProperties.h`, `ParticleStatus.h`, `MCUtils.h` |
| event/source orchestration | `DigitizationContext.h`, `InteractionSampler.h`, `PrimaryChunk.h`, `StackParam.h` |
| detector truth interface | `BaseHits.h`, `TrackReference.h` |
| particle metadata support | `O2DatabasePDG.h` |

This grouping is an O2MCAI indexing aid, not an AliceO2 API classification.

## 4. Navigation semantics: four identifiers that must not be confused

### 4.1 Track ID
Within an MC event, mother/daughter IDs and `MCCompLabel.trackID` address entries in the event's MC-track collection.

### 4.2 Event ID
Identifies the MC event within one source stream.

### 4.3 Source ID
Identifies the simulation/input source in digitization contexts, including multi-source/embedding workflows.

### 4.4 AO2D row ID
AO2D `McParticle` references are table-row relations after AOD production. They are not the original `(source,event,track)` identifier and may reflect filtering/remapping performed by the AOD producer.

**Practical rule:** a compact detector `MCCompLabel` is resolved through `MCKinematicsReader`; an AO2D `McTrackLabel` is resolved as an index relation to the AO2D `McParticles` table. The two are related by production, but are not interchangeable types or namespaces.

## 5. Connection to AO2D MC tables

### 5.1 Analysis data model

**Source:** `Framework/Core/include/Framework/AnalysisDataModel.h`

The current model defines MC collision, particle, reconstructed-object label and HepMC auxiliary tables.

#### `McCollisions`

The current version stores a BC relation, compact `GeneratorsID`, x/y/z/t, weight, impact parameter, event-plane angle, and dynamic generator/sub-generator/source decoders. These dynamic values use `MCGenIdEncoding`.

#### `McParticles`

Current `StoredMcParticles_001` stores the `McCollision` relation, PDG code, status code, flags, mother-array and daughter-slice relations, weight, momentum/energy, and production vertex/time.

Dynamic columns expose produced-by-generator vs produced-by-transport, background-event flag, generator status, HepMC status, transport process, and physical-primary flag.

This is a **projection of simulation truth into an analysis table**, not `MCTrack` copied field-for-field.

A crucial contract is:

- generator-produced row: `getProcess()` reports primary-process semantics and generator/HepMC status accessors decode `statusCode`;
- transport-produced row: `getProcess()` interprets `statusCode` as transport process and generator/HepMC status accessors return `-1`.

#### MC label tables

For reconstructed tracks:

```text
McTrackLabels:
    McParticleId
    McMask (uint16)
```

Related tables exist for MFT/forward tracks, calorimeter associations, and collisions.

The semantics are therefore:

```text
reconstructed AO2D row -> AO2D McParticle row (+ mask)
```

not:

```text
reconstructed AO2D row -> raw MCCompLabel bits
```

### 5.2 `MCEventHeader` -> AO2D event/HepMC tables

AO2D defines event-generator auxiliary tables including `HepMCXSections` and `HepMCPdfInfos`, plus heavy-ion information in the same MC/HepMC section.

`HepMCXSections` associates an `McCollision` with generator identity and accepted/attempted counts, cross section/error, hard scale, MPI count and process ID.

This is the analysis-layer destination for a subset of richer `MCEventHeader` event information.

### 5.3 Producer bridge

Relevant paths:

- `Detectors/AOD/include/AODProducerWorkflow/AODProducerWorkflowSpec.h`
- `Detectors/AOD/include/AODProducerWorkflow/AODMcProducerHelpers.h`
- `Detectors/AOD/src/AODProducerWorkflowSpec.cxx`
- `Detectors/AOD/src/AODMcProducerWorkflowSpec.cxx`
- `run/o2sim_mctracks_to_aod.cxx`

The producer interface takes an `MCKinematicsReader` for MC-particle filling. Source code iterates source/event mappings, gets the corresponding `MCTrack` vector, converts/filters/remaps particles into AO2D rows, and releases per-event track data afterward.

The reconstructed-data producer also creates tables such as `McTrackLabels` relating reconstructed AO2D objects to remapped `McParticles`. The simulation-only producer fills MC collision/header-derived tables and MC particles without requiring reconstructed detector objects.

## 6. Primary-particle terminology: do not alias names by intuition

Three notions coexist:

1. `MCTrack::isPrimary()` — record/transport-origin criterion.
2. `MCTrackNavigator::isPhysicalPrimary(...)` — navigation/physics predicate over MC ancestry.
3. AO2D `mcparticle::IsPhysicalPrimary` — dynamic access to a persisted AO2D flag.

They are connected by producer logic but are not semantically interchangeable simply because their names contain “primary”.

## 7. Representative source-flow examples

### 7.1 HepMC generator to event/particle metadata

`Generators/src/GeneratorHepMC.cxx` creates `TParticle` entries from HepMC particles, calls `MCGenHelper::encodeParticleStatusAndTracking`, writes generator/version data to `MCEventHeader`, and copies cross-section, PDF and heavy-ion metadata to `MCInfoKeys`.

### 7.2 Detector object back to truth particle

Representative detector consumers follow:

```text
detector data index
 -> MCTruthContainer.getLabels(index)
 -> MCCompLabel
 -> MCKinematicsReader.getTrack(label)
 -> MCTrack
```

This is the source-level navigation pattern that should anchor MIWiki explanations.

## 8. Phase_0_1 boundaries

Included:

- core simulation MC truth DataFormats;
- particle/event/status/label semantics;
- reader/navigation path;
- generator/HepMC status bridge;
- simulation-to-AO2D connection;
- representative detector truth association.

Not exhaustively indexed yet:

- detector-specific label weighting/merging policies;
- every generator implementation;
- every simulation stack/transport implementation detail;
- every AO2D detector-specific MC label table;
- bit-for-bit layout of `MCCompLabel` and `ParticleStatus` until pinned direct source is attached;
- O2Physics analysis-level tables outside AliceO2.

## 9. Assertions suitable for MIWikiAI integration

1. `MCTrack` is the per-particle simulation kinematics/truth record; it is not an AO2D row type.
2. `TrackReference` describes transport state along a track, not a distinct MC particle.
3. `MCEventHeader` is event-level generator/simulation metadata and supplies metadata needed to interpret event/track truth.
4. O2 detector truth identity is commonly represented by `{sourceID,eventID,trackID}` in `MCCompLabel`.
5. `MCTruthContainer` provides data-object-index -> zero/one/many truth-element association.
6. `MCKinematicsReader` resolves compact identity back to `MCTrack`, event header and track references.
7. `MCTrackNavigator` supplies ancestry/physics navigation richer than direct integer mother/daughter access.
8. Generator/HepMC status, transport production process and transport lifecycle flags are different concepts.
9. AOD production remaps/projects simulation truth into `McCollisions`, `McParticles` and reconstructed-object label tables.
10. AO2D `McTrackLabels` index `McParticles`; they are not raw `MCCompLabel` records.

## 10. Provenance companion artifacts

This draft is accompanied by:

- `Phase_0_1_O2MC_Provenance_Evidence.md`
- `Phase_0_1_O2MC_Source_Inventory.csv`
- `phase_0_1_verify_aliceo2_source.sh`
- `Phase_0_1_O2MC_Review_Summary.md`

The verification script is the required closure mechanism for exact commit SHA / per-file byte provenance.
