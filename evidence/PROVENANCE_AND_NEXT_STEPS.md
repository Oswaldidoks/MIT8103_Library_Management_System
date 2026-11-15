# Imported PostgreSQL 16 evidence: provenance and next steps

The 27 `.txt` outputs under `evidence/portfolio-1` through `portfolio-5` are copied **byte-for-byte** from the uploaded `Idoko_Oswald_StudentID_evidence.zip`. They are labelled as **an automated Claude (Anthropic) sandbox run on 15 November 2026**. This was **not a student-run experiment** and **not executed by me** during this integration. The exact source and execution caveats are in [README.md](README.md); see [CAPTURE_GUIDE.md](CAPTURE_GUIDE.md) for student-run captures.

- Preserve headers, errors and timestamps; do not rename the original logs to imply they were run on a different system.
- Original SHA-256 checksums are recorded in `IMPORTED_FILE_SHA256.txt` for traceability.
- This archive contains no PNG screenshots. Capture your own actual terminals and application state where required.
- P1: original schema/seed/integrity/smoke outputs; no new negative-test logs.
- P2: original 100,000-row benchmark and three before/after plans; no trigram experiment outputs.
- P3: original COMMIT/ROLLBACK, two-session checkout, return/fine and two isolation demonstrations; no deadlock/SERIALIZABLE/direct-INSERT logs.
- P4: only existing PostgreSQL JSONB output; MongoDB and larger JSONB-GIN benchmark have **not been executed by me**.
- P5: single-node partitioning and empty replication view; the Docker streaming-replication lab has **not been executed by me**.
- Document in your declaration that a previous AI assistant carried out the original automated capture, and distinguish the results you later reproduce yourself.

See the [evidence matrix](../submission/05_evidence_matrix.md) for a portfolio-by-portfolio mapping and test status. Never convert the new scripts' expected outcomes into observed results without running them.
