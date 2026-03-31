---
unit: U-09
title: Program Structure
source_page: pages/research.md
source_lines: 84–87
section: From Engineering Execution to Executive Insight / Program Structure
destination_class: CKR_CANDIDATE
proposed_target_entity: program_structure (new derivative entity)
coverage_verdict: NOT_CANONICALIZED
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: PENDING_CKR_ENTRY
---

## Extracted Text

Complex engineering environments often evolve organically across repositories, services and
teams. Program Intelligence reconstructs the true program architecture, revealing how initiatives,
systems and delivery domains relate to each other.

---

## Disposition Notes

No canonical derivative entity exists for `program_structure`. The 40.3 entity catalog covers
program structure for the BlueEdge subject program as a reconstruction artifact, but not as
a doctrine-level capability description.

**Entity definition seed (from this unit):**
- Function: reconstructs the true program architecture of organically-evolved environments
- Input: repositories, services, teams (source-agnostic: execution telemetry across delivery
  domains)
- Output: structural map of how initiatives, systems and delivery domains relate to each other

**CKR promotion path:**
1. Create `docs/governance/derivatives/nodes/program_structure.md` with:
   - Entity ID and name
   - Class (structural reconstruction capability)
   - Function description (seed above)
   - Relationship to parent construct (pios / program_intelligence)
   - Relationship to initiative_visibility (U-10 entity — these are structurally dependent)
2. Pass projection readiness review
3. Create narrative: `docs/governance/derivatives/narratives/program_structure.md`
4. If a web route `/program-structure/` is planned, update route_source_map.yaml

**Dependency note:** initiative_visibility (U-10) presupposes program_structure. Program
structure must be defined before initiative visibility can be formally scoped. Develop these
as a pair (program_structure first, initiative_visibility second).
