---
unit: U-10
title: Initiative Visibility
source_page: pages/research.md
source_lines: 89–92
section: From Engineering Execution to Executive Insight / Initiative Visibility
destination_class: CKR_CANDIDATE
proposed_target_entity: initiative_visibility (new derivative entity)
coverage_verdict: NOT_CANONICALIZED
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: PENDING_CKR_ENTRY
---

## Extracted Text

Leadership requires clear understanding of which initiatives exist, how they progress, and how
they contribute to broader program objectives. Program Intelligence maps initiative structures
and delivery progress across engineering domains.

---

## Disposition Notes

No canonical derivative entity exists for `initiative_visibility`. The concept relates to the
ENL (Evidence Navigation Layer) and delivery_telemetry constructs but is not formally named
as a PI capability in any current governance document.

**Entity definition seed (from this unit):**
- Capability: maps initiative structures and delivery progress across engineering domains
- Consumer: executive leadership (requires understanding of which initiatives exist, how they
  progress, and how they contribute to program objectives)
- Three visibility dimensions identified:
  1. Initiative existence (which initiatives exist)
  2. Initiative progress (how they progress)
  3. Initiative contribution (how they contribute to broader program objectives)

**Relationship to program_structure (U-09):**
Initiative visibility presupposes program_structure. You cannot map initiative progress without
first reconstructing the program architecture in which initiatives are defined. The dependency
order is: program_structure → initiative_visibility.

**CKR promotion path:**
1. Create `docs/governance/derivatives/nodes/initiative_visibility.md` with:
   - Entity ID and name
   - Class (visibility capability)
   - Three visibility dimensions
   - Dependency on program_structure entity
   - Relationship to ENL chain (evidence navigation mechanism)
2. Pass projection readiness review
3. Create narrative: `docs/governance/derivatives/narratives/initiative_visibility.md`
4. If a web route `/initiative-visibility/` is planned, update route_source_map.yaml

**Note:** Develop this entity AFTER program_structure (U-09) is canonicalized. The three
visibility dimensions (existence, progress, contribution) are the natural structure for the
initiative_visibility narrative §What It Provides.
