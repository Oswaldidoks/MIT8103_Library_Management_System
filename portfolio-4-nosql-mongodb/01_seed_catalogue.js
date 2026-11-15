// Crescent City Library demo documents. Entirely synthetic records.
// Run using mongosh inside docker-compose container; rerunnable via upsert.
const library = db.getSiblingDB(process.env.MONGO_DB || 'library_document_demo');
const rows = [
  ['9781000000001','Practical PostgreSQL','Computing',['Nora Wells'],['databases','sql'],[['CCL-0001','CENTRAL'],['CCL-0002','EAST']]],
  ['9781000000002','Introduction to Data Modelling','Computing',['Nora Wells','David Mensah'],['design','databases'],[['CCL-0003','CENTRAL']]],
  ['9781000000003','The River at Dawn','Fiction',['Mina Adeyemi'],['fiction'],[['CCL-0004','CENTRAL'],['CCL-0010','EAST']]],
  ['9781000000004','Business in West Africa','Business',['Jonah Clarke'],['business','africa'],[['CCL-0005','CENTRAL'],['CCL-0011','EAST']]],
  ['9781000000005','Cities and Memory','History',['Bisi Cole'],['history','cities'],[['CCL-0006','EAST']]],
  ['9781000000006','Concurrency by Example','Computing',['David Mensah'],['transactions','sql'],[['CCL-0007','CENTRAL'],['CCL-0012','EAST']]],
  ['9781000000007','Markets at Midnight','Fiction',['Tari Okafor'],['fiction'],[['CCL-0008','EAST']]],
  ['9781000000008','Data for Managers','Business',['Jonah Clarke'],['analytics','business'],[['CCL-0009','CENTRAL']]]
];
for (const [isbn,title,category,authors,subjects,copies] of rows) {
  // The document embeds authors and copies for catalogue reads.
  // Availability is an intentionally illustrative local snapshot, NOT synced to PostgreSQL.
  const doc={isbn,title,category,authors,subjects,
    copies:copies.map(([barcode,branch])=>({barcode,branch,available:true})),
    loanEvents:[],source:'SYNTHETIC_CRESCENT_CITY_LIBRARY'};
  library.catalogue.updateOne({isbn},{$setOnInsert:doc},{upsert:true});
}
print('ACTUAL catalogue document count:',library.catalogue.countDocuments({source:'SYNTHETIC_CRESCENT_CITY_LIBRARY'}));
printjson(library.catalogue.findOne({isbn:'9781000000001'},{_id:0}));
