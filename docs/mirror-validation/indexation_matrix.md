# Indexation Matrix

Source of truth: GSC URL Inspection API
Property: https://mirror.krayu.be/
Last updated: 2026-03-31 11:27:54
Overall status: PARTIAL

---

| Route | Page Class | Canonical Status | Indexation Status | Source of Truth | Timestamp |
|-------|-----------|-----------------|------------------|----------------|-----------|
| /execution-stability-index/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| / | unknown | live | INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /manifesto/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /pios/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /portfolio-intelligence/ | unknown | live | INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /program-intelligence/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /research/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /risk-acceleration-gradient/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |
| /signal-platform/ | unknown | live | DISCOVERED_NOT_INDEXED | GSC URL Inspection API | 2026-03-31 11:27:54 |

---

## Status Key

| Status | Meaning | Action |
|--------|---------|--------|
| INDEXED | Page is confirmed in Google index | None — monitor for ranking |
| DISCOVERED_NOT_INDEXED | Google knows the page but has not indexed it yet | Normal for new content; re-check after 7–14 days |
| NOT_FOUND | Page has a blocking error (404, redirect error, robots block, server error) | Investigate immediately — do not declare release complete |
| NOT_CONFIGURED | GSC credentials not available | Configure GSC credentials and re-run |

---

## Interpretation Notes

- DISCOVERED_NOT_INDEXED is the expected status for newly published pages within the first 7–14 days.
- NOT_FOUND on a page that was previously INDEXED indicates a regression. Investigate before next release.
- Canonical routes should reach INDEXED within 30 days of first publication.
- Additive expansion pages should reach INDEXED or DISCOVERED_NOT_INDEXED (never NOT_FOUND) within 24h of publish.

---

*Indexation Matrix — WEB-OPS external validation | 2026-03-31 11:27:54*
