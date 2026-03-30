---
title: "Risk Acceleration Gradient (RAG) — Program Intelligence | Krayu"
route: "/risk-acceleration-gradient"
source: "https://krayu.be/risk-acceleration-gradient"
snapshot_date: "2026-03-30"
---

# Risk Acceleration Gradient

Understanding how execution risk evolves over time

RAG is the dynamics dimension of Program Intelligence. Where ESI measures where a program stands, RAG measures how fast it is moving — capturing the velocity and acceleration of risk injection, escalation, and cross-program propagation.

---

## What is the Risk Acceleration Gradient?

The Risk Acceleration Gradient (RAG) is a dynamic risk measurement model that captures how execution risk evolves over time within a program environment.

Most traditional risk management approaches measure risk as a static quantity — a point-in-time count of issues, or a fixed probability and impact matrix. RAG takes a fundamentally different approach: it measures the *rate of change* of risk accumulation and the *acceleration* of that rate.

This distinction matters because programs rarely fail from a single large risk event. They fail from the gradual, compounding accumulation of risks that individually appear manageable, but collectively tip the execution system into instability.

> "RAG does not ask how much risk exists. It asks how fast risk is growing — and whether that growth is accelerating."

---

## What RAG Measures

RAG is computed from three observable risk dynamics, each derived from engineering execution telemetry.

### Rate of Change

Measures how quickly new risks are being injected into the program environment per delivery cycle. A rising injection rate — even when individual risks appear low-severity — signals structural pressure building across the program.

### Acceleration of Risk

Measures whether the rate of risk injection is itself increasing. Acceleration is the critical signal — a risk rate that is growing faster each sprint indicates a loss of program self-correction capacity.

### Propagation Across Boundaries

Measures whether risks originating in one workstream, team, or dependency are propagating into adjacent program areas. Cross-boundary propagation is the primary mechanism through which local instability becomes systemic failure.

---

## Relationship to the Execution Stability Index

ESI and RAG are complementary analytical constructs. Together they provide a complete view of execution health — current state and directional dynamics.

### ESI — State

*Where is the program right now?*

ESI measures the current structural stability of the execution system. It is a composite snapshot that tells leadership whether the program is stable, under stress, or in critical exposure at a given point in time.

### RAG — Dynamics

*How fast is the program moving — and in which direction?*

RAG measures the rate and acceleration of risk evolution. A program may have a moderate ESI today, but if RAG is rising sharply, the stability score will deteriorate rapidly — often within one to two delivery cycles.

**ESI alone can be misleading.** A program with ESI 72 appears stable — but if RAG shows accelerating risk injection with cross-boundary propagation, that program is likely to be in the critical band within three sprints.

This is why RAG is embedded as the dynamics dimension within the ESI composite model — to ensure that acceleration is weighted alongside current state in every stability assessment.

---

## RAG in Practice: Risk Acceleration Across Six Sprints

In the same program where ESI declined from 68 to 42, RAG was the earliest and most predictive signal. While the ESI score still appeared in the "emerging instability" band at Sprint 3, RAG had already crossed into acceleration territory.

**Program:** Enterprise Digital Transformation
**Metric:** Active risk exposure index — 6 sprints
**RAG trend:** Accelerating

### Sprint-by-Sprint RAG Signals

| Sprint | Signal | Level |
|---|---|---|
| Sprint 1–2 | Risk injection rate steady at ~8 new items per sprint | Monitor |
| Sprint 3 | Injection rate increasing — 2 cross-boundary dependencies unresolved | Watch |
| Sprint 4–5 | Escalation momentum rising — dependency propagation confirmed | Warning |
| Sprint 6 | RAG dimension score: 28 — acceleration driving ESI to Critical Exposure | Critical |

RAG identified the acceleration of risk in Sprint 3 — three sprints before the ESI score entered Critical Exposure. This lead time is the operational value of dynamics-based measurement.

---

## Related

- https://krayu.be/program-intelligence
- https://krayu.be/execution-stability-index
- https://krayu.be/portfolio-intelligence
