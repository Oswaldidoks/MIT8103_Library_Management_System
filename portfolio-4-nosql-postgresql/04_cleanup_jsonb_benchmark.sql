-- Removes ONLY synthetic JSONB experiment books. Review WHERE predicate.
-- The benchmark inserts no physical book_copies or loans, so no FK rows depend
-- on those 50,000 records. Remove the index only if you intentionally want to.
BEGIN;
SELECT COUNT(*) AS before_rows FROM library.books
WHERE publisher='BENCH_JSONB' AND metadata @> '{"benchmark":"jsonb_50k"}'::jsonb;
DELETE FROM library.books
WHERE publisher='BENCH_JSONB' AND metadata @> '{"benchmark":"jsonb_50k"}'::jsonb;
COMMIT;
ANALYZE library.books;
