// Multikey index on subjects array, plus title text-search index.
// Re-running createIndex with the same name/specification is safe.
const library = db.getSiblingDB(process.env.MONGO_DB || 'library_document_demo');
print('Creating index on subjects array for selective catalogue filters');
print(library.catalogue.createIndex({subjects:1},{name:'subjects_1_lab'}));
print('Creating text index on title for language-aware text search');
print(library.catalogue.createIndex({title:'text'},{name:'title_text_lab'}));
printjson(library.catalogue.getIndexes());
