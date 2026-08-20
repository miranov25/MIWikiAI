---
doc_id: AnalyticalPDFHEP
doc_type: initial-cross-team-proposal
version: v0.1
date: 2026-08-20
status: SELECTED STARTING CANDIDATE — prepared for initial cross-team review
author_reviewer_id: GPT5:AO2D
author_group_id: AO2DAI
composite_author_identity: AO2DAI::GPT5:AO2D
proposed_drafting_owner: AO2DAI
proposed_review_teams:
  - samplingAI
  - timeAI
immediate_consumer: AO2DAI PHASE_0_2 Stage D
not_a_final_consensus_document: true
selection_status: selected unanimously by six cross-team reviewers as the strongest of three independent AO2DAI starting proposals
revision_note: future PID/occupancy/multiplicity trigger families clarified as multidimensional composite triggers retaining pT dependence
---

# AnalyticalPDFHEP — Initial Proposal v0.1

## Analytical PDFs, deterministic downsampling, trigger composition, and exact reweighting for HEP analysis

**Author:** `GPT5:AO2D / AO2DAI`  
**Status:** selected starting candidate for initial cross-team review; not yet a consensus/frozen document  
**Proposed drafting team:** AO2DAI  
**Requested reviewers:** samplingAI, timeAI

---

# 0. Executive proposal

The primary goal is not downsampling for its own sake.

The goal is to make very large ALICE analysis samples usable for **interactive multidimensional physics analysis** while retaining a quantitatively correct connection to the original sample.

The intended data volumes span several orders of magnitude in the physics coordinates of interest. Charged-particle and V0 spectra fall strongly with transverse momentum, while V0/cascade decay-radius populations fall strongly with radius. Uniform random reduction therefore spends most retained statistics in already-dense regions and gives poor coverage of rare regions.

This proposal defines a reusable analytical-PDF sampling contract:

```text
physics-shape model
        ↓
target sampling density
        ↓
exact implemented inclusion probability
        ↓
deterministic trigger decision
        ↓
trigger mask + per-trigger probabilities/weights
        ↓
combined inclusion probability
        ↓
analysis weight
        ↓
weighted closure against an unbiased reference
```

The first two analytical models are:

1. **mass- and sqrt(s)-dependent Tsallis/Hagedorn pT spectrum**, based on the existing ALICE O2 implementation and its AliPhysics predecessor;
2. **relativistically boosted exponential decay-radius model**, conditional on pT, mass, and proper lifetime.

Later revisions can add multidimensional PID, occupancy and multiplicity trigger models, plus efficiency/acceptance models. These later trigger families are expected to retain the steep pT dependence and add one or more additional discriminating coordinates rather than becoming unrelated standalone 1D samplers.

The first AO2DAI implementation should remain narrow:

```text
MB/reference trigger
+
1D analytical pT / inverse-pT trigger

then

2D inverse-pT × decay-radius trigger
```

The persisted output contract should support later triggers from the beginning.

---

# 1. Cross-team responsibility

## 1.1 AO2DAI

AO2DAI should draft the first common document and implement the first consumer.

AO2DAI responsibilities:

- define immediate V0/cascade use cases;
- connect AO2D/ADF quantities to analytical PDFs;
- implement Stage-D integration;
- preserve AO2D relations during reduction;
- store trigger/probability/weight provenance;
- perform real-file MB/reference versus weighted-sample closure.

## 1.2 samplingAI

samplingAI should review:

- inclusion-probability definitions;
- deterministic sampling;
- trigger composition;
- inverse-probability weights;
- overlap semantics;
- statistical closure;
- variance/effective-sample-size diagnostics;
- farm/chunk/order invariance.

## 1.3 timeAI

timeAI should review:

- proper-time exponential semantics;
- Lorentz-boost transformation to decay length/radius;
- lifetime/mass parameterization;
- future time/occupancy-dependent analytical PDFs;
- physics use in multidimensional resolution studies.

---

# 2. Central terminology

Four quantities must remain distinct.

For trigger `i` and object coordinates `x`:

## 2.1 Physics PDF / shape

```text
f_i(x; theta)
```

A model of the underlying population or a shape proportional to it. It need not be normalized if only ratios are used.

## 2.2 Target sampling density

```text
g_i(x)
```

The shape desired for the retained sample, e.g. flat in `pT`, flat in `u=1/pT`, or flat in `(u,R)`.

## 2.3 Inclusion probability

```text
pi_i(x) = P(trigger i accepts | x)
```

This is the actual probability implemented by the sampler and must satisfy `0 <= pi_i <= 1`, including all clipping/saturation.

## 2.4 Analysis weight

For a single trigger:

```text
w_i(x) = 1 / pi_i(x)
```

For an OR of triggers, the final analysis weight comes from the **combined** inclusion probability.

### Binding principle

The historical O2/AliPhysics quantity called `weight` is a normalized spectrum factor. It must **not** automatically be interpreted as the final inverse-inclusion AO2DAI analysis weight.

---

# 3. Source lineage: ALICE Tsallis/Hagedorn implementation

## 3.1 Pinned AliceO2 reference for this initial proposal

```text
repository: AliceO2Group/AliceO2
commit: e4d1882bf5fdcc9d821593b867313e67a56fc629
files:
  Common/MathUtils/src/Tsallis.cxx
  Common/MathUtils/include/MathUtils/Tsallis.h
```

At this commit O2 defines:

```text
a = 6.81
b = 59.24
c = 0.082
d = 0.151

mT = sqrt(m^2 + pT^2)
n(sqrt(s)) = a + b/sqrt(s)
T(sqrt(s)) = c + d/sqrt(s)
p0 = n*T
```

and

\[
F_{p_T}(p_T;m,\sqrt{s})
=
p_T\left(1+\frac{m_T}{nT}\right)^{-n}.
\]

The O2 header describes the associated downsampler as a **flat q/pT trigger**.

## 3.2 Historical AliPhysics reference

The O2 header points to:

```text
repository: alisw/AliPhysics
commit: 523f2dc8b45d913e9b7fda9b27e746819cbe5b09
files:
  PWGPP/AliAnalysisTaskFilteredTree.h
  PWGPP/AliAnalysisTaskFilteredTree.cxx
```

The historical implementation exposes:

```text
bit 0  flat pT trigger
bit 1  flat q/pT trigger
bit 2  MB/reference trigger
```

and the historical V0 trigger extends the mask with gamma-candidate variants.

The historical source explicitly motivates low-pT downscaling to obtain approximately flat spectra for tracks and V0s for tracking-resolution, V0, dE/dx and related studies.

## 3.3 AliRoot lineage

A separate AliRoot implementation has **not yet been source-verified** in this proposal. Do not claim AliRoot provenance until Git/source evidence is found.

## 3.4 Literature

The O2 implementation cites:

```text
Kapil Saraswat, Prashant Shukla, Venktesh Singh
Transverse momentum spectra of hadrons in high energy pp and heavy ion collisions
J. Phys. Commun. 2 (2018) 035003
arXiv:1706.04860
DOI: 10.1088/2399-6528/aab00f
```

---

# 4. Model A — Tsallis/Hagedorn pT sampling

## 4.1 Spectrum model

Use the pinned O2 function:

\[
F_{p_T}(p_T;m,\sqrt{s})
=
p_T\left(1+\frac{\sqrt{m^2+p_T^2}}{n(\sqrt{s})T(\sqrt{s})}\right)^{-n(\sqrt{s})}.
\]

Initial AO2DAI units:

```text
sqrt(sNN): GeV
mass: GeV/c^2
pT: GeV/c
```

## 4.2 Normalized model score

Define a reference momentum, initially compatible with O2:

```text
pT_ref = 1 GeV/c
```

and

\[
S(p_T)=\frac{F_{p_T}(p_T)}{F_{p_T}(p_{T,\mathrm{ref}})}.
\]

`S` is a model score, not an analysis weight.

## 4.3 Historical flat-pT trigger

The AliPhysics acceptance corresponds to:

\[
\pi_{\mathrm{flat}\ p_T}(p_T)
=\min\left(1,\frac{C_{p_T}}{S(p_T)}\right).
\]

For an exact model this approximately produces constant retained density in `pT`.

## 4.4 Historical/current flat-q/pT / flat-1/pT trigger

For a neutral candidate use:

\[
u=1/p_T.
\]

For a charged track the signed coordinate may be `q/pT`.

Since

\[
\left|\frac{du}{dp_T}\right|=1/p_T^2,
\]

a sample flat in `u` has target density in pT proportional to `1/pT^2`.

The historical/current O2 rule corresponds to:

\[
\pi_{1/p_T}(p_T)
=\min\left(1,\frac{C_{1/p_T}}{S(p_T)p_T^2}\right).
\]

This is the immediate preferred analytical trigger for the AO2DAI V0/track use case.

## 4.5 Domain

The `1/pT` transform is singular at zero. Every production trigger must declare:

```text
pT_min > 0
pT_max
outside_domain_policy
```

No hidden epsilon is allowed.

---

# 5. Model B — relativistically boosted decay-radius PDF

## 5.1 Proper decay time

For proper lifetime `tau`:

\[
f_t(t)=\frac1\tau e^{-t/\tau},\qquad t\ge0.
\]

## 5.2 Lab flight length

With momentum `p` and mass `m`:

\[
\beta\gamma=p/m,
\qquad
\lambda_L=(p/m)c\tau.
\]

## 5.3 Transverse decay radius

Projecting the flight length into the transverse plane:

\[
R=L\frac{p_T}{p},
\]

therefore

\[
\lambda_R(p_T,m,\tau)=\frac{p_T}{m}c\tau.
\]

The ideal conditional radius density is:

\[
f_R(R\mid p_T,m,\tau)=\frac1{\lambda_R}e^{-R/\lambda_R},\qquad R\ge0.
\]

This is explicitly **conditional on pT**. The 2D model must not treat pT and radius as independent PDFs.

## 5.4 First approximation versus observed data

Initial Stage-D approximation:

```text
efficiency(R,pT,eta,...) = 1
```

inside a declared domain.

A later extension may use:

\[
f_{\rm obs}\propto f_R\,\epsilon(R,p_T,\eta,\ldots).
\]

Efficiency correction is not required for the first Stage-D prototype.

## 5.5 Radius definition

For each particle family declare:

```text
production vertex
decay vertex
transverse-radius definition
mass hypothesis
lifetime source
```

V0 and cascade sequential-decay geometry must not be conflated silently.

---

# 6. Model C — 2D inverse-pT × radius trigger

## 6.1 Desired target

For the V0/cascade resolution study, first approximation:

\[
u=1/p_T,
\qquad g(u,R)=\mathrm{const}.
\]

In `(pT,R)` coordinates:

\[
g(p_T,R)\propto1/p_T^2.
\]

## 6.2 Physical joint model

\[
f(p_T,R)=F_{p_T}(p_T)f_R(R\mid p_T,m,\tau).
\]

This is a conditional joint model, not two independent 1D PDFs.

## 6.3 Inclusion rule

For budget constant `C_2D`:

\[
\pi_{2D}(p_T,R)
=\min\left[1,C_{2D}\frac{g(p_T,R)}{f(p_T,R)}\right].
\]

Up to normalization absorbed in `C_2D`:

\[
\pi_{2D}\propto
\frac{\lambda_R(p_T)}{F_{p_T}(p_T)p_T^2}
 e^{R/\lambda_R(p_T)}.
\]

This makes the pT-radius coupling explicit.

## 6.4 Numerical implementation

Production code should use log-space scores where useful and explicitly handle:

```text
pT -> 0
lambda_R -> 0
large R/lambda_R
probability saturation at 1
configured pT/R domain boundaries
```

No NaN/Inf may silently become an acceptance decision.

---

# 7. Trigger model

## 7.1 Initial and future trigger families

The first Stage-D mask remains intentionally simple:

```text
trigger family                 nominal dimensionality   status
MB_REFERENCE                   0D / constant            NOW
PT_ANALYTICAL / INVPT_FLAT     1D pT or 1/pT            NOW
PT_RADIUS_2D                   2D pT × radius           NEXT

future:
TRACK_PID_MD                   >=2D pT × PID response(s)              LATER
TRACK_OCCUPANCY_MD             >=2D pT × occupancy [× event vars]     LATER
TRACK_PID_OCCUPANCY_MD         >=3D pT × PID × occupancy [× ...]      LATER
PT_MULTIPLICITY_MD             >=2D pT × multiplicity [× event vars]  LATER
```

The exact future bit allocation is **not frozen in this v0.1 candidate**. The joint proposal should freeze stable trigger IDs only when the trigger semantics are sufficiently defined.

The important architectural requirement is already frozen:

> **Future PID, occupancy and multiplicity triggers are multidimensional/composite triggers. They augment pT downsampling; they do not replace it with unrelated 1D selections.**

A future track trigger therefore has the generic form

\[
\pi_{\mathrm{track}}
=
P(\mathrm{accept}\mid
p_T,\mathrm{PID},\mathrm{occupancy},\mathrm{multiplicity},\ldots),
\]

with only the required subset of coordinates enabled for a particular trigger version.

## 7.2 MB_REFERENCE semantics

Here `MB_REFERENCE` means a **kinematics-independent random reference branch for the declared sampling unit**. It must not automatically be confused with a detector/online minimum-bias trigger class.

## 7.3 Future multidimensional PID / occupancy triggers

For tracks, PID-based downsampling will normally combine the steep pT dependence with one or more detector-response coordinates, for example

\[
\pi_{\mathrm{PID}}
=
P(\mathrm{accept}\mid
p_T,
n\sigma_{\mathrm{TPC}},
n\sigma_{\mathrm{TOF}},
\ldots),
\]

or an equivalent conditional/semi-analytical formulation.

Similarly, an occupancy-aware trigger will normally combine occupancy with at least pT and may later include multiplicity, time or event-class coordinates:

\[
\pi_{\mathrm{occ}}
=
P(\mathrm{accept}\mid
p_T,
\mathrm{occupancy},
\mathrm{multiplicity},
\mathrm{time/event\ class},
\ldots).
\]

A combined track trigger may therefore be three-dimensional or higher:

\[
\pi_{\mathrm{PID+occ}}
=
P(\mathrm{accept}\mid
p_T,\mathrm{PID},\mathrm{occupancy},\ldots).
\]

The historical AliPhysics filtered-tree code already contains dedicated PID masks; the new system should reuse the conceptual trigger-mask architecture, not necessarily the historical hard-coded PID cuts.

## 7.4 No unvalidated factorization assumption

The joint framework must **not** silently assume

\[
f(p_T,\mathrm{PID},\mathrm{occupancy})
=
f_{p_T}(p_T)\,
f_{\mathrm{PID}}(\mathrm{PID})\,
f_{\mathrm{occ}}(\mathrm{occupancy})
\]

unless that approximation is validated for the intended trigger.

Conditional or semi-analytical forms are allowed and are likely more appropriate, for example

\[
f(p_T,\mathrm{PID},\mathrm{occupancy})
=
f_{p_T}(p_T)\,
f_{\mathrm{PID}}(\mathrm{PID}\mid p_T,\mathrm{occupancy})\,
f_{\mathrm{occ}}(\mathrm{occupancy}\mid p_T,\mathrm{event\ class}).
\]

The exact forms are deferred, but the trigger/probability/storage architecture must support multidimensional PDFs from the beginning.

Diagnostic sub-bits may later record that a TPC-PID, TOF-PID or occupancy criterion contributed to an acceptance decision. Such diagnostic bits must not obscure the actual multidimensional inclusion probability used for analysis.

---

# 8. Deterministic trigger decision

Production sampling must be reproducible across:

```text
row order
chunk size
worker count
farm-job boundaries
repeated execution
```

For each sampling unit and trigger derive an independent deterministic uniform variate `U_i in [0,1)` conceptually from:

```text
sampler_schema_version
seed
source_file_identity
partition_identity
structure/table identity
original row/object identity
trigger_id
```

The exact hash/byte encoding belongs in the sampling implementation profile but must be standardized and tested.

## 8.1 Independent trigger streams

If the simple OR formula below is used, each trigger must use a separate deterministic stream/domain separator. Reusing one uniform number for multiple triggers invalidates the independence formula.

---

# 9. Multiple triggers and overlap

For conditionally independent trigger decisions with probabilities `pi_i`:

\[
\pi_{OR}=1-\prod_i(1-\pi_i).
\]

The final inclusive analysis weight is:

\[
w_{OR}=1/\pi_{OR}.
\]

If future triggers are intentionally correlated, their joint inclusion probability must be defined explicitly; the product formula may not be used.

---

# 10. Required persisted sampling information

## 10.1 Object-level fields

At minimum:

```text
sampling_trigger_mask
sampling_probability_combined
sampling_weight_combined
```

For each active trigger retain either explicit per-trigger probability/weight fields or an equivalently explicit representation.

Because the requested user contract includes trigger weights, this proposal prefers storing both:

```text
sampling_probability_<trigger>
sampling_weight_<trigger>
```

## 10.2 Model diagnostics

Optional fields may include:

```text
pdf_score_<trigger>
target_score_<trigger>
```

These must not be called simply `weight`.

The historical O2 `tsallisWeight` is a normalized spectrum score, not the final inverse-inclusion analysis weight.

## 10.3 Dataset/configuration provenance

Store at least:

```text
sampler schema/version
trigger definitions
seed/hash algorithm
sqrt(sNN)
mass/effective-mass hypothesis
proper lifetime / c*tau
pT and radius domains
normalization/downsampling factors
analytical-PDF source identities
source AO2D identity
```

---

# 11. Model quality versus analysis unbiasedness

The analytical model is used to choose the sampling probability.

If the **actual implemented inclusion probability** `pi(x)` is known and stored, the inverse-probability estimator

\[
\hat N=\sum_{kept}1/\pi(x)
\]

is unbiased for the original finite population under the sampling design.

Therefore:

- a rough Tsallis model can still give unbiased weighted closure;
- model mismatch changes flattening quality and variance;
- it does not by itself bias the inverse-probability correction;
- an incorrectly recorded probability **does** bias reweighting.

Analytical parameters are deterministic configuration inputs, so there is no finite-statistics fit-estimator error if they are fixed. The sampling realization still has statistical variance, and parameter variations may be treated as systematic studies if needed.

---

# 12. Relation-aware sampling

AnalyticalPDFHEP defines primary-object inclusion probability.

AO2DAI must additionally preserve the relational unit:

```text
sample primary object
        ↓
retain required dependencies
        ↓
remap indices consistently
```

Dependency rows are not assigned independent physics sampling weights merely because they were retained to preserve the primary object.

---

# 13. Validation contract

## 13.1 Tsallis source/formula equivalence

- compare Python/model output to the pinned O2 implementation across `pT`, mass, and sqrt(s);
- verify the flat-1/pT acceptance rule against the same deterministic uniform input;
- preserve historical flat-pT/MB equivalence tests if those modes are implemented.

## 13.2 Probability sanity

Require:

```text
0 <= pi <= 1
finite pi
finite weight when pi > 0
pi=1 => weight=1
```

## 13.3 Determinism

Retained object identities must be invariant under row permutation, chunk size, file batching, worker count, and repeat execution.

## 13.4 Empirical inclusion

Measured trigger frequency over controlled independent identities should agree with configured `pi(x)` within statistical expectation.

## 13.5 MB/reference closure

Compare:

```text
full/unbiased reference
vs
MB_REFERENCE
vs
analytical trigger × inverse-probability weight
```

for sampling variables and orthogonal observables.

## 13.6 1D closure

- retained distribution approximately follows the target coordinate;
- weighted pT reproduces the original;
- weighted orthogonal distributions reproduce the reference.

## 13.7 2D closure

For `(1/pT,R)`:

- inspect 2D occupancy;
- verify weighted 2D closure;
- verify pT and R projections;
- verify conditional slices;
- verify mass/resolution observables are unchanged within expected sampling uncertainty.

## 13.8 Trigger-overlap closure

With MB + pT (+ later radius/PID):

- verify realized mask;
- verify per-trigger probabilities;
- verify combined OR probability;
- verify `1/pi_OR` closure;
- explicitly test multiply-triggered rows.

## 13.9 Expected statistical variance

For independent Bernoulli inclusion, a count estimator has

\[
Var(\hat N)=\sum_j\frac{1-\pi_j}{\pi_j}.
\]

This should be used for principled pull/closure tests. samplingAI should review the final statistic.

## 13.10 Relation integrity

AO2DAI must prove after reduction:

```text
no dangling positive references
correct old->new remapping
positional-family consistency
partition identity preserved
dependency closure preserved
```

---

# 14. Effective sample size and diagnostics

Report at least:

```text
kept fraction
weight min/median/max
weight quantiles
sum(w)
sum(w^2)
effective sample size
```

with

\[
N_{eff}=\frac{(\sum w)^2}{\sum w^2}.
\]

A constant MB/reference trigger provides a probability floor when OR-combined with analytical triggers and can bound extreme combined weights.

---

# 15. Future analytical/semi-analytical PDFs

Not required for the first Stage-D implementation.

The entries below are **model ingredients**, not declarations that the corresponding production trigger will be one-dimensional. For track sampling, the expected production trigger will normally combine these ingredients with pT and possibly with each other.

## 15.1 Multiplicity

Candidate marginal/conditional family:

```text
Negative Binomial / Gamma-Poisson
```

possibly centrality-conditioned.

The later production trigger is expected to be at least two-dimensional, e.g.

\[
\pi_{\mathrm{mult}}
=
P(\mathrm{accept}\mid p_T,\mathrm{multiplicity},\ldots).
\]

## 15.2 Occupancy

Keep initially empirical/semi-analytical. Candidate ingredients after data inspection:

```text
log-normal
Gamma
NBD-like/compound
conditional occupancy given multiplicity/time/event class
```

The corresponding trigger is expected to retain pT dependence:

\[
\pi_{\mathrm{occ}}
=
P(\mathrm{accept}\mid p_T,\mathrm{occupancy},\ldots).
\]

A combined PID+occupancy trigger may use both dimensions simultaneously.

## 15.3 PID

Potential model ingredients:

```text
TPC Bethe-Bloch mean
TPC residual / n-sigma resolution
TOF time/residual response
Gaussian or mixture residual models
rare-tail trigger models
```

The intended production use is multidimensional, for example:

\[
\pi_{\mathrm{PID}}
=
P(\mathrm{accept}\mid
p_T,n\sigma_{\mathrm{TPC}},n\sigma_{\mathrm{TOF}},\ldots).
\]

PID and occupancy models may later be combined into a single >=3D trigger if that provides a more efficient retained phase-space coverage.

## 15.4 Other future models

Potentially useful later:

```text
vertex-z / beam-profile
rapidity / eta acceptance
DCA / resolution tails
proper-time directly
```

---

# 16. Immediate AO2DAI Stage-D profile

## D1 — MB/reference

Constant inclusion probability:

\[
\pi_{MB}=C_{MB}.
\]

Store trigger bit, probability, and weight.

## D2 — 1D analytical inverse-pT

Use the pinned Tsallis score and historical/current flat-1/pT rule.

Store:

```text
trigger bit
Tsallis model score
pi_pt
weight_pt
```

## D3 — combined output

For independent MB and pT streams:

```text
pi_OR = 1 - (1-pi_MB)(1-pi_pt)
weight_OR = 1/pi_OR
```

## D4 — 2D pT × radius

Add after D1/D2 closure if required by the physics deadline. Use the conditional boosted radius PDF, not a naively independent product.

## D5 — farm execution

The same deterministic object must receive the same decision whether processed alone, in 1–10-file jobs, on different workers, or merged in a different order.

---

# 17. Explicit decisions for the joint proposal

## Q1 — first pT target

Support only flat `1/pT` / `q/pT`, or preserve both historical flat-pT and flat-1/pT modes?

This proposal prefers flat `1/pT` as the immediate AO2DAI trigger.

## Q2 — V0 mass parameter

For a mixed K0Short/Lambda sample, choose among:

- one effective V0 mass;
- hypothesis-specific triggers;
- OR of multiple mass-hypothesis triggers;
- another conservative approximation.

Historical AliPhysics used an effective V0 mass approximately corresponding to Lambda.

## Q3 — sqrt(s)

The API must state whether the configuration is `sqrt(s)` or `sqrt(sNN)` and its units.

## Q4 — radius definition

For V0/cascade specify production vertex, decay vertex, radius, and which stage of a sequential cascade decay is modeled.

## Q5 — exact 2D target

Exactly uniform in `(1/pT,R)` inside a hard domain, or only approximately flattened by bounded orders of magnitude to improve effective sample size?

## Q6 — MB/reference fraction

What reference fraction gives useful independent closure and a useful probability floor within the storage budget?

## Q7 — trigger independence

Should separate hash streams be mandatory for all OR-composed triggers? This proposal says **yes** unless a joint probability is explicitly modeled.

## Q8 — stored columns

Store both `pi_i` and `1/pi_i` for each trigger, or only `pi_i` plus combined weight? Current architect requirement favors storing trigger weights too.

## Q9 — parameter/systematic variants

How should alternative Tsallis/lifetime/efficiency parameter sets be represented?

## Q10 — AliRoot provenance

Can the older AliRoot implementation and cited references be recovered and pinned? Do not block Stage D on this historical task.

## Q11 — future multidimensional track-trigger factorization

For future PID/occupancy/multiplicity sampling, which coordinates should be represented jointly and which conditional/semi-analytical factorization is acceptable?

The architecture requirement is already clear:

```text
future trigger dimensionality >= 2
pT remains an explicit coordinate
PID / occupancy / multiplicity add discriminating dimensions
```

The exact factorization and trigger versions are intentionally deferred until real distributions and sampling efficiency are reviewed.

---

# 18. Acceptance criteria for a future shared version

A joint `AnalyticalPDFHEP` document is ready to freeze when it defines:

- [ ] immutable reference Tsallis source identity;
- [ ] historical AliPhysics lineage;
- [ ] PDF / target / inclusion probability / weight distinction;
- [ ] pT and inverse-pT trigger formulas;
- [ ] boosted conditional radius PDF;
- [ ] non-factorized 2D pT-radius model;
- [ ] trigger-bit semantics;
- [ ] deterministic object/trigger-stream contract;
- [ ] trigger-overlap formula;
- [ ] persisted probability/weight contract;
- [ ] relation-aware sampling-unit rule;
- [ ] configuration/source provenance;
- [ ] MB/reference closure;
- [ ] weighted statistical closure;
- [ ] farm/chunk/order determinism tests;
- [ ] effective-sample-size diagnostics;
- [ ] AO2DAI implementation profile;
- [ ] deferred multidimensional PID/occupancy/multiplicity extension points that retain pT dependence and do not assume unvalidated factorization;
- [ ] ownership/versioning rules.

---

# 19. Recommended synthesis process

Use this as the **selected starting candidate for initial cross-team review**, not as the final consensus:

```text
independent AO2DAI proposals
        +
samplingAI proposal/review
        +
timeAI proposal/review
        ↓
joint AnalyticalPDFHEP proposal
        ↓
focused cross-team approval
        ↓
AO2DAI Stage-D implementation
```

The Stage-D prototype does not need to wait for every future PDF family.

The minimum shared contract needed now is:

```text
Tsallis pT model
deterministic inclusion probability
MB + pT trigger composition
exact inverse-probability weight
boosted radius model
2D extension semantics
closure tests
```

---

# 20. Revision note for initial review

This selected review candidate preserves the original GPT5:AO2D statistical architecture and incorporates one bounded architect clarification identified after comparison of the three independent proposals:

- the immediate `MB_REFERENCE`, 1D pT and 2D pT×radius roadmap is unchanged;
- future PID, occupancy and multiplicity trigger families are explicitly **multidimensional/composite**;
- future track triggers retain pT as a coordinate and add PID/occupancy/multiplicity information;
- no independent-product factorization is assumed without validation;
- future trigger dimensionality is therefore **at least 2D**, and may be 3D or higher;
- exact future bit allocation and analytical/semi-analytical factorization remain review decisions.

No other architecture or probability/weight semantics were changed.

---

# 21. Initial proposal conclusion

The problem is sufficiently defined to proceed.

The unresolved items in §17 are normal cross-team design decisions, not evidence that the goal is unclear.

**Proposed direction: APPROVE FOR JOINT SYNTHESIS.**

**Author:** `GPT5:AO2D / AO2DAI`  
**Date:** 2026-08-20
