# PostgreSQL 16 transaction isolation — observation worksheet

**Status: not executed by me.** Two terminals and the same database are required; record actual outcomes. Existing READ COMMITTED/REPEATABLE READ demo scripts `06_isolation_setup.sql`, `07_read_committed_a.sql`, `08_isolation_b.sql` and `09_repeatable_read_a.sql` remain unchanged.

| PostgreSQL isolation level | Dirty reads | Non-repeatable reads | Phantom-like changes | Write-skew / serialization anomalies |
|---|---|---|---|---|
| READ COMMITTED | Prevented | Possible between statements | Possible between statements | Possible |
| REPEATABLE READ (snapshot isolation) | Prevented | Prevented by stable snapshot | Prevented for repeated snapshot reads | **Possible** (write skew across different rows) |
| SERIALIZABLE (SSI) | Prevented | Prevented | Prevented | Detected/aborted as `40001` where concurrent history would be non-serializable; applications must retry |

PostgreSQL **does not implement READ UNCOMMITTED as a weaker level**; it behaves as READ COMMITTED. PostgreSQL's REPEATABLE READ is stronger than the SQL minimum in preventing phantom reads but can still allow write skew. SERIALIZABLE uses Serializable Snapshot Isolation (SSI): it may abort one transaction instead of waiting, so the entire transaction must be retried. See the [PostgreSQL transaction isolation documentation](https://www.postgresql.org/docs/16/transaction-iso.html).

## Capture exercises

1. Reset `06_isolation_setup.sql` to `tally=10`; run READ COMMITTED session A and session B while A sleeps. Expected **if timing is correct**: A reads 10 then 11.
2. Reset again; run REPEATABLE READ session A/B. Expected **if timing is correct**: A reads 10 twice; a new transaction sees B's committed 11.
3. Run `05_without_lock_race.sql`, then 05a/05b in two sessions. The unique partial index must reject a second open loan, even without the PL/pgSQL checkout function. Record whether B waited.
4. Run `11_deadlock_setup.sql`, then `12_deadlock_session_a.sql` and `13_deadlock_session_b.sql` simultaneously. Capture a real deadlock `40P01` if it occurs; one transaction can be rolled back.
5. Run `14_serializable_setup.sql`, then `15_serializable_session_a.sql` and `16_serializable_session_b.sql` simultaneously. A write-skew-style conflict may produce `40001`. **Expected-not-guaranteed:** scheduling and snapshots determine whether both transactions overlap meaningfully. Reset and repeat if inconclusive.

## Retry pattern for a real application

Catch SQLSTATE `40P01` (deadlock) or `40001` (serialization failure); rollback the failed transaction, wait with bounded exponential backoff plus jitter, and **rerun the complete transaction**, including reading the current business state and validating invariants, up to a configured retry limit. Apply consistent lock ordering when possible to reduce deadlock frequency. Do not blindly replay side effects such as sending emails or payments without idempotency protection.

| Evidence item | FILL FROM MY OWN EVIDENCE |
|---|---|
| Actual database version | |
| A/B READ COMMITTED outputs | |
| A/B REPEATABLE READ outputs | |
| Direct-index race outcome | |
| Deadlock SQLSTATE and sessions | |
| Serializable SQLSTATE and sessions | |
| My explanation of observed anomalies | |
