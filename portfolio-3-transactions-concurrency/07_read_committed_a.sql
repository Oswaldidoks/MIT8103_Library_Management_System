-- Session A. Start this, then run 08_isolation_b.sql in session B DURING the sleep.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT tally AS first_read FROM library_experiments.isolation_counter WHERE id=1;
SELECT pg_sleep(12);
SELECT tally AS second_read FROM library_experiments.isolation_counter WHERE id=1;
COMMIT;
-- Expected if B committed during sleep: second read sees tally=11, unlike first read 10.
