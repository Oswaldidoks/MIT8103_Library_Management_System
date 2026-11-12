-- Reset table with 06_isolation_setup.sql first.
-- Session A. Start this, then run 08_isolation_b.sql during the sleep.
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT tally AS first_read FROM library_experiments.isolation_counter WHERE id=1;
SELECT pg_sleep(12);
SELECT tally AS second_read FROM library_experiments.isolation_counter WHERE id=1;
COMMIT;
-- Expected if B committed during sleep: BOTH reads return 10.
-- A new transaction after COMMIT will see B's updated 11.
