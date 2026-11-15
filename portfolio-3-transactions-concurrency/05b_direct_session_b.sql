-- Session B: start before session A commits. No checkout_book() call.
-- Expected after A COMMIT: duplicate-key error (SQLSTATE 23505) at INSERT.
-- It may wait on A's uncommitted unique index entry first.
-- If B starts late, the duplicate error may arrive immediately.
BEGIN;
SET LOCAL lock_timeout='25s';
INSERT INTO library.loans(copy_id,borrower_id,checked_out_by,loaned_at,due_at,notes)
SELECT copy_id,2,2,clock_timestamp(),clock_timestamp()+interval '14 days','DIRECT_INDEX_RACE'
FROM library.book_copies WHERE barcode='RACE-COPY-001';
COMMIT;
