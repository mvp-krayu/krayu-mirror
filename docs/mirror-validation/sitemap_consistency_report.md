# Sitemap Consistency Report

Run timestamp: 2026-03-30 20:18:55
Mode: strict
Sitemap source: _site/sitemap.xml
Pages dir: /Users/khorrix/Projects/krayu-mirror/pages
Live check: NO
Overall status: FAIL

---

## Route Consistency Matrix

| Route | Page Class | Publish Status | Sitemap Status | Notes |
|-------|-----------|---------------|---------------|-------|
| /execution-stability-index | unknown | live | FAIL | Live page missing from sitemap |
| /index | unknown | live | FAIL | Live page missing from sitemap |
| /manifesto | unknown | live | FAIL | Live page missing from sitemap |
| /pios | unknown | live | FAIL | Live page missing from sitemap |
| /portfolio-intelligence | unknown | live | FAIL | Live page missing from sitemap |
| /program-intelligence | unknown | live | FAIL | Live page missing from sitemap |
| /research | unknown | live | FAIL | Live page missing from sitemap |
| /risk-acceleration-gradient | unknown | live | FAIL | Live page missing from sitemap |
| /signal-platform | unknown | live | FAIL | Live page missing from sitemap |
| /early-warning-signals-program-failure | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /execution-blindness-examples | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /why-dashboards-fail-programs | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /program-intelligence#execution-blindness | unknown | anchor-section | EXCLUDED | Anchor-section pages do not receive sitemap entries |
| /program-intelligence#program-intelligence-gap | unknown | anchor-section | EXCLUDED | Anchor-section pages do not receive sitemap entries |
| /program-intelligence#signal-infrastructure | unknown | anchor-section | EXCLUDED | Anchor-section pages do not receive sitemap entries |
| /manifesto/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /research/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /signal-platform/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /program-intelligence/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /pios/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /execution-stability-index/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /risk-acceleration-gradient/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /portfolio-intelligence/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /program-intelligence-gap/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /execution-blindness/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |
| /signal-infrastructure/ | unknown | sitemap-only | FAIL | Sitemap route has no backing page in pages/ |

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
| pages/ scanned: 15 page(s) found | PASS |
| sitemap.xml present: _site/sitemap.xml | PASS |
| sitemap.xml has valid <urlset> root | PASS |
| MISSING from sitemap: /execution-stability-index (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /index (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /manifesto (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /pios (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /portfolio-intelligence (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /program-intelligence (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /research (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /risk-acceleration-gradient (publish_status=live — blocking) | FAIL |
| MISSING from sitemap: /signal-platform (publish_status=live — blocking) | FAIL |
| preview page correctly excluded from sitemap: /early-warning-signals-program-failure | PASS |
| preview page correctly excluded from sitemap: /execution-blindness-examples | PASS |
| preview page correctly excluded from sitemap: /why-dashboards-fail-programs | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#execution-blindness | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#program-intelligence-gap | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#signal-infrastructure | PASS |
| ORPHAN SITEMAP ROUTE: /manifesto/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /research/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /signal-platform/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /program-intelligence/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /pios/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /execution-stability-index/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /risk-acceleration-gradient/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /portfolio-intelligence/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /program-intelligence-gap/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /execution-blindness/ (in sitemap but no page in pages/) | FAIL |
| ORPHAN SITEMAP ROUTE: /signal-infrastructure/ (in sitemap but no page in pages/) | FAIL |
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

*Sitemap Consistency Report — WEB-OPS-05C | 2026-03-30 20:18:55*
