# Portfolio 1 — Case study and normalisation

## Organisation and operations
Crescent City Library is a simulated two-branch lending service. Librarians check out/return copies, staff register borrowers and fines, borrowers search catalogues, and managers review overdue loans. It stores branches, staff, books, authors, categories, physical copies, borrowers, loans, fines and individual payments.

## Relational modelling and dependencies
- `books(book_id, isbn, title, category_id, ...)`: `book_id → isbn,title,category_id,...`. Book titles are **not** duplicated in `book_copies` or `loans`.
- `book_copies(copy_id, book_id, branch_id, barcode, ...)`: `copy_id → book_id,branch_id,barcode,...`. Physical copy and book title are different entities.
- `borrowers(borrower_id, library_card, full_name, email, ...)`: borrower identity is stored once, not repeated on every loan.
- `loans(loan_id, copy_id, borrower_id, checked_out_by, ...)`: loan references the copy, borrower, staff and transaction times.
- `book_authors(book_id, author_id)`: composite primary key represents many-to-many authorship without repeating groups.
- `fines(fine_id, loan_id, assessed_amount, ...)` and `fine_payments(payment_id, fine_id, amount, ...)`: support partial payments and an auditable history.

## First normal form (1NF)
One physical copy per `book_copies` row, one borrower per `borrowers` row, one transaction per `loans` row. Authors are in `authors` and `book_authors`, not a comma-separated field in `books`. The optional `books.metadata` JSONB is intentionally semi-structured for Portfolio 4, not the authoritative source of core relational identities.

## Second normal form (2NF)
The only composite primary key is `book_authors(book_id,author_id)`, with no descriptive attributes depending solely on one part. All other base tables have single-column primary keys. This avoids partial-key dependencies.

## Third normal form (3NF)
Borrower name/email depend on `borrower_id`, not `loan_id`; book title/ISBN depend on `book_id`, not `copy_id`; author names depend on `author_id`, not a particular book-author link. Separating loans, fines and payments avoids transitive descriptive data and preserves separate business events.

## Constraints and transaction rules
Primary/foreign keys preserve references; unique keys protect barcodes, ISBNs and library cards. `loans_due_after_start` protects due dates. `ux_loans_one_open_per_copy` prohibits two unreturned loans on the same physical copy. `checkout_book` uses `SELECT ... FOR UPDATE` to serialize concurrent attempts; `pay_fine` locks the fine row before calculating its payment balance.

## Limitations to discuss in your own reflection
The demo fine policy is NGN 50 per calendar day with no grace period, holiday exemptions or maximum. Checkout has no reservations or borrowing limits. A direct database user with table-write permissions could bypass some function checks; production roles should restrict table DML. These are conscious scope constraints, not implemented features.
