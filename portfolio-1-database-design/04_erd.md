# Entity–relationship diagram — Crescent City Library

This Mermaid ER diagram is rendered directly by GitHub. It documents the schema in `01_schema.sql` (not an execution screenshot).

```mermaid
erDiagram
    BRANCHES ||--o{ STAFF : employs
    BRANCHES ||--o{ BOOK_COPIES : houses
    CATEGORIES ||--o{ BOOKS : classifies
    BOOKS ||--o{ BOOK_COPIES : has
    BOOKS ||--o{ BOOK_AUTHORS : has
    AUTHORS ||--o{ BOOK_AUTHORS : writes
    BORROWERS ||--o{ LOANS : borrows
    BOOK_COPIES ||--o{ LOANS : loan_history
    STAFF ||--o{ LOANS : checks_out_or_in
    LOANS ||--o| FINES : may_incur
    STAFF ||--o{ FINES : assesses
    FINES ||--o{ FINE_PAYMENTS : receives
    STAFF ||--o{ FINE_PAYMENTS : collects

    BRANCHES {
        bigint branch_id PK
        string branch_code UK
        string branch_name
        string address
    }
    STAFF {
        bigint staff_id PK
        string employee_no UK
        bigint branch_id FK
        string staff_role
        boolean active
    }
    BORROWERS {
        bigint borrower_id PK
        string library_card UK
        string full_name
        string email UK
        boolean active
    }
    CATEGORIES {
        bigint category_id PK
        string category_name UK
    }
    AUTHORS {
        bigint author_id PK
        string author_name UK
    }
    BOOKS {
        bigint book_id PK
        string isbn UK
        bigint category_id FK
        string title
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
        string barcode UK
        string condition_status
    }
    LOANS {
        bigint loan_id PK
        bigint copy_id FK
        bigint borrower_id FK
        bigint checked_out_by FK
        bigint checked_in_by FK
        timestamp loaned_at
        timestamp due_at
        timestamp returned_at
    }
    FINES {
        bigint fine_id PK
        bigint loan_id FK,UK
        decimal assessed_amount
        bigint assessed_by FK
    }
    FINE_PAYMENTS {
        bigint payment_id PK
        bigint fine_id FK
        decimal amount
        bigint collected_by FK
    }
```

**Key modelling decision:** a `BOOK` is a bibliographic title, while a `BOOK_COPY` is an individual physical item. The same title can have many independently loanable barcoded copies. A partial unique index enforces at most one open loan per copy. A loan can have zero or one fine; a fine can be paid in several instalments.

**Diagram limitation:** the notation combines both staff foreign keys in `LOANS` for readability; there are two separate relationships, `checked_out_by` (required) and `checked_in_by` (nullable until returned). Confirm the exact design against the SQL schema.