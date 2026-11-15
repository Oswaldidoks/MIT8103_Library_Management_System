-- Identical SQL to 10_trgm_before.sql; capture EXPLAIN ANALYZE BUFFERS.
-- GIN has maintenance/storage costs; the planner may still choose a seq scan.
EXPLAIN (ANALYZE, BUFFERS)
SELECT book_id,title FROM library.books
WHERE title ILIKE '%data%'
ORDER BY book_id;
