# Portfolio 4 — separate MongoDB document-store experiment

This directory **adds a real NoSQL DBMS** to the existing PostgreSQL JSONB comparison. It uses fictitious Crescent City Library books/authors/copies; loan and payment transactions remain authoritative in PostgreSQL.

**Requirements:** Docker Engine and Docker Compose v2; free local TCP port 27018; enough disk. Commands **not executed by me**.

```bash
cd portfolio-4-nosql-mongodb
cp .env.example .env                     # replace the fake password locally; never commit .env
docker compose up -d
# Wait for health status to turn healthy:
docker compose ps
# Use the container's locally configured admin credentials without putting secrets in Git files:
docker compose exec -T mongodb sh -c 'mongosh --quiet -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin "$MONGO_DB" /scripts/01_seed_catalogue.js'
docker compose exec -T mongodb sh -c 'mongosh --quiet -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin "$MONGO_DB" /scripts/02_queries.js'
docker compose exec -T mongodb sh -c 'mongosh --quiet -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin "$MONGO_DB" /scripts/03_indexes.js'
docker compose exec -T mongodb sh -c 'mongosh --quiet -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin "$MONGO_DB" /scripts/04_explain.js'
```

For a true **before/after**, `04_explain.js` drops and recreates **only** its own `subjects_1_lab` index, then prints actual `executionStats` in both states. Capture the output to `evidence/portfolio-4/`. Eight documents are not a realistic large-scale benchmark; a COLLSCAN is not an error. `02_queries.js` mutates one demonstration availability flag; the change is **not synchronised** to PostgreSQL. See `05_suitability.md`.

**Stop (retains volume):** `docker compose down`. **Destroy local MongoDB data:** `docker compose down -v` (destructive). The service binds only on `127.0.0.1` and is **not production secured**; Docker Compose may expose passwords inside local container metadata, so use fake credentials in this lab and never publish `docker inspect` output or `.env`.

## Current Windows screenshot evidence (15 November 2026)

The student supplied real PowerShell/Docker screenshots, separate from the imported Claude/PostgreSQL logs. They show MongoDB 7.0.16, a seed result reporting **eight** fictional catalogue documents, and a before/after `04_explain.js` query-plan comparison: collection scan of **eight** documents before the index, then index scan using `subjects_1_lab` with **two documents and two index keys** examined. These observations do **not** prove a general speedup on an eight-document dataset. See [evidence documentation](../evidence/portfolio-4/README_WINDOWS_SCREENSHOTS.md). The screenshots are supplied by the student and **not executed by me**.

**Not yet documented as successful from these screenshots:** standalone `02_queries.js` and `03_indexes.js` runs, plus the PostgreSQL primary/standby experiment in Portfolio 5. Do not claim those specific scripts were run without additional evidence.
