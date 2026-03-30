# Push Manifest — <STREAM NAME>

<!-- Copy this template. Do not edit in-place. Save as: <stream>_<YYYY-MM-DD_HHMMSS>_push_manifest.md -->

---

## Push Metadata

| Field | Value |
|-------|-------|
| Timestamp | YYYY-MM-DD HH:MM:SS |
| Stream name | <!-- e.g. WEB-EXP-02 --> |
| Operator | <!-- Claude Code / WEB-OPS-01 --> |
| App name | Krayu Program Intelligence |
| App ID | 68b96d175d7634c75c234194 |
| Editor URL | <!-- https://app.base44.com/apps/68b96d175d7634c75c234194/editor/preview --> |

---

## Target Routes

| Route | Title | New / Existing |
|-------|-------|---------------|
| /route-name | Page Title | NEW |

---

## Navigation Changes Requested

| Anchor (insert after) | New Entry Label | New Entry Route |
|----------------------|-----------------|----------------|
| Existing Entry Name | New Label | /new-route |

---

## Additive-Only Confirmation

- [ ] Edit prompt opened with `ADDITIVE ONLY` declaration
- [ ] Edit prompt included `Do NOT modify existing pages` instruction
- [ ] No protected canonical routes in target route list
- [ ] No frozen baseline app was targeted

---

## Baseline Touched

Baseline modified: **YES / NO** ← must be NO

If YES: declare BASELINE VIOLATION. Stop all downstream stages immediately.

---

## MCP Execution Record

| Event | Value |
|-------|-------|
| `edit_base44_app` called | YES |
| Editor URL returned | <!-- URL --> |
| Final status polled | ready / error |
| Attempts until ready | <!-- e.g. 6 (at 30s intervals) --> |
| Preview URL retrieved | <!-- URL --> |

---

## Per-Route Verification

| Route | Accessible | Content Match | Canonical Link | Protected Route Check |
|-------|-----------|--------------|---------------|----------------------|
| /route-name | YES/NO | PASS/FAIL | PRESENT/MISSING | NOT MODIFIED |

---

## Downstream Snapshot Reference

| Field | Value |
|-------|-------|
| Extraction timestamp | YYYY-MM-DD_HHMMSS |
| Snapshot path | WEB/base44-snapshot/YYYY-MM-DD_HHMMSS/ |
| Extraction status | PASS/FAIL/PENDING |
| Promoted to latest | YES/NO/PENDING |

---

## Result

**Push result: PASS / FAIL / BASELINE VIOLATION**

---

## Notes

<!-- Any observations, warnings, or deviations from expected behavior -->

---

*Push governed under WEB/contracts/push-base44-expansion.md*
