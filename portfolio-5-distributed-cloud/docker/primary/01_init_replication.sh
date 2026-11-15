#!/usr/bin/env bash
# Runs ONCE at first primary volume initialization via official postgres entrypoint.
# Creates replication LOGIN role and a harmless test table for replay verification.
set -euo pipefail
: "${POSTGRES_USER:?}" "${POSTGRES_DB:?}" "${POSTGRES_PASSWORD:?}"
: "${REPLICATION_USER:?}" "${REPLICATION_PASSWORD:?}"
# Append replication HBA rule to generated pg_hba.conf, not a real secret.
cat /etc/postgresql/pg_hba_replication.conf >> "${PGDATA}/pg_hba.conf"
# Reload is unnecessary on first startup; entrypoint restarts PostgreSQL afterward.
export PGPASSWORD="${POSTGRES_PASSWORD}"
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  --set=repl_user="$REPLICATION_USER" --set=repl_pass="$REPLICATION_PASSWORD" <<'SQL'
-- format %I safely quotes role identifier, %L safely quotes demo password.
-- \gexec executes the generated CREATE ROLE only if it does not exist.
SELECT format('CREATE ROLE %I WITH LOGIN REPLICATION PASSWORD %L', :'repl_user', :'repl_pass')
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname=:'repl_user') \gexec
-- Test-probe table is separate from the real library schema.
CREATE TABLE IF NOT EXISTS public.replication_probe (
  probe_id text PRIMARY KEY,
  inserted_at timestamptz NOT NULL DEFAULT clock_timestamp()
);
SQL
