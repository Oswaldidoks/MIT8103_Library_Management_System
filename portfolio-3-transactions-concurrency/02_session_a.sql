SET search_path TO library,public;
-- Run manually in session A; leave the transaction open while session B runs.
BEGIN;
SELECT copy_id FROM book_copies WHERE copy_id=10 FOR UPDATE;
SELECT checkout_book(10,7,2,14);
-- Wait for session B to attempt checkout, then:
COMMIT;
