# Portfolio 2 — Query optimisation (7 marks)

Run `01_queries.sql` for reports. In a fresh demo database, optionally run `02_benchmark_seed.sql` to create 100,000 synthetic historical loans (check disk capacity). Then run `03_plan_before.sql`, `04_index.sql`, `05_plan_after.sql` **in this order**. Save actual EXPLAIN ANALYZE BUFFERS output. Record results in `06_results_template.csv` and describe your interpretation in `07_performance_analysis.md`.

Use only these numbered performance scripts; older `02_plan_before.sql`, `03_index.sql`, and `04_plan_after.sql` are superseded and must not be included in your execution sequence. If PostgreSQL chooses a sequential scan, explain why; never fabricate an index speedup.