# Source Fallback Report

Contract: WEB-CAT-INTEGRATION-01
Generated: 2026-03-31 19:57:52
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

---

Total fallback routes: 3

## Resolution Path

For each route above, canonical maturation requires:
1. A derivative entity node in k-pi/docs/governance/derivatives/nodes/<entity>.md
2. A narrative expansion in k-pi/docs/governance/derivatives/narratives/<entity>.md
3. An updated entry in WEB/config/route_source_map.yaml changing source_type to cat_governed_derivative
4. Rerunning validate-source-authority.sh to confirm the route promotes to allowed

Until maturation is complete, these routes remain classified as provisional.
They may publish but must not be represented as canonical governance surfaces.
