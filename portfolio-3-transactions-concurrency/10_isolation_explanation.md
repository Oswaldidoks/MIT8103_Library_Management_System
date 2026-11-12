# Isolation level experiment — PostgreSQL 16

This experiment demonstrates a **non-repeatable read**, separately from the existing `FOR UPDATE` checkout exercise.

Use two psql terminal windows connecting to the **same database**:
1. Run `06_isolation_setup.sql` to set counter `tally=10`.
2. Run `07_read_committed_a.sql` in **session A**. While A sleeps for 12 seconds, run `08_isolation_b.sql` in **session B**.
3. A should see 10 then 11 if B commits before A's second read. This is expected under READ COMMITTED.
4. Run setup again. In session A run `09_repeatable_read_a.sql`; while A sleeps run session B's `08_isolation_b.sql` again.
5. A should see 10 then 10 under REPEATABLE READ, even though B has committed. After A commits, a new SELECT should see 11.

**Important:** The values depend on *timing*. If you launch B after A finishes sleeping, the demonstration is inconclusive; rerun it. Record both terminal timestamps and output, and interpret using your own tests.

READ COMMITTED creates a new snapshot for each ordinary SELECT; REPEATABLE READ uses a stable snapshot for the transaction. Neither of these two examples is meant to trigger a serialization failure. See https://www.postgresql.org/docs/16/transaction-iso.html
