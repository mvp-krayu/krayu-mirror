# Provisional Route Classification

Contract: I.6 HARDENING BATCH 02
Generated: 2026-03-31
Stream: WEB-CAT-INTEGRATION-01
Mode: READ-ONLY — DECISION ARTIFACT

Input sources:
- WEB/config/route_source_map.yaml
- WEB/reports/source_authority_inventory.md
- WEB/reports/source_fallback_report.md
- k-pi/docs/governance/derivatives/nodes/*.md (structural role verification)

---

## Classification Rules Applied

- PROMOTE: route represents a missing/incomplete CAT entity; OR structurally required for model coherence; OR feeds other CAT-governed entities
- HOLD: content useful but non-core; does not break CAT if left provisional; acts as explanatory/research/narrative surface
- REMOVE: redundant with canonical content; pure Base44 expansion with no CAT value; marketing/duplicate/low signal

---

Route: /

Current Source Type: compiled_trusted_legacy
Current Source Path: pages/index.md
Reason for Provisional Status: No canonical k-pi source maps to the root homepage construct. Content predates the derivative entity governance model.

Classification: HOLD

Rationale:
- Structural role: navigation entry point — not a discipline construct, not a CAT entity
- CAT dependency: none; the route references canonical entities but is not itself a canonical entity; no "homepage" or "root" entity exists in the CAT graph
- Risk if removed: high — removes the site entry point and navigation hub for all canonical routes
- Risk if left provisional: low — the route makes no doctrine claims; it links to canonical entities that make their own claims; provisional status is the correct steady-state for a compiled navigation surface

Action Required:

IF HOLD:
- justification: A root navigation surface has no meaningful CAT entity to map to. The page aggregates links to canonical constructs — it does not define them. Additionally, the current page content contains source-agnosticism violations (names Jira, Git, DevOps, CI/CD in the three-layer model), which are content-level issues to be addressed in a future page correction — not governance canonicalization issues.
- review_later_in_stream: I.7 — if a formal "discipline entry point" document class is established in k-pi governance, the root route could be promoted to canonical_kpi. Currently no such document class exists.

---

Route: /manifesto/

Current Source Type: compiled_trusted_legacy
Current Source Path: pages/manifesto.md
Reason for Provisional Status: Manifesto predates the CAT governance model. No canonical k-pi source file. Contains product language (Signäl).

Classification: HOLD

Rationale:
- Structural role: discipline-founding authored text — a position statement by the discipline author (Kurt Horrix, 2025); not a derivative entity; not a doctrine definition document
- CAT dependency: none as a governed entity. The manifesto references canonical constructs (program_intelligence_gap, execution_blindness, signal infrastructure, ESI, RAG) but does not constitute a derivative entity in any of those namespaces
- Risk if removed: medium — the manifesto is an important external-facing discipline founding text. Its removal would eliminate the most accessible narrative framing of why the discipline exists. However, the discipline constructs it references are now all CAT-governed and would survive.
- Risk if left provisional: low — the manifesto makes claims within the acknowledged scope of a position statement; it does not make analytical construct claims that could be verified against derivation specifications. Provisional status correctly signals it is authored narrative, not governed derivation.
- Additional consideration: the manifesto contains product-level language ("Krayu's Signäl platform provides the execution signal infrastructure") that cannot be included in a CAT-governed discipline narrative without violating the product/discipline separation enforced by the governance model. Any promotion path requires authoring a clean discipline-only version of the manifesto in k-pi.

Action Required:

IF HOLD:
- justification: The manifesto is authored founding text that predates the governance model and contains product language. No governance document class currently covers "discipline manifesto" or "position statement." Promotion would require either (a) creating such a class in k-pi and authoring a clean discipline-only founding text, or (b) accepting product language into canonical governance — which violates the discipline/product separation.
- review_later_in_stream: I.7 — when/if a discipline_narrative or founding_statement document class is established in k-pi governance.

---

Route: /research/

Current Source Type: compiled_trusted_legacy
Current Source Path: pages/research.md
Reason for Provisional Status: Research page has no canonical k-pi authority source in the derivatives model.

Classification: HOLD

Rationale:
- Structural role: research surface — pre-canonical academic framing of the discipline; serves as the external-facing research/evidence layer that complements the doctrine surfaces
- CAT dependency: none as an entity. The page was systematically processed through CONTRACT RESEARCH-CANONICAL-EXTRACTION-01, which extracted 13 atomic units and classified them for canonical promotion. Those units are being promoted through I.6/I.7 gap closure work. The page itself is the authored source material, not a derivative entity.
- Risk if removed: low-medium — the research page provides external credibility for the discipline framing (research-paper-class positioning). However, the canonical constructs that appear within it (ESI, RAG, execution_blindness, program_intelligence_gap) are all governed and accessible through their own routes.
- Risk if left provisional: low — the research page clearly functions as a research surface (authored academic framing), not as a doctrine source. Provisional status correctly signals this.
- Forward path: as the I.6 extraction units are canonicalized (GAP-01 through GAP-05 and the enrich targets), the research page content will become substantially backed by canonical authority even if the page file itself remains compiled_trusted_legacy.

Action Required:

IF HOLD:
- justification: The research page is explicitly a pre-canonical authored surface. Its canonical value has been extracted through RESEARCH-CANONICAL-EXTRACTION-01 and is being promoted through I.6 gap closures. The page itself is not a CAT entity. Provisional is the correct permanent classification for authored research narrative.
- review_later_in_stream: never — unless the governance model establishes a "research corpus" document class (RES_CORPUS source_type) that could give this page formal provisional-exempt status.

---

Route: /signal-platform/

Current Source Type: compiled_trusted_legacy
Current Source Path: pages/signal-platform.md
Reason for Provisional Status: Product/commercial surface (Signäl). No CAT-governed doctrine source. Contains named source systems.

Classification: HOLD

Rationale:
- Structural role: product surface — describes the Signäl product, which is the productization layer built on top of PiOS (program_intelligence_stack.md §3 explicit). Signäl is not a discipline construct; it is a product that consumes discipline outputs.
- CAT dependency: the signal_platform entity exists in the derivative graph (as the parent of signal_infrastructure) but it is a product node, classified separately from discipline derivative entities. The governance model explicitly distinguishes between "the governed capability" (signal_infrastructure) and "the product surface" (signal_platform). signal_infrastructure is now canonical (GAP-05 closure); signal_platform as product is not subject to the same canonicalization path.
- Risk if removed: medium — the Signäl product page is the commercial surface for the product offering. Its removal would eliminate the product reference for external audiences. The signal-infrastructure route (now canonical) covers the discipline side; signal-platform covers the product side.
- Risk if left provisional: low — product pages are correctly classified as compiled_trusted_legacy. They make product claims (commercial positioning, named source system integration) that cannot and should not be CAT-governed.
- Blocking concern: the page names specific source systems (Jira, Git, DevOps pipelines, ServiceNow, MS Project, SAP) as explicit integration targets. This is appropriate for a product page but would be a source-agnosticism violation if the content were promoted to a discipline narrative.

Action Required:

IF HOLD:
- justification: signal_platform is a product surface by explicit classification in program_intelligence_stack.md §3. The governance model cannot CAT-govern a product commercial page. Signäl's authority is product authority, not discipline authority. provisional (compiled_trusted_legacy) is the correct permanent classification for this route.
- review_later_in_stream: never — product pages are permanently outside the CAT governance scope.

---

Route: /execution-blindness-examples/

Current Source Type: base44_snapshot_fallback
Current Source Path: WEB/base44-snapshot/latest/execution-blindness-examples.md
Reason for Provisional Status: Base44 additive expansion (WEB-EXP-01). No canonical k-pi source. STUB maturity in node file.

Classification: PROMOTE

Rationale:
- Structural role: evidence illustration surface, Phase 1 Category A (Routed Derivative Entity) per nodes/execution_blindness_examples.md; standalone_route; child of execution_blindness
- CAT dependency: yes — formally registered in the derivative graph. Node file exists. Parent: execution_blindness (allowed). Cross-references ESI (allowed) and RAG (allowed). The entity is referenced in the execution_blindness narrative ("execution_blindness →[R] execution_blindness_examples").
- Risk if removed: medium — the examples surface is the primary evidence-illustration layer for the execution_blindness entity. Without it, execution_blindness describes a condition but provides no concrete scenario demonstration. The CAT graph has a gap at depth-2 under execution_blindness if this route is absent.
- Risk if left provisional: medium — the route is currently backed by a Base44 capture that has no authority codes, no k-pi governance, and STUB maturity. This means the canonical execution_blindness entity points (via the dependency map) to a surface that is operating without canonical authority. This is a graph coherence gap.
- Note: STUB maturity in the node file means authority codes are absent and the narrative has not been written. Promotion requires narrative creation, not just YAML update.

Action Required:

IF PROMOTE:
- target_entity: execution_blindness_examples
- required_narrative_file: docs/governance/derivatives/narratives/execution_blindness_examples.md
- positioning_required: yes — add execution_blindness_examples to construct_positioning_map.md (Class: Evidence Illustration Surface / Parent: Execution Blindness)
- projection_required: no — no derivation specification required; illustration surface

---

Route: /why-dashboards-fail-programs/

Current Source Type: base44_snapshot_fallback
Current Source Path: WEB/base44-snapshot/latest/why-dashboards-fail-programs.md
Reason for Provisional Status: Base44 additive expansion (WEB-EXP-01). No canonical k-pi source. STUB maturity in node file.

Classification: PROMOTE

Rationale:
- Structural role: structural analysis surface, Phase 1 Category A (Routed Derivative Entity) per nodes/why_dashboards_fail_programs.md; standalone_route; child of execution_blindness
- CAT dependency: yes — formally registered in the derivative graph. Node file exists. Parent: execution_blindness (allowed). The content addresses a governance-critical question: why do traditional monitoring tools fail to detect program failure? This directly supports the execution_blindness entity by explaining its mechanism and answering the implicit audience question ("if my dashboards look fine, how do I know I have an execution blindness problem?"). The entity feeds into a coherent narrative cluster: execution_blindness → why_dashboards_fail_programs → execution_blindness_examples → early_warning_signals.
- Risk if removed: medium — the "why dashboards fail" framing is the most accessible entry point to the execution_blindness concept for an external audience. Without it, the execution_blindness route makes structural claims without the supporting explanatory layer that makes those claims credible.
- Risk if left provisional: medium — same graph coherence concern as execution_blindness_examples. The dependency map points from execution_blindness to this entity. The entity is currently backed by an unauthored Base44 capture.

Action Required:

IF PROMOTE:
- target_entity: why_dashboards_fail_programs
- required_narrative_file: docs/governance/derivatives/narratives/why_dashboards_fail_programs.md
- positioning_required: yes — add why_dashboards_fail_programs to construct_positioning_map.md (Class: Structural Analysis Surface / Parent: Execution Blindness)
- projection_required: no — no derivation specification required; structural analysis surface

---

Route: /early-warning-signals-program-failure/

Current Source Type: base44_snapshot_fallback
Current Source Path: WEB/base44-snapshot/latest/early-warning-signals-program-failure.md
Reason for Provisional Status: Base44 additive expansion (WEB-EXP-01). No canonical k-pi source. STUB maturity in node file.

Classification: PROMOTE

Rationale:
- Structural role: signal reference index, Phase 1 Category A (Routed Derivative Entity) per nodes/early_warning_signals.md; standalone_route; depth-2 under program_intelligence via execution_stability_index
- CAT dependency: yes — formally registered in the derivative graph. Node file exists. Referenced by execution_stability_index ("execution_stability_index →[R] early_warning_signals"). Cross-referenced by execution_blindness and risk_acceleration_gradient. This is the highest-priority promote among the three Base44 routes: it directly operationalizes the canonical constructs (ESI, RAG) for leadership governance use. Without a canonical signal reference surface, ESI and RAG are defined as analytical constructs but lack their governance application layer — what patterns constitute early warnings, what thresholds trigger intervention, what sequences indicate structural failure approaching.
- Risk if removed: high — early warning signal patterns are the practical governance output of ESI and RAG. Their absence means the canonical constructs (both READY and promoted) lack their forward-facing application reference. The governance model has a gap at the point where analysis becomes actionable for leadership.
- Risk if left provisional: high — this is the strongest coherence argument among all 7 routes. The ESI and RAG entities (fully canonical, projection READY) explicitly reference early_warning_signals in the dependency map. A canonical construct that references a STUB/provisional surface has a downstream authority gap.

Action Required:

IF PROMOTE:
- target_entity: early_warning_signals
- required_narrative_file: docs/governance/derivatives/narratives/early_warning_signals.md
- positioning_required: yes — add early_warning_signals to construct_positioning_map.md (Class: Signal Reference Index / Parent: Execution Stability Index)
- projection_required: no — no derivation specification required; reference index surface

---

## Summary

| Route | Classification | Action |
|-------|----------------|--------|
| `/` | HOLD | Navigation surface. No CAT entity. Permanent provisional. |
| `/manifesto/` | HOLD | Authored founding text with product language. No governance document class available. Review I.7. |
| `/research/` | HOLD | Pre-canonical research surface. Extractions promoted separately. Permanent provisional. |
| `/signal-platform/` | HOLD | Product surface (Signäl). Outside CAT governance scope. Permanent provisional. |
| `/execution-blindness-examples/` | PROMOTE | Phase 1 Category A node exists. Parent (execution_blindness) is canonical. Requires narrative. |
| `/why-dashboards-fail-programs/` | PROMOTE | Phase 1 Category A node exists. Parent (execution_blindness) is canonical. Requires narrative. |
| `/early-warning-signals-program-failure/` | PROMOTE | Phase 1 Category A node exists. Referenced by ESI (canonical). Highest-priority promote. Requires narrative. |

PROMOTE: 3
HOLD: 4
REMOVE: 0

---

## Promote Queue (ordered by priority)

1. `/early-warning-signals-program-failure/` — PRIORITY HIGH
   - target_entity: early_warning_signals
   - narrative: docs/governance/derivatives/narratives/early_warning_signals.md
   - Referenced by ESI (canonical); governance application layer for canonical constructs

2. `/why-dashboards-fail-programs/` — PRIORITY MEDIUM
   - target_entity: why_dashboards_fail_programs
   - narrative: docs/governance/derivatives/narratives/why_dashboards_fail_programs.md
   - Structural analysis supporting execution_blindness (canonical)

3. `/execution-blindness-examples/` — PRIORITY MEDIUM
   - target_entity: execution_blindness_examples
   - narrative: docs/governance/derivatives/narratives/execution_blindness_examples.md
   - Evidence illustration supporting execution_blindness (canonical)

All three require: narrative creation → construct_positioning_map.md update → projection_readiness_gate.md update → route_source_map.yaml update → gate rerun.

## Hold Queue (review schedule)

| Route | Review Stream | Trigger for Promotion |
|-------|-------------|----------------------|
| `/` | I.7 | Establishment of discipline entry-point document class in k-pi governance |
| `/manifesto/` | I.7 | Establishment of discipline_narrative or founding_statement document class; authored clean version without product language |
| `/research/` | never | RES_CORPUS source_type would need to be established in governance model |
| `/signal-platform/` | never | Product pages permanently outside CAT governance scope |
