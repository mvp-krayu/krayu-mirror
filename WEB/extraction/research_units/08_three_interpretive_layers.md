---
unit: U-08
title: Three Interpretive Layers Model (EE → PI → EI)
source_page: pages/research.md
source_lines: 74–82
section: From Engineering Execution to Executive Insight (## heading)
destination_class: DOCTRINE_CORE
proposed_target_entity: program_intelligence / pios_architecture (L0→L8 canonical layer model)
coverage_verdict: PARTIALLY_CANONICAL
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: BLOCKED — SOURCE_AGNOSTICISM_VIOLATION
---

## Extracted Text

Engineering activity flows through three interpretive layers:

**Engineering Execution** — Jira · Git · CI/CD · Architecture · Service Platforms

**Program Intelligence** — Program structure · Initiative transparency · Execution signals · Governance models

**Executive Insight** — Program visibility · Delivery risk awareness · Strategic decision support

---

## Disposition Notes

The three-layer model is a simplified external representation of the canonical L0–L8 layer
architecture. Partial coverage exists in:
- program_intelligence_stack.md §Analytical model: "Three-layer (Observability L1–3,
  Intelligence L4–6, Executive L7)"
- pios_architecture_whitepaper.md: Full L0–L8 layer model

**BLOCKING FLAG — SOURCE-AGNOSTICISM VIOLATION:**
The "Engineering Execution" layer names specific source systems:
- Jira (project management tool)
- Git (version control)
- CI/CD (pipeline category — acceptable as a category, but named alongside tool names)
- Architecture (ambiguous — could be a system category)
- Service Platforms (acceptable as a category)

This violates the source-agnosticism principle established in Stream 40.16: derivation must
not depend on named source systems. Governance doctrine must not name specific vendor tools as
the canonical source of engineering execution telemetry.

**Required reformulation before canonicalization:**
The "Engineering Execution" sub-items must be replaced with source-agnostic telemetry classes.
Using the TC-01..TC-08 telemetry requirement classes from Stream 40.16 as reference:
- TC-01: Activity Telemetry (replaces: Jira, Git implicitly)
- TC-02: Delivery Telemetry (replaces: CI/CD, deployments)
- TC-03: Architecture Telemetry (reformulation of: Architecture)
- TC-04: System Telemetry (reformulation of: Service Platforms)

Proposed reformulation of the Engineering Execution layer:
"Activity telemetry · Delivery telemetry · Architecture telemetry · System telemetry"

**After reformulation:**
The Program Intelligence and Executive Insight sub-items are partially canonical and can be
promoted with minor review. The full three-layer model is an important external-facing
simplification of the L0–L8 architecture and belongs in doctrine once the source-agnosticism
violation is resolved.
