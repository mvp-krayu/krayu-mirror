# Contract: Push Base44 Expansion

Program: Krayu — Program Intelligence Discipline
Contract type: Operational / Push Stage / Additive Only
Governed by: WEB-OPS-01 / WEB-EXP series

---

## Purpose

This contract governs every execution of an additive content push to the Base44 application via Claude Code MCP. It defines the rules, inputs, required verification, and manifest obligations for push operations.

A push is the act of creating new pages or adding navigation entries to the Base44 app using the `mcp__base44__edit_base44_app` tool.

---

## Additive-Only Rule

Every push governed by this contract must be additive only.

**Additive operations are permitted:**
- Creating new routes that do not yet exist
- Adding new menu entries after existing entries
- Adding new page sections to pages that currently have none

**The following are forbidden under this contract:**
- Modifying existing page content
- Removing or renaming existing routes
- Changing canonical core page content
- Altering navigation order of existing entries
- Overwriting any page that is listed in the canonical authority set

If a push operation is found to have modified a baseline page, the push must be declared **BASELINE VIOLATION** and immediately reported. Downstream stages (extract, promote, compile) must not run until the violation is resolved.

---

## Baseline Protection Rule

Before any push, the operator must confirm:

1. The target route list contains NO routes from the canonical core set
2. The edit prompt begins with `ADDITIVE ONLY` declaration
3. The edit prompt explicitly states DO NOT MODIFY for protected pages
4. The target app ID matches the correct non-frozen app

**Protected canonical routes (must never be modified by push):**
- /program-intelligence/
- /execution-stability-index
- /risk-acceleration-gradient
- /pios
- /portfolio-intelligence
- /program-intelligence/-gap
- /execution-blindness
- /signal-infrastructure
- /manifesto

**Frozen baseline apps (must never be targeted):**
- Krayu Program Intelligence (Frozen baseline WC-01) — ID: 69ca65ac4d59e0b2cd94a9ce

---

## Target App Field

Every push manifest must record:
- App name
- App ID
- Editor URL

The target app for expansion pushes is:

```
App name: Krayu Program Intelligence
App ID:   68b96d175d7634c75c234194
Editor:   https://app.base44.com/apps/68b96d175d7634c75c234194/editor/preview
```

---

## Route List Field

Every push must declare the exact route list before execution:

- Routes must be in kebab-case
- Routes must not duplicate existing routes
- Routes must be confirmed against current app structure before push
- Routes must be recorded in the push manifest

---

## Navigation Insertion Rule

When a push adds navigation entries:

- New entries must be added AFTER a named existing entry (anchor point required)
- The anchor entry name must be declared before push
- Existing entry order must not change
- Existing entry labels and routes must not change

---

## MCP Execution Expectation

A push is executed via:

```
mcp__base44__edit_base44_app(appId, editPrompt)
```

After calling edit, the operator must:

1. Share the editor URL immediately with the user
2. Poll `mcp__base44__get_app_status` every 30 seconds until status = `ready` or `error`
3. Retrieve the preview URL via `mcp__base44__get_app_preview_url`
4. Record all three (editor URL, preview URL, final status) in the push manifest

If status = `error`, the push is declared **FAILED** and no downstream stages may run.

---

## Required Post-Push Verification

After status = `ready`, the operator must verify:

1. Each new route is accessible from the preview URL
2. Existing canonical routes are NOT returning changed content
3. Navigation menu contains the new entries at the declared position
4. No baseline-protected routes were altered

Verification must be recorded per-route in the push manifest.

---

## Manifest Writing Requirement

Every push run must produce a manifest file at:

```
WEB/logs/push-runs/<stream-name>_<YYYY-MM-DD_HHMMSS>_push_manifest.md
```

The manifest template is at:
```
WEB/logs/push-runs/_template/push_manifest.md
```

A push run without a manifest is incomplete. Downstream WEB-OPS stages must not run from an unmanifested push.

---

*Contract authority: WEB-OPS-01 | Krayu Program Intelligence Discipline | 2026-03-30*
