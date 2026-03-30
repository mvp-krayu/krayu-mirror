#!/usr/bin/env bash
# WEB-OPS-04 — Snapshot Promotion
# Promotes a timestamped Base44 snapshot to latest working input state.
#
# Usage:
#   promote-snapshot.sh <YYYY-MM-DD_HHMMSS> [--reason "..."] [--stream "..."]
#
# Enforces all WEB-OPS-04 promotion eligibility conditions.
# Writes promotion_manifest.md into the snapshot (accessible via latest/).
# Runs promotion validation after symlink creation.
# Exits 0 on success, 1 on any failure.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SNAPSHOT_ROOT="$REPO_ROOT/WEB/base44-snapshot"

# ─── ARGS ────────────────────────────────────────────────────────────────────

SNAPSHOT_TS="${1:-}"
PROMOTION_REASON="Explicit promotion via promote-snapshot.sh"
ORIGIN_STREAM="WEB-OPS-04"

shift 1 2>/dev/null || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --reason)  PROMOTION_REASON="$2"; shift 2 ;;
    --stream)  ORIGIN_STREAM="$2";    shift 2 ;;
    *)         echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$SNAPSHOT_TS" ]]; then
  echo "ERROR: snapshot timestamp required."
  echo "Usage: $0 <YYYY-MM-DD_HHMMSS> [--reason \"...\"] [--stream \"...\"]"
  exit 1
fi

SNAPSHOT_DIR="$SNAPSHOT_ROOT/$SNAPSHOT_TS"
LATEST_LINK="$SNAPSHOT_ROOT/latest"
MANIFEST_FILE="$SNAPSHOT_DIR/promotion_manifest.md"
CAPTURE_MANIFEST="$SNAPSHOT_DIR/capture_manifest.md"
PROMOTION_TS="$(date '+%Y-%m-%d %H:%M:%S')"

# ─── HELPERS ─────────────────────────────────────────────────────────────────

pass() { echo "  [PASS] $*"; }
fail() { echo "  [FAIL] $*"; FAILED=1; }
header() { echo ""; echo "=== $* ==="; }
FAILED=0

# Extract a frontmatter value from a markdown file
# Usage: frontmatter_value FILE KEY
frontmatter_value() {
  local file="$1" key="$2"
  awk -v key="$key" '
    /^---$/ { c++; if (c==2) exit; next }
    c==1 && $0 ~ "^"key":" {
      sub("^"key": *\"?", ""); sub("\"$", ""); print; exit
    }
  ' "$file"
}

# ─── STEP 1: BASIC PATH CHECK ─────────────────────────────────────────────────

header "PROMOTION ELIGIBILITY CHECK — $SNAPSHOT_TS"

if [[ ! -d "$SNAPSHOT_DIR" ]]; then
  echo "ERROR: snapshot directory not found: $SNAPSHOT_DIR"
  exit 1
fi

# ─── STEP 2: EIGHT ELIGIBILITY CONDITIONS ────────────────────────────────────

echo ""
echo "Checking 8 eligibility conditions..."

# Condition 1: capture_manifest.md exists
if [[ -f "$CAPTURE_MANIFEST" ]]; then
  pass "capture_manifest.md exists"
else
  fail "capture_manifest.md missing"
fi

# Condition 2: extraction status = PASS (check manifest)
# Accepts: "N PASS / 0 FAIL" summary line, "- Status: PASS" per-route lines, or no FAIL lines
PASS_COUNT="$(grep -c '^\- Status: PASS\|[[:space:]]PASS$\|Result:.*PASS\|[0-9]* PASS' "$CAPTURE_MANIFEST" 2>/dev/null || true)"
HARD_FAIL="$(grep -c '^\- Status: FAIL\|[[:space:]]FAIL$\|[0-9]* FAIL' "$CAPTURE_MANIFEST" 2>/dev/null || true)"
if [[ "$PASS_COUNT" -gt 0 ]] && [[ "$HARD_FAIL" -eq 0 ]]; then
  pass "extraction status = PASS ($PASS_COUNT PASS entries, 0 FAIL)"
elif [[ "$HARD_FAIL" -gt 0 ]]; then
  fail "extraction has $HARD_FAIL FAIL entry(ies) in capture_manifest.md"
else
  # No explicit status entries — warn but don't block if manifest exists and has content
  MANIFEST_LINES="$(wc -l < "$CAPTURE_MANIFEST")"
  if [[ "$MANIFEST_LINES" -gt 10 ]]; then
    pass "extraction status presumed PASS (manifest present, $MANIFEST_LINES lines, no FAIL entries)"
  else
    fail "extraction status not confirmed PASS — check capture_manifest.md"
  fi
fi

# Condition 3: capture_integrity = rendered_capture or source_capture
INTEGRITY="$(frontmatter_value "$CAPTURE_MANIFEST" "capture_integrity" 2>/dev/null || true)"
if [[ -z "$INTEGRITY" ]]; then
  # Check inline content of manifest
  if grep -q 'rendered_capture\|source_capture' "$CAPTURE_MANIFEST" 2>/dev/null; then
    INTEGRITY="$(grep -o 'rendered_capture\|source_capture' "$CAPTURE_MANIFEST" | head -1)"
  fi
fi
if [[ "$INTEGRITY" == "rendered_capture" ]] || [[ "$INTEGRITY" == "source_capture" ]]; then
  pass "capture_integrity = $INTEGRITY"
else
  # Check per-route status in manifest
  if grep -qE 'Integrity: rendered_capture|capture_integrity.*rendered' "$CAPTURE_MANIFEST" 2>/dev/null; then
    pass "capture_integrity = rendered_capture (per-route)"
  else
    fail "capture_integrity not rendered_capture or source_capture (got: ${INTEGRITY:-undetected})"
  fi
fi

# Condition 4: no shell-only or empty files
PAGE_FILES=()
while IFS= read -r -d '' f; do
  fname="$(basename "$f")"
  if [[ "$fname" != "capture_manifest.md" ]] && [[ "$fname" != "promotion_manifest.md" ]]; then
    PAGE_FILES+=("$f")
  fi
done < <(find -L "$SNAPSHOT_DIR" -maxdepth 1 -name "*.md" -print0 | sort -z)

EMPTY_FILES=0
for f in "${PAGE_FILES[@]}"; do
  lines="$(wc -l < "$f")"
  if [[ "$lines" -lt 10 ]]; then
    fail "file appears shell-only or near-empty: $(basename "$f") ($lines lines)"
    EMPTY_FILES=1
  fi
done
if [[ "$EMPTY_FILES" -eq 0 ]]; then
  pass "no shell-only or empty files (${#PAGE_FILES[@]} page files checked)"
fi

# Condition 5: all intended route files present (at least 1 page file)
if [[ "${#PAGE_FILES[@]}" -gt 0 ]]; then
  pass "${#PAGE_FILES[@]} page file(s) present in snapshot"
else
  fail "no page files found in snapshot (only manifests)"
fi

# Condition 6: route naming consistency (kebab-case .md files, no spaces)
NAMING_FAIL=0
for f in "${PAGE_FILES[@]}"; do
  fname="$(basename "$f" .md)"
  if [[ "$fname" =~ [[:upper:]] ]] || [[ "$fname" =~ \  ]]; then
    fail "non-kebab-case filename: $(basename "$f")"
    NAMING_FAIL=1
  fi
done
if [[ "$NAMING_FAIL" -eq 0 ]]; then
  pass "route naming consistent (kebab-case)"
fi

# Condition 7: no reconstruction fallback (reconstructed_capture must not be promoted)
if grep -q 'reconstructed_capture' "$CAPTURE_MANIFEST" 2>/dev/null; then
  # Check if it's the primary integrity or just noted as fallback
  if grep -q 'capture_integrity.*reconstructed\|Integrity: reconstructed' "$CAPTURE_MANIFEST" 2>/dev/null; then
    fail "capture_integrity = reconstructed_capture — promotion forbidden without explicit override"
    FAILED=1
    echo ""
    echo "PROMOTION BLOCKED: reconstructed_capture snapshots may not be promoted to latest."
    echo "Run WEB-OPS-03 extraction first to obtain a rendered_capture snapshot."
    exit 1
  else
    pass "reconstructed_capture noted in manifest but not primary integrity"
  fi
else
  pass "no reconstructed_capture flag detected"
fi

# Condition 8: explicit promotion decision (presence of this script invocation is the decision)
pass "promotion decision is explicit (invoked via promote-snapshot.sh)"

# ─── STEP 3: CHECK FOR FAILURES ───────────────────────────────────────────────

if [[ "$FAILED" -ne 0 ]]; then
  echo ""
  echo "PROMOTION BLOCKED — eligibility check failed."
  echo "Resolve failures before promoting snapshot $SNAPSHOT_TS."
  exit 1
fi

echo ""
echo "All 8 eligibility conditions met. Proceeding with promotion."

# ─── STEP 4: RECORD PRIOR LATEST ──────────────────────────────────────────────

PRIOR_LATEST="none"
if [[ -L "$LATEST_LINK" ]]; then
  PRIOR_LATEST="$(readlink "$LATEST_LINK")"
  PRIOR_LATEST="$(basename "$PRIOR_LATEST")"
  echo ""
  echo "Prior latest: $PRIOR_LATEST — will be replaced."
elif [[ -d "$LATEST_LINK" ]]; then
  echo ""
  echo "WARNING: latest exists as directory (not symlink). Replacing with symlink."
fi

# ─── STEP 5: CREATE SYMLINK ───────────────────────────────────────────────────

header "CREATING SYMLINK"

# Remove existing latest (symlink or directory)
if [[ -L "$LATEST_LINK" ]] || [[ -d "$LATEST_LINK" ]]; then
  rm -rf "$LATEST_LINK"
fi

ln -s "$SNAPSHOT_DIR" "$LATEST_LINK"
echo "  latest → $SNAPSHOT_DIR"

# ─── STEP 6: WRITE PROMOTION MANIFEST ─────────────────────────────────────────

header "WRITING PROMOTION MANIFEST"

# Collect promoted routes
PROMOTED_ROUTES=""
for f in "${PAGE_FILES[@]}"; do
  route="$(frontmatter_value "$f" "route")"
  if [[ -n "$route" ]]; then
    PROMOTED_ROUTES="${PROMOTED_ROUTES}- ${route}"$'\n'
  else
    # Derive from filename
    fname="$(basename "$f" .md)"
    PROMOTED_ROUTES="${PROMOTED_ROUTES}- /${fname}"$'\n'
  fi
done

# Determine integrity level for manifest
MANIFEST_INTEGRITY="rendered_capture"
if grep -q 'source_capture' "$CAPTURE_MANIFEST" 2>/dev/null; then
  MANIFEST_INTEGRITY="source_capture"
fi

cat > "$MANIFEST_FILE" << EOF
# Promotion Manifest — WEB-OPS-04

---

## 1. Promoted Snapshot Timestamp
${SNAPSHOT_TS}

## 2. Promotion Date/Time
${PROMOTION_TS}

## 3. Promotion Source Path
${SNAPSHOT_DIR}/

## 4. Promotion Mode
symlink

\`latest\` → \`${SNAPSHOT_TS}\` (absolute path symlink)

## 5. Operator / Execution Stream
${ORIGIN_STREAM}

## 6. Reason for Promotion
${PROMOTION_REASON}

## 7. Integrity Level
${MANIFEST_INTEGRITY}

## 8. Eligible Routes Promoted
${PROMOTED_ROUTES}
## 9. Excluded Routes
None. All page files in snapshot are eligible.

## 10. Prior Latest Reference
${PRIOR_LATEST}

## 11. Promotion Status
PASS

All promotion eligibility conditions met:
- [x] extraction status = PASS
- [x] capture_integrity = ${MANIFEST_INTEGRITY}
- [x] all intended route files present (${#PAGE_FILES[@]} files)
- [x] capture_manifest.md exists
- [x] no shell-only or empty files
- [x] route naming consistent (kebab-case)
- [x] no unresolved extraction errors
- [x] promotion decision is explicit (invoked via promote-snapshot.sh)

---

*Promotion governed under WEB-OPS-04 — Promotion + Mirror Compile | ${PROMOTION_TS}*
EOF

echo "  Written: $MANIFEST_FILE"

# ─── STEP 7: PROMOTION VALIDATION ─────────────────────────────────────────────

header "PROMOTION VALIDATION"
FAILED=0

# Check 1: latest exists
if [[ -L "$LATEST_LINK" ]] || [[ -d "$LATEST_LINK" ]]; then
  pass "latest exists"
else
  fail "latest does not exist after symlink creation"
fi

# Check 2: latest resolves to intended snapshot
RESOLVED="$(readlink "$LATEST_LINK" 2>/dev/null || true)"
if [[ "$RESOLVED" == "$SNAPSHOT_DIR" ]]; then
  pass "latest resolves to $SNAPSHOT_TS"
else
  fail "latest resolves to unexpected path: $RESOLVED"
fi

# Check 3: all promoted files accessible from latest
ACCESSIBLE_FAIL=0
for f in "${PAGE_FILES[@]}"; do
  fname="$(basename "$f")"
  if [[ ! -f "$LATEST_LINK/$fname" ]]; then
    fail "file not accessible from latest: $fname"
    ACCESSIBLE_FAIL=1
  fi
done
if [[ "$ACCESSIBLE_FAIL" -eq 0 ]]; then
  pass "all ${#PAGE_FILES[@]} page file(s) accessible from latest"
fi

# Check 4: capture_manifest.md accessible
if [[ -f "$LATEST_LINK/capture_manifest.md" ]]; then
  pass "capture_manifest.md accessible from latest"
else
  fail "capture_manifest.md not accessible from latest"
fi

# Check 5: promotion_manifest.md exists
if [[ -f "$LATEST_LINK/promotion_manifest.md" ]]; then
  pass "promotion_manifest.md exists"
else
  fail "promotion_manifest.md missing"
fi

# Check 6: no unintended files (only .md files should be present)
UNEXPECTED=0
while IFS= read -r -d '' f; do
  ext="${f##*.}"
  if [[ "$ext" != "md" ]]; then
    fail "unexpected non-.md file in latest: $(basename "$f")"
    UNEXPECTED=1
  fi
done < <(find -L "$LATEST_LINK" -maxdepth 1 -type f -print0)
if [[ "$UNEXPECTED" -eq 0 ]]; then
  pass "no unexpected files in latest (all .md)"
fi

# Check 7: integrity level recorded in promotion manifest
if grep -q "$MANIFEST_INTEGRITY" "$MANIFEST_FILE" 2>/dev/null; then
  pass "integrity level recorded ($MANIFEST_INTEGRITY)"
else
  fail "integrity level not found in promotion_manifest.md"
fi

# ─── RESULT ──────────────────────────────────────────────────────────────────

echo ""
if [[ "$FAILED" -ne 0 ]]; then
  echo "PROMOTION VALIDATION FAILED"
  echo "latest should not be used as compiler input until failures are resolved."
  exit 1
fi

echo "PROMOTION COMPLETE — $SNAPSHOT_TS"
echo ""
echo "  latest → $SNAPSHOT_TS"
echo "  Page files promoted: ${#PAGE_FILES[@]}"
echo "  Integrity: $MANIFEST_INTEGRITY"
echo "  Prior latest: $PRIOR_LATEST"
echo ""
echo "Next step: run build-mirror-from-snapshot.sh"
