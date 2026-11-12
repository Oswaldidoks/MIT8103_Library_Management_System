# Portfolio 1 — Design (7 marks)

Run `01_schema.sql`, `02_seed.sql` and `03_integrity_checks.sql` in order. Open [04_erd.md](04_erd.md) for the GitHub-rendered ER diagram and read [05_normalisation.md](05_normalisation.md) for first, second and third normal form. Capture your own execution screenshots in `evidence/portfolio-1/`.

The design distinguishes bibliographic `books` from physical `book_copies`, and uses a partial unique loan index to prevent two open loans for one copy.