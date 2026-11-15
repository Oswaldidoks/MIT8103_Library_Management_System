# Crescent City Library — normalisation to 3NF

## Worked example: from a flat sheet to relational tables

Imagine a single **unnormalised library transaction spreadsheet** with columns: loan number, borrower library card, borrower name, borrower email, book ISBN/title, **a comma-separated list of author names**, copy barcode, branch code/name/address, checkout staff, due/return dates, fine amount and several payment receipts. This is an **illustrative source sheet**, not actual stored data.

**Repeated data and anomalies:** every new checkout repeats a borrower's email, book title and branch address. An **update anomaly** occurs if branch address changes on only some rows; an **insert anomaly** prevents recording a new book before someone borrows it; a **delete anomaly** risks losing the only stored details of a rare title when its last loan is deleted. Repeating author fields and payment columns also prevent reliable querying.

### 1NF — atomic values and separate repeat groups

Give each row a stable loan identifier, keep atomic borrower/book/copy fields and dates, and split the author list and repeated payments into separately represented rows. A partial intermediate 1NF design could be `LoanFlat(loan_id, borrower_card, borrower_name, isbn, title, barcode, branch_code, due_at, ...)` plus `LoanFlatAuthor(loan_id, author_name)` and `LoanFlatPayment(loan_id, receipt_ref, amount)`. **This is not the final schema**, and it still repeats descriptive data across loans.

### 2NF — remove dependencies on part of a composite key

Separate title and authors into `books`, `authors` and junction `book_authors(book_id, author_id)`, rather than storing book/title attributes in author-association rows. In the final schema `book_authors` has the composite key `(book_id, author_id)` and **no non-key attributes** dependent on one component alone. Other final tables use a single primary key. Keep a separate `book_copies(copy_id, book_id, branch_id, barcode, ...)`: one book title can have several physical copies.

### 3NF — remove transitive descriptive dependencies

Move borrower properties to `borrowers(borrower_id, library_card, full_name, email, ...)`, staff properties to `staff`, category names to `categories`, branch names/addresses to `branches` and book bibliographic properties to `books`. `loans(loan_id, copy_id, borrower_id, checked_out_by, due_at, ...)` then stores IDs and the checkout/return event rather than borrower names or branch addresses. `fines` records assessments linked to loans; `fine_payments` stores each payment, avoiding payment-receipt repeat groups. 

Examples of intended functional dependencies: `book_id → isbn,title,category_id,...`; `copy_id → book_id,branch_id,barcode,...`; `borrower_id → library_card,full_name,email,...`; `loan_id → copy_id,borrower_id,due_at,...`. In the baseline domain a loan refers to **one physical copy**, not a row that stores many titles.

## Tables in the final design

`branches`, `staff`, `borrowers`, `categories`, `authors`, `books`, `book_authors`, `book_copies`, `loans`, `fines` and `fine_payments` are implemented in `01_schema.sql`. Surrogate primary keys, unique natural identifiers, foreign keys and CHECK constraints maintain integrity. The partial unique index on an **open** loan prevents two active loans against a physical copy. The checkout function also locks the copy and checks status (defence in depth).

## Deliberate qualification

`books.metadata` is JSONB for optional catalogue descriptors; it is semi-structured **by design** and is compared with MongoDB in Portfolio 4. It is not used to replace authoritative book, author, borrower or transaction relations. The demonstration fee is NGN 50 per overdue day with no grace/cap policy; loan limits, reservations and staff authorisation by database roles remain outside the implemented scope.
