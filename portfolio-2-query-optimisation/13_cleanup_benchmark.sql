-- DESTRUCTIVE within a DEMO database: deletes ONLY specially tagged benchmark data.
-- Review counts first; this script does not remove genuine seeded library rows.
-- Requires no other new rows referencing benchmark titles/copies.
BEGIN;
SELECT COUNT(*) AS benchmark_loans_before FROM library.loans WHERE notes='BENCHMARK_ROWS';
SELECT COUNT(*) AS benchmark_copies_before FROM library.book_copies WHERE barcode LIKE 'BENCH-%';
SELECT COUNT(*) AS benchmark_titles_before FROM library.books
 WHERE publisher='BENCHMARK_SYNTHETIC' AND metadata @> '{"synthetic":true}'::jsonb;

-- Loans must be deleted before their physical copies because of the foreign key.
DELETE FROM library.loans WHERE notes='BENCHMARK_ROWS';
DELETE FROM library.book_copies WHERE barcode LIKE 'BENCH-%';
DELETE FROM library.books WHERE publisher='BENCHMARK_SYNTHETIC'
  AND metadata @> '{"synthetic":true}'::jsonb;
COMMIT;
-- Keep indexing experiments separate; remove only benchmark-specific trigram index.
DROP INDEX IF EXISTS library.idx_books_title_trgm;
ANALYZE library.books;
ANALYZE library.loans;
