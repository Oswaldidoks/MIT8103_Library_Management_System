# Streaming replication evidence — TODO (not executed by me)

The supplied earlier log shows no replicas connected. After running the new `portfolio-5-distributed-cloud/docker/` lab, capture actual `docker compose ps`, primary `pg_stat_replication`, standby `pg_is_in_recovery`, WAL replay LSN, evidence that a specific primary probe reached the standby, and a rejected standby write. Record exact commands, errors, any lag and whether you deployed/prompted failover. Do **not** claim cloud deployment; this is a local two-container lab unless you actually deploy to a cloud provider.
