-- Multicolumn B-tree for equality filter then date ordering.
CREATE INDEX IF NOT EXISTS idx_loans_borrower_date
ON library.loans(borrower_id,loaned_at DESC);
ANALYZE library.loans;