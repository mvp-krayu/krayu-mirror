#!/usr/bin/env bash
# WEB-OPS Pipeline — WEB-OPS-03 + WEB-OPS-04
# Full pipeline: extract Base44 pages → promote snapshot → compile mirror
#
# Usage:
#   run-webops-pipeline.sh [--timestamp YYYY-MM-DD_HHMMSS]
#                          [--routes /route1,/route2,...]
#                          [--app-id ID]
#                          [--preview-base URL]
#                          [--preview-token TOKEN]
#                          [--origin-stream NAME]
#                          [--reason "promotion reason"]
#                          [--mode strict|permissive]
#                          [--skip-extract]
#                          [--skip-promote]
#                          [--skip-compile]
#
# Stages:
#   1. WEB-OPS-03 — Extract rendered pages from Base44 preview
#   2. promote-snapshot.sh — Promote timestamped snapshot to latest
#   3. build-mirror-from-snapshot.sh — Compile pages/ + write validation artifacts
#
# Exit codes:
#   0 — full pipeline success
#   1 — stage failure (stage name printed before exit)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SNAPSHOT_ROOT="$REPO_ROOT/WEB/base44-snapshot"

# ─── DEFAULTS ────────────────────────────────────────────────────────────────

TIMESTAMP=""
ROUTES=""
APP_ID="68b96d175d7634c75c234194"
PREVIEW_BASE="https://preview-sandbox--68b96d175d7634c75c234194.base44.app"
PREVIEW_TOKEN="AucgjSzm_ZgG1KaY6nROuvQ8XnTtgHsU1L5EbtECe_M"
ORIGIN_STREAM="WEB-OPS-PIPELINE"
PROMOTION_REASON="Automated pipeline promotion via run-webops-pipeline.sh"
COMPILE_MODE="strict"
SKIP_EXTRACT=0
SKIP_PROMOTE=0
SKIP_COMPILE=0
SKIP_BUILD=0
SKIP_EXTERNAL_CHECK=0
RUN_BUILD=0
RUN_EXTERNAL_CHECK=0

# ─── ARGS ────────────────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --timestamp)     TIMESTAMP="$2";         shift 2 ;;
    --routes)        ROUTES="$2";            shift 2 ;;
    --app-id)        APP_ID="$2";            shift 2 ;;
    --preview-base)  PREVIEW_BASE="$2";      shift 2 ;;
    --preview-token) PREVIEW_TOKEN="$2";     shift 2 ;;
    --origin-stream) ORIGIN_STREAM="$2";     shift 2 ;;
    --reason)        PROMOTION_REASON="$2";  shift 2 ;;
    --mode)          COMPILE_MODE="$2";      shift 2 ;;
    --skip-extract)        SKIP_EXTRACT=1;          shift ;;
    --skip-promote)        SKIP_PROMOTE=1;          shift ;;
    --skip-compile)        SKIP_COMPILE=1;          shift ;;
    --skip-build)          SKIP_BUILD=1;            shift ;;
    --skip-external-check) SKIP_EXTERNAL_CHECK=1;   shift ;;
    --run-build)           RUN_BUILD=1;             shift ;;
    --run-external-check)  RUN_EXTERNAL_CHECK=1;    shift ;;
    -h|--help)
      sed -n '2,20p' "$0" | sed 's/^# //'
      exit 0
      ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# Generate timestamp if not provided
if [[ -z "$TIMESTAMP" ]]; then
  TIMESTAMP="$(date '+%Y-%m-%d_%H%M%S')"
fi

# ─── PIPELINE START ───────────────────────────────────────────────────────────

PIPELINE_START="$(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  WEB-OPS PIPELINE — $PIPELINE_START"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Timestamp:  $TIMESTAMP"
echo "  Stream:     $ORIGIN_STREAM"
echo "  App ID:     $APP_ID"
echo "  Mode:       $COMPILE_MODE"
echo ""
echo "  Stages:"
echo "    1. WEB-OPS-03 extract:  $([ "$SKIP_EXTRACT" -eq 1 ] && echo "SKIP" || echo "RUN")"
echo "    2. promote-snapshot:    $([ "$SKIP_PROMOTE" -eq 1 ] && echo "SKIP" || echo "RUN")"
echo "    3. build-mirror:        $([ "$SKIP_COMPILE" -eq 1 ] && echo "SKIP" || echo "RUN")"
echo "    4. eleventy build:      $([ "$RUN_BUILD" -eq 0 ] && echo "NOT_RUN (pass --run-build)" || ([ "$SKIP_BUILD" -eq 1 ] && echo "SKIP" || echo "RUN"))"
echo "    5. external validate:   $([ "$RUN_EXTERNAL_CHECK" -eq 0 ] && echo "NOT_RUN (pass --run-external-check)" || ([ "$SKIP_EXTERNAL_CHECK" -eq 1 ] && echo "SKIP" || echo "RUN"))"
echo ""

# ─── STAGE 1: WEB-OPS-03 EXTRACT ─────────────────────────────────────────────

if [[ "$SKIP_EXTRACT" -eq 0 ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "STAGE 1 — WEB-OPS-03: Extracting pages from Base44"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  EXTRACT_SCRIPT="$SCRIPT_DIR/extract-base44-pages.js"
  if [[ ! -f "$EXTRACT_SCRIPT" ]]; then
    echo "ERROR: extract-base44-pages.js not found at $EXTRACT_SCRIPT"
    exit 1
  fi

  # Build env for extractor
  EXTRACT_ENV=(
    "BASE44_APP_ID=$APP_ID"
    "BASE44_PREVIEW_BASE=$PREVIEW_BASE"
    "BASE44_PREVIEW_TOKEN=$PREVIEW_TOKEN"
    "BASE44_ORIGIN_STREAM=$ORIGIN_STREAM"
    "BASE44_SNAPSHOT_ROOT=$SNAPSHOT_ROOT"
  )
  [[ -n "$ROUTES" ]] && EXTRACT_ENV+=("BASE44_ROUTES=$ROUTES")

  # Run extractor
  EXTRACT_EXIT=0
  env "${EXTRACT_ENV[@]}" node "$EXTRACT_SCRIPT" --timestamp "$TIMESTAMP" || EXTRACT_EXIT=$?

  if [[ "$EXTRACT_EXIT" -ne 0 ]]; then
    echo ""
    echo "STAGE 1 FAILED — WEB-OPS-03 extraction returned exit code $EXTRACT_EXIT"
    echo "Snapshot at: $SNAPSHOT_ROOT/$TIMESTAMP/"
    echo "Check the extraction output above for per-route errors."
    echo ""
    echo "Pipeline halted. Stages 2 and 3 will not run."
    exit 1
  fi

  echo ""
  echo "STAGE 1 COMPLETE — snapshot written: $TIMESTAMP"
else
  echo "STAGE 1 — WEB-OPS-03: SKIPPED"
  # Verify snapshot exists if we skipped extraction
  if [[ ! -d "$SNAPSHOT_ROOT/$TIMESTAMP" ]]; then
    echo "ERROR: --skip-extract used but snapshot does not exist: $SNAPSHOT_ROOT/$TIMESTAMP"
    exit 1
  fi
  echo "  Using existing snapshot: $TIMESTAMP"
fi

# ─── STAGE 2: PROMOTE SNAPSHOT ───────────────────────────────────────────────

if [[ "$SKIP_PROMOTE" -eq 0 ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "STAGE 2 — Promoting snapshot to latest"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  PROMOTE_SCRIPT="$SCRIPT_DIR/promote-snapshot.sh"
  if [[ ! -f "$PROMOTE_SCRIPT" ]]; then
    echo "ERROR: promote-snapshot.sh not found at $PROMOTE_SCRIPT"
    exit 1
  fi

  PROMOTE_EXIT=0
  bash "$PROMOTE_SCRIPT" "$TIMESTAMP" \
    --reason "$PROMOTION_REASON" \
    --stream "$ORIGIN_STREAM" || PROMOTE_EXIT=$?

  if [[ "$PROMOTE_EXIT" -ne 0 ]]; then
    echo ""
    echo "STAGE 2 FAILED — promote-snapshot.sh returned exit code $PROMOTE_EXIT"
    echo "Pipeline halted. Stage 3 will not run."
    exit 1
  fi

  echo ""
  echo "STAGE 2 COMPLETE — latest → $TIMESTAMP"
else
  echo ""
  echo "STAGE 2 — Promote snapshot: SKIPPED"
  echo "  Using existing latest: $(basename "$(readlink "$SNAPSHOT_ROOT/latest" 2>/dev/null || echo "unset")")"
fi

# ─── STAGE 3: BUILD MIRROR ───────────────────────────────────────────────────

if [[ "$SKIP_COMPILE" -eq 0 ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "STAGE 3 — Compiling mirror pages from latest"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  BUILD_SCRIPT="$SCRIPT_DIR/build-mirror-from-snapshot.sh"
  if [[ ! -f "$BUILD_SCRIPT" ]]; then
    echo "ERROR: build-mirror-from-snapshot.sh not found at $BUILD_SCRIPT"
    exit 1
  fi

  BUILD_EXIT=0
  bash "$BUILD_SCRIPT" \
    --stream "$ORIGIN_STREAM" \
    --mode "$COMPILE_MODE" || BUILD_EXIT=$?

  if [[ "$BUILD_EXIT" -ne 0 ]]; then
    echo ""
    echo "STAGE 3 FAILED — build-mirror-from-snapshot.sh returned exit code $BUILD_EXIT"
    echo "Compiled output is in place for inspection."
    echo "Do not use failed compile output for downstream publishing."
    exit 1
  fi

  echo ""
  echo "STAGE 3 COMPLETE — mirror pages compiled"
else
  echo ""
  echo "STAGE 3 — Build mirror: SKIPPED"
fi

# ─── STAGE 4: ELEVENTY BUILD ─────────────────────────────────────────────────

if [[ "$RUN_BUILD" -eq 1 ]] && [[ "$SKIP_BUILD" -eq 0 ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "STAGE 4 — Eleventy Build"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  BUILD_EXIT=0
  (cd "$REPO_ROOT" && npx @11ty/eleventy) || BUILD_EXIT=$?

  if [[ "$BUILD_EXIT" -ne 0 ]]; then
    echo ""
    echo "STAGE 4 FAILED — Eleventy build returned exit code $BUILD_EXIT"
    echo "Do not deploy. Investigate Eleventy error output above."
    exit 1
  fi

  if [[ ! -d "$REPO_ROOT/_site" ]]; then
    echo "STAGE 4 FAILED — _site/ directory not created"
    exit 1
  fi

  echo ""
  echo "STAGE 4 COMPLETE — _site/ built"
else
  echo ""
  echo "STAGE 4 — Eleventy Build: NOT_RUN"
  echo "  Run with --run-build to include this stage."
  echo "  Contract: WEB/contracts/eleventy-build.md"
fi

# ─── STAGE 5: EXTERNAL VALIDATION ─────────────────────────────────────────────

if [[ "$RUN_EXTERNAL_CHECK" -eq 1 ]] && [[ "$SKIP_EXTERNAL_CHECK" -eq 0 ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "STAGE 5 — External Validation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  EXT_ROUTES="$(echo "$ROUTES" | tr ',' '\n' | head -20 | tr '\n' ',' | sed 's/,$//')"

  # Sitemap check (no credentials required)
  SITEMAP_EXIT=0
  bash "$SCRIPT_DIR/check-sitemap.sh" --live || SITEMAP_EXIT=$?
  [[ "$SITEMAP_EXIT" -ne 0 ]] && echo "  WARN: sitemap check returned non-zero — review report"

  # URL indexation (requires credentials)
  INDEXATION_EXIT=0
  bash "$SCRIPT_DIR/check-url-indexation.sh" \
    ${EXT_ROUTES:+--routes "$EXT_ROUTES"} || INDEXATION_EXIT=$?
  [[ "$INDEXATION_EXIT" -ne 0 ]] && echo "  WARN: URL indexation check returned non-zero — review report"

  # Search Console (requires credentials)
  GSC_EXIT=0
  bash "$SCRIPT_DIR/validate-search-console.sh" || GSC_EXIT=$?
  [[ "$GSC_EXIT" -ne 0 ]] && echo "  WARN: Search Console validation returned non-zero — review report"

  echo ""
  echo "STAGE 5 COMPLETE — external validation run (see docs/mirror-validation/external_validation_report.md)"
else
  echo ""
  echo "STAGE 5 — External Validation: NOT_RUN"
  echo "  Run with --run-external-check to include this stage."
  echo "  Contract: WEB/contracts/external-search-validation.md"
  echo "  Note: requires GSC_ACCESS_TOKEN for full validation. Sitemap check runs without credentials."
fi

# ─── PIPELINE SUMMARY ─────────────────────────────────────────────────────────

PIPELINE_END="$(date '+%Y-%m-%d %H:%M:%S')"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  PIPELINE COMPLETE"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Start:    $PIPELINE_START"
echo "║  End:      $PIPELINE_END"
echo "║  Snapshot: $TIMESTAMP"
echo "║  Stream:   $ORIGIN_STREAM"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Stage 1 (extract):         $([ "$SKIP_EXTRACT" -eq 1 ] && echo "SKIPPED  " || echo "PASS     ")"
echo "║  Stage 2 (promote):         $([ "$SKIP_PROMOTE" -eq 1 ] && echo "SKIPPED  " || echo "PASS     ")"
echo "║  Stage 3 (compile):         $([ "$SKIP_COMPILE" -eq 1 ] && echo "SKIPPED  " || echo "PASS     ")"
echo "║  Stage 4 (eleventy build):  $([ "$RUN_BUILD" -eq 0 ] && echo "NOT_RUN  " || ([ "$SKIP_BUILD" -eq 1 ] && echo "SKIPPED  " || echo "PASS     "))"
echo "║  Stage 5 (external check):  $([ "$RUN_EXTERNAL_CHECK" -eq 0 ] && echo "NOT_RUN  " || ([ "$SKIP_EXTERNAL_CHECK" -eq 1 ] && echo "SKIPPED  " || echo "COMPLETE "))"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Snapshot:   $SNAPSHOT_ROOT/$TIMESTAMP/"
echo "  Latest:     $SNAPSHOT_ROOT/latest/ → $TIMESTAMP"
echo "  Pages:      $REPO_ROOT/pages/"
echo "  Validation: $REPO_ROOT/docs/mirror-validation/"
echo ""
