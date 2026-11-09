SET search_path TO library,public;
-- Inspect schema and test the one-open-loan-per-copy invariant.
SELECT table_name FROM information_schema.tables WHERE table_schema='library' ORDER BY table_name;
SELECT * FROM v_catalogue ORDER BY title;
SELECT * FROM v_loan_status ORDER BY loan_id;
SELECT * FROM v_fine_balances ORDER BY fine_id;
SELECT indexname,indexdef FROM pg_indexes WHERE schemaname='library' AND tablename='loans';
