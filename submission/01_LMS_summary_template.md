# MIT 8103 Advanced Database Systems — LMS portfolio summary TEMPLATE

**Submission:** final document must be **2–3 pages** (not this full working template); target roughly **850–1,050 words** depending on figures and formatting. Adapt word budgets to space. This template is **not** the student's completed report. **Every result blank must be replaced by genuine evidence.**

**Student name:** **FILL SURNAME AND FIRST NAME IN YOUR LOCAL LMS COPY**  
**Student ID:** **FILL IN YOUR LOCAL LMS COPY**  
**Matric number:** **FILL IN YOUR LOCAL LMS COPY (BODY TEXT ONLY)**  
**Folder:** `Surname_Firstname_StudentID/`  
**File:** `Surname_Firstname_PortfolioSummary.docx` or `.pdf` under that folder. The student ID is **not** repeated in the filename.  
**Repository:** `https://github.com/Oswaldidoks/MIT8103_Library_Management_System` (set private; add assessor as collaborator; follow brief)  
**Database platform(s):** PostgreSQL **FILL ACTUAL VERSION**, MongoDB **FILL ACTUAL VERSION** if executed.

## 1. Selected organisation and scenario (~120–150 words)

Provide the **five required elements**:

1. **Organisation/scenario:** Crescent City Library (clearly state that it is simulated).
2. **Nature of the system:** library catalogue and circulation/borrowing database.
3. **Users:** library borrowers, librarians, staff and management.
4. **Major data:** branches, book titles, physical copies, authors, categories, borrowers, staff, loans, fines and payments.
5. **Key operations:** search catalogue, checkout, return, overdue identification, fine assessment/payment and management reporting.

Write in your own words: **FILL MY DESCRIPTION AND LIMITATIONS**.

## 2. Portfolio 1: database modelling (~140–170 words)

Discuss ERD, physical copies versus titles, primary/foreign keys, 1NF–3NF and constraints. Explain one trade-off that you made yourself. **FILL MY OWN EVIDENCE:** ERD screenshot, SQL schema/test output and failed negative tests.

## 3. Portfolio 2: query processing and optimisation (~130–160 words)

**Documented in imported automated Claude PostgreSQL 16.15 logs (not personally run by the student):** a synthetic 100,000-loan borrower/date experiment changed from a sequential scan to an index scan after adding the borrower/date index. Three-run median execution time was **8.010 ms before** and **0.059 ms after**, on that dataset. Reference [original plans and analysis](../evidence/portfolio-2/07_imported_benchmark_summary.md). A separately prepared trigram title-search experiment has **no supplied execution evidence**. **STUDENT TO COMPLETE:** interpret planner, buffers, index storage and limitations in their own words and add any personal rerun evidence.

## 4. Portfolio 3: transactions/concurrency (~130–160 words)

**Imported automated PostgreSQL 16.15 logs, not student-run:** COMMIT retained a checkout and ROLLBACK undid another; in the two-session checkout test, session B received `Copy 10 is already on loan` after session A committed. Returning seeded loan 3 produced a **NGN 400** overdue fine. The READ COMMITTED demonstration read **10 then 11**; REPEATABLE READ read **10 then 10**. See [transaction evidence files](../evidence/portfolio-3/). Additional deadlock and SERIALIZABLE experiments are scripts only, **not evidenced as executed**. **STUDENT TO COMPLETE:** explain the locking and isolation effects in personal words, add screenshots from any experiments personally repeated.

## 5. Portfolio 4: NoSQL and advanced models (~120–150 words)

**Documented from student-provided Windows screenshots (15 November 2026):** MongoDB 7.0.16 was started with Docker Desktop and the fictional catalogue seed reported **8 documents**. The subject filter used a **COLLSCAN examining 8 documents** before an experimental index, and an **IXSCAN using `subjects_1_lab`, examining 2 documents and 2 keys**, afterward. These are screenshot observations, not independently executed by this assistant. The small demonstration does not establish a general speed improvement. Explain how MongoDB's embedded authors/copies differ from PostgreSQL's normalised relational source of truth and why checkout consistency requires care. **STUDENT TO SUPPLY:** any additional `02_queries.js`/`03_indexes.js` output actually run and personal analysis; do not claim an availability update was observed unless evidence exists.

## 6. Portfolio 5: distributed/cloud (~120–150 words)

**Imported automated PostgreSQL 16.15 evidence, not student-run:** two events appeared in local hash partitions; the diagnostic server had `pg_is_in_recovery() = false` and **zero** rows in `pg_stat_replication` (no connected standby). This supports a single-node partitioning demonstration and a standalone-primary observation, **not** actual streaming replication. Discuss the proposed PostgreSQL primary/standby Docker lab, replica lag, stale availability after checkout, failover and why partitioning is not multi-node sharding. **STUDENT TO COMPLETE:** only describe successful replica LSN/probe tests or standby write failures when personally observed and recorded.

## 7. Individual technical reflection (~100–130 words)

**WRITE MY OWN REFLECTION.** Use `03_reflection_prompts.md` for questions, not copied answers. Identify a genuine issue encountered, independent decisions, any failed attempts and lessons learned.

## 8. Sources and responsible AI use (~60–100 words)

**References:** [PostgreSQL documentation](https://www.postgresql.org/docs/16/), [MongoDB manual](https://www.mongodb.com/docs/manual/), and **FILL OTHER SOURCES ACTUALLY CONSULTED**. Use the university's preferred referencing style.

**AI use:** Complete `02_ai_use_declaration_template.md` accurately for every tool used, how you checked it, and any corrections. Never claim results or personal testing you did not perform.

### Evidence checklist before export

- [ ] P1 ERD, schema and constraint test output.
- [ ] P2 two true EXPLAIN comparisons with data sizes and honest interpretation.
- [ ] P3 both concurrency session outputs, isolation observations and errors where seen.
- [ ] P4 separate MongoDB run, documents, indexes and actual explain output (JSONB comparison optional).
- [ ] P5 partition results and (if deployed) actual primary/standby evidence, otherwise a clearly labelled design with limitations.
- [ ] Authored reflection, references, all AI tools declared, 2–3 pages, official folder and file naming (`Surname_Firstname_StudentID/` and `Surname_Firstname_DocumentType.ext`), and repo access.
