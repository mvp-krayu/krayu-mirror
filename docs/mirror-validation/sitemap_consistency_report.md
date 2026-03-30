# Sitemap Consistency Report

Run timestamp: 2026-03-30 18:28:52
Mode: permissive
Sitemap source: _site/sitemap.xml
Pages dir: /Users/khorrix/Projects/krayu-mirror/pages
Live check: NO
Overall status: FAIL

---

## Route Consistency Matrix

| Route | Page Class | Publish Status | Sitemap Status | Notes |
|-------|-----------|---------------|---------------|-------|
| /early-warning-signals-program-failure | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /execution-blindness-examples | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /execution-stability-index | unknown | unknown | EXCLUDED | Correctly absent from sitemap |
| /index | unknown | unknown | EXCLUDED | Correctly absent from sitemap |
| /manifesto | unknown | unknown | FAIL | Preview-pending page must not appear in sitemap |
| /pios | unknown | unknown | EXCLUDED | Correctly absent from sitemap |
| /portfolio-intelligence | unknown | unknown | FAIL | Preview-pending page must not appear in sitemap |
| /program-intelligence | unknown | unknown | FAIL | Preview-pending page must not appear in sitemap |
| /research | unknown | unknown | FAIL | Preview-pending page must not appear in sitemap |
| /risk-acceleration-gradient | unknown | unknown | EXCLUDED | Correctly absent from sitemap |
| /signal-platform | unknown | unknown | FAIL | Preview-pending page must not appear in sitemap |
| /why-dashboards-fail-programs | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /program-intelligence#execution-blindness | unknown | anchor-section | EXCLUDED | Anchor-section pages do not receive sitemap entries |
| /program-intelligence#program-intelligence-gap | unknown | anchor-section | EXCLUDED | Anchor-section pages do not receive sitemap entries |
| /program-intelligence#signal-infrastructure | unknown | anchor-section | EXCLUDED | Anchor-section pages do not receive sitemap entries |

---

## Blocking Rules

| Rule | Trigger | Blocking |
|------|---------|---------|
| Live page missing from sitemap | publish_status=live but route not in sitemap.xml | YES |
| Preview page in sitemap | publish_status=preview-pending-* but route present in sitemap.xml | YES |
| Orphan sitemap route | Route in sitemap.xml but no backing page in pages/ | YES |
| Malformed sitemap | sitemap.xml missing `<urlset` root | YES |
| robots.txt missing Sitemap reference | robots.txt present but has no Sitemap: line | YES |

---

## Check Results

| Check | Result |
|-------|--------|
| unknown publish_status for execution-stability-index.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for index.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for manifesto.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for pios.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for portfolio-intelligence.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for program-intelligence.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for research.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for risk-acceleration-gradient.md (unknown) — treating as preview-pending | WARN |
| unknown publish_status for signal-platform.md (unknown) — treating as preview-pending | WARN |
| pages/ scanned: 15 page(s) found | PASS |
| sitemap.xml present: _site/sitemap.xml | PASS |
| sitemap.xml has valid <urlset> root | PASS |
| preview page correctly excluded from sitemap: /early-warning-signals-program-failure | PASS |
| preview page correctly excluded from sitemap: /execution-blindness-examples | PASS |
| preview page correctly excluded from sitemap: /execution-stability-index | PASS |
| preview page correctly excluded from sitemap: /index | PASS |
| PREVIEW PAGE IN SITEMAP: /manifesto (publish_status=unknown — blocking) | FAIL |
| preview page correctly excluded from sitemap: /pios | PASS |
| PREVIEW PAGE IN SITEMAP: /portfolio-intelligence (publish_status=unknown — blocking) | FAIL |
| PREVIEW PAGE IN SITEMAP: /program-intelligence (publish_status=unknown — blocking) | FAIL |
| PREVIEW PAGE IN SITEMAP: /research (publish_status=unknown — blocking) | FAIL |
| preview page correctly excluded from sitemap: /risk-acceleration-gradient | PASS |
| PREVIEW PAGE IN SITEMAP: /signal-platform (publish_status=unknown — blocking) | FAIL |
| preview page correctly excluded from sitemap: /why-dashboards-fail-programs | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#execution-blindness | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#program-intelligence-gap | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#signal-infrastructure | PASS |
| sitemap route has backing page: /program-intelligence | PASS |
| sitemap route has backing page: /manifesto | PASS |
| sitemap route has backing page: /research | PASS |
| sitemap route has backing page: /signal-platform | PASS |
| sitemap route has backing page: /portfolio-intelligence | PASS |
| robots.txt present: repo root robots.txt | PASS |
| robots.txt contains User-agent: * | PASS |
| robots.txt references sitemap: Sitemap: https://mirror.krayu.be/sitemap.xml | PASS |
| sitemap reference points to correct URL | PASS |

---

## Status Key

| Status | Meaning |
|--------|---------|
| PASS | Route is correctly represented (live page in sitemap, or preview page absent) |
| FAIL | Blocking consistency violation — see blocking rules above |
| EXCLUDED | Route correctly excluded from sitemap (preview-pending or anchor-section) |
| NOT_VERIFIED | Cannot verify — sitemap not found |

---

*Sitemap Consistency Report — WEB-OPS-05C | 2026-03-30 18:28:52*
