-- Session A: direct SQL INSERT; deliberately does NOT call checkout_book().
-- Session B must start while A is sleeping, before this COMMIT.
BEGIN;
INSERT INTO library.loans(copy_id,borrower_id,checked_out_by,loaned_at,due_at,notes)
SELECT copy_id,1,1,clock_timestamp(),clock_timestamp()+interval '14 days','DIRECT_INDEX_RACE'
FROM library.book_copies WHERE barcode='RACE-COPY-001';
SELECT pg_sleep(12); -- Holds the uncommitted unique-index entry during the pause.
COMMIT;
