SET search_path TO library,public;
EXPLAIN (ANALYZE,BUFFERS) SELECT loan_id,borrower_id,due_at FROM loans WHERE returned_at IS NULL AND due_at<CURRENT_TIMESTAMP ORDER BY due_at;
