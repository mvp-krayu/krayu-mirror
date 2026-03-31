#!/usr/bin/env bash
# WEB-CAT-INTEGRATION-01 — Source Authority Validation Gate
# Pre-compile enforcement: resolve source, validate CAT, gate projection readiness.
#
# Usage:
#   validate-source-authority.sh [--report-only] [--stream "..."] [--mode strict|permissive]
#
# Reads:  WEB/config/route_source_map.yaml
#         k-pi/docs/governance/category/ (CAT artifacts)
#
# Writes: WEB/reports/source_authority_inventory.md
#         WEB/reports/cat_projection_gate_report.md
#         WEB/reports/blocked_routes_report.md
#         WEB/reports/source_fallback_report.md
#
# Exit codes:
#   0 — all routes pass (allowed or provisional); no blocks
#   1 — one or more routes BLOCKED (strict mode or any mode with blocks present)
#   2 — infrastructure missing (source map, k-pi root, or CAT artifacts)
#
# BLOCKING conditions (not warnings):
#   A. source_type missing or not in valid enum
#   B. source file missing for canonical_kpi or cat_governed_derivative routes
#   C. CAT_required=true AND entity not found in construct_positioning_map.md (derivative routes only)
#   D. projection_required=true AND construct does not pass projection_readiness_gate.md
#   E. route verdict explicitly declared "blocked" in route_source_map.yaml
#
# PROVISIONAL conditions (compiles but non-canonical):
#   compiled_trusted_legacy or base44_snapshot_fallback routes with valid source
#
# ALLOWED conditions:
#   canonical_kpi route: source file exists + CAT artifact files present
#   cat_governed_derivative route: source exists + entity in positioning map + projection ready (if required)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIRROR_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WEB_ROOT="$MIRROR_ROOT/WEB"
REPORTS_DIR="$WEB_ROOT/reports"
SOURCE_MAP="$WEB_ROOT/config/route_source_map.yaml"

KPI_ROOT="${KPI_ROOT:-$(cd "$MIRROR_ROOT/../repos/k-pi" 2>/dev/null && pwd || echo "")}"

ORIGIN_STREAM="WEB-CAT-INTEGRATION-01"
VALIDATE_MODE="strict"
REPORT_ONLY=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stream)      ORIGIN_STREAM="$2"; shift 2 ;;
    --mode)        VALIDATE_MODE="$2"; shift 2 ;;
    --report-only) REPORT_ONLY=1; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

RUN_TS="$(date '+%Y-%m-%d %H:%M:%S')"

# ─── HELPERS ──────────────────────────────────────────────────────────────────

pass()    { echo "  [PASS] $*"; }
fail()    { echo "  [FAIL] $*"; }
block()   { echo "  [BLOCK] $*"; }
warn()    { echo "  [WARN] $*"; }
info()    { echo "  [INFO] $*"; }
header()  { echo ""; echo "=== $* ==="; }

# ─── VALID SOURCE TYPE ENUM ──────────────────────────────────────────────────

VALID_SOURCE_TYPES=(
  "canonical_kpi"
  "cat_governed_derivative"
  "base44_snapshot_fallback"
  "compiled_trusted_legacy"
)

is_valid_source_type() {
  local t="$1"
  for valid in "${VALID_SOURCE_TYPES[@]}"; do
    [[ "$t" == "$valid" ]] && return 0
  done
  return 1
}

# ─── INFRASTRUCTURE CHECKS ───────────────────────────────────────────────────

header "SOURCE AUTHORITY GATE — $RUN_TS"
info "Stream: $ORIGIN_STREAM"
info "Mode:   $VALIDATE_MODE"
info "Mirror: $MIRROR_ROOT"
info "k-pi:   ${KPI_ROOT:-UNRESOLVED}"
echo ""

if [[ ! -f "$SOURCE_MAP" ]]; then
  echo "ERROR: route_source_map.yaml not found at $SOURCE_MAP"
  echo "  WEB-CAT-INTEGRATION-01 requires an explicit source authority map."
  exit 2
fi
pass "route_source_map.yaml found"

if [[ -z "$KPI_ROOT" ]] || [[ ! -d "$KPI_ROOT" ]]; then
  echo "ERROR: k-pi root not found."
  echo "  Expected: $MIRROR_ROOT/../repos/k-pi"
  echo "  Override: KPI_ROOT=/path/to/k-pi $0"
  exit 2
fi
pass "k-pi root found: $KPI_ROOT"

CAT_DIR="$KPI_ROOT/docs/governance/category"
if [[ ! -d "$CAT_DIR" ]]; then
  echo "ERROR: CAT artifacts directory not found: $CAT_DIR"
  exit 2
fi

CAT_FILES=(
  "construct_positioning_map.md"
  "claim_boundary_model.md"
  "projection_schema.md"
  "projection_readiness_gate.md"
  "category_structure_model.md"
  "domain_mapping_model.md"
)
CAT_MISSING=0
for cat_file in "${CAT_FILES[@]}"; do
  if [[ ! -f "$CAT_DIR/$cat_file" ]]; then
    fail "Missing CAT artifact: $cat_file"
    CAT_MISSING=1
  fi
done

if [[ "$CAT_MISSING" -eq 1 ]]; then
  echo "ERROR: Required CAT artifacts missing. WEB cannot enforce CAT without all 6 files."
  exit 2
fi
pass "All 6 CAT artifacts present"

mkdir -p "$REPORTS_DIR"

POSITIONING_FILE="$CAT_DIR/construct_positioning_map.md"
PROJECTION_GATE_FILE="$CAT_DIR/projection_readiness_gate.md"

# ─── YAML PARSER ─────────────────────────────────────────────────────────────
# Parses route_source_map.yaml into a structured line format:
#   ROUTE|<route>|source_type|source_path|CAT_required|projection_required|cat_entity|projection_construct|verdict|fallback_policy|anchor
# One line per route. Processed entirely in bash without further Python calls.

ROUTE_TABLE="$(python3 - "$SOURCE_MAP" <<'PYEOF'
import sys, re

yaml_file = sys.argv[1]
routes = {}
route_order = []
current_route = None
in_routes_section = False

with open(yaml_file) as f:
    for line in f:
        ls = line.rstrip('\n')

        if re.match(r'^routes:\s*$', ls):
            in_routes_section = True
            continue

        if not in_routes_section:
            continue

        # Top-level non-route key ends routes section
        if re.match(r'^[a-zA-Z_]', ls):
            in_routes_section = False
            continue

        # Route entry: 2 spaces + /route/:
        m = re.match(r'^  (/[^:]*):$', ls)
        if m:
            current_route = m.group(1).rstrip()
            if current_route not in routes:
                route_order.append(current_route)
                routes[current_route] = {}
            continue

        if current_route is not None:
            # Property: 4 spaces + key: value
            m = re.match(r'^    ([a-zA-Z_]+): (.+)$', ls)
            if m:
                key = m.group(1)
                raw = m.group(2).strip()
                if raw in ('>', '|', '>-', '|-'):
                    routes[current_route][key] = ''
                    continue
                if raw == 'true':
                    val = 'true'
                elif raw == 'false':
                    val = 'false'
                else:
                    val = raw.strip('"').strip("'")
                # Don't overwrite with empty from multiline continuation
                if val != '':
                    routes[current_route][key] = val
                continue

            # Multiline continuation (6+ spaces): skip
            if re.match(r'^      ', ls):
                continue

def g(props, key, default=''):
    return str(props.get(key, default)).replace('|', '__PIPE__')

for route in route_order:
    props = routes[route]
    row = '|'.join([
        'ROUTE',
        route,
        g(props, 'source_type'),
        g(props, 'source_path'),
        g(props, 'CAT_required', 'false'),
        g(props, 'projection_required', 'false'),
        g(props, 'cat_entity'),
        g(props, 'projection_construct'),
        g(props, 'verdict', 'provisional'),
        g(props, 'fallback_policy', 'allow_with_warn'),
        g(props, 'anchor', 'false'),
    ])
    print(row)
PYEOF
)"

if [[ -z "$ROUTE_TABLE" ]]; then
  echo "ERROR: Failed to parse route_source_map.yaml (empty output)"
  exit 2
fi

ROUTE_COUNT="$(echo "$ROUTE_TABLE" | wc -l | tr -d ' ')"
pass "Parsed $ROUTE_COUNT routes"

# ─── PER-ROUTE VALIDATION ────────────────────────────────────────────────────

header "ROUTE VALIDATION"

ALLOWED_ROUTES=()
PROVISIONAL_ROUTES=()
BLOCKED_ROUTES=()
BLOCKED_REASONS=()

# Temp results file (one line per route, for report generation)
RESULTS_FILE="$REPORTS_DIR/.gate_results_$$"
rm -f "$RESULTS_FILE"

while IFS='|' read -r tag route source_type source_path cat_required proj_required cat_entity proj_construct declared_verdict fallback_policy anchor; do
  [[ "$tag" != "ROUTE" ]] && continue

  echo "  Route: $route"
  echo "    source_type: $source_type"

  route_result="allowed"
  block_reason=""

  # ── BLOCK A: source_type enum validation ─────────────────────────────────
  if [[ -z "$source_type" ]]; then
    block "source_type is EMPTY — not a valid authority class"
    route_result="blocked"
    block_reason="source_type is empty or missing"
  elif ! is_valid_source_type "$source_type"; then
    block "source_type='$source_type' is NOT a valid enum value"
    block "  Allowed values: canonical_kpi | cat_governed_derivative | base44_snapshot_fallback | compiled_trusted_legacy"
    route_result="blocked"
    block_reason="Invalid source_type: '$source_type' — must be one of: canonical_kpi, cat_governed_derivative, base44_snapshot_fallback, compiled_trusted_legacy"
  else
    pass "source_type valid: $source_type"
  fi

  # ── BLOCK B: source file existence (only for authority classes that require it) ──
  if [[ "$route_result" != "blocked" ]]; then
    if [[ "$source_type" == "canonical_kpi" ]] || [[ "$source_type" == "cat_governed_derivative" ]]; then
      if [[ -z "$source_path" ]]; then
        block "source_path is EMPTY for $source_type route"
        route_result="blocked"
        block_reason="source_path is empty for $source_type route"
      else
        resolved_path="$KPI_ROOT/$source_path"
        if [[ ! -f "$resolved_path" ]]; then
          block "Source file missing from k-pi: $source_path"
          route_result="blocked"
          block_reason="Source file missing in k-pi: $source_path"
        else
          pass "Source exists: $source_path"
        fi
      fi
    else
      # Fallback classes: provisional if source missing, not blocked
      if [[ -n "$source_path" ]]; then
        fallback_path="$MIRROR_ROOT/$source_path"
        if [[ ! -f "$fallback_path" ]]; then
          warn "Fallback source not found: $source_path (marking provisional)"
          route_result="provisional"
        else
          pass "Fallback source exists: $source_path"
        fi
      fi
    fi
  fi

  # ── BLOCK C: CAT entity positioning check (ONLY for cat_governed_derivative) ──
  # canonical_kpi routes are doctrine-level; their constructs are not in construct_positioning_map.md
  # (which governs derivative entities only). Do not check positioning for doctrine routes.
  if [[ "$route_result" != "blocked" ]] && [[ "$cat_required" == "true" ]]; then
    if [[ "$source_type" == "cat_governed_derivative" ]] && [[ -n "$cat_entity" ]]; then
      if grep -qF "$cat_entity" "$POSITIONING_FILE" 2>/dev/null; then
        pass "CAT positioning: '$cat_entity' found in construct_positioning_map.md"
      else
        block "CAT positioning: '$cat_entity' NOT found in construct_positioning_map.md"
        route_result="blocked"
        block_reason="Construct '$cat_entity' not found in construct_positioning_map.md"
      fi
    else
      pass "CAT artifacts present (doctrine-level or no entity check required)"
    fi
    pass "Claim boundary: claim_boundary_model.md present"
  fi

  # ── BLOCK D: Projection readiness gate ───────────────────────────────────
  if [[ "$route_result" != "blocked" ]] && [[ "$proj_required" == "true" ]] && [[ -n "$proj_construct" ]]; then
    if grep -q "${proj_construct}.*READY\|READY.*${proj_construct}" "$PROJECTION_GATE_FILE" 2>/dev/null; then
      pass "Projection readiness: $proj_construct = READY"
    else
      block "Projection readiness: $proj_construct is NOT READY in projection_readiness_gate.md"
      route_result="blocked"
      block_reason="Projection readiness gate failed for: $proj_construct"
    fi
  fi

  # ── BLOCK E: Explicitly declared blocked verdict ──────────────────────────
  if [[ "$declared_verdict" == "blocked" ]]; then
    if [[ "$route_result" != "blocked" ]]; then
      block "Route explicitly declared blocked in route_source_map.yaml"
      route_result="blocked"
      block_reason="Declared blocked in route_source_map.yaml"
    fi
  fi

  # ── Apply provisional for fallback classes (only if not blocked) ──────────
  if [[ "$route_result" != "blocked" ]]; then
    if [[ "$source_type" == "compiled_trusted_legacy" ]] || [[ "$source_type" == "base44_snapshot_fallback" ]]; then
      route_result="provisional"
    fi
    # canonical_kpi and cat_governed_derivative that pass all checks remain "allowed"
  fi

  # ── Output and accumulate ─────────────────────────────────────────────────
  if [[ "$route_result" == "blocked" ]]; then
    echo "    Result: BLOCKED — $block_reason"
    BLOCKED_ROUTES+=("$route")
    BLOCKED_REASONS+=("$block_reason")
  elif [[ "$route_result" == "provisional" ]]; then
    echo "    Result: provisional"
    PROVISIONAL_ROUTES+=("$route")
  else
    echo "    Result: allowed"
    ALLOWED_ROUTES+=("$route")
  fi
  echo ""

  # Record for report generation
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$route" "$route_result" "$source_type" "$source_path" \
    "$cat_required" "$proj_required" "$proj_construct" "$block_reason" \
    >> "$RESULTS_FILE"

done <<< "$ROUTE_TABLE"

# ─── SUMMARY ─────────────────────────────────────────────────────────────────

header "VALIDATION SUMMARY"
echo "  Allowed:     ${#ALLOWED_ROUTES[@]}"
echo "  Provisional: ${#PROVISIONAL_ROUTES[@]}"
echo "  Blocked:     ${#BLOCKED_ROUTES[@]}"
echo ""

if [[ ${#BLOCKED_ROUTES[@]} -gt 0 ]]; then
  echo "  BLOCKED ROUTES:"
  for i in "${!BLOCKED_ROUTES[@]}"; do
    echo "    ${BLOCKED_ROUTES[$i]}"
    echo "      Reason: ${BLOCKED_REASONS[$i]}"
  done
  echo ""
fi

# ─── WRITE REPORTS ───────────────────────────────────────────────────────────

header "WRITING REPORTS"

# ─── source_authority_inventory.md ───────────────────────────────────────────

{
  echo "# Source Authority Inventory"
  echo ""
  echo "Contract: WEB-CAT-INTEGRATION-01"
  echo "Generated: $RUN_TS"
  echo "Stream: $ORIGIN_STREAM"
  echo "Total routes: $ROUTE_COUNT"
  echo ""
  echo "---"
  echo ""
  echo "## Route Inventory"
  echo ""
  echo "| Route | Source Type | Source Path | CAT Required | Verdict |"
  echo "|-------|------------|-------------|--------------|---------|"

  while IFS=$'\t' read -r route result stype spath cat_req proj_req proj_const breason; do
    echo "| \`$route\` | $stype | $spath | $cat_req | **$result** |"
  done < "$RESULTS_FILE"

  echo ""
  echo "---"
  echo ""
  echo "## Summary"
  echo ""
  echo "- Allowed:     ${#ALLOWED_ROUTES[@]}"
  echo "- Provisional: ${#PROVISIONAL_ROUTES[@]}"
  echo "- Blocked:     ${#BLOCKED_ROUTES[@]}"
  echo ""

  if [[ ${#ALLOWED_ROUTES[@]} -gt 0 ]]; then
    echo "## Allowed Routes"
    echo ""
    for r in "${ALLOWED_ROUTES[@]}"; do
      echo "- \`$r\`"
    done
    echo ""
  fi

  if [[ ${#PROVISIONAL_ROUTES[@]} -gt 0 ]]; then
    echo "## Provisional Routes (Require Canonical Maturation)"
    echo ""
    for r in "${PROVISIONAL_ROUTES[@]}"; do
      stype="$(grep -m1 "^$r	" "$RESULTS_FILE" | cut -f3)"
      echo "- \`$r\` — source: $stype"
    done
    echo ""
  fi

  if [[ ${#BLOCKED_ROUTES[@]} -gt 0 ]]; then
    echo "## Blocked Routes"
    echo ""
    for i in "${!BLOCKED_ROUTES[@]}"; do
      echo "- \`${BLOCKED_ROUTES[$i]}\` — ${BLOCKED_REASONS[$i]}"
    done
    echo ""
  fi

} > "$REPORTS_DIR/source_authority_inventory.md"
pass "source_authority_inventory.md written"

# ─── cat_projection_gate_report.md ───────────────────────────────────────────

{
  echo "# CAT Projection Gate Report"
  echo ""
  echo "Contract: WEB-CAT-INTEGRATION-01"
  echo "Generated: $RUN_TS"
  echo "Stream: $ORIGIN_STREAM"
  echo ""
  echo "CAT Artifact Location: $CAT_DIR"
  echo ""
  echo "---"
  echo ""
  echo "## CAT Artifact Status"
  echo ""
  echo "| Artifact | Present |"
  echo "|----------|---------|"
  for f in "${CAT_FILES[@]}"; do
    if [[ -f "$CAT_DIR/$f" ]]; then
      echo "| $f | YES |"
    else
      echo "| $f | **NO** |"
    fi
  done

  echo ""
  echo "---"
  echo ""
  echo "## Per-Route CAT Gate Results"
  echo ""
  echo "| Route | CAT Required | Positioning Check | Projection Required | Projection Gate | Verdict |"
  echo "|-------|-------------|------------------|--------------------|--------------------|---------|"

  while IFS=$'\t' read -r route result stype spath cat_req proj_req proj_const breason; do
    pos_check="N/A"
    proj_gate="N/A"

    if [[ "$cat_req" == "true" ]]; then
      if [[ "$stype" == "cat_governed_derivative" ]]; then
        pos_check="checked"
      else
        pos_check="doctrine (not derivative)"
      fi
    fi

    if [[ "$proj_req" == "true" ]] && [[ -n "$proj_const" ]]; then
      if grep -q "${proj_const}.*READY\|READY.*${proj_const}" "$PROJECTION_GATE_FILE" 2>/dev/null; then
        proj_gate="PASS ($proj_const = READY)"
      else
        proj_gate="FAIL ($proj_const not READY)"
      fi
    fi

    echo "| \`$route\` | $cat_req | $pos_check | $proj_req | $proj_gate | **$result** |"
  done < "$RESULTS_FILE"

  if [[ ${#BLOCKED_ROUTES[@]} -eq 0 ]]; then
    echo ""
    echo "---"
    echo ""
    echo "All CAT-required routes passed."
  else
    echo ""
    echo "---"
    echo ""
    echo "**${#BLOCKED_ROUTES[@]} route(s) blocked.** See blocked_routes_report.md for detail."
  fi

} > "$REPORTS_DIR/cat_projection_gate_report.md"
pass "cat_projection_gate_report.md written"

# ─── blocked_routes_report.md ────────────────────────────────────────────────

{
  echo "# Blocked Routes Report"
  echo ""
  echo "Contract: WEB-CAT-INTEGRATION-01"
  echo "Generated: $RUN_TS"
  echo "Stream: $ORIGIN_STREAM"
  echo ""
  echo "---"
  echo ""

  if [[ ${#BLOCKED_ROUTES[@]} -eq 0 ]]; then
    echo "**No routes blocked in this validation run.**"
    echo ""
    echo "All routes passed or were marked provisional."
  else
    echo "## Blocked Routes"
    echo ""
    echo "| Route | Source Type | Blocking Reason |"
    echo "|-------|------------|-----------------|"
    for i in "${!BLOCKED_ROUTES[@]}"; do
      r="${BLOCKED_ROUTES[$i]}"
      reason="${BLOCKED_REASONS[$i]}"
      stype="$(grep -m1 "^$r	" "$RESULTS_FILE" | cut -f3)"
      echo "| \`$r\` | $stype | $reason |"
    done
    echo ""
    echo "**${#BLOCKED_ROUTES[@]} route(s) blocked. Build must not proceed until resolved.**"
    echo ""
    echo "Resolution: repair source or CAT authority in k-pi — do NOT patch mirror pages."
  fi

  echo ""
  echo "---"
  echo ""
  echo "## Blocking Policy"
  echo ""
  echo "A route is blocked when ANY of the following are true:"
  echo ""
  echo "- A. source_type is empty, missing, or not in the valid enum"
  echo "     Valid enum: canonical_kpi | cat_governed_derivative | base44_snapshot_fallback | compiled_trusted_legacy"
  echo "- B. source_type is canonical_kpi or cat_governed_derivative AND source file is missing from k-pi"
  echo "- C. CAT_required=true AND source_type=cat_governed_derivative AND entity not found in construct_positioning_map.md"
  echo "- D. projection_required=true AND construct does not pass projection_readiness_gate.md"
  echo "- E. Route verdict explicitly declared 'blocked' in route_source_map.yaml"
  echo ""
  echo "Manual page correction in pages/ is NOT a valid resolution."
  echo "The required resolution is always repairing the source or CAT authority in k-pi."

} > "$REPORTS_DIR/blocked_routes_report.md"
pass "blocked_routes_report.md written"

# ─── source_fallback_report.md ───────────────────────────────────────────────

{
  echo "# Source Fallback Report"
  echo ""
  echo "Contract: WEB-CAT-INTEGRATION-01"
  echo "Generated: $RUN_TS"
  echo "Stream: $ORIGIN_STREAM"
  echo ""
  echo "---"
  echo ""
  echo "## Purpose"
  echo ""
  echo "This report lists all routes currently using compiled_trusted_legacy or base44_snapshot_fallback"
  echo "source classes. These routes are explicitly provisional. Their content may compile and publish,"
  echo "but they are operating without canonical k-pi authority."
  echo ""
  echo "Manual mirror corrections to these routes are acknowledged, not endorsed."
  echo "The correct steady-state is canonical maturation in k-pi, not mirror-layer patching."
  echo ""
  echo "---"
  echo ""
  echo "## Fallback Route Registry"
  echo ""

  FALLBACK_COUNT=0
  while IFS=$'\t' read -r route result stype spath cat_req proj_req proj_const breason; do
    if [[ "$stype" == "compiled_trusted_legacy" ]] || [[ "$stype" == "base44_snapshot_fallback" ]]; then
      FALLBACK_COUNT=$((FALLBACK_COUNT + 1))
      echo "### \`$route\`"
      echo ""
      echo "- Source class: $stype"
      echo "- Source path: $spath"
      echo "- Verdict: $result"
      echo "- Status: Non-ideal. Remains provisional until canonical k-pi source is defined."
      echo ""
    fi
  done < "$RESULTS_FILE"

  echo "---"
  echo ""
  echo "Total fallback routes: $FALLBACK_COUNT"
  echo ""
  echo "## Resolution Path"
  echo ""
  echo "For each route above, canonical maturation requires:"
  echo "1. A derivative entity node in k-pi/docs/governance/derivatives/nodes/<entity>.md"
  echo "2. A narrative expansion in k-pi/docs/governance/derivatives/narratives/<entity>.md"
  echo "3. An updated entry in WEB/config/route_source_map.yaml changing source_type to cat_governed_derivative"
  echo "4. Rerunning validate-source-authority.sh to confirm the route promotes to allowed"
  echo ""
  echo "Until maturation is complete, these routes remain classified as provisional."
  echo "They may publish but must not be represented as canonical governance surfaces."

} > "$REPORTS_DIR/source_fallback_report.md"
pass "source_fallback_report.md written"

# Cleanup
rm -f "$RESULTS_FILE"

# ─── EXIT DETERMINATION ───────────────────────────────────────────────────────

echo ""
echo "Reports written to: $REPORTS_DIR"
echo ""

if [[ ${#BLOCKED_ROUTES[@]} -gt 0 ]]; then
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║  SOURCE AUTHORITY GATE: FAIL                             ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  ${#BLOCKED_ROUTES[@]} route(s) are BLOCKED."
  echo "  Allowed: ${#ALLOWED_ROUTES[@]}   Provisional: ${#PROVISIONAL_ROUTES[@]}   Blocked: ${#BLOCKED_ROUTES[@]}"
  echo ""
  if [[ "$REPORT_ONLY" -eq 1 ]]; then
    warn "Report-only mode: blocked routes logged but not halting build."
    exit 0
  fi
  # In both strict and permissive mode: if blocked routes exist, exit 1.
  # The pipeline caller decides whether to halt (it always should).
  exit 1
else
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║  SOURCE AUTHORITY GATE: PASS                             ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  Allowed: ${#ALLOWED_ROUTES[@]}   Provisional: ${#PROVISIONAL_ROUTES[@]}   Blocked: 0"
  echo "  All CAT-required routes cleared. Compile may proceed."
  echo ""
  exit 0
fi
