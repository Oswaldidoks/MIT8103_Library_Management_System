#!/usr/bin/env bash
# Capture genuine PostgreSQL output for one script; never generates dummy results.
# Usage: ./evidence/run_and_capture.sh DB portfolio-1 path/to/file.sql [--expect-error]
set -euo pipefail
if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo 'Usage: run_and_capture.sh DATABASE portfolio-[1-5] path/to/script.sql [--expect-error]' >&2; exit 2
fi
DB=$1; PORTFOLIO=$2; SCRIPT=$3; MODE=${4:-}
[[ "$PORTFOLIO" =~ ^portfolio-[1-5]$ ]] || { echo 'Invalid portfolio' >&2; exit 2; }
[[ -f "$SCRIPT" ]] || { echo "Script not found: $SCRIPT" >&2; exit 2; }
[[ -z "$MODE" || "$MODE" == '--expect-error' ]] || { echo 'Invalid mode' >&2; exit 2; }
command -v psql >/dev/null || { echo 'psql not found' >&2; exit 127; }
mkdir -p "evidence/$PORTFOLIO"
NOW=$(date +%Y%m%d_%H%M%S)
BASE=$(basename "$SCRIPT" .sql)
OUT="evidence/$PORTFOLIO/${BASE}_${NOW}.txt"
set +e
{
  printf 'Captured UTC: %s\nDatabase: %s\nScript: %s\n' "$(date -u +%FT%TZ)" "$DB" "$SCRIPT"
  psql -X -v ON_ERROR_STOP=1 -d "$DB" -c 'SELECT version();'
  psql -X -v ON_ERROR_STOP=1 -d "$DB" -f "$SCRIPT"
} 2>&1 | tee "$OUT"
STATUS=${PIPESTATUS[0]}
set -e
printf '\nSaved unverified raw evidence to: %s (exit=%s)\n' "$OUT" "$STATUS"
if [[ "$MODE" == '--expect-error' ]]; then
  if [[ "$STATUS" -eq 0 ]]; then echo 'WARNING: expected error was not observed' >&2; exit 1; fi
  echo 'Nonzero exit observed. Manually verify the expected SQLSTATE and error text.'; exit 0
fi
exit "$STATUS"
