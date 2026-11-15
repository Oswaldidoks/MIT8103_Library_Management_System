# MongoDB versus PostgreSQL — Crescent City Library

| Library requirement | PostgreSQL relational model | MongoDB embedded document model |
|---|---|---|
| Catalogue display (book + authors + copies) | Several joins provide consistent canonical data | One document can embed authors/copies for convenient denormalised reads |
| Flexible attributes (subjects, format) | JSONB supports optional book metadata with SQL | Each document can have optional fields and nested structures |
| Availability and checkout | Row locks, foreign keys, unique partial index and functions enforce one open loan per copy | A single-document update can atomically update one embedded copy, but borrower/loan/fine information spanning multiple documents needs transactional design and uniqueness strategy |
| Author/branch name changes | Normalised rows update once | Embedded copies/authors may require updates across many book documents |
| Reporting across all transactions | SQL joins, aggregation, window functions and ACID transactions fit well | Aggregation pipelines support reporting, but modelling and transactional consistency need careful design |
| Indexing | B-tree, partial unique, GIN JSONB, GIN trigram | Multikey subjects index, text index on title, field indexes and aggregation plans |

**Appropriate split for this coursework:** PostgreSQL remains the authoritative loan/return/fine database. MongoDB is a *separate* NoSQL implementation of the denormalised, read-focused catalogue. The two are **not synchronised** here; the embedded `available` flag in MongoDB is intentionally illustrative and must not be used by a real circulation service without a designed update and consistency mechanism.

**Capture:** Real seed output, query output, index list and `explain('executionStats')` before/after. If the collection is only eight documents, a collection scan may correctly remain faster than index access; do not invent improvement.
