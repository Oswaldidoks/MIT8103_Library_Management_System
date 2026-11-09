SET search_path TO library,public;
-- Committed checkout; copy 5 is initially available.
BEGIN;
SELECT checkout_book(5,7,2,14);
COMMIT;
-- A second checkout, rolled back; copy 7 is initially available.
BEGIN;
SELECT checkout_book(7,8,2,14);
ROLLBACK;
SELECT copy_id,borrower_id,returned_at FROM loans WHERE copy_id IN (5,7) ORDER BY loan_id;
