# Portfolio 2 — Before/after query plan analysis

Run the same library query twice, once without and once with `idx_loans_borrower_date`. First execute `02_benchmark_seed.sql` in a fresh demo database (100,000 synthetic historical loans). Run scripts `03_plan_before.sql`, `04_index.sql`, and `05_plan_after.sql` in this order; save actual terminal output in `evidence/portfolio-2/`.

## Experiment
**Question:** Does `(borrower_id, loaned_at DESC)` speed up recent-loan lookup for one borrower with `LIMIT 25`?

**Before:** [Paste actual scan/sort node, execution time, buffers, rows.]
**After:** [Paste actual scan node, execution time, buffers, rows.]
**Comparison:** [Explain improvement or regression. Do **not** claim an index is always faster. A small table, cache, data distribution or selectivity can favour a sequential scan.]

## Index reasoning
The first indexed column matches `borrower_id = 4`; the second helps the range predicate and descending ordering. The partial unique index on `copy_id WHERE returned_at IS NULL` prevents duplicate active loans but is not a suitable index for this borrower/date query.

## Fair measurements
Use equal SQL predicates and the same dataset. Save `SELECT version();`, row count, full `EXPLAIN (ANALYZE, BUFFERS)` plans, and any timing variation from repeated runs. EXPLAIN ANALYZE **actually executes** the query. Planning time and execution time are separate. Do not use `enable_seqscan=off` as evidence that an index is naturally beneficial.

## Optional catalogue search
For `ILIKE '%data%'` on a realistically large titles table, consider `pg_trgm` and a GIN index, but first verify `pg_trgm` is available and compare plans. With just eight sample books, a sequential scan is often reasonable.

Official references: https://www.postgresql.org/docs/16/sql-explain.html and https://www.postgresql.org/docs/16/indexes-multicolumn.html
