# Research Canonical Extraction Map

Contract: RESEARCH-CANONICAL-EXTRACTION-01
Source: pages/research.md
Generated: 2026-03-31
Stream: RESEARCH-CANONICAL-EXTRACTION-01

This is an ingestion/mapping artifact. It is NOT a web publishing artifact.
All extracted units are staging material only.

---

## Extraction Method

Source page `pages/research.md` was segmented into 13 atomic conceptual units.
Each unit was mapped to a destination class and a coverage verdict.
No text was rewritten. Formatting cleanup only where required for clarity.

---

## Unit Registry

### U-01 — Structural Interpretive Gap (Opening Thesis)

**Source lines:** 25–27
**Section:** (opening — no heading)

**Extracted text:**
> Modern technology organizations generate vast operational data across repositories, delivery pipelines, architecture domains and enterprise systems. Engineering tools measure activity in detail, yet leadership often struggles to understand what this activity means for the program as a whole.
>
> This disconnect is not a tooling problem. It is a structural interpretive gap between engineering execution and executive decision-making.

**Destination class:** DOCTRINE_CORE
**Proposed target entity:** program_intelligence (top-level doctrine) / program_intelligence_gap
**Coverage verdict:** PARTIALLY_CANONICAL

**Mapping rationale:** The "structural interpretive gap" framing is the canonical premise of the program_intelligence_gap entity. The opening articulation here is accessible prose that partially appears in program_intelligence_stack.md §1–2 and is grounded in pios_investor_narrative.md §1–2 per the program_intelligence_gap narrative. However, the research.md phrasing ("Modern technology organizations generate...") is not present verbatim in any current governance document.

---

### U-02 — Visibility Problem: Question-Class Distinction

**Source lines:** 31–37
**Section:** The Visibility Problem (## heading)

**Extracted text:**
> Engineering systems optimize for delivery workflow. They answer operational questions: which tickets are open, how many deployments occurred, what commits were merged.
>
> Executive leadership requires a different class of question answered: which programs are actually underway, where delivery risks are accumulating, whether execution is structurally stable or drifting toward failure.
>
> **The challenge is interpretive.** Raw engineering telemetry does not speak the language of executive decision-making.

**Destination class:** DOCTRINE_CORE / CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** program_intelligence_gap (primary) / program_intelligence (secondary)
**Coverage verdict:** PARTIALLY_CANONICAL

**Mapping rationale:** The program_intelligence_gap narrative states "structural space between what engineering systems report and what executive leadership needs to govern large technology programs" and "Engineering systems answer operational questions; executive leadership requires program-level intelligence." The research.md unit gives the same structural claim with different phrasing and is more accessible. The specific "question-class" framing (operational questions vs. program-level questions) enriches the existing canonical statement.

---

### U-03 — Traditional Tools Contrast (What Tools Show vs. What PI Reveals)

**Source lines:** 39–51
**Section:** The Visibility Problem / ### What Traditional Tools Show / ### What Program Intelligence Reveals

**Extracted text:**
> ### What Traditional Tools Show
> - Commits merged
> - Tickets closed
> - Deployments running
> - Activity appears normal
>
> ### What Program Intelligence Reveals
> - Execution stability deteriorating
> - Risk acceleration increasing
> - Delivery predictability weakening
> - Structural pressure building

**Destination class:** CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** execution_blindness
**Coverage verdict:** PARTIALLY_CANONICAL

**Mapping rationale:** The execution_blindness narrative states "engineering systems are reporting accurately within their design scope — the blindness is structural, not a malfunction." The specific enumeration of what traditional tools show vs. what PI reveals is a concrete articulation of that structural condition — but this enumeration does not appear in the current execution_blindness narrative. It would directly enrich the §What It Is section. The list items (commits, tickets, deployments vs. stability, acceleration, predictability, structural pressure) map explicitly to the ESI dimensions.

---

### U-04 — Gradual Failure Pattern

**Source lines:** 37–38
**Section:** The Visibility Problem (between ### headings)

**Extracted text:**
> Most technology programs fail gradually — long before leadership realizes it. The program may still appear operationally normal — tickets closing, deployments running, activity appearing normal — while structural instability signals are already accumulating beneath the surface.

**Destination class:** CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** execution_blindness
**Coverage verdict:** PARTIALLY_CANONICAL

**Mapping rationale:** The execution_blindness narrative defines the entity as "Condition in which a technology program appears operationally normal while structural instability signals are already emerging across program dimensions." The research.md formulation adds the temporal framing ("fail gradually — long before leadership realizes it") and the specific phrase "accumulating beneath the surface" — neither of which appears in the current canonical narrative. The temporal dimension is an important enrichment.

---

### U-05 — Emergence Rationale (Why PI Is Emerging Now)

**Source lines:** 53–61
**Section:** Why Program Intelligence Is Emerging Now (## heading)

**Extracted text:**
> Engineering environments now generate continuous execution data across hundreds of services, repositories, delivery pipelines and enterprise platforms. Organizations can observe infrastructure reliability with increasing precision.
>
> Yet program execution itself remains largely opaque to leadership.
>
> As delivery environments scale, traditional governance approaches struggle to maintain visibility over program dynamics. Activity is visible. Meaning is not.
>
> Program Intelligence emerges as a response to this structural shift — providing the interpretive layer required to translate engineering execution into signals that leadership can understand and act upon.

**Destination class:** RES_CORPUS
**Proposed target entity:** program_intelligence (contextual framing section) / future emergence_rationale derivative
**Coverage verdict:** NOT_CANONICALIZED

**Mapping rationale:** No existing k-pi governance document contains an "emergence rationale" — a structured argument for why the Program Intelligence discipline is emerging at this point in time rather than earlier. program_intelligence_stack.md §1 states the interpretive gap but does not address the temporal emergence argument ("as delivery environments scale"). This is a research-class argument that belongs in a dedicated RES_CORPUS artifact rather than in doctrine. It should not be inserted into existing doctrine without review.

---

### U-06 — Formal Discipline Definition

**Source lines:** 63–65
**Section:** Defining Program Intelligence (## heading)

**Extracted text:**
> Program Intelligence is the discipline of translating engineering execution into executive insight. It introduces a structured interpretive layer above engineering systems, transforming operational delivery data into clear signals about program structure, delivery momentum, and emerging execution risk.

**Destination class:** DOCTRINE_CORE
**Proposed target entity:** program_intelligence (canonical definition)
**Coverage verdict:** ALREADY_CANONICAL

**Mapping rationale:** The sentence "Program Intelligence is the discipline of translating engineering execution into executive insight" appears in program_intelligence_stack.md §1 (confirmed) and in `_data/site.json` as `piConceptDescription`. The expanded second sentence partially appears in governance framing but not verbatim. This unit is already canonicalized at the sentence level. The second sentence may serve as a derivative enrichment but does not require new canonical treatment.

---

### U-07 — Comparative Discipline Table

**Source lines:** 67–72
**Section:** Defining Program Intelligence (continuation)

**Extracted text:**
> | Discipline | Focus | Audience |
> |---|---|---|
> | Engineering Observability | System performance & reliability | Engineers |
> | DevOps Analytics | Delivery efficiency within teams | Engineering leaders |
> | Business Intelligence | Commercial & operational outcomes | Business leaders |
> | **Program Intelligence** | **Program execution dynamics — the analytical bridge** | **Executive leadership** |

**Destination class:** DOCTRINE_CORE / RES_CORPUS
**Proposed target entity:** program_intelligence (positioning section) / new canonical positioning table
**Coverage verdict:** NOT_CANONICALIZED

**Mapping rationale:** This four-row comparative table does not appear in any current k-pi governance document reviewed. It provides explicit competitive positioning (vs. Engineering Observability, DevOps Analytics, Business Intelligence). The "analytical bridge" positioning and the audience column are doctrine-level claims that need CAT review before canonicalization. The table is the most research-paper-like artifact in the page — it warrants careful treatment as both RES_CORPUS and potential DOCTRINE_CORE enrichment.

---

### U-08 — Three Interpretive Layers Model (EE → PI → EI)

**Source lines:** 74–82
**Section:** From Engineering Execution to Executive Insight (## heading)

**Extracted text:**
> Engineering activity flows through three interpretive layers:
>
> **Engineering Execution** — Jira · Git · CI/CD · Architecture · Service Platforms
>
> **Program Intelligence** — Program structure · Initiative transparency · Execution signals · Governance models
>
> **Executive Insight** — Program visibility · Delivery risk awareness · Strategic decision support

**Destination class:** DOCTRINE_CORE
**Proposed target entity:** program_intelligence / pios_architecture (L0→L8 canonical layer model representation)
**Coverage verdict:** PARTIALLY_CANONICAL

**Mapping rationale:** program_intelligence_stack.md §Analytical model states "Three-layer (Observability L1–3, Intelligence L4–6, Executive L7)" and the architecture whitepaper defines the full L0–L8 canonical layer model. The research.md three-layer model is a simplified external-facing representation of the same architecture. The specific sub-items under each layer:
- Engineering Execution: "Jira · Git · CI/CD · Architecture · Service Platforms" — NOT in current governance docs (names source systems; violates source-agnosticism at doctrine layer)
- Program Intelligence: "Program structure · Initiative transparency · Execution signals · Governance models" — partially canonical
- Executive Insight: "Program visibility · Delivery risk awareness · Strategic decision support" — not in current governance docs

**Important flag:** The "Engineering Execution" layer lists named source systems (Jira, Git, CI/CD). This conflicts with the source-agnosticism principle of the derivation layer (Stream 40.16). Canonicalization of this unit requires source-agnostic reformulation.

---

### U-09 — Program Structure

**Source lines:** 84–87
**Section:** From Engineering Execution to Executive Insight / ### Program Structure

**Extracted text:**
> Complex engineering environments often evolve organically across repositories, services and teams. Program Intelligence reconstructs the true program architecture, revealing how initiatives, systems and delivery domains relate to each other.

**Destination class:** CKR_CANDIDATE
**Proposed target entity:** program_structure (new derivative entity) / program_intelligence (sub-section)
**Coverage verdict:** NOT_CANONICALIZED

**Mapping rationale:** No canonical derivative entity exists for "program structure" as a named PI construct. The 40.3 entity catalog covers program structure for the BlueEdge subject program but as a reconstruction artifact, not as a doctrine-level capability description. The concept of "reconstructing the true program architecture" is a named capability of PiOS but not yet a defined derivative entity with a canonical narrative. CKR_CANDIDATE classification is appropriate — this warrants a controlled knowledge representation entry before canonical promotion.

---

### U-10 — Initiative Visibility

**Source lines:** 89–92
**Section:** From Engineering Execution to Executive Insight / ### Initiative Visibility

**Extracted text:**
> Leadership requires clear understanding of which initiatives exist, how they progress, and how they contribute to broader program objectives. Program Intelligence maps initiative structures and delivery progress across engineering domains.

**Destination class:** CKR_CANDIDATE
**Proposed target entity:** initiative_visibility (new derivative entity) / program_intelligence (sub-section)
**Coverage verdict:** NOT_CANONICALIZED

**Mapping rationale:** No canonical derivative entity for "initiative visibility" exists in the current governance corpus. The concept relates to the ENL (Evidence Navigation Layer) and delivery_telemetry constructs but is not formally named as a PI capability in any derivative entity definition. Like program structure, this requires CKR treatment before canonical promotion.

---

### U-11 — Execution Signals Layer

**Source lines:** 94–95
**Section:** From Engineering Execution to Executive Insight / ### Execution Signals

**Extracted text:**
> Operational delivery patterns contain early indicators of program instability. Program Intelligence extracts signals from engineering activity that highlight structural pressure, delivery divergence and risk propagation.

**Destination class:** CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** signal_infrastructure
**Coverage verdict:** NOT_CANONICALIZED

**Mapping rationale:** signal_infrastructure is referenced as a structural parent construct in category_structure_model.md (as the parent of ESI and RAG) and is listed as an anchor surface in route_source_map.yaml, but has no canonical narrative in docs/governance/derivatives/narratives/. The research.md unit provides a concise prose definition of the signal extraction function ("extracts signals from engineering activity that highlight structural pressure, delivery divergence and risk propagation") that could seed the signal_infrastructure narrative. The specific named signals — "structural pressure, delivery divergence, risk propagation" — are not yet formally defined as signal categories in any current governance document.

---

### U-12 — ESI Context Block

**Source lines:** 100–101
**Section:** Analytical Constructs (## heading, first construct)

**Extracted text:**
> **Execution Stability Index (ESI)** — Measures the structural stability of a program's execution system. ESI converts multi-dimensional delivery signals into a single composite indicator that leadership can monitor over time.

**Destination class:** CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** execution_stability_index
**Coverage verdict:** ALREADY_CANONICAL

**Mapping rationale:** The execution_stability_index narrative already states "Composite structural stability indicator. Converts multi-dimensional execution signals into a single 0–100 score measuring whether a program is stable, degrading, or approaching systemic risk." The research.md unit is a simplified public-facing version of the same claim. The phrase "that leadership can monitor over time" adds a governance consumer framing absent from the current canonical narrative. No new entity creation needed; minor enrichment potential only.

---

### U-13 — RAG Context Block

**Source lines:** 102–103
**Section:** Analytical Constructs (## heading, second construct)

**Extracted text:**
> **Risk Acceleration Gradient (RAG)** — Measures how execution risk evolves over time. RAG captures the rate of change and acceleration of risk injection, escalation momentum and propagation across program boundaries.

**Destination class:** CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** risk_acceleration_gradient
**Coverage verdict:** ALREADY_CANONICAL

**Mapping rationale:** The risk_acceleration_gradient narrative already states "Dynamic risk measurement model. Captures how execution risk evolves over time — measuring rate of change, acceleration, and cross-boundary propagation of risk within a program environment." The research.md unit is a simplified public-facing version. "Risk injection, escalation momentum" are specific terms not in the current canonical narrative — minor enrichment potential. No new entity creation needed.

---

## Destination Class Summary

| Class | Count | Units |
|-------|-------|-------|
| DOCTRINE_CORE | 4 | U-01, U-06, U-07, U-08 |
| CAT_DERIVATIVE_ENRICHMENT | 5 | U-02, U-03, U-04, U-11, U-12, U-13 |
| RES_CORPUS | 1 | U-05 |
| CKR_CANDIDATE | 2 | U-09, U-10 |
| GOV_REFERENCE | 0 | — |
| UNMAPPED_GAP | 0 | — |

Note: U-02 is dual-classified (DOCTRINE_CORE / CAT_DERIVATIVE_ENRICHMENT). U-07 is dual-classified (DOCTRINE_CORE / RES_CORPUS). U-08 carries a flag: source-system names in "Engineering Execution" layer violate source-agnosticism — requires reformulation before canonicalization.

---

## Coverage Verdict Summary

| Verdict | Count | Units |
|---------|-------|-------|
| ALREADY_CANONICAL | 2 | U-06, U-12, U-13 |
| PARTIALLY_CANONICAL | 4 | U-01, U-02, U-03, U-04, U-08 |
| NOT_CANONICALIZED | 4 | U-05, U-07, U-09, U-10, U-11 |
| DUPLICATES_EXISTING_AUTHORITY | 0 | — |

Note: U-12 and U-13 are jointly ALREADY_CANONICAL; counted as a pair in the summary above. Actual unique verdict slots: ALREADY_CANONICAL = 3 entries (U-06, U-12, U-13), PARTIALLY_CANONICAL = 5 (U-01, U-02, U-03, U-04, U-08), NOT_CANONICALIZED = 5 (U-05, U-07, U-09, U-10, U-11).
