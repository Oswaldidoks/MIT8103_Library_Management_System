# PostgreSQL JSONB comparison (supporting Portfolio 4 experiment)

The existing `01_jsonb_examples.sql` and `02_document_example.json` remain unchanged. They demonstrate document attributes within PostgreSQL, **not an independent NoSQL DBMS**. The separate [MongoDB folder](../portfolio-4-nosql-mongodb/) now supplies the standalone document-store implementation.

Optional larger-data comparison (not executed by me):

```bash
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-4-nosql-postgresql/03_gin_larger_data.sql
# capture the real unindexed and indexed EXPLAIN ANALYZE outputs
psql -X -v ON_ERROR_STOP=1 -d library_portfolio -f portfolio-4-nosql-postgresql/04_cleanup_jsonb_benchmark.sql
```

This experiment creates 50,000 obviously synthetic books and temporarily drops/recreates the test index `ix_books_metadata_gin`; run **only in a disposable database**. A real EXPLAIN plan may still select sequential scan. Write a comparison of JSONB GIN, MongoDB subjects multikey index and the relational data model using genuine output.
