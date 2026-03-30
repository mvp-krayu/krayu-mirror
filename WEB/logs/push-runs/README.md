# Push Runs Log

This directory contains manifests for every Base44 MCP push operation.

---

## Structure

```
WEB/logs/push-runs/
  README.md                          — this file
  _template/
    push_manifest.md                 — manifest template (copy, do not edit in-place)
  <stream>_<YYYY-MM-DD_HHMMSS>_push_manifest.md
  ...
```

---

## Naming Convention

Each push manifest is named:

```
<stream-name>_<YYYY-MM-DD_HHMMSS>_push_manifest.md
```

Examples:
```
WEB-EXP-01_2026-03-30_170100_push_manifest.md
WEB-EXP-02_2026-04-01_140500_push_manifest.md
```

---

## Retention Rule

Push manifests are immutable historical records. They must not be deleted, renamed, or modified after the push run is complete.

---

## Relationship to Snapshot Log

Every push manifest must have a corresponding timestamped snapshot in:

```
WEB/base44-snapshot/<YYYY-MM-DD_HHMMSS>/
```

The snapshot timestamp may differ slightly from the push timestamp (extraction runs after push completes). Both timestamps must be recorded in the push manifest.

---

## Governed by

WEB/contracts/push-base44-expansion.md
