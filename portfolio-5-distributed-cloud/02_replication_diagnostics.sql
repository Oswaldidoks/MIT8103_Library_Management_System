-- Read-only diagnostics; a local standalone server may have no replicas.
SELECT pg_is_in_recovery() AS is_standby;
SELECT application_name,state,sync_state FROM pg_stat_replication;
SHOW wal_level;
SHOW max_wal_senders;
