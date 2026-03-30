#!/usr/bin/env bash
# WEB-OPS — External Validation: Search Console
# Validates Search Console data for Krayu Program Intelligence surface.
#
# Usage:
#   validate-search-console.sh [--property URL]
#                              [--start-date YYYY-MM-DD]
#                              [--end-date YYYY-MM-DD]
#                              [--days N]
#                              [--query-file /path/to/queries.txt]
#
# Credentials (one required):
#   GSC_ACCESS_TOKEN            — OAuth2 bearer token
#   GSC_SERVICE_ACCOUNT_KEY_FILE — Path to GCP service account JSON key
#
# Exits:
#   0 — PASS, PARTIAL, or NOT_CONFIGURED
#   1 — FAIL (blocking errors detected)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATION_DIR="$REPO_ROOT/docs/mirror-validation"
LOG_TS="$(date '+%Y-%m-%d_%H%M%S')"
LOG_DIR="$REPO_ROOT/WEB/logs/external-validation/$LOG_TS"
REPORT_FILE="$VALIDATION_DIR/external_validation_report.md"
JSON_OUT="$LOG_DIR/gsc_report.json"

PROPERTY="${GSC_PROPERTY:-https://mirror.krayu.be/}"
DAYS="30"
START_DATE=""
END_DATE=""
QUERY_FILE=""
RUN_TS="$(date '+%Y-%m-%d %H:%M:%S')"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --property)   PROPERTY="$2";   shift 2 ;;
    --start-date) START_DATE="$2"; shift 2 ;;
    --end-date)   END_DATE="$2";   shift 2 ;;
    --days)       DAYS="$2";       shift 2 ;;
    --query-file) QUERY_FILE="$2"; shift 2 ;;
    *)            shift ;;
  esac
done

mkdir -p "$VALIDATION_DIR"
mkdir -p "$LOG_DIR"

# ─── DATE RESOLUTION ─────────────────────────────────────────────────────────

if [[ -z "$END_DATE" ]]; then
  END_DATE="$(date '+%Y-%m-%d')"
fi

if [[ -z "$START_DATE" ]]; then
  # macOS: date -v; Linux: date -d
  START_DATE="$(date -v-"${DAYS}"d '+%Y-%m-%d' 2>/dev/null || date -d "$DAYS days ago" '+%Y-%m-%d')"
fi

# ─── CREDENTIAL RESOLUTION ───────────────────────────────────────────────────

TOKEN=""

resolve_token() {
  # Option 1: direct bearer token
  if [[ -n "${GSC_ACCESS_TOKEN:-}" ]]; then
    TOKEN="$GSC_ACCESS_TOKEN"
    echo "  Auth: GSC_ACCESS_TOKEN (direct bearer)"
    return 0
  fi

  # Option 2: service account key file
  if [[ -n "${GSC_SERVICE_ACCOUNT_KEY_FILE:-}" ]]; then
    if [[ ! -f "$GSC_SERVICE_ACCOUNT_KEY_FILE" ]]; then
      echo "  ERROR: GSC_SERVICE_ACCOUNT_KEY_FILE set but file not found: $GSC_SERVICE_ACCOUNT_KEY_FILE"
      return 1
    fi

    # Try gcloud first
    if command -v gcloud &>/dev/null; then
      echo "  Auth: service account via gcloud"
      local sa_email
      sa_email="$(python3 -c "import json; print(json.load(open('$GSC_SERVICE_ACCOUNT_KEY_FILE'))['client_email'])" 2>/dev/null || echo "")"
      if [[ -n "$sa_email" ]]; then
        if gcloud auth activate-service-account "$sa_email" \
            --key-file="$GSC_SERVICE_ACCOUNT_KEY_FILE" --quiet 2>/dev/null; then
          TOKEN="$(gcloud auth print-access-token 2>/dev/null || echo "")"
          if [[ -n "$TOKEN" ]]; then
            return 0
          fi
        fi
      fi
    fi

    # Try python3 with google-auth
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
      if [[ -n "$TOKEN" ]]; then
        return 0
      fi
      echo "  WARN: google-auth python package not available. Install: pip install google-auth"
    fi

    echo "  ERROR: service account key file present but token could not be acquired."
    echo "         Install gcloud CLI or 'pip install google-auth' to use service account auth."
    return 1
  fi

  return 1
}

# ─── NOT_CONFIGURED CHECK ────────────────────────────────────────────────────

if [[ -z "${GSC_ACCESS_TOKEN:-}" ]] && [[ -z "${GSC_SERVICE_ACCOUNT_KEY_FILE:-}" ]]; then
  echo "NOT_CONFIGURED — Search Console credentials not available."
  echo ""
  echo "To configure, set one of:"
  echo "  export GSC_ACCESS_TOKEN=<oauth2-bearer-token>"
  echo "  export GSC_SERVICE_ACCOUNT_KEY_FILE=/path/to/service-account.json"
  echo ""
  echo "Acquiring an OAuth2 token:"
  echo "  gcloud auth application-default print-access-token"
  echo "  OR: gcloud auth print-access-token (for personal account with GSC access)"
  echo ""
  echo "Acquiring a service account token:"
  echo "  1. Create a service account in GCP with Search Console read access"
  echo "  2. Download the JSON key file"
  echo "  3. Set GSC_SERVICE_ACCOUNT_KEY_FILE=/path/to/key.json"
  echo "  4. Add the service account email to Search Console property as a 'Restricted' user"
  echo ""

  python3 - <<PYEOF > "$JSON_OUT"
import json, sys
print(json.dumps({
    "run_ts": "$RUN_TS",
    "status": "NOT_CONFIGURED",
    "property": "$PROPERTY",
    "start_date": "$START_DATE",
    "end_date": "$END_DATE",
    "message": "GSC_ACCESS_TOKEN and GSC_SERVICE_ACCOUNT_KEY_FILE are both unset",
    "results": []
}, indent=2))
PYEOF

  cat >> "$REPORT_FILE" << EOF

---

## Search Console Validation — ${RUN_TS}

Status: NOT_CONFIGURED

Credentials required:
- \`GSC_ACCESS_TOKEN\` environment variable (OAuth2 bearer token)
- OR \`GSC_SERVICE_ACCOUNT_KEY_FILE\` environment variable (path to GCP service account JSON key)

Property: ${PROPERTY}
Date range: ${START_DATE} to ${END_DATE}

No validation data was collected. Pipeline may proceed with NOT_CONFIGURED warning.

JSON output: ${JSON_OUT}

EOF

  echo "Report appended: $REPORT_FILE"
  echo "JSON output: $JSON_OUT"
  echo ""
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

# ─── LOAD QUERY SET ──────────────────────────────────────────────────────────

mapfile -t QUERY_SET < <(
  if [[ -n "$QUERY_FILE" ]] && [[ -f "$QUERY_FILE" ]]; then
    grep -v '^#' "$QUERY_FILE" | grep -v '^[[:space:]]*$'
  else
    cat <<QUERIES
execution blindness
program intelligence
ESI execution stability
execution blindness examples
why dashboards fail programs
QUERIES
  fi
)

# ─── CONFIGURED — SEARCH ANALYTICS API ──────────────────────────────────────

echo "Search Console validation — Property: $PROPERTY"
echo "Date range: $START_DATE → $END_DATE"
echo "Queries: ${#QUERY_SET[@]}"
echo ""

RESULTS=()
JSON_RESULTS=()
OVERALL_STATUS="PASS"

PROPERTY_ENCODED="$(python3 -c "import urllib.parse; print(urllib.parse.quote('$PROPERTY', safe=''))")"
API_BASE="https://searchconsole.googleapis.com/webmasters/v3/sites/${PROPERTY_ENCODED}/searchAnalytics/query"

for query in "${QUERY_SET[@]}"; do
  echo "  Checking: $query"

  RESPONSE="$(curl -s --max-time 15 -X POST "$API_BASE" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"startDate\": \"$START_DATE\",
      \"endDate\": \"$END_DATE\",
      \"dimensions\": [\"query\"],
      \"dimensionFilterGroups\": [{
        \"filters\": [{
          \"dimension\": \"query\",
          \"operator\": \"contains\",
          \"expression\": \"$query\"
        }]
      }]
    }" 2>/dev/null || echo '{"error":{"message":"request_failed"}}')"

  if echo "$RESPONSE" | grep -q '"rows"'; then
    IMPRESSIONS="$(echo "$RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(sum(int(r.get('impressions', 0)) for r in d.get('rows', [])))
" 2>/dev/null || echo 0)"
    CLICKS="$(echo "$RESPONSE" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(sum(int(r.get('clicks', 0)) for r in d.get('rows', [])))
" 2>/dev/null || echo 0)"
    echo "    Impressions: $IMPRESSIONS | Clicks: $CLICKS"

    if [[ "$IMPRESSIONS" -gt 0 ]]; then
      RESULTS+=("$query|PASS|impressions=$IMPRESSIONS,clicks=$CLICKS")
      JSON_RESULTS+=("{\"query\":\"$query\",\"status\":\"PASS\",\"impressions\":$IMPRESSIONS,\"clicks\":$CLICKS}")
    else
      RESULTS+=("$query|WARN|0 impressions (may be new content)")
      JSON_RESULTS+=("{\"query\":\"$query\",\"status\":\"WARN\",\"impressions\":0,\"clicks\":0,\"note\":\"0 impressions — may be new content or not yet indexed\"}")
      [[ "$OVERALL_STATUS" == "PASS" ]] && OVERALL_STATUS="PARTIAL"
    fi
  elif echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if 'error' in d else 1)" 2>/dev/null; then
    ERR_MSG="$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('error',{}).get('message','unknown'))" 2>/dev/null || echo "unknown")"
    echo "    API error: $ERR_MSG"
    RESULTS+=("$query|FAIL|API error: $ERR_MSG")
    JSON_RESULTS+=("{\"query\":\"$query\",\"status\":\"FAIL\",\"error\":\"$ERR_MSG\"}")
    OVERALL_STATUS="FAIL"
  else
    RESULTS+=("$query|WARN|no data returned")
    JSON_RESULTS+=("{\"query\":\"$query\",\"status\":\"WARN\",\"note\":\"no data returned\"}")
    [[ "$OVERALL_STATUS" == "PASS" ]] && OVERALL_STATUS="PARTIAL"
  fi
done

# ─── WRITE JSON OUTPUT ────────────────────────────────────────────────────────

JSON_RESULTS_JOINED="$(printf '%s,' "${JSON_RESULTS[@]}")"
JSON_RESULTS_JOINED="${JSON_RESULTS_JOINED%,}"

python3 - <<PYEOF > "$JSON_OUT"
import json, sys
results = json.loads('[${JSON_RESULTS_JOINED}]')
output = {
    "run_ts": "$RUN_TS",
    "status": "$OVERALL_STATUS",
    "property": "$PROPERTY",
    "start_date": "$START_DATE",
    "end_date": "$END_DATE",
    "query_count": ${#QUERY_SET[@]},
    "results": results
}
print(json.dumps(output, indent=2))
PYEOF

# ─── WRITE MARKDOWN REPORT ───────────────────────────────────────────────────

{
  echo ""
  echo "---"
  echo ""
  echo "## Search Console Validation — ${RUN_TS}"
  echo ""
  echo "Property: ${PROPERTY}"
  echo "Date range: ${START_DATE} to ${END_DATE}"
  echo "Overall status: ${OVERALL_STATUS}"
  echo ""
  echo "### Query Results"
  echo ""
  echo "| Query | Status | Detail |"
  echo "|-------|--------|--------|"
  for result in "${RESULTS[@]}"; do
    q="$(echo "$result" | cut -d'|' -f1)"
    s="$(echo "$result" | cut -d'|' -f2)"
    d="$(echo "$result" | cut -d'|' -f3)"
    echo "| $q | $s | $d |"
  done
  echo ""
  echo "JSON: \`$JSON_OUT\`"
  echo ""
} >> "$REPORT_FILE"

echo ""
echo "Search Console validation: $OVERALL_STATUS"
echo "Report: $REPORT_FILE"
echo "JSON:   $JSON_OUT"

[[ "$OVERALL_STATUS" == "FAIL" ]] && exit 1
exit 0
