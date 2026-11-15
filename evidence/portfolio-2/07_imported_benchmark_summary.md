# Imported automated sandbox benchmark: read-only summary

**Provenance:** Values are transcribed from the supplied PostgreSQL 16.15 logs, explicitly attributed to an automated Claude sandbox run on **15 November 2026**. **Not executed by me** during this integration. They do **not** represent your own local measurements.

| Run | Before (ms) | Before node | After (ms) | After node |
|---|---:|---|---:|---|
| 1 | 8.010 | Seq Scan | 0.064 | Index Scan |
| 2 | 7.914 | Seq Scan | 0.059 | Index Scan |
| 3 | 8.082 | Seq Scan | 0.058 | Index Scan |

- Median before: **8.010 ms**; median after: **0.059 ms**.
- Difference in these three-run medians: **99.26% less execution time**, approximately **135.8×** by division, in this particular benchmark.
- Original evidence: [before run 1](03_plan_before_run1.txt), [before run 2](03_plan_before_run2.txt), [before run 3](03_plan_before_run3.txt); [after run 1](05_plan_after_run1.txt), [after run 2](05_plan_after_run2.txt), [after run 3](05_plan_after_run3.txt); [size output](06_index_sizes_output.txt).
- These are **execution** times, not total query latency; separate planning time and data/buffer sizes must be reviewed in each original output.
- Local environment, caching, and row distribution affect any result. Do not present this source-backed summary as your own measurement or treat speedup as universal.

**Your own follow-up:** rerun the unchanged base comparison on your PostgreSQL installation, capture version, total row count and all six plans, record median and contrast with the imported test, then write your own interpretation in `portfolio-2-query-optimisation/07_performance_analysis.md`.
