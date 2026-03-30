# Contract: External Search Validation

Program: Krayu — Program Intelligence Discipline
Contract type: Operational / External Validation Stage
Governed by: WEB-OPS post-release validation
Last updated: 2026-03-30

---

## Purpose

This contract defines the external validation stage that must run after pages are published and indexed. It governs Search Console checks, URL indexation inspection, and sitemap validation.

External validation is not a pre-publish gate. It is a post-publish confirmation stage. Pages must be live before this stage can produce meaningful results.

---

## Required Environment Variables

### Option A — OAuth2 bearer token (personal account or CI service account)

```bash
export GSC_ACCESS_TOKEN=<token>
```

Acquire via:
```bash
# Personal account with GSC access (interactive):
gcloud auth login
gcloud auth print-access-token

# Application default credentials:
gcloud auth application-default login
gcloud auth application-default print-access-token
```

Token scope required: `https://www.googleapis.com/auth/webmasters.readonly`

Tokens expire after ~1 hour. Refresh before each pipeline run.

### Option B — GCP service account JSON key

```bash
export GSC_SERVICE_ACCOUNT_KEY_FILE=/path/to/service-account.json
```

Setup steps:
1. Create a service account in the GCP project linked to your GSC property
2. Grant it no GCP-level roles (it only needs GSC access)
3. Download the JSON key: `gcloud iam service-accounts keys create key.json --iam-account=<sa-email>`
4. Open Google Search Console → Settings → Users and permissions → Add user
5. Add the service account email (`<name>@<project>.iam.gserviceaccount.com`) as **Restricted** user
6. Set: `export GSC_SERVICE_ACCOUNT_KEY_FILE=/path/to/key.json`

Token acquisition (handled automatically by script):
- Preferred: `gcloud auth activate-service-account` + `gcloud auth print-access-token`
- Fallback: `pip install google-auth` + python3 token acquisition

### Property override

```bash
export GSC_PROPERTY=https://krayu.be/
```

Default if unset: `https://krayu.be/`

---

## Mandatory Query Set

After any new route is published, the following query types must be checked in Search Console:

| Query | Requirement |
|-------|-------------|
| `execution blindness` | Must appear in impressions within 30 days |
| `program intelligence` | Must maintain current position rank |
| `ESI execution stability` | Must appear in impressions within 30 days |
| `execution blindness examples` | Must appear for expansion pages |
| `why dashboards fail programs` | Must appear for expansion pages |

Custom query sets can be loaded from a file (one query per line, `#` comments supported):
```bash
--query-file WEB/config/gsc-queries.txt
```

---

## Mandatory Route Set

Every route published through WEB-EXP series must be inspected post-publish:

| Route | Check Type |
|-------|-----------|
| /execution-blindness-examples | URL inspection + indexation |
| /why-dashboards-fail-programs | URL inspection + indexation |
| /early-warning-signals-program-failure | URL inspection + indexation |
| /program-intelligence/ | Baseline — confirm no regression |
| /execution-stability-index | Baseline — confirm no regression |
| /risk-acceleration-gradient | Baseline — confirm no regression |

Custom route sets can be loaded from a file (one route per line, `#` comments supported):
```bash
--route-file WEB/config/routes-to-inspect.txt
```

---

## Search Console Metrics Required

For each inspected URL:

1. URL is in the index OR is pending indexation (not blocked)
2. Page is not marked `noindex`
3. Canonical is self-referencing (not pointing to wrong URL)
4. No coverage errors (redirect errors, 404, server error)
5. Mobile usability: no critical errors

For existing canonical pages, additionally confirm:

6. No ranking regression in the 30 days following a push cycle
7. Impressions not dropped by >20% week-over-week

---

## URL Inspection Checks Required

For each new route:

1. URL inspection API returns `VERDICT: PASS` or indexation request submitted
2. Page is crawlable (not blocked by robots.txt)
3. Canonical URL matches the live route exactly
4. Google sees the same canonical as declared in `<link rel="canonical">`
5. No HTTP errors detected by inspection

---

## Sitemap Checks Required

1. `/sitemap.xml` exists and is accessible
2. All new routes are present in sitemap
3. All canonical core routes remain in sitemap
4. No removed routes remain in sitemap
5. Sitemap is referenced in `/robots.txt`
6. Sitemap `lastmod` values are updated for newly published routes

---

## Exact Invocation Examples

### Sitemap check (no credentials required)

```bash
bash WEB/scripts/check-sitemap.sh --live --base-url https://krayu.be
```

### URL indexation check — bearer token

```bash
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"
bash WEB/scripts/check-url-indexation.sh \
  --property "https://krayu.be/" \
  --routes "/execution-blindness-examples,/why-dashboards-fail-programs,/early-warning-signals-program-failure"
```

### URL indexation check — service account

```bash
export GSC_SERVICE_ACCOUNT_KEY_FILE=~/.secrets/krayu-gsc-sa.json
bash WEB/scripts/check-url-indexation.sh \
  --property "https://krayu.be/" \
  --route-file WEB/config/routes-to-inspect.txt
```

### Search Console validation — bearer token

```bash
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"
bash WEB/scripts/validate-search-console.sh \
  --property "https://krayu.be/" \
  --start-date 2026-03-01 \
  --end-date 2026-03-30
```

### Search Console validation — service account, custom query file

```bash
export GSC_SERVICE_ACCOUNT_KEY_FILE=~/.secrets/krayu-gsc-sa.json
bash WEB/scripts/validate-search-console.sh \
  --property "https://krayu.be/" \
  --days 30 \
  --query-file WEB/config/gsc-queries.txt
```

### Full pipeline with external validation (stages 1–5 + external)

```bash
export GSC_ACCESS_TOKEN="$(gcloud auth print-access-token)"
bash WEB/scripts/run-webops-pipeline.sh \
  --origin-stream "WEB-EXP-02" \
  --routes "/execution-blindness-examples,/why-dashboards-fail-programs,/early-warning-signals-program-failure" \
  --run-external-check
```

---

## Output Artifact Locations

| Artifact | Location | Written by |
|----------|----------|------------|
| External validation report (markdown) | `docs/mirror-validation/external_validation_report.md` | All 3 scripts (appended) |
| GSC search analytics JSON | `WEB/logs/external-validation/<timestamp>/gsc_report.json` | `validate-search-console.sh` |
| URL indexation JSON | `WEB/logs/external-validation/<timestamp>/indexation_report.json` | `check-url-indexation.sh` |

The `<timestamp>` in JSON output paths is the run timestamp (`YYYY-MM-DD_HHMMSS`), independent of the snapshot timestamp.

The markdown report at `docs/mirror-validation/external_validation_report.md` is append-only — each run adds a new section. It is not reset between runs.

---

## Failure / Not-Configured States

**NOT_CONFIGURED:** Credentials not available. Scripts exit 0. JSON output written with `"status": "NOT_CONFIGURED"`. Markdown report appended with status. Pipeline may proceed but external validation is marked INCOMPLETE.

**FAIL:** URL inspection returns a blocking error (noindex, 404, crawl blocked, redirect error) or Search Console API returns an error. Script exits 1. Pipeline is flagged. Published pages must be investigated before declaring release complete.

**PARTIAL:** Some checks pass, some return inconclusive results (e.g. newly submitted for indexation, 0 impressions on new content). Acceptable for new routes within 7 days of publication. Script exits 0.

---

## Implementation Status

| Script | Status | Requires |
|--------|--------|---------|
| `WEB/scripts/check-sitemap.sh` | ACTIVE — no credentials needed | None |
| `WEB/scripts/check-url-indexation.sh` | ACTIVE — requires credentials | `GSC_ACCESS_TOKEN` or `GSC_SERVICE_ACCOUNT_KEY_FILE` |
| `WEB/scripts/validate-search-console.sh` | ACTIVE — requires credentials | `GSC_ACCESS_TOKEN` or `GSC_SERVICE_ACCOUNT_KEY_FILE` |

---

*Contract authority: WEB-OPS external validation stage | Krayu Program Intelligence Discipline | 2026-03-30*
