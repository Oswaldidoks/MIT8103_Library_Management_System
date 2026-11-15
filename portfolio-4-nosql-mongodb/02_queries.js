// Read and update examples for the MongoDB document catalogue.
// Requires 01_seed_catalogue.js. Record actual output; do not invent results.
const library = db.getSiblingDB(process.env.MONGO_DB || 'library_document_demo');
print('1. Subject search (books tagged databases):');
printjson(library.catalogue.find({subjects:'databases'},{_id:0,isbn:1,title:1,authors:1,subjects:1}).toArray());

print('2. Embedded copy counts per title using aggregation:');
printjson(library.catalogue.aggregate([
  {$project:{_id:0,title:1,copyCount:{$size:'$copies'},availableCount:{$size:{$filter:{input:'$copies',as:'c',cond:'$$c.available'}}}}},
  {$sort:{title:1}}
]).toArray());

print('3. Optional loan event totals; these are zero until real demo events are added:');
printjson(library.catalogue.aggregate([
  {$project:{_id:0,title:1,loanCount:{$size:{$ifNull:['$loanEvents',[]]}}}},
  {$sort:{loanCount:-1,title:1}}
]).toArray());

// Atomic update of ONE embedded copy inside ONE document, for demo only.
// Do NOT treat this as the PostgreSQL checkout truth or as a multi-document transaction.
print('4. Mark CCL-0002 as unavailable if currently available:');
const result=library.catalogue.updateOne(
  {isbn:'9781000000001',copies:{$elemMatch:{barcode:'CCL-0002',available:true}}},
  {$set:{'copies.$.available':false}}
);
printjson({matchedCount:result.matchedCount,modifiedCount:result.modifiedCount});
printjson(library.catalogue.findOne({isbn:'9781000000001'},{_id:0,title:1,copies:1}));
// Re-seeding uses $setOnInsert; to reset this demo field use the explicit update below
// after capturing your evidence (not run automatically):
// library.catalogue.updateOne({isbn:'9781000000001','copies.barcode':'CCL-0002'},{$set:{'copies.$.available':true}});
