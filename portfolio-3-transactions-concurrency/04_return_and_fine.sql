SET search_path TO library,public;
-- Demonstrate returning the seeded overdue loan (loan 3).
BEGIN;
SELECT * FROM return_book(3,2);
COMMIT;
SELECT * FROM v_fine_balances ORDER BY fine_id;
