-- Run on STANDBY. Streaming asynchronous physical replica is read-only.
SELECT current_database(),pg_is_in_recovery() AS standby_is_in_recovery;
SELECT pg_last_wal_receive_lsn() AS received_lsn,
       pg_last_wal_replay_lsn() AS replayed_lsn,
       pg_last_xact_replay_timestamp() AS last_replayed_tx;
-- This reflects replay timestamp recency, not a guaranteed precise RPO.
SELECT CASE WHEN pg_last_xact_replay_timestamp() IS NULL THEN NULL
       ELSE clock_timestamp()-pg_last_xact_replay_timestamp()
       END AS time_since_last_replayed_commit;
