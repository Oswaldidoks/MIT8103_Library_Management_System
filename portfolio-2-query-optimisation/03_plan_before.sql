-- Run AFTER 02_benchmark_seed.sql. Baseline without the test index.
DROP INDEX IF EXISTS library.idx_loans_borrower_date;
ANALYZE library.loans;
EXPLAIN (ANALYZE, BUFFERS)
SELECT loan_id,borrower_id,loaned_at,due_at
FROM library.loans
WHERE borrower_id=4
  AND loaned_at>=CURRENT_TIMESTAMP-interval '365 days'
ORDER BY loaned_at DESC
LIMIT 25;