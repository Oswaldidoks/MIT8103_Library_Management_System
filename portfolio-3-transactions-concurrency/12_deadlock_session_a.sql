-- Session A: lock row 1 first, then try row 2.
-- Run concurrently with 13_deadlock_session_b.sql in another psql terminal.
-- If overlap is sufficient, PostgreSQL aborts one transaction with 40P01.
BEGIN;
UPDATE library_experiments.deadlock_accounts SET balance=balance+1 WHERE account_id=1;
SELECT pg_sleep(6);
UPDATE library_experiments.deadlock_accounts SET balance=balance+1 WHERE account_id=2;
COMMIT;
