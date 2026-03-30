# Hard Validator Report — WEB-OPS-04

Timestamp: 2026-03-30 19:49:14
Stream: WEB-OPS-04
Snapshot: 2026-03-30_181500
Mode: strict
Pages validated: 3

---

## Overall Verdict: PASS

All BLOCKING validators passed.

| Metric | Count |
|--------|-------|
| PASS checks | 24 |
| BLOCKING failures | 0 |
| WARNING failures | 0 |

---

## Validator Registry

| # | Validator | Purpose | Severity |
|---|-----------|---------|---------|
| 1 | STRUCTURE | H1/H2 hierarchy, body length | BLOCKING |
| 2 | TERMINOLOGY | Required terms present (Execution Blindness, ESI, RAG) | BLOCKING |
| 3 | DEFINITION | No canonical concept redefinition (FAIL=BLOCKING, PARTIAL=WARNING) | BLOCKING/WARNING |
| 4 | CONTEXT | Canonical anchor link present | BLOCKING |
| 5 | RELATIONSHIP | Cross-links to related canonical pages | WARNING |
| 6 | STANDALONE | Self-contained page (FAIL=BLOCKING, PARTIAL=WARNING) | BLOCKING/WARNING |
| 7 | METADATA | All required frontmatter fields present | BLOCKING |
| 8 | LINK | Markdown link syntax valid | BLOCKING |

---

## Per-Validator Summary

| Validator | PASS | BLOCKING Failures | WARNING Failures | Verdict |
|-----------|------|------------------|-----------------|---------|
| STRUCTURE | 3 | 0 | 0 | PASS |
| TERMINOLOGY | 3 | 0 | 0 | PASS |
| DEFINITION | 3 | 0 | 0 | PASS |
| CONTEXT | 3 | 0 | 0 | PASS |
| RELATIONSHIP | 3 | 0 | 0 | PASS |
| STANDALONE | 3 | 0 | 0 | PASS |
| METADATA | 3 | 0 | 0 | PASS |
| LINK | 3 | 0 | 0 | PASS |

---

## Results Per Page

| Validator | Severity | Page | Status | Detail |
|-----------|---------|------|--------|--------|
| STRUCTURE | BLOCKING | early-warning-signals-program-failure.md | PASS | H1 present, 4 H2 sections, 111 body lines |
| TERMINOLOGY | BLOCKING | early-warning-signals-program-failure.md | PASS | All required terms present |
| DEFINITION | BLOCKING | early-warning-signals-program-failure.md | PASS | No canonical concept redefinition detected |
| CONTEXT | BLOCKING | early-warning-signals-program-failure.md | PASS | Canonical anchor link present: /program-intelligence#execution-blindness |
| RELATIONSHIP | WARNING | early-warning-signals-program-failure.md | PASS | At least one cross-link to related canonical page |
| STANDALONE | BLOCKING | early-warning-signals-program-failure.md | PASS | title, description, and sufficient body present |
| METADATA | BLOCKING | early-warning-signals-program-failure.md | PASS | All required frontmatter fields present |
| LINK | BLOCKING | early-warning-signals-program-failure.md | PASS | 3 links checked — no syntax errors |
| STRUCTURE | BLOCKING | execution-blindness-examples.md | PASS | H1 present, 3 H2 sections, 159 body lines |
| TERMINOLOGY | BLOCKING | execution-blindness-examples.md | PASS | All required terms present |
| DEFINITION | BLOCKING | execution-blindness-examples.md | PASS | No canonical concept redefinition detected |
| CONTEXT | BLOCKING | execution-blindness-examples.md | PASS | Canonical anchor link present: /program-intelligence#execution-blindness |
| RELATIONSHIP | WARNING | execution-blindness-examples.md | PASS | At least one cross-link to related canonical page |
| STANDALONE | BLOCKING | execution-blindness-examples.md | PASS | title, description, and sufficient body present |
| METADATA | BLOCKING | execution-blindness-examples.md | PASS | All required frontmatter fields present |
| LINK | BLOCKING | execution-blindness-examples.md | PASS | 3 links checked — no syntax errors |
| STRUCTURE | BLOCKING | why-dashboards-fail-programs.md | PASS | H1 present, 5 H2 sections, 107 body lines |
| TERMINOLOGY | BLOCKING | why-dashboards-fail-programs.md | PASS | All required terms present |
| DEFINITION | BLOCKING | why-dashboards-fail-programs.md | PASS | No canonical concept redefinition detected |
| CONTEXT | BLOCKING | why-dashboards-fail-programs.md | PASS | Canonical anchor link present: /program-intelligence#execution-blindness |
| RELATIONSHIP | WARNING | why-dashboards-fail-programs.md | PASS | At least one cross-link to related canonical page |
| STANDALONE | BLOCKING | why-dashboards-fail-programs.md | PASS | title, description, and sufficient body present |
| METADATA | BLOCKING | why-dashboards-fail-programs.md | PASS | All required frontmatter fields present |
| LINK | BLOCKING | why-dashboards-fail-programs.md | PASS | 6 links checked — no syntax errors |

---

## Exit Behavior

| Condition | Exit code | Strict mode | Permissive mode |
|-----------|-----------|-------------|----------------|
| All BLOCKING validators pass | 0 | Continues | Continues |
| Any BLOCKING validator FAIL or PARTIAL | 1 | **Exits — build blocked** | Logs, continues |
| WARNING validator FAIL or PARTIAL only | 0 | Logs, continues | Logs, continues |

---

*Hard Validator Report — WEB-OPS-04 build stage | 2026-03-30 19:49:14*
