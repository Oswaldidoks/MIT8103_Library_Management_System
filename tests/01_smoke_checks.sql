SET search_path TO library,public;
SELECT COUNT(*) AS branch_count FROM branches;
SELECT COUNT(*) AS book_count FROM books;
SELECT COUNT(*) AS copy_count FROM book_copies;
SELECT COUNT(*) AS borrower_count FROM borrowers;
SELECT COUNT(*) AS loan_count FROM loans;
SELECT COUNT(*) AS open_loans FROM loans WHERE returned_at IS NULL;
SELECT COUNT(*) AS duplicate_active_copies FROM (SELECT copy_id FROM loans WHERE returned_at IS NULL GROUP BY copy_id HAVING COUNT(*)>1) x;
