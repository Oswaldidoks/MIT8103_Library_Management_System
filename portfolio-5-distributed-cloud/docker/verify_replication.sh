#!/usr/bin/env bash
# Run from portfolio-5-distributed-cloud/docker/ AFTER docker compose up -d.
# Prints REAL observations only; it does not fabricate streaming status.
set -euo pipefail
[[ -f .env ]] || { echo 'Copy .env.example to .env first' >&2; exit 2; }
# The local .env is controlled by this project owner; never commit it.
set -a; source .env; set +a
for v in POSTGRES_USER POSTGRES_DB; do [[ -n "${!v:-}" ]] || { echo "Missing $v" >&2; exit 2; }; done
printf '\n--- Primary replication status ---\n'
docker compose exec -T primary psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dev/stdin < 01_primary_verify.sql
printf '\n--- Standby recovery and replay status ---\n'
docker compose exec -T standby psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dev/stdin < 02_standby_verify.sql
# Tag consists only of digits and underscore; safe inside the SQL string literal.
tag="probe_$(date -u +%Y%m%d_%H%M%S)_$RANDOM"
printf '\n--- Insert primary probe: %s ---\n' "$tag"
docker compose exec -T primary psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -c "INSERT INTO public.replication_probe(probe_id) VALUES ('$tag');"
found=0
for i in $(seq 1 15); do
  # Read standby repeatedly; actual replay may lag behind primary.
  result=$(docker compose exec -T standby psql -X -qAt -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
    -c "SELECT COUNT(*) FROM public.replication_probe WHERE probe_id='$tag';")
  if [[ "$result" == 1 ]]; then echo "Observed probe on standby at attempt $i"; found=1; break; fi
  sleep 1
done
[[ "$found" -eq 1 ]] || { echo 'Probe not observed on standby within attempts; investigate' >&2; exit 1; }
printf '\n--- Standby write test (EXPECTED ERROR, verify SQLSTATE 25006) ---\n'
set +e
docker compose exec -T standby psql -X -v ON_ERROR_STOP=1 -v VERBOSITY=verbose -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /dev/stdin < 04_standby_write_expected_failure.sql
status=$?
set -e
if [[ "$status" -eq 0 ]]; then echo 'UNEXPECTED: standby accepted a write' >&2; exit 1; fi
echo "Expected nonzero standby-write exit observed ($status); manually confirm SQLSTATE 25006."
