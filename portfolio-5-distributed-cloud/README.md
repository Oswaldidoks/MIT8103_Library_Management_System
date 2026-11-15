# Portfolio 5 — distributed/cloud concepts (6 marks)

1. Existing `01_partition_exercise.sql`: execute and capture local hash partition routing/pruning. A partition is on **one server**, not distributed sharding.
2. Existing `02_replication_diagnostics.sql`: inspect the current server. Empty `pg_stat_replication` is **not** evidence that replication was deployed.
3. `03_cloud_architecture.md`: clearly labelled *design* and observed-versus-proposed table.
4. `04_consistency_analysis.md`: real library read-after-write example, replica routing, RPO/RTO and branch-based conceptual sharding.
5. Optional [docker/](docker/) PostgreSQL 16 primary/standby asynchronous WAL streaming demo with redacted actual primary/standby/probe results. This is a **local Docker lab**, not a deployed cloud or automatic failover cluster.

Keep exact terminal commands, both PostgreSQL server versions, failover outcome if undertaken, and your own conclusions in `evidence/portfolio-5/`. All Docker and new SQL materials are **not executed by me**.
