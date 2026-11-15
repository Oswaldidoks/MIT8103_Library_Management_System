# Portfolio 5 — PostgreSQL cloud architecture **design**

This document describes a **proposed architecture** for Crescent City Library. An optional single-host Docker lab in [docker/](docker/) implements a primary and asynchronous physical streaming standby; this is **not** a deployed cloud service and does **not** provide automatic failover.

```text
  Library application -- committed checkout, return, fines --> PRIMARY
       |                                                 |
       +-- tolerated-lag catalogue & reporting ----------+--> STANDBY (async WAL)
                                                           ^
  PRIMARY -- WAL stream ------------------------------------+
       |
       +-- independent base backups + WAL archive (planned, NOT implemented)
```

All writes go to the primary. An immediate availability check after checkout must also use the primary or explicitly wait for the replica to replay the relevant transaction. Catalogue/reporting reads may use the standby when staleness is acceptable. Asynchronous replication can lose acknowledged-but-not-replayed transactions if a standby is promoted after primary failure; replication alone is **not** a backup system.

### What I observed vs what I proposed — FILL FROM MY OWN EVIDENCE

| Component | Proposed | Observed by me (commands, dates, evidence files) |
|---|---|---|
| Hash partition experiment | Existing single-server SQL | **FILL FROM MY OWN EVIDENCE** |
| Replication diagnostics | Existing diagnostic SQL | **FILL FROM MY OWN EVIDENCE** |
| Streaming primary/standby | Optional Docker files | **FILL FROM MY OWN EVIDENCE / NOT RUN** |
| Replicated probe | Primary INSERT, standby SELECT | **FILL FROM MY OWN EVIDENCE / NOT RUN** |
| Standby write rejection | Expected SQLSTATE 25006 | **FILL FROM MY OWN EVIDENCE / NOT RUN** |
| Promotion/failover | Manual design only | **FILL FROM MY OWN EVIDENCE / NOT RUN** |
| Managed cloud, backups and point-in-time restore | Design, not configured | **NOT IMPLEMENTED**, unless I actually deploy it |

### Single-node partitioning is not sharding

`01_partition_exercise.sql` uses local hash partitions. Multi-node sharding would route data by a chosen key (potentially branch_id) across separate database servers and would require coordination for shared borrower history, cross-shard queries, capacity balancing and re-sharding. The trade-offs are considered further in [04_consistency_analysis.md](04_consistency_analysis.md).

### References

[Streaming replication](https://www.postgresql.org/docs/16/warm-standby.html); [Partitioning](https://www.postgresql.org/docs/16/ddl-partitioning.html); [Continuous archiving](https://www.postgresql.org/docs/16/continuous-archiving.html).
