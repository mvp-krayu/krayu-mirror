---
unit: U-03
title: Traditional Tools Contrast
source_page: pages/research.md
source_lines: 39–51
section: The Visibility Problem / What Traditional Tools Show / What Program Intelligence Reveals
destination_class: CAT_DERIVATIVE_ENRICHMENT
proposed_target_entity: execution_blindness
coverage_verdict: PARTIALLY_CANONICAL
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: PENDING_ENRICHMENT
---

## Extracted Text

### What Traditional Tools Show
- Commits merged
- Tickets closed
- Deployments running
- Activity appears normal

### What Program Intelligence Reveals
- Execution stability deteriorating
- Risk acceleration increasing
- Delivery predictability weakening
- Structural pressure building

---

## Disposition Notes

The execution_blindness narrative states "engineering systems are reporting accurately within
their design scope — the blindness is structural, not a malfunction." This unit provides the
concrete enumeration of that structural condition — what the tools DO show vs. what PI REVEALS
instead.

The four "What PI Reveals" items map explicitly to ESI dimensions:
- Execution stability deteriorating → delivery_predictability / schedule_stability (ESI PES-01)
- Risk acceleration increasing → risk_acceleration_gradient (RAG)
- Delivery predictability weakening → delivery_predictability (ESI PES-03/04)
- Structural pressure building → flow_compression / schedule_stability (ESI composite)

**Enrichment target:** execution_blindness narrative §What It Is — add a concrete enumeration
sub-section after the opening definition. This does not require claim review; the contrast
formulation is definitional of the execution_blindness entity.

**Note:** The "What Traditional Tools Show" list (commits, tickets, deployments) is a factual
description of what current engineering tools measure. No claim boundary concern. The "What
Program Intelligence Reveals" list describes PI output dimensions that are already canonicalized
through ESI and RAG entities.
