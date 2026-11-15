# Portfolio 4 — Windows MongoDB screenshots and verified scope

**Source:** User-supplied, unwatermarked Windows PowerShell/Docker screenshots dated **15 November 2026**. These are genuine images provided in the conversation, not model-rendered terminal output. They have **not been executed by me** or independently authenticated beyond their visible content. Do not mix them with the 27 imported Claude/PostgreSQL 16.15 text logs.

## Original screenshots to place alongside this note

The separate evidence archive includes these **unaltered PNGs** with these intended repository paths:

| Image filename | What is visibly supported |
|---|---|
| `01_docker_mongodb_started.png` | Docker pulled `mongo:7.0.16`, created volume/network and started the `portfolio-4-nosql-mongodb-mongodb-1` container; the Docker Desktop window shows it running |
| `02_mongodb_seed_8_documents.png` | `01_seed_catalogue.js` returned `ACTUAL catalogue document count: 8` and printed a fictional book with author/embedded-copy details |
| `03_mongodb_explain_before_and_index_creation.png` | `04_explain.js` prints the before-index `COLLSCAN` with 8 documents examined and 0 keys examined and shows index creation |
| `04_mongodb_explain_after_index.png` | The after-index query plan includes `IXSCAN` using `subjects_1_lab` |
| `05_mongodb_explain_after_summary.png` | After-index execution statistics show 2 documents examined, 2 index keys examined and 8 total catalogue documents |

## Reportable technical comparison (from screenshots, not fabricated)

| Property | Before adding the index | After adding the index |
|---|---|---|
| Plan operation | `COLLSCAN` | `IXSCAN` within `FETCH` |
| Query filter | `subjects: 'databases'` | Same |
| Documents examined | **8** | **2** |
| Index keys examined | **0** | **2** |
| Matching documents returned | **2** | **2** |
| MongoDB version | `7.0.16` | `7.0.16` |

The dataset contains only eight documents. Index usage and fewer examined documents do **not** establish a statistically meaningful improvement in response time. A full `executionStats` text capture with run context is useful alongside the images.

**Not established by these images:** complete successful output from `02_queries.js`, separate successful `03_indexes.js` output, MongoDB–PostgreSQL synchronisation, any streaming replication, or a student-performed PostgreSQL execution.

### Image integrity and privacy

Do not recreate terminal screenshots or add fabricated results. Before publishing images, review every screenshot for passwords/tokens/private information. These particular screenshots display Windows paths and commands with environment-variable names; the actual secrets should not be included.

**Upload status, checked 15 November 2026:** The first three original PNGs (Docker startup, eight-document seed, and before-index explain) were committed to this folder. Their Git blob hashes match the original images. The other two original PNGs (after-index plan and execution summary) are in the supplied `Portfolio4_Windows_Genuine_Screenshots.zip` archive and are **not yet confirmed committed**; verify the folder contents before submission. No synthetic image or watermark has been added.
