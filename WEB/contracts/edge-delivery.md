# Contract: Edge Delivery

Program: Krayu — Program Intelligence Discipline
Contract type: Operational / Edge and DNS Governance
Governs: DNS, Cloudflare, caching, redirects, SSL/TLS, preview vs production routing

---

## DNS / Cloudflare Scope

The krayu.be domain is served through Cloudflare.

| Layer | Owner | Notes |
|-------|-------|-------|
| DNS records | Cloudflare DNS | A/CNAME records pointing to host |
| CDN/proxy | Cloudflare | Proxied traffic |
| SSL/TLS | Cloudflare | Full or Full (Strict) mode |
| Cache | Cloudflare | Page rules or Cache Rules govern TTL |

---

## Proxy / Cache Expectations

Rules:
- Cloudflare proxy is enabled for production routes
- Cache purge must be triggered after every release that updates existing pages
- New pages (not previously cached) do not require cache purge — they will be fetched fresh
- Purge scope: purge by URL for targeted releases; purge all only for structural changes
- Edge caching must not serve stale content for pages that were updated in a release

Cache purge procedure:
```
Cloudflare Dashboard → Caching → Configuration → Purge Cache
→ Custom Purge → enter URL list for updated pages
```

Or via Cloudflare API (if credentials configured):
```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/<ZONE_ID>/purge_cache" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  --data '{"files":["https://krayu.be/route1","https://krayu.be/route2"]}'
```

---

## Redirect Policy

Rules:
- All redirects must be documented before implementation
- No route may be silently removed — a redirect must be put in place
- Redirect rules are defined in Cloudflare (Page Rules or Redirect Rules), not in the Eleventy build
- Temporary redirects (302) are not used for permanent URL changes
- Permanent redirects (301) must be used for any route that changes its permanent location

Redirect documentation format (add to this file under Redirect Log):

```
Route changed: /old-route → /new-route
Date: YYYY-MM-DD
Reason: ...
Redirect type: 301
Implemented in: Cloudflare Redirect Rules
```

---

## Redirect Log

*(empty — no redirects implemented as of 2026-03-30)*

---

## SSL / TLS Checks

Before any release:

1. Confirm SSL certificate is valid and not approaching expiry
2. Confirm Cloudflare SSL mode is Full or Full (Strict) — not Flexible
3. Confirm HTTPS redirect is active (HTTP → HTTPS forced)
4. Confirm `https://krayu.be` responds with 200 and correct headers

---

## Preview vs Production Delivery Rules

| Surface | Delivery Method | Access Control |
|---------|----------------|---------------|
| `preview-sandbox--68b96d175d7634c75c234194.base44.app` | Base44 preview hosting | Preview token required |
| `krayu.be` | Cloudflare → static host | Public — no token |

Rules:
- Preview surface is never treated as a production delivery surface
- Content is not considered live until it is served from `krayu.be` — not from the Base44 preview
- Preview URLs must never be shared as live canonical references
- The production release sequence (build → deploy → purge) is required before any route is considered live

---

## Release Delivery Sequence

When a release is ready:

1. Eleventy build completed successfully → `_site/` generated
2. `_site/` deployed to static host or edge (e.g. Cloudflare Pages, Netlify, or server)
3. New routes confirmed accessible at `https://krayu.be/<route>`
4. Cache purge executed for updated routes
5. SSL confirmed valid
6. Search Console: submit new routes for indexation

---

*Contract authority: WEB-OPS edge delivery governance | Krayu Program Intelligence Discipline | 2026-03-30*
