# Portfolio 3 — Transactions and concurrency (7 marks)

On fresh seed data, run `01_commit_rollback.sql`. For the checkout race, use TWO terminals: `02_session_a.sql` in A then `03_session_b.sql` in B *before A commits*. Capture outcomes and time spent waiting. Run `04_return_and_fine.sql` on fresh seed data.

**Isolation-level extension:** run `06_isolation_setup.sql`. While `07_read_committed_a.sql` is sleeping in session A, execute `08_isolation_b.sql` in session B. Reset with `06_isolation_setup.sql` and repeat using `09_repeatable_read_a.sql` and B. See `10_isolation_explanation.md`. Record actual outputs; scheduling/timing matters.