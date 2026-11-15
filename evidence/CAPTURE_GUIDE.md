# Execution evidence — capture checklist

**This directory contains instructions, not results.** All outputs and screenshots must come from an actual run. Avoid passwords, connection strings containing credentials, tokens and personal information. Evidence directories may contain `.gitkeep` files until real proof is added.

## Naming convention

Place your output under `evidence/portfolio-1/` ... `evidence/portfolio-5/` (create directories if missing). Use ordered names such as `01_schema_run_YYYYMMDD_HHMMSS.txt`, `01_before_plan_YYYYMMDD_HHMMSS.txt`, `02_after_plan_YYYYMMDD_HHMMSS.txt`, `03_session_a_YYYYMMDD_HHMMSS.png`. Preserve original output; label manually written notes as analysis, not terminal output.

## Checklists

- **Portfolio 1:** server version; schema and seed output; integrity/smoke checks; ER diagram screenshot; six intentional constraint failures and SQLSTATE/error messages; foreign-key index list; comment on 1NF–3NF.
- **Portfolio 2:** PostgreSQL/OS version and row counts; borrower/date EXPLAIN before and after (three runs each); execution times, rows, buffers, median; index disk size; title search before/after trigram; discussion of query plans and index write/storage trade-offs.
- **Portfolio 3:** COMMIT/ROLLBACK results; checkout function race with both session terminals; direct INSERT race (unique-index error); two-session deadlock (detected SQLSTATE `40P01`) and retry discussion; READ COMMITTED versus REPEATABLE READ reads; SERIALIZABLE write-skew test (SQLSTATE `40001` if conflict arises); returned loan/fine result.
- **Portfolio 4:** MongoDB Docker version/config without secrets; seed count and representative redacted document; subject query, aggregation, availability update, indexes and actual before/after `executionStats`; PostgreSQL JSONB plan before/after larger dataset (optional); suitability discussion.
- **Portfolio 5:** local partition distribution; primary and standby server versions; `pg_stat_replication` on primary; `pg_is_in_recovery` and replay LSN on standby; a uniquely identified test row inserted on primary and then observed on standby; failed standby-write command/output; replica-lag discussion; failover and consistency analysis (mark simulated vs observed).

## Bash runner

From the repository root:

```bash
chmod +x evidence/run_and_capture.sh
./evidence/run_and_capture.sh library_portfolio portfolio-1 portfolio-1-database-design/03_integrity_checks.sql
./evidence/run_and_capture.sh library_portfolio portfolio-2 portfolio-2-query-optimisation/03_plan_before.sql
```

The helper first records PostgreSQL version, then runs `psql -X` with `ON_ERROR_STOP=1`, capturing stdout **and stderr** via `tee` to a timestamped `.txt`. It exits nonzero if SQL fails. For scripts that deliberately exit nonzero (for example the direct-insert race loser), `--expect-error` captures that failure without claiming success. The six constraint tests in `08_constraint_tests.sql` catch their own expected errors, so run them **without** `--expect-error` and verify six NOTICEs manually.

## PowerShell runner

```powershell
./evidence/run_and_capture.ps1 -Database library_portfolio -Portfolio portfolio-1 -Script portfolio-1-database-design/03_integrity_checks.sql
./evidence/run_and_capture.ps1 -Database library_portfolio -Portfolio portfolio-1 -Script portfolio-1-database-design/08_constraint_tests.sql
```

These helpers require `psql` on PATH, valid local authentication, a working PostgreSQL connection and no embedded passwords. The scripts do not generate screenshots; take your own screenshots with your OS and save `.png` files here.
