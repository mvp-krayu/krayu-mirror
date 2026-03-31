# Research Canonical Coverage Matrix

Contract: RESEARCH-CANONICAL-EXTRACTION-01
Source: pages/research.md
Generated: 2026-03-31

This matrix shows, for each extracted unit, which existing k-pi authority documents cover it and to what degree.

---

## Authority Documents Checked

| Code | Document |
|------|----------|
| PI-STACK | docs/governance/architecture/program_intelligence_stack.md |
| PIOS-WP | docs/governance/architecture/pios_architecture_whitepaper.md |
| ESI-NAR | docs/governance/derivatives/narratives/execution_stability_index.md |
| RAG-NAR | docs/governance/derivatives/narratives/risk_acceleration_gradient.md |
| EB-NAR | docs/governance/derivatives/narratives/execution_blindness.md |
| PIG-NAR | docs/governance/derivatives/narratives/program_intelligence_gap.md |
| CAT-POS | docs/governance/category/construct_positioning_map.md |
| CAT-CLM | docs/governance/category/claim_boundary_model.md |
| CAT-STR | docs/governance/category/category_structure_model.md |

---

## Coverage Matrix

| Unit | Title | PI-STACK | PIOS-WP | ESI-NAR | RAG-NAR | EB-NAR | PIG-NAR | CAT-POS | Verdict |
|------|-------|----------|---------|---------|---------|--------|---------|---------|---------|
| U-01 | Structural Interpretive Gap | partial | — | — | — | — | partial | — | PARTIALLY_CANONICAL |
| U-02 | Visibility Problem / Question-Class | partial | — | — | — | partial | partial | — | PARTIALLY_CANONICAL |
| U-03 | Traditional Tools Contrast | — | — | — | — | partial | — | — | PARTIALLY_CANONICAL |
| U-04 | Gradual Failure Pattern | — | — | — | — | partial | — | — | PARTIALLY_CANONICAL |
| U-05 | Emergence Rationale | — | — | — | — | — | — | — | NOT_CANONICALIZED |
| U-06 | Formal Discipline Definition | YES | — | — | — | — | — | — | ALREADY_CANONICAL |
| U-07 | Comparative Discipline Table | — | — | — | — | — | — | — | NOT_CANONICALIZED |
| U-08 | Three Interpretive Layers | partial | partial | — | — | — | — | — | PARTIALLY_CANONICAL |
| U-09 | Program Structure | — | — | — | — | — | — | — | NOT_CANONICALIZED |
| U-10 | Initiative Visibility | — | — | — | — | — | — | — | NOT_CANONICALIZED |
| U-11 | Execution Signals Layer | — | — | — | — | — | — | partial | NOT_CANONICALIZED |
| U-12 | ESI Context Block | YES | — | YES | — | — | — | YES | ALREADY_CANONICAL |
| U-13 | RAG Context Block | YES | — | — | YES | — | — | YES | ALREADY_CANONICAL |

Legend:
- YES — unit is substantially covered in this document
- partial — unit is partially present (framing matches, specific text or sub-element absent)
- — — no coverage in this document

---

## Per-Unit Coverage Detail

### U-01 — Structural Interpretive Gap

**PI-STACK (partial):** §1 states "Strict separation: State, Signal, Meaning occupy distinct zones" and establishes the interpretive gap as the structural premise. The specific accessible prose ("Modern technology organizations generate...") does not appear.

**PIG-NAR (partial):** §What It Is states "structural space between what engineering systems report and what executive leadership needs to govern large technology programs. Not a data gap — an interpretive gap." Matches framing but not the opening prose.

**Coverage gap:** The opening-thesis prose articulation of the problem has no exact canonical counterpart. The governance docs state the structural claim at the assertion level; the research.md unit gives an evidence-level entry point.

---

### U-02 — Visibility Problem: Question-Class Distinction

**PI-STACK (partial):** Establishes interpretive gap framing. Does not enumerate the two question classes explicitly.

**PIG-NAR (partial):** "Engineering systems answer operational questions; executive leadership requires program-level intelligence." Direct structural match. The research.md unit expands this with examples (which tickets, deployments, commits vs. which programs, where risks, whether stable).

**EB-NAR (partial):** §What It Is describes the same structural condition from the failure-mode perspective rather than the question-class perspective.

**Coverage gap:** The enumerated examples of each question class (specific question types for engineering vs. executive) are not in any canonical document.

---

### U-03 — Traditional Tools Contrast (Enumerated Lists)

**EB-NAR (partial):** Covers the structural condition that produces the contrast ("engineering systems are reporting accurately within their design scope — the blindness is structural"). Does not include the specific enumeration (commits/tickets/deployments vs. stability/acceleration/predictability/structural pressure).

**Coverage gap:** The four-item contrast enumeration is not canonicalized anywhere. It is directly derivable from ESI dimensions (delivery_predictability, risk_acceleration_gradient, schedule_stability, flow_compression) and would substantially enrich the execution_blindness narrative's §What It Is section.

---

### U-04 — Gradual Failure Pattern

**EB-NAR (partial):** Canonical definition covers "appears operationally normal while structural instability signals are already emerging." The temporal dimension ("fail gradually — long before leadership realizes it") and the specific phrase "accumulating beneath the surface" are absent from the canonical narrative.

**Coverage gap:** The temporal framing of gradual failure is important for the execution_blindness entity's public-facing articulation. It is NOT present in the current canonical narrative.

---

### U-05 — Emergence Rationale

**No coverage in any reviewed document.** No existing k-pi governance artifact addresses WHY the Program Intelligence discipline is emerging at this point in time — the argument from scale, complexity, governance gaps, and the availability of execution data.

**Coverage gap:** This is a genuine research-class argument that belongs in a dedicated corpus artifact. The "emergence now" claim is implicitly assumed in the doctrine but never argued.

---

### U-06 — Formal Discipline Definition

**PI-STACK (YES):** "Program Intelligence is the discipline of translating engineering execution into executive insight" — verbatim match in program_intelligence_stack.md §1.

No coverage gap. Already canonical.

---

### U-07 — Comparative Discipline Table

**No coverage in any reviewed document.** The four-row positioning table (Engineering Observability, DevOps Analytics, Business Intelligence, Program Intelligence) with Focus and Audience columns does not appear in any current k-pi governance artifact.

**Coverage gap:** This is a significant gap. The competitive/comparative positioning of Program Intelligence against adjacent disciplines is not formalized anywhere in the doctrine. The table is the most research-paper-distinguishing artifact in the page. Its canonicalization would require CAT review to validate:
1. The claim that PI's focus is "program execution dynamics — the analytical bridge" (claim language check)
2. The audience classification "executive leadership" (consistent with existing doctrine)
3. The placement of DevOps Analytics and Engineering Observability as distinct from PI

---

### U-08 — Three Interpretive Layers Model

**PI-STACK (partial):** §Analytical model states "Three-layer (Observability L1–3, Intelligence L4–6, Executive L7)" — structural match. The L0–L8 canonical layer model is the formalization of the same model.

**PIOS-WP (partial):** §Layered Architecture (L0–L8) is the full canonical representation. The research.md unit is a simplified external representation.

**Coverage gap / flag:** The "Engineering Execution" sub-items name specific source systems: "Jira · Git · CI/CD · Architecture · Service Platforms." This is inconsistent with the source-agnosticism principle established in Stream 40.16 (derivation must not depend on named source systems). Before this unit can be canonicalized, the "Engineering Execution" sub-items must be reformulated as source-agnostic telemetry classes or system categories.

---

### U-09 — Program Structure

**No coverage.** "Program Intelligence reconstructs the true program architecture" is a capability claim with no supporting canonical derivative entity definition. The closest related content is the 40.3 entity catalog (BlueEdge-specific) and ENL chain (evidence navigation), but neither constitutes a canonical definition of "program structure" as a PI discipline construct.

---

### U-10 — Initiative Visibility

**No coverage.** "Leadership requires clear understanding of which initiatives exist, how they progress, and how they contribute to broader program objectives" is not formalized in any current k-pi governance document as a named PI capability.

---

### U-11 — Execution Signals Layer

**CAT-STR (partial):** category_structure_model.md references signal_infrastructure as a structural parent of ESI and RAG. No further canonical content about the signal extraction function itself.

**Coverage gap:** The function description — "Operational delivery patterns contain early indicators of program instability. Program Intelligence extracts signals from engineering activity that highlight structural pressure, delivery divergence and risk propagation" — is precisely the prose that a signal_infrastructure canonical narrative would contain. This is the highest-priority enrichment candidate for the signal_infrastructure entity, which currently has no narrative file.

---

### U-12 — ESI Context Block

**ESI-NAR (YES):** Full canonical coverage in execution_stability_index.md narrative.

**PI-STACK (YES):** Referenced as "composite indicator role in stack architecture."

**CAT-POS (YES):** "Execution Stability Index (ESI) / Class: Execution Signal / Role: Stability Measurement Dimension"

Minor enrichment potential: "that leadership can monitor over time" adds governance consumer framing absent from current canonical.

---

### U-13 — RAG Context Block

**RAG-NAR (YES):** Full canonical coverage in risk_acceleration_gradient.md narrative.

**PI-STACK (YES):** Referenced as "dynamics measurement role in stack architecture."

**CAT-POS (YES):** "Risk Acceleration Gradient (RAG) / Class: Execution Signal / Role: Acceleration Measurement Dimension"

Minor enrichment potential: "risk injection, escalation momentum" are specific process terms absent from the current canonical narrative.

---

## Coverage Summary by Authority Document

| Document | Units Covered (any degree) | Notes |
|----------|---------------------------|-------|
| PI-STACK | U-01, U-02, U-06, U-08, U-12, U-13 | Covers doctrine-level framing and constructs |
| PIOS-WP | U-08 | Covers layer model only |
| ESI-NAR | U-12 | Covers ESI construct fully |
| RAG-NAR | U-13 | Covers RAG construct fully |
| EB-NAR | U-02, U-03, U-04 | Covers failure-mode framing |
| PIG-NAR | U-01, U-02 | Covers structural gap framing |
| CAT-POS | U-11 (partial), U-12, U-13 | Covers derivative entity positioning |
| CAT-CLM | — | Claim boundaries apply to ESI/RAG but no unit is coverage-dependent on this |
| CAT-STR | U-11 (partial) | References signal_infrastructure as structural parent |

**Units with NO coverage in any document:** U-05, U-07, U-09, U-10
**Units with ONLY partial coverage:** U-01, U-02, U-03, U-04, U-08, U-11
**Units with full coverage:** U-06, U-12, U-13
