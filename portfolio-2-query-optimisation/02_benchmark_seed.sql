-- OPTIONAL DATA LOAD for a fresh DEMONSTRATION database only.
-- 1,000 synthetic copies and 100,000 closed loan records (re-run safely).
-- Each copy is reused after about 31 days: 1,000 rows * 45 minutes.
-- Loads older records with dates extending from ~3200 days ago to ~75 days ago.
-- This is artificial performance data, not actual library activity.
BEGIN;
INSERT INTO library.book_copies(book_id,branch_id,barcode,condition_status,acquired_on)
SELECT 1,1,'BENCH-'||lpad(g::text,5,'0'),'CIRCULATING',CURRENT_DATE-3300
FROM generate_series(1,1000) AS g
ON CONFLICT (barcode) DO NOTHING;

WITH bench_copies AS (
 SELECT copy_id,row_number() OVER(ORDER BY barcode)::bigint AS rn
 FROM library.book_copies WHERE barcode LIKE 'BENCH-%'
), demo_seq AS (
 SELECT g,((g-1)%1000+1)::bigint AS rn
 FROM generate_series(1,100000) AS g
)
INSERT INTO library.loans(
 copy_id,borrower_id,checked_out_by,loaned_at,due_at,returned_at,checked_in_by,notes
)
SELECT bc.copy_id,((ds.g-1)%8)+1,1,
       now()-interval '3200 days'+ds.g*interval '45 minutes',
       now()-interval '3200 days'+ds.g*interval '45 minutes'+interval '14 days',
       now()-interval '3200 days'+ds.g*interval '45 minutes'+interval '7 days',
       2,'BENCHMARK_ROWS'
FROM demo_seq ds JOIN bench_copies bc ON bc.rn=ds.rn
WHERE NOT EXISTS(SELECT 1 FROM library.loans WHERE notes='BENCHMARK_ROWS');
COMMIT;
ANALYZE library.loans;
SELECT count(*) AS benchmark_rows FROM library.loans WHERE notes='BENCHMARK_ROWS';