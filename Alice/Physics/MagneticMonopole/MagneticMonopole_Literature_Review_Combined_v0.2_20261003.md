# Magnetic Monopoles for ALICE — Combined Core Literature Review

**Document:** `MagneticMonopole_Literature_Review_Combined_v0.2`
**Status:** REVISED CANDIDATE FOR NARROW CONFIRMATION / MIWikiAI HANDOFF
**Date:** 2026-10-03
**Prepared by:** GPT1:MonopoleAI, synthesis editor
**Parent:** `MagneticMonopole_Literature_Review_Combined_v0.1_20261003.md`
**Authoritative review contract:** `MagneticMonopole_Literature_Review_Combined_v0.1_20261003_Review_Summary.md`
**Target teams:** MagneticMonopole / MIWikiAI / O2MCAI
**Primary emphasis:** Schwinger monopole production in heavy-ion collisions, experimental HEP searches, ALICE TPC relevance, and the interface to future O2MCAI studies.

---

## 0. Why this combined document exists

Five independent reviewers prepared magnetic-monopole literature reviews for the ALICE MagneticMonopole study. A subsequent ranking round showed strong convergence on the physics direction but different strengths in presentation:

- **GPT2:MonopoleAI** — strongest compromise between readability, onboarding value, ALICE relevance, and breadth;
- **GPT1:MonopoleAI** — most compact ALICE-centered narrative and explicit MC requirements;
- **GPT3:MonopoleAI** — strongest Schwinger/MC/transport technical treatment;
- **Clude1:MonoploeAI** — strongest verification-controlled bibliography and known-gap accounting;
- **Claude2:MonoploeAI** — broadest literature reservoir, especially energy-loss and Geant/Geant4 material.

The ranking panel did **not** identify a major conceptual conflict. The main recommendation was therefore to create one consolidated document rather than preserve multiple competing onboarding reviews.

### 0.1 Synthesis decision

This document uses **GPT2 as the structural/readability baseline**, but it is not a lightly edited copy of GPT2. The synthesis deliberately imports:

- GPT1's compact executive framing and explicit O2MCAI specification;
- GPT3's finite-size discussion, FPA/LCFA distinction, production provenance, transport separation, and injected-truth validation strategy;
- Clude1's verification/provenance discipline and experimental-result organization;
- Claude2's extended bibliography, GEANT/Geant4 energy-loss material, and "searched for but not found" items.

The goal is a **single readable front document backed by an explicit evidence/provenance layer**, not a catalogue of five opinions. The exhaustive Clude1/Claude2 reviews remain retained evidence companions; v0.2 intentionally keeps a curated core bibliography rather than reproducing their full 100+ reference reservoirs.

### 0.2 v0.1 review-closure matrix

| Consolidated finding | v0.2 disposition |
|---|---|
| **P1-01 — ATLAS 2025 derived mass exclusions absent** | **CLOSED in §7.3:** 120 GeV (FPA) and 80 GeV (LCFA) are restored explicitly. |
| **P1-02 — bibliography/provenance traceability incomplete** | **CLOSED in §14:** DOI/arXiv identifiers and compact provenance-status tags are restored; Clude1/Claude2 remain named evidence companions. |
| P2 — GHR 2021 approximation provenance | Applied in §3.7 and §9. |
| P2 — composite-monopole production motivation | Applied in §1.1, §2.2 and §7.1. |
| P2 — 2026 DY/PF counter-position | Applied in §4.3 as an explicitly open theoretical point. |
| P2 — ALICE detector-response anchors | Applied compactly in §8.1, with detector references. |
| P2 — experimental interpretation chain | Applied in §1.1. |
| P2 — glossary / citation cleanup | Applied below and in §§8–14. |

No accepted v0.1 architecture is reopened by these corrections.

### 0.3 Abbreviations used in this review

| Abbreviation | Meaning |
|---|---|
| **HIP** | highly ionizing particle |
| **MIP** | minimum-ionizing particle |
| **TPC** | time projection chamber |
| **GEM** | gas electron multiplier |
| **UPC** | ultraperipheral collision |
| **SQUID** | superconducting quantum interference device |
| **FPA** | free-particle approximation |
| **LCFA** | locally constant field approximation |
| **DY** | Drell–Yan |
| **PF** | photon fusion |
| **MC** | Monte Carlo |

### 0.4 Source coverage matrix

| Source review | Material preserved in this synthesis |
|---|---|
| GPT2:MonopoleAI | Overall pedagogical structure; three-question framing; Schwinger emphasis; ALICE Lehner thesis; reviewer questions; recent reviews |
| GPT1:MonopoleAI | Compact executive summary; explicit production/transport/detector chain; 12-point O2MCAI specification; mandatory reading concept |
| GPT3:MonopoleAI | Terminology warning; Affleck/Manton chain; finite-size monopoles; FPA/LCFA; MC production provenance; injected-truth validation |
| Clude1:MonoploeAI | Verification discipline; experimental status/limit organization; known gaps; detailed ALICE common-mode discussion; source-status concept. The full source review remains an evidence companion rather than being reproduced verbatim. |
| Claude2:MonoploeAI | GEANT/Geant4 monopole transport references; detailed stopping-power lineage; explicit negative-search results; broad bibliography reservoir. The full source review remains an evidence companion rather than being reproduced verbatim. |

**Important:** this synthesis is based on the supplied reviews. It does **not** claim that every bibliographic item has been independently re-verified by the synthesis editor. Section 14 now records whether a core item was primary-checked by the v0.1 review panel, verified in a source review, record-checked, or still dependent on source-review provenance. Clude1 and Claude2 remain retained evidence companions for deeper audit.

---

# 1. Executive summary

The ALICE MagneticMonopole study is best organized around one central question:

> **Can low-mass magnetic monopoles be produced nonperturbatively in the very strong, short-lived electromagnetic fields of heavy-ion collisions and detected using the distinctive response of the ALICE TPC to extreme ionization?**

Three physics layers should be kept separate.

### 1.1 Production

The Dirac magnetic charge is large, \(g_D/e \simeq 68.5\), implying a strong magnetic coupling. As a consequence, ordinary fixed-order perturbative calculations of magnetic-monopole pair production are not theoretically controlled in the same sense as standard QED processes.

Drell–Yan (DY) and photon-fusion (PF) models remain useful as **benchmark production models**, particularly for pp searches by ATLAS and MoEDAL. Their detector efficiencies and fiducial limits are experimentally meaningful, but mass limits obtained by intersecting those limits with perturbative monopole-production curves are model dependent.

The **dual Schwinger mechanism** offers a qualitatively different route. Strong external magnetic fields can produce monopole–antimonopole pairs by nonperturbative tunnelling. Relativistic Pb–Pb collisions provide enormous transient electromagnetic fields, making Schwinger production the principal production framework for the ALICE-oriented heavy-ion programme considered here.

A second reason for this emphasis is monopole structure. For composite/solitonic monopoles, hard production in point-particle collisions can be strongly suppressed; Drukier and Nussinov identified this issue already in 1982. Schwinger production in an external field does not rely on resolving the monopole as a pointlike constituent, which is why modern heavy-ion searches treat it as an especially important channel.

For every experimental result, keep the interpretation chain explicit:

```text
observed events / background
-> reconstruction efficiency / fiducial or cross-section limit
-> assumed production kinematics
-> assumed absolute production cross section
-> derived mass exclusion
```

The first two layers can be comparatively detector-robust; the last layers can remain production-model dependent.

### 1.2 Transport and detector response

A monopole is not equivalent to an electrically charged particle with \(z=68.5\). Its force law and trajectory in electromagnetic fields differ, and its stopping power has characteristic velocity-dependent regimes described by monopole-specific calculations.

For relativistic \(1g_D\) monopoles, the ionization can be thousands of times that of a minimum-ionizing particle. This makes monopoles experimentally spectacular but also creates detector problems: electronics saturation, stopping before sensitive layers, nonstandard tracking, and reconstruction outside the detector's normal operating regime.

### 1.3 ALICE opportunity

The central ALICE-relevant peer-reviewed paper is:

**M. Arslandok, H. Caines, M. Ivanov, "New method to search for highly ionizing exotic particles, monopoles, and beyond using time projection chambers," Phys. Rev. D 110, 032013 (2024), arXiv:2403.12299.**

The key proposal is to exploit the **common-mode signal of the GEM-based ALICE TPC** rather than treating saturation only as lost information. A sufficiently large HIP/monopole signal induces a correlated, opposite-polarity common-mode response across pads of a readout stack; the paper proposes using that response as a hardware-trigger observable and retaining raw information for later reconstruction.

This is a **detector-method paper**, not a published ALICE Collaboration monopole-search result and not a published ALICE sensitivity/mass-reach analysis.

---

# 2. Minimal theoretical background

## 2.1 Dirac charge and charge quantization

Dirac's 1931 work established the basic relation between electric and magnetic charge. Depending on unit conventions, the condition may be written in forms such as

\[
eg = 2\pi n
\]

in common natural units, or equivalently with explicit \(\hbar c\) factors in Gaussian-like conventions.

For the minimum Dirac charge,

\[
\frac{g_D}{e} \simeq \frac{1}{2\alpha} \simeq 68.5 .
\]

The corresponding magnetic fine-structure coupling is of order

\[
\alpha_g \sim \frac{1}{4\alpha} \approx 34 .
\]

The exact normalization convention must be explicit in any MC or analysis implementation.

## 2.2 Pointlike versus solitonic monopoles

Dirac's construction does not fix the monopole mass or spin. Later work by 't Hooft and Polyakov showed that magnetic monopoles can arise as regular finite-energy solitonic solutions in spontaneously broken non-Abelian gauge theories.

This distinction matters operationally:

- **pointlike/effective Dirac monopole** — convenient phenomenological particle model;
- **finite-size/composite monopole** — an extended gauge-field configuration whose production may differ qualitatively from hard point-particle production.

A future ALICE result should therefore always state which monopole class is being constrained.

For composite monopoles this is not a cosmetic distinction. Drukier and Nussinov, *Phys. Rev. Lett.* **49** (1982) 102, argued that direct production of extended monopoles in energetic point-particle collisions can be enormously suppressed. This is one of the motivations for treating coherent-field Schwinger production separately from ordinary hard-scattering benchmark models.

## 2.3 Terminology warning: "Schwinger"

In this project, **Schwinger production** means the Schwinger pair-production mechanism / Schwinger effect and its electromagnetic dual for magnetic charges.

It does **not** mean the 1+1-dimensional quantum-electrodynamics theory often called the "Schwinger model."

---

# 3. Why Schwinger production is central

## 3.1 Original Schwinger effect

Schwinger's 1951 calculation showed that a sufficiently strong electric field destabilizes the vacuum with respect to charged-particle pair production. The characteristic weak-field exponential has the schematic form

\[
\Gamma \propto
\exp\left[-\frac{\pi m^2}{qE}\right].
\]

The important point is nonperturbative vacuum tunnelling: the external field lowers the barrier to pair creation.

## 3.2 Magnetic dual

Under electric-magnetic duality, the schematic replacement

\[
qE \rightarrow gB
\]

gives the leading intuition

\[
\Gamma_{M\bar M}
\propto
\exp\left[-\frac{\pi m_M^2}{gB}\right].
\]

This expression is only pedagogical. A realistic heavy-ion collision involves strong spatial and temporal inhomogeneity, strong magnetic coupling, temperature, possible monopole finite size, and post-production acceleration.

## 3.3 Affleck–Manton / strong-coupling bridge

Two 1982 papers are central:

- I. K. Affleck and N. S. Manton, **"Monopole pair production in a magnetic field,"** Nucl. Phys. B 194, 38 (1982).
- I. K. Affleck, O. Alvarez and N. S. Manton, **"Pair production at strong coupling in weak external fields,"** Nucl. Phys. B 197, 509 (1982).

They establish the semiclassical instanton framework for magnetic pair production and show why large magnetic charge does not force the calculation into an ordinary low-order expansion in \(g\).

A commonly quoted strong-coupling constant-field exponent contains both a field-dependent tunnelling term and a self-interaction correction. It must be used only inside its stated validity domain.

## 3.4 Heavy-ion programme: Gould and Rajantie 2017

O. Gould and A. Rajantie, **Phys. Rev. Lett. 119, 241601 (2017)**, connected Schwinger monopole production directly to heavy-ion phenomenology. Heavy-ion collisions combine strong electromagnetic fields with high temperatures and therefore provide a laboratory environment in which monopole production can be studied without relying only on conventional perturbative partonic production.

This paper marks the start of the modern heavy-ion Schwinger-search chain.

## 3.5 Space-time-dependent fields: Gould, Ho and Rajantie 2019

O. Gould, D. L.-J. Ho and A. Rajantie, **Phys. Rev. D 100, 015041 (2019)**, is the key technical theory paper for an ALICE heavy-ion programme.

It uses worldline instantons to treat the space-time-dependent electromagnetic field in peripheral heavy-ion collisions and treats the monopole coupling to the external electromagnetic field nonperturbatively. The calculation introduces the importance of field inhomogeneity / Keldysh-type scales and finds that the space-time dependence can enhance production relative to an oversimplified constant-field treatment.

Two conclusions are especially important for our later studies:

1. realistic space-time dependence matters; a static uniform-\(B\) estimate is not automatically an adequate event-generator model;
2. finite monopole size and the strong-coupling structure remain important limitations/inputs.

## 3.6 Finite-size monopoles

D. L.-J. Ho and A. Rajantie studied classical/semiclassical production of 't Hooft–Polyakov monopoles in strong magnetic fields. The main lesson for the subgroup is not a single correction factor but a warning:

> **Pointlike Schwinger production is not automatically a universally valid or conservative description of a composite monopole.**

Finite-size structure can modify and potentially enhance production, and sufficiently strong fields can change the qualitative regime.

## 3.7 Momentum distribution: the MC-critical step

O. Gould, D. L.-J. Ho and A. Rajantie, **Phys. Rev. D 104, 015033 (2021)**, derive the momentum distribution of Schwinger-produced monopoles using complex worldline instantons.

The paper includes the external magnetic field to all orders but neglects monopole self-interactions. In the terminology used in this review, its kinematic treatment therefore belongs on the **FPA-type** side of the approximation split. This matters for MC provenance: a momentum distribution taken from this calculation must not be silently combined with an LCFA normalization and then labelled simply “the Schwinger model.”

This is critical for experiment. A total pair-production rate is insufficient for acceptance and detector studies. MC work ultimately needs quantities such as

\[
m_M,\quad g,\quad \mathbf p,\quad p_T,\quad y,\quad \phi,
\]

their correlations with the collision geometry and field, and a prescription for post-production propagation.

---

# 4. Production-model taxonomy for experimental work

## 4.1 Schwinger heavy-ion production

A Schwinger sample should carry explicit provenance:

- collision species and \(\sqrt{s_{NN}}\);
- impact parameter, centrality, or equivalent electromagnetic-field model;
- monopole mass and charge;
- pointlike versus finite-size assumption;
- approximation class;
- space-time production distribution;
- initial momentum distribution;
- field evolution used after production;
- normalization/cross-section prescription and validity regime.

## 4.2 FPA and LCFA

The heavy-ion literature uses complementary approximations that should not be treated as interchangeable generator "tunes":

- **Free-particle approximation (FPA):** captures space-time dependence of the external field more faithfully while neglecting monopole self-interactions.
- **Locally constant field approximation (LCFA):** incorporates strong-coupling/self-interaction structure while approximating the external field locally as constant.

A future O2MCAI interface should record the approximation explicitly.

## 4.3 Drell–Yan and photon fusion

DY and PF remain valuable because they provide reproducible benchmark kinematics used by ATLAS and MoEDAL.

For Dirac-strength magnetic charge, however, their absolute cross sections are not ordinary perturbatively controlled predictions. They should therefore be labelled **benchmark models** and should record:

- spin hypothesis;
- magnetic charge;
- constant-\(g\) versus velocity-dependent effective coupling, if used;
- DY versus PF;
- generator/version;
- the strong-coupling caveat for the absolute rate.

The Baines et al. MadGraph work is a useful reference for how modern pointlike benchmark samples are constructed.

There is also a recent counter-position that should remain visible. Alexandre, Mavromatos, Mitsou and Musumeci, *Eur. Phys. J. C* **86** (2026) 942, argue that monopole resummation can formally justify use of tree-level DY/PF production cross sections. The source-review panel verified the bibliographic record but did not resolve the broader theoretical dispute. MonopoleAI therefore retains the conservative operational rule: **record DY/PF explicitly as the production prescription and keep detector limits separate from the theory-dependent mass interpretation**, while tracking this 2026 result as an open theory-development point.

---

# 5. Energy loss, propagation and simulation

## 5.1 Energy loss in matter

The core stopping-power literature includes:

- S. P. Ahlen, **Phys. Rev. D 17, 229 (1978)**;
- S. P. Ahlen, **Rev. Mod. Phys. 52, 121 (1980)**;
- S. P. Ahlen and K. Kinoshita, **Phys. Rev. D 26, 2347 (1982)**;
- S. D. Drell et al., **Phys. Rev. Lett. 50, 644 (1983)** for slow-monopole atomic excitation.

The important experimental point is that monopole stopping power changes with velocity and material. No single constant "4700 MIP" multiplier should be used over the full kinematic range.

## 5.2 Equation of motion

A magnetic charge obeys the dual Lorentz-force law. In a solenoidal magnetic field a monopole is accelerated along/opposite to the field direction rather than following the ordinary transverse helical trajectory of an electric charge.

This is why monopole transport must not be approximated by an electrically charged particle with \(z=68.5\).

## 5.3 GEANT / Geant4 lineage

Claude2's verified literature survey identified:

- G. Bauer et al., **"Simulating magnetic monopoles by extending GEANT,"** Nucl. Instrum. Meth. A 545, 503 (2005);
- the Geant4 source `G4mplIonisationModel.cc`, whose source header cites Ahlen-type high-energy stopping power, Ahlen–Kinoshita at low velocity, with interpolation between regimes.

Claude2 reports that no dedicated Geant4 Collaboration publication documenting monopole physics was found in its search; the verified evidence was the source-code header rather than an archival Geant4 monopole paper.

This is important for O2MCAI: the exact O2/Geant4 implementation and configuration should be read from source and validated directly rather than inferred from literature alone.

---

# 6. Experimental search programme

## 6.1 Selected pre-LHC lineage

A complete historical catalogue is not needed for onboarding, but several experiments establish the main techniques.

### HERA / H1

H1 scanned beam-pipe material exposed to \(e^+p\) collisions with a SQUID magnetometer, looking for permanently trapped magnetic charge. This is an important precursor to modern beam-pipe/trapping searches.

### Tevatron / CDF

CDF performed a direct high-ionization search in \(p\bar p\) collisions and presented a Drell–Yan-based mass interpretation. It is a useful example of why detector-level results and production-model mass limits should be discussed separately.

### LEP / OPAL

OPAL searched for approximately back-to-back, extremely highly ionizing tracks in \(e^+e^-\) collisions. The clean topology makes this a useful pedagogical example of an active tracking-detector monopole signature.

### Heavy-ion precursor

Y. D. He, **Phys. Rev. Lett. 79, 3134 (1997)**, searched high-energy nucleus–nucleus collisions for Dirac monopoles. It predates the modern Schwinger interpretation but is an important historical heavy-ion predecessor.

## 6.2 ATLAS pp programme

ATLAS developed a sequence of highly ionizing particle searches at 7, 8 and 13 TeV, culminating in the full Run-2 analysis:

**ATLAS Collaboration, JHEP 11 (2023) 112, arXiv:2308.04835.**

The pp analyses use dedicated highly-ionizing signatures/triggers and interpret results using DY and PF benchmark production.

The detector lesson is directly relevant to ALICE: extreme ionization is distinctive, but triggering, saturation, range/stopping, and reconstruction outside the normal detector regime are central.

## 6.3 MoEDAL pp programme

MoEDAL was designed specifically for highly ionizing particles. Its pp programme combines nuclear-track detectors and trapping volumes that can be scanned with a SQUID for persistent magnetic charge.

Important papers include the 8 TeV prototype trapping search, the 13 TeV forward/full trapping searches, the 2019 PF+DY interpretation, and the 2025 full Run-2 HIP analysis reaching magnetic charges up to approximately \(10g_D\) in the reported benchmark interpretations.

The strength of the trapping approach is the direct magnetic-charge observable; the limitation is geometric/stopping acceptance.

---

# 7. Heavy-ion Schwinger searches

## 7.1 MoEDAL Nature 2022

**B. Acharya et al. (MoEDAL), "Search for magnetic monopoles produced via the Schwinger mechanism," Nature 602, 63–67 (2022), arXiv:2106.11933.**

This is the first collider search explicitly interpreted through Schwinger monopole production.

MoEDAL exposed aluminium trapping samples during the 2018 Pb–Pb run at \(\sqrt{s_{NN}}=5.02\) TeV and scanned them with a superconducting magnetometer. No monopole signal was found.

Within the adopted Schwinger model, the analysis excluded \(1g_D\), \(2g_D\), and \(3g_D\) monopoles up to masses of order 75 GeV.

A major conceptual advantage of this interpretation is that the search can be applied to **finite-size/composite monopoles**, rather than requiring the hard-collision production of a pointlike monopole.

The paper is particularly valuable because it demonstrates the complete chain:

\[
B(x,t)
\rightarrow
M\bar M\ {\rm production}
\rightarrow
{\rm kinematics}
\rightarrow
{\rm propagation/stopping}
\rightarrow
{\rm trapping}
\rightarrow
{\rm SQUID}
\rightarrow
{\rm limit}.
\]

## 7.2 MoEDAL CMS beam-pipe search 2024

**B. Acharya et al. (MoEDAL), Phys. Rev. Lett. 133, 071803 (2024), arXiv:2402.15682.**

Material from the CMS beam pipe exposed to Pb–Pb collisions was scanned for trapped magnetic charge. No signal was observed.

The reported interpretation extends to high magnetic charges, approximately \(2\)–\(45g_D\), with mass reach of order 80 GeV in parts of the charge range.

The methodological lesson is important: accelerator hardware very close to the interaction point can itself act as trapping material.

## 7.3 ATLAS Pb–Pb search 2025

**ATLAS Collaboration, Phys. Rev. Lett. 134, 061803 (2025), arXiv:2408.11035.**

ATLAS used \(262\,\mu{\rm b}^{-1}\) of ultraperipheral Pb–Pb data at \(\sqrt{s_{NN}}=5.36\) TeV and searched for extreme ionization with innermost silicon-layer hit clusters.

No significant excess was observed. The search covers \(1g_D\) monopoles over approximately the 20–150 GeV mass interval and interprets the result with nonperturbative semiclassical production models.

In the published model interpretations, monopoles with \(|q_m|=1g_D\) are excluded below approximately **120 GeV under the FPA** and below approximately **80 GeV under the LCFA**. The 40 GeV difference is an explicit illustration of why an experimental cross-section limit and a derived monopole mass exclusion must not be conflated.

This is the most direct active-detector comparator for a future ALICE Pb–Pb search.

---

# 8. ALICE-specific literature and detector strategy

## 8.1 Arslandok–Caines–Ivanov 2024

**M. Arslandok, H. Caines, M. Ivanov, Phys. Rev. D 110, 032013 (2024), arXiv:2403.12299.**

This is the central ALICE-relevant peer-reviewed monopole-method paper found by the review panel.

### The problem

Highly ionizing particles can exceed the dynamic range of conventional readout electronics. Saturation can destroy the ordinary relationship between detector amplitude and energy loss.

### The key ALICE TPC idea: common-mode signal

In the GEM TPC, the pad plane and GEM foils are capacitively coupled. A very large local signal can induce a correlated signal with opposite polarity on pads of the same readout stack.

The paper proposes using this **common-mode signal** as part of the trigger/readout strategy for HIPs and monopoles.

This point must remain explicit in the combined review: the proposal is not merely "the TPC sees high \(dE/dx\)." It specifically exploits detector response outside the ordinary linear readout regime.

### Proposed analysis ingredients

The reviewed paper describes:

1. a common-mode threshold trigger;
2. a time-duration / consecutive-time-bin observable related to the track extent;
3. raw-data recording without losing the extreme signal information;
4. cluster finding retaining the relevant signal tail;
5. tracking that can accommodate monopole-like non-helical trajectories.

The review panel reports a relativistic \(1g_D\) ionization scale above roughly 4700 MIPs as quoted in the paper. The paper uses laser-calibration data at roughly **798 MIP-equivalent** as a measured high-ionization anchor, about a factor six below the expected monopole scale.

Additional detector-response anchors retained for O2MCAI validation are:

- the electronics/pedestal constraint that limits the measurable common-mode amplitude once ordinary channels saturate;
- a GEM-discharge safety estimate that remains well below the quoted critical charge in the study configuration;
- **spallation products** as the identified primary HIP-search background;
- the explicit assumption that the monopole survives the material in front of the TPC.

Two detector references should be read alongside the monopole-method paper:

- ALICE TPC Collaboration, *The upgrade of the ALICE TPC with GEMs and continuous readout*, JINST **16** (2021) P03022, arXiv:2012.09518;
- ALICE TPC Collaboration, *Correction of the baseline fluctuations in the GEM-based ALICE TPC*, JINST **18** (2023) P11021, arXiv:2304.03881.

These detector papers describe the GEM TPC and the baseline/common-mode behavior that the monopole method deliberately turns from a nuisance into a signal observable.

### Status

This is a detector-method and feasibility paper. It is **not** a published ALICE Collaboration monopole-search result, contains **no collision-data monopole analysis**, and contains no published ALICE mass-reach/sensitivity curve.

Claude2's literature search found no ALICE Collaboration monopole publication on INSPIRE and no published ALICE sensitivity/mass-reach estimate. This is a useful negative-search result, but the approval panel should independently reconfirm it before MIWikiAI treats it as permanent source-of-truth.

## 8.2 Earlier ALICE thesis

GPT2 identified:

**S. Lehner, "Dielectron production and a search for highly-charged particles in Pb–Pb collisions," PhD thesis, TU Wien (2019), CERN-THESIS-2019-261.**

The thesis develops an ALICE highly charged particle / monopole-search strategy. A particularly useful idea is the use of **stopping nuclear fragments as data-driven detector-response analogues** for very highly ionizing objects.

This is not a peer-reviewed ALICE Collaboration search result, but it is valuable historical and methodological material for the subgroup.

## 8.3 Current conference material

The source reviews also identify recent conference material:

**M. Arslandok, “Magnetic Monopole and HIP Searches with TPCs: First Experience from ALICE,” contribution to *Next Frontiers in Magnetic Monopole Searches*, 11–14 September 2026.**

An earlier precursor is the 14 October 2021 APS Division of Nuclear Physics contribution, **“Exploiting common-mode signals in the ALICE TPC to search for magnetic Monopoles.”**

Conference material should be archived separately from peer-reviewed literature and clearly labelled **preliminary/current-status material**.

---

# 9. What O2MCAI should eventually specify

A scientifically useful monopole MC configuration should not be represented by a single ambiguous label such as `monopoleProduction`.

At minimum it should declare:

1. **Monopole model:** pointlike Dirac/effective particle versus finite-size/composite model.
2. **Mass:** \(m_M\).
3. **Magnetic charge:** \(g=n g_D\), with unit convention.
4. **Spin hypothesis**, where the production prescription depends on it.
5. **Production mechanism:** Schwinger, thermal Schwinger, DY, PF, or another explicit model.
6. **Collision system and field model:** species, \(\sqrt{s_{NN}}\), impact parameter/centrality or UPC selection, \(B(\mathbf x,t)\) and where relevant \(E(\mathbf x,t)\).
7. **Kinematics approximation:** FPA-type, LCFA-derived, or another named prescription used to generate momentum/angle distributions.
8. **Normalization approximation:** FPA, LCFA, thermal Schwinger, DY/PF cross section, or another explicit rate prescription; do not assume it is identical to the kinematics prescription.
9. **Production normalization:** total rate/cross section and validity regime.
10. **Generated kinematics:** momentum/angular distribution and correlations with production geometry.
11. **Propagation:** dual Lorentz force in ALICE electromagnetic fields.
12. **Material interaction:** velocity- and material-dependent monopole stopping power.
13. **Detector response:** primary ionization, saturation, common-mode response, thresholds, cluster/track behaviour.
14. **Software provenance:** generator/version, Geant4 version and monopole process, O2 revision/tag, field-map/configuration identity.
15. **Validation references:** independent analytical, alternate-implementation, data-driven, or published experimental anchors.

## 9.1 Separate production, transport, and detector response

These layers should be validated independently before being combined.

A recommended sequence is:

1. **Injected-truth production samples** with exactly known kinematics.
2. Validate monopole transport in electromagnetic fields.
3. Validate material energy loss / range.
4. Validate TPC ionization and electronics response.
5. Validate reconstruction observables.
6. Only then connect the detector chain to a Schwinger event generator.

This follows the broader differential-validation discipline: isolate disagreement layers before interpreting a final efficiency or sensitivity curve.

## 9.2 Immediate MC literature priorities

For the first implementation phase, the highest-value papers are:

- Gould–Ho–Rajantie 2021 for momentum distributions **with the explicit caveat that the calculation neglects monopole self-interactions (FPA-type kinematics provenance)**;
- Ahlen / Ahlen–Kinoshita for stopping power;
- Bauer et al. 2005 plus the actual Geant4 monopole source for transport implementation;
- Arslandok–Caines–Ivanov 2024 for the ALICE TPC response concept;
- MoEDAL 2022/2024 and ATLAS 2025 as experimental reference chains.

---

# 10. Common onboarding reading set

The full bibliography is large. Every new subgroup reviewer should first read a controlled core.

## Tier A — mandatory first reading

1. **V. A. Mitsou (2026), "Magnetic monopoles: from Dirac to the Large Hadron Collider."**
   Current broad map of theory and experimental searches.

2. **A. Rajantie (2019), "Monopole–antimonopole pair production by magnetic fields."**
   Compact conceptual bridge into magnetic Schwinger production.

3. **O. Gould, D. L.-J. Ho, A. Rajantie, Phys. Rev. D 100, 015041 (2019).**
   Core space-time-dependent heavy-ion Schwinger theory.

4. **O. Gould, D. L.-J. Ho, A. Rajantie, Phys. Rev. D 104, 015033 (2021).**
   Core momentum-distribution / MC-kinematics paper.

5. **MoEDAL Collaboration, Nature 602, 63–67 (2022).**
   First experimental Schwinger monopole search.

6. **ATLAS Collaboration, Phys. Rev. Lett. 134, 061803 (2025).**
   Current active-detector Pb–Pb Schwinger search.

7. **M. Arslandok, H. Caines, M. Ivanov, Phys. Rev. D 110, 032013 (2024).**
   Core ALICE/TPC detector-method paper.

8. **S. P. Ahlen, Phys. Rev. D 17, 229 (1978), plus Rev. Mod. Phys. 52, 121 (1980).**
   Core stopping-power references.

## Tier B — foundations and production models

9. P. A. M. Dirac, Proc. R. Soc. A 133, 60 (1931).
10. J. Schwinger, Phys. Rev. 82, 664 (1951).
11. G. 't Hooft, Nucl. Phys. B 79, 276 (1974).
12. A. M. Polyakov, JETP Lett. 20, 194 (1974).
13. I. K. Affleck and N. S. Manton, Nucl. Phys. B 194, 38 (1982).
14. I. K. Affleck, O. Alvarez and N. S. Manton, Nucl. Phys. B 197, 509 (1982).
15. O. Gould and A. Rajantie, Phys. Rev. Lett. 119, 241601 (2017).
16. S. Baines et al., Eur. Phys. J. C 78, 966 (2018), MadGraph DY/PF benchmark implementation.

## Tier C — detector/search context

17. ATLAS full Run-2 pp monopole/HIP search, JHEP 11 (2023) 112.
18. MoEDAL CMS beam-pipe Schwinger search, PRL 133, 071803 (2024).
19. MoEDAL full Run-2 HIP search, PRL 134, 071802 (2025).
20. H1 beam-pipe/SQUID search, EPJC 41, 133 (2005).
21. CDF direct search, PRL 96, 201801 (2006).
22. OPAL LEP2 search, Phys. Lett. B 663, 37 (2008).
23. S. Lehner, TU Wien PhD thesis (2019), ALICE highly charged particle / monopole strategy.

---

# 11. Recent overview references

Useful map/review papers include:

- K. A. Milton, **Theoretical and experimental status of magnetic monopoles**, Rep. Prog. Phys. 69 (2006).
- A. Rajantie, **Introduction to magnetic monopoles**, Contemp. Phys. 53 (2012).
- L. Patrizii and M. Spurio, **Status of Searches for Magnetic Monopoles**, Annu. Rev. Nucl. Part. Sci. 65 (2015).
- N. E. Mavromatos and V. A. Mitsou, **Magnetic monopoles revisited: Models and searches at colliders and in the Cosmos**, Int. J. Mod. Phys. A 35 (2020).
- D. Milstead and E. J. Weinberg, **Magnetic Monopoles**, chapter 94 (revised August 2025) of the Particle Data Group *Review of Particle Physics*, *Int. J. Mod. Phys. A* **41** (2026) 2630011.
- O. Gould, I. Ostrovskiy, A. Upreti, **Next frontiers for magnetic monopole searches**, Phys. Rev. D 111, 102004 (2025).
- V. A. Mitsou, **Magnetic monopoles: from Dirac to the Large Hadron Collider** (2026).

---

# 12. Known gaps and items for reviewer confirmation

v0.2 closes the two blocking v0.1 review findings, but intentionally retains several boundaries for later source-of-truth and implementation work:

1. **Bibliography provenance:** the curated core now carries identifiers and compact status tags. The exhaustive Clude1/Claude2 reviews remain evidence companions for deeper audit.
2. **ALICE publication absence:** the v0.1 panel independently reproduced an INSPIRE search with zero ALICE-collaboration monopole-title hits. Treat this as a dated search result, not proof of nonexistence.
3. **Geant4/O2 implementation:** the literature lineage is recorded, but the exact AliceO2/Geant4 source, version and runtime configuration still require a dedicated O2MCAI implementation audit. The review panel points to AliceO2 PR #15602 and the MIWikiAI TPC hit-creation source-of-truth note as relevant starting points.
4. **Current ALICE conference status:** conference material remains preliminary/current-status evidence and should not be used for archival numerical claims without source checking.
5. **Exact experimental tables:** the headline MoEDAL/ATLAS values used in this review were spot-checked by the v0.1 panel, but a future frozen MIWikiAI numerical-limit table should still be built directly from primary publications.
6. **DY/PF theory status:** the standard strong-coupling caveat and the 2026 resummation counter-position are both recorded. MonopoleAI should not silently collapse this into a single settled theoretical statement.
7. **Mattermost use-case discussion:** not yet incorporated. It should become the next review unit, mapping concrete ALICE questions to established literature, assumptions and required validation.

---

# 13. Proposed next step after narrow confirmation

After the v0.2 correction-confirmation review closes the v0.1 P1 findings:

1. archive this document in MIWikiAI as the common MagneticMonopole onboarding review;
2. read the Mattermost discussion as a separate ALICE-use-case source;
3. extract every concrete physics/detector/MC claim or question;
4. classify each as:
   - established by literature;
   - plausible but model-dependent;
   - ALICE-specific assumption;
   - unresolved;
   - requires O2MCAI simulation;
   - requires detector/data validation;
5. build the first focused MagneticMonopole → O2MCAI work programme.

---

# 14. Consolidated core bibliography and provenance

This is a **curated core**, not the full 100+ item union of the source reviews. The exhaustive Clude1 and Claude2 reviews remain retained evidence companions.

### Provenance-status legend

- **PANEL-PRIMARY-CHECKED** — one or more v0.1 approval reviewers independently checked the primary publication/record for the relevant claim.
- **SOURCE-REVIEW-VERIFIED** — Clude1 and/or Claude2 explicitly marked the item verified from a primary/abstract source.
- **SOURCE-REVIEW-RECORD** — bibliographic record checked, but not full scientific-content verification.
- **SOURCE-REVIEW-CITED** — retained from the source-review corpus without a stronger verification claim in this synthesis.

| # | Reference | Identifier(s) | Provenance status |
|---:|---|---|---|
| 1 | P. A. M. Dirac, *Quantised Singularities in the Electromagnetic Field*, Proc. R. Soc. A **133**, 60 (1931) | DOI `10.1098/rspa.1931.0130` | SOURCE-REVIEW-VERIFIED |
| 2 | J. Schwinger, *On Gauge Invariance and Vacuum Polarization*, Phys. Rev. **82**, 664 (1951) | DOI `10.1103/PhysRev.82.664` | SOURCE-REVIEW-CITED |
| 3 | G. 't Hooft, *Magnetic Monopoles in Unified Gauge Theories*, Nucl. Phys. B **79**, 276 (1974) | DOI `10.1016/0550-3213(74)90486-6` | SOURCE-REVIEW-VERIFIED |
| 4 | A. M. Polyakov, *Particle Spectrum in Quantum Field Theory*, JETP Lett. **20**, 194 (1974) | no DOI/arXiv in source reviews | SOURCE-REVIEW-RECORD |
| 5 | S. P. Ahlen, *Stopping-Power Formula for Magnetic Monopoles*, Phys. Rev. D **17**, 229 (1978) | DOI `10.1103/PhysRevD.17.229` | SOURCE-REVIEW-VERIFIED |
| 6 | S. P. Ahlen, *Theoretical and experimental aspects of the energy loss of relativistic heavily ionizing particles*, Rev. Mod. Phys. **52**, 121 (1980) | DOI `10.1103/RevModPhys.52.121` | SOURCE-REVIEW-VERIFIED |
| 7 | I. K. Affleck and N. S. Manton, *Monopole Pair Production in a Magnetic Field*, Nucl. Phys. B **194**, 38 (1982) | DOI `10.1016/0550-3213(82)90511-9` | SOURCE-REVIEW-VERIFIED |
| 8 | I. K. Affleck, O. Alvarez and N. S. Manton, *Pair Production at Strong Coupling in Weak External Fields*, Nucl. Phys. B **197**, 509 (1982) | DOI `10.1016/0550-3213(82)90455-2` | SOURCE-REVIEW-VERIFIED |
| 9 | S. P. Ahlen and K. Kinoshita, *Calculation of the Stopping Power of Very-Low-Velocity Magnetic Monopoles*, Phys. Rev. D **26**, 2347 (1982) | DOI `10.1103/PhysRevD.26.2347` | SOURCE-REVIEW-VERIFIED |
| 10 | G. Bauer et al., *Simulating magnetic monopoles by extending GEANT*, Nucl. Instrum. Meth. A **545**, 503 (2005) | DOI `10.1016/j.nima.2005.01.326` | SOURCE-REVIEW-VERIFIED |
| 11 | H1 Collaboration, *A Direct Search for Stable Magnetic Monopoles Produced in Positron-Proton Collisions at HERA*, Eur. Phys. J. C **41**, 133 (2005) | DOI `10.1140/epjc/s2005-02201-6`; arXiv `hep-ex/0501039` | SOURCE-REVIEW-VERIFIED |
| 12 | CDF Collaboration, *Direct Search for Dirac Magnetic Monopoles in \(p\bar p\) Collisions at \(\sqrt{s}=1.96\) TeV*, Phys. Rev. Lett. **96**, 201801 (2006) | DOI `10.1103/PhysRevLett.96.201801`; arXiv `hep-ex/0509015` | SOURCE-REVIEW-VERIFIED |
| 13 | OPAL Collaboration, *Search for Dirac magnetic monopoles in \(e^+e^-\) collisions with OPAL at LEP2*, Phys. Lett. B **663**, 37 (2008) | DOI `10.1016/j.physletb.2008.03.057`; arXiv `0707.0404` | SOURCE-REVIEW-VERIFIED |
| 14 | A. Rajantie, *Introduction to magnetic monopoles*, Contemp. Phys. **53**, 195 (2012) | DOI `10.1080/00107514.2012.685693`; arXiv `1204.3077` | SOURCE-REVIEW-VERIFIED |
| 15 | L. Patrizii and M. Spurio, *Status of Searches for Magnetic Monopoles*, Annu. Rev. Nucl. Part. Sci. **65**, 279 (2015) | DOI `10.1146/annurev-nucl-102014-022137`; arXiv `1510.07125` | SOURCE-REVIEW-VERIFIED |
| 16 | O. Gould and A. Rajantie, *Magnetic Monopole Mass Bounds from Heavy-Ion Collisions and Neutron Stars*, Phys. Rev. Lett. **119**, 241601 (2017) | DOI `10.1103/PhysRevLett.119.241601`; arXiv `1705.07052` | SOURCE-REVIEW-VERIFIED |
| 17 | S. Baines et al., *Monopole production via photon fusion and Drell–Yan processes: MadGraph implementation...*, Eur. Phys. J. C **78**, 966 (2018) | DOI `10.1140/epjc/s10052-018-6440-6`; arXiv `1808.08942` | SOURCE-REVIEW-VERIFIED |
| 18 | A. Rajantie, *Monopole–antimonopole pair production by magnetic fields*, Philos. Trans. R. Soc. A **377**, 20190333 (2019) | DOI `10.1098/rsta.2019.0333`; arXiv `1907.05745` | SOURCE-REVIEW-CITED |
| 19 | O. Gould, D. L.-J. Ho, A. Rajantie, *Towards Schwinger production of magnetic monopoles in heavy-ion collisions*, Phys. Rev. D **100**, 015041 (2019) | DOI `10.1103/PhysRevD.100.015041`; arXiv `1902.04388` | PANEL-PRIMARY-CHECKED |
| 20 | S. Lehner, *Dielectron production and a search for highly-charged particles in Pb–Pb collisions*, PhD thesis, TU Wien (2019) | CERN-THESIS-2019-261; CDS 2705740 | PANEL-PRIMARY-CHECKED (record/title) |
| 21 | N. E. Mavromatos and V. A. Mitsou, *Magnetic monopoles revisited: Models and searches at colliders and in the Cosmos*, Int. J. Mod. Phys. A **35**, 2030012 (2020) | DOI `10.1142/S0217751X20300124`; arXiv `2005.05100` | SOURCE-REVIEW-VERIFIED |
| 22 | D. L.-J. Ho and A. Rajantie, *Classical production of 't Hooft–Polyakov monopoles from magnetic fields*, Phys. Rev. D **101**, 055003 (2020) | DOI `10.1103/PhysRevD.101.055003`; arXiv `1911.06088` | SOURCE-REVIEW-CITED |
| 23 | O. Gould, D. L.-J. Ho, A. Rajantie, *Schwinger pair production of magnetic monopoles: Momentum distribution for heavy-ion collisions*, Phys. Rev. D **104**, 015033 (2021) | DOI `10.1103/PhysRevD.104.015033`; arXiv `2103.14454` | PANEL-PRIMARY-CHECKED |
| 24 | MoEDAL Collaboration, *Search for magnetic monopoles produced via the Schwinger mechanism*, Nature **602**, 63 (2022) | DOI `10.1038/s41586-021-04298-1`; arXiv `2106.11933` | PANEL-PRIMARY-CHECKED |
| 25 | ATLAS Collaboration, *Search for magnetic monopoles and stable particles with high electric charges in 13 TeV pp collisions*, JHEP **11** (2023) 112 | DOI `10.1007/JHEP11(2023)112`; arXiv `2308.04835` | SOURCE-REVIEW-VERIFIED |
| 26 | M. Arslandok, H. Caines, M. Ivanov, *New method to search for highly ionizing exotic particles, monopoles, and beyond using time projection chambers*, Phys. Rev. D **110**, 032013 (2024) | DOI `10.1103/PhysRevD.110.032013`; arXiv `2403.12299` | PANEL-PRIMARY-CHECKED |
| 27 | MoEDAL Collaboration, *MoEDAL Search in the CMS Beam Pipe for Magnetic Monopoles Produced via the Schwinger Effect*, Phys. Rev. Lett. **133**, 071803 (2024) | DOI `10.1103/PhysRevLett.133.071803`; arXiv `2402.15682` | PANEL-PRIMARY-CHECKED |
| 28 | O. Gould, I. Ostrovskiy, A. Upreti, *Next frontiers for magnetic monopole searches*, Phys. Rev. D **111**, 102004 (2025) | DOI `10.1103/PhysRevD.111.102004`; arXiv `2409.04552` | SOURCE-REVIEW-VERIFIED |
| 29 | ATLAS Collaboration, *Search for Magnetic Monopole Pair Production in Ultraperipheral Pb+Pb Collisions at \(\sqrt{s_{NN}}=5.36\) TeV*, Phys. Rev. Lett. **134**, 061803 (2025) | DOI `10.1103/PhysRevLett.134.061803`; arXiv `2408.11035` | PANEL-PRIMARY-CHECKED |
| 30 | MoEDAL Collaboration, *Search for Highly Ionizing Particles in pp Collisions during LHC Run 2 Using the Full MoEDAL Detector*, Phys. Rev. Lett. **134**, 071802 (2025) | DOI `10.1103/PhysRevLett.134.071802`; arXiv `2311.06509` | SOURCE-REVIEW-VERIFIED |
| 31 | V. A. Mitsou, *Magnetic monopoles: from Dirac to the Large Hadron Collider*, Eur. Phys. J. Spec. Top. **235** (2026) 5481–5521 | DOI `10.1140/epjs/s11734-026-02463-z`; arXiv `2605.02869` | PANEL-PRIMARY-CHECKED (publication status) |

### Additional references introduced by v0.2 corrections

| # | Reference | Identifier(s) | Provenance status |
|---:|---|---|---|
| 32 | A. K. Drukier, S. Nussinov, *Monopole pair creation in energetic collisions: is it possible?*, Phys. Rev. Lett. **49**, 102 (1982) | DOI `10.1103/PhysRevLett.49.102` | SOURCE-REVIEW-VERIFIED |
| 33 | J. Alexandre, N. E. Mavromatos, V. A. Mitsou, E. Musumeci, *Magnetic-monopole resummation justifies perturbatively calculated collider production cross sections*, Eur. Phys. J. C **86**, 942 (2026) | DOI `10.1140/epjc/s10052-026-16085-1`; arXiv `2603.24200` | SOURCE-REVIEW-RECORD |
| 34 | ALICE TPC Collaboration, *The upgrade of the ALICE TPC with GEMs and continuous readout*, JINST **16** (2021) P03022 | DOI `10.1088/1748-0221/16/03/P03022`; arXiv `2012.09518` | SOURCE-REVIEW-VERIFIED |
| 35 | ALICE TPC Collaboration, *Correction of the baseline fluctuations in the GEM-based ALICE TPC*, JINST **18** (2023) P11021 | DOI `10.1088/1748-0221/18/11/P11021`; arXiv `2304.03881` | SOURCE-REVIEW-VERIFIED |
| 36 | D. Milstead, E. J. Weinberg, *Magnetic Monopoles*, chapter 94 (rev. Aug. 2025), Particle Data Group, *Int. J. Mod. Phys. A* **41** (2026) 2630011 | PDG 2026 review record | SOURCE-REVIEW-VERIFIED |

---

## Synthesis conclusion

The combined source reviews converge on a clear ALICE programme:

\[
\boxed{
\text{Schwinger production}
\rightarrow
\text{monopole kinematics}
\rightarrow
\text{transport / stopping}
\rightarrow
\text{extreme TPC response}
\rightarrow
\text{ALICE reconstruction}
\rightarrow
\text{experimental sensitivity}
}
\]

DY/PF samples remain useful benchmark controls and an active theory topic, but they should not silently become the default physical production model or be mixed with Schwinger kinematics/normalization without explicit provenance.

The immediate technical bridge to O2MCAI is therefore the combination of:

- the 2019/2021 heavy-ion Schwinger calculations,
- validated monopole transport and stopping power,
- the ALICE GEM-TPC common-mode response,
- and differential validation against published MoEDAL/ATLAS results and injected-truth simulations.
