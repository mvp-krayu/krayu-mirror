#!/usr/bin/env bash
# WEB-OPS — Sitemap Consistency Gate
# Validates bidirectional consistency: mirror pages ↔ sitemap ↔ robots.txt
# Generates: docs/mirror-validation/sitemap_consistency_report.md
#
# Consistency model:
#   Live pages (publish_status=live)     → MUST appear in sitemap          (FAIL if missing)
#   Preview pages (preview-pending-*)    → MUST NOT appear in sitemap       (FAIL if present)
#   Anchor-section pages (route has #)   → EXCLUDED from sitemap            (PASS)
#   Sitemap routes with no backing page  → ORPHAN (FAIL)
#
# Usage:
#   check-sitemap.sh [--live] [--base-url https://krayu.be]
#                    [--pages-dir /path/to/pages] [--mode strict|permissive]
#
# Without --live: validates local sitemap and pages/ only
# With --live:    also fetches live sitemap from base-url
#
# Exits:
#   0 — PASS or PARTIAL (permissive, or no blocking failures)
#   1 — FAIL (blocking consistency violation in strict mode)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATION_DIR="$REPO_ROOT/docs/mirror-validation"
REPORT_FILE="$VALIDATION_DIR/external_validation_report.md"
CONSISTENCY_REPORT="$VALIDATION_DIR/sitemap_consistency_report.md"

BASE_URL="https://krayu.be"
PAGES_DIR="$REPO_ROOT/pages"
CHECK_LIVE=0
MODE="strict"
RUN_TS="$(date '+%Y-%m-%d %H:%M:%S')"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --live)       CHECK_LIVE=1;   shift ;;
    --base-url)   BASE_URL="$2";  shift 2 ;;
    --pages-dir)  PAGES_DIR="$2"; shift 2 ;;
    --mode)       MODE="$2";      shift 2 ;;
    *)            shift ;;
  esac
done

mkdir -p "$VALIDATION_DIR"

SITEMAP_LOCAL="$REPO_ROOT/sitemap.xml"
ROBOTS_LOCAL="$REPO_ROOT/robots.txt"
SITE_SITEMAP="$REPO_ROOT/_site/sitemap.xml"
SITE_ROBOTS="$REPO_ROOT/_site/robots.txt"

echo "Sitemap Consistency Gate — ${RUN_TS}"
echo "Mode: $MODE | Live check: $([ "$CHECK_LIVE" -eq 1 ] && echo yes || echo no)"
echo "Pages dir: $PAGES_DIR"
echo ""

FAILED=0
OVERALL_STATUS="PASS"
declare -a CHECKS=()
declare -a CONSISTENCY_ROWS=()

# ─── HELPERS ─────────────────────────────────────────────────────────────────

pass_check()  { echo "  [PASS] $*"; CHECKS+=("PASS|$*"); }
fail_check()  { echo "  [FAIL] $*"; CHECKS+=("FAIL|$*"); FAILED=1; OVERALL_STATUS="FAIL"; }
warn_check()  { echo "  [WARN] $*"; CHECKS+=("WARN|$*"); if [[ "$OVERALL_STATUS" == "PASS" ]]; then OVERALL_STATUS="PARTIAL"; fi; }
info_check()  { echo "  [INFO] $*"; CHECKS+=("INFO|$*"); }

# Normalize a route or URL to canonical trailing-slash form.
# Rules:
#   - Strip scheme + hostname (any domain)
#   - Ensure leading slash
#   - Collapse duplicate slashes
#   - /index and /index/ → /
#   - Anchor routes (#) → preserved as-is (no trailing slash forced)
#   - All other routes → trailing slash ensured
#   - Root / → kept as /
normalize_route() {
  local r="$1"
  # Strip scheme + hostname (handles https://any.domain/path)
  r="$(echo "$r" | sed -E 's|^https?://[^/]*||')"
  # Ensure leading slash
  [[ -z "$r" || "${r:0:1}" != "/" ]] && r="/$r"
  # Collapse duplicate slashes
  r="$(echo "$r" | sed 's|//\+|/|g')"
  # Normalize /index variants to root
  if [[ "$r" == "/index" || "$r" == "/index/" ]]; then
    echo "/"; return
  fi
  # Preserve anchor routes unchanged (no trailing slash after fragment)
  if [[ "$r" == *"#"* ]]; then
    echo "$r"; return
  fi
  # Ensure trailing slash for non-root routes
  if [[ "$r" != "/" && "${r: -1}" != "/" ]]; then
    r="${r}/"
  fi
  echo "$r"
}

# Extract frontmatter field from a pages/ file
frontmatter_value() {
  local file="$1" key="$2"
  awk -v key="$key" '
    /^---$/ { c++; if (c==2) exit; next }
    c==1 && $0 ~ "^"key":" {
      sub("^"key": *\"?", ""); sub("\"[ \t]*$", ""); sub("\"$", ""); print; exit
    }
  ' "$file"
}

# ─── SECTION 1: DISCOVER PAGES/ STATE ────────────────────────────────────────

echo "--- Section 1: Pages/ discovery ---"
echo ""

declare -a LIVE_ROUTES=()
declare -a PREVIEW_ROUTES=()
declare -a ANCHOR_ROUTES=()
declare -a ALL_PAGE_ROUTES=()

# Track metadata per route
declare -A PAGE_CLASS_MAP=()
declare -A PUBLISH_STATUS_MAP=()

PAGES_FOUND=0

if [[ ! -d "$PAGES_DIR" ]]; then
  warn_check "pages/ directory not found at $PAGES_DIR — cannot run page-based consistency checks"
else
  for pfile in "$PAGES_DIR"/*.md; do
    [[ -f "$pfile" ]] || continue
    PAGES_FOUND=$((PAGES_FOUND + 1))

    canonical="$(frontmatter_value "$pfile" "canonical")"
    publish_status="$(frontmatter_value "$pfile" "publish_status")"
    page_class="$(frontmatter_value "$pfile" "page_class")"
    fname="$(basename "$pfile")"

    # Derive route from canonical (hostname-agnostic) or filename, then normalize
    if [[ -n "$canonical" ]]; then
      route="$(normalize_route "$canonical")"
    else
      route="$(normalize_route "/$(basename "$pfile" .md)")"
    fi

    [[ -z "$publish_status" ]] && publish_status="unknown"
    [[ -z "$page_class" ]]     && page_class="unknown"

    ALL_PAGE_ROUTES+=("$route")
    PAGE_CLASS_MAP["$route"]="$page_class"
    PUBLISH_STATUS_MAP["$route"]="$publish_status"

    # Classify
    if [[ "$route" == *"#"* ]]; then
      ANCHOR_ROUTES+=("$route")
    elif [[ "$publish_status" == "live" ]]; then
      LIVE_ROUTES+=("$route")
    elif [[ "$publish_status" == preview* ]]; then
      PREVIEW_ROUTES+=("$route")
    else
      # Unknown publish status — treat as preview (conservative)
      PREVIEW_ROUTES+=("$route")
      warn_check "unknown publish_status for $fname ($publish_status) — treating as preview-pending"
    fi
  done

  echo "  Pages found:   $PAGES_FOUND"
  echo "  Live routes:   ${#LIVE_ROUTES[@]}"
  echo "  Preview routes: ${#PREVIEW_ROUTES[@]}"
  echo "  Anchor routes: ${#ANCHOR_ROUTES[@]}"
  echo ""

  if [[ "$PAGES_FOUND" -eq 0 ]]; then
    warn_check "pages/ directory is empty — no pages to validate against sitemap"
  else
    pass_check "pages/ scanned: $PAGES_FOUND page(s) found"
  fi
fi

# ─── SECTION 2: LOCATE SITEMAP ───────────────────────────────────────────────

echo "--- Section 2: Sitemap location ---"
echo ""

SITEMAP_FILE=""
SITEMAP_SOURCE=""

if [[ -f "$SITE_SITEMAP" ]]; then
  SITEMAP_FILE="$SITE_SITEMAP"
  SITEMAP_SOURCE="_site/sitemap.xml"
  pass_check "sitemap.xml present: _site/sitemap.xml"
elif [[ -f "$SITEMAP_LOCAL" ]]; then
  SITEMAP_FILE="$SITEMAP_LOCAL"
  SITEMAP_SOURCE="sitemap.xml (repo root)"
  pass_check "sitemap.xml present: repo root sitemap.xml"
else
  SITEMAP_FILE=""
  SITEMAP_SOURCE="NOT_CONFIGURED"
  warn_check "sitemap.xml not found (checked: _site/sitemap.xml, sitemap.xml)"
  echo "  This is expected before first Eleventy build + deploy."
fi

# ─── SECTION 3: EXTRACT SITEMAP ROUTES ───────────────────────────────────────

declare -a SITEMAP_ROUTES=()
SITEMAP_PARSEABLE=0

if [[ -n "$SITEMAP_FILE" ]]; then
  echo ""
  echo "--- Section 3: Sitemap route extraction ---"
  echo ""

  # Validate sitemap is well-formed XML (xmllint when available; HTML-wrapper heuristic fallback)
  if ! grep -q '<urlset' "$SITEMAP_FILE" 2>/dev/null; then
    fail_check "sitemap.xml is malformed — missing <urlset> root element"
  elif command -v xmllint &>/dev/null; then
    if xmllint --noout "$SITEMAP_FILE" 2>/dev/null; then
      SITEMAP_PARSEABLE=1
      pass_check "sitemap.xml is valid XML (xmllint)"
    else
      fail_check "sitemap.xml is not valid XML — xmllint parse error (possible HTML wrapper or malformed content)"
    fi
  else
    # xmllint unavailable — heuristic: reject if HTML wrapper detected
    if grep -q '<!DOCTYPE html' "$SITEMAP_FILE" 2>/dev/null || grep -q '<html' "$SITEMAP_FILE" 2>/dev/null; then
      fail_check "sitemap.xml contains HTML wrapper — not valid XML (install xmllint for strict validation)"
    else
      SITEMAP_PARSEABLE=1
      warn_check "sitemap.xml has <urlset> root — xmllint unavailable; install xmllint for strict XML validation"
    fi
  fi

  if [[ "$SITEMAP_PARSEABLE" -eq 1 ]]; then
    # Extract all <loc> URLs and normalize to trailing-slash canonical form
    while IFS= read -r loc_line; do
      # Strip XML tags and whitespace
      url="$(echo "$loc_line" | sed 's|.*<loc>||; s|</loc>.*||; s|[[:space:]]||g')"
      [[ -z "$url" ]] && continue
      route="$(normalize_route "$url")"
      [[ -z "$route" ]] && continue
      SITEMAP_ROUTES+=("$route")
    done < <(grep -i '<loc>' "$SITEMAP_FILE" 2>/dev/null || true)

    echo "  Sitemap routes found: ${#SITEMAP_ROUTES[@]}"
    for r in "${SITEMAP_ROUTES[@]}"; do
      echo "    $r"
    done
    echo ""
  fi
fi

# ─── SECTION 4: BIDIRECTIONAL CONSISTENCY ────────────────────────────────────

echo "--- Section 4: Bidirectional consistency ---"
echo ""

# Helper: check if a route is in the sitemap routes list
in_sitemap() {
  local target="$1"
  for sr in "${SITEMAP_ROUTES[@]}"; do
    [[ "$sr" == "$target" ]] && return 0
  done
  return 1
}

# Helper: check if a route has a backing page.
# Checks both canonical-derived routes and filename-based lookup.
# Pages whose canonical points to an anchor are still "backed" by their file.
has_page() {
  local target="$1"
  # Check against canonical-normalized routes
  for pr in "${ALL_PAGE_ROUTES[@]}"; do
    [[ "$pr" == "$target" ]] && return 0
  done
  # Filename fallback: /slug/ → pages/slug.md, / → pages/index.md
  local slug
  if [[ "$target" == "/" ]]; then
    [[ -f "$PAGES_DIR/index.md" ]] && return 0
  else
    slug="${target%/}"   # strip trailing slash
    slug="${slug#/}"     # strip leading slash
    [[ -n "$slug" && -f "$PAGES_DIR/${slug}.md" ]] && return 0
  fi
  return 1
}

# 4a. Live pages → must be in sitemap
for route in "${LIVE_ROUTES[@]}"; do
  page_class="${PAGE_CLASS_MAP[$route]:-unknown}"
  if [[ -z "$SITEMAP_FILE" ]]; then
    warn_check "live page not verifiable (no sitemap): $route"
    CONSISTENCY_ROWS+=("$route|$page_class|live|NOT_VERIFIED|No sitemap found")
  elif in_sitemap "$route"; then
    pass_check "live page in sitemap: $route"
    CONSISTENCY_ROWS+=("$route|$page_class|live|PASS|Present in sitemap")
  else
    fail_check "MISSING from sitemap: $route (publish_status=live — blocking)"
    CONSISTENCY_ROWS+=("$route|$page_class|live|FAIL|Live page missing from sitemap")
  fi
done

# 4b. Preview pages → must NOT be in sitemap
for route in "${PREVIEW_ROUTES[@]}"; do
  page_class="${PAGE_CLASS_MAP[$route]:-unknown}"
  if [[ -n "$SITEMAP_FILE" ]] && in_sitemap "$route"; then
    fail_check "PREVIEW PAGE IN SITEMAP: $route (publish_status=${PUBLISH_STATUS_MAP[$route]:-preview} — blocking)"
    CONSISTENCY_ROWS+=("$route|$page_class|${PUBLISH_STATUS_MAP[$route]:-preview}|FAIL|Preview-pending page must not appear in sitemap")
  else
    pass_check "preview page correctly excluded from sitemap: $route"
    CONSISTENCY_ROWS+=("$route|$page_class|${PUBLISH_STATUS_MAP[$route]:-preview}|EXCLUDED|Correctly absent from sitemap")
  fi
done

# 4c. Anchor-section pages → excluded, no sitemap entry expected
for route in "${ANCHOR_ROUTES[@]}"; do
  page_class="${PAGE_CLASS_MAP[$route]:-unknown}"
  pass_check "anchor-section excluded from sitemap (correct): $route"
  CONSISTENCY_ROWS+=("$route|$page_class|anchor-section|EXCLUDED|Anchor-section pages do not receive sitemap entries")
done

# 4d. Sitemap routes → must have a backing page
if [[ "${#SITEMAP_ROUTES[@]}" -gt 0 ]]; then
  echo ""
  echo "  Checking sitemap routes have backing pages..."
  for route in "${SITEMAP_ROUTES[@]}"; do
    if has_page "$route"; then
      pass_check "sitemap route has backing page: $route"
    elif [[ "$PAGES_FOUND" -eq 0 ]]; then
      warn_check "cannot verify backing page for $route (pages/ empty)"
    else
      fail_check "ORPHAN SITEMAP ROUTE: $route (in sitemap but no page in pages/)"
      CONSISTENCY_ROWS+=("$route|unknown|sitemap-only|FAIL|Sitemap route has no backing page in pages/")
    fi
  done
fi

# ─── SECTION 5: ROBOTS.TXT CHECKS ────────────────────────────────────────────

echo ""
echo "--- Section 5: robots.txt checks ---"
echo ""

ROBOTS_FILE=""
if [[ -f "$SITE_ROBOTS" ]]; then
  ROBOTS_FILE="$SITE_ROBOTS"
  pass_check "robots.txt present: _site/robots.txt"
elif [[ -f "$ROBOTS_LOCAL" ]]; then
  ROBOTS_FILE="$ROBOTS_LOCAL"
  pass_check "robots.txt present: repo root robots.txt"
else
  warn_check "robots.txt not found — expected before deploy"
fi

if [[ -n "$ROBOTS_FILE" ]]; then
  if grep -qi "user-agent: \*" "$ROBOTS_FILE" 2>/dev/null; then
    pass_check "robots.txt contains User-agent: *"
  else
    warn_check "robots.txt missing User-agent: * directive"
  fi

  if grep -qi "sitemap:" "$ROBOTS_FILE" 2>/dev/null; then
    SITEMAP_REF="$(grep -i "sitemap:" "$ROBOTS_FILE" | head -1 | xargs)"
    pass_check "robots.txt references sitemap: $SITEMAP_REF"

    # Verify sitemap URL in robots.txt points to the correct location
    if echo "$SITEMAP_REF" | grep -q "krayu.be/sitemap.xml"; then
      pass_check "sitemap reference points to correct URL"
    else
      warn_check "sitemap reference URL may be incorrect: $SITEMAP_REF"
    fi
  else
    fail_check "robots.txt missing Sitemap: reference (blocking — robots.txt present but incomplete)"
  fi

  if grep -q "preview-sandbox\|\.base44\.app" "$ROBOTS_FILE" 2>/dev/null; then
    warn_check "robots.txt references Base44 preview domain — verify this is intentional"
  fi
fi

# ─── SECTION 6: LIVE CHECKS (OPTIONAL) ──────────────────────────────────────

if [[ "$CHECK_LIVE" -eq 1 ]]; then
  echo ""
  echo "--- Section 6: Live sitemap checks ($BASE_URL) ---"
  echo ""

  LIVE_SITEMAP="$(curl -s --max-time 10 "$BASE_URL/sitemap.xml" 2>/dev/null || echo "")"
  if [[ -n "$LIVE_SITEMAP" ]] && echo "$LIVE_SITEMAP" | grep -q "<urlset"; then
    pass_check "live sitemap accessible: $BASE_URL/sitemap.xml"

    # Check all live routes appear in the live sitemap
    for route in "${LIVE_ROUTES[@]}"; do
      if echo "$LIVE_SITEMAP" | grep -q "$route"; then
        pass_check "live sitemap contains: $route"
      else
        fail_check "live sitemap MISSING: $route (live page not in live sitemap)"
      fi
    done

    # Check no preview routes are in the live sitemap
    for route in "${PREVIEW_ROUTES[@]}"; do
      if echo "$LIVE_SITEMAP" | grep -q "$route"; then
        fail_check "preview route in LIVE sitemap: $route (must be removed)"
      fi
    done
  else
    fail_check "live sitemap not accessible or invalid at $BASE_URL/sitemap.xml"
  fi

  LIVE_ROBOTS="$(curl -s --max-time 10 "$BASE_URL/robots.txt" 2>/dev/null || echo "")"
  if [[ -n "$LIVE_ROBOTS" ]]; then
    pass_check "live robots.txt accessible: $BASE_URL/robots.txt"
    if echo "$LIVE_ROBOTS" | grep -qi "sitemap:"; then
      pass_check "live robots.txt contains Sitemap reference"
    else
      fail_check "live robots.txt missing Sitemap reference"
    fi
  else
    fail_check "live robots.txt not accessible at $BASE_URL/robots.txt"
  fi
fi

# ─── WRITE SITEMAP CONSISTENCY REPORT ────────────────────────────────────────

{
  echo "# Sitemap Consistency Report"
  echo ""
  echo "Run timestamp: ${RUN_TS}"
  echo "Mode: ${MODE}"
  echo "Sitemap source: ${SITEMAP_SOURCE:-NOT_CONFIGURED}"
  echo "Pages dir: ${PAGES_DIR}"
  echo "Live check: $([ "$CHECK_LIVE" -eq 1 ] && echo "YES (${BASE_URL})" || echo "NO")"
  echo "Overall status: ${OVERALL_STATUS}"
  echo ""
  echo "---"
  echo ""
  echo "## Route Consistency Matrix"
  echo ""
  echo "| Route | Page Class | Publish Status | Sitemap Status | Notes |"
  echo "|-------|-----------|---------------|---------------|-------|"

  # Include all discovered routes
  for row in "${CONSISTENCY_ROWS[@]}"; do
    IFS='|' read -r cr_route cr_class cr_pub cr_status cr_notes <<< "$row"
    echo "| ${cr_route} | ${cr_class} | ${cr_pub} | ${cr_status} | ${cr_notes} |"
  done

  # If no consistency rows (e.g. pages/ empty and no sitemap) — explicit statement
  if [[ "${#CONSISTENCY_ROWS[@]}" -eq 0 ]]; then
    echo "| (none) | — | — | NOT_CONFIGURED | No pages discovered and no sitemap found |"
  fi

  echo ""
  echo "---"
  echo ""
  echo "## Blocking Rules"
  echo ""
  echo "| Rule | Trigger | Blocking |"
  echo "|------|---------|---------|"
  echo "| Live page missing from sitemap | publish_status=live but route not in sitemap.xml | YES |"
  echo "| Preview page in sitemap | publish_status=preview-pending-* but route present in sitemap.xml | YES |"
  echo "| Orphan sitemap route | Route in sitemap.xml but no backing page in pages/ | YES |"
  echo "| Malformed sitemap | sitemap.xml is not valid XML (xmllint or HTML-wrapper heuristic) | YES |"
  echo "| robots.txt missing Sitemap reference | robots.txt present but has no Sitemap: line | YES |"
  echo ""
  echo "---"
  echo ""
  echo "## Check Results"
  echo ""
  echo "| Check | Result |"
  echo "|-------|--------|"
  for check in "${CHECKS[@]}"; do
    c_status="$(echo "$check" | cut -d'|' -f1)"
    c_desc="$(echo "$check" | cut -d'|' -f2)"
    echo "| $c_desc | $c_status |"
  done
  echo ""
  echo "---"
  echo ""
  echo "## Status Key"
  echo ""
  echo "| Status | Meaning |"
  echo "|--------|---------|"
  echo "| PASS | Route is correctly represented (live page in sitemap, or preview page absent) |"
  echo "| FAIL | Blocking consistency violation — see blocking rules above |"
  echo "| EXCLUDED | Route correctly excluded from sitemap (preview-pending or anchor-section) |"
  echo "| NOT_VERIFIED | Cannot verify — sitemap not found |"
  echo ""
  echo "---"
  echo ""
  echo "*Sitemap Consistency Report — WEB-OPS-05C | ${RUN_TS}*"
} > "$CONSISTENCY_REPORT"

# ─── APPEND TO EXTERNAL VALIDATION REPORT ────────────────────────────────────

{
  echo ""
  echo "---"
  echo ""
  echo "## Sitemap Consistency Check — ${RUN_TS}"
  echo ""
  echo "Mode: $([ "$CHECK_LIVE" -eq 1 ] && echo "live + local" || echo "local only")"
  echo "Sitemap source: ${SITEMAP_SOURCE:-NOT_CONFIGURED}"
  echo "Overall status: ${OVERALL_STATUS}"
  echo ""
  echo "| Check | Result |"
  echo "|-------|--------|"
  for check in "${CHECKS[@]}"; do
    c_status="$(echo "$check" | cut -d'|' -f1)"
    c_desc="$(echo "$check" | cut -d'|' -f2)"
    echo "| $c_desc | $c_status |"
  done
  echo ""
  echo "Consistency report: \`$CONSISTENCY_REPORT\`"
  echo ""
} >> "$REPORT_FILE"

echo ""
echo "Sitemap consistency: $OVERALL_STATUS"
echo "Consistency report: $CONSISTENCY_REPORT"
echo "External report:    $REPORT_FILE"

if [[ "$FAILED" -ne 0 ]] && [[ "$MODE" == "strict" ]]; then
  exit 1
fi
exit 0
