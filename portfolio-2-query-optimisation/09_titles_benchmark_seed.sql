-- OPTIONAL: create 50,000 synthetic catalogue titles for the trigram comparison.
-- Synthetic titles are uniquely marked by publisher and ISBN; not real library records.
-- Run in a disposable seeded database AFTER 01_schema.sql + 02_seed.sql.
-- Re-running does not duplicate rows because ISBN is unique.
BEGIN;
INSERT INTO library.books(isbn,title,category_id,publication_year,publisher,metadata)
SELECT '979'||LPAD(g::text,10,'0'),
       CASE WHEN g%97=0 THEN 'BENCH_TITLE_data_'||g::text
            ELSE 'BENCH_TITLE_volume_'||g::text END,
       1,2024,'BENCHMARK_SYNTHETIC',
       jsonb_build_object('synthetic',true,'sequence',g)
FROM generate_series(1,50000) AS g
ON CONFLICT(isbn) DO NOTHING;
COMMIT;
ANALYZE library.books;
SELECT COUNT(*) AS synthetic_title_rows
FROM library.books WHERE publisher='BENCHMARK_SYNTHETIC';
