# Portfolio 1 — Design and modelling (7 marks)

1. Existing `01_schema.sql` creates 11 relational entities, constraints, functions and views. Run on fresh PostgreSQL database.
2. Existing `02_seed.sql` inserts synthetic Crescent City Library records.
3. Existing `03_integrity_checks.sql` inspects tables, views, open loans and indexes.
4. `04_erd.md` documents **all** schema attributes and the two independent staff/loan foreign-key relationships.
5. `05_normalisation.md` explains a flat library record transformed to 1NF, 2NF and 3NF.
6. `06_design_decisions.md` contains trade-off questions to rewrite in your own words.
7. `07_fk_indexes.sql` adds optional B-tree indexes on frequently joined foreign keys. Existing primary/unique/partial indexes stay intact.
8. `08_constraint_tests.sql` intentionally attempts six invalid operations, catches expected SQLSTATEs and logs NOTICEs. Must be run with seed data in an isolated training DB.

**Capture:** server version, initial schema/seed/check output, six constraint NOTICEs, ERD screenshot, optional index list and personal design explanation under `evidence/portfolio-1/`. Nothing has been executed by me for this patch set.
