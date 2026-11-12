-- Repeat the IDENTICAL query after 04_index.sql.
EXPLAIN (ANALYZE, BUFFERS)
SELECT loan_id,borrower_id,loaned_at,due_at
FROM library.loans
WHERE borrower_id=4
  AND loaned_at>=CURRENT_TIMESTAMP-interval '365 days'
ORDER BY loaned_at DESC
LIMIT 25;