-- Run on STANDBY ONLY. EXPECT ERROR SQLSTATE 25006 (read_only_sql_transaction).
-- A streaming hot standby cannot accept writes. Failure is evidence only if
-- you capture the actual PostgreSQL message and verify you targeted STANDBY.
INSERT INTO public.replication_probe(probe_id)
VALUES('SHOULD_NOT_WRITE_ON_STANDBY');
