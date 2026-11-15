-- Intentional NEGATIVE TESTS. Requires seeded 01_schema.sql + 02_seed.sql.
-- Each nested block is a subtransaction; a failed INSERT is automatically rolled back.
-- An unexpected success raises a TEST FAILED exception and aborts the DO block.
-- Capture the actual NOTICE lines and SQLSTATE in evidence/portfolio-1/.
-- Never claim pass until you run this on PostgreSQL yourself.
SET search_path TO library, public;
DO $constraint_tests$
BEGIN
  -- Test 1: existing seeded ISBN must violate books_isbn_key (SQLSTATE 23505).
  BEGIN
    INSERT INTO books(isbn,title,category_id)
    SELECT isbn,'INTENTIONAL_DUPLICATE_ISBN',category_id FROM books WHERE book_id=1;
    RAISE EXCEPTION 'TEST FAILED: duplicate ISBN was accepted';
  EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'EXPECTED duplicate ISBN rejected (SQLSTATE %)',SQLSTATE;
  END;

  -- Test 2: due_at before loaned_at must violate loans_due_after_start (23514).
  BEGIN
    INSERT INTO loans(copy_id,borrower_id,checked_out_by,loaned_at,due_at)
    VALUES(11,1,1,clock_timestamp(),clock_timestamp()-interval '1 day');
    RAISE EXCEPTION 'TEST FAILED: reversed due date was accepted';
  EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'EXPECTED reversed due date rejected (SQLSTATE %)',SQLSTATE;
  END;

  -- Test 3: seeded copy 3 already has an unreturned loan; second must violate
  -- ux_loans_one_open_per_copy (23505), even without checkout_book().
  BEGIN
    INSERT INTO loans(copy_id,borrower_id,checked_out_by,loaned_at,due_at)
    VALUES(3,2,2,clock_timestamp(),clock_timestamp()+interval '14 days');
    RAISE EXCEPTION 'TEST FAILED: duplicate open loan was accepted';
  EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'EXPECTED second active loan rejected (SQLSTATE %)',SQLSTATE;
  END;

  -- Test 4: staff_role CHECK only accepts LIBRARIAN/ASSISTANT/MANAGER (23514).
  BEGIN
    INSERT INTO staff(employee_no,full_name,branch_id,staff_role)
    VALUES('NEG-ROLE','Synthetic Role Test',1,'PILOT');
    RAISE EXCEPTION 'TEST FAILED: invalid staff role was accepted';
  EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'EXPECTED invalid staff role rejected (SQLSTATE %)',SQLSTATE;
  END;

  -- Test 5: fine_payments.amount > 0 CHECK; negative amount must fail (23514).
  BEGIN
    INSERT INTO fine_payments(fine_id,amount,collected_by,receipt_ref)
    VALUES(1,-10.00,1,'NEG-PAYMENT-TEST');
    RAISE EXCEPTION 'TEST FAILED: negative payment was accepted';
  EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'EXPECTED negative payment rejected (SQLSTATE %)',SQLSTATE;
  END;

  -- Test 6: returned_at and checked_in_by must both be null or non-null (23514).
  BEGIN
    INSERT INTO loans(copy_id,borrower_id,checked_out_by,loaned_at,due_at,returned_at,checked_in_by)
    VALUES(11,1,1,clock_timestamp()-interval '2 days',clock_timestamp()+interval '12 days',clock_timestamp(),NULL);
    RAISE EXCEPTION 'TEST FAILED: inconsistent return pair was accepted';
  EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'EXPECTED invalid return pair rejected (SQLSTATE %)',SQLSTATE;
  END;
END
$constraint_tests$;
