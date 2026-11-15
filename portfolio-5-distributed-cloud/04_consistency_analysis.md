# Consistency, sharding and cloud-design analysis — Crescent City Library

**This is a design worksheet, not a report of observed replication.** Fill observed outcomes using real Docker lab evidence. The existing `01_partition_exercise.sql` and `02_replication_diagnostics.sql` remain unchanged; local hash partitioning is NOT sharding.

## Read-after-write example

A borrower checks out physical copy `CCL-0001` on the **primary**. The checkout function commits and the loan is immediately authoritative on the primary, but an asynchronous standby may be behind. A catalogue availability check sent to the standby *immediately* after that checkout can temporarily show the copy as available. For read-your-writes consistency, route the immediate availability confirmation and all checkout/return/fine reads involved in a transaction to the **primary**, or use an explicitly designed wait-for-replay/LSN mechanism.

| Operation | Suggested endpoint | Rationale |
|---|---|---|
| Checkout, return, fine assessment/payment | Primary only | Transactionally consistent write and constraint checks |
| Immediate availability after checkout | Primary | Avoid stale read after recent write |
| Borrower/account history with strict freshness | Primary | Financial and loan-state consistency |
| Trend reports and older catalogue browsing | Standby *if lag acceptable* | Can tolerate asynchronous replication lag; monitor lag |
| Backups and restore | Independent, tested backup procedure | A replica is not a substitute for backups |

## Partitioning versus sharding

`01_partition_exercise.sql` hashes borrower_id into **partitions on one PostgreSQL instance**. A conceptual branch-based shard layout would use `branch_id` as a routing key to direct branch-owned copies and transactions to physically separate database nodes. This would complicate borrower-wide history (a borrower may visit multiple branches), cross-shard consistency, shared book titles, failover and **resharding** when branches are added or workload shifts. Treat this as a proposal, not implemented functionality.

## CAP, PACELC, RPO and RTO

CAP matters during network partitions: an application must choose whether to reject some operations or serve potentially divergent/stale results. In normal operation (else case, PACELC), a system also weighs latency against tighter consistency. An asynchronous read replica is **not a simple full-system CAP classification**: catalogue/reporting reads may be stale while primary writes remain authoritative.

| Planning assumption — replace with your own | Value / rationale |
|---|---|
| Required RPO | **FILL MY OWN ASSUMPTION** (not measured) |
| Required RTO | **FILL MY OWN ASSUMPTION** (not measured) |
| Acceptable catalogue lag | **FILL MY OWN ASSUMPTION** |
| Backup interval, WAL archival, restore testing | **FILL MY OWN PLAN** |
| Monitoring/alerting for lag and disk | **FILL MY OWN PLAN** |

## Observed versus proposed

| Feature | Proposed design | Actually observed — FILL FROM MY OWN EVIDENCE |
|---|---|---|
| Local hash partitioning | Experiment within one instance | |
| Primary/standby streaming | Optional local Docker lab | |
| Probe replay and lag | Unique row on primary, query on standby | |
| Standby read-only rejection | SQLSTATE 25006 expected | |
| Automatic failover | Not implemented | |
| Cloud deployment / managed backup | Not implemented | |
