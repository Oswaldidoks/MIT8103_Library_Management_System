SET search_path TO library,public;
-- JSONB provides document-style modelling inside PostgreSQL.
SELECT book_id,title,metadata->>'format' AS format,metadata->'subjects' AS subjects FROM books ORDER BY book_id;
SELECT book_id,title FROM books WHERE metadata @> '{"language":"en"}'::jsonb;
CREATE INDEX IF NOT EXISTS ix_books_metadata_gin ON books USING GIN(metadata);
EXPLAIN (ANALYZE,BUFFERS) SELECT title FROM books WHERE metadata @> '{"subjects":["databases"]}'::jsonb;
