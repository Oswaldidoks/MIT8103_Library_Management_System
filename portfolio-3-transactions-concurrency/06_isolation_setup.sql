-- Isolated training table; does not alter any real loan.
CREATE SCHEMA IF NOT EXISTS library_experiments;
DROP TABLE IF EXISTS library_experiments.isolation_counter;
CREATE TABLE library_experiments.isolation_counter(id integer PRIMARY KEY,tally integer NOT NULL);
INSERT INTO library_experiments.isolation_counter(id,tally) VALUES(1,10);