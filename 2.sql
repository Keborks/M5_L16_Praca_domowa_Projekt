Ad.1.

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_owner(
id_ba_own SERIAL PRIMARY KEY,
owner_name VARCHAR(50) NOT NULL,
owner_desc VARCHAR(250),
user_login INTEGER NOT NULL,
active VARCHAR(1) DEFAULT '1' NOT NULL,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp);

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types(
id_ba_typ SERIAL PRIMARY KEY,
ba_type VARCHAR(50) NOT NULL,
ba_desc VARCHAR(250),
active VARCHAR(1) DEFAULT '1' NOT NULL,
is_common_account VARCHAR(1) DEFAULT '0' NOT NULL,
id_ba_own INTEGER,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp,
FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner(id_ba_own)
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_bank_accounts(
id_trans_ba SERIAL PRIMARY KEY,
id_ba_own INTEGER,
id_ba_typ INTEGER,
bank_account_name VARCHAR (50) NOT NULL,
bank_account_desc VARCHAR(250),
active VARCHAR(1) DEFAULT '1' NOT NULL,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp,
FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner (id_ba_own),
FOREIGN KEY (id_ba_typ) REFERENCES expense_tracker.bank_account_types (id_ba_typ)
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category (
id_trans_cat SERIAL PRIMARY KEY,
category_name VARCHAR(50) NOT NULL,
category_description VARCHAR(250),
active VARCHAR(1) DEFAULT '1' NOT NULL,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory (
id_trans_subcat SERIAL PRIMARY KEY,
id_trans_cat INTEGER,
subcategory_name VARCHAR(50) NOT NULL,
subcategory_description VARCHAR(250),
active VARCHAR(1) DEFAULT '1' NOT NULL,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp,
FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_type (
id_trans_type SERIAL PRIMARY KEY,
transaction_type_name VARCHAR(50) NOT NULL,
transaction_type_desc VARCHAR(250),
active VARCHAR(1) DEFAULT '1' NOT NULL,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp);

CREATE TABLE IF NOT EXISTS expense_tracker.users (
id_user SERIAL PRIMARY KEY,
user_login VARCHAR(25) NOT NULL,
user_name VARCHAR(50) NOT NULL,
user_password VARCHAR(100) NOT NULL,
password_salt VARCHAR(100) NOT NULL,
active VARCHAR(1) DEFAULT '1' NOT NULL,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp);

CREATE TABLE IF NOT EXISTS expense_tracker.transactions(
id_transaction SERIAL PRIMARY KEY,
id_trans_ba INTEGER,
id_trans_cat INTEGER,
id_trans_subcat INTEGER,
id_trans_type INTEGER,
id_user INTEGER,
transaction_date DATE DEFAULT current_date,
transaction_value NUMERIC(9,2),
transaction_description TEXT,
insert_date TIMESTAMP DEFAULT current_timestamp,
update_date TIMESTAMP DEFAULT current_timestamp,
FOREIGN KEY (id_trans_ba) REFERENCES expense_tracker.transaction_bank_accounts (id_trans_ba),
FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category (id_trans_cat),
FOREIGN KEY (id_trans_subcat) REFERENCES expense_tracker.transaction_subcategory (id_trans_subcat),
FOREIGN KEY (id_trans_type) REFERENCES expense_tracker.transaction_type (id_trans_type),
FOREIGN KEY (id_user) REFERENCES expense_tracker.users (id_user)
);

AD.2. Polecenia wstawienia rekordów w poszczególnych tabelach.


INSERT INTO expense_tracker.bank_account_owner (id_ba_own, owner_name, owner_desc, user_login, active) 
VALUES (1, 'Marcin', 'Tata', '111', 1);

INSERT INTO expense_tracker.bank_account_types (id_ba_typ, ba_type, ba_desc, 
active, is_common_account, id_ba_own) 
VALUES (001, 010, 'wpływ', 1, 0, 1);

INSERT INTO expense_tracker.transaction_bank_accounts (id_trans_ba, id_ba_own, id_ba_typ, 
bank_account_name, bank_account_desc, active) 
VALUES (123, 1, 001, 'Konto Marcina', 'Konto Millennium', 1);

INSERT INTO expense_tracker.transaction_category (id_trans_cat, category_name, category_description, active) 
VALUES (987, 'wydatek', 'zakupy spożywcze', 1);

INSERT INTO expense_tracker.transaction_subcategory (id_trans_subcat, id_trans_cat, subcategory_name, 
subcategory_description, active) 
VALUES (222, 987, 'pieczywo', 'bułki', 1);

INSERT INTO expense_tracker.transaction_type (id_trans_type, transaction_type_name, 
transaction_type_desc, active) 
VALUES (12345, 'gotówka', 'płatnosć gotówką', 1);

INSERT INTO expense_tracker.users (id_user, user_login, user_name, user_password, 
password_salt, active) 
VALUES (2, 'marcin_s',  'Marcin', '123sq!','#######', 1);

INSERT INTO expense_tracker.transactions (id_transaction, id_trans_ba, id_trans_cat, id_trans_subcat, 
id_trans_type, id_user, transaction_date, transaction_value, transaction_description) 
VALUES (1, 123, 987, 222, 12345, 2, '2022-12-08', 123, 'koszt');

Ad.3. Wykonanie kopii zapasowej bazy danych

pg_dump --host localhost ^
        --port 5432 ^
        --username postgres ^
        --format plain ^
        --file "C:\Users\user\OneDrive\Pulpit\Projekt_kopia_zapasowa\M5_L16.sql" ^
        --clean ^
        postgres

AD.3. Odtworzenie kopii z zapisanego skryptu używając narzędzia psql:

psql -U postgres -p 5432 -h localhost -d postgres -f "C:\Users\user\OneDrive\Pulpit\Projekt_kopia_zapasowa\M5_L16.sql"
