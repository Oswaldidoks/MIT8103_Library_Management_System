-- Demonstrate write skew under a minimum-one-librarian-on-duty business rule.
-- Separate from the production library schema; never update real staff for this.
CREATE SCHEMA IF NOT EXISTS library_experiments;
DROP TABLE IF EXISTS library_experiments.on_call;
CREATE TABLE library_experiments.on_call(
  staff_no integer PRIMARY KEY,
  on_duty boolean NOT NULL
);
INSERT INTO library_experiments.on_call(staff_no,on_duty) VALUES(1,true),(2,true);
