# Design decisions — **my reasoning to review and rewrite in my own words**

This is a **discussion scaffold**, not the student's personal reflection. Check every point against `01_schema.sql`, your own observed query plans and your actual case-study assumptions. Replace generic prose with your independent reasoning before submitting.

| Decision | Reason to evaluate | Trade-off / question to resolve |
|---|---|---|
| Separate `books` and `book_copies` | A title can have many barcoded, branch-specific loanable copies | More joins, but copy-level status and auditability |
| Optional `books.metadata` JSONB | Variable attributes such as format, language and subjects | Flexible but weaker typed constraints and additional GIN/index costs; core entities remain relational |
| Unique partial index plus `checkout_book()` validation | Database uniqueness is a final defence while the function reports business errors and acquires a row lock | Two mechanisms to explain; direct table writes can bypass business checks but **not** the unique index |
| NGN 50/day directly in `return_book()` | Easy to demonstrate one simple fee policy | Hard to vary rates by branch, category or effective date; a `fine_policies` settings table would be more configurable |
| No reservation queue | Keeps scope aligned to checkout/return/overdue flow | Cannot hold items or prioritise waiting borrowers |
| No loan-limit rule | Avoids complex account-policy logic in initial coursework | Production design should validate maximum concurrent loans and borrower standing |
| Staff IDs on loan/payment actions | Preserves basic operational accountability | Production would also need database users/roles, authorisation and secure audit logs |

**Prompts for my own rewrite:** Which trade-off mattered most for this library? Which design would I change after seeing real workloads? What did the negative tests reveal? What I actually implemented versus merely proposed?
