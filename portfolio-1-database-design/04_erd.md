# Crescent City Library — ER diagram

The diagram reflects the **tables and attributes in `01_schema.sql`**. It is a model, **not evidence of execution**. `checked_out_by` and `checked_in_by` are deliberately shown as separate STAFF relationships. Foreign keys are listed by their actual names in LOANS.

```mermaid
erDiagram
    BRANCHES ||--o{ STAFF : employs
    BRANCHES ||--o{ BOOK_COPIES : stocks
    CATEGORIES ||--o{ BOOKS : classifies
    BOOKS ||--o{ BOOK_COPIES : has
    BOOKS ||--o{ BOOK_AUTHORS : has
    AUTHORS ||--o{ BOOK_AUTHORS : written_by
    BORROWERS ||--o{ LOANS : takes
    BOOK_COPIES ||--o{ LOANS : loan_history
    STAFF ||--o{ LOANS : checked_out_by_required
    STAFF o|--o{ LOANS : checked_in_by_optional
    LOANS ||--o| FINES : may_have
    STAFF ||--o{ FINES : assessed_by
    FINES ||--o{ FINE_PAYMENTS : paid_using
    STAFF ||--o{ FINE_PAYMENTS : collected_by

    BRANCHES {
        bigint branch_id PK
        varchar branch_code UK
        varchar branch_name
        varchar address
    }
    STAFF {
        bigint staff_id PK
        varchar employee_no UK
        varchar full_name
        bigint branch_id FK
        varchar staff_role
        boolean active
    }
    BORROWERS {
        bigint borrower_id PK
        varchar library_card UK
        varchar full_name
        varchar email UK
        date joined_at
        boolean active
    }
    CATEGORIES {
        bigint category_id PK
        varchar category_name UK
    }
    AUTHORS {
        bigint author_id PK
        varchar author_name UK
    }
    BOOKS {
        bigint book_id PK
        varchar isbn UK
        varchar title
        bigint category_id FK
        integer publication_year
        varchar publisher
        jsonb metadata
    }
    BOOK_AUTHORS {
        bigint book_id PK,FK
        bigint author_id PK,FK
    }
    BOOK_COPIES {
        bigint copy_id PK
        bigint book_id FK
        bigint branch_id FK
        varchar barcode UK
        varchar condition_status
        date acquired_on
    }
    LOANS {
        bigint loan_id PK
        bigint copy_id FK
        bigint borrower_id FK
        bigint checked_out_by FK
        timestamptz loaned_at
        timestamptz due_at
        timestamptz returned_at
        bigint checked_in_by FK
        text notes
    }
    FINES {
        bigint fine_id PK
        bigint loan_id FK,UK
        numeric assessed_amount
        timestamptz assessed_at
        bigint assessed_by FK
    }
    FINE_PAYMENTS {
        bigint payment_id PK
        bigint fine_id FK
        numeric amount
        timestamptz received_at
        bigint collected_by FK
        varchar receipt_ref UK
    }
```

**Cardinality notes:** a loan has exactly one checkout staff member, but the check-in staff member is `NULL` until the book is returned. One loan can have zero or one fine (`fines.loan_id` is UNIQUE); one fine can have multiple payments. The unique *partial* index on `loans(copy_id)` where `returned_at IS NULL` enforces at most one simultaneous unreturned loan per copy, which ordinary ER cardinality notation does not express.
