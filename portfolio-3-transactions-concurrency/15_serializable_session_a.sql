-- Run in session A at about the same time as 16_serializable_session_b.sql.
-- Both transactions read the count=2 and try to switch off a different staff.
-- With overlapping SERIALIZABLE transactions, one may fail with SQLSTATE 40001.
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) AS on_duty_before FROM library_experiments.on_call WHERE on_duty;
SELECT pg_sleep(7);
UPDATE library_experiments.on_call SET on_duty=false
WHERE staff_no=1 AND (SELECT COUNT(*) FROM library_experiments.on_call WHERE on_duty)>1;
COMMIT;
