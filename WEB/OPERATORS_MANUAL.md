# Operators Manual — WEB-OPS Pipeline

Program: Krayu — Program Intelligence Discipline
Repo: ~/Projects/krayu-mirror
Last updated: 2026-03-30

---

## 1. System Map

```
BASE44 (publishing surface)
  │
  │  MCP push via Claude Code (edit_base44_app)
  ▼
BASE44 PREVIEW (preview-sandbox--68b96d175d7634c75c234194.base44.app)
  │
  │  WEB-OPS-03: extract-base44-pages.js (Playwright Chromium)
  ▼
WEB/base44-snapshot/<YYYY-MM-DD_HHMMSS>/     ← LAYER 1: Historical snapshot (immutable)
  │
  │  WEB-OPS-04: promote-snapshot.sh
  ▼
WEB/base44-snapshot/latest/                   ← LAYER 2: Promoted working input (symlink)
  │
  │  WEB-OPS-04: build-mirror-from-snapshot.sh
  ▼
pages/*.md                                    ← LAYER 3: Compiled mirror output
  │
  │  npx @11ty/eleventy
  ▼
_site/                                        ← LAYER 4: Built site (ephemeral)
  │
  │  Deploy to static host
  ▼
krayu.be (production surface)
  │
  │  WEB-OPS external validation
  ▼
docs/mirror-validation/external_validation_report.md
```

---

## 2. Repo and Directory Roles

| Path | Role | Written by | Read by |
|------|------|-----------|---------|
| `pages/` | Compiled mirror source | `build-mirror-from-snapshot.sh` | Eleventy build |
| `WEB/base44-snapshot/<ts>/` | Immutable historical snapshot | `extract-base44-pages.js` | `promote-snapshot.sh`, operator |
| `WEB/base44-snapshot/latest/` | Current working input (symlink) | `promote-snapshot.sh` | `build-mirror-from-snapshot.sh` |
| `WEB/scripts/` | Pipeline scripts | Operator / contract updates | Pipeline invocations |
| `WEB/contracts/` | Operational contracts | Operator | All pipeline operators |
| `WEB/logs/push-runs/` | Push manifests | Operator (post-push) | Audit, downstream checks |
| `docs/mirror-validation/` | Validation artifacts | `build-mirror-from-snapshot.sh` | Operator, audit |
| `WEB/config/route_source_map.yaml` | Explicit source authority per route | Operator (contract updates only) | `validate-source-authority.sh` |
| `WEB/reports/` | Source authority and CAT gate reports | `validate-source-authority.sh` | Operator, audit |
| `_includes/` | Eleventy layout templates | Operator (structural changes only) | Eleventy build |
| `_data/` | Site data (nav, shared) | Operator | Eleventy build |
| `_site/` | Built site (ephemeral) | Eleventy build | Deploy stage |

---

## 3. Exact Input / Output Flow

```
INPUT: Claude Code MCP session
  → mcp__base44__edit_base44_app(appId, editPrompt)
  → OUTPUT: editor URL, build status, preview URL

INPUT: preview URL + route list
  → node WEB/scripts/extract-base44-pages.js --timestamp <ts>
  → OUTPUT: WEB/base44-snapshot/<ts>/*.md + capture_manifest.md

INPUT: snapshot timestamp
  → bash WEB/scripts/promote-snapshot.sh <ts>
  → OUTPUT: WEB/base44-snapshot/latest → <ts>
             WEB/base44-snapshot/<ts>/promotion_manifest.md

INPUT: WEB/config/route_source_map.yaml + k-pi CAT artifacts
  → bash WEB/scripts/validate-source-authority.sh [called automatically by pipeline]
  → OUTPUT: WEB/reports/source_authority_inventory.md
             WEB/reports/cat_projection_gate_report.md
             WEB/reports/blocked_routes_report.md
             WEB/reports/source_fallback_report.md
             EXIT 0 (all allowed/provisional) | EXIT 1 (CAT-required route blocked)

INPUT: latest/ (via symlink) [only reached if source authority gate passes]
  → bash WEB/scripts/build-mirror-from-snapshot.sh
  → OUTPUT: pages/*.md (compiled pages)
             docs/mirror-validation/hard_validator_report.md
             docs/mirror-validation/compile_manifest.md
             docs/mirror-validation/{authority_scorecard,coverage_matrix,expansion_report,drift_report}.md

INPUT: pages/
  → npx @11ty/eleventy
  → OUTPUT: _site/ (full built site)

INPUT: _site/
  → deploy to host
  → OUTPUT: live routes on krayu.be

INPUT: live routes
  → bash WEB/scripts/validate-search-console.sh
  → bash WEB/scripts/check-url-indexation.sh
  → bash WEB/scripts/check-sitemap.sh --live
  → OUTPUT: docs/mirror-validation/external_validation_report.md
```

---

## 4. Exact Execution Order

Never skip a stage. Never run stages out of order.

```
Stage 1: PUSH
Stage 2: EXTRACT
Stage 3: PROMOTE
Stage 4: SOURCE AUTHORITY GATE  [WEB-CAT-INTEGRATION-01]
Stage 5: COMPILE + INTERNAL VALIDATE
Stage 6: ELEVENTY BUILD
Stage 7: DEPLOY
Stage 8: EXTERNAL VALIDATE
```

Stage 4 (Source Authority Gate) is the CAT enforcement point. It must pass before Stage 5 (compile) is allowed. No page may compile unless its source authority is explicitly declared and passes CAT validation.

---

## 5. Exact Bash Commands

### Stage 1: Push (MCP — not shell)

Use Claude Code with MCP connected to base44.
See: `WEB/scripts/push-base44-expansion.md` (operator wrapper)
After push completes: write push manifest to `WEB/logs/push-runs/`.

### Stage 2: Extract

```bash
cd ~/Projects/krayu-mirror

# Full pipeline (stages 2–4):
bash WEB/scripts/run-webops-pipeline.sh \
  --origin-stream "WEB-EXP-02" \
  --routes "/new-route-1,/new-route-2" \
  --reason "WEB-EXP-02 additive expansion"

# Or stage by stage:
BASE44_ROUTES="/route-1,/route-2" \
BASE44_ORIGIN_STREAM="WEB-EXP-02" \
  node WEB/scripts/extract-base44-pages.js --timestamp 2026-04-01_140000
```

### Stage 3: Promote

```bash
bash WEB/scripts/promote-snapshot.sh 2026-04-01_140000 \
  --reason "First rendered_capture for WEB-EXP-02" \
  --stream "WEB-OPS-04"
```

### Stage 4: Compile

```bash
bash WEB/scripts/build-mirror-from-snapshot.sh \
  --stream "WEB-EXP-02" \
  --mode strict
```

### Stage 5: Eleventy Build

```bash
cd ~/Projects/krayu-mirror
npx @11ty/eleventy
```

### Stage 6: Deploy

Host-specific. For Cloudflare Pages or Netlify:
- Push `_site/` or trigger CI/CD from git commit
- Confirm all routes accessible on krayu.be

### Stage 7: External Validate

See §15 for GSC credential setup before running these commands.

```bash
# Sitemap consistency gate (no credentials required):
bash WEB/scripts/check-sitemap.sh --base-url https://mirror.krayu.be

# Sitemap — also validate live sitemap at https://mirror.krayu.be:
bash WEB/scripts/check-sitemap.sh --live --base-url https://mirror.krayu.be

# Sitemap — permissive mode (log failures but do not block):
bash WEB/scripts/check-sitemap.sh --mode permissive --base-url https://mirror.krayu.be

# URL indexation — bearer token:
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"
bash WEB/scripts/check-url-indexation.sh \
  --property "https://mirror.krayu.be/" \
  --routes "/route-1,/route-2,/route-3"

# URL indexation — service account:
export GSC_SERVICE_ACCOUNT_KEY_FILE=~/.secrets/krayu-gsc-sa.json
bash WEB/scripts/check-url-indexation.sh \
  --property "https://mirror.krayu.be/" \
  --route-file WEB/config/routes-to-inspect.txt

# Search Console validation — bearer token:
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"
bash WEB/scripts/validate-search-console.sh \
  --property "https://mirror.krayu.be/" \
  --start-date 2026-03-01 \
  --end-date 2026-03-30

# Search Console validation — service account with custom query file:
export GSC_SERVICE_ACCOUNT_KEY_FILE=~/.secrets/krayu-gsc-sa.json
bash WEB/scripts/validate-search-console.sh \
  --property "https://mirror.krayu.be/" \
  --days 30 \
  --query-file WEB/config/gsc-queries.txt
```

Output artifacts:
- `docs/mirror-validation/external_validation_report.md` (markdown, append-only)
- `WEB/logs/external-validation/<timestamp>/gsc_report.json`
- `WEB/logs/external-validation/<timestamp>/indexation_report.json`

---

## 6. Expected Outputs Per Stage

| Stage | Expected Output | Location |
|-------|----------------|----------|
| Push | Push manifest | `WEB/logs/push-runs/<stream>_<ts>_push_manifest.md` |
| Extract | Snapshot files + capture manifest | `WEB/base44-snapshot/<ts>/` |
| Promote | Symlink + promotion manifest | `WEB/base44-snapshot/latest/` |
| Compile | Mirror pages | `pages/*.md` |
| Compile | Hard validator report | `docs/mirror-validation/hard_validator_report.md` |
| Compile | Compile manifest | `docs/mirror-validation/compile_manifest.md` |
| Compile | 4 validation artifacts | `docs/mirror-validation/{authority_scorecard,coverage_matrix,expansion_report,drift_report}.md` |
| Eleventy | Built site | `_site/` |
| Deploy | Live routes | `https://mirror.krayu.be/<route>` |
| External validate | External validation report | `docs/mirror-validation/external_validation_report.md` |

---

## 7. Validation Gates

| Gate | Pass Condition | Action on Fail |
|------|---------------|----------------|
| Push status | `status = ready` + manifest written | Stop. Do not extract. |
| Extraction | All routes PASS in capture_manifest | Stop. Do not promote. |
| Promotion | All 7 checks PASS | Stop. Do not compile. |
| Compile (strict) | All 10 checks PASS | Stop. Do not build. |
| Hard validators | 0 BLOCKING failures (WARNING accepted) | BLOCKING FAIL: Stop. WARNING: log and continue. |
| External (sitemap) | PASS | FAIL: investigate before release. |
| External (indexation) | PASS or NOT_CONFIGURED | NOT_CONFIGURED: proceed with warning. FAIL: investigate. |
| Eleventy build | Exit code 0 | Stop. Do not deploy. |

---

## 8. Failure Handling

**Push failure (`status = error`):**
- Do not run WEB-OPS-03
- Check Base44 editor for error details
- Re-run push with corrected edit prompt

**Extraction failure (any route FAIL):**
- Inspect `WEB/base44-snapshot/<ts>/capture_manifest.md`
- Verify preview URL is accessible
- Re-run extraction for failed routes

**Promotion failure:**
- Read `WEB/base44-snapshot/<ts>/promotion_manifest.md`
- Resolve reported eligibility failure
- Re-run `promote-snapshot.sh` — idempotent

**Compile failure (strict mode):**
- Read `docs/mirror-validation/compile_manifest.md`
- Read `docs/mirror-validation/hard_validator_report.md`
- Fix the failing page in `pages/` or fix the snapshot
- Re-run `build-mirror-from-snapshot.sh` — idempotent

**Eleventy build failure:**
- Read Eleventy stderr
- Check for malformed frontmatter in `pages/`
- Fix, then re-run `npx @11ty/eleventy`

**Post-deploy 404:**
- Initiate rollback (see §9)

---

## 9. Rollback Handling

**Step 1:** Identify the last known good git commit for `pages/`:
```bash
git log --oneline pages/
```

**Step 2:** Restore prior state:
```bash
git checkout <prior-commit> -- pages/
```

**Step 3:** Rebuild:
```bash
npx @11ty/eleventy
```

**Step 4:** Redeploy `_site/`.

**Step 5:** Purge Cloudflare cache for affected routes.

**Step 6:** Document the rollback in `WEB/logs/push-runs/` as a rollback manifest.

Rollback does NOT alter historical snapshots. Snapshots are immutable.

---

## 10. Preview vs Publish Distinction

| State | Surface | URL Pattern | Indexable |
|-------|---------|-------------|-----------|
| Preview | Base44 preview | `preview-sandbox--*.base44.app?_preview_token=*` | NO |
| Captured | Snapshot folder | Local file only | NO |
| Promoted | latest/ | Local file only | NO |
| Compiled | pages/*.md | Local file only | NO |
| Built | _site/ | Local file only | NO |
| Published | mirror.krayu.be | `https://mirror.krayu.be/<route>` | YES |

A page is NOT live until it exists on `https://mirror.krayu.be/<route>`. None of the intermediate stages constitute publication.

---

## 11. Where Manifests Are Written

| Manifest | Written at | Written by |
|----------|-----------|-----------|
| Push manifest | After Stage 1 — push complete | Operator (manually) |
| Capture manifest | After Stage 2 — extraction complete | `extract-base44-pages.js` |
| Promotion manifest | After Stage 3 — promote complete | `promote-snapshot.sh` |
| Hard validator report | During Stage 4 — compile | `build-mirror-from-snapshot.sh` |
| Compile manifest | During Stage 4 — compile | `build-mirror-from-snapshot.sh` |
| Authority scorecard | During Stage 4 — compile | `build-mirror-from-snapshot.sh` |
| Coverage matrix | During Stage 4 — compile | `build-mirror-from-snapshot.sh` |
| Expansion report | During Stage 4 — compile | `build-mirror-from-snapshot.sh` |
| Drift report | During Stage 4 — compile | `build-mirror-from-snapshot.sh` |
| External validation report | After Stage 7 — external validate | Validation scripts |

---

## 12. Historical vs Working Input vs Final Output

| Layer | Path | Nature | Mutable |
|-------|------|--------|---------|
| Historical | `WEB/base44-snapshot/<ts>/` | Immutable record | NO |
| Working input | `WEB/base44-snapshot/latest/` | Promoted snapshot (symlink) | Only by explicit promotion |
| Compiled output | `pages/` | Mirror-ready source | Updated per compile |
| Build output | `_site/` | Ephemeral | Regenerated per build |
| Published | `krayu.be` | Live | Updated per deploy |

**The compile stage (`pages/`) is the last mutable layer before the build.** Content in `pages/` must always be traceable to a promoted snapshot via the `captured` frontmatter field.

---

## 13. Stage Implementation Status

| Stage | Script | Status |
|-------|--------|--------|
| 1. Push | `WEB/scripts/push-base44-expansion.md` (operator wrapper) | IMPLEMENTED (MCP-mediated) |
| 2. Extract | `WEB/scripts/extract-base44-pages.js` | IMPLEMENTED |
| 3. Promote | `WEB/scripts/promote-snapshot.sh` | IMPLEMENTED |
| 4. Compile + internal validate | `WEB/scripts/build-mirror-from-snapshot.sh` | IMPLEMENTED |
| 4a. Hard validators | (within build script) | IMPLEMENTED (8 validators) |
| 5. Eleventy build | `npx @11ty/eleventy` | AVAILABLE — manual invocation |
| 6. Deploy | Host-specific | NOT_IMPLEMENTED — host not yet configured |
| 7a. Sitemap check | `WEB/scripts/check-sitemap.sh` | IMPLEMENTED |
| 7b. URL indexation | `WEB/scripts/check-url-indexation.sh` | ACTIVE — requires GSC credentials (see §15) |
| 7c. Search Console | `WEB/scripts/validate-search-console.sh` | ACTIVE — requires GSC credentials (see §15) |
| Pipeline runner | `WEB/scripts/run-webops-pipeline.sh` | IMPLEMENTED (stages 2–4) |
| CI workflow | `.github/workflows/webops-build.yml` | IMPLEMENTED — compile + Eleventy + artifact archive |

---

## 14. Contracts Reference

| Contract | Governs | Path |
|----------|---------|------|
| Push Base44 Expansion | Push stage rules | `WEB/contracts/push-base44-expansion.md` |
| External Search Validation | External validation stage | `WEB/contracts/external-search-validation.md` |
| SEO Surface Control | Sitemap, robots.txt, canonical policy | `WEB/contracts/seo-surface-control.md` |
| Eleventy Build | Build system governance | `WEB/contracts/eleventy-build.md` |
| Edge Delivery | DNS, Cloudflare, CDN, redirects | `WEB/contracts/edge-delivery.md` |
| Release Control | Release sequence, rollback, retention | `WEB/contracts/release-control.md` |

---

## 15. GSC Auth Setup

Scripts `check-url-indexation.sh` and `validate-search-console.sh` require one of the following credentials.

### Option A — OAuth2 Bearer Token

Best for: local operator use, one-off runs.

```bash
# Step 1: authenticate (one time)
gcloud auth login

# Step 2: acquire token before each run
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"

# Step 3: verify token works
curl -s -H "Authorization: Bearer $GSC_ACCESS_TOKEN" \
  "https://searchconsole.googleapis.com/webmasters/v3/sites" | python3 -m json.tool | head -20
```

Token expires after ~1 hour. Re-acquire before each pipeline run.

Required scope: `https://www.googleapis.com/auth/webmasters.readonly`

### Option B — GCP Service Account JSON Key

Best for: CI/CD, automated runs, long-lived credential.

```bash
# Step 1: create service account (one time)
gcloud iam service-accounts create krayu-gsc-reader \
  --display-name "Krayu GSC Reader"

# Step 2: download JSON key
gcloud iam service-accounts keys create ~/.secrets/krayu-gsc-sa.json \
  --iam-account krayu-gsc-reader@<your-project>.iam.gserviceaccount.com

# Step 3: add service account to Search Console
# → console.search.google.com → Settings → Users and permissions → Add user
# → Enter: krayu-gsc-reader@<your-project>.iam.gserviceaccount.com
# → Permission: Restricted

# Step 4: set env var
export GSC_SERVICE_ACCOUNT_KEY_FILE=~/.secrets/krayu-gsc-sa.json

# Step 5: verify (requires gcloud or pip install google-auth)
gcloud auth activate-service-account --key-file="$GSC_SERVICE_ACCOUNT_KEY_FILE"
gcloud auth print-access-token
```

The scripts will automatically acquire a token from the key file using:
1. `gcloud auth activate-service-account` + `gcloud auth print-access-token` (preferred)
2. `python3` + `google-auth` package (fallback): `pip install google-auth`

### NOT_CONFIGURED behavior

If neither `GSC_ACCESS_TOKEN` nor `GSC_SERVICE_ACCOUNT_KEY_FILE` is set:
- Scripts exit 0 (non-blocking)
- `"status": "NOT_CONFIGURED"` written to JSON output
- `docs/mirror-validation/indexation_matrix.md` written with all routes marked `NOT_CONFIGURED`
- Markdown report appended with NOT_CONFIGURED status
- Pipeline may proceed with external validation marked INCOMPLETE

---

## 16. Indexation Matrix

### What it is

`docs/mirror-validation/indexation_matrix.md` is the canonical record of each route's actual indexation state. It is the single source of truth for whether a route is in Google's index.

It is written (or overwritten) by `check-url-indexation.sh` on each run.

### How to run

```bash
# Standalone — default route set:
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"
bash WEB/scripts/check-url-indexation.sh --property "https://mirror.krayu.be/"

# Standalone — specific routes:
bash WEB/scripts/check-url-indexation.sh \
  --routes "/execution-blindness-examples,/why-dashboards-fail-programs,/early-warning-signals-program-failure" \
  --property "https://mirror.krayu.be/"

# Standalone — routes from file:
bash WEB/scripts/check-url-indexation.sh \
  --route-file WEB/config/routes-to-inspect.txt \
  --property "https://mirror.krayu.be/"

# As part of compile stage:
bash WEB/scripts/build-mirror-from-snapshot.sh \
  --stream "WEB-EXP-02" \
  --mode strict \
  --run-external-check

# Without credentials (writes NOT_CONFIGURED matrix):
bash WEB/scripts/check-url-indexation.sh --property "https://mirror.krayu.be/"
```

### Four-status classification model

| Status | GSC Signal | Meaning | Expected action |
|--------|-----------|---------|----------------|
| `INDEXED` | verdict=PASS or coverageState=INDEXED or SUBMITTED_AND_INDEXED | Page is confirmed in Google index | None — monitor for ranking |
| `DISCOVERED_NOT_INDEXED` | verdict=NEUTRAL, or coverageState contains NOT_INDEXED, DISCOVERED, CRAWLED, or SUBMITTED | Google knows the page but has not yet indexed it | Normal for new content; re-check after 7–14 days |
| `NOT_FOUND` | verdict=FAIL, or coverageState contains 404, REDIRECT_ERROR, SERVER_ERROR, BLOCKED | Page has a blocking error or cannot be found by Google | Investigate immediately — do not declare release complete |
| `NOT_CONFIGURED` | No GSC credentials | Actual indexation status unknown | Configure GSC credentials and re-run |

### Matrix columns

| Column | Source | Notes |
|--------|--------|-------|
| Route | Route list (arg or default) | e.g. `/execution-blindness-examples` |
| Page Class | `pages/<route>.md` frontmatter `page_class` | e.g. `additive_expansion`, `canonical_core` |
| Canonical Status | `pages/<route>.md` frontmatter `publish_status` | e.g. `preview-pending-publish`, `live` |
| Indexation Status | GSC URL Inspection API (or NOT_CONFIGURED) | Four-state classification |
| Source of Truth | Which system provided the data | GSC URL Inspection API, NOT_CONFIGURED, or API error detail |
| Timestamp | When the check ran | ISO-formatted run timestamp |

### Normal post-publish sequence

```
Day 0 (publish):    DISCOVERED_NOT_INDEXED  ← expected immediately after publish
Day 1–7:            DISCOVERED_NOT_INDEXED  ← Google crawling queue
Day 7–14:           INDEXED                 ← normal indexation window
Day 30+:            INDEXED                 ← if not INDEXED, investigate
```

`NOT_FOUND` at any point after publish = blocking issue. Investigate before next release.

---

## 17. Sitemap Consistency Gate

### What it is

`WEB/scripts/check-sitemap.sh` is a bidirectional consistency gate between `pages/` and `sitemap.xml`. It does not just check that a sitemap exists — it validates that every live page is in the sitemap, and that the sitemap contains no orphan or preview routes.

`docs/mirror-validation/sitemap_consistency_report.md` is written on every run.

### Route normalization

All routes — whether derived from page frontmatter, page filenames, or sitemap `<loc>` entries — are normalized before any comparison. Normalization rules:

| Input | Normalized form |
|-------|----------------|
| `https://mirror.krayu.be/pios/` | `/pios/` |
| `https://krayu.be/pios` | `/pios/` |
| `/pios` | `/pios/` |
| `/index` or `/index/` | `/` |
| `https://mirror.krayu.be/` | `/` |
| `/program-intelligence#execution-blindness` | `/program-intelligence#execution-blindness` (anchor — no trailing slash) |

- **All non-anchor, non-root routes receive a trailing slash.** The validator never fails on a slash mismatch.
- **Root index page** (`pages/index.md`, route `/index`, or sitemap `/`) is always normalized to `/`.
- **Backing-page lookup** uses both canonical-derived routes and filename-based lookup. A sitemap route `/execution-blindness/` is considered backed by `pages/execution-blindness.md` even if that page's canonical points to an anchor on another page.

### How to run

```bash
# Standard pre-deploy check (no credentials required):
bash WEB/scripts/check-sitemap.sh \
  --base-url https://mirror.krayu.be

# With live sitemap fetch:
bash WEB/scripts/check-sitemap.sh \
  --live \
  --base-url https://mirror.krayu.be

# With permissive mode (log but do not block):
bash WEB/scripts/check-sitemap.sh \
  --mode permissive \
  --base-url https://mirror.krayu.be

# With explicit pages dir (defaults to repo pages/):
bash WEB/scripts/check-sitemap.sh \
  --pages-dir pages \
  --base-url https://mirror.krayu.be
```

### Blocking failures and action required

| FAIL condition | Root cause | Action |
|---------------|-----------|--------|
| Live page missing from sitemap | `publish_status=live` page not in `sitemap.xml` | Add route to sitemap, rebuild `_site/`, redeploy |
| Preview page in sitemap | `publish_status=preview-pending-*` page present in `sitemap.xml` | Remove route from sitemap, rebuild, redeploy |
| Orphan sitemap route | Route in sitemap but no `pages/` backing page | Remove orphan from sitemap |
| Malformed sitemap | `sitemap.xml` missing `<urlset>` root | Fix sitemap XML structure |
| robots.txt missing Sitemap reference | `robots.txt` present but no `Sitemap:` line | Add `Sitemap: https://mirror.krayu.be/sitemap.xml` to robots.txt |

### WARN vs FAIL distinction

| Condition | Level | Explanation |
|-----------|-------|-------------|
| Page has no `publish_status` field | WARN | Pre-governance page — add `publish_status` to frontmatter to resolve |
| No sitemap.xml found | WARN | Expected before first Eleventy build + deploy |
| No robots.txt found | WARN | Expected before first deploy |
| Any of the five blocking failures above | FAIL | Must be resolved before release is declared complete |

### sitemap_consistency_report.md columns

| Column | Source | Notes |
|--------|--------|-------|
| Route | `pages/` canonical or filename | Path only (no hostname) |
| Page Class | `pages/` frontmatter `page_class` | e.g. `canonical_core`, `additive_expansion` |
| Publish Status | `pages/` frontmatter `publish_status` | e.g. `live`, `preview-pending-publish`, `unknown` |
| Sitemap Status | Consistency check result | PASS, FAIL, EXCLUDED, NOT_VERIFIED |
| Notes | Reason for status | Human-readable explanation |

---

## 18. Hard Validators

### What causes exit 1

The build script exits 1 (in `--mode strict`) when any **BLOCKING** validator returns FAIL or PARTIAL for any compiled page. Specifically:

| Validator | BLOCKING conditions (exits 1) | WARNING conditions (logs, continues) |
|-----------|-------------------------------|--------------------------------------|
| STRUCTURE | No H1 (FAIL); No H2 or body <20 lines (PARTIAL) | — |
| TERMINOLOGY | Missing required terms (FAIL) | — |
| DEFINITION | page_class=canonical_core on expansion page (FAIL) | Possible redefinition heuristic (PARTIAL) |
| CONTEXT | Canonical anchor link missing (FAIL) | — |
| RELATIONSHIP | — | No cross-links to canonical pages (PARTIAL) |
| STANDALONE | Missing title (FAIL) | Missing description or short body (PARTIAL) |
| METADATA | Missing frontmatter fields — any count (FAIL, PARTIAL) | — |
| LINK | Empty link text or empty href (FAIL) | — |

Exit code: `1` — any BLOCKING failure in strict mode.
Exit code: `0` — all BLOCKING validators pass (WARNING failures do not block).

### How to inspect hard_validator_report.md

```bash
# After a failed build:
cat docs/mirror-validation/hard_validator_report.md

# Quick verdict check:
grep "Overall Verdict" docs/mirror-validation/hard_validator_report.md

# See per-validator counts:
grep -A10 "Per-Validator Summary" docs/mirror-validation/hard_validator_report.md

# See per-page failures only:
grep -E "FAIL|PARTIAL" docs/mirror-validation/hard_validator_report.md | grep -v "^#"
```

### Resolving a BLOCKING failure

| Validator | FAIL/PARTIAL condition | Resolution |
|-----------|----------------------|------------|
| STRUCTURE | No H1 | Check snapshot extraction — body may be truncated or missing |
| STRUCTURE | No H2 or short body | Page content may be incomplete — re-extract from Base44 |
| TERMINOLOGY | Missing required terms | Verify Base44 page content includes Execution Blindness, ESI, RAG |
| DEFINITION | Wrong page_class | Fix page_class frontmatter in snapshot before re-compile |
| CONTEXT | Missing canonical anchor | Verify page body links to /program-intelligence/#execution-blindness |
| STANDALONE | Missing title | Fix title frontmatter in compiled output |
| METADATA | Missing frontmatter fields | Check compile stage — field may not have been extracted from snapshot |
| LINK | Empty href or link text | Fix markdown link syntax in snapshot before re-compile |

### compile_manifest.md — §9 reference

The compile_manifest.md §9 always records the hard validator verdict with counts:

```
## 9. Semantic Hard Validator Verdict

Overall: PASS | FAIL | PASS_WITH_WARNINGS
BLOCKING failures: N
WARNING failures: N
PASS checks: N

Exit behavior: PASS — no blocking failures
             OR: BLOCKED — BLOCKING failure(s) detected
```

---

## 19. CI Workflow

### How to trigger

**Manual (workflow_dispatch):**

Go to GitHub → Actions → "WEB-OPS Build" → Run workflow.

Inputs:
| Input | Default | Options |
|-------|---------|---------|
| `compile_mode` | `strict` | `strict`, `permissive` |
| `origin_stream` | `CI-WEBOPS-BUILD` | Any string — recorded in manifests |
| `run_eleventy` | `true` | `true`, `false` |

**Automatic (push trigger):**

Runs automatically on push to `main` when any of these paths change:
- `pages/**`
- `WEB/base44-snapshot/**`
- `WEB/scripts/**`
- `_includes/**`
- `_data/**`
- `.eleventy.js`
- `package.json`

Push-triggered runs use `origin_stream: CI-WEBOPS-PUSH` and `compile_mode: strict`.

### Workflow stages

| Step | What it does | Blocking |
|------|-------------|---------|
| Checkout | Clone repository | YES |
| Set up Node.js | Install Node 20 + cache npm | YES |
| Install dependencies | `npm ci` | YES |
| Check snapshot | Verify `WEB/base44-snapshot/latest` exists | YES |
| Compile mirror | `build-mirror-from-snapshot.sh` | YES — exits 1 on BLOCKING validator failure |
| Eleventy build | `npx @11ty/eleventy --output=_site` | YES (if `run_eleventy=true`) |
| Verify Eleventy output | Check `_site/` was created | YES (if `run_eleventy=true`) |
| Sitemap check | `check-sitemap.sh --mode permissive` | NO — `continue-on-error: true` |
| Indexation check | `check-url-indexation.sh` | NO — exits 0 when NOT_CONFIGURED |
| Archive validation artifacts | Upload `docs/mirror-validation/` | NO |
| Archive compiled pages | Upload `pages/` | NO |
| Archive built site | Upload `_site/` (if Eleventy ran) | NO |
| Build summary | Print manifest + hard validator verdict | NO |

### Where artifacts appear

After each run, go to: GitHub → Actions → the run → **Artifacts**

| Artifact | Content | Retention |
|----------|---------|-----------|
| `mirror-validation-N` | `docs/mirror-validation/` — all reports including `hard_validator_report.md`, `compile_manifest.md`, `indexation_matrix.md`, `sitemap_consistency_report.md` | 30 days |
| `compiled-pages-N` | `pages/*.md` — compiled mirror pages for this run | 14 days |
| `built-site-N` | `_site/` — full Eleventy output (if `run_eleventy=true`) | 7 days |
| `external-validation-N` | `WEB/logs/external-validation/` — JSON output from indexation + GSC scripts | 30 days |

### What CI does NOT yet cover

| Stage | Status | Notes |
|-------|--------|-------|
| Base44 extraction (WEB-OPS-03) | NOT_IN_CI | Requires Playwright + Base44 preview token — run locally |
| Snapshot promotion | NOT_IN_CI | Run `promote-snapshot.sh` locally before push |
| Deploy to krayu.be | NOT_IN_CI | No host configured — see `WEB/contracts/edge-delivery.md` |
| GSC external validation | NOT_CONFIGURED | Add `GSC_ACCESS_TOKEN` repository secret to activate |
| Search Console validation | NOT_CONFIGURED | Add `GSC_ACCESS_TOKEN` repository secret |

### Secrets required for full external validation

| Secret name | Used by | Status |
|-------------|---------|--------|
| `GSC_ACCESS_TOKEN` | `check-url-indexation.sh`, `validate-search-console.sh` | NOT_CONFIGURED — add to repo secrets to enable |

Without `GSC_ACCESS_TOKEN`, external validation steps run in NOT_CONFIGURED mode and exit 0 (non-blocking). They still write artifacts with `"status": "NOT_CONFIGURED"`.

---

---

## 20. Canonical Tag Wiring

### Source field

The canonical URL for each page is taken from frontmatter at build time by `_includes/base.njk`.

| Priority | Frontmatter field | Used by |
|----------|------------------|---------|
| 1 (preferred) | `canonical` | All pages |
| 2 (fallback) | `canonicalUrl` | Retained for backward compatibility only — no current pages use it |

If neither field is present, no `<link rel="canonical">` tag is emitted.

Template logic in `_includes/base.njk`:
```njk
{% set _canonicalHref = canonical or canonicalUrl %}{% if _canonicalHref %}
<link rel="canonical" href="{{ _canonicalHref }}"/>{% endif %}
```

### Rules

- Do NOT invent canonical values. If a page has no `canonical` or `canonicalUrl` frontmatter, no tag is emitted — this is intentional and correct.
- Do NOT mix source fields within a single page. If both `canonical` and `canonicalUrl` are present, `canonical` wins.
- `og:url` and JSON-LD `url` fields, if added to the template in future, must use the same `canonical or canonicalUrl` resolution logic.

### Remaining body-content CTA link issue

Two pages (`research.md`, `signal-platform.md`) contain CTA block links in their **page bodies** that still point to pre-migration SPA URLs:

- `research/index.html`: `href="https://krayu.be/ProgramIntelligenceResearch"`
- `signal-platform/index.html`: `href="https://krayu.be/Product"`

These are Base44 extraction artifacts in the page body — not frontmatter. They do not affect the canonical tag. Correcting them requires either re-extraction from Base44 or a targeted body edit, which is outside the scope of canonical governance contracts.

### Verification

After any template change, verify canonical tag output:
```bash
cd ~/Projects/krayu-mirror
npx @11ty/eleventy --output=_site
grep -r 'rel="canonical"' _site/*/index.html | head -20
```

No line should contain `canonicalUrl` or an empty `href=""`.

---

## Source Authority Model (WEB-CAT-INTEGRATION-01)

This section documents the source authority model introduced by WEB-CAT-INTEGRATION-01. Every operator must understand these concepts before running the pipeline.

### What Source Authority Means

Every route in the mirror must declare where its content authority comes from. Before WEB-CAT-INTEGRATION-01, pages compiled if a markdown file existed in the snapshot — source was implicit. After WEB-CAT-INTEGRATION-01, source is explicit per route, declared in `WEB/config/route_source_map.yaml`.

### source_type Is a Strict Enum

`source_type` is not a free-text field. It must be exactly one of these four values:

| Value | Meaning |
|-------|---------|
| `canonical_kpi` | Source is a k-pi governance document (architecture, doctrine) |
| `cat_governed_derivative` | Source is a k-pi derivative node/narrative, governed by CAT |
| `base44_snapshot_fallback` | Source is a rendered Base44 capture |
| `compiled_trusted_legacy` | Source is a pages/ file with no upstream k-pi authority |

**Any other value — including `invalid_unmapped`, empty string, or any custom string — is a BLOCKING condition.** The gate will exit 1 and the build will not proceed.

This is not a warning. It is a hard block.

### route_source_map.yaml

**Location:** `WEB/config/route_source_map.yaml`

**Role:** The single source of truth for route → source authority mapping. Every route must have an entry. No implicit sourcing is permitted.

**Authority classes:**

| Class | Meaning | Verdict |
|-------|---------|---------|
| `canonical_kpi` | Source is a k-pi governance document (architecture, doctrine) | allowed (if checks pass) |
| `cat_governed_derivative` | Source is a k-pi derivative node/narrative, CAT-governed | allowed (if checks pass) |
| `base44_snapshot_fallback` | Source is a rendered Base44 capture | provisional |
| `compiled_trusted_legacy` | Source is pages/ with no upstream k-pi authority | provisional |
| `invalid_unmapped` | No source declared | blocked |

**Editing the map:** Only update `route_source_map.yaml` when a route's source authority genuinely changes (e.g., after completing a canonical narrative in k-pi). Do not edit it to unblock routes that should legitimately be blocked.

### CAT Pre-Compile Gate

**What it does:** Before any page compiles, `validate-source-authority.sh` checks:
1. Does the source file exist?
2. If CAT_required: Does the construct appear in `construct_positioning_map.md`?
3. If CAT_required: Is `claim_boundary_model.md` present?
4. If projection_required: Does the construct pass `projection_readiness_gate.md`?

**Where CAT artifacts live:** `~/Projects/repos/k-pi/docs/governance/category/` (6 files)

**Key principle: WEB enforces CAT; WEB does not define CAT.** Do not edit CAT artifacts in the WEB layer. CAT is defined exclusively in k-pi. Any change to claim boundaries, construct positioning, or projection readiness must happen in k-pi first.

### Source Priority Order

When selecting the source for a route, the priority order is:

1. **canonical_kpi** — if a canonical k-pi governance source exists and is mapped, it must dominate
2. **cat_governed_derivative** — if a CAT-governed derivative narrative exists, use it
3. **base44_snapshot_fallback** — only if CAT allows the construct and claim boundaries are enforceable
4. **compiled_trusted_legacy** — temporary explicit class only; never as an implicit default
5. **block** — if none of the above apply

No hidden fallback. No silent source substitution.

### Mutation Testing — Required Verification Method

The source authority gate must be verified by mutation test after any change to `validate-source-authority.sh`. The required procedure:

```bash
# 1. Backup the source map
cp WEB/config/route_source_map.yaml /tmp/route_source_map.yaml.bak

# 2. Mutate the first cat_governed_derivative entry
#    Change: source_type: cat_governed_derivative
#    To:     source_type: invalid_unmapped

# 3. Run the gate — MUST return exit 1
bash WEB/scripts/validate-source-authority.sh
# Expected: GATE: FAIL, exit code 1, route appears in blocked_routes_report.md

# 4. Restore the original YAML
cp /tmp/route_source_map.yaml.bak WEB/config/route_source_map.yaml

# 5. Run the gate on clean map — MUST return exit 0
bash WEB/scripts/validate-source-authority.sh
# Expected: GATE: PASS, exit code 0, blocked count = 0
```

A gate implementation that returns exit 0 on a mutated (invalid) source map is incorrect. Do not ship it.

### What "Provisional" Means

A route marked **provisional** compiles and may publish. But it is operating without canonical k-pi authority. The content may be correct, but its source is not yet part of the governed truth chain.

Provisional status is not an error. It is an explicit acknowledgment that canonical maturation is incomplete. The fallback source is acknowledged, not endorsed.

**A provisional route should not be treated as canonical.** It should not be cited as a governed output of the program intelligence discipline until its source_type is promoted to canonical_kpi or cat_governed_derivative.

### What "Blocked" Means

A route marked **blocked** must NOT compile. The gate exits 1 regardless of mode.

Blocking conditions (any one is sufficient):
- **A.** `source_type` is missing, empty, or not in the valid enum
- **B.** `source_type` is `canonical_kpi` or `cat_governed_derivative` and the source file is missing from k-pi
- **C.** `CAT_required: true` and `source_type: cat_governed_derivative` and the entity is not found in `construct_positioning_map.md`
- **D.** `projection_required: true` and the construct does not pass `projection_readiness_gate.md`
- **E.** Route explicitly declares `verdict: blocked` in `route_source_map.yaml`

**Manual mirror correction is not a valid resolution to a blocked route.** The correct resolution is always repairing the source or CAT authority in k-pi, then re-running the pipeline.

Note: Condition C applies only to `cat_governed_derivative` routes. `canonical_kpi` (doctrine-level) routes are not checked against `construct_positioning_map.md` because doctrine constructs are not in the derivative entity positioning model.

### How Derivative Signals Are Handled

ESI (`/execution-stability-index/`) and RAG (`/risk-acceleration-gradient/`) are Category Primitives under the CAT model. They:
- Are classified `cat_governed_derivative` with `CAT_required: true` and `projection_required: true`
- Must pass projection_readiness_gate.md (both confirmed READY as of 2026-03-31, after Stream 40.16)
- Must not exceed `claim_boundary_model.md` claim language
- May not publish as orphan constructs — they must remain positioned under signal_infrastructure
- Are governed by `construct_positioning_map.md` (both classified as Category Primitive, L3, dedicated page allowed)

When canonical maturity is incomplete for a derivative signal, the route must be marked provisional (base44_snapshot_fallback or compiled_trusted_legacy) rather than silently treated as canonical. The system exposes the truth of maturity; it does not hide it.

### What "Manual Page Correction" Means and Why It Is Not Permitted

A **manual page correction** is any direct edit to `pages/*.md` intended to fix content that was pulled from an ungoverned or incorrect source. This practice:
- Fixes the symptom while leaving the root cause (wrong or absent source authority) in place
- Breaks determinism: the next pipeline run will overwrite the correction
- Creates invisible governance debt: no audit trail, no authority binding, no claim boundary enforcement

**Manual page correction is not a valid steady-state operating mode.**

If content in a mirror page is incorrect, the correct resolution path is:
1. Identify the source authority gap (missing canonical source, wrong claim class, ungoverned fallback)
2. Repair the source in k-pi (write the node, narrative, or architecture document)
3. Update `route_source_map.yaml` to declare the repaired source
4. Re-run the pipeline

---

## CAT Source Files Reference

| File | Location | Purpose |
|------|----------|---------|
| `construct_positioning_map.md` | k-pi/docs/governance/category/ | Declares entity class, role, parent, projection depth per construct |
| `claim_boundary_model.md` | k-pi/docs/governance/category/ | Defines allowed and disallowed claim language for derivative signals |
| `projection_schema.md` | k-pi/docs/governance/category/ | Defines projection targets and authority for each domain |
| `projection_readiness_gate.md` | k-pi/docs/governance/category/ | Gates which constructs may be externally projected (READY/not ready) |
| `category_structure_model.md` | k-pi/docs/governance/category/ | Hierarchical category structure for the program intelligence discipline |
| `domain_mapping_model.md` | k-pi/docs/governance/category/ | Maps krayu.be, mirror.krayu.be, product domains to their CAT role |

---

*Operators Manual — WEB-OPS Pipeline | Krayu Program Intelligence | 2026-03-31*
*Updated: WEB-CAT-INTEGRATION-01 — Source Authority Model and CAT Pre-Compile Gate*
