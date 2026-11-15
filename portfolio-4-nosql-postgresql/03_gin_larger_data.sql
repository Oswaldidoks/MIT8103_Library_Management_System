-- Optional PostgreSQL JSONB index experiment with 50,000 synthetic book titles.
-- Run on a fresh/disposable database AFTER Portfolio 1 schema+seed.
-- This script temporarily removes/recreates the existing JSONB demo index
-- to provide comparable baseline/indexed plans. Do NOT run on production.
-- Existing portfolio-4 01_jsonb_examples.sql remains unchanged.
BEGIN;
INSERT INTO library.books(isbn,title,category_id,publication_year,publisher,metadata)
SELECT '9788'||LPAD(g::text,9,'0'),
       'JSONB_BENCH_BOOK_'||g,1,2024,'BENCH_JSONB',
       jsonb_build_object('benchmark','jsonb_50k',
          'subjects', CASE WHEN g%101=0 THEN jsonb_build_array('rare_index_subject')
                           ELSE jsonb_build_array('common_subject') END,
          'language','en')
FROM generate_series(1,50000) g
ON CONFLICT(isbn) DO NOTHING;
COMMIT;
ANALYZE library.books;
-- Original 01_jsonb_examples.sql may already have created this index.
-- Drop exactly that test index to obtain an unindexed baseline.
DROP INDEX IF EXISTS library.ix_books_metadata_gin;
EXPLAIN (ANALYZE,BUFFERS)
SELECT book_id,title FROM library.books
WHERE metadata @> '{"subjects":["rare_index_subject"]}'::jsonb;
-- Recreate the same JSONB index definition for the indexed comparison.
CREATE INDEX IF NOT EXISTS ix_books_metadata_gin
 ON library.books USING GIN(metadata);
ANALYZE library.books;
EXPLAIN (ANALYZE,BUFFERS)
SELECT book_id,title FROM library.books
WHERE metadata @> '{"subjects":["rare_index_subject"]}'::jsonb;
SELECT pg_size_pretty(pg_relation_size('library.ix_books_metadata_gin'::regclass)) AS gin_bytes;
