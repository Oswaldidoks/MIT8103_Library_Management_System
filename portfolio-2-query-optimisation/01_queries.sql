SET search_path TO library,public;
-- Catalogue search
SELECT * FROM v_catalogue WHERE title ILIKE '%data%' ORDER BY title;
-- Open and overdue loans
SELECT l.loan_id,b.full_name,bc.barcode,l.due_at
FROM loans l JOIN borrowers b ON b.borrower_id=l.borrower_id
JOIN book_copies bc ON bc.copy_id=l.copy_id
WHERE l.returned_at IS NULL AND l.due_at<clock_timestamp() ORDER BY l.due_at;
-- Fine balances
SELECT * FROM v_fine_balances WHERE outstanding_amount>0 ORDER BY fine_id;
-- Most borrowed titles
SELECT bk.title,count(*) AS loan_count FROM loans l JOIN book_copies bc ON bc.copy_id=l.copy_id JOIN books bk ON bk.book_id=bc.book_id GROUP BY bk.book_id,bk.title ORDER BY loan_count DESC;
