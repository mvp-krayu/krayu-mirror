# Research Unmapped Canonical Gaps

Contract: RESEARCH-CANONICAL-EXTRACTION-01
Source: pages/research.md
Generated: 2026-03-31

This report identifies units from the research page extraction that have NO coverage in any
current k-pi authority document. These are genuine canonical gaps — not enrichment candidates
for existing documents, but missing doctrine or research artifacts.

---

## Gap Registry

### GAP-01 — Emergence Rationale (U-05)

**Unit:** U-05 — Why Program Intelligence Is Emerging Now
**Source lines:** 53–61
**Destination class:** RES_CORPUS
**Proposed target entity:** program_intelligence (contextual framing) / future emergence_rationale artifact

**Gap description:**
No existing k-pi governance document contains a structured argument for WHY Program Intelligence
as a discipline is emerging at this point in time. The argument in research.md rests on three
premises:

1. Scale: Engineering environments now generate continuous execution data across hundreds of
   services, repositories, delivery pipelines and enterprise platforms.
2. Precision asymmetry: Infrastructure reliability is observable with increasing precision, while
   program execution remains opaque to leadership.
3. Governance gap: As delivery environments scale, traditional governance approaches struggle to
   maintain visibility over program dynamics.

**What is missing from doctrine:**
program_intelligence_stack.md §1 states the interpretive gap as a structural premise but does not
address the temporal emergence argument. The doctrine implicitly assumes the discipline's emergence
is justified; it does not make the argument. This is the distinction between an assertion and an
argument.

**Gap classification:** RESEARCH_CLASS
A temporal emergence argument is not appropriate for insertion into governance doctrine without
review. It requires a dedicated research artifact that can be cited by doctrine but is not itself
doctrine.

**Recommended disposition:** Create a dedicated RES_CORPUS artifact:
`docs/governance/research/emergence_rationale.md`
This artifact would formalize the scale/precision-asymmetry/governance-gap premises as a citable
evidence base for the discipline's emergence claim.

**Blocking flag:** None. This gap does not block any current route or CAT projection.

---

### GAP-02 — Comparative Discipline Table (U-07)

**Unit:** U-07 — Comparative Discipline Table
**Source lines:** 67–72
**Destination class:** DOCTRINE_CORE / RES_CORPUS (dual)
**Proposed target entity:** program_intelligence (positioning section) / new canonical positioning table

**Gap description:**
The four-row comparative discipline table does not appear in any current k-pi governance document:

| Discipline | Focus | Audience |
|---|---|---|
| Engineering Observability | System performance & reliability | Engineers |
| DevOps Analytics | Delivery efficiency within teams | Engineering leaders |
| Business Intelligence | Commercial & operational outcomes | Business leaders |
| Program Intelligence | Program execution dynamics — the analytical bridge | Executive leadership |

**What is missing from doctrine:**
No k-pi document formally positions Program Intelligence against adjacent disciplines
(Engineering Observability, DevOps Analytics, Business Intelligence). The competitive/comparative
positioning is implicit in CAT artifacts (construct_positioning_map.md, claim_boundary_model.md)
but is never laid out as a structured table.

**Gap classification:** DOCTRINE_CORE_GAP
The "analytical bridge" claim and audience column ("Executive leadership") are doctrine-level
positioning claims that require CAT review before canonical promotion. Three specific CAT
review items:

1. Claim language: "program execution dynamics — the analytical bridge" requires review against
   claim_boundary_model.md to ensure it does not over-claim.
2. Audience classification: "Executive leadership" is consistent with existing doctrine but must
   be confirmed as the canonical term against construct_positioning_map.md.
3. Adjacent discipline placement: DevOps Analytics and Engineering Observability as distinct from
   PI requires confirmation that no claim boundary is crossed.

**Recommended disposition:** Route through CAT review before canonical promotion.
If CAT validates the table, the canonical home is a new section in program_intelligence_stack.md
or a dedicated positioning artifact at `docs/governance/category/discipline_positioning_table.md`.

**Blocking flag:** None. But this is the highest-priority strategic gap in the extraction.
The comparative discipline table is the strongest research-paper-class artifact on the page and
has no governance counterpart.

---

### GAP-03 — Program Structure (U-09)

**Unit:** U-09 — Program Structure
**Source lines:** 84–87
**Destination class:** CKR_CANDIDATE
**Proposed target entity:** program_structure (new derivative entity)

**Gap description:**
The capability claim "Program Intelligence reconstructs the true program architecture, revealing
how initiatives, systems and delivery domains relate to each other" is not formalized in any
current k-pi governance document as a named PI capability.

**What is missing from doctrine:**
- No derivative entity node exists for `program_structure` in docs/governance/derivatives/nodes/
- No narrative exists for `program_structure` in docs/governance/derivatives/narratives/
- The 40.3 entity catalog covers program structure for the BlueEdge subject program as a
  reconstruction artifact, but not as a doctrine-level capability description
- The concept of "reconstructing the true program architecture" is a named PiOS capability but
  is not a defined derivative entity with a canonical narrative

**Gap classification:** CKR_CANDIDATE
Cannot be promoted to canonical doctrine until:
1. A Controlled Knowledge Representation (CKR) entry is created defining the entity
2. The entity passes projection readiness review (projection_readiness_gate.md)
3. The narrative is written and approved

**Recommended disposition:** Create CKR entry:
`docs/governance/derivatives/nodes/program_structure.md`
Then produce narrative:
`docs/governance/derivatives/narratives/program_structure.md`
Then update route_source_map.yaml to promote `/program-structure/` if that route exists or
is planned.

**Blocking flag:** None currently. No web route maps to program_structure. If a route is
created before canonicalization, it would be classified provisional.

---

### GAP-04 — Initiative Visibility (U-10)

**Unit:** U-10 — Initiative Visibility
**Source lines:** 89–92
**Destination class:** CKR_CANDIDATE
**Proposed target entity:** initiative_visibility (new derivative entity)

**Gap description:**
The capability claim "Leadership requires clear understanding of which initiatives exist, how they
progress, and how they contribute to broader program objectives. Program Intelligence maps
initiative structures and delivery progress across engineering domains" is not formalized in any
current k-pi governance document.

**What is missing from doctrine:**
- No derivative entity node exists for `initiative_visibility`
- No narrative exists for `initiative_visibility`
- The concept relates to ENL (Evidence Navigation Layer) and delivery_telemetry constructs but
  is not formally named as a PI capability in any derivative entity definition
- The ENL chain provides the mechanism (evidence navigation) but not the capability description
  as a leadership-facing construct

**Gap classification:** CKR_CANDIDATE
Same promotion path as program_structure. These two entities (program_structure and
initiative_visibility) are structurally related and may warrant development as a pair.

**Recommended disposition:** Create CKR entries and narratives as a paired development:
`docs/governance/derivatives/nodes/initiative_visibility.md`
`docs/governance/derivatives/narratives/initiative_visibility.md`
These should be developed in relation to program_structure, as initiative visibility presupposes
program structure reconstruction.

**Blocking flag:** None currently.

---

### GAP-05 — Signal Infrastructure Narrative (U-11)

**Unit:** U-11 — Execution Signals Layer
**Source lines:** 94–95
**Destination class:** CAT_DERIVATIVE_ENRICHMENT
**Proposed target entity:** signal_infrastructure

**Gap description:**
signal_infrastructure is referenced as a structural parent construct in category_structure_model.md
and listed as an anchor surface in route_source_map.yaml, but has NO canonical narrative in
docs/governance/derivatives/narratives/.

The research.md unit provides:
> "Operational delivery patterns contain early indicators of program instability. Program
> Intelligence extracts signals from engineering activity that highlight structural pressure,
> delivery divergence and risk propagation."

**What is missing from doctrine:**
A signal_infrastructure narrative file. The entity is named in the CAT structure model as the
parent of ESI and RAG, but:
- No narrative defines what signal_infrastructure IS as a capability
- The three named signal categories — "structural pressure, delivery divergence, risk propagation"
  — are not formally defined signal categories in any current governance document
- The L3 derivation specification (Stream 40.16) provides the derivation logic for ESI and RAG
  as outputs of signal extraction but does not produce a named signal_infrastructure entity
  narrative

**Gap classification:** DERIVATIVE_NARRATIVE_GAP
This is different from the CKR_CANDIDATE gaps above. The entity already exists in the CAT
structure (signal_infrastructure is a named construct). What is missing is the narrative file
that defines the entity's function, scope, and relationship to its children (ESI, RAG).

**Recommended disposition:** Create the missing narrative:
`docs/governance/derivatives/narratives/signal_infrastructure.md`
Seed content: the U-11 prose from research.md, reformulated as canonical narrative.
The three signal categories (structural pressure, delivery divergence, risk propagation) should
be formally named as signal dimensions in this narrative.

**Blocking flag:** ACTIVE. `/signal-infrastructure/` in route_source_map.yaml maps to
`compiled_trusted_legacy` (pages/signal-infrastructure.md). The absence of a canonical narrative
means this route cannot promote to `cat_governed_derivative`. This is the highest-priority
gap from the perspective of provisional route resolution.

---

## Gap Summary

| Gap | Unit | Classification | Priority | Blocking? |
|-----|------|----------------|----------|-----------|
| GAP-01 | U-05 — Emergence Rationale | RESEARCH_CLASS | Medium | No |
| GAP-02 | U-07 — Comparative Discipline Table | DOCTRINE_CORE_GAP | High | No |
| GAP-03 | U-09 — Program Structure | CKR_CANDIDATE | Low | No |
| GAP-04 | U-10 — Initiative Visibility | CKR_CANDIDATE | Low | No |
| GAP-05 | U-11 — Signal Infrastructure Narrative | DERIVATIVE_NARRATIVE_GAP | High | Yes (route) |

---

## Resolution Paths

### Immediate (unblocks routes)

**GAP-05 — signal_infrastructure narrative:**
1. Create `docs/governance/derivatives/nodes/signal_infrastructure.md` (if absent)
2. Create `docs/governance/derivatives/narratives/signal_infrastructure.md`
3. Add signal_infrastructure to projection_readiness_gate.md
4. Update `/signal-infrastructure/` in route_source_map.yaml: source_type → cat_governed_derivative
5. Rerun validate-source-authority.sh

### CAT-gated (requires review before canonical promotion)

**GAP-02 — Comparative Discipline Table:**
1. Submit U-07 to CAT review (claim_boundary_model.md, construct_positioning_map.md)
2. If CAT validates: create canonical positioning table artifact
3. Determine canonical home (program_intelligence_stack.md section or standalone)

### Research corpus (no route dependency)

**GAP-01 — Emergence Rationale:**
1. Create `docs/governance/research/emergence_rationale.md`
2. Document as RES_CORPUS (not doctrine)
3. Reference from program_intelligence_stack.md as contextual support

### CKR development queue (long-form)

**GAP-03 — Program Structure:**
1. CKR entry → projection review → narrative → route
**GAP-04 — Initiative Visibility:**
1. CKR entry → projection review → narrative → route
Note: develop GAP-03 and GAP-04 as a paired set.
