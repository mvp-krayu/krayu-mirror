#!/usr/bin/env bash
# WEB-OPS — External Validation: URL Indexation Check
# Inspects each route for Google indexation status via Search Console URL Inspection API.
# Classifies each route as: INDEXED | DISCOVERED_NOT_INDEXED | NOT_FOUND | NOT_CONFIGURED
# Generates: docs/mirror-validation/indexation_matrix.md
#
# Usage:
#   check-url-indexation.sh [--routes /r1,/r2,...] [--route-file /path/to/routes.txt]
#                           [--property URL] [--pages-dir /path/to/pages]
#
# Credentials (one required):
#   GSC_ACCESS_TOKEN            — OAuth2 bearer token
#   GSC_SERVICE_ACCOUNT_KEY_FILE — Path to GCP service account JSON key
#
# Exits:
#   0 — PASS, PARTIAL, or NOT_CONFIGURED
#   1 — FAIL (NOT_FOUND on any route)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATION_DIR="$REPO_ROOT/docs/mirror-validation"
LOG_TS="$(date '+%Y-%m-%d_%H%M%S')"
LOG_DIR="$REPO_ROOT/WEB/logs/external-validation/$LOG_TS"
REPORT_FILE="$VALIDATION_DIR/external_validation_report.md"
MATRIX_FILE="$VALIDATION_DIR/indexation_matrix.md"
JSON_OUT="$LOG_DIR/indexation_report.json"

PROPERTY="${GSC_PROPERTY:-https://mirror.krayu.be/}"
PAGES_DIR="$REPO_ROOT/pages"
ROUTES_ARG=""
ROUTE_FILE=""
RUN_TS="$(date '+%Y-%m-%d %H:%M:%S')"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --routes)     ROUTES_ARG="$2"; shift 2 ;;
    --route-file) ROUTE_FILE="$2"; shift 2 ;;
    --property)   PROPERTY="$2";   shift 2 ;;
    --pages-dir)  PAGES_DIR="$2";  shift 2 ;;
    *)            shift ;;
  esac
done

mkdir -p "$VALIDATION_DIR"
mkdir -p "$LOG_DIR"

# ─── ROUTE RESOLUTION ────────────────────────────────────────────────────────

load_routes() {
  if [[ -n "$ROUTE_FILE" ]] && [[ -f "$ROUTE_FILE" ]]; then
    mapfile -t ROUTES < <(grep -v '^#' "$ROUTE_FILE" | grep -v '^[[:space:]]*$' | xargs -I{} echo {})
  elif [[ -n "$ROUTES_ARG" ]]; then
    IFS=',' read -ra ROUTES <<< "$ROUTES_ARG"
  else
    ROUTES=(
      /execution-blindness-examples
      /why-dashboards-fail-programs
      /early-warning-signals-program-failure
      /program-intelligence/
      /execution-stability-index
      /risk-acceleration-gradient
    )
  fi
}

declare -a ROUTES
load_routes

# ─── PAGE METADATA LOOKUP ────────────────────────────────────────────────────
# Returns: page_class|canonical_status from compiled pages/ frontmatter

get_page_metadata() {
  local route="$1"
  local fname="${route#/}.md"
  local filepath="$PAGES_DIR/$fname"

  if [[ -f "$filepath" ]]; then
    local page_class publish_status
    page_class="$(awk '/^---$/{c++; if(c==2)exit; next} c==1 && /^page_class:/{sub(/^page_class: *"?/,""); sub(/"[ \t]*$/,""); print; exit}' "$filepath" 2>/dev/null || echo "")"
    publish_status="$(awk '/^---$/{c++; if(c==2)exit; next} c==1 && /^publish_status:/{sub(/^publish_status: *"?/,""); sub(/"[ \t]*$/,""); print; exit}' "$filepath" 2>/dev/null || echo "")"
    echo "${page_class:-unknown}|${publish_status:-unknown}"
  else
    echo "not_in_pages|not_compiled"
  fi
}

# ─── INDEXATION CLASSIFICATION ───────────────────────────────────────────────
# Maps GSC API response fields to four canonical statuses:
#   INDEXED              — page is in Google index
#   DISCOVERED_NOT_INDEXED — known to Google but not yet indexed (normal for new content)
#   NOT_FOUND            — page has an error state, is blocked, or cannot be found
#   NOT_CONFIGURED       — GSC credentials not available

classify_indexation() {
  local verdict="$1" coverage="$2"

  # Indexed states
  case "$coverage" in
    "INDEXED"|"SUBMITTED_AND_INDEXED")
      echo "INDEXED"; return ;;
  esac

  if [[ "$verdict" == "PASS" ]]; then
    echo "INDEXED"; return
  fi

  # Error / blocking states → NOT_FOUND
  case "$coverage" in
    *"404"*|*"NOT_FOUND"*|*"REDIRECT_ERROR"*|*"SERVER_ERROR"*|*"5XX"*|"BLOCKED"*|*"BLOCKED_BY_ROBOTS_TXT"*)
      echo "NOT_FOUND"; return ;;
  esac

  if [[ "$verdict" == "FAIL" ]]; then
    echo "NOT_FOUND"; return
  fi

  # Discovered-but-not-indexed states (normal for new pages)
  case "$coverage" in
    *"NOT_INDEXED"*|*"NOT_INDEXABLE"*|"DISCOVERED"*|"CRAWLED"*|*"SUBMITTED"*)
      echo "DISCOVERED_NOT_INDEXED"; return ;;
  esac

  if [[ "$verdict" == "NEUTRAL" ]]; then
    echo "DISCOVERED_NOT_INDEXED"; return
  fi

  # Unknown / no data — treat as not found
  echo "NOT_FOUND"
}

# ─── CREDENTIAL RESOLUTION ───────────────────────────────────────────────────

TOKEN=""

resolve_token() {
  if [[ -n "${GSC_ACCESS_TOKEN:-}" ]]; then
    TOKEN="$GSC_ACCESS_TOKEN"
    echo "  Auth: GSC_ACCESS_TOKEN (direct bearer)"
    return 0
  fi

  if [[ -n "${GSC_SERVICE_ACCOUNT_KEY_FILE:-}" ]]; then
    if [[ ! -f "$GSC_SERVICE_ACCOUNT_KEY_FILE" ]]; then
      echo "  ERROR: GSC_SERVICE_ACCOUNT_KEY_FILE set but file not found: $GSC_SERVICE_ACCOUNT_KEY_FILE"
      return 1
    fi

    if command -v gcloud &>/dev/null; then
      echo "  Auth: service account via gcloud"
      local sa_email
      sa_email="$(python3 -c "import json; print(json.load(open('$GSC_SERVICE_ACCOUNT_KEY_FILE'))['client_email'])" 2>/dev/null || echo "")"
      if [[ -n "$sa_email" ]]; then
        if gcloud auth activate-service-account "$sa_email" \
            --key-file="$GSC_SERVICE_ACCOUNT_KEY_FILE" --quiet 2>/dev/null; then
          TOKEN="$(gcloud auth print-access-token 2>/dev/null || echo "")"
          [[ -n "$TOKEN" ]] && return 0
        fi
      fi
    fi

    if command -v python3 &>/dev/null; then
      echo "  Auth: service account via google-auth (python3)"
      TOKEN="$(python3 - <<PYEOF 2>/dev/null || echo ""
import sys
try:
    from google.oauth2 import service_account
    import google.auth.transport.requests
    creds = service_account.Credentials.from_service_account_file(
        '$GSC_SERVICE_ACCOUNT_KEY_FILE',
        scopes=['https://www.googleapis.com/auth/webmasters.readonly']
    )
    creds.refresh(google.auth.transport.requests.Request())
    print(creds.token)
except Exception as e:
    sys.exit(1)
PYEOF
)"
      [[ -n "$TOKEN" ]] && return 0
      echo "  WARN: google-auth python package not available. Install: pip install google-auth"
    fi

    echo "  ERROR: service account key file present but token could not be acquired."
    echo "         Install gcloud CLI or 'pip install google-auth' to use service account auth."
    return 1
  fi

  return 1
}

# ─── NOT_CONFIGURED PATH ─────────────────────────────────────────────────────

write_matrix_not_configured() {
  {
    echo "# Indexation Matrix"
    echo ""
    echo "Source of truth: NOT_CONFIGURED"
    echo "Property: ${PROPERTY}"
    echo "Last updated: ${RUN_TS}"
    echo "GSC credentials: NOT_CONFIGURED"
    echo ""
    echo "---"
    echo ""
    echo "| Route | Page Class | Canonical Status | Indexation Status | Source of Truth | Timestamp |"
    echo "|-------|-----------|-----------------|------------------|----------------|-----------|"
    for route in "${ROUTES[@]}"; do
      route="$(echo "$route" | xargs)"
      local meta
      meta="$(get_page_metadata "$route")"
      local page_class="${meta%%|*}"
      local canonical_status="${meta##*|}"
      echo "| ${route} | ${page_class} | ${canonical_status} | NOT_CONFIGURED | NOT_CONFIGURED | ${RUN_TS} |"
    done
    echo ""
    echo "---"
    echo ""
    echo "## Status Key"
    echo ""
    echo "| Status | Meaning |"
    echo "|--------|---------|"
    echo "| INDEXED | Page is confirmed in Google index |"
    echo "| DISCOVERED_NOT_INDEXED | Google knows the page but has not yet indexed it — normal for new content |"
    echo "| NOT_FOUND | Page has a blocking error (404, redirect error, robots block, server error) |"
    echo "| NOT_CONFIGURED | GSC credentials not available — actual status unknown |"
    echo ""
    echo "---"
    echo ""
    echo "*Indexation Matrix — WEB-OPS external validation | ${RUN_TS}*"
  } > "$MATRIX_FILE"
}

if [[ -z "${GSC_ACCESS_TOKEN:-}" ]] && [[ -z "${GSC_SERVICE_ACCOUNT_KEY_FILE:-}" ]]; then
  echo "NOT_CONFIGURED — GSC_ACCESS_TOKEN and GSC_SERVICE_ACCOUNT_KEY_FILE are both unset."
  echo ""
  echo "To configure, set one of:"
  echo "  export GSC_ACCESS_TOKEN=<oauth2-bearer-token>"
  echo "  export GSC_SERVICE_ACCOUNT_KEY_FILE=/path/to/service-account.json"
  echo ""
  echo "Acquiring an OAuth2 token:"
  echo "  gcloud auth print-access-token  (personal account with GSC access)"
  echo "  gcloud auth application-default print-access-token"
  echo ""
  echo "URL Inspection API requires scope: https://www.googleapis.com/auth/webmasters.readonly"
  echo ""

  ROUTES_JSON="$(printf '"%s",' "${ROUTES[@]}")"
  ROUTES_JSON="[${ROUTES_JSON%,}]"

  python3 - <<PYEOF > "$JSON_OUT"
import json
print(json.dumps({
    "run_ts": "$RUN_TS",
    "status": "NOT_CONFIGURED",
    "property": "$PROPERTY",
    "message": "GSC_ACCESS_TOKEN and GSC_SERVICE_ACCOUNT_KEY_FILE are both unset",
    "routes": $ROUTES_JSON,
    "results": []
}, indent=2))
PYEOF

  write_matrix_not_configured

  cat >> "$REPORT_FILE" << EOF

---

## URL Indexation Check — ${RUN_TS}

Status: NOT_CONFIGURED

Credentials required:
- \`GSC_ACCESS_TOKEN\` environment variable (OAuth2 bearer token)
- OR \`GSC_SERVICE_ACCOUNT_KEY_FILE\` environment variable (path to GCP service account JSON key)

Property: ${PROPERTY}

No indexation data collected. Pipeline may proceed with NOT_CONFIGURED warning.

Indexation matrix: ${MATRIX_FILE} (all routes marked NOT_CONFIGURED)
JSON output: ${JSON_OUT}

EOF

  echo "Report appended: $REPORT_FILE"
  echo "Matrix:          $MATRIX_FILE"
  echo "JSON output:     $JSON_OUT"
  echo "Exit: NOT_CONFIGURED (exit 0)"
  exit 0
fi

# ─── RESOLVE CREDENTIALS ─────────────────────────────────────────────────────

if ! resolve_token; then
  echo ""
  echo "FAIL — credential resolution failed. See errors above."
  exit 1
fi

if [[ -z "$TOKEN" ]]; then
  echo "FAIL — token resolved to empty string."
  exit 1
fi

# ─── URL INSPECTION API ───────────────────────────────────────────────────────

echo "URL Indexation Check — Property: $PROPERTY"
echo "Routes: ${ROUTES[*]}"
echo ""

declare -a MATRIX_ROWS=()
declare -a RESULTS=()
declare -a JSON_RESULTS=()
OVERALL_STATUS="PASS"
FAIL_COUNT=0

for route in "${ROUTES[@]}"; do
  route="$(echo "$route" | xargs)"
  INSPECT_URL="${PROPERTY%/}${route}"
  echo "  Inspecting: $INSPECT_URL"

  # Get page metadata from pages/ (does not depend on GSC)
  PAGE_META="$(get_page_metadata "$route")"
  PAGE_CLASS="${PAGE_META%%|*}"
  CANONICAL_STATUS="${PAGE_META##*|}"

  RESPONSE="$(curl -s --max-time 15 -X POST \
    "https://searchconsole.googleapis.com/v1/urlInspection/index:inspect" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"inspectionUrl\": \"$INSPECT_URL\",
      \"siteUrl\": \"$PROPERTY\"
    }" 2>/dev/null || echo '{"error":{"message":"request_failed"}}')"

  if echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if 'inspectionResult' in d else 1)" 2>/dev/null; then
    VERDICT="$(echo "$RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('inspectionResult',{}).get('indexStatusResult',{}).get('verdict','UNKNOWN'))
" 2>/dev/null || echo UNKNOWN)"

    COVERAGE="$(echo "$RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('inspectionResult',{}).get('indexStatusResult',{}).get('coverageState','UNKNOWN'))
" 2>/dev/null || echo UNKNOWN)"

    CRAWLED_AS="$(echo "$RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('inspectionResult',{}).get('indexStatusResult',{}).get('crawledAs','UNKNOWN'))
" 2>/dev/null || echo UNKNOWN)"

    ROBOTS_ALLOWED="$(echo "$RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('inspectionResult',{}).get('indexStatusResult',{}).get('robotsTxtState','UNKNOWN'))
" 2>/dev/null || echo UNKNOWN)"

    INDEXATION_CLASS="$(classify_indexation "$VERDICT" "$COVERAGE")"
    echo "    Verdict: $VERDICT | Coverage: $COVERAGE | Class: $INDEXATION_CLASS"

    case "$INDEXATION_CLASS" in
      INDEXED)
        RESULTS+=("$route|PASS|$COVERAGE|$CRAWLED_AS") ;;
      DISCOVERED_NOT_INDEXED)
        RESULTS+=("$route|PARTIAL|$COVERAGE|$CRAWLED_AS")
        [[ "$OVERALL_STATUS" == "PASS" ]] && OVERALL_STATUS="PARTIAL" ;;
      NOT_FOUND)
        RESULTS+=("$route|FAIL|$COVERAGE|$CRAWLED_AS")
        OVERALL_STATUS="FAIL"
        FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
    esac

    MATRIX_ROWS+=("${route}|${PAGE_CLASS}|${CANONICAL_STATUS}|${INDEXATION_CLASS}|GSC URL Inspection API|${RUN_TS}")
    JSON_RESULTS+=("{\"route\":\"$route\",\"url\":\"$INSPECT_URL\",\"page_class\":\"$PAGE_CLASS\",\"canonical_status\":\"$CANONICAL_STATUS\",\"indexation_class\":\"$INDEXATION_CLASS\",\"verdict\":\"$VERDICT\",\"coverage\":\"$COVERAGE\",\"crawled_as\":\"$CRAWLED_AS\",\"robots_txt_state\":\"$ROBOTS_ALLOWED\"}")

  elif echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if 'error' in d else 1)" 2>/dev/null; then
    ERR_MSG="$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('error',{}).get('message','unknown'))" 2>/dev/null || echo "unknown")"
    echo "    API error: $ERR_MSG"
    RESULTS+=("$route|FAIL|API_ERROR|n/a")
    MATRIX_ROWS+=("${route}|${PAGE_CLASS}|${CANONICAL_STATUS}|NOT_FOUND|GSC API Error: ${ERR_MSG}|${RUN_TS}")
    JSON_RESULTS+=("{\"route\":\"$route\",\"url\":\"$INSPECT_URL\",\"page_class\":\"$PAGE_CLASS\",\"canonical_status\":\"$CANONICAL_STATUS\",\"indexation_class\":\"NOT_FOUND\",\"error\":\"$ERR_MSG\"}")
    OVERALL_STATUS="FAIL"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  else
    RESULTS+=("$route|WARN|NO_DATA|n/a")
    MATRIX_ROWS+=("${route}|${PAGE_CLASS}|${CANONICAL_STATUS}|DISCOVERED_NOT_INDEXED|GSC (no data returned)|${RUN_TS}")
    JSON_RESULTS+=("{\"route\":\"$route\",\"url\":\"$INSPECT_URL\",\"page_class\":\"$PAGE_CLASS\",\"canonical_status\":\"$CANONICAL_STATUS\",\"indexation_class\":\"DISCOVERED_NOT_INDEXED\",\"note\":\"no data returned\"}")
    [[ "$OVERALL_STATUS" == "PASS" ]] && OVERALL_STATUS="PARTIAL"
  fi
done

# ─── WRITE INDEXATION MATRIX ─────────────────────────────────────────────────

{
  echo "# Indexation Matrix"
  echo ""
  echo "Source of truth: GSC URL Inspection API"
  echo "Property: ${PROPERTY}"
  echo "Last updated: ${RUN_TS}"
  echo "Overall status: ${OVERALL_STATUS}"
  echo ""
  echo "---"
  echo ""
  echo "| Route | Page Class | Canonical Status | Indexation Status | Source of Truth | Timestamp |"
  echo "|-------|-----------|-----------------|------------------|----------------|-----------|"
  for row in "${MATRIX_ROWS[@]}"; do
    IFS='|' read -r r_route r_class r_canonical r_idx r_source r_ts <<< "$row"
    echo "| ${r_route} | ${r_class} | ${r_canonical} | ${r_idx} | ${r_source} | ${r_ts} |"
  done
  echo ""
  echo "---"
  echo ""
  echo "## Status Key"
  echo ""
  echo "| Status | Meaning | Action |"
  echo "|--------|---------|--------|"
  echo "| INDEXED | Page is confirmed in Google index | None — monitor for ranking |"
  echo "| DISCOVERED_NOT_INDEXED | Google knows the page but has not indexed it yet | Normal for new content; re-check after 7–14 days |"
  echo "| NOT_FOUND | Page has a blocking error (404, redirect error, robots block, server error) | Investigate immediately — do not declare release complete |"
  echo "| NOT_CONFIGURED | GSC credentials not available | Configure GSC credentials and re-run |"
  echo ""
  echo "---"
  echo ""
  echo "## Interpretation Notes"
  echo ""
  echo "- DISCOVERED_NOT_INDEXED is the expected status for newly published pages within the first 7–14 days."
  echo "- NOT_FOUND on a page that was previously INDEXED indicates a regression. Investigate before next release."
  echo "- Canonical routes should reach INDEXED within 30 days of first publication."
  echo "- Additive expansion pages should reach INDEXED or DISCOVERED_NOT_INDEXED (never NOT_FOUND) within 24h of publish."
  echo ""
  echo "---"
  echo ""
  echo "*Indexation Matrix — WEB-OPS external validation | ${RUN_TS}*"
} > "$MATRIX_FILE"

# ─── WRITE JSON OUTPUT ────────────────────────────────────────────────────────

JSON_RESULTS_JOINED="$(printf '%s,' "${JSON_RESULTS[@]}")"
JSON_RESULTS_JOINED="${JSON_RESULTS_JOINED%,}"

python3 - <<PYEOF > "$JSON_OUT"
import json
results = json.loads('[${JSON_RESULTS_JOINED}]')
output = {
    "run_ts": "$RUN_TS",
    "status": "$OVERALL_STATUS",
    "property": "$PROPERTY",
    "fail_count": $FAIL_COUNT,
    "route_count": ${#ROUTES[@]},
    "results": results,
    "matrix_file": "$MATRIX_FILE"
}
print(json.dumps(output, indent=2))
PYEOF

# ─── WRITE MARKDOWN REPORT ───────────────────────────────────────────────────

{
  echo ""
  echo "---"
  echo ""
  echo "## URL Indexation Check — ${RUN_TS}"
  echo ""
  echo "Property: ${PROPERTY}"
  echo "Overall status: ${OVERALL_STATUS}"
  echo ""
  echo "| Route | Status | Coverage State | Crawled As |"
  echo "|-------|--------|---------------|------------|"
  for result in "${RESULTS[@]}"; do
    r="$(echo "$result" | cut -d'|' -f1)"
    s="$(echo "$result" | cut -d'|' -f2)"
    c="$(echo "$result" | cut -d'|' -f3)"
    cr="$(echo "$result" | cut -d'|' -f4)"
    echo "| $r | $s | $c | $cr |"
  done
  echo ""
  echo "Matrix: \`$MATRIX_FILE\`"
  echo "JSON: \`$JSON_OUT\`"
  echo ""
} >> "$REPORT_FILE"

echo ""
echo "URL Indexation: $OVERALL_STATUS ($FAIL_COUNT FAIL)"
echo "Matrix:  $MATRIX_FILE"
echo "Report:  $REPORT_FILE"
echo "JSON:    $JSON_OUT"

[[ "$FAIL_COUNT" -gt 0 ]] && exit 1
exit 0
