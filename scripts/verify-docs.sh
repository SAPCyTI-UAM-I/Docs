#!/usr/bin/env bash
# verify-docs.sh — checks documentation consistency for SAPCyTI Docs repo
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ERR=0

echo "==> Checking deprecated path references..."

# Allowlist: files that may mention deprecated paths intentionally
ALLOW=(
  'CANONICAL.md'
  'specifications/README.md'
  'estructura-propuesta.md'
  'resumen-propuesta.md'
  'scripts/verify-docs.sh'
)

build_allow_glob() {
  local g=()
  for f in "${ALLOW[@]}"; do
    g+=(--glob "!$f")
  done
  printf '%s\n' "${g[@]}"
}

mapfile -t ALLOW_GLOBS < <(build_allow_glob)

if rg -l 'SDD_fusion' "${ALLOW_GLOBS[@]}" . 2>/dev/null; then
  echo "ERROR: Found SDD_fusion references (see above)"
  ERR=1
fi

# Pre-rename mode: warn on legacy paths but do not fail until Hito C completes
LEGACY_PATTERN='visionDocs/|Analisis_Requerimientos/|implementations/|SDD-theory/'
if [[ "${STRICT_PATHS:-0}" == "1" ]]; then
  if rg -l "$LEGACY_PATTERN" "${ALLOW_GLOBS[@]}" . 2>/dev/null; then
    echo "ERROR: Found legacy path references (STRICT_PATHS=1)"
    ERR=1
  fi
else
  LEGACY_COUNT=$(rg -l "$LEGACY_PATTERN" "${ALLOW_GLOBS[@]}" . 2>/dev/null | wc -l || true)
  echo "INFO: Legacy path references: $LEGACY_COUNT files (OK pre-rename; set STRICT_PATHS=1 after Hito C)"
fi

echo "==> Checking progress.md Current Phase blocks..."
CURRENT_PHASE_COUNT=$(grep -c '^## Current Phase' implementations/progress.md 2>/dev/null || echo 0)
if [[ "$CURRENT_PHASE_COUNT" -ne 1 ]]; then
  echo "ERROR: implementations/progress.md must have exactly one '## Current Phase' (found $CURRENT_PHASE_COUNT)"
  ERR=1
fi

echo "==> Checking SPEC_INDEX summary row..."
if grep -q '| 2 | 2 | 0 | 0 | 0 |' SDD/SPEC_INDEX.md 2>/dev/null; then
  echo "ERROR: SPEC_INDEX summary table appears outdated"
  ERR=1
fi

if [[ $ERR -eq 0 ]]; then
  echo "OK: All checks passed."
else
  echo "FAILED: Fix errors above."
  exit 1
fi
