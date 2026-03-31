---
unit: U-13
title: RAG Context Block
source_page: pages/research.md
source_lines: 102–103
section: Analytical Constructs (## heading, second construct)
destination_class: CAT_DERIVATIVE_ENRICHMENT
proposed_target_entity: risk_acceleration_gradient
coverage_verdict: ALREADY_CANONICAL
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: CANONICAL — MINOR_ENRICHMENT_ONLY
---

## Extracted Text

**Risk Acceleration Gradient (RAG)** — Measures how execution risk evolves over time. RAG
captures the rate of change and acceleration of risk injection, escalation momentum and
propagation across program boundaries.

---

## Disposition Notes

Full canonical coverage confirmed in:
- risk_acceleration_gradient.md narrative: "Dynamic risk measurement model. Captures how
  execution risk evolves over time — measuring rate of change, acceleration, and cross-boundary
  propagation of risk within a program environment."
- program_intelligence_stack.md: referenced as "dynamics measurement role in stack architecture"
- construct_positioning_map.md: "Risk Acceleration Gradient (RAG) / Class: Execution Signal /
  Role: Acceleration Measurement Dimension"

**Minor enrichment potential:**
Two specific terms in the research.md formulation do not appear in the current canonical narrative:

1. "Risk injection" — describes the source process of risk entering the program. This is more
   specific than "rate of change" in the canonical definition. It is consistent with the RAG
   derivation specification (Stream 40.16) which models risk as a change function across PES
   windows.

2. "Escalation momentum" — describes the intermediate process between injection and propagation.
   This adds a three-stage model (injection → escalation → propagation) that is implicit in RAG
   but not named in the current narrative.

**If enrichment is desired:**
Add to risk_acceleration_gradient narrative §What It Measures:
"RAG tracks the three-stage risk lifecycle: risk injection (entry of new risk signals),
escalation momentum (acceleration within program dimensions), and propagation (cross-boundary
spread)."

**No new entity creation required. No route dependency.**
