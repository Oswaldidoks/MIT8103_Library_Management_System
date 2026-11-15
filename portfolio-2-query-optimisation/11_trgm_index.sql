-- pg_trgm adds trigram operators and the gin_trgm_ops operator class.
-- Needs CREATE privilege in the database; use training DB only.
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_books_title_trgm
ON library.books USING GIN (title gin_trgm_ops);
ANALYZE library.books;
SELECT pg_size_pretty(pg_relation_size('library.idx_books_title_trgm'::regclass)) AS trigram_index_size;
