---
title: "Execution Blindness Examples"
route: "/execution-blindness-examples"
source: "https://preview-sandbox--68b96d175d7634c75c234194.base44.app/execution-blindness-examples?_preview_token=AucgjSzm_ZgG1KaY6nROuvQ8XnTtgHsU1L5EbtECe_M"
capture_timestamp: "2026-03-30 17:04:20"
capture_type: "base44-page-capture"
origin_stream: "WEB-EXP-01"
upstream_surface: "Base44"
status: "captured"
page_class: "additive_expansion"
capture_method: "content-reconstruction-from-generation-source"
capture_method_note: "Preview URL returns SPA shell only; MCP has no page content retrieval tool. Content reconstructed faithfully from WEB-EXP-01 generation prompt and source authority (execution-blindness.md)."
---

# Execution Blindness Examples

Canonical reference: [/program-intelligence/#execution-blindness](/program-intelligence/#execution-blindness)

This page presents three real-world program scenarios illustrating Execution Blindness — the condition in which activity metrics appear normal while structural stability is deteriorating. Each scenario includes ESI (Execution Stability Index) and RAG (Risk Acceleration Gradient) interpretation.

---

## Scenario 1: Enterprise Digital Transformation

**Program context:** Large-scale enterprise digital transformation program spanning multiple business units.

**What activity metrics showed:** Commits merged on schedule. Ticket closure rate normal. Deployments running. Sprint reviews reported green. Activity appeared normal throughout the six-sprint period.

**ESI movement:** 68 → 42 (−26 points over 6 sprints)

| Sprint | ESI Score | Band |
|--------|-----------|------|
| S1 | 68 | Compounding Stress |
| S2 | 61 | Compounding Stress |
| S3 | 55 | Compounding Stress |
| S4 | 50 | Critical Exposure |
| S5 | 46 | Critical Exposure |
| S6 | 42 | Critical Exposure |

**RAG interpretation:** RAG crossed into acceleration territory at Sprint 3 — three sprints before ESI entered Critical Exposure. Instability was accelerating structurally while operational metrics remained unremarkable.

**Primary dimension under stress:** Risk Acceleration Gradient (score: 28 at Sprint 6) and Schedule Stability (score: 35 at Sprint 6).

**Dimension breakdown at Sprint 6:**

| Dimension | Score |
|-----------|-------|
| Schedule Stability | 35 |
| Cost Stability | 58 |
| Risk Acceleration Gradient | 28 |
| Delivery Predictability | 44 |
| Flow Compression | 62 |

**Lead time advantage:** RAG detected acceleration at Sprint 3. Operational failure visibility arrived at Sprint 6. ESI and RAG provided a three-sprint lead.

---

## Scenario 2: Cloud Migration Program

**Program context:** Multi-workload cloud migration program with infrastructure dependencies across delivery teams.

**What activity metrics showed:** Deployments running on schedule. Migration checkpoints completing. Velocity metrics holding. No operational alerts raised. Activity appeared normal throughout.

**ESI movement:** 72 → 51 (−21 points over 5 sprints)

| Sprint | ESI Score | Band |
|--------|-----------|------|
| S1 | 72 | Compounding Stress |
| S2 | 65 | Compounding Stress |
| S3 | 59 | Compounding Stress |
| S4 | 54 | Critical Exposure |
| S5 | 51 | Critical Exposure |

**RAG interpretation:** RAG crossed into acceleration territory at Sprint 2 — the earliest onset across the three scenarios. Structural instability began compounding before the ESI score had meaningfully declined.

**Primary dimensions under stress:** Delivery Predictability and Flow Compression. Cycle time dispersion was increasing while WIP variation across workstreams was accumulating. Neither pattern was visible in deployment or velocity dashboards.

**Lead time advantage:** RAG signalled acceleration three sprints before operational visibility. The structural deterioration was fully underway at Sprint 2 while the program reported normal status.

---

## Scenario 3: Regulatory Compliance Platform

**Program context:** Regulatory compliance platform delivery program operating under fixed statutory deadline.

**What activity metrics showed:** Ticket closure rate appeared high. Burndown charts tracking toward target. Activity metrics reported progress. Delivery appeared on track operationally.

**ESI movement:** 65 → 38 (−27 points over 8 sprints)

| Sprint | ESI Score | Band |
|--------|-----------|------|
| S1 | 65 | Compounding Stress |
| S2 | 62 | Compounding Stress |
| S3 | 59 | Compounding Stress |
| S4 | 55 | Compounding Stress |
| S5 | 50 | Critical Exposure |
| S6 | 46 | Critical Exposure |
| S7 | 42 | Critical Exposure |
| S8 | 38 | Critical Exposure |

**RAG interpretation:** RAG entered sustained acceleration at Sprint 4. Backlog growth was outpacing throughput structurally — even while ticket closure rate appeared high at the operational layer. High ticket closure combined with accelerating backlog injection produces the exact Execution Blindness condition: activity looks productive while structural pressure is building.

**Primary dimensions under stress:** Cost Stability (variance accumulation and untracked scope expansion) and Schedule Stability (buffer compression accelerating against the fixed statutory deadline).

**Lead time advantage:** RAG identified acceleration at Sprint 4. ESI entered Critical Exposure at Sprint 5. Operational visibility of delivery risk arrived no earlier than Sprint 6. Four sprints of structural deterioration preceded any operationally visible signal.

---

## Summary: Lead Time Across All Three Scenarios

| Program | RAG Acceleration Onset | ESI Critical Exposure | Operational Visibility | Lead Sprints |
|---------|----------------------|----------------------|----------------------|-------------|
| Enterprise Digital Transformation | Sprint 3 | Sprint 4 | Sprint 6 | 3 |
| Cloud Migration | Sprint 2 | Sprint 4 | Sprint 5 | 3 |
| Regulatory Compliance Platform | Sprint 4 | Sprint 5 | Sprint 6+ | 2–3 |

In every scenario, Execution Blindness concealed structural deterioration that ESI and RAG detected multiple sprints earlier. The lead time is the operational value of evidence-based structural measurement.
