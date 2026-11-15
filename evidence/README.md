# Evidence – MIT 8103 Crescent City Library (PostgreSQL)

## Provenance (read before submitting)
These files are the **real, unedited output** of running the repository's scripts against a fresh
PostgreSQL 16 database on **15 Nov 2026**. The run was performed by an automated sandbox
session with Claude (Anthropic), **not on the student's own machine**. Every file starts with a header
stating the date, source script, PostgreSQL version and who ran it.

Student to-do before relying on this: re-run the scripts on your own PostgreSQL install, take your
own screenshots, and replace or add to these files. Declare in the AI-use declaration that Claude
executed the first capture run. Do not present these outputs as your own runs.

Harness notes (the only differences from running the scripts by hand):
- Output was captured with `psql -X -a` so the statements and results appear together.
- Portfolio 3 lock test: a `SELECT pg_sleep(5);` was inserted before session A's `COMMIT` so that session B
  could run while A held the lock. Session B started about 1.5 s after A.
- Isolation tests: session B started 3 s into session A's 12 s sleep.

## Index
| Folder | Files | What they show |
|---|---|---|
| portfolio-1 | 01–04 | Schema creation, seed data, integrity checks, smoke tests |
| portfolio-2 | 01–06 | Report queries, 100,000-row benchmark seed, three before and three after plans, index and table sizes |
| portfolio-3 | 01–10 | Commit and rollback, two-session lock test, return and fine, READ COMMITTED vs REPEATABLE READ |
| portfolio-4 | 01 | JSONB queries and GIN index plan (8 rows only) |
| portfolio-5 | 01–02 | Partitioning exercise; replication diagnostics on a standalone server |

## Key observations (check each against the files)
- **Portfolio 2:** `Execution Time` before the index: 8.010 / 7.914 / 8.082 ms (Seq Scan on loans). After
  `idx_loans_borrower_date`: 0.064 / 0.059 / 0.058 ms (Index Scan). Table 10 MB; new index 3104 kB.
  Dataset: 100,006 loans.
- **Portfolio 3 lock test:** session B waited for A and then failed with `Copy 10 is already on loan`
  after A committed (see 03_lock_session_b_output.txt for start and finish times).
- **Portfolio 3 isolation:** READ COMMITTED returned 10 then 11. REPEATABLE READ returned 10 then 10.
- **Portfolio 4:** the GIN index is not used on 8 rows; the planner prefers a sequential scan.
- **Portfolio 5:** replication diagnostics are empty because no replica is connected. Partitioning is
  not sharding.

## Limits
Timings come from one sandbox machine; absolute numbers will differ on yours, but the plan shapes should match.
No replication, MongoDB or cloud deployment was run.
