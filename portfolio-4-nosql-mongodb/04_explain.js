// Capture actual executionStats before and after our subjects index.
// Recreates only subjects_1_lab; existing title text index is not touched.
// With 8 documents MongoDB may prefer COLLSCAN: explain why in your analysis.
const library = db.getSiblingDB(process.env.MONGO_DB || 'library_document_demo');
const coll=library.catalogue;
const indexName='subjects_1_lab';
if(coll.getIndexes().some(x=>x.name===indexName)) {
  print('Dropping ONLY experiment index:',indexName);
  coll.dropIndex(indexName);
}
print('BEFORE: actual executionStats, not a predicted plan');
printjson(coll.find({subjects:'databases'}).explain('executionStats'));
print('Creating subject index and collecting AFTER executionStats');
coll.createIndex({subjects:1},{name:indexName});
printjson(coll.find({subjects:'databases'}).explain('executionStats'));
print('Document count:',coll.countDocuments({}));
