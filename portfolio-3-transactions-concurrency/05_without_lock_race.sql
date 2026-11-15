-- Setup for an independent duplicate-checkout race WITHOUT checkout_book().
-- Run this once first. It adds one distinct available synthetic copy only.
-- Run 05a_direct_session_a.sql and 05b_direct_session_b.sql in separate psql
-- terminals. The unique partial index (not the PL/pgSQL function) is tested.
INSERT INTO library.book_copies(book_id,branch_id,barcode,condition_status)
VALUES(1,1,'RACE-COPY-001','CIRCULATING')
ON CONFLICT (barcode) DO NOTHING;
SELECT copy_id,barcode FROM library.book_copies WHERE barcode='RACE-COPY-001';
