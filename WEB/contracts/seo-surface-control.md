# Contract: SEO Surface Control

Program: Krayu — Program Intelligence Discipline
Contract type: Operational / SEO Governance
Governs: sitemap, robots.txt, canonical policy, indexability

---

## Sitemap Ownership

The sitemap is owned by the krayu-mirror repository.

- **Location:** `~/Projects/krayu-mirror/sitemap.xml`
- **Built by:** Eleventy (11ty) build process or manually maintained
- **Format:** Standard XML sitemap
- **Served at:** `https://krayu.be/sitemap.xml`

Rules:
- Every canonical core route must appear in the sitemap
- Additive expansion routes must be added to the sitemap when they are published (not preview-only)
- Preview-pending routes must NOT appear in the sitemap
- Routes with `publish_status: preview-pending-publish` are excluded from sitemap until promotion to live
- The sitemap must be updated as part of every release, not as a separate step

---

## Sitemap Inclusion Rules — Explicit Route Classification

### Routes that MUST be in the sitemap

These routes enter the sitemap when ALL five conditions in §"When Routes Enter Sitemap" are met:

| Route | Page Class | Entry Condition |
|-------|-----------|----------------|
| /program-intelligence | canonical_core | Already live — must remain in sitemap |
| /execution-stability-index | canonical_core | Already live — must remain in sitemap |
| /risk-acceleration-gradient | canonical_core | Already live — must remain in sitemap |
| /pios | canonical_core | Already live — must remain in sitemap |
| /portfolio-intelligence | canonical_core | Already live — must remain in sitemap |
| /manifesto | canonical_core | Already live — must remain in sitemap |
| /execution-blindness-examples | additive_expansion | Enters sitemap on publish (publish_status → live) |
| /why-dashboards-fail-programs | additive_expansion | Enters sitemap on publish (publish_status → live) |
| /early-warning-signals-program-failure | additive_expansion | Enters sitemap on publish (publish_status → live) |

### Routes that MUST NOT be in the sitemap

| Route pattern | Reason |
|--------------|--------|
| Any route with `publish_status: preview-pending-publish` | Not yet live — sitemap entry is premature |
| Any route with `publish_status: preview-pending-*` | Not yet live |
| Any anchor-section route (`/route#anchor`) | Anchor fragments do not receive independent sitemap entries |
| Any route not compiled into `pages/` | No backing page — orphan sitemap entry |
| Any Base44 preview URL | Preview surface is not indexed |

### How additive_expansion pages are handled

Additive expansion pages follow a two-phase sitemap lifecycle:

**Phase 1 — Preview (pre-publish):**
- `publish_status: preview-pending-publish`
- Page exists in `pages/` and `_site/`
- Route MUST NOT appear in sitemap
- `check-sitemap.sh` will PASS (EXCLUDED correctly)

**Phase 2 — Published (post-deploy):**
- `publish_status: live` (set manually or by deploy script at publish time)
- Route is live at `https://krayu.be/<route>`
- Route MUST appear in sitemap
- `check-sitemap.sh` will PASS only if route is in sitemap

The gate from Phase 1 → Phase 2 is: deploy to `krayu.be` + confirm live + set `publish_status: live` + rebuild sitemap.

### Legacy canonical pages (pre-governance)

Pages compiled before the governance pipeline (`publish_status` frontmatter) was introduced may not carry a `publish_status` field. These pages:
- Are flagged as WARN by `check-sitemap.sh` if their publish_status is unknown
- Are treated conservatively as preview-pending by the script
- Must have `publish_status: live` added to their frontmatter to fully resolve the warning
- The warning does NOT block the sitemap check from running; it indicates pages that predate the governance layer

---

## robots.txt Ownership

- **Location:** `~/Projects/krayu-mirror/robots.txt`
- **Served at:** `https://krayu.be/robots.txt`

Rules:
- `User-agent: *` must be present
- `Sitemap: https://krayu.be/sitemap.xml` must be present
- Preview surface (`preview-sandbox--*.base44.app`) must be disallowed or left unconfigured (Base44 handles preview robots independently)
- No production routes must be explicitly disallowed unless there is a documented reason

---

## Canonical Policy

Every page published on krayu.be must carry a `<link rel="canonical">` tag.

Rules:
- Canonical must exactly match the live public URL of the page
- Canonical must never point to a non-existent route
- Canonical must never point to the preview surface
- For anchor-section mirror pages (e.g. `/program-intelligence#execution-blindness`): the canonical must reference the parent page + anchor hash
- For additive expansion pages with `publish_status: preview-pending-publish`: canonical is set to the intended live route but must not be published until the route is live

Canonical format: `https://krayu.be/<route>`

---

## Preview vs Production Indexability

| Surface | Indexable | Notes |
|---------|-----------|-------|
| `preview-sandbox--68b96d175d7634c75c234194.base44.app` | NO | Preview token required; Base44 handles noindex |
| `krayu.be` | YES — after explicit publish | Production surface |
| `krayu.be` — pages with `publish_status: preview-pending-publish` | NO | Must not be live on krayu.be yet |

No preview content must be submitted to Search Console before it is live on krayu.be.

---

## When Routes Enter Sitemap

A route may enter the sitemap only when ALL of the following are true:

1. Page exists in `pages/` as a compiled mirror page
2. `publish_status` is NOT `preview-pending-publish`
3. Route is live and accessible at `https://krayu.be/<route>`
4. Eleventy build has completed successfully with the page included
5. Edge delivery is confirmed (DNS + Cloudflare serving the route)

Routes must NOT enter the sitemap speculatively or at extraction/promotion time.

---

## SEO Integrity Rules

1. No two pages may claim the same canonical URL
2. No additive expansion page may claim the canonical of a core page
3. ESI, RAG, and Execution Blindness definitions must remain on their canonical authority pages — expansion pages reference, not supplant
4. Redirects from old routes (if ever changed) must be explicit and documented in the edge delivery contract

---

*Contract authority: WEB-OPS SEO surface governance | Krayu Program Intelligence Discipline | 2026-03-30*
