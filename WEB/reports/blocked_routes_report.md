# Blocked Routes Report

Contract: WEB-CAT-INTEGRATION-01
Generated: 2026-03-31 17:50:24
Stream: WEB-CAT-INTEGRATION-01

---

**No routes blocked in this validation run.**

All routes passed or were marked provisional.

---

## Blocking Policy

A route is blocked when ANY of the following are true:

- A. source_type is empty, missing, or not in the valid enum
     Valid enum: canonical_kpi | cat_governed_derivative | base44_snapshot_fallback | compiled_trusted_legacy
- B. source_type is canonical_kpi or cat_governed_derivative AND source file is missing from k-pi
- C. CAT_required=true AND source_type=cat_governed_derivative AND entity not found in construct_positioning_map.md
- D. projection_required=true AND construct does not pass projection_readiness_gate.md
- E. Route verdict explicitly declared 'blocked' in route_source_map.yaml

Manual page correction in pages/ is NOT a valid resolution.
The required resolution is always repairing the source or CAT authority in k-pi.
