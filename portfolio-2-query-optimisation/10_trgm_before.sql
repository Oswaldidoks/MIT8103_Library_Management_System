-- Baseline for a leading-wildcard search. A standard B-tree index on title
-- cannot generally speed up ILIKE '%data%' because there is no fixed prefix.
-- This removes ONLY our experimental trigram index if it already exists.
DROP INDEX IF EXISTS library.idx_books_title_trgm;
ANALYZE library.books;
EXPLAIN (ANALYZE, BUFFERS)
SELECT book_id,title FROM library.books
WHERE title ILIKE '%data%'
ORDER BY book_id;
