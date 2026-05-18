#!/usr/bin/env bash
# verify-docs.sh — checks documentation consistency for SAPCyTI Docs repo
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ERR=0

ALLOW_GLOBS=(
  --glob '!CANONICAL.md'
  --glob '!estructura-propuesta.md'
  --glob '!resumen-propuesta.md'
  --glob '!external-references.md'
  --glob '!scripts/verify-docs.sh'
  --glob '!onboarding/02-tour-directorios.md'
)

echo "==> Checking SDD_fusion references..."
if command -v rg >/dev/null 2>&1; then
  if rg -l 'SDD_fusion' "${ALLOW_GLOBS[@]}" . 2>/dev/null; then
    echo "ERROR: Found SDD_fusion references"
    ERR=1
  fi
else
  echo "WARN: rg not installed, skipping SDD_fusion check"
fi

LEGACY_PATTERN='visionDocs/|Analisis_Requerimientos/|implementations/|SDD-theory/|specifications/|SDD/technologies/'
if [[ "${STRICT_PATHS:-1}" == "1" ]]; then
  echo "==> Checking legacy path references (STRICT_PATHS=1)..."
  if command -v rg >/dev/null 2>&1; then
    if rg -l "$LEGACY_PATTERN" "${ALLOW_GLOBS[@]}" . 2>/dev/null; then
      echo "ERROR: Found legacy path references"
      ERR=1
    fi
  fi
fi

echo "==> Checking progress.md Current Phase blocks..."
CURRENT_PHASE_COUNT=$(grep -c '^## Current Phase' implementation/progress.md 2>/dev/null || echo 0)
if [[ "$CURRENT_PHASE_COUNT" -ne 1 ]]; then
  echo "ERROR: implementation/progress.md must have exactly one '## Current Phase' (found $CURRENT_PHASE_COUNT)"
  ERR=1
fi

echo "==> Checking SPEC_INDEX summary row..."
if grep -q '| 2 | 2 | 0 | 0 | 0 |' sdd/SPEC_INDEX.md 2>/dev/null; then
  echo "ERROR: SPEC_INDEX summary table appears outdated"
  ERR=1
fi

if [[ $ERR -eq 0 ]]; then
  echo "OK: All checks passed."
else
  echo "FAILED: Fix errors above."
  exit 1
fi
