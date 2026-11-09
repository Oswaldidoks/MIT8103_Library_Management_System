-- Isolated educational partitioning exercise, not a migration of library.loans.
CREATE SCHEMA IF NOT EXISTS library_experiments;
CREATE TABLE IF NOT EXISTS library_experiments.loan_events(
 event_id bigint GENERATED ALWAYS AS IDENTITY,
 borrower_id bigint NOT NULL,
 event_time timestamptz NOT NULL DEFAULT now(),
 event_type text NOT NULL
) PARTITION BY HASH(borrower_id);
CREATE TABLE IF NOT EXISTS library_experiments.loan_events_p0 PARTITION OF library_experiments.loan_events FOR VALUES WITH (MODULUS 2,REMAINDER 0);
CREATE TABLE IF NOT EXISTS library_experiments.loan_events_p1 PARTITION OF library_experiments.loan_events FOR VALUES WITH (MODULUS 2,REMAINDER 1);
INSERT INTO library_experiments.loan_events(borrower_id,event_type) VALUES(1,'CHECKOUT'),(2,'RETURN');
SELECT tableoid::regclass AS partition_name,borrower_id,event_type FROM library_experiments.loan_events;
