#!/usr/bin/env bash
# Standby initialiser: on empty volume take pg_basebackup -R from primary.
# The standby's local .pgpass is created inside container storage, never Git.
# Uses asynchronous physical streaming, WITHOUT replication slot; extended
# disconnection can cause WAL removal and require a fresh base backup.
set -euo pipefail
: "${PGDATA:?}" "${REPLICATION_USER:?}" "${REPLICATION_PASSWORD:?}"
: "${POSTGRES_USER:?}" "${POSTGRES_DB:?}"
mkdir -p "$PGDATA"
chown -R postgres:postgres /var/lib/postgresql/data
chmod 700 "$PGDATA"
# Permit pg_basebackup and WAL receiver to authenticate to the primary.
PASSFILE=/var/lib/postgresql/.pgpass
printf 'primary:5432:replication:%s:%s\n' "$REPLICATION_USER" "$REPLICATION_PASSWORD" > "$PASSFILE"
chown postgres:postgres "$PASSFILE"
chmod 600 "$PASSFILE"
if [[ ! -s "$PGDATA/PG_VERSION" ]]; then
  echo 'No PG_VERSION found; waiting for primary then taking pg_basebackup.'
  until pg_isready -h primary -p 5432 -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; do
    sleep 2
  done
  # -R creates standby.signal and recovery parameters; WAL streaming with -Xs.
  gosu postgres env PGPASSFILE="$PASSFILE" pg_basebackup \
    -h primary -p 5432 -U "$REPLICATION_USER" -D "$PGDATA" \
    -Fp -Xs -P -R
  # Override primary_conninfo WITHOUT embedding the password. It references
  # the private local passfile for the PostgreSQL WAL receiver process.
  printf "\nprimary_conninfo = 'host=primary port=5432 user=%s passfile=%s application_name=library_standby'\n" \
    "$REPLICATION_USER" "$PASSFILE" >> "$PGDATA/postgresql.auto.conf"
  chown postgres:postgres "$PGDATA/postgresql.auto.conf"
fi
exec docker-entrypoint.sh postgres
