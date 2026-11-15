-- Six additional operational queries for Crescent City Library.
-- Run after 01_schema.sql and 02_seed.sql. All are read-only.
SET search_path TO library,public;

-- Q1. Outstanding fines by borrower: join fines via loan and subtract payments.
SELECT b.borrower_id,b.full_name,
       SUM(v.outstanding_amount) AS total_outstanding_ngn
FROM v_fine_balances v
JOIN loans l ON l.loan_id=v.loan_id
JOIN borrowers b ON b.borrower_id=l.borrower_id
WHERE v.outstanding_amount>0
GROUP BY b.borrower_id,b.full_name
ORDER BY total_outstanding_ngn DESC,b.borrower_id;

-- Q2. Most borrowed titles at each branch: CTE aggregation and window rank.
WITH title_counts AS (
  SELECT cp.branch_id,br.branch_name,bk.book_id,bk.title,COUNT(*) AS loan_count
  FROM loans l
  JOIN book_copies cp ON cp.copy_id=l.copy_id
  JOIN branches br ON br.branch_id=cp.branch_id
  JOIN books bk ON bk.book_id=cp.book_id
  GROUP BY cp.branch_id,br.branch_name,bk.book_id,bk.title
), ranked AS (
  SELECT *,DENSE_RANK() OVER(PARTITION BY branch_id ORDER BY loan_count DESC) AS borrow_rank
  FROM title_counts
)
SELECT branch_name,title,loan_count,borrow_rank
FROM ranked WHERE borrow_rank<=3 ORDER BY branch_name,borrow_rank,title;

-- Q3. Average completed-loan duration in days, per book category.
SELECT c.category_name,
       ROUND(AVG(EXTRACT(EPOCH FROM(l.returned_at-l.loaned_at))/86400)::numeric,2) AS avg_days,
       COUNT(*) AS completed_loans
FROM loans l
JOIN book_copies cp ON cp.copy_id=l.copy_id
JOIN books b ON b.book_id=cp.book_id
JOIN categories c ON c.category_id=b.category_id
WHERE l.returned_at IS NOT NULL
GROUP BY c.category_name ORDER BY avg_days DESC;

-- Q4. Count and age of overdue open loans by branch.
SELECT br.branch_name,COUNT(*) AS overdue_open_loans,
       MAX(CURRENT_DATE-l.due_at::date) AS oldest_days_overdue
FROM loans l
JOIN book_copies cp ON cp.copy_id=l.copy_id
JOIN branches br ON br.branch_id=cp.branch_id
WHERE l.returned_at IS NULL AND l.due_at<CURRENT_TIMESTAMP
GROUP BY br.branch_id,br.branch_name ORDER BY overdue_open_loans DESC;

-- Q5. Copies never borrowed: NOT EXISTS anti-join avoids duplicate counts.
SELECT br.branch_name,cp.barcode,bk.title
FROM book_copies cp JOIN books bk ON bk.book_id=cp.book_id
JOIN branches br ON br.branch_id=cp.branch_id
WHERE NOT EXISTS (SELECT 1 FROM loans l WHERE l.copy_id=cp.copy_id)
ORDER BY br.branch_name,bk.title,cp.barcode;

-- Q6. Borrowers with multiple open overdue loans (HAVING).
SELECT b.library_card,b.full_name,COUNT(*) AS overdue_count
FROM borrowers b JOIN loans l ON l.borrower_id=b.borrower_id
WHERE l.returned_at IS NULL AND l.due_at<CURRENT_TIMESTAMP
GROUP BY b.borrower_id,b.library_card,b.full_name
HAVING COUNT(*)>=2 ORDER BY overdue_count DESC,b.library_card;
