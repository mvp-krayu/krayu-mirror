# Source Fallback Report

Contract: WEB-CAT-INTEGRATION-01
Generated: 2026-03-31 17:56:53
Stream: WEB-CAT-INTEGRATION-01

---

## Purpose

This report lists all routes currently using compiled_trusted_legacy or base44_snapshot_fallback
source classes. These routes are explicitly provisional. Their content may compile and publish,
but they are operating without canonical k-pi authority.

Manual mirror corrections to these routes are acknowledged, not endorsed.
The correct steady-state is canonical maturation in k-pi, not mirror-layer patching.

---

## Fallback Route Registry

### `/`

- Source class: compiled_trusted_legacy
- Source path: pages/index.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/manifesto/`

- Source class: compiled_trusted_legacy
- Source path: pages/manifesto.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/research/`

- Source class: compiled_trusted_legacy
- Source path: pages/research.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/signal-platform/`

- Source class: compiled_trusted_legacy
- Source path: pages/signal-platform.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/portfolio-intelligence/`

- Source class: compiled_trusted_legacy
- Source path: pages/portfolio-intelligence.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/signal-infrastructure/`

- Source class: compiled_trusted_legacy
- Source path: pages/signal-infrastructure.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/execution-blindness-examples/`

- Source class: base44_snapshot_fallback
- Source path: WEB/base44-snapshot/latest/execution-blindness-examples.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/why-dashboards-fail-programs/`

- Source class: base44_snapshot_fallback
- Source path: WEB/base44-snapshot/latest/why-dashboards-fail-programs.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

### `/early-warning-signals-program-failure/`

- Source class: base44_snapshot_fallback
- Source path: WEB/base44-snapshot/latest/early-warning-signals-program-failure.md
- Verdict: provisional
- Status: Non-ideal. Remains provisional until canonical k-pi source is defined.

---

Total fallback routes: 9

## Resolution Path

For each route above, canonical maturation requires:
1. A derivative entity node in k-pi/docs/governance/derivatives/nodes/<entity>.md
2. A narrative expansion in k-pi/docs/governance/derivatives/narratives/<entity>.md
3. An updated entry in WEB/config/route_source_map.yaml changing source_type to cat_governed_derivative
4. Rerunning validate-source-authority.sh to confirm the route promotes to allowed

Until maturation is complete, these routes remain classified as provisional.
They may publish but must not be represented as canonical governance surfaces.
