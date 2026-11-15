-- Session B: same write-skew decision but alters the other row.
-- Expected NOT GUARANTEED: SQLSTATE 40001 on one overlapping transaction.
-- When caught by an application, retry BEGIN + read + business check + UPDATE
-- + COMMIT as one complete transaction. Do NOT blindly re-run just UPDATE.
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) AS on_duty_before FROM library_experiments.on_call WHERE on_duty;
SELECT pg_sleep(7);
UPDATE library_experiments.on_call SET on_duty=false
WHERE staff_no=2 AND (SELECT COUNT(*) FROM library_experiments.on_call WHERE on_duty)>1;
COMMIT;
