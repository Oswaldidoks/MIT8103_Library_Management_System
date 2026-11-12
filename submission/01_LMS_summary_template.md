# MIT 8103 Advanced Database Systems — LMS summary draft structure

**Required length:** 2–3 pages in the final submitted document. Replace every bracketed field, then export to PDF/Word with the required naming convention.

**Student:** [Surname_Firstname_StudentID]  
**Organisation:** Crescent City Library — simulated two-branch library using PostgreSQL 16 (or actual tested version).  
**Repository:** https://github.com/Oswaldidoks/MIT8103_Library_Management_System

## 1. Case study and design (Portfolio 1)
The system stores bibliographic titles separately from physical copies and manages borrowers, staff, loans, returns, overdue fines and partial payments. Explain the ER diagram, normal forms, primary/foreign keys and the partial unique index on active loans. [Insert real diagram reference or screenshot.]

## 2. Query optimisation (Portfolio 2)
Queries cover catalogue search, overdue loans, fine balances and recent-loan lookup. The index experiment compares [record baseline plan] with [record indexed plan] using [row count] loans. Actual execution times: [before] ms / [after] ms. Interpret why the planner chose each plan. [Link real evidence.]

## 3. Transactions and concurrency (Portfolio 3)
Checkout uses a row-level lock and a unique partial index to prevent two simultaneous active loans. Test the effects of COMMIT/ROLLBACK and two-session checkout. Explain isolation behaviour demonstrated under READ COMMITTED and REPEATABLE READ. [Insert your actual observations and evidence paths.]

## 4. Advanced document model (Portfolio 4)
PostgreSQL JSONB stores optional book metadata with document containment queries and GIN indexing. This demonstrates document-style modelling in PostgreSQL; it does not replace an independently installed NoSQL DBMS. [Explain suitability and any lecturer approval.]

## 5. Distributed/cloud design (Portfolio 5)
Document the local hash partition example and explain proposed primary/standby WAL streaming, read replicas, lag, backup and failover. Identify which aspects were actually deployed versus only designed. [Insert real diagnostic outputs.]

## Reflection, references and AI use
**Individual reflection:** [Write in your own words: which decisions you made, what went wrong, fixes, what you learned.]  
**Sources:** PostgreSQL official docs, any other actual sources you used.  
**AI use:** [List every AI tool you actually used, purpose, and how YOU reviewed/tested it.]

This is **a template**, not a completed or verified submission. Apply the institution's file/folder naming rules and keep only evidence from actual work.