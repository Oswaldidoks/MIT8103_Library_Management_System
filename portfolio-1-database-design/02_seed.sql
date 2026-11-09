-- Synthetic demonstration data; run after 01_schema.sql.
BEGIN;
SET search_path TO library,public;
INSERT INTO branches(branch_id,branch_code,branch_name,address) VALUES (1,'CENTRAL','Central Library','12 River Road'),(2,'EAST','East Branch','41 Garden Street') ON CONFLICT DO NOTHING;
INSERT INTO staff(staff_id,employee_no,full_name,branch_id,staff_role) VALUES (1,'EMP001','Amina Yusuf',1,'MANAGER'),(2,'EMP002','Emeka Nwosu',1,'LIBRARIAN'),(3,'EMP003','Tola Ade',2,'ASSISTANT') ON CONFLICT DO NOTHING;
INSERT INTO borrowers(borrower_id,library_card,full_name,email,joined_at) VALUES (1,'CARD001','Ife Bello','ife@example.test',CURRENT_DATE-200),(2,'CARD002','Ada Okeke','ada@example.test',CURRENT_DATE-190),(3,'CARD003','Chika Musa','chika@example.test',CURRENT_DATE-170),(4,'CARD004','Segun Lawal','segun@example.test',CURRENT_DATE-160),(5,'CARD005','Kemi Daniel','kemi@example.test',CURRENT_DATE-140),(6,'CARD006','Mary James','mary@example.test',CURRENT_DATE-120),(7,'CARD007','Zainab Idris','zainab@example.test',CURRENT_DATE-100),(8,'CARD008','John Peter','john@example.test',CURRENT_DATE-90) ON CONFLICT DO NOTHING;
INSERT INTO categories(category_id,category_name) VALUES (1,'Computing'),(2,'Fiction'),(3,'Business'),(4,'History') ON CONFLICT DO NOTHING;
INSERT INTO authors(author_id,author_name) VALUES (1,'Nora Wells'),(2,'David Mensah'),(3,'Mina Adeyemi'),(4,'Jonah Clarke'),(5,'Bisi Cole'),(6,'Tari Okafor') ON CONFLICT DO NOTHING;
INSERT INTO books(book_id,isbn,title,category_id,publication_year,publisher,metadata) VALUES
(1,'9781000000001','Practical PostgreSQL',1,2023,'Harbour Press','{"format":"paperback","language":"en","subjects":["databases","sql"],"pages":320}'),
(2,'9781000000002','Introduction to Data Modelling',1,2021,'Harbour Press','{"format":"hardcover","language":"en","subjects":["design","databases"],"pages":280}'),
(3,'9781000000003','The River at Dawn',2,2022,'Canopy Books','{"format":"paperback","language":"en","subjects":["fiction"],"pages":240}'),
(4,'9781000000004','Business in West Africa',3,2020,'Lagoon Publishing','{"format":"ebook","language":"en","subjects":["business","africa"]}'),
(5,'9781000000005','Cities and Memory',4,2019,'Canopy Books','{"format":"hardcover","language":"en","subjects":["history","cities"]}'),
(6,'9781000000006','Concurrency by Example',1,2024,'Harbour Press','{"format":"paperback","language":"en","subjects":["transactions","sql"]}'),
(7,'9781000000007','Markets at Midnight',2,2024,'Canopy Books','{"format":"paperback","language":"en","subjects":["fiction"]}'),
(8,'9781000000008','Data for Managers',3,2025,'Lagoon Publishing','{"format":"paperback","language":"en","subjects":["analytics","business"]}') ON CONFLICT DO NOTHING;
INSERT INTO book_authors(book_id,author_id) VALUES (1,1),(2,1),(2,2),(3,3),(4,4),(5,5),(6,2),(7,6),(8,4) ON CONFLICT DO NOTHING;
INSERT INTO book_copies(copy_id,book_id,branch_id,barcode,condition_status,acquired_on) VALUES
(1,1,1,'CCL-0001','CIRCULATING',CURRENT_DATE-400),(2,1,2,'CCL-0002','CIRCULATING',CURRENT_DATE-390),(3,2,1,'CCL-0003','CIRCULATING',CURRENT_DATE-380),(4,3,1,'CCL-0004','CIRCULATING',CURRENT_DATE-370),(5,4,1,'CCL-0005','CIRCULATING',CURRENT_DATE-360),(6,5,2,'CCL-0006','REPAIR',CURRENT_DATE-350),(7,6,1,'CCL-0007','CIRCULATING',CURRENT_DATE-340),(8,7,2,'CCL-0008','CIRCULATING',CURRENT_DATE-330),(9,8,1,'CCL-0009','CIRCULATING',CURRENT_DATE-320),(10,3,2,'CCL-0010','CIRCULATING',CURRENT_DATE-310),(11,4,2,'CCL-0011','CIRCULATING',CURRENT_DATE-300),(12,6,2,'CCL-0012','CIRCULATING',CURRENT_DATE-290) ON CONFLICT DO NOTHING;
INSERT INTO loans(loan_id,copy_id,borrower_id,checked_out_by,loaned_at,due_at,returned_at,checked_in_by,notes) VALUES
(1,1,1,1,CURRENT_DATE-43,CURRENT_DATE-29,CURRENT_DATE-26,2,'Seed: returned 3 days late'),
(2,2,2,2,CURRENT_DATE-32,CURRENT_DATE-18,CURRENT_DATE-20,2,'Seed: returned early'),
(3,3,3,1,CURRENT_DATE-22,CURRENT_DATE-8,NULL,NULL,'Seed: active overdue'),
(4,4,4,2,CURRENT_DATE-7,CURRENT_DATE+7,NULL,NULL,'Seed: active current'),
(5,8,5,3,CURRENT_DATE-41,CURRENT_DATE-27,CURRENT_DATE-25,3,'Seed: returned 2 days late'),
(6,9,6,1,CURRENT_DATE-29,CURRENT_DATE-15,CURRENT_DATE-18,2,'Seed: returned early') ON CONFLICT DO NOTHING;
INSERT INTO fines(fine_id,loan_id,assessed_amount,assessed_by) VALUES (1,1,150.00,2),(2,5,100.00,3) ON CONFLICT DO NOTHING;
INSERT INTO fine_payments(payment_id,fine_id,amount,collected_by,receipt_ref) VALUES (1,1,50.00,2,'REC-SEED-001'),(2,2,100.00,3,'REC-SEED-002') ON CONFLICT DO NOTHING;
SELECT setval(pg_get_serial_sequence('library.branches','branch_id'),(SELECT max(branch_id) FROM branches),true);
SELECT setval(pg_get_serial_sequence('library.staff','staff_id'),(SELECT max(staff_id) FROM staff),true);
SELECT setval(pg_get_serial_sequence('library.borrowers','borrower_id'),(SELECT max(borrower_id) FROM borrowers),true);
SELECT setval(pg_get_serial_sequence('library.categories','category_id'),(SELECT max(category_id) FROM categories),true);
SELECT setval(pg_get_serial_sequence('library.authors','author_id'),(SELECT max(author_id) FROM authors),true);
SELECT setval(pg_get_serial_sequence('library.books','book_id'),(SELECT max(book_id) FROM books),true);
SELECT setval(pg_get_serial_sequence('library.book_copies','copy_id'),(SELECT max(copy_id) FROM book_copies),true);
SELECT setval(pg_get_serial_sequence('library.loans','loan_id'),(SELECT max(loan_id) FROM loans),true);
SELECT setval(pg_get_serial_sequence('library.fines','fine_id'),(SELECT max(fine_id) FROM fines),true);
SELECT setval(pg_get_serial_sequence('library.fine_payments','payment_id'),(SELECT max(payment_id) FROM fine_payments),true);
COMMIT;
