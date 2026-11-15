# Portfolio 2 — performance analysis worksheet

**Status: FILL FROM MY OWN EVIDENCE.** This is a comparison structure, not measured results. Save the original terminal output under `evidence/portfolio-2/` and cite filenames below.

## Environment and data

| Field | FILL FROM MY OWN EVIDENCE |
|---|---|
| PostgreSQL version / OS | **FILL FROM MY OWN EVIDENCE** |
| CPU/RAM/storage (if known) | **FILL FROM MY OWN EVIDENCE** |
| Database and sample row counts | **FILL FROM MY OWN EVIDENCE** |
| Seed command and date | **FILL FROM MY OWN EVIDENCE** |
| Exact SQL query | **FILL FROM MY OWN EVIDENCE** (copy from `03_plan_before.sql` / `05_plan_after.sql`) |
| Before plan output file | **FILL FROM MY OWN EVIDENCE** |
| After plan output file | **FILL FROM MY OWN EVIDENCE** |

## Repeat-run protocol

1. Execute `02_benchmark_seed.sql` in a disposable seeded database; run `ANALYZE library.loans`.
2. Run `03_plan_before.sql` **three times** and keep all three complete `EXPLAIN (ANALYZE, BUFFERS)` plans.
3. Run `04_index.sql`, then `05_plan_after.sql` **three times**. Do not change SQL predicates between trials.
4. Record execution time, planning time, node type, rows, shared hit/read buffers for every run; report the **median** of each set of three execution times. Warm cache effects and other running processes may affect the comparison.
5. Record index size after creation:

```sql
SELECT pg_size_pretty(pg_relation_size('library.idx_loans_borrower_date'::regclass)) AS index_size;
```

## Before and after: enter only measured values

| Measurement | Before — FILL FROM MY OWN EVIDENCE | After — FILL FROM MY OWN EVIDENCE |
|---|---|---|
| Plan node(s) | | |
| Planning time (ms), run 1/2/3 | | |
| Execution time (ms), run 1/2/3 | | |
| Median execution time (ms) | | |
| Rows output | | |
| Shared hit buffers | | |
| Shared read buffers | | |
| Disk size of index | n/a | |

## Interpretation — answer in your own words

- Why did the planner choose an index or a sequential scan? Was there a Sort or Bitmap Heap Scan? **FILL FROM MY OWN EVIDENCE.**
- Why is `borrower_id` the leading key column, with `loaned_at DESC` second? **FILL FROM MY OWN EVIDENCE.**
- Is the actual speedup meaningful across the **median of three** runs? What could caching explain? **FILL FROM MY OWN EVIDENCE.**
- What extra disk space, INSERT/UPDATE/DELETE maintenance and vacuum costs does the index create? **FILL FROM MY OWN EVIDENCE.**
- Did the separate `pg_trgm` title benchmark choose a GIN-assisted plan for `ILIKE '%data%'`? **FILL FROM MY OWN EVIDENCE.**

### Sources

[PostgreSQL 16 EXPLAIN](https://www.postgresql.org/docs/16/sql-explain.html); [multicolumn indexes](https://www.postgresql.org/docs/16/indexes-multicolumn.html); [pg_trgm](https://www.postgresql.org/docs/16/pgtrgm.html).
