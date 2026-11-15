-- PARTIAL RESET for tagged Portfolio 3 experimental data only.
-- Does NOT restore seeded loan 3 if already returned, copy 5 from COMMIT demo,
-- or any other base record affected by an unrelated test.
-- For a FULL reset, recreate a disposable database and rerun 01_schema + 02_seed.
-- This script does not touch untagged real borrower/loan rows.
BEGIN;
DELETE FROM library.loans WHERE notes='DIRECT_INDEX_RACE';
DELETE FROM library.book_copies WHERE barcode='RACE-COPY-001';
DO $$ BEGIN
  IF to_regclass('library_experiments.isolation_counter') IS NOT NULL THEN
    UPDATE library_experiments.isolation_counter SET tally=10 WHERE id=1;
  END IF;
  IF to_regclass('library_experiments.deadlock_accounts') IS NOT NULL THEN
    UPDATE library_experiments.deadlock_accounts SET balance=100;
  END IF;
  IF to_regclass('library_experiments.on_call') IS NOT NULL THEN
    UPDATE library_experiments.on_call SET on_duty=true;
  END IF;
END $$;
COMMIT;
