# MIT 8103 — PostgreSQL Library Management System

Case study: **Crescent City Library**, a fictional two-branch library.

The repository demonstrates PostgreSQL relational design, catalogue search and query optimisation, transactions/concurrency, JSONB document modelling, and partitioning/replication diagnostics.

## Run locally

Install PostgreSQL 14+ and create a fresh demonstration database:

```bash
createdb library_portfolio
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/01_schema.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-1-database-design/02_seed.sql
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f tests/01_smoke_checks.sql
```

The data is synthetic. The code has not been verified against a running PostgreSQL server in this chat. Capture genuine query plans and screenshots, provide a personal reflection, and include an accurate AI-use declaration.

**Assessment warning:** The course brief requires a *private* GitHub repository. This repository is public at the owner's request. Confirm acceptability with the lecturer. PostgreSQL JSONB is document-style modelling, not a standalone NoSQL DBMS; confirm Portfolio 4 expectations.

The provided project ZIP contains additional material that may not yet be mirrored here. Check the repository contents before submission.
