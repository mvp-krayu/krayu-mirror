# Coverage Matrix — Mirror Validation

Last updated: 2026-03-30
Current compile stream: WEB-OPS-04 — Promotion + Mirror Compile

---

## W.4.2 Compile — Snapshot Files → Mirror Pages

| Snapshot File | Mirror Page | Relationship | Route Status |
|--------------|-------------|-------------|--------------|
| program-intelligence.md | pages/program-intelligence.md | REBUILD — full standalone route | Confirmed: krayu.be/program-intelligence |
| pios.md | pages/pios.md | REBUILD — full standalone route | Confirmed: krayu.be/pios |
| execution-stability-index.md | pages/execution-stability-index.md | REBUILD — full standalone route | Confirmed: krayu.be/execution-stability-index |
| risk-acceleration-gradient.md | pages/risk-acceleration-gradient.md | REBUILD — full standalone route | Confirmed: krayu.be/risk-acceleration-gradient |
| portfolio-intelligence.md | pages/portfolio-intelligence.md | REBUILD — full standalone route | Confirmed: krayu.be/portfolio-intelligence |
| program-intelligence-gap.md | pages/program-intelligence-gap.md | EXPAND — anchor section → standalone mirror page | Anchor: krayu.be/program-intelligence#program-intelligence-gap |
| execution-blindness.md | pages/execution-blindness.md | EXPAND — anchor section → standalone mirror page | Anchor: krayu.be/program-intelligence#execution-blindness |
| signal-infrastructure.md | pages/signal-infrastructure.md | EXPAND — anchor section → standalone mirror page | Anchor: krayu.be/program-intelligence#signal-infrastructure |
| manifesto.md | REFERENCE ONLY — no mirror page generated in this run | Input for terminology/positioning | Confirmed: krayu.be/manifesto |

---

## WEB-OPS-04 Compile — Promoted Snapshot → Mirror Pages

Promoted snapshot: 2026-03-30_181500 (rendered_capture)
Source: WEB-EXP-01 additive expansion pages

| Promoted Snapshot File | Mirror Page | Relationship | Route Status |
|-----------------------|-------------|-------------|--------------|
| execution-blindness-examples.md | pages/execution-blindness-examples.md | ADDITIVE — new standalone expansion page | Preview-pending: krayu.be/execution-blindness-examples |
| why-dashboards-fail-programs.md | pages/why-dashboards-fail-programs.md | ADDITIVE — new standalone expansion page | Preview-pending: krayu.be/why-dashboards-fail-programs |
| early-warning-signals-program-failure.md | pages/early-warning-signals-program-failure.md | ADDITIVE — new standalone expansion page | Preview-pending: krayu.be/early-warning-signals-program-failure |

---

## CKR Concept Coverage — Full 11-Page Set

| CKR ID | Concept | Primary Mirror Page | Secondary Coverage | Additive Expansion Coverage |
|--------|---------|--------------------|--------------------|----------------------------|
| CKR-001 | Program Intelligence | program-intelligence.md | pios.md, program-intelligence-gap.md, execution-blindness.md, signal-infrastructure.md | why-dashboards-fail-programs.md, execution-blindness-examples.md, early-warning-signals-program-failure.md |
| CKR-003 | Execution Evidence | signal-infrastructure.md | execution-stability-index.md, risk-acceleration-gradient.md | — |
| CKR-004 | Execution Telemetry | signal-infrastructure.md | execution-stability-index.md, risk-acceleration-gradient.md | — |
| CKR-005 | Execution Signals | signal-infrastructure.md | program-intelligence.md, execution-stability-index.md, risk-acceleration-gradient.md | early-warning-signals-program-failure.md |
| CKR-014 | Execution Stability Index (ESI) | execution-stability-index.md | portfolio-intelligence.md, program-intelligence.md, execution-blindness.md, signal-infrastructure.md | execution-blindness-examples.md, early-warning-signals-program-failure.md, why-dashboards-fail-programs.md |
| CKR-015 | Risk Acceleration Gradient (RAG) | risk-acceleration-gradient.md | portfolio-intelligence.md, program-intelligence.md, execution-blindness.md, signal-infrastructure.md | execution-blindness-examples.md, early-warning-signals-program-failure.md, why-dashboards-fail-programs.md |

---

## Route Validity Check — Full 11-Page Set

| Canonical Used | Confirmed | Basis |
|---------------|-----------|-------|
| krayu.be/program-intelligence | YES | Base44 snapshot route field |
| krayu.be/pios | YES | Base44 snapshot route field |
| krayu.be/execution-stability-index | YES | Base44 snapshot route field |
| krayu.be/risk-acceleration-gradient | YES | Base44 snapshot route field |
| krayu.be/portfolio-intelligence | YES | Base44 snapshot route field |
| krayu.be/program-intelligence#program-intelligence-gap | YES | Snapshot note: named anchor section |
| krayu.be/program-intelligence#execution-blindness | YES | Snapshot note: named anchor section |
| krayu.be/program-intelligence#signal-infrastructure | YES | Snapshot note: named anchor section |
| krayu.be/execution-blindness-examples | PREVIEW-PENDING | Route created via WEB-EXP-01 / Base44 app |
| krayu.be/why-dashboards-fail-programs | PREVIEW-PENDING | Route created via WEB-EXP-01 / Base44 app |
| krayu.be/early-warning-signals-program-failure | PREVIEW-PENDING | Route created via WEB-EXP-01 / Base44 app |

**Zero invented canonical URLs.**

---

## Coverage Summary

| CKR Concept | Primary | Secondary | Additive | Total Pages | Coverage |
|-------------|---------|-----------|----------|-------------|----------|
| CKR-001 Program Intelligence | 1 | 4 | 3 | 8/11 | FULL + EXPANDED |
| CKR-003 Execution Evidence | 1 | 2 | 0 | 3/11 | FULL |
| CKR-004 Execution Telemetry | 1 | 2 | 0 | 3/11 | FULL |
| CKR-005 Execution Signals | 1 | 3 | 1 | 5/11 | FULL + EXPANDED |
| CKR-014 ESI | 1 | 4 | 3 | 8/11 | FULL + EXPANDED |
| CKR-015 RAG | 1 | 4 | 3 | 8/11 | FULL + EXPANDED |

**Coverage: COMPLETE and EXPANDED. All 6 CKR concepts have primary coverage and multi-page secondary reinforcement. WEB-OPS-04 additive pages significantly deepen CKR-001, CKR-014, and CKR-015 coverage.**

---

## WEB-OPS-04-SMOKETEST Compile — 2026-03-30 17:47:16

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-04-SMOKETEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-GAP-CLOSURE-TEST Compile — 2026-03-30 18:03:35

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-GAP-CLOSURE-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-05B-TEST Compile — 2026-03-30 18:19:50

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-05B-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-05B-TEST Compile — 2026-03-30 18:19:58

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-05B-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-05D-TEST Compile — 2026-03-30 18:35:46

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-05D-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-05D-TEST Compile — 2026-03-30 18:35:51

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-05D-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-05D-TEST Compile — 2026-03-30 18:36:29

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-05D-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-05D-TEST Compile — 2026-03-30 18:36:35

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-05D-TEST

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**

---

## WEB-OPS-04 Compile — 2026-03-30 19:49:13

Promoted snapshot: 2026-03-30_181500

### Snapshot Files → Mirror Pages

| Page | Source Snapshot | Class | Route Status | Integrity |
|------|----------------|-------|--------------|-----------|
| early-warning-signals-program-failure.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| execution-blindness-examples.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |
| why-dashboards-fail-programs.md | 2026-03-30_181500 | additive_expansion | preview-pending-publish | rendered_capture |

### Route Validity — WEB-OPS-04

| /early-warning-signals-program-failure | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /execution-blindness-examples | preview-pending-publish | WEB-EXP-01 Base44 route | NO |
| /why-dashboards-fail-programs | preview-pending-publish | WEB-EXP-01 Base44 route | NO |

**Zero invented canonical URLs in this compile run.**
