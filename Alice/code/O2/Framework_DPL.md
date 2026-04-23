---
wiki_id: O2_Framework_DPL
title: "Framework — the O² Data Processing Layer (DPL): what it is, how it maps to FairMQ, and what lives in Framework/"
project: MIWikiAI / ALICE
folder: code/O2
source_type: software-index
source_status: DRAFT v0.1 — initial draft; awaits cycle-0 self-review then 7-reviewer panel cycle-1
source_fingerprint:
  upstream:
    - id: AliceO2-GitHub-root
      title: "AliceO2Group/AliceO2 — repository root (dev branch)"
      url: "https://github.com/AliceO2Group/AliceO2"
      branch: "dev"
      commit_verified: "87b9775"
      commit_evidence: "PR #15202 (aalkin, DPL: Better detection for injected workflows, merged 2026-03-26); Claude5 confirmed 1:1 directory match at re-fetch 2026-04-23; Module 1 gate 1 pinning remains valid for this module"
      role: "primary source for Framework/ directory structure"
      accessed: "2026-04-21 (via Module 1), Framework/Core/README.md re-fetched 2026-04-23 for Module 2"
    - id: AliceO2-Framework-Core-README
      title: "Framework/Core/README.md — Data Processing Layer in O2 Framework"
      url: "https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/README.md"
      size: "485 lines, 27.1 KB"
      document_version: "v0.9 (per footer: 'proposal for approval at the O2 TB - 19th June 2018'); document has been maintained continuously since"
      role: "PRIMARY source for DPL concepts, DataProcessorSpec / WorkflowSpec / AlgorithmSpec definitions, Service catalog, customisation hooks, nomenclature, and folder organization"
      accessed: "2026-04-23"
    - id: O2-Quickstart-FairDPL
      title: "FairMQ and DPL (Newcomers' guide)"
      url: "https://aliceo2group.github.io/quickstart/fair-dpl.html"
      role: "secondary primary source for the FairMQ/DPL/ALFA stack at conceptual level; cited in Module 1 §2.3 and carried forward here"
      accessed: "2026-04-21 (via Module 1)"
    - id: O2-CHEP2023-arXiv
      title: "The O² software framework and GPU usage in ALICE online and offline reconstruction in Run 3 (Eulisse & Rohr, arXiv:2402.01205)"
      url: "https://arxiv.org/abs/2402.01205"
      role: "peer-reviewed reference for in-production DPL usage at scale; the FLP/EPN layout, TF lengths, synchronous/asynchronous scheduling"
      accessed: "2026-04-21 (via Module 1)"
    - id: AliceO2-Doxygen-Published
      title: "AliceO2 Doxygen — o2::framework namespace"
      url: "https://aliceo2group.github.io/AliceO2/"
      role: "primary source for class signatures of o2::framework::* (DataProcessorSpec, InputSpec, OutputSpec, ProcessingContext, ServiceRegistry, etc.) — referenced via [DX] tag for specific classes where relevant"
      accessed: "2026-04-23 (landing confirmed; per-class pages cited where load-bearing)"
    - id: AliceO2-Framework-Core-tree
      title: "Framework/Core/ directory tree"
      url: "https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/Core"
      role: "primary source for Core/ subdirectory layout (include/, src/, test/, etc.)"
      accessed: "2026-04-23"
  introduction_only: []
source_inconsistencies: []
related_jira_tickets: []
indexed_by: Claude8
indexing_model: Claude Opus 4.7
indexed_on: 2026-04-23
source_last_verified: 2026-04-23
source_verification_depth: "Framework/Core/README.md fetched in full (485 lines verbatim); repo structure reuses Module 1's verified SHA; quickstart/fair-dpl.html and arXiv:2402.01205 already established as primary in Module 1; per-class Doxygen pages cited inline where load-bearing."
review_status: CYCLE_0_SELF_REVIEW_PENDING
review_cycle: 0
peer_reviewers_assigned: [Claude1, Claude2, Claude3, Claude4, Claude5, Claude6, Claude7]
peer_reviewers_reported: []
review_assignment_doc: PHASE_0_1_Review_Module_2_FrameworkDPL.md
hard_constraints_checked: {correctness: self-review-pending, reproducibility: self-review-pending, safety: verified}
staleness: fresh
searchable_keywords:
  - DPL
  - Data-Processing-Layer
  - o2-framework
  - DataProcessorSpec
  - WorkflowSpec
  - AlgorithmSpec
  - InputSpec
  - OutputSpec
  - InputRecord
  - DataAllocator
  - ProcessingContext
  - InitContext
  - ErrorContext
  - ServiceRegistry
  - FairMQ
  - fair::mq::Device
  - O2-Data-Model
  - CompletionPolicy
  - ChannelConfigurationPolicy
  - ConfigParamSpec
  - ControlService
  - RawDeviceService
  - Monitoring-service
  - InfoLogger-service
  - CallbackService
  - FairMQRawDeviceService
  - parallel-helper
  - timePipeline
  - workflow-composition
  - defineDataProcessing
  - runDataProcessing
  - adaptFromTask
  - o2::framework::select
  - Framework-Core
  - Framework-Foundation
  - Framework-TestWorkflows
  - Framework-GUISupport
  - Framework-AnalysisSupport
  - Framework-Utils
known_verify_flags:
  - "Framework/Core/README.md document version per footer is v0.9 (O2 TB proposal, 2018-06-19). The file has been maintained since, but the footer has not been updated. Content coverage in this wiki reflects the current (2026-04-23) file, not the 2018 version."
  - "The '1-1 correspondence between DataProcessorSpec and fair::mq::Device' described in Framework/Core/README.md is stated 'in the current implementation'. This may have evolved; not re-verified against source code of Framework/Core/src/."
  - "Service catalog in §6 is complete with respect to what Framework/Core/README.md names explicitly. Additional services may exist in Framework/Core/include/Framework/*.h; a full enumeration is deferred to Module 3 / Module 4 if they become needed."
  - "Doxygen class pages at https://aliceo2group.github.io/AliceO2/ are cited as primary via [DX] tag. Per-class URL anchors are not verified here; reviewers with Aspect D should sample-check."
wiki_sections_stubbed: []
---

# Framework — the O² Data Processing Layer (DPL)

## TL;DR

- **DPL is ALICE's workflow abstraction layer on top of FairMQ.** A user describes a processing topology declaratively as a set of `DataProcessorSpec` objects grouped in a `WorkflowSpec`; DPL maps each `DataProcessorSpec` to a `fair::mq::Device` (1-1 in the current implementation) and handles message routing, completion policies, service injection, and lifecycle management [GH: Framework/Core/README.md §Instanciating a workflow].
- **Why DPL exists.** FairMQ on its own leaves the user responsible for verifying input availability, creating output messages, and documenting data flow. DPL was created to make (1) the data flow explicit up-front, (2) the transport invisible to the user, and (3) processing steps composable [GH: Framework/Core/README.md §Status quo and motivation].
- **Core abstractions in three words.** `DataProcessorSpec` = *what does this step do, what does it consume, what does it produce*. `InputSpec` / `OutputSpec` = *subscriptions and publications* in the (origin, description, subspecification) space of the O² Data Model. `AlgorithmSpec` = *the actual computation* (with optional `onInit` for stateful setup, `onProcess` for the per-record work, `onError` for custom error handling) [GH: Framework/Core/README.md §Describing a computation].
- **Where DPL lives in the repository.** `Framework/Core/` holds the main classes (`DataProcessorSpec`, `WorkflowSpec`, `InputSpec`, `OutputSpec`, `InputRecord`, `DataAllocator`, `ProcessingContext`, `ServiceRegistry`) and the `DataProcessingDevice` / `Driver` implementation. Six sibling directories (`Foundation/`, `Utils/`, `TestWorkflows/`, `GUISupport/`, `AnalysisSupport/`, plus `Core/test/`) cover cross-platform headers, workflow-authoring helpers, example workflows, GUI, analysis-framework support, and unit tests [GH: Framework/Core/README.md §Folder Organization].
- **What DPL is not.** It is not a detector-specific workflow catalogue (that lives in `Detectors/<DET>/workflow/` — wave 2). It is not a specification for reconstruction data formats (that's Module 3). It is not the analysis framework `O2Physics` (separate repository).
- **This MIWikiAI page in one sentence.** An index to `Framework/` covering the core DPL abstractions, the mapping to FairMQ, the customisation points, and pointers to subdirectories — written at a level suitable for readers who have absorbed [Module 1 AliceO2_overview](./AliceO2_overview.md).

## 1. Purpose and scope

### 1.1 What this page indexes

This page covers the **Data Processing Layer (DPL)** — the ALICE-authored workflow framework that lives in the `Framework/` top-level directory of the `AliceO2` repository. DPL is the layer on which every reconstruction, calibration, simulation, and data-quality-control workflow in O² is built.

Concretely this page indexes:

- the six subdirectories under `Framework/` and what each contains;
- the core DPL abstractions — `DataProcessorSpec`, `WorkflowSpec`, `AlgorithmSpec`, `InputSpec`, `OutputSpec`, `InputRecord`, `DataAllocator`, `ProcessingContext`;
- how a workflow expressed in these abstractions maps to a running set of `fair::mq::Device` processes;
- the service catalog (`ControlService`, `Monitoring`, `InfoLogger`, `CallbackService`, and others);
- the customisation points (`CompletionPolicy`, `ChannelConfigurationPolicy`, command-line options);
- and workflow composition via shell-piping.

### 1.2 What this page is not

- **Not a tutorial.** The aliBuild installation, "write your first DPL workflow" path, and runnable examples live in the quickstart and `Framework/TestWorkflows/`; this page points to them, it does not reproduce them.
- **Not a class-by-class reference.** Doxygen at `https://aliceo2group.github.io/AliceO2/` serves that purpose. When a specific class signature is load-bearing, this page cites the Doxygen page via a `[DX]` tag.
- **Not a catalogue of per-detector workflows.** Each detector has its own `workflow/` directory under `Detectors/<DET>/`. That material is indexed in MIWikiAI wave 2.
- **Not a replacement for `Framework/Core/README.md`.** The upstream README is the authoritative narrative. This page re-indexes it for MIWikiAI's AI-reader-first format and cross-links it into the wider wiki.

### 1.3 Dependencies on and from other wiki pages

This page **builds on** [Module 1 AliceO2_overview](./AliceO2_overview.md), specifically:
- §2.3 *Software stack summary* — the FairMQ + DPL + ALFA layering,
- §3.1 *Top-level directory tree* — where `Framework/` sits in the repo.

This page **is built on by**:
- [Module 3 DataFormats_Reconstruction](./DataFormats_Reconstruction.md) — data classes that DPL workflows consume and produce,
- [Module 4 Common_utilities](./Common_utilities.md) — helpers called from within DPL algorithms,
- all wave-2 detector wiki pages — every detector's `workflow/` directory is an application of DPL.

### 1.4 Phase context (MIWikiAI internal)

This is **Module 2 of Phase 0.1** per `PHASE_0_1_Proposal_AliceO2_Framework_Indexation.md` v3. Approved per kickoff note `PHASE_0_1_Module_2_FrameworkDPL_Kickoff.md` (2026-04-23). Reviewer panel: same 7-reviewer configuration as Module 1 with rotated aspect assignments; see `PHASE_0_1_Review_Module_2_FrameworkDPL.md`.

---

## 2. What DPL is and why it exists

*Schema note: this section + §3 together correspond to "§2 Directory layout" in Phase 0.1 proposal v2 §2.2. Per v3 Amendment 3, context-before-directory is permitted when a reader benefits from understanding the subject before seeing the file tree — which is especially true for DPL because the directory names (`Core/`, `Foundation/`, `Utils/`) do not self-explain what DPL is.*

### 2.1 The problem DPL solves

FairMQ by itself is an actor-based message-passing framework: each process is a `fair::mq::Device`; devices listen for messages on channels and run a callback when a message arrives. This is fully general and covers all ALICE use cases, but at a cost — the user ends up responsible for [GH: Framework/Core/README.md §Status quo and motivation]:

1. **Verifying inputs are available.** Not only the per-timeframe detector data, but also asynchronous streams (alignment, calibration constants). The user has to write the "wait until I have everything" logic.
2. **Creating and sending output messages.** Including the envelope format and destination routing.
3. **Documenting and testing the data flow.** Because the flow is buried in an `OnData` callback, there is no way for tooling to inspect *what a device expects* or *what it produces*.

The FairMQ transport layer cannot help with any of this because — by design — it does not know about the O² Data Model. That's a feature, not a bug: keeping the transport agnostic is what allows reuse across experiments. But it means ALICE needed its own layer on top, aware of the O² Data Model, to provide the three things the user shouldn't have to write from scratch.

### 2.2 What DPL adds

DPL is that layer. Its design aims are, verbatim from the upstream README [GH: Framework/Core/README.md §Status quo and motivation]:

- **Explicit data flow.** Inputs and outputs of each computation are declared up-front. The declaration can be used for documentation and for automatic topology creation (if the processing environment is known).
- **Transport-agnostic data processing.** Users do not know — and do not need to know — how the data materialises on their device. DPL hands them the complete set of requested payloads, even when they arrive at different times.
- **Composability.** Individual processing functions can be chained, scheduled together, and merged across workflow boundaries at the level of the implicit topology representation.

To deliver these, DPL requires three things from the user:

1. **Input types declared upfront** — via `InputSpec` objects.
2. **Output types declared upfront** — via `OutputSpec` objects.
3. **A time identifier associable with inputs** — so that "all the inputs for TF N" can be matched.

Given those, DPL guarantees [GH: Framework/Core/README.md §Separating data-processing from transport]:

- When a new input arrives, a `CompletionPolicy` decides whether the associated record is complete. The default policy waits for all declared inputs.
- No message passing happens during the user's processing callback. Output messages are emitted only at the end of the callback, eliminating the "modified after send" class of bugs.

### 2.3 The mapping to FairMQ (one sentence)

A `WorkflowSpec` (a list of `DataProcessorSpec` objects) is compiled by the DPL driver into a topology of `fair::mq::Device` processes, one device per `DataProcessorSpec` in the current implementation [GH: Framework/Core/README.md §Instanciating a workflow]. The driver starts the devices, wires their channels according to each `InputSpec` / `OutputSpec`, optionally starts a GUI, and manages lifecycle.

### 2.4 Historical note

The `Framework/Core/README.md` footer records the document as *"v0.9: proposal for approval at the O2 TB — 19th June 2018"* [GH: Framework/Core/README.md §Document history]. Core concepts have been stable since then; the README has been maintained continuously, though the version line itself is not updated.

---

## 3. Directory layout of `Framework/`

### 3.1 Top-level under `Framework/`

At pinned SHA `87b9775`, branch `dev`, the `Framework/` top-level directory contains the following subdirectories. The column *"What it is"* summarises the content. The column *"Typical user interaction"* answers "when would someone browse this directory?".

| Directory | What it is | Typical user interaction |
|---|---|---|
| `Framework/Core/` | The heart of DPL — `DataProcessorSpec`, `WorkflowSpec`, `AlgorithmSpec`, `InputSpec`, `OutputSpec`, `InputRecord`, `DataAllocator`, `ProcessingContext`, `InitContext`, `ErrorContext`, `ServiceRegistry`, the `DataProcessingDevice` that runs a device, and the `Driver` that compiles a `WorkflowSpec` to a device topology [GH: Framework/Core/README.md §Folder Organization] | every DPL-authoring user sees this via `#include "Framework/*.h"` |
| `Framework/Core/test/` | Unit tests and a few minimal example workflows demonstrating individual DPL features (e.g. `test_Task.cpp` for the task-based API) [GH: Framework/Core/README.md §Task based API] | reference when implementing a new feature or debugging a DPL regression |
| `Framework/TestWorkflows/` | A collection of larger example workflows exercising DPL end-to-end | best starting point for reading a complete `defineDataProcessing` function |
| `Framework/Foundation/` | Header-only utility classes, primarily for cross-platform compatibility (macOS vs Linux, different compiler versions) [GH: Framework/Core/README.md §Folder Organization] | rarely browsed directly; pulled in transitively |
| `Framework/Utils/` | Helpers for workflow creation, including utilities that bridge DPL and non-DPL parts of the O² codebase [GH: Framework/Core/README.md §Folder Organization] | referenced when interfacing a DPL workflow with a pre-existing FairMQ device or an external system |
| `Framework/GUISupport/` | The DPL monitoring GUI — started by the driver when the user is running interactively and has not passed `-b` [GH: Framework/Core/README.md §Folder Organization] | run-time convenience; no user code depends on it |
| `Framework/AnalysisSupport/` | Specific components used by the ALICE analysis framework (which lives in the separate `O2Physics` repository); included here because the analysis layer is layered on top of DPL and shares some infrastructure [GH: Framework/Core/README.md §Folder Organization] | analysis authors; out of scope for reconstruction/calibration work |

### 3.2 What lives inside `Framework/Core/`

Within `Framework/Core/`, the standard O² module layout applies:

- `include/Framework/` — public headers. This is where user-visible classes live: `DataProcessorSpec.h`, `WorkflowSpec.h`, `AlgorithmSpec.h`, `InputSpec.h`, `OutputSpec.h`, `InputRecord.h`, `DataAllocator.h`, `ProcessingContext.h`, `InitContext.h`, `ErrorContext.h`, `ServiceRegistry.h`, `ConfigParamSpec.h`, `CompletionPolicy.h`, `ChannelConfigurationPolicy.h`, and others. Also includes analysis-specific headers like `ASoA.h` (Arrays of Structures of Arrays) and `AnalysisDataModel.h` — these are DPL features used by the analysis framework, not reconstruction.
- `src/` — the corresponding implementations and the `DataProcessingDevice` that runs a device instance.
- `test/` — unit tests; each `test_<Feature>.cpp` exercises one feature and doubles as a minimal working example.

The `include/Framework/Utils/runDataProcessing.h` header is the single include that turns a user-provided `defineDataProcessing` function into a working driver executable — this is the entry point every DPL workflow uses [GH: Framework/Core/README.md §Instanciating a workflow].

### 3.3 Where DPL workflows live in the wider repo

DPL workflow *declarations* (the C++ files that call `defineDataProcessing`) live throughout the repository, not in `Framework/`. The convention is:

- Per-detector workflows: `Detectors/<DET>/workflow/<name>-workflow.cxx` (indexed in wave 2).
- Cross-detector / global tracking workflows: `Detectors/GlobalTrackingWorkflow/`.
- Calibration workflows: `Detectors/<DET>/calibration/testWorkflow/` or a dedicated calibration subdirectory [GH: Detectors/Calibration/README.md].
- Example / reference workflows: `Framework/TestWorkflows/` (this page) and `Framework/Core/test/`.

Production workflow *composition* (which workflows run together on FLPs vs EPNs vs calibration nodes) lives in separate AliceO2Group repositories: [`O2DataProcessing`](https://github.com/AliceO2Group/O2DataProcessing) for production chains and [`ControlWorkflows`](https://github.com/AliceO2Group/ControlWorkflows) for AliECS-driven FLP/QC topology configuration. These are out of scope for Phase 0.1.

---

## 4. Core concepts — declaring a computation

This section unpacks the four classes that every DPL workflow touches: `WorkflowSpec`, `DataProcessorSpec`, `AlgorithmSpec`, and the `ConfigContext`. Their definitions and field semantics are taken verbatim from `Framework/Core/README.md` [GH: Framework/Core/README.md §Describing a computation].

### 4.1 `WorkflowSpec` — the outermost container

A DPL driver executable is a single program whose only required user-provided symbol is a free function of this signature:

```cpp
#include "Framework/Utils/runDataProcessing.h"

WorkflowSpec defineDataProcessing(ConfigContext &context) {
  return WorkflowSpec {
    DataProcessorSpec{ /* ... */ },
    DataProcessorSpec{ /* ... */ }
  };
}
```

When this executable runs, the DPL driver [GH: Framework/Core/README.md §Instanciating a workflow]:

1. maps every `DataProcessorSpec` in the returned `WorkflowSpec` to a `fair::mq::Device` (1-1 in the current implementation);
2. instantiates and starts those devices;
3. optionally starts a monitoring GUI.

The `ConfigContext` passed to `defineDataProcessing` carries user-provided command-line options, so the same executable can produce different topologies (e.g. enable or disable particular detector processors, adjust parallelism factors). To declare which options should be accepted, the user provides a free function [GH: Framework/Core/README.md §Instanciating a workflow]:

```cpp
void customize(std::vector<o2::framework::ConfigParamSpec> &workflowOptions) {
  workflowOptions.push_back(ConfigParamSpec{/* name, type, default, help */});
}
```

### 4.2 `DataProcessorSpec` — one processing step

A `DataProcessorSpec` describes exactly one processing step — what it consumes, what it produces, and how it computes. Its complete signature [GH: Framework/Core/README.md §Describing a computation]:

```cpp
struct DataProcessorSpec {
   using InitCallback = std::function<ProcessCallback(InitContext &)>;
   using ProcessCallback = std::function<void(ProcessingContext &)>;
   using ErrorCallback = std::function<void(ErrorContext &)>;
   std::vector<InputSpec> inputs;
   std::vector<OutputSpec> outputs;
   std::vector<ConfigParamSpec> configParams;
   std::vector<std::string> requiredServices;
   AlgorithmSpec algorithm;
};
```

Field-by-field:

| Field | Purpose |
|---|---|
| `inputs` | Subscriptions in the O² Data Model space — one `InputSpec` per input kind. Drives both message routing and the `CompletionPolicy` decision. Detailed in §5. |
| `outputs` | Publications in the same space — one `OutputSpec` per kind of message the algorithm may produce. The `DataAllocator` will refuse to create messages not declared here. Detailed in §5. |
| `configParams` | Configuration options available at init time. Command-line flags are generated automatically from these. Available only during init (not during processing) because "all the critical parameters for data processing should be part of the data stream itself, eventually coming from CCDB / ParameterManager" [GH: Framework/Core/README.md §Describing a computation]. |
| `requiredServices` | Services the algorithm needs — data cache, GPU context, thread pool, etc. Detailed in §6. |
| `algorithm` | The actual computation — an `AlgorithmSpec`. Separating this from the rest of the spec allows the same input/output signature to be tried with different algorithm implementations, useful for A/B comparisons [GH: Framework/Core/README.md §Describing a computation]. |

### 4.3 `AlgorithmSpec` — the computation itself

```cpp
struct AlgorithmSpec {
  using ProcessCallback = std::function<void(ProcessingContext &)>;
  using InitCallback = std::function<ProcessCallback(InitContext &)>;
  using ErrorCallback = std::function<void(ErrorContext &)>;

  InitCallback onInit = nullptr;
  ProcessCallback onProcess = nullptr;
  ErrorCallback onError = nullptr;
};
```

Three callbacks, all optional in the type but the user must provide at least one of `onInit` or `onProcess`:

- **`onProcess`** runs once per complete input record (i.e. once `CompletionPolicy` says "go"). It receives a `ProcessingContext`, which exposes the current inputs (`InputRecord`), the services (`ServiceRegistry`), and the output allocator (`DataAllocator`) — see §5 and §6. Suitable for *stateless* computation where every record is independent.
- **`onInit`** runs once before the first record and can capture state (e.g. load geometry, open CCDB connections) into the returned `ProcessCallback` via lambda capture. This is the idiom for *stateful* computation [GH: Framework/Core/README.md §Stateful processing]:

  ```cpp
  AlgorithmSpec{
    InitCallBack{[](InitContext &setup){
      auto statefulGeo = std::make_shared<TGeo>();
      return [geo = statefulGeo](ProcessingContext &ctx) {
        // use geo here
      };
    }}
  };
  ```

- **`onError`** is invoked when the `onProcess` callback throws. The default behaviour (no `onError` supplied) is for `DataProcessingDevice` to catch the exception, print a message, and continue; supplying `onError` allows custom error handling, with future support planned for re-injecting data into the flow [GH: Framework/Core/README.md §Error handling].

Throwing a `std::exception`-derived exception uses its `what()` for the log line; other exceptions produce a generic message. For unrecoverable errors, calling `LOG(fatal)` with a description message is the convention — it shuts the application down with a non-zero exit code [GH: Framework/Core/README.md §Error handling].

### 4.4 The task-based API

The three-callback pattern is flexible but verbose for the common case "initialise some state, then run per record". DPL offers a task-based shortcut [GH: Framework/Core/README.md §Task based API]:

```cpp
#include "Framework/Task.h"

class MyTask : public o2::framework::Task {
  void init(InitContext &ic) override { /* ... */ }
  void run(ProcessingContext &pc) override { /* ... */ }
};

// in defineDataProcessing:
DataProcessorSpec{
  /* inputs, outputs, configParams, requiredServices */,
  adaptFromTask<MyTask>(/* constructor args */)
}
```

`adaptFromTask<T>(args...)` returns an `AlgorithmSpec` whose `onInit` constructs a `T`, stores it, and returns a `ProcessCallback` that dispatches to `T::run`. A complete working example is in `Framework/Core/test/test_Task.cpp` [GH: Framework/Core/README.md §Task based API].

**When to use which:** the three-callback form when you need fine control over state construction (e.g. capture differs per process); the task-based form when you would otherwise write a class wrapping `onInit` and `onProcess` by hand (the common case).

---

## 5. Inputs, outputs, and messaging

This section covers how DPL routes data between processors: the `InputSpec` / `OutputSpec` space, the `InputRecord` API for retrieving inputs, and the `DataAllocator` API for producing outputs.

### 5.1 The O² Data Model addressing scheme

Every DPL message carries three properties from the O² Data Model [GH: Framework/Core/README.md §Describing a computation]:

- **origin** — typically a detector tag, e.g. `"TPC"`, `"ITS"`, `"MFT"`, `"GLO"` (for global). 4-character max.
- **description** — what kind of object, e.g. `"CLUSTERS"`, `"TRACKS"`, `"DIGITS"`, `"RAWDATA"`. 16-character max.
- **subspecification** — a 32-bit integer for any further disambiguation (most commonly a sector or link index).

An `InputSpec` is a *three-dimensional selection* on this space: "give me messages whose origin is X, description is Y, subspecification is Z". An `OutputSpec` is a *three-dimensional point* in the same space: "this processor will produce messages at (X, Y, Z)".

Matching a declared `InputSpec` against all declared `OutputSpec` instances in the workflow is how DPL wires the topology.

### 5.2 Declaring inputs — `InputSpec`

Two equivalent forms [GH: Framework/Core/README.md §Describing a computation]:

```cpp
// Verbose form: binding-label + origin + description + subspecification
{InputSpec{"clusters", "TPC", "CLUSTERS", 0}}

// Compact form via the select helper:
select("clusters:TPC/CLUSTERS/0")
```

Both mean "subscribe to messages with origin `TPC`, description `CLUSTERS`, subspecification `0`, and refer to them by the label `clusters` inside the algorithm". The label is what the user passes to `InputRecord::get()` later.

### 5.3 Declaring outputs — `OutputSpec`

Symmetric to `InputSpec` but without a label (outputs don't need to be named for the algorithm — the algorithm knows what it is producing). Same (origin, description, subspecification) triple.

### 5.4 Reading inputs — the `InputRecord` API

Inside `onProcess`, the current record is reached via the `ProcessingContext`:

```cpp
InputRecord &inputs = ctx.inputs();
```

Two access patterns [GH: Framework/Core/README.md §Using inputs]:

- **By label** (preferred): `DataRef ref = inputs.get("clusters");`
- **By positional index**: `DataRef ref = inputs.getByPos(0);`

A `DataRef` exposes `header` and `payload` raw pointers for full control. For common messageable types the templated form does the dispatch:

```cpp
auto p = ctx.inputs().get<T>("points");
```

The return type depends on `T` [GH: Framework/Core/README.md §Using inputs]:

- `T const&` if `T` is a messageable (trivially copyable, non-polymorphic) type — no copy, zero-overhead.
- `T` if `T` is a `std::container` of a ROOT-serializable type — the container is returned by value after deserialisation.
- `smart_pointer<T>` if `T` is a ROOT-serializable non-container type and `T*` is passed as the template argument — the type is deserialised and returned wrapped in a smart pointer.

Examples [GH: Framework/Core/README.md §Using inputs]:

```cpp
XYZ const& p = ctx.inputs().get<XYZ>("points");             // messageable
auto h = ctx.inputs().get<TH1*>("histo"); h->Print();       // ROOT object
auto v = ctx.inputs().get<std::vector<TPoint>>("points");   // container
```

The framework handles deserialisation transparently; the user never calls `TMessage` directly.

### 5.5 Creating outputs — the `DataAllocator` API

The `DataAllocator` is reached from the `ProcessingContext`:

```cpp
auto &outputs = ctx.outputs();
```

Its primary methods [GH: Framework/Core/README.md §Creating outputs]:

- **`make<T>(spec, args...)`** — creates a Framework-owned resource matching a declared `OutputSpec`. Returning `T&` for messageable types, `gsl::span<T>` for collections.
- **`adopt(spec, ptr)`** — takes ownership of an externally-created resource.
- **`snapshot(spec, value)`** — creates a copy of an externally-owned resource; the copy is sent when the process callback returns.

Currently supported types for `make<T>` [GH: Framework/Core/README.md §Creating outputs]:

- Raw `char*` buffers with explicit size (the actual FairMQ message content).
- Messageable types — trivially copyable, non-polymorphic. Zero-copy: the message is the object.
- Collections of messageable types, exposed as `gsl::span`.
- `TObject`-derived classes — serialised via `TMessage`. Only use when the cost is acceptable.

Supported types for `snapshot` [GH: Framework/Core/README.md §Creating outputs]:

- Messageable types.
- ROOT-serialisable classes (auto-detected via `TClass`). Can be forced via the `ROOTSerialized` type converter.
- `std::vector<messageable>` — received as `gsl::span`.
- `std::vector<messageable*>` — linearised into the message, received as `gsl::span`.

### 5.6 The commit-on-return invariant

Created `DataChunk` instances are *not* sent immediately. DPL batches them and emits all outputs together when the `onProcess` callback returns [GH: Framework/Core/README.md §Creating outputs]:

```cpp
struct DataChunk { char *data; size_t size; };
```

This eliminates "modified after send" bugs — the user cannot send a message and then keep writing into the buffer, because the write side stays owner-accessible until the process function returns and transfer happens.

### 5.7 Proxying non-DPL FairMQ devices

When a workflow needs to consume or produce messages from/to a `fair::mq::Device` that pre-dates or by design sits outside DPL, DPL provides a *proxy* `DataProcessorSpec` that connects to the foreign device, optionally translates the message format, and pumps messages into the right place in the DPL topology [GH: Framework/Core/README.md §Integrating with pre-existing devices]. The `FairMQRawDeviceService` exposes the underlying `fair::mq::Device` to an algorithm that needs full manual control. This pattern is how DPL interoperates with `Readout` (FLP-side readout software) and `DataDistribution` (time-frame building and transport).

---

## 6. Services and configuration

Services are the pluggable out-of-band capabilities DPL exposes to algorithms — monitoring, logging, control, and similar cross-cutting concerns. They are initialised by the driver and passed to user code via a `ServiceRegistry` on the `ProcessingContext` [GH: Framework/Core/README.md §Services].

### 6.1 Retrieving a service

```cpp
#include <Monitoring/Monitoring.h>
// ...
auto service = ctx.services().get<Monitoring>();
service.send({ 1, "my/metric" });
```

The service is retrieved by interface type — `Monitoring`, `InfoLogger`, `ControlService`, etc. Each has its own API documented by its origin library.

### 6.2 Service catalog

The services named in `Framework/Core/README.md` [GH: Framework/Core/README.md §Services]:

| Service | Purpose | Header / origin |
|---|---|---|
| **`ControlService`** | Modify the DPL topology's state — most commonly "quit the whole workflow". Typical call: `ctx.services().get<ControlService>().readyToQuit(QuitRequest::All);` | `Framework/ControlService.h` |
| **`RawDeviceService`** | Escape hatch — returns the underlying `fair::mq::Device` so user code can integrate with pre-existing FairMQ behaviour not modelled in DPL | `Framework/RawDeviceService.h` |
| **`Monitoring`** | Integration with the O² monitoring subsystem. Backend depends on deployment: stdout on a laptop, aggregator → InfluxDB/Kafka in production. Metrics support vector and tabular forms via `/n`, `/m`, and `/<i>` suffixes | AliceO2Group/Monitoring |
| **Generic Logger** (`Framework/Logger.h`) | Log macros: streamer `LOG(info) << "msg"`, printf-style `LOGF(info, "%s", "msg")`, python/fmt-style `LOGP(info, "{}", "msg")`, shorthand `O2INFO("{}", "msg")`. Wraps FairLogger | `Framework/Logger.h` |
| **`InfoLogger`** | Integration with the ALICE-wide InfoLogger. Two modes: explicit (`get<InfoLogger>()`) or implicit (plain `LOG` macros routed when `--infologger-severity` is set). `--infologger-mode` controls behaviour. `InfoLoggerContext` can be customised in the init callback to set facility, etc. | AliceO2Group/InfoLogger |
| **`CallbackService`** | Allows processors to register callbacks at specific lifecycle events. Event IDs: `Start` (before running), `Stop` (before exit), `Reset` (before device reset), `ClockTick` (periodic, for non-FairMQ events), `Idle` (nothing to process), `EndOfStream` (upstream has finished — finalise results) | `Framework/CallbackService.h` |

### 6.3 Configuration

DPL distinguishes two layers of configuration [GH: Framework/Core/README.md §Describing a computation]:

- **`ConfigParamSpec` on a `DataProcessorSpec`** — per-processor options available at init time, also exposed as command-line flags. These are for things that change across runs but are fixed within a run (which thread pool, which CCDB URL).
- **`ConfigParamSpec` at the workflow level via `customize(std::vector<ConfigParamSpec> &)`** — options passed to `defineDataProcessing` through the `ConfigContext`. These change the *shape* of the produced `WorkflowSpec` (which detectors are enabled, which proxies are installed).

Design principle stated in the upstream README: critical per-message data — the values the algorithm uses to produce its output — should live in the data stream, not in config. Config is for "how is this process deployed", not "what should this process do with this specific TF". Dynamic per-run values come from CCDB through a standard calibration `DataProcessor` and arrive on the data stream [GH: Framework/Core/README.md §Describing a computation].

---

## 7. Customisation and workflow composition

### 7.1 Customisation hooks

DPL's defaults handle the majority of cases. For the minority, three hooks are available, each provided by a free function `customize(...)` taking a specific argument type [GH: Framework/Core/README.md §Customisation of default behavior]:

- **`CompletionPolicy`** — decides when an incoming record is "complete enough" to run the `onProcess` callback, and what to do with the record afterwards (keep, drop, require more). Default: all declared inputs must be present. Common override: "process as soon as any one input arrives" for monitoring-like tasks.
- **`ChannelConfigurationPolicy`** — overrides how FairMQ channels are constructed (transport, rate-limits, buffer sizes). Default: shared-memory transport via FairMQ `shmem` (the transport used in production per CERN Courier; the O² production setting is by separate policy configuration, not a `Framework/Core/README.md` claim).
- **Command-line options** — append processor or workflow-level options discoverable via `--help`.

All three hooks are discovered by the driver through ADL (argument-dependent lookup) on the free-function `customize`.

### 7.2 Merging workflows — the pipe operator

Multiple DPL executables can be merged by shell-piping [GH: Framework/Core/README.md §Managing multiple workflows]:

```sh
workflow-a | workflow-b
```

The pipe does *not* transfer data — it transfers the `WorkflowSpec` representation. `workflow-a` serialises its spec, `workflow-b` reads it and merges into its own spec, and the rightmost executable in the pipeline starts all devices from the union. This makes it possible to keep workflows modular (one per detector, one for QC, one for calibration) and compose them at run time.

A direct consequence: the merged workflow can have *dangling* inputs and outputs that are satisfied only after merging with another workflow. Each individual `workflow-X` need not be self-contained; the *composition* needs to be.

### 7.3 Expressing parallelism

The O² Data Model allows two kinds of parallelism [GH: Framework/Core/README.md §Expressing parallelism]:

- **Data-flow parallelism.** Partitioning data by some criterion (e.g. one stream per TPC sector → 36-way parallel). Expressed in DPL via the `o2::framework::parallel` helper — replicates a `DataProcessorSpec` across a range of subspecifications.
- **Time-flow parallelism.** Partitioning by time (e.g. different TFs handled by different workers). Expressed via `o2::framework::timePipeline` — pipelines a `DataProcessorSpec` over time.

The shared-memory transport's "single ownership" model is the reason these helpers exist instead of shared-state parallelism: in DPL, parallel workers duplicate streams rather than share references, which keeps failure modes local.

---

## 8. Known limitations and open items

- **DPL is not a tutorial.** This page catalogues concepts and points at source files; a user writing their first workflow should combine this page with `Framework/TestWorkflows/` examples and the quickstart.
- **`Framework/Core/README.md` document version.** The README footer records v0.9 (2018-06-19). Content has been maintained since but the footer has not been updated. Flagged in `known_verify_flags`.
- **1-1 `DataProcessorSpec` ↔ `fair::mq::Device` mapping.** The README calls this "the current implementation", implying the framework does not commit to this as permanent. If future DPL versions multiplex processors onto devices (or vice versa), this page's §2.3 and §4.1 will need an update.
- **Service catalog completeness.** §6 enumerates services explicitly named in `Framework/Core/README.md`. Additional services almost certainly exist in `Framework/Core/include/Framework/*.h` (header scan would enumerate them). A full audit is deferred; flag in `known_verify_flags`.
- **Doxygen per-class anchors.** The `[DX]` tag is used as a category marker; per-class URL anchors at `https://aliceo2group.github.io/AliceO2/` are not verified in this draft. Aspect D reviewer should sample-check 3–5 of them.
- **Customisation defaults.** Specifically, the claim that `shmem` is the production transport is attributed in `AliceO2_overview.md` v0.5 to CERN Courier, not to `Framework/Core/README.md`. This page does *not* repeat that claim as a DPL-internal default — `ChannelConfigurationPolicy` is said only to be where that choice is made.
- **Analysis framework overlap.** `Framework/AnalysisSupport/` and headers like `ASoA.h` and `AnalysisDataModel.h` in `Framework/Core/include/Framework/` belong conceptually to the `O2Physics` analysis framework rather than reconstruction. They appear here because they physically live in this repository, but a reconstruction-focused reader can ignore them. Module 3 and 4 do not cover analysis either.
- **Production workflow composition** (which workflows run on FLP vs EPN vs calibration nodes) lives in separate repositories (`O2DataProcessing`, `ControlWorkflows`) — out of scope for Phase 0.1.
- **Anchor freeze contract.** Per Phase 0.1 v3 §5.3, the `##`-level anchors of this page freeze at gate 2. Downstream modules (3, 4) and wave-2 detector pages will cross-link to them.

---

## 9. Cross-references to MIWikiAI wiki

| Link | Referenced from | Status |
|---|---|---|
| [`./AliceO2_overview.md`](./AliceO2_overview.md) | §1.3, §2, §3.3 (this page builds on Module 1) | **live (APPROVED v0.5, 2026-04-23)** |
| [`./DataFormats_Reconstruction.md`](./DataFormats_Reconstruction.md) | §5.1 (data-model addressing), §5.4 (messageable types) | planned — Module 3 |
| [`./Common_utilities.md`](./Common_utilities.md) | §1.3 | planned — Module 4 |
| [`../../TDR/O2.md`](../../TDR/O2.md) | §2.1 (motivation re-confirms TDR design) | planned — TDR body indexation deferred |
| [`../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md`](../../presentations/O2-6344_materialbudget_ITS_TRD_alignment.md) | contextual — a calibration workflow built on DPL | live (DRAFT, cycle 0) |

---

## 10. External references

### 10.1 AliceO2 repository (primary, [GH])

| Topic | URL |
|---|---|
| `Framework/Core/README.md` (main source) | https://github.com/AliceO2Group/AliceO2/blob/dev/Framework/Core/README.md |
| `Framework/Core/` tree | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/Core |
| `Framework/Core/include/Framework/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/Core/include/Framework |
| `Framework/Core/test/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/Core/test |
| `Framework/TestWorkflows/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/TestWorkflows |
| `Framework/Foundation/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/Foundation |
| `Framework/GUISupport/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/GUISupport |
| `Framework/AnalysisSupport/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/AnalysisSupport |
| `Framework/Utils/` | https://github.com/AliceO2Group/AliceO2/tree/dev/Framework/Utils |

### 10.2 Published documentation (primary, [QS] + [DX])

| Topic | URL |
|---|---|
| AliceO2 Doxygen landing | https://aliceo2group.github.io/AliceO2/ |
| Quickstart — FairMQ and DPL | https://aliceo2group.github.io/quickstart/fair-dpl.html |

### 10.3 Peer-reviewed references ([PP])

| Document | Citation |
|---|---|
| O² software framework + GPU usage | G. Eulisse, D. Rohr, arXiv:2402.01205 (2024). https://arxiv.org/abs/2402.01205 |

### 10.4 Ecosystem repositories (not primary sources for DPL internals, referenced from §3.3)

| Topic | URL |
|---|---|
| AliceO2Group/Monitoring | https://github.com/AliceO2Group/Monitoring |
| AliceO2Group/InfoLogger | https://github.com/AliceO2Group/InfoLogger |
| AliceO2Group/O2DataProcessing | https://github.com/AliceO2Group/O2DataProcessing |
| AliceO2Group/ControlWorkflows | https://github.com/AliceO2Group/ControlWorkflows |
| FairRoot | https://github.com/FairRootGroup/FairRoot |
| FairMQ | https://github.com/FairRootGroup/FairMQ |

### 10.5 Referenced design literature

The `Framework/Core/README.md` itself cites [GH: Framework/Core/README.md §Interesting reads]: *MillWheel: Fault-Tolerant Stream Processing at Internet Scale*, Google Research (pub41378) — cited as prior-art inspiration for the stream-processing model, not as a primary source for DPL.

---

## Appendix A: Structural closure checks

### A.1 `Framework/` subdirectory count

**Claim.** §3.1 lists 7 `Framework/` subdirectories: `Core`, `Core/test`, `TestWorkflows`, `Foundation`, `Utils`, `GUISupport`, `AnalysisSupport`.

**Primary evidence.** `Framework/Core/README.md §Folder Organization` enumerates exactly these (with `Core/test` as a sub-listing).

**Result:** CLOSED ✓ (enumeration is exact; additional cross-cutting CMake files live at `Framework/` level but are not subdirectories).

### A.2 `DataProcessorSpec` field count

**Claim.** §4.2 lists 5 fields: `inputs`, `outputs`, `configParams`, `requiredServices`, `algorithm`.

**Primary evidence.** `Framework/Core/README.md §Describing a computation` definition block.

**Result:** CLOSED ✓.

### A.3 `AlgorithmSpec` callback count

**Claim.** §4.3 lists 3 callbacks: `onInit`, `onProcess`, `onError`.

**Primary evidence.** `Framework/Core/README.md §Describing a computation` definition block.

**Result:** CLOSED ✓.

### A.4 Service catalog count

**Claim.** §6.2 enumerates 6 services by name.

**Primary evidence.** `Framework/Core/README.md §Services` names Control, RawDevice, Monitoring, Logger, InfoLogger, CallbackService. Enumeration exact w.r.t. upstream README.

**Result:** CLOSED with caveat — the README is the enumeration authority; `Framework/Core/include/Framework/*.h` likely contains additional services. See `known_verify_flags`.

### A.5 Customisation hook count

**Claim.** §7.1 lists 3 hooks: `CompletionPolicy`, `ChannelConfigurationPolicy`, command-line options.

**Primary evidence.** `Framework/Core/README.md §Customisation of default behavior`.

**Result:** CLOSED ✓.

### A.6 Commit SHA re-verification

**Claim.** Directory layout pinned to SHA `87b9775` (PR #15202, 2026-03-26), structurally 1:1 with HEAD at 2026-04-23 per Claude5.

**Primary evidence.** Module 1 v0.5 front-matter `commit_evidence` field. No evidence that `Framework/` has gained or lost a subdirectory since.

**Result:** CLOSED ✓ for structural claims. `Framework/Core/README.md` line count (485) and file size (27.1 KB) verified at 2026-04-23 re-fetch.

---

## Appendix B: Notation

### B.1 Primary-source inline-tag grammar

Identical to Module 1 Appendix B.1; see `AliceO2_overview.md` §B.1 [GH]/[DX]/[QS]/[AD]/[TDR]/[PP]/[CC]/[CONFLICT-N].

### B.2 DPL-specific terminology

| Term | Definition |
|---|---|
| **Device** (FairMQ sense) | A `fair::mq::Device` — a single OS process that listens for messages on channels |
| **Device** (DPL sense, runtime) | A running `DataProcessingDevice` — a `fair::mq::Device` subclass provided by DPL; each `DataProcessorSpec` becomes one at runtime |
| **Workflow** | A `WorkflowSpec` — a list of `DataProcessorSpec` objects describing an implicit topology |
| **DataProcessor** | A `DataProcessorSpec` — declaration of one processing step |
| **Algorithm** | An `AlgorithmSpec` — the computation attached to a `DataProcessorSpec` |
| **InputSpec / OutputSpec** | Three-dimensional declarations in the O² Data Model space (origin, description, subspecification) |
| **InputRecord** | Runtime access to the current record's matched inputs, inside `onProcess` |
| **DataAllocator** | Runtime allocator for output messages; refuses outputs not declared in `OutputSpec`s |
| **ProcessingContext** | The bundle passed to `onProcess`: `inputs()`, `outputs()`, `services()`, others |
| **InitContext** | The bundle passed to `onInit`: `services()`, `options()`, others |
| **ErrorContext** | The bundle passed to `onError`: exception info, inputs at failure time |
| **ServiceRegistry** | Runtime catalog of services keyed by interface type; reached via `ctx.services()` |
| **DataRef** | Raw-pointer `{header, payload}` view of a message, returned by `InputRecord::get()` |
| **Spec / Info / Context** suffixes | Nomenclature convention — `Spec` = declaration, `Info` = runtime information about an entity, `Context` = state of a lifecycle phase [GH: Framework/Core/README.md §Nomenclature] |

### B.3 DPL ↔ FairMQ glossary

| DPL side | FairMQ side |
|---|---|
| `DataProcessorSpec` | compiled to one `fair::mq::Device` |
| `InputSpec` | incoming FairMQ channel (with subscription filter) |
| `OutputSpec` | outgoing FairMQ channel |
| `ServiceRegistry` | per-device service instances held by `DataProcessingDevice` |
| `DataProcessingDevice` | subclass of `fair::mq::Device` provided by DPL |
| `FairMQRawDeviceService` | the escape hatch from DPL back to raw FairMQ |

---

## Changelog

- **v0.1 — 2026-04-23 — initial draft.** Indexed `Framework/Core/README.md` (485 lines) as the primary source. Body contents: TL;DR, purpose and scope, motivation + goals, directory layout (7 Framework/ subdirs), core concepts (WorkflowSpec / DataProcessorSpec / AlgorithmSpec / ConfigContext), inputs/outputs/messaging (O² Data Model addressing, InputSpec, OutputSpec, InputRecord, DataAllocator, proxies), services and configuration (6 named services + ConfigParamSpec layers), customisation + composition (CompletionPolicy, ChannelConfigurationPolicy, `|` operator, parallelism helpers), known limitations (8 items), cross-refs, external refs. Schema variation applied: §2 context section before §3 directory layout (per Phase 0.1 v3 Amendment 3). Reuses Module 1 pinned SHA `87b9775` — Framework/Core/README.md content verified at 2026-04-23. No `source_inconsistencies` in this draft (sources concur).

---

*Indexed by Claude8 on 2026-04-23. Team MIWikiAI. v0.1 pending cycle-0 self-review, then cycle-1 panel per `PHASE_0_1_Review_Module_2_FrameworkDPL.md`.*

*Quota: no session-block / quota-loss signals observed.*
