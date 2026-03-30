# Push Base44 Expansion — Operator Wrapper

Type: Versioned operator runbook wrapper
Script class: MCP-mediated (not shell-executable)
Contract: WEB/contracts/push-base44-expansion.md
Manifest template: WEB/logs/push-runs/_template/push_manifest.md

---

## Required Inputs

Before beginning, the operator must have confirmed:

| Input | Required |
|-------|----------|
| Stream name (e.g. WEB-EXP-02) | YES |
| Target app ID | YES — must be 68b96d175d7634c75c234194 |
| Route list (complete, kebab-case) | YES |
| Page titles | YES |
| Content requirements per route | YES |
| Navigation anchor point | YES — the existing entry after which new entries are inserted |
| Navigation labels and routes | YES |
| Additive-only confirmation | YES |
| Baseline check confirmation | YES — no protected routes in route list |

Do not proceed if any required input is missing.

---

## Ordered Actions

### Action 1 — Pre-push baseline check

Verify that the target app is not the frozen baseline.

```
App to target:  68b96d175d7634c75c234194  (Krayu Program Intelligence)
App to NEVER target:  69ca65ac4d59e0b2cd94a9ce  (Frozen baseline WC-01)
```

Verify that no route in the push route list exists in the canonical protected set.

### Action 2 — Compose the edit prompt

The edit prompt must:

1. Open with `ADDITIVE ONLY — do NOT modify any existing pages or navigation entries.`
2. List each new page with: route, title, full content requirements
3. State `Do NOT remove or change any existing nav entries.`
4. Declare the nav anchor point and insertion position
5. Include exact terminology: Execution Blindness, ESI (Execution Stability Index), RAG (Risk Acceleration Gradient) — where applicable

The prompt must not:
- Redefine canonical concepts
- Ask Base44 to modify existing pages
- Ask Base44 to delete routes

### Action 3 — Execute the MCP push

Call:
```
mcp__base44__edit_base44_app(
  appId: "68b96d175d7634c75c234194",
  editPrompt: "<composed prompt>"
)
```

Immediately share the returned `editorUrl` with the user.

### Action 4 — Poll for completion

Call `mcp__base44__get_app_status(appId)` every 30 seconds.

Expected response: `{ "status": "ready" }` or `{ "status": "error" }`

If `status = error`: declare push FAILED. Stop. Do not proceed.

If `status = ready`: proceed to Action 5.

### Action 5 — Retrieve preview URL

Call `mcp__base44__get_app_preview_url(appId)`.

Record the returned preview URL.

### Action 6 — Per-route verification

For each route in the push route list:

1. Confirm route is accessible at `<previewBase><route>?_preview_token=<token>`
2. Confirm page content matches what was requested
3. Confirm canonical link to `/program-intelligence#execution-blindness` (or relevant anchor) is present
4. Confirm page is NOT overwriting an existing protected route

Record status per route: PASS / FAIL / PARTIAL

### Action 7 — Baseline protection check

For each protected route, confirm no content change is detectable.

If any protected route shows changed content: declare BASELINE VIOLATION. Stop all downstream stages.

### Action 8 — Write push manifest

Copy and complete `WEB/logs/push-runs/_template/push_manifest.md`.

Save as:
```
WEB/logs/push-runs/<stream-name>_<YYYY-MM-DD_HHMMSS>_push_manifest.md
```

---

## Expected MCP Interactions

| Call | When |
|------|------|
| `mcp__base44__list_user_apps` | Optional — to confirm app ID before push |
| `mcp__base44__edit_base44_app` | Action 3 |
| `mcp__base44__get_app_status` | Action 4 — repeat until ready/error |
| `mcp__base44__get_app_preview_url` | Action 5 |

---

## Expected Outputs

| Output | Location |
|--------|----------|
| Editor URL | Shared with user immediately after Action 3 |
| Preview URL | Recorded in push manifest |
| Push manifest | WEB/logs/push-runs/<stream>_<ts>_push_manifest.md |
| Per-route verification | Inside push manifest |
| Baseline check result | Inside push manifest |

---

## Post-Run Checks

The following must be TRUE before WEB-OPS-03 (extraction) is triggered:

- [ ] `status = ready` confirmed
- [ ] All target routes accessible from preview URL
- [ ] No protected routes modified
- [ ] Push manifest written
- [ ] Preview URL recorded in manifest

If any check is FALSE: downstream WEB-OPS stages must not run.

---

## Downstream Trigger

When all post-run checks pass, the downstream pipeline is:

```
WEB-OPS-03: extract-base44-pages.js --timestamp <YYYY-MM-DD_HHMMSS>
WEB-OPS-04: promote-snapshot.sh <YYYY-MM-DD_HHMMSS> --reason "..." --stream "<stream>"
WEB-OPS-04: build-mirror-from-snapshot.sh --stream "<stream>"
```

Or via full pipeline:

```bash
bash WEB/scripts/run-webops-pipeline.sh \
  --origin-stream "<stream>" \
  --routes "/route1,/route2,/route3" \
  --reason "<promotion reason>"
```

---

*Operator wrapper — WEB/scripts/push-base44-expansion.md | Governed by WEB/contracts/push-base44-expansion.md*
