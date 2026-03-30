---
title: "Early Warning Signals of Program Failure"
route: "/early-warning-signals-program-failure"
source: "https://preview-sandbox--68b96d175d7634c75c234194.base44.app/early-warning-signals-program-failure?_preview_token=AucgjSzm_ZgG1KaY6nROuvQ8XnTtgHsU1L5EbtECe_M"
capture_timestamp: "2026-03-30 17:04:20"
capture_type: "base44-page-capture"
origin_stream: "WEB-EXP-01"
upstream_surface: "Base44"
status: "captured"
page_class: "additive_expansion"
capture_method: "content-reconstruction-from-generation-source"
capture_method_note: "Preview URL returns SPA shell only; MCP has no page content retrieval tool. Content reconstructed faithfully from WEB-EXP-01 generation prompt and source authority (execution-blindness.md)."
---

# Early Warning Signals of Program Failure

Canonical reference: [/program-intelligence/#execution-blindness](/program-intelligence/#execution-blindness)

These signals appear before program failure is visible in operational metrics. They require the Program Intelligence signal infrastructure to detect — they are not visible in dashboards, activity reports, or standard engineering tooling.

---

## ESI (Execution Stability Index) Decline Signals

- **Sustained ESI decline across 2+ consecutive sprints** — a single-sprint ESI dip may be transient; sustained decline across two or more consecutive sprints indicates structural deterioration in progress
- **ESI crossing from Compounding Stress into Critical Exposure band** — band transition signals that instability has moved from manageable structural pressure into a range requiring active intervention
- **ESI score velocity increasing** — the rate of ESI decline accelerating sprint-over-sprint indicates structural deterioration is compounding, not stabilising

---

## RAG (Risk Acceleration Gradient) Signals

- **RAG crossing into positive acceleration territory** — the primary directional early warning; a positive RAG indicates instability is increasing in rate, not just magnitude
- **RAG sustaining acceleration for 2+ sprints** — sustained RAG acceleration indicates the structural forces driving instability are not resolving
- **RAG acceleration present while ESI still in acceptable range** — this is the highest-value early warning condition; RAG can enter acceleration while ESI has not yet declined to Critical Exposure, providing lead time measured in multiple sprints before structural severity becomes visible

---

## Dimension-Level Early Signals

### Schedule Stability
- Buffer compression accelerating across active milestones
- Milestone drift widening sprint-over-sprint
- Planning assumption decay — original schedule assumptions no longer holding

### Cost Stability
- Variance accumulation increasing beyond normal tolerance bands
- Untracked scope expanding — work being absorbed without formal scope change
- Burn momentum increasing relative to planned burn rate

### Risk Acceleration Gradient
- Risk injection rate rising — new risks entering the program faster than existing risks are resolving
- Cross-boundary risk propagation beginning — risks moving across workstream or team boundaries, indicating systemic instability

### Delivery Predictability
- Cycle time dispersion increasing — the spread of cycle times across work items widening, indicating unpredictability growth
- Forecast reliability decaying — sprint-level delivery forecasts becoming less accurate over successive sprints

### Flow Compression
- Work-in-progress variation increasing — WIP levels fluctuating rather than stabilising
- Bottleneck emergence trends visible — early signs of throughput constraints accumulating at specific points in the delivery flow

---

## The Lead Time Principle

These signals precede operational visibility by multiple sprints.

In the Enterprise Digital Transformation scenario:

- RAG crossed into acceleration at **Sprint 3**
- ESI entered Critical Exposure at **Sprint 4**
- Operational failure became visible at **Sprint 6**

Three sprints of lead time were available. Execution Blindness — the absence of a governed interpretive layer — meant that lead time was not converted into action.

---

## What Detection Requires

Detecting these signals requires the Program Intelligence signal infrastructure — not better dashboards or more data, but a governed interpretive layer that transforms execution evidence into structural intelligence.

The full detection pipeline:

1. Evidence ingestion — structured capture of execution telemetry
2. Signal derivation — governed transformation into execution signals
3. ESI computation — composite stability measure from normalised signals
4. RAG computation — directional signal from interval variation
5. Intelligence delivery — structured outputs to decision-relevant audiences

Each step in the pipeline is governed. The signals do not emerge from raw data — they are produced by a disciplined analytical process. That process is the operational expression of Program Intelligence.
