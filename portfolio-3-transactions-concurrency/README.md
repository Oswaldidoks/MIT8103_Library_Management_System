# Portfolio 3 — Transactions and concurrency (7 marks)

Do these experiments in a **fresh disposable seeded database**. Some intentionally cause PostgreSQL errors or mutate data. Capture both terminals for two-session tests. New scripts **not executed by me**.

| Exercise | Files and order | Expected or possible observation (must actually test) |
|---|---|---|
| Reset | `00_reset_demo_state.sql` | Partial reset of tagged test objects only; it does **not** restore changed seed loans. Full reset: recreate demo DB, rerun P1 schema and seed. |
| Commit/rollback | Existing `01_commit_rollback.sql` | COMMIT persists checkout; ROLLBACK undoes separate checkout. |
| Function row lock | Existing `02_session_a.sql` + `03_session_b.sql`, separate terminals | B waits or times out, or fails as copy is already on loan. |
| Overdue return | Existing `04_return_and_fine.sql` | Loan return and fee computed using current date. |
| Partial unique index without function | `05_without_lock_race.sql` setup; A: `05a_direct_session_a.sql`; B: `05b_direct_session_b.sql` | B waits for A's direct INSERT then gets duplicate open-loan error `23505` if A commits first. |
| Isolation | Existing `06_isolation_setup.sql`; A: `07_read_committed_a.sql` + B: `08_isolation_b.sql`; reset; A: `09_repeatable_read_a.sql` + B | READ COMMITTED may see new value; REPEATABLE READ keeps snapshot. |
| Deadlock | `11_deadlock_setup.sql`; A: `12_deadlock_session_a.sql`; B: `13_deadlock_session_b.sql` | One transaction may fail with SQLSTATE `40P01` due to opposite lock order. |
| Serializable write skew | `14_serializable_setup.sql`; A: `15_serializable_session_a.sql`; B: `16_serializable_session_b.sql` | One overlapping transaction may fail `40001`; **not guaranteed** without correct concurrent overlap. |

Read `10_isolation_explanation.md` for PostgreSQL-specific isolation matrix, scheduling and retry pattern. On deadlock/serialization errors the application should rollback and retry the **whole** transaction with backoff. Avoid claiming SQLSTATEs without real output.
