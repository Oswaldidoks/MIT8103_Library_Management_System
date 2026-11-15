# Failover and recovery discussion — not a high-availability deployment

**Do not run promotion merely to collect marks.** Promotion changes topology and stops normal replay from the original primary. A standby promoted with `pg_promote()` becomes writable; the original primary **must be fenced/stopped** before applications write to the promoted server to prevent split brain.

## Controlled study sequence (only if you choose to test it)

1. Confirm replication is healthy and record `pg_stat_replication` (primary) and `pg_is_in_recovery()` (standby). Save actual evidence.
2. **Stop the original primary and application writes first.** Confirm no client can continue writing to the old primary. In a supervised lab you may use `docker compose stop primary`.
3. Connect to the standby and request promotion with `SELECT pg_promote(wait => true);` (or `pg_ctl promote` as postgres). Check `pg_is_in_recovery()` now returns `false` **using actual output**.
4. Redirect the application's **write connection string** and any health/routing checks to the promoted server. It is no longer a read-only replica; do not let both old and new servers accept writes.
5. The old primary cannot simply rejoin unchanged. A controlled re-seed, base backup or `pg_rewind` with correct WAL/history preconditions may be required. Restore a coherent backup chain and build a new standby.

## Risks with asynchronous streaming

A committed transaction can be acknowledged by the primary **before** its WAL is replayed on the standby. If the original primary fails and the standby is promoted, some recently acknowledged transactions **might be missing**. This project specifies no measured RPO/RTO. For discussion only, define RPO as allowable data loss and RTO as target recovery duration; state your own assumptions explicitly and differentiate them from actual tests.

## Capture checklist

- Promotion command and **actual** pre/post `pg_is_in_recovery()` result.
- Whether the uniquely identified probe row existed before and after promotion.
- How you fenced the former primary and updated the application's write endpoint.
- Whether/how any old primary was rejoined; absence of automatic failover is a limitation.
