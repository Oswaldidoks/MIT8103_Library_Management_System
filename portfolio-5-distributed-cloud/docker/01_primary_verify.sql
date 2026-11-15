-- Run on PRIMARY to inspect only actual live replication sessions and WAL LSN.
-- Zero pg_stat_replication rows means no active standby connection observed.
SELECT current_database(),pg_is_in_recovery() AS primary_is_in_recovery;
SELECT pg_current_wal_lsn() AS current_primary_wal_lsn;
SELECT application_name,client_addr,state,sync_state,
       sent_lsn,write_lsn,flush_lsn,replay_lsn,
       write_lag,flush_lag,replay_lag
FROM pg_stat_replication;
