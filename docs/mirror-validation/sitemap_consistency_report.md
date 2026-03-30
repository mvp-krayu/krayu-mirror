# Sitemap Consistency Report

Run timestamp: 2026-03-30 22:03:34
Mode: strict
Sitemap source: _site/sitemap.xml
Pages dir: /Users/khorrix/Projects/krayu-mirror/pages
Live check: NO
Overall status: PARTIAL

---

## Route Consistency Matrix

| Route | Page Class | Publish Status | Sitemap Status | Notes |
|-------|-----------|---------------|---------------|-------|
| /execution-stability-index/ | unknown | live | PASS | Present in sitemap |
| / | unknown | live | PASS | Present in sitemap |
| /pios/ | unknown | live | PASS | Present in sitemap |
| /portfolio-intelligence/ | unknown | live | PASS | Present in sitemap |
| /program-intelligence/ | unknown | live | PASS | Present in sitemap |
| /research/ | unknown | live | PASS | Present in sitemap |
| /risk-acceleration-gradient/ | unknown | live | PASS | Present in sitemap |
| /signal-platform/ | unknown | live | PASS | Present in sitemap |
| /early-warning-signals-program-failure/ | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /execution-blindness-examples/ | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
| /manifesto/ | unknown | unknown | EXCLUDED | Correctly absent from sitemap |
| /why-dashboards-fail-programs/ | additive_expansion | preview-pending-publish | EXCLUDED | Correctly absent from sitemap |
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
| unknown publish_status for manifesto.md (unknown) — treating as preview-pending | WARN |
| pages/ scanned: 15 page(s) found | PASS |
| sitemap.xml present: _site/sitemap.xml | PASS |
| sitemap.xml has valid <urlset> root | PASS |
| live page in sitemap: /execution-stability-index/ | PASS |
| live page in sitemap: / | PASS |
| live page in sitemap: /pios/ | PASS |
| live page in sitemap: /portfolio-intelligence/ | PASS |
| live page in sitemap: /program-intelligence/ | PASS |
| live page in sitemap: /research/ | PASS |
| live page in sitemap: /risk-acceleration-gradient/ | PASS |
| live page in sitemap: /signal-platform/ | PASS |
| preview page correctly excluded from sitemap: /early-warning-signals-program-failure/ | PASS |
| preview page correctly excluded from sitemap: /execution-blindness-examples/ | PASS |
| preview page correctly excluded from sitemap: /manifesto/ | PASS |
| preview page correctly excluded from sitemap: /why-dashboards-fail-programs/ | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#execution-blindness | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#program-intelligence-gap | PASS |
| anchor-section excluded from sitemap (correct): /program-intelligence#signal-infrastructure | PASS |
| sitemap route has backing page: / | PASS |
| sitemap route has backing page: /research/ | PASS |
| sitemap route has backing page: /signal-platform/ | PASS |
| sitemap route has backing page: /program-intelligence/ | PASS |
| sitemap route has backing page: /pios/ | PASS |
| sitemap route has backing page: /execution-stability-index/ | PASS |
| sitemap route has backing page: /risk-acceleration-gradient/ | PASS |
| sitemap route has backing page: /portfolio-intelligence/ | PASS |
| sitemap route has backing page: /program-intelligence-gap/ | PASS |
| sitemap route has backing page: /execution-blindness/ | PASS |
| sitemap route has backing page: /signal-infrastructure/ | PASS |
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

*Sitemap Consistency Report — WEB-OPS-05C | 2026-03-30 22:03:34*
