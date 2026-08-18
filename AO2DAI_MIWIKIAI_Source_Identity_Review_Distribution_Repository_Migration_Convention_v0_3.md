# MIWikiAI Common Source Identity, Review Distribution, and Repository Migration Convention — Proposal v0.3

**Status:** PROPOSED — bounded governance/provenance revision after accepted v0.2 architecture review  
**Date:** 2026-08-18  
**Canonical owner / maintainer:** MIWikiAI  
**Ratification authority:** Architect  
**Project profiles represented:** AO2DAI / dfextension / other consuming projects  
**Scope:** external Git source provenance; local project review/distribution; source-semantic review identity; DIRTY review snapshots; transitional/migrating subprojects; repository migration provenance  
**Supersedes:** `AO2DAI_MIWIKIAI_External_Source_and_Review_Reference_Proposal_v0_2.md`  
**Review basis:** `AO2DAI_MIWIKIAI_SourceIdentity_Proposal_v0_2_Official_Consolidated_Review_Summary_AO2DAI_GPT4_AO2D_20260818.md`  
**Purpose:** Make code/source reviews reproducible for humans and AI reviewers without requiring full clones/builds of large external software stacks, while preserving exact reviewed-byte identity, immutable Git provenance, bounded change evidence, and migration history.

> **v0.3 scope:** This revision preserves the accepted three-profile v0.2 architecture. It incorporates the consolidated C1–C5 reproducibility/governance corrections. It is not an AO2DAI Stage-B redesign.

---

# 1. Motivation

AO2DAI and related projects use several different kinds of source.

They should not all be forced into one review/distribution mechanism.

The three source profiles are:

```text
A. Stable external authoritative repositories
   e.g. AliceO2, O2Physics

B. Local actively developed projects
   e.g. AO2DAI

C. Transitional / migrating subprojects
   e.g. dfextension currently developed inside O2DPG,
        but expected to move to its own repository later
```

The goals are:

1. reviewers can identify the exact bytes they reviewed;
2. reviewers can identify the Git/source provenance of those bytes;
3. reviewers can see a bounded change from an approved reference;
4. external source facts are tied to immutable Git identities when those identities are known;
5. pre-existing snapshots with unknown upstream provenance are represented honestly rather than assigned an invented commit;
6. AI reviewers can inspect exact source without cloning/building hundreds of GB of software;
7. a later repository migration does not invalidate historical reviews;
8. ZIP files remain convenient review/distribution artifacts without becoming a second VCS;
9. reviewer identity and Source-Read evidence are auditable across teams;
10. project teams retain semantic/implementation authority while MIWikiAI owns the common provenance schema.

---

# 2. The three source profiles

## 2.1 Profile A — stable external Git authority

Use for sources such as:

```text
AliceO2
O2Physics
```

For a commit-identified source, the normative source identity is:

```text
repository URL
+
full 40-character Git commit SHA
+
path
```

Record when useful:

```text
human-readable tag/release
```

but a tag/release does not replace the commit SHA.

A mutable branch such as:

```text
master
main
dev
```

is orientation only and must not be the official source identity of a formal review.

When an older source snapshot exists but its upstream commit is not yet known, use the pin-state model in §5. Do not silently assign the snapshot to a convenient current commit.

---

## 2.2 Profile B — local active project review

Use for AO2DAI and similar actively developed local projects.

Primary review interface:

```text
complete current source ZIP
+
canonical source/payload manifest
+
git diff to the approved reference
+
reviewer/test evidence ZIP
```

Typical packet:

```text
CRR.md
sources_ao2dai_<identity>.zip
source_manifest_<timestamp>.yaml
reviewer_<timestamp>.zip
```

This gives reviewers:

```text
full current source
+
exact delivered-byte identity
+
bounded change set
+
execution/reviewer evidence
```

without requiring them to reconstruct the source tree from diffs.

For a committed CLEAN state, the Git commit remains the authoritative source identity.

For a DIRTY pre-commit state, the exact reviewed-byte identity is the retained source snapshot + canonical payload manifest, while the base Git commit remains provenance/reference identity. See §3.2.

---

## 2.3 Profile C — transitional / migrating subproject

Use when a project currently lives inside a larger repository but is expected to move later.

Current example:

```text
dfextension
current repository: O2DPG
future repository: not yet decided / not yet migrated
```

Migration expectation does **not** demote existing Git history.

While the project remains in the host repository, record:

```text
current host repository
current path/subtree
current full commit SHA
current approved reference tag/commit when applicable
source ZIP SHA-256
source/payload manifest SHA-256
diff baseline
```

The review interface may remain:

```text
complete source ZIP
+
Git diff
+
review/test evidence
```

but the current host repository/path/commit remains the provenance authority for committed history.

Do **not** describe the current host repository as the permanent future repository if migration is already expected.

---

# 3. Core identity and authority principles

## 3.1 P1 — exact reviewed-byte identity must always be recoverable

Every official review must answer:

```text
What exact bytes did this reviewer read?
```

Depending on state/profile:

### Stable external source at a known commit

```text
repository + full commit SHA + path
+
per-file SHA-256 when delivered through a bundle
```

### Local CLEAN committed project

```text
repository/path + current full commit SHA
+
source ZIP SHA-256
+
source/payload manifest SHA-256
+
approved reference tag/commit
```

### Local DIRTY pre-commit project

```text
base HEAD full SHA
+
Tree state = DIRTY
+
retained source snapshot ZIP SHA-256
+
canonical source/payload manifest SHA-256
+
staged/unstaged diff
+
untracked/deleted-file inventory
```

### Transitional project

```text
current host repository + subtree/path + full commit SHA
+
review snapshot ZIP SHA-256
+
source/payload manifest SHA-256
+
diff/reference identity
```

---

## 3.2 P2 — authority hierarchy for CLEAN, DIRTY, and final accepted states

### CLEAN / committed state

```text
authoritative source identity
    = repository + relevant path/subtree + full commit SHA

delivered review-artifact identity
    = source ZIP SHA-256 + source/payload manifest identity

change identity
    = approved reference commit/tag → current commit
```

Git is authoritative for the committed source.

The ZIP is a delivered review artifact derived from that state.

### DIRTY / pre-commit review

A DIRTY working tree contains bytes that do not exist in the base Git commit.

Therefore:

```text
Git provenance/reference
    = base HEAD full SHA

exact reviewed-byte identity
    = retained source snapshot ZIP
      + canonical source/payload manifest

change evidence
    = staged diff
      + unstaged diff
      + untracked-file inventory
      + deleted-file inventory
```

A DIRTY snapshot filename must **not** imply that the snapshot contents equal `base HEAD`.

For example, this is valid:

```text
UNCOMMITTED REVIEW SNAPSHOT
base HEAD = <40-char SHA>
Tree state = DIRTY
source ZIP SHA-256 = <sha256>
source manifest SHA-256 = <sha256>
```

but the base SHA is provenance, not the byte identity of the dirty snapshot.

The exact DIRTY source ZIP and manifest must be retained as raw review inputs.

### Final accepted checkpoint

```text
Tree state = CLEAN
accepted full commit SHA = <40-char SHA>
source ZIP regenerated from accepted committed state
manifest regenerated/verified from accepted committed state
```

The accepted committed state becomes the normative authority.

---

## 3.3 P3 — Git remains authoritative where committed Git history exists

ZIP files are review/distribution artifacts.

They are not a competing source-control system.

For a committed project state:

```text
Git commit/tag
    ↓
complete source ZIP generated from accepted source bytes
    ↓
canonical source/payload manifest
    ↓
reviewer evidence generated from those bytes
```

For Profile C, the same rule applies while the project remains in the current host repository.

Expected future migration is not a reason to treat existing Git history as secondary.

---

## 3.4 P4 — local reviews receive the complete current review source

A bounded diff is not sufficient as the only source artifact once a project has multiple stages/commits.

A Profile-B review should receive the complete review source even when the evidence packet also contains:

```text
diff_to_reference
diff_last_commit
diff_to_phase
```

The complete source answers:

> What exact code exists in the reviewed snapshot?

The diff answers:

> What changed from the approved baseline?

### Definition of “complete current source ZIP”

The project-specific Profile-B rule must define its include/exclude policy.

At minimum, the source manifest must state whether the archive includes:

```text
tracked source/configuration files
tracked tests
tracked documentation required by the implementation
untracked files intentionally included in the review
generated source required for the reviewed state
submodule/vendor identities when applicable
```

and must explicitly exclude or inventory as appropriate:

```text
.git metadata
build products
compiler caches
temporary files
large data not required to reconstruct source state
external installations
```

Excluded review-relevant files must not be hidden by an archive-generation convention.

---

## 3.5 P5 — approved reference tags are immutable review checkpoints

Examples:

```text
PHASE_0_2_AO2D_STAGE_A_APPROVED
PHASE_0_2_AO2D_STAGE_B_APPROVED
PHASE_0_2_AO2D_END
```

An official review records both:

```text
reference_tag
reference_full_commit_SHA
```

Once used in an official review, the tag must not be silently retargeted.

A mutable convenience alias may exist locally but must never be the only identity recorded in a review.

When useful, the review runner should mechanically verify that:

```text
git rev-parse <reference_tag>
==
recorded reference_full_commit_SHA
```

---

# 4. Machine-readable external-source manifest

Maintain a version-controlled project instance:

```text
external_sources.yaml
```

## 4.1 Schema ownership versus instance ownership

```text
external_sources.yaml schema + semantics
    OWNER: MIWikiAI

AO2DAI external_sources.yaml instance/content
    OWNER: AO2DAI

other project instances
    OWNER: corresponding consuming project
```

MIWikiAI defines what the fields mean.

MIWikiAI does **not** choose every consuming project's source baseline.

The consuming project owns the correctness of its project-specific repository/path/pin entries, with Architect ratification where the baseline is an architecture decision.

---

## 4.2 Minimum manifest schema

Example:

```yaml
schema_version: 2

sources:
  AliceO2:
    profile: stable_external
    repository: https://github.com/AliceO2Group/AliceO2

    # recovered | new_baseline | snapshot_only
    pin_status: <state>

    # recovered_provenance | architect_selected_new_baseline | unknown
    pin_origin: <origin>

    reference_commit: <40-character SHA or null>
    producer_provenance_commit: <40-character SHA or null>
    tag: <release-or-null>
    role: framework_and_standard_ao2d_authority

    required_files:
      - path: Framework/Core/include/Framework/ASoA.h
        sha256: <sha256-or-PENDING>
      - path: Framework/Core/src/ASoA.cxx
        sha256: <sha256-or-PENDING>
      - path: Framework/Core/include/Framework/AnalysisDataModel.h
        sha256: <sha256-or-PENDING>

    snapshot:
      bundle_sha256: <sha256-or-null>
      retrieved_at: <timestamp-or-null>
      verified_at: <timestamp-or-null>

  O2Physics:
    profile: stable_external
    repository: https://github.com/AliceO2Group/O2Physics
    pin_status: <state>
    pin_origin: <origin>
    reference_commit: <40-character SHA or null>
    producer_provenance_commit: <40-character SHA or null>
    tag: <release-or-null>
    role: pwg_and_derived_ao2d_authority

    required_files:
      - path: PWGLF/DataModel/LFStrangenessTables.h
        sha256: <sha256-or-PENDING>
      - path: PWGLF/DataModel/LFStrangenessPIDTables.h
        sha256: <sha256-or-PENDING>
      - path: <relevant producer source or explicit unresolved marker>
        sha256: <sha256-or-PENDING>

  dfextension:
    profile: transitional_subproject
    repository: <current O2DPG repository URL>
    path: <current dfextension subtree>
    current_commit: <current full O2DPG SHA>
    reference_commit: <approved reference full SHA or null>
    permanent_repository: PENDING
    review_distribution: zip_plus_git_diff
```

The exact project manifest is allowed to add project-specific fields, but it must preserve the common meanings above.

---

## 4.3 Manifest identity in every formal source-semantic review

Every formal source-semantic review that relies on `external_sources.yaml` must record:

```text
external_sources_manifest_sha256 = <sha256>
schema_version = <version>
```

This prevents a review from silently resolving its source against a later-edited manifest.

---

## 4.4 Per-file byte binding

Every `required_file` used to certify a source claim must have either:

1. a file SHA-256 in the manifest; or
2. an equivalent per-file entry in the verified external-source bundle manifest.

For commit-addressed Method A/B acquisition, the Git commit remains authoritative.

The file hash proves which bytes the reviewer actually received/read.

---

# 5. Pin-state model and pre-existing snapshots

The project already has cases where source bytes are known but the exact upstream commit may be unknown.

The convention must represent that state honestly.

## 5.1 Pin states

Allowed common states:

```text
pin_status:
  recovered
  new_baseline
  snapshot_only

pin_origin:
  recovered_provenance
  architect_selected_new_baseline
  unknown
```

### `recovered`

Use when the exact snapshot bytes have been traced to an upstream repository/commit.

```text
snapshot bytes
==
bytes at recorded repository + commit + path
```

### `new_baseline`

Use when the exact historical provenance was not recovered, and the Architect/project deliberately selects a different immutable commit as the new reference baseline.

This is a **new baseline decision**.

It must not be described as merely fixing “line drift”.

### `snapshot_only`

Use when exact source bytes are available and fingerprinted but their upstream commit is not known.

The snapshot may remain valid historical evidence.

It must not be given an invented Git identity.

---

## 5.2 Pin-adoption procedure

For a pre-existing snapshot:

1. retain and hash the original snapshot;
2. attempt provenance recovery;
3. if exact provenance is recovered, record `recovered`;
4. if not recovered, keep `snapshot_only` unless/until a new reference baseline is explicitly selected;
5. if the Architect selects another commit, record `new_baseline`;
6. preserve both the old snapshot identity and the new baseline identity;
7. regenerate commit-qualified line references only for the source identity to which they actually apply.

---

## 5.3 Reference source versus producer/data provenance

When both matter, record them separately:

```text
reference_commit
producer_provenance_commit
```

A current coding/reference baseline is not automatically the historical producer commit of an older AO2D or other data artifact.

---

# 6. Valid source acquisition for AI/human reviewers

A source-semantic reviewer does not need a full external installation.

Allowed acquisition methods:

## Method A — direct source at the pinned commit

Read exact source by:

```text
repository + full commit SHA + path
```

For GitHub-hosted source, a commit-qualified raw/source URL is acceptable.

---

## Method B — sparse / partial Git checkout

Retrieve only the required source directories/files at the recorded commit.

The review must still record the full commit SHA and paths read.

---

## Method C — verified external-source bundle

Generate:

```text
external_sources_<manifest-hash>.zip
```

containing the required files plus a machine-readable bundle manifest:

```text
repository
full commit SHA, when known
path
file SHA-256
external_sources.yaml SHA-256
retrieved_at / verified_at
```

For stable external repositories:

```text
Method A/B
    preferred when available

Method C
    derived evidence
```

A Method-C bundle is commit-equivalent evidence only when its repository/commit/path/file hashes are mechanically verifiable against upstream.

If the bundle cannot be located at a known upstream commit, it remains `snapshot_only`.

---

## 6.1 Text-only derived review bundles

A reviewer seat without archive/shell access may receive a text-only derived REVIEW_BUNDLE if:

- the canonical source/review artifact identity is recorded;
- the source/bundle manifest identity is recorded;
- no omitted binary/archive content is required for the claims assigned to that reviewer;
- the review explicitly states that it used a derived bundle.

A derived text bundle must never silently become the authoritative source artifact.

---

# 7. Reviewer identity and Source-Read declaration

## 7.1 Composite reviewer identity

A bare reviewer ID is not globally sufficient.

Every official review records at least:

```yaml
reviewer_id: <reviewerID>
group_id: <groupID>
review_role: <role>
```

The pair:

```text
reviewerID + groupID
```

is the minimum reviewer identity.

A rendered composite identity may use:

```text
<groupID>::<reviewerID>
```

provided the separate fields remain available.

---

## 7.2 Structured Source-Read declaration

Every official review carries a Source-Read declaration.

Minimum schema:

```yaml
source_read:
  review_type: source_semantic | compiled_runtime | both | documentation_only

  acquisition_method:
    direct_git | sparse_checkout | verified_bundle | derived_review_bundle | other_declared

  external_sources_manifest_sha256: <sha256-or-N/A>

  sources:
    - repository: <URL-or-N/A>
      commit: <40-character SHA or null>
      pin_status: recovered | new_baseline | snapshot_only | N/A
      paths_read:
        - <path>
      file_or_bundle_hashes:
        - <sha256 or manifest reference>

  runtime_evidence:
    build_performed: true | false
    tests_performed: [...]
```

For a documentation-only governance review where external source is genuinely not needed:

```text
review_type: documentation_only
```

must be stated explicitly.

A reviewer who has not read the required source must not certify source semantics.

---

## 7.3 Source-semantic versus compiled/runtime review

Review assignments must distinguish:

```text
SOURCE-SEMANTIC REVIEW
    inspect exact source bytes

COMPILED/RUNTIME VALIDATION
    build/run only when the reviewed claim requires execution
```

Reading source does not automatically require:

```text
full AliceO2 checkout
full O2Physics checkout
full O2 build
full O2Physics build
hundreds of GB of installation
```

Conversely, source inspection must not be represented as runtime validation when the claim requires compilation or execution.

---

## 7.4 Commit-qualified source citations

Formal source citations must identify the immutable source identity to which their path/line range applies.

Conceptual minimum:

```text
repository
full revision/commit
path
line/range when used
```

A compact normalized source-location string may be rendered as:

```text
<repository>@<40-char-commit>:<path>:Lx-Ly
```

or an equivalent MIWikiAI-governed representation.

Line citations must not silently re-resolve after a source pin changes.

If the evidence is `snapshot_only`, cite the snapshot SHA-256 instead of inventing a commit-qualified location.

---

# 8. Canonical source/payload manifest for local review ZIPs

Local CLEAN and DIRTY review ZIPs should carry a canonical payload manifest.

Example:

```yaml
schema_version: 1

archive:
  sha256: <zip-sha256>
  generated_at: <timestamp>

git:
  repository: <URL/path>
  base_head: <40-char SHA>
  tree_state: CLEAN | DIRTY
  current_commit: <40-char SHA or null>

files:
  - path: <relative path>
    sha256: <sha256>
    status: tracked | modified | added | untracked | generated_review_source

deleted_files:
  - <path>

excluded:
  - path_or_pattern: <pattern>
    reason: <reason>
```

For a DIRTY review, the manifest plus archive is the canonical reviewed-byte snapshot.

If deterministic ZIP generation is not guaranteed, the payload manifest remains the canonical content inventory while the ZIP SHA-256 identifies the delivered container.

The exact DIRTY archive must be retained as a raw review input.

---

# 9. AO2DAI Profile-B local review packet

AO2DAI owns this project-specific profile under the common MIWikiAI provenance convention.

Recommended implementation packet:

```text
CRR.md

sources_ao2dai_<identity>.zip
source_manifest_<timestamp>.yaml

reviewer_<timestamp>.zip
    SUMMARY_<timestamp>.txt
    git_status_<timestamp>.txt
    git_log_<timestamp>.txt
    reference_<timestamp>.txt
    external_sources_identity_<timestamp>.txt
    diff_to_reference_<timestamp>.txt
    diff_last_commit_<timestamp>.txt
    test_full_<timestamp>.log
    test_realdata_<timestamp>.log
    pilot_inventory_<timestamp>.txt
```

`reference_<timestamp>.txt` records:

```text
reference tag
reference full commit SHA
current full commit SHA, if CLEAN/committed
base HEAD full SHA, if DIRTY
Tree state
```

`external_sources_identity_<timestamp>.txt` records:

```text
external_sources.yaml SHA-256
schema version
```

Final checkpoint requirement:

```text
Tree state: CLEAN
accepted full commit SHA recorded
source ZIP regenerated from accepted committed state
```

AO2DAI may extend this packet with phase-specific evidence.

MIWikiAI owns the common identity semantics, not the AO2DAI test/pilot contents.

---

# 10. dfextension transitional review profile

## 10.1 Current state

dfextension began as a relatively small development inside O2DPG.

It has grown substantially and may later move to an independent repository.

Until that architectural/repository decision is made:

```text
do not force a premature repository migration
do not treat O2DPG as necessarily permanent
do not lose the existing Git provenance
```

---

## 10.2 Current dfextension review convention

Use:

```text
sources_dfextension_<reference-or-identity>.zip
+
source/payload manifest
+
git diff to the selected dfextension reference
+
reviewer/test evidence
```

Also record:

```text
current O2DPG repository
current dfextension subtree/path
current O2DPG full commit SHA
selected reference full commit/tag
```

This gives reviewers a compact self-contained source tree while preserving the host-repository Git provenance.

---

## 10.3 Review authority during the transitional period

For a committed dfextension review:

```text
authoritative source provenance
    = O2DPG repository + subtree/path + full commit SHA

reviewed delivered-byte identity
    = source ZIP SHA-256 + payload manifest SHA-256

change identity
    = Git diff from selected reference commit/tag
```

For a DIRTY transitional review, apply §3.2:

```text
base HEAD
+
retained DIRTY source snapshot
+
payload manifest
+
complete change inventory
```

All identities must be recorded.

---

# 11. Repository migration rule

A dfextension repository migration is an explicit architecture/provenance event.

It must **not** be performed silently as ordinary code refactoring.

Before migration:

```text
project-team approval
+
Architect approval
```

is required because the decision affects:

- ownership;
- release process;
- provenance;
- issue/PR location;
- downstream references;
- review baselines.

MIWikiAI owns the migration-record schema, not the technical decision to migrate.

---

## 11.1 Preferred migration model

Preferred:

> Create a new dfextension repository by extracting/preserving the relevant Git history, leave O2DPG intact, and record an explicit migration boundary.

Avoid if possible:

```text
rename O2DPG and delete unrelated code
```

because this misrepresents the history/ownership of the rest of O2DPG.

Also avoid:

```text
copy only the current dfextension files into a fresh repository
```

when doing so discards useful history and provenance.

---

## 11.2 Migration record

When migration occurs, add a durable record such as:

```yaml
migration:
  schema_version: 1
  project: dfextension
  migration_date: <date>

  old:
    repository: <O2DPG URL>
    path: <old subtree>
    last_authoritative_commit: <full SHA>
    last_reference_tag: <tag or null>
    subtree_tree_or_manifest_sha256: <hash-or-null>

  new:
    repository: <new repository URL>
    first_authoritative_commit: <full SHA>
    first_reference_tag: <tag or null>
    subtree_tree_or_manifest_sha256: <hash-or-null>

  history_preserved: true
  migration_method: <filter-repo/subtree/history-preserving method>
  migration_tool: <tool>
  migration_tool_version: <version>

  commit_mapping:
    artifact: <old-to-new-map file or null>
    sha256: <sha256-or-null>
```

If history extraction rewrites commit IDs, the old→new mapping artifact is strongly recommended.

Historical reviews continue to cite the old repository/path/commit.

New reviews cite the new repository/commit.

The migration record bridges the histories without rewriting historical provenance.

---

## 11.3 Old repository after migration

O2DPG should remain intact unless its maintainers decide otherwise.

At the old dfextension location, add a migration notice when appropriate:

```text
This component moved to <new repository>.
Historical source through <old commit> remains here.
```

Do not rewrite historical review artifacts to point to the new repository.

Historical provenance remains historical.

---

# 12. Ownership and responsibility model

## 12.1 Canonical common convention

```text
Canonical common convention document
    OWNER / MAINTAINER: MIWikiAI

Common source-profile vocabulary
    OWNER: MIWikiAI

external_sources.yaml schema
    OWNER: MIWikiAI

Source-Read/reviewer-identity schema
    OWNER: MIWikiAI

migration provenance schema
    OWNER: MIWikiAI
```

---

## 12.2 Architect role

```text
Cross-project Architect Decision
    RATIFICATION AUTHORITY: Architect

Recovered-provenance vs new-baseline choice
    ARCHITECT INPUT/RATIFICATION when architecturally relevant

Repository migration
    ARCHITECT APPROVAL required
```

The candidate Architect Decision in §15 remains **PROPOSED** until entered/ratified in the correct Architect Decision registry.

Reviewer or drafter prose must not be rewritten as an Architect quote unless the Architect actually ratifies that wording.

---

## 12.3 AO2DAI role

AO2DAI owns:

```text
Profile-B implementation
AO2DAI review-packet generation
AO2DAI reference tags/checkpoints
AO2DAI test/reviewer evidence
AO2DAI pilot/data identity
AO2DAI external_sources.yaml instance
project-specific AliceO2/O2Physics pin selection/proposal
```

AO2DAI operates under the MIWikiAI common provenance schema.

MIWikiAI does not become AO2DAI's semantic owner.

---

## 12.4 Profile-C project role

The relevant project team owns:

```text
project-specific review implementation
migration implementation
technical repository layout
release/issue/PR consequences
```

under:

```text
MIWikiAI provenance schema
+
Architect migration approval
```

---

# 13. Tag versus commit versus ZIP versus snapshot

The concepts remain distinct.

## Stable external Git source

```text
tag/release = optional human-readable identity
commit SHA  = normative Git source identity
path        = source object identity
file hash   = delivered/read byte verification
```

## Local CLEAN implementation review

```text
reference tag/commit = approved baseline
current commit       = authoritative reviewed source state
source ZIP           = complete delivered reviewer source
ZIP SHA-256          = delivered-container identity
payload manifest     = delivered-content identity
diff                 = bounded change evidence
```

## Local DIRTY implementation review

```text
base HEAD            = Git provenance/reference
DIRTY source ZIP     = exact reviewed snapshot container
payload manifest     = exact reviewed snapshot content
status/diffs         = change evidence
```

## Transitional subproject

```text
host repo/path/commit = current Git provenance
source ZIP/manifest   = reviewer byte identity
diff/reference        = change identity
migration record      = old→new provenance bridge
```

After migration, the new repository/commit becomes the current Git authority while the old provenance remains recorded.

---

# 14. AO2DAI Stage-B entry requirement

This convention should be ratified before Stage B performs normal semantic relation promotion from AliceO2/O2Physics source.

Stage B must use immutable source identities to establish:

```text
relation target
relation kind
producer/source closure
wrong-target semantic protection
table/view identity
```

The source identity must not be only:

```text
current master
current dev
whatever happened to be installed locally
```

Minimum Stage-B prerequisites:

```text
1. Architect ratifies this common convention / Architect Decision.
2. MIWikiAI freezes the v0.3 common schema.
3. AO2DAI records the approved Stage-A reference tag + full commit.
4. AO2DAI creates its external_sources.yaml instance.
5. AO2DAI records the external_sources.yaml SHA-256.
6. AliceO2 reference source has:
      full 40-character SHA
      pin_status = recovered | new_baseline
7. O2Physics reference source has:
      full 40-character SHA
      pin_status = recovered | new_baseline
8. Required source files/hashes are available through Method A/B or a verified Method-C bundle.
```

`snapshot_only` evidence may remain valid historical evidence, but it is not sufficient as the sole identity for new Stage-B source-semantic promotion that requires an immutable external Git baseline.

This is a bounded source/governance gate, not another PHASE_0_2 redesign.

---

# 15. Candidate common Architect Decision

Use the next unused Architect Decision identifier.

## AD-0XX — Source identity, review distribution, Source-Read, and repository migration

**State:** PROPOSED  
**Origin:** AO2DAI / MIWikiAI  
**Canonical convention owner:** MIWikiAI  
**Ratification authority:** Architect

### Candidate decision text

The project distinguishes three source profiles:

```text
stable external Git authority
local active project
transitional/migrating subproject
```

For stable external Git sources with known provenance:

```text
repository + full commit SHA + path
```

is normative.

Tags/releases are optional human-readable identities.

For a local CLEAN implementation review:

```text
authoritative current Git commit
+
complete current source ZIP
+
canonical payload/source manifest
+
diff to an approved immutable reference tag/commit
+
reviewer/test evidence
```

is the standard review packet.

For a local DIRTY pre-commit review:

```text
base HEAD
+
retained DIRTY source snapshot ZIP
+
canonical payload/source manifest
+
complete staged/unstaged/untracked/deleted change evidence
```

defines the reviewed state. The base HEAD is provenance, not the identity of the dirty bytes. Final accepted checkpoints are committed and CLEAN.

For transitional/migrating subprojects such as dfextension, current host repository/path/full commit remains the current Git provenance authority while ZIP + manifest + diff provide the review interface.

A later repository migration must preserve or explicitly map historical provenance and record the old repository/path/commit → new repository/commit boundary.

Pre-existing source snapshots whose exact upstream commit is unknown remain `snapshot_only`. Selecting a different commit as the project reference is an explicit `new_baseline` decision, not a silent provenance recovery.

Every official review records reviewer ID + group ID and an explicit Source-Read declaration.

A full external software checkout/build is not required for source-semantic review unless the reviewed claim requires executable validation.

> This is candidate wording only until the Architect ratifies it and assigns the final AD identifier.

---

# 16. Acceptance checklist with owners

Before the common convention is active:

- [ ] **Architect:** ratify the common source/review convention and assign the Architect Decision identifier.
- [ ] **MIWikiAI:** freeze/approve the common provenance, Source-Read, manifest, citation, and migration schemas.
- [ ] **MIWikiAI:** publish the canonical v0.3 document identity/fingerprint.
- [ ] **AO2DAI:** record the approved Stage-A reference tag + full commit.
- [ ] **AO2DAI:** create the AO2DAI `external_sources.yaml` instance.
- [ ] **AO2DAI:** record the exact `external_sources.yaml` SHA-256 in the Stage-B review/reference packet.
- [ ] **AO2DAI + Architect as applicable:** determine AliceO2 `pin_status` / baseline and record the full SHA.
- [ ] **AO2DAI + Architect as applicable:** determine O2Physics `pin_status` / baseline and record the full SHA.
- [ ] **AO2DAI:** resolve `<relevant producer source>` placeholders to concrete required files or an explicit unresolved closure state.
- [ ] **AO2DAI:** ensure required source files have per-file SHA-256 or equivalent verified-bundle evidence.
- [ ] **AO2DAI:** reviewer runner records reference tag + resolved commit + manifest identity.
- [ ] **AO2DAI:** official source ZIPs carry/ship with a canonical payload/source manifest.
- [ ] **AO2DAI:** retain exact DIRTY source snapshots used as official raw review inputs.
- [ ] **AO2DAI:** final checkpoint packets come from CLEAN committed trees.
- [ ] **dfextension/project owner:** mark dfextension `transitional_subproject`, not permanent O2DPG ownership.
- [ ] **Architect + project owner:** approve any future dfextension repository migration.
- [ ] **MIWikiAI + project owner:** migration record preserves old→new provenance, including content/tree identity and commit mapping when applicable.
- [ ] **All official reviewers:** record `reviewer_id`, `group_id`, role, review type, acquisition method, source identities, paths read, and hashes/evidence appropriate to the review.

---

# 17. Recommended activation sequence

**Adopt this convention before AO2DAI Stage-B semantic relation promotion.**

Do not delay Stage B for a large documentation cycle.

Required bounded process:

```text
1. MIWikiAI issues this v0.3 bounded revision.
2. Architect ratifies the common decision / AD.
3. MIWikiAI performs one focused provenance/governance check.
4. AO2DAI performs one focused Profile-B implementation/reference check.
5. AO2DAI creates and fingerprints its external_sources.yaml instance.
6. AO2DAI records the approved Stage-A reference tag + commit.
7. AliceO2 full SHA / pin_status is resolved or selected.
8. O2Physics full SHA / pin_status is resolved or selected.
9. Stage B may begin normal source-semantic promotion.
```

No new broad architecture panel is required if this v0.3 faithfully closes the bounded review findings.

For dfextension, no immediate repository migration is required.

This convention defines how to review it correctly now and how to preserve provenance if/when the Architect/project later decides to migrate it.

---

# 18. v0.3 revision summary

Compared with v0.2, this revision:

- preserves the accepted three-profile architecture;
- makes the CLEAN / DIRTY / final-accepted authority hierarchy explicit;
- clarifies that Profile-C existing Git history remains authoritative provenance until migration;
- defines a canonical source/payload manifest for local review ZIPs;
- requires per-file hashes or equivalent verified-bundle evidence for source claims;
- requires every formal source-semantic review to record the exact `external_sources.yaml` SHA-256 it used;
- makes `reviewer_id + group_id` the minimum official reviewer identity;
- adds a structured Source-Read declaration;
- requires immutable source identity in line/range citations;
- adds the `recovered | new_baseline | snapshot_only` pin-state model;
- distinguishes `reference_commit` from `producer_provenance_commit`;
- states that adopting a new source baseline is not the same as recovering historical provenance;
- distinguishes MIWikiAI schema ownership from consuming-project manifest-instance ownership;
- makes MIWikiAI the canonical common-convention owner and the Architect the ratification authority;
- keeps AO2DAI as owner of its Profile-B implementation, review packet, manifest instance, checkpoints and source-baseline proposal;
- strengthens verified Method-C bundles with manifest/file-hash binding;
- requires retention of exact DIRTY review snapshots;
- adds migration tool/version, content identity and optional old→new commit mapping;
- adds owner-labelled activation checklist items;
- retains historical reviews unchanged after repository migration;
- keeps Stage-B gating bounded and explicitly avoids reopening PHASE_0_2 architecture.

# End of Proposal v0.3
