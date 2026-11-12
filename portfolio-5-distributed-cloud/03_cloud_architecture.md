# Portfolio 5 — PostgreSQL distribution and cloud design

## Proposed architecture (not a deployed service)

```text
Library application
  |         \-- reporting reads (may tolerate replica lag)
  |                  |
  v                  v
PostgreSQL PRIMARY --WAL stream--> PostgreSQL READ REPLICA
  |
  +--> scheduled base backups + WAL archive (point-in-time recovery)
```

**Primary:** all checkouts, returns, fine payments and read-after-write confirmations use the primary, preserving immediate visibility of writes. **Replica:** reporting and catalogue searches may use a standby if lag is acceptable. Asynchronous replication has a nonzero data-loss risk on sudden primary failure; a read replica alone is not automatic failover. A managed plan must explicitly provide promotion and failover policy.

**Data partitioning:** the local `loan_events` hash partition exercise is PostgreSQL partitioning **within one server**, not multi-node sharding. True sharding would distribute subsets over separate database nodes and require routing, resharding and cross-node consistency policies. This project does not claim it has implemented sharding.

**Evidence:** Run `01_partition_exercise.sql` and capture output. Run `02_replication_diagnostics.sql`. With no standby, an empty `pg_stat_replication` result is a factual observation, **not evidence of successful replication**. If you later deploy replicas, add topology, PostgreSQL version, safe configuration excerpts, standby `pg_is_in_recovery()` and primary `pg_stat_replication` evidence, as well as RPO/RTO assumptions.

**Security:** avoid passwords in GitHub. Use TLS, least-privilege roles, restricted networks, encrypted backups and restore drills.

References:
- https://www.postgresql.org/docs/16/warm-standby.html
- https://www.postgresql.org/docs/16/ddl-partitioning.html
- https://www.postgresql.org/docs/16/continuous-archiving.html
