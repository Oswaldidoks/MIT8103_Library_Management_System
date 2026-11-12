# MIT 8103 — PostgreSQL Library Management System

**Case study:** Crescent City Library, a simulated two-branch library. **Engine:** PostgreSQL 14+; sample records are synthetic.

## Portfolio map

| Component | Material | What still requires real evidence |
|---|---|---|
| [1. Database design](portfolio-1-database-design/) | SQL schema/seed, [GitHub ERD](portfolio-1-database-design/04_erd.md), [normalisation](portfolio-1-database-design/05_normalisation.md) | Real schema/query screenshots |
| [2. Optimisation](portfolio-2-query-optimisation/) | Reports, optional 100,000-row benchmark, index and EXPLAIN comparisons | Actual before/after timings, buffers and interpretation |
| [3. Transactions](portfolio-3-transactions-concurrency/) | Checkout/return functions, locks and isolated READ COMMITTED / REPEATABLE READ scripts | Two-session screenshots and outputs |
| [4. Advanced document model](portfolio-4-nosql-postgresql/) | JSONB, containment queries and GIN index | Results, suitability explanation; lecturer approval if standalone NoSQL is expected |
| [5. Distributed/cloud](portfolio-5-distributed-cloud/) | Local partitions, read-only replication diagnostics, proposed primary/standby architecture | Observed outputs; do not claim replication deployment |
| [LMS submission](submission/) | Summary and AI-use templates | Your 2–3 page final document and individual reflection |

### First-time setup
Use a new *demonstration* database; do not run these scripts on production:

```bash
createdb library_portfolio
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/01_schema.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/02_seed.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/03_integrity_checks.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f tests/01_smoke_checks.sql
```

For optimisation, run `portfolio-2-query-optimisation/02_benchmark_seed.sql`, then `03_plan_before.sql`, `04_index.sql`, `05_plan_after.sql` **in that order**. Old numbering variants in this folder are superseded. Test concurrency and transaction isolation with two terminals as explained in Portfolio 3's README. Run Portfolio 4 and 5 exercises according to their READMEs.

**Evidence and integrity:** The repository holds scripts and learning materials, not proof of execution. Another AI reported testing earlier scripts on PostgreSQL 16; newly added exercises need to be run independently. Include only genuine plans, results and screenshots. Your own final reflection and accurate AI-use declaration are mandatory. No credentials or real borrower data belong in GitHub.

**Scope limitations:** PostgreSQL JSONB offers document-style modelling but is not a separate NoSQL database. Local partitioning is not sharding. Empty replication status means no replica connection was observed. The institution asks for a private GitHub repository; the owner has elected to keep this one public, so confirm that exception with the assessor.

**Official references:** [PostgreSQL EXPLAIN](https://www.postgresql.org/docs/16/sql-explain.html), [Isolation](https://www.postgresql.org/docs/16/transaction-iso.html), [JSON](https://www.postgresql.org/docs/16/datatype-json.html), [Replication](https://www.postgresql.org/docs/16/warm-standby.html).