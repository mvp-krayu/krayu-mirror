---
unit: U-07
title: Comparative Discipline Table
source_page: pages/research.md
source_lines: 67–72
section: Defining Program Intelligence (continuation)
destination_class: DOCTRINE_CORE / RES_CORPUS
proposed_target_entity: program_intelligence (positioning section) / new canonical positioning table
coverage_verdict: NOT_CANONICALIZED
extraction_contract: RESEARCH-CANONICAL-EXTRACTION-01
generated: 2026-03-31
staging_status: PENDING_CAT_REVIEW
---

## Extracted Text

| Discipline | Focus | Audience |
|---|---|---|
| Engineering Observability | System performance & reliability | Engineers |
| DevOps Analytics | Delivery efficiency within teams | Engineering leaders |
| Business Intelligence | Commercial & operational outcomes | Business leaders |
| Program Intelligence | Program execution dynamics — the analytical bridge | Executive leadership |

---

## Disposition Notes

This four-row table does not appear in any current k-pi governance document. It is the most
significant NOT_CANONICALIZED unit in the research page extraction.

**Three CAT review items required before canonicalization:**

1. **Claim language — "the analytical bridge":**
   This phrase must be reviewed against claim_boundary_model.md. "Analytical bridge" positions
   PI as explicitly mediating between engineering analytics (row 1–2) and business analytics
   (row 3). This is a strong comparative claim. If approved, it should become a canonical
   positioning phrase. If not, a softer formulation is needed.

2. **Audience column — "Executive leadership":**
   Consistent with existing doctrine ("executive decision-making," "executive insight") but
   "executive leadership" as the canonical audience label must be confirmed against
   construct_positioning_map.md. No conflict is expected but formal confirmation is required.

3. **Adjacent discipline definitions:**
   The Focus column definitions for Engineering Observability, DevOps Analytics, and Business
   Intelligence are the project's implicit characterizations of those disciplines. These must
   be confirmed as non-defamatory and within the scope of comparative positioning before
   publication as canonical doctrine.

**Recommended canonical home (pending CAT approval):**
Option A: New section in program_intelligence_stack.md — "Discipline Positioning"
Option B: Dedicated artifact `docs/governance/category/discipline_positioning_table.md`
Option B is preferred because CAT governs competitive positioning and the table is a CAT artifact
class (comparative positioning) rather than a stack architecture artifact.

**Strategic note:** This table has the highest external-audience value of all units in the
extraction. It answers the "what is PI vs. BI/observability?" question in a single scannable
artifact. Priority for CAT review is HIGH.
