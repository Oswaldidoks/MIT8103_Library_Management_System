-- Optional supporting B-tree indexes for join/filter foreign-key columns.
-- PostgreSQL indexes primary/unique keys automatically, but does not automatically
-- create an index on each REFERENCING foreign-key column.
-- Run AFTER 01_schema.sql, in the same training database. Safe to rerun.
-- Existing unique partial index loans(copy_id) WHERE returned_at IS NULL
-- only covers open-loan queries, so a full loans(copy_id) index helps history.
-- Existing book_authors PK(book_id,author_id) starts with book_id;
-- an author-first join benefits from a separate author_id index.

CREATE INDEX IF NOT EXISTS ix_staff_branch_fk
  ON library.staff(branch_id);
CREATE INDEX IF NOT EXISTS ix_book_copies_book_fk
  ON library.book_copies(book_id);
CREATE INDEX IF NOT EXISTS ix_book_copies_branch_fk
  ON library.book_copies(branch_id);
CREATE INDEX IF NOT EXISTS ix_book_authors_author_fk
  ON library.book_authors(author_id);
CREATE INDEX IF NOT EXISTS ix_loans_borrower_fk
  ON library.loans(borrower_id);
CREATE INDEX IF NOT EXISTS ix_loans_copy_history_fk
  ON library.loans(copy_id);
CREATE INDEX IF NOT EXISTS ix_fine_payments_fine_fk
  ON library.fine_payments(fine_id);

-- Show real index definitions. Indexes consume storage and add write overhead;
-- measure query benefits before deciding all should stay in a production schema.
SELECT tablename,indexname,indexdef
FROM pg_indexes
WHERE schemaname='library'
  AND indexname LIKE 'ix_%_fk' OR schemaname='library'
  AND indexname='ix_loans_copy_history_fk'
ORDER BY tablename,indexname;
