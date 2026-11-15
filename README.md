# MIT 8103 Advanced Database Systems — Crescent City Library

**Case study:** Crescent City Library, a fictional two-branch lending system. PostgreSQL 16 provides the relational source of truth for books, physical copies, borrowers, staff, loans, returns, overdue fines and payments. MongoDB illustrates a separate document-oriented catalogue; PostgreSQL JSONB supports a comparison. Synthetic records only.

## Quick start (fresh training database only)

```bash
createdb library_portfolio
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/01_schema.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/02_seed.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/03_integrity_checks.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f tests/01_smoke_checks.sql
# Optional additional foreign-key indexes
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/07_fk_indexes.sql
```

The 08 constraint tests intentionally encounter errors; execute them separately and capture the results. Portfolio 2 benchmarking inserts large *synthetic* datasets; use an isolated, disposable database and review cleanup instructions.

## Portfolio map

| Component | Folder | Execution order and deliverables |
|---|---|---|
| 1. Design | [portfolio-1-database-design](portfolio-1-database-design/) | Existing 01–03; [04 ERD](portfolio-1-database-design/04_erd.md); [05 normalisation](portfolio-1-database-design/05_normalisation.md); 06 decisions, 07 indexes, 08 constraint tests |
| 2. Optimisation | [portfolio-2-query-optimisation](portfolio-2-query-optimisation/) | 01 reports → 02 benchmark seed → 03 baseline → 04 index → 05 indexed plan; 08 extra queries; optional 09–12 trigram experiment → 13 cleanup; 06–07 results templates |
| 3. Transactions | [portfolio-3-transactions-concurrency](portfolio-3-transactions-concurrency/) | Existing 01–04 and 06–10; 05 direct-insert race; isolated 11–15 deadlock/serializable demos; 00 reset guidance |
| 4. NoSQL | [portfolio-4-nosql-mongodb](portfolio-4-nosql-mongodb/) | Docker MongoDB, seed, query, index, EXPLAIN; [suitability](portfolio-4-nosql-mongodb/05_suitability.md) |
| 4. JSONB comparison | [portfolio-4-nosql-postgresql](portfolio-4-nosql-postgresql/) | Existing 01/02 plus optional 03 larger dataset and 04 cleanup |
| 5. Distributed/cloud | [portfolio-5-distributed-cloud](portfolio-5-distributed-cloud/) | Existing 01–03; 04 consistency analysis and optional [primary/standby Docker lab](portfolio-5-distributed-cloud/docker/) |
| Evidence | [evidence](evidence/) | Run/capture helpers and evidence capture checklist by portfolio |
| Submission | [submission](submission/) | 2–3-page LMS summary, AI declaration, reflection questions, final checklist |

## Evidence

Previously captured PostgreSQL 16.15 outputs, source attribution and execution caveats are recorded in [evidence/README.md](evidence/README.md). New **student-run** capture instructions are in [evidence/CAPTURE_GUIDE.md](evidence/CAPTURE_GUIDE.md), and imported-vs-unexecuted status is in [submission/05_evidence_matrix.md](submission/05_evidence_matrix.md). Scripts are **not evidence of successful execution**. Output files produced by the capture helpers must be inspected/redacted before committing. The original supplied PostgreSQL 16.15 evidence is attributed to an automated Claude run. **The new patch-set scripts and Docker experiments are not executed by me.**

## Limitations

The fine policy is a simple NGN 50/day rule without grace periods or caps; reservations, loan limits and enterprise-grade access control are out of scope. Benchmark loans/books are synthetic and must be removed or clearly separated from normal sample data. MongoDB's embedded-copy availability is a *demonstration* and is not transactionally synchronised with PostgreSQL. The Docker streaming-replication example is a local learning lab, not a production high-availability or automatic-failover deployment. Hash partitioning on one PostgreSQL server is **not sharding**. Asynchronous replicas can return stale reads and may lose transactions during forced failover.

## Contributing / progressive commits

Make small, verifiable commits grouped by portfolio. Keep a meaningful commit series for each component (design → experiment → documentation → evidence). A series recorded over time should reflect real work; **do not alter timestamps or simulate activity**. Never commit passwords, credentials, real borrower records or made-up outputs. The assessment brief requires a private repository with assessor access; use GitHub collaborators to share it.
