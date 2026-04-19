---
layout: base.njk
title: "Early Warning Signals of Program Failure"
description: "⚡ Signal Reference"
canonical: "https://krayu.be/early-warning-signals-program-failure"
publish_status: "live"
page_class: "additive_expansion"
origin_stream: "WEB-EXP-01"
upstream_surface: "Base44"
capture_integrity: "rendered_capture"
captured: "2026-03-30_181500"
---


# Early Warning Signals of Program Failure | Program Intelligence | Krayu

[Program Intelligence](/program-intelligence/)›[Execution Blindness](/program-intelligence/#execution-blindness)

⚡ Signal Reference

# Early Warning Signals of Program Failure

Structural signals that precede operational failure by multiple sprints

These signals emerge before failure is visible in activity metrics. Detecting them requires the Program Intelligence signal infrastructure — not better dashboards, but a governed interpretive layer that transforms execution evidence into structural intelligence. Related: [Execution Blindness](/program-intelligence/#execution-blindness).

ESI Decline Signals

## Execution Stability Index — Decline Patterns

ESI decline signals are the primary structural early warning category. They indicate that the program's ability to sustain its execution is weakening — even when individual operational metrics appear stable.

→**Sustained ESI decline across 2+ consecutive sprints** — a single sprint decline may reflect noise, but sustained decline across two or more consecutive sprints indicates a structural trend, not a transient event.

→**ESI crossing from Compounding Stress into Critical Exposure band** — when ESI crosses below 55, the program has entered the range where systemic failure risk is elevated and board-level intervention is warranted.

→**ESI score velocity increasing** — when the rate of ESI decline is itself accelerating (e.g. −3 points in Sprint 4, −5 points in Sprint 5, −7 points in Sprint 6), the program is losing structural integrity at an increasing rate.

RAG Acceleration Signals

## Risk Acceleration Gradient — Acceleration Signals

RAG signals are the leading indicator category — they frequently precede ESI decline, providing the earliest structural warning. A program with acceptable ESI but accelerating RAG is on a deteriorating trajectory.

→**RAG crossing into positive acceleration territory** — the point at which the rate of risk injection begins increasing sprint-over-sprint. This is the earliest structural signal in the Program Intelligence model.

→**RAG sustaining acceleration for 2+ sprints** — sustained acceleration indicates the program has lost the self-correcting capacity to absorb and resolve incoming risk. Structural intervention is required.

→**RAG acceleration present while ESI still in acceptable range** — this is the critical leading indicator configuration. ESI may still read 65 or 70 while RAG is accelerating. The ESI decline will follow within 2–3 sprints unless structural intervention occurs.

Lead Time Example — Enterprise Digital Transformation

RAG crossed into acceleration at **Sprint 3**. ESI entered Critical Exposure at **Sprint 6**. Operational failure signals became visible at Sprint 6. RAG provided a **3-sprint lead time advantage** over operational visibility — and a lead time advantage over ESI's own critical threshold.

Dimension-Level Signals

## Early Signals Across the Five ESI Dimensions

Each of the five ESI dimensions has its own early warning signal pattern. Dimension-level signals often precede composite ESI decline — monitoring each dimension individually provides additional lead time.

🕐

Schedule Stability

→Buffer compression accelerating — remaining schedule buffer being consumed at an increasing rate

→Milestone drift widening — the gap between planned and actual milestone dates is growing each sprint

→Critical path variance expanding — deviation from planned critical path is increasing across workstreams

💰

Cost Stability

→Variance accumulation increasing — cost variance is compounding even when individual sprint overruns appear small

→Untracked scope expanding — work being performed without corresponding budget authorisation or backlog entries

→Budget compression signals — rate of spend relative to earned value accelerating beyond acceptable bands

⚠️

Risk Acceleration Gradient

→Risk injection rate rising — more new risk items entering the program per sprint than are being resolved

→Cross-boundary propagation beginning — risks originating in one workstream are beginning to appear in adjacent areas

→Escalation momentum building — proportion of risks reaching escalation threshold increasing each sprint

📈

Delivery Predictability

→Cycle time dispersion increasing — the spread between fastest and slowest work items widening across the program

→Forecast reliability decaying — actual delivery outcomes diverging from planned targets across consecutive sprints

→Scope churn accelerating — proportion of backlog items being added, modified, or removed per sprint is rising

⚡

Flow Compression

→WIP variation increasing — work-in-progress levels fluctuating more widely, indicating flow instability

→Bottleneck emergence trends visible — cycle time lengthening in specific pipeline stages or team boundaries

→Release cadence slipping — time between production releases increasing without corresponding scope reduction

Key Insight

## Structural signals precede operational visibility

Across all documented Program Intelligence scenarios, structural signals — ESI decline velocity, RAG acceleration onset, and dimension-level stress patterns — appeared **2 to 4 sprints before failure became operationally visible** in activity metrics, status reports, or budget variance figures.

This lead time is not a marginal improvement. For complex programs, 2–4 sprints represents the difference between structural intervention and reactive crisis management.

Detecting these signals requires the Program Intelligence signal infrastructure.

Not better dashboards. Not more metrics. A governed interpretive layer that transforms execution evidence into structural intelligence — computing ESI and RAG from engineering telemetry and making structural conditions visible before they manifest as operational failures.

[Execution Blindness](/program-intelligence/#execution-blindness)[See Real-World Examples](/execution-blindness-examples) [Execution Stability Index](/execution-stability-index) [Risk Acceleration Gradient](/risk-acceleration-gradient)
