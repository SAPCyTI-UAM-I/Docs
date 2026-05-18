#!/usr/bin/env bash
# verify-docs.sh — checks documentation consistency for SAPCyTI Docs repo
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ERR=0

# Files that may mention legacy paths intentionally
EXCLUDE_FILES=(
  'CANONICAL.md'
  'estructura-propuesta.md'
  'resumen-propuesta.md'
  'external-references.md'
  'scripts/verify-docs.sh'
  'onboarding/02-tour-directorios.md'
  'MERGE-GUIDE.md'
)

should_skip() {
  local f="$1"
  for ex in "${EXCLUDE_FILES[@]}"; do
    [[ "$f" == *"$ex" ]] && return 0
  done
  return 1
}

search_pattern() {
  local pattern="$1"
  local hits=()

  if command -v rg >/dev/null 2>&1; then
    local -a globs=()
    for ex in "${EXCLUDE_FILES[@]}"; do
      globs+=(--glob "!$ex")
    done
    mapfile -t hits < <(rg -l "$pattern" "${globs[@]}" . 2>/dev/null || true)
  else
    while IFS= read -r -d '' f; do
      should_skip "$f" && continue
      if grep -qE "$pattern" "$f" 2>/dev/null; then
        hits+=("$f")
      fi
    done < <(find . -type f \( -name '*.md' -o -name '*.mdc' \) ! -path './.git/*' -print0)
  fi

  if ((${#hits[@]} > 0)); then
        printf '%s\n' "${hits[@]}"
        return 1
  fi
  return 0
}

echo "==> Checking SDD_fusion references..."
if ! search_pattern 'SDD_fusion'; then
  echo "ERROR: Found SDD_fusion references (see above)"
  ERR=1
fi

LEGACY_PATTERN='visionDocs/|Analisis_Requerimientos/|implementations/|SDD-theory/|specifications/|SDD/technologies/'
if [[ "${STRICT_PATHS:-1}" == "1" ]]; then
  echo "==> Checking legacy path references (STRICT_PATHS=1)..."
  if ! search_pattern "$LEGACY_PATTERN"; then
    echo "ERROR: Found legacy path references (see above)"
    ERR=1
  fi
else
  echo "INFO: STRICT_PATHS=0 — skipping legacy path check"
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
