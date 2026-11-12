-- Session B, execute while session A is sleeping.
BEGIN;
UPDATE library_experiments.isolation_counter SET tally=tally+1 WHERE id=1;
COMMIT;
SELECT tally FROM library_experiments.isolation_counter WHERE id=1;