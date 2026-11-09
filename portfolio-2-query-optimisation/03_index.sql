CREATE INDEX IF NOT EXISTS ix_loans_open_due ON library.loans(due_at) WHERE returned_at IS NULL;
ANALYZE library.loans;
