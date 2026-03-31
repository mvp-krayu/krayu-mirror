---
unit: U-11
title: Execution Signals Layer
source_page: pages/research.md
source_lines: 94–95
section: From Engineering Execution to Executive Insight / Execution Signals
destination_class: CAT_DERIVATIVE_ENRICHMENT
proposed_target_entity: signal_infrastructure
coverage_verdict: NOT_CANONICALIZED
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: HIGH_PRIORITY — NARRATIVE_GAP_ACTIVE
---

## Extracted Text

Operational delivery patterns contain early indicators of program instability. Program
Intelligence extracts signals from engineering activity that highlight structural pressure,
delivery divergence and risk propagation.

---

## Disposition Notes

signal_infrastructure is a named construct in category_structure_model.md (structural parent of
ESI and RAG) and an anchor surface in route_source_map.yaml. It has NO canonical narrative.

**This unit provides the seed for the signal_infrastructure narrative.**

**Entity function description (from this unit):**
- Input: operational delivery patterns (containing early indicators of program instability)
- Function: extracts signals from engineering activity
- Output signals: three named categories identified:
  1. Structural pressure
  2. Delivery divergence
  3. Risk propagation

**Note on the three signal categories:**
"Structural pressure, delivery divergence and risk propagation" are not yet formally defined
signal categories in any governance document. They are named here for the first time in
governance-adjacent material. Before canonicalization:
- Structural pressure: maps to ESI composite output (schedule_stability, flow_compression
  components)
- Delivery divergence: maps to delivery_predictability, schedule_stability ESI dimensions
- Risk propagation: maps to RAG_cross (cross-boundary propagation component)

These three categories could become the canonical §Signal Dimensions of the
signal_infrastructure narrative.

**Route dependency — ACTIVE:**
`/signal-infrastructure/` in route_source_map.yaml is currently `compiled_trusted_legacy`.
The absence of a canonical signal_infrastructure narrative is what keeps this route provisional.
This is the highest-priority enrichment action from the perspective of canonical route promotion.

**Recommended next action:**
1. Create `docs/governance/derivatives/nodes/signal_infrastructure.md` (if not already present)
2. Create `docs/governance/derivatives/narratives/signal_infrastructure.md` using this unit
   as seed content, reformulated as canonical narrative
3. Formally define the three signal categories (structural pressure, delivery divergence, risk
   propagation) as §Signal Dimensions
4. Add to projection_readiness_gate.md
5. Update route_source_map.yaml: `/signal-infrastructure/` → cat_governed_derivative
