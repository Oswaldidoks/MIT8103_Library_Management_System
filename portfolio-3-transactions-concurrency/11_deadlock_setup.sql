-- Independent experiment; safe to rerun while NO deadlock session is active.
CREATE SCHEMA IF NOT EXISTS library_experiments;
CREATE TABLE IF NOT EXISTS library_experiments.deadlock_accounts(
  account_id integer PRIMARY KEY,
  balance integer NOT NULL
);
INSERT INTO library_experiments.deadlock_accounts(account_id,balance)
VALUES(1,100),(2,100) ON CONFLICT(account_id) DO UPDATE SET balance=100;
