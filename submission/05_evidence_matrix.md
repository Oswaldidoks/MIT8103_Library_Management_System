# Evidence-backed integration matrix (status as prepared)

**Interpretation:** “Imported log” means an unaltered record supplied by the user, attributed in its header to Claude's automated PostgreSQL 16.15 sandbox on 15 November 2026. It is **not** your own execution, not a screenshot, and not independent execution by this integrator. “New experiment” means source code/templates only (**not executed by me**).

| Portfolio | Imported output files | Demonstrated by imported logs | Prepared source without new execution evidence | What the student must capture |
|---|---:|---|---|---|
| 1 | 4 | schema, seed, integrity and smoke checks | constraint failures, optional FK indexes | Own database run and ERD screenshots |
| 2 | 10 | reports, 100k historical synthetic loans, three pre-/post-index plans, index sizes | six extra queries, 50k-title pg_trgm experiment, cleanup | Repeat plans, trigram evidence and explain observed plan choice |
| 3 | 10 | COMMIT/ROLLBACK, concurrency checkout, return/fine, READ COMMITTED and REPEATABLE READ | direct-insert index race, deadlock, SERIALIZABLE | Own two-terminal screenshots and real SQLSTATE errors |
| 4 | 1 PostgreSQL log + user screenshots | PostgreSQL JSONB example in imported log; Windows screenshots show MongoDB 7.0.16 started, 8 catalogue documents seeded, and COLLSCAN→IXSCAN query-plan change (8 vs 2 documents examined) | MongoDB `02_queries.js` and `03_indexes.js` outputs not yet evidenced; larger JSONB benchmark not evidenced | Preserve original Windows screenshots; capture missing commands and full outputs; explain small-sample limitation |
| 5 | 2 | single-node partition and standalone replication diagnostics (no replica) | asynchronous local primary/standby Docker lab, consistency and failover notes | Primary + standby observed status and replay probe |

**Current branch disclaimer:** This integration is an **overlay on the existing GitHub code**, not a replacement of its PostgreSQL scripts. The supplied ZIP cannot independently confirm that every log matches a current source revision; verify SHA/version and rerun any experiments needed for your assessment.

**Windows MongoDB screenshot provenance:** [Portfolio 4 observations](../evidence/portfolio-4/README_WINDOWS_SCREENSHOTS.md) record user-supplied screenshots distinct from the 27 imported Claude logs. Until binary PNGs are present in the repository, use the separate supplied screenshot archive; do not misstate this Markdown note as image evidence. 

**Reflection and AI use:** Complete `submission/03_reflection_prompts.md` yourself. Fill `submission/02_ai_use_declaration_template.md` with tools actually used, including any AI involved in source generation and testing; do not describe imported logs as student-run tests. Do not put passwords or private/real patron data in the repository.
