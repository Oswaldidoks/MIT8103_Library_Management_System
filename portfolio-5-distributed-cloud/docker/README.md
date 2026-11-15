# PostgreSQL 16 asynchronous primary/standby — Docker lab

**Status: not executed by me.** This is a local **single-host** replication exercise for Crescent City Library, not a managed cloud deployment or automatic HA system. Requires Docker Engine and Compose v2, free local ports **55432** and **55433**, and local disk space. Image is pinned to `postgres:16.6` in both services; adjust together if your platform requires another PostgreSQL 16 patch image.

## Start from an empty lab volume

```bash
cd portfolio-5-distributed-cloud/docker
cp .env.example .env
# Replace the fake passwords locally; NEVER commit .env
chmod +x primary/01_init_replication.sh replica/standby_init.sh verify_replication.sh
docker compose config            # inspect rendered config LOCALLY; don't publish password fields
docker compose up -d
# Wait until both containers are healthy (base backup can take time):
docker compose ps
docker compose logs --tail=50 primary standby   # redact sensitive details before saving
chmod +x verify_replication.sh
a=1; ./verify_replication.sh     # produces LIVE output; capture and inspect
```

### What the setup does

- On the first **primary** volume creation, the official image initialises PostgreSQL, and `primary/01_init_replication.sh` adds the HBA streaming rule, creates a replication login role using the *local* `.env`, and creates an isolated `public.replication_probe` table. The primary enables `wal_level=replica`, `max_wal_senders` and WAL retention.
- On the first **standby** volume creation, `replica/standby_init.sh` uses `pg_basebackup -R` and creates a local `.pgpass` (permissions `0600`). The standby uses `primary_conninfo` and streams WAL asynchronously. If disconnected long enough, replay might require re-seeding because this simple demo does **not** use a physical replication slot.
- `verify_replication.sh` reads both servers' status, inserts a unique probe on the **primary**, polls the **standby** until it sees it, and attempts a write on the standby (expected to fail). **Only your actual stdout/stderr can establish success.**

### Manual commands / further verification

```bash
# Set environment variables locally from the demo .env before using shell substitution:
set -a; source .env; set +a
docker compose exec -T primary psql -X -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dev/stdin < 01_primary_verify.sql
docker compose exec -T standby psql -X -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dev/stdin < 02_standby_verify.sql
docker compose exec -T primary psql -X -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /dev/stdin < 03_probe_primary.sql
```

**Failover:** See `05_failover_recovery.md`. Promotion is optional and destructive to the existing streaming topology. Never run a split-brain pair of writable primaries. This lab has no automatic failover, no point-in-time recovery archive, no TLS and no secret management. The HBA CIDR is broad **inside the Docker network** to keep the lab portable; narrow it for anything outside a disposable local demo. Both database ports are bound to localhost on the host. The example passwords are obviously fake, but **do not commit the actual `.env`**.

**Cleanup:** `docker compose down` keeps volumes; `docker compose down -v` deletes lab data and forces a new base backup (destructive). For evidence, save redacted output in `evidence/portfolio-5/` and record whether the probe reached the standby and what delay you observed, if any. Record an empty `pg_stat_replication` result as **not connected**, not successful replication.
