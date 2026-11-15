-- Session B: lock the SAME two rows in reverse order, causing a lock cycle.
-- Expected but timing-dependent: deadlock detected, SQLSTATE 40P01.
-- An application should ROLLBACK and retry the WHOLE transaction with backoff;
-- the safer prevention is to acquire row locks in consistent ID order.
BEGIN;
UPDATE library_experiments.deadlock_accounts SET balance=balance+1 WHERE account_id=2;
SELECT pg_sleep(6);
UPDATE library_experiments.deadlock_accounts SET balance=balance+1 WHERE account_id=1;
COMMIT;
