# Portfolio 2 — Query processing/optimisation (7 marks)

**All data changes are for a disposable training database.** Recommended ordered sequence:

1. Existing `01_queries.sql`: basic library reports.
2. Existing `02_benchmark_seed.sql`: adds 1,000 copies and 100,000 synthetic *closed* loans; preserve the already-reviewed script.
3. Existing `03_plan_before.sql`: borrower/date baseline.
4. Existing `04_index.sql`: borrower/date index.
5. Existing `05_plan_after.sql`: same query with index.
6. Existing `06_results_template.csv`: recorded measurements; revised `07_performance_analysis.md` explains three-run median protocol and interpretation.
7. `08_extra_queries.sql`: six further operational queries, including aggregation, CTEs and window rank.
8. Optional trigram experiment: `09_titles_benchmark_seed.sql` → `10_trgm_before.sql` → `11_trgm_index.sql` → `12_trgm_after.sql`. A normal B-tree cannot generally accelerate `ILIKE '%data%'` because the leading `%` prevents a fixed prefix; pg_trgm GIN may help. Record actual plans and disk size.
9. `13_cleanup_benchmark.sql` deletes only marked benchmark loans/copies/titles and drops only the experiment trigram index. Review counts first.

Capture **each** before/after plan 3 times, report median execution time, actual plan nodes, rows/buffers, dataset size, PostgreSQL version and index storage. A sequential scan can be the right choice; do not claim speedups without actual output. See `evidence/README.md`. New experiments: **not executed by me**.
