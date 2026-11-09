SET search_path TO library,public;
-- Run in a second psql session while A holds the copy lock.
BEGIN;
SET LOCAL lock_timeout='8s';
SELECT checkout_book(10,8,2,14);
-- Expected: lock timeout while A holds the lock, or already-on-loan error after A commits.
ROLLBACK;
