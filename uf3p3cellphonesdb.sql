DROP DATABASE IF EXISTS cellphones;
CREATE DATABASE IF NOT EXISTS cellphones;
USE cellphones;

CREATE TABLE client (
   id_client MEDIUMINT AUTO_INCREMENT,
   dni VARCHAR(9) NOT NULL,
   name VARCHAR (20) NOT NULL,
   surname VARCHAR(20) NOT NULL,
   email VARCHAR(30) NOT NULL,
   phone VARCHAR(15),
   address VARCHAR(50),
   PRIMARY KEY (id_client),
   CONSTRAINT uk_client_dni UNIQUE (dni),
   CONSTRAINT uk_client_email UNIQUE (email),
   CONSTRAINT ck_client_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]')
)ENGINE=INNODB;

CREATE TABLE transporter (
   id_transporter SMALLINT AUTO_INCREMENT,
   dni VARCHAR(9) NOT NULL,
   company VARCHAR(20),
   email VARCHAR(30) NOT NULL,
   phone VARCHAR(15) NOT NULL,
   address VARCHAR(50),
   PRIMARY KEY (id_transporter),
   CONSTRAINT uk_transporter_dni UNIQUE (dni),
   CONSTRAINT ck_client_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]')
)ENGINE=INNODB;

CREATE TABLE purchase (
   id_purchase INT AUTO_INCREMENT,
   client_id MEDIUMINT NOT NULL,
   transporter_id SMALLINT NOT NULL,
   destination_address VARCHAR(50) NULL,
   status ENUM('R', 'E', 'P') NOT NULL DEFAULT 'P',
   sent_date DATE,
   delivery_date DATETIME,
   PRIMARY KEY (id_purchase),
   CONSTRAINT fk_client_purchase FOREIGN KEY (client_id) REFERENCES client(id_client),
   CONSTRAINT fk_client_transporter FOREIGN KEY (transporter_id) REFERENCES transporter(id_transporter)
)ENGINE=INNODB;

CREATE TABLE employee (
   id_employee SMALLINT(3) AUTO_INCREMENT,
   supervisor_id SMALLINT(3),
   dni VARCHAR(9) NOT NULL,
   name VARCHAR(20) NOT NULL,
   surname_1 VARCHAR(20) NOT NULL,
   surname_2 VARCHAR(20),
   email VARCHAR(30),
   phone VARCHAR(15),
   address VARCHAR(50),
   salary DECIMAL(7,2) NOT NULL,
   birth_date DATE NOT NULL,
   contract_date DATE NOT NULL,
   PRIMARY KEY (id_employee),
   CONSTRAINT fk_employee_employee FOREIGN KEY (supervisor_id) REFERENCES employee(id_employee),
   CONSTRAINT uk_employee_dni UNIQUE (dni),
   CONSTRAINT uk_employee_email UNIQUE (email),
   CONSTRAINT ck_employee_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]'),
   CONSTRAINT ck_employee_salary CHECK (salary>0)
)ENGINE=INNODB;

CREATE TABLE technician (
   id_technician SMALLINT(3) NOT NULL,
   speciality VARCHAR(20),
   PRIMARY KEY (id_technician),
   CONSTRAINT fk_employee_technician FOREIGN KEY (id_technician) REFERENCES employee(id_employee)
)ENGINE=INNODB;

CREATE TABLE incidence (
   id_incidence INT AUTO_INCREMENT,
   client_id MEDIUMINT NOT NULL,
   technician_supervisor SMALLINT(3) NOT NULL,
   description VARCHAR(255) NOT NULL,
   notify_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,   
   start_date DATETIME NOT NULL,
   resolution_date DATETIME NULL,
   PRIMARY KEY (id_incidence),
   CONSTRAINT fk_client_incidence FOREIGN KEY (client_id) REFERENCES client(id_client),
   CONSTRAINT fk_technician_incidence FOREIGN KEY (technician_supervisor) REFERENCES technician(id_technician),
   CONSTRAINT ck_incidence_start_date CHECK (start_date>=notify_date),
   CONSTRAINT ck_incidence_resolution_date CHECK (resolution_date>start_date)
)ENGINE=INNODB;

CREATE TABLE incidence_technician (
   id_incidence INT NOT NULL,
   id_technician SMALLINT(3) NOT NULL,
   PRIMARY KEY (id_incidence, id_technician),
   CONSTRAINT fk_incidence_technician_incidences FOREIGN KEY (id_incidence) REFERENCES incidence (id_incidence),
   CONSTRAINT fk_incidence_technician_technician FOREIGN KEY (id_technician) REFERENCES technician (id_technician)
) ENGINE=INNODB;

CREATE TABLE salesman(
    id_salesman SMALLINT(3) NOT NULL,
    PRIMARY KEY (id_salesman),
    CONSTRAINT fk_salesman_employee FOREIGN KEY (id_salesman) REFERENCES employee(id_employee)
)ENGINE=INNODB;

CREATE TABLE country(
    id_country SMALLINT(3) AUTO_INCREMENT,
    code VARCHAR(3) NOT NULL,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_country),
    CONSTRAINT uk_country_code UNIQUE (code),
    CONSTRAINT uk_country_name UNIQUE (name)
)ENGINE=INNODB;

CREATE TABLE supplier(
    id_supplier SMALLINT(3) AUTO_INCREMENT,
    country_id SMALLINT(3),
    name VARCHAR(30),
    email VARCHAR(30),
    salesman_id SMALLINT(3),
    PRIMARY KEY (id_supplier),
    CONSTRAINT fk_salesman_supplier FOREIGN KEY (salesman_id) REFERENCES salesman(id_salesman),
    CONSTRAINT uk_supplier_name UNIQUE (name),
    CONSTRAINT fk_supplier_country FOREIGN KEY (country_id) REFERENCES country(id_country)
)ENGINE=INNODB;

CREATE TABLE brand(
    id_brand SMALLINT(3) AUTO_INCREMENT,
    code VARCHAR(3) NOT NULL,
    name VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_brand),
    CONSTRAINT uk_brand_code UNIQUE (code),
    CONSTRAINT uk_brand_name UNIQUE (name)
)ENGINE=INNODB;

CREATE TABLE phone(
    id_phone SMALLINT AUTO_INCREMENT,
    brand_id SMALLINT (3) NOT NULL,
    model VARCHAR(20) NOT NULL,
    pvp DECIMAL(7,2) NOT NULL,
    stock SMALLINT(4) NOT NULL,
    PRIMARY KEY(id_phone),
    CONSTRAINT fk_phone_brand FOREIGN KEY (brand_id) REFERENCES brand(id_brand),
    CONSTRAINT uk_phone_brand_id_model UNIQUE (brand_id, model),
    CONSTRAINT ck_phone_stock CHECK (stock>=0)
)ENGINE=INNODB;
ALTER TABLE phone AUTO_INCREMENT=100;

CREATE TABLE phone_purchase (
    id_purchase INT NOT NULL,
    id_phone SMALLINT NOT NULL,
    amount TINYINT NOT NULL,
    PRIMARY KEY (id_purchase, id_phone),
    CONSTRAINT fk_phone_purchase_purchase FOREIGN KEY (id_purchase) REFERENCES purchase(id_purchase),
    CONSTRAINT fk_phone_purchase_phone FOREIGN KEY (id_phone) REFERENCES phone(id_phone),
    CONSTRAINT ck_phone_purchase_amount CHECK(amount>0)
)ENGINE=INNODB;

CREATE TABLE phone_supplier (
    id_phone SMALLINT NOT NULL,
    id_supplier SMALLINT(3) NOT NULL,
    price DECIMAL(7,2) NOT NULL,
    PRIMARY KEY(id_phone,id_supplier),
    CONSTRAINT fk_phone_supplier_phone FOREIGN KEY (id_phone) REFERENCES phone(id_phone),
    CONSTRAINT fk_phone_supplier_supplier FOREIGN KEY (id_supplier) REFERENCES supplier(id_supplier),
    CONSTRAINT ck_phone_supplier CHECK (price<50000.00 AND price>= 0.00)
)ENGINE=INNODB;


INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('44226677W','Juan','Membrillo', 'meju@gmail.com' ,'0034667612987','Calle Milet n2 p3, Barcelona, 08215 BCN');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('33226647Q','Maria','Torre', 'mato@gmail.com','0034687366787','Casa Blanca, Puebla de Lillet, 08315 GIR');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('39226675D','Norman','Aren', 'noar@yahoo.de', '123766431255987','Elm Str n2 p3, Pueblo Caoba, 18215 TOL');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('39223621F','Silvia','Aren','siar@yahoo.de', '123777892237287','Elm Str n2 p3, Pueblo Caoba, 18215 TOL');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('59226612G','Carla','Heuer','cahe@hdmail.com' ,'0034699322495','Casa Antigua, Mur, 20500 LLD');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('31226227D','Montse','Ayala','moay@tmail.com' ,'0034992559872','Mon Gaztelugatxe, Bilbao, 44444 BIZ');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('39247277S','Ander','Goikoetxea','ango@gmail.com', '0034592559872','Playa la Concha, San Sebastián, 55555 GIZ');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('39226671C','Fernando','Schneider','fesch@de.olnd.com', '0034231453675','Calle Essen n5 p1, Mallorca, 33333 BAL');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('38833612V','Terry','Shelby', 'tesh@malm.com','0034443554776',' 2 C Unica Arrollo de la Miel, Malaga, 22222 MAL');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('32226699Z','Heidi','Arendt', 'hear@me.com','0045654327877','45 Kirchen Strasse, Köln, 56120 RHI Deutschland');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('45222291M','Hannah','Arendt', 'haar@me.com','004567892231','45 Kirchen Strasse, Köln, 56120 RHI Deutschland');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('52226119W','Franz','Liszt', 'liszt.f@deankht.com','0034444327877','11 Zee Strasse, Tillburg, 5011 Nederland');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('37287779X','Sally','Brown', 'sb.peanuts@snoop.com','0034664329967','Calle Nadha n66 2o 3a, Ceuta, 44444 CEU');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('37225591D','Charlie','Brown', 'cb.peanuts@snoop.com','0034664329968','Calle Nadha n66 2o 3a, Ceuta, 44444 CEU');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('33612342G','Dean','Lonnely', 'highlander@schol.uk','0025654227871','Calle Blanca n10, 1o 2a, Torremolinos, 22211 MAL');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('39945288Z','Ametz','Torres', 'amto@you.com','0034664227667','Mendiberriak Kalea n17, bj 1a, Andoain 55444 GIZ');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('44113156W','Caoímhin','Iraeta', 'cair@eoir.com','0034711327811','Calle Rota n99, Gijón 66443 AST');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('52521322N','Hodei','Aginalde', 'hoag@aldea.com','0032151127117','Rue de la Défénse n7, Alès 77777 France');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('39188290T','Iratxe','Salaberria', 'irsa@txeberria.com','0034552668991','Irigoyen Kalea n12, 3o 2a, Hernani 55423 GIZ');
INSERT INTO client (dni, name, surname, email, phone, address) 
    VALUES ('42226691Z','Eithne','Hernández', 'eihdz@hermn.com','0034714227111','Pl. Fuente Colorada n2, 1o 1a, Cadiz, 22131 CAD');


INSERT INTO transporter 
   VALUES (1, '49226671F', 'GLS', 'art.fern@gls.com', 0034666777888, NULL);
INSERT INTO transporter 
   VALUES (5, '39225512W', NULL, 'eli.hdz@gmail.com', 0034669977588, NULL);
INSERT INTO transporter 
   VALUES (7, '54326671G', 'SEUR', 'ernst.hemingwy@seur.com', 0034874678883, NULL);
INSERT INTO transporter VALUES (2, '44355611C', "SEUR", 'grg.orwell@seur.com', '0034874678883', '16, Xinghai Rd, Suzhou 666667 ANH China');
INSERT INTO transporter VALUES (3, '61126211B', 'GLS', 'srg.rachmaninoff@gls.com', '003546472268', NULL);

INSERT INTO purchase
   VALUES (1, 3, 5, 'Cl Uberdrive, n5 p3, Madrid 99999', 'R', '2022-11-30', '2022-12-05 14:55:00');
INSERT INTO purchase
   VALUES (2, 3, 7, 'Elm Str n2 p3, Pueblo Caoba, 18215 TOL', 'P', NULL, NULL);
INSERT INTO purchase
   VALUES (7, 7, 1, 'Playa la Concha, San Sebastián, 55555 GIZ', 'E', '2021-01-01', NULL);
INSERT INTO purchase
   VALUES (3, 1, 2, NULL, 'R', '2022-11-30', '2022-12-05 14:55:00');
INSERT INTO purchase
   VALUES (4, 2, 3, NULL, 'R', '2022-12-11', '2022-12-19 13:22:15');
INSERT INTO purchase
   VALUES (5, 4, 5, NULL, 'R', '2021-12-11', '2022-12-21 17:31:11');
INSERT INTO purchase
   VALUES (6, 5, 5, NULL, 'R', '2022-12-14', '2022-12-17 14:55:00');
INSERT INTO purchase
   VALUES (8, 10, 2, NULL, 'R', '2022-12-19', '2022-12-23 09:11:52');
INSERT INTO purchase
   VALUES (9, 11, 1, NULL, 'R', '2021-12-21', '2023-01-03 16:11:31');
INSERT INTO purchase
   VALUES (10, 12, 2, NULL, 'R', '2022-12-22', '2023-01-04 11:15:00');
INSERT INTO purchase
   VALUES (11, 3, 7, 'Elm Str n2 p3, Pueblo Caoba, 18215 TOL', 'P', NULL, NULL);
INSERT INTO purchase
   VALUES (12, 19, 1, NULL, 'E', '2023-01-02', NULL);
INSERT INTO purchase
   VALUES (13, 13, 5, NULL, 'R', '2023-01-02', '2023-01-07 11:43:10');
INSERT INTO purchase
   VALUES (14, 16, 7, NULL, 'P', NULL, NULL);
INSERT INTO purchase
   VALUES (15, 17, 3, NULL, 'E', '2023-01-04', NULL);
INSERT INTO purchase
   VALUES (16, 11, 2, NULL, 'R', '2023-01-11', '2023-01-14 13:21:21');
INSERT INTO purchase
   VALUES (17, 18, 7, NULL, 'P', NULL, NULL);
INSERT INTO purchase
   VALUES (18, 14, 3, NULL, 'E', '2023-01-11', NULL);
INSERT INTO purchase
   VALUES (19, 15, 1, NULL, 'R', '2023-01-12', '2023-01-15 10:18:56');
INSERT INTO purchase
   VALUES (20, 3, 7, 'Elm Str n2 p3, Pueblo Caoba, 18215 TOL', 'P', NULL, NULL);
INSERT INTO purchase
   VALUES (21, 7, 1, 'Playa la Concha, San Sebastián, 55555 GIZ', 'E', '2001-01-01', NULL);

INSERT INTO employee (dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE('18292383B','Juan','Moreno','Cano','juanmoca@gmail.com',626622432,'Fuentalbilla',1500,'1970-10-28','2000-01-01');
INSERT INTO employee (dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE('18292283Z','Jose','Josue','Gerard','jojo@gmail.com',626621422,'Olimpo',1700,'1972-02-21','2000-01-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'18292334A','Luigi','Ortiz','Bros','lbro@gmail.com',623663432,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date)
    VALUE(2,'18292181X','Mario','Ortiz','Bros','mbro@gmail.com',622665432,1200,'1971-04-26','2001-09-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date)
    VALUE(1,'18292322Z','Joselito','Lopez','Piña','pluvio@gmail.com',626623323,'Huecomundo',1000,'1972-05-27','2002-08-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,email,phone,address,salary,birth_date,contract_date)
    VALUE(2,'18292387Z','Nivea','Ortega','nile@gmail.com',623662413,'Pedrada',1450,'1974-06-28','2002-07-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,email,phone,address,salary,birth_date,contract_date)
    VALUE(1,'18292386A','Cynthia','Concepcion','ccc@gmail.com',626624424,'Chilena',1000,'1975-07-29','2003-06-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(2,'18292385B','Kevin','Cardozo','Canto','keca@gmail.com',626624942,'Bocasucia',1450,'1976-08-23','2004-05-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'18292384A','Paco','López','Fernandez','palo@gmail.com',626691292,'CuencaAntigua',1250,'1977-09-21','2002-07-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date) 
    VALUE(2,'18292382A','Pablo','Calero','Dominguez','paca@gmail.com',626331432,1000,'1978-11-22','2003-11-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,email,phone,salary,birth_date,contract_date) 
    VALUE(1,'18292381X','Brian','Ferrer','bfl@gmail.com',626621432,1000,'1979-12-29','2004-11-11');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'96916391A','Godwyn','Romulo','Cornejo','pafraumeittei@gmail.com',198756432,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'73780315H','Matias','Gálvez','Ferréndez','jaupeppewiwu-3680@gmail.com',98756421,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'21422296G','Begoña','Espinosa','Villalonga','freheiff4989@gmail.com',645132975,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'33786423K','Custodio ','Mata ','Larrea','froumouk-4009@gmail.com',465879135,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date) 
    VALUE(1,'21444273Q','Noemí ','Pablo','Villena','depeideis-5438@gmail.com',566789789,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date)
    VALUE(2,'70017706W','Íñigo ','Navas','Palomar','zagroutrig@gmail.com',789745681,1200,'1971-04-26','2001-09-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date)
    VALUE(2,'57313696L','Victor ','Manuel ','Reig ','treteibae@gmail.com',195843264,1200,'1971-04-26','2001-09-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date)
    VALUE(2,'73804760Z','Reyes ','Peiró','Perona','weippessubr@gmail.com',7894561235,1200,'1971-04-26','2001-09-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date)
    VALUE(2,'28348230V','Maricela ','Garmendia','Juanlandia','sufibtissi@gmail.com',953624875,1200,'1971-04-26','2001-09-01');
INSERT INTO employee (supervisor_id,dni,name,surname_1,surname_2,email,phone,salary,birth_date,contract_date)
    VALUE(2,'06740826D','Moreno ','Atienza ','Carbó','tauzoinui@gmail.com',194875612,1200,'1971-04-26','2001-09-01');

INSERT INTO technician VALUES(1, 'Hardware');
INSERT INTO technician VALUES(2, 'Software');
INSERT INTO technician (id_technician) VALUES(3);
INSERT INTO technician (id_technician) VALUES(5);
INSERT INTO technician VALUES (7, 'Hardware');
INSERT INTO technician VALUES (9, 'Software');
INSERT INTO technician VALUES(11, 'Hardware');
INSERT INTO technician VALUES(12, 'Software');
INSERT INTO technician VALUES (13, 'Hardware');
INSERT INTO technician VALUES (14, 'Software');
INSERT INTO technician VALUES (15, 'Hardware');
INSERT INTO technician VALUES (16, 'Software');

INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (1, 1, 'phone roto', '2022-11-14 13:12:54', '2022-11-14 15:40:11', NULL);
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (2, 2, 'No va OS', '2022-11-19 19:52:34', '2022-11-20 14:25:13', '2022-11-23 15:55:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (4, 7, 'phone roto', '2022-11-24 09:11:14', '2022-11-29 14:34:55', NULL);
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (10, 2, 'purchase incorrecto', '2022-09-11 20:12:51', '2022-09-12 13:11:14', '2022-10-01 09:11:14');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (11, 2, 'No va OS', '2022-09-19 09:52:34', '2022-09-20 14:25:13', '2022-09-23 15:55:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (10, 3, 'Reembolso', '2022-10-01 09:11:14', '2022-10-01 09:12:14', '2022-10-01 12:23:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (15, 1, 'phone roto', '2022-10-01 12:11:54', '2022-10-14 15:40:11', '2022-10-14 19:54:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (12, 2, 'No va OS', '2022-10-02 15:02:34', '2022-10-20 11:25:13', '2022-10-23 09:55:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (14, 7, 'Pantalla rota', '2022-10-05 15:41:54', '2022-10-07 11:11:55', '2022-10-11 13:45:12');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (13, 1, 'phone roto', '2022-10-09 10:02:14', '2022-10-14 13:40:11', '2022-10-17 09:55:53');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (20, 2, 'No va OS', '2022-10-12 08:52:34', '2022-10-20 18:15:23', '2022-10-23 16:55:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (6, 7, 'phone roto', '2022-10-12 17:14:54', '2022-10-29 14:34:55', '2022-11-03 12:33:11');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (19, 1, 'phone roto', '2022-10-14 12:11:31', '2022-11-14 15:40:11', '2022-12-14 16:16:29');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (8, 2, 'No va OS', '2022-10-19 20:22:34', '2022-10-20 11:25:13', '2022-10-23 19:34:21');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (7, 7, 'phone roto', '2022-10-21 19:49:21', '2022-11-11 11:24:51', NULL);
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (18, 1, 'Pantalla rota', '2022-10-21 21:06:11', '2022-11-14 08:20:11', NULL);
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (9, 3, 'Retraso purchase', '2022-10-22 14:52:34', '2022-11-20 11:15:23', '2022-11-23 19:25:21');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (14, 7, 'phone roto', '2022-10-23 19:31:12', '2022-11-29 17:24:43', '2022-11-30 11:30:10');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (11, 1, 'phone roto', '2022-10-28 13:12:54', '2022-11-11 15:40:11', NULL);
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (12, 2, 'No va OS', '2022-11-07 10:12:34', '2022-11-20 11:25:13', '2022-11-23 12:31:41');
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (14, 7, 'phone roto', '2022-11-07 17:11:14', '2022-11-10 11:22:15', NULL);
INSERT INTO incidence (client_id, technician_supervisor, description, notify_date, start_date, resolution_date)
   VALUES (11, 1, 'phone roto', '2022-11-14 16:11:23', '2022-11-16 10:10:11', NULL);

INSERT INTO incidence_technician VALUES (1, 1);
INSERT INTO incidence_technician VALUES (2, 2);
INSERT INTO incidence_technician VALUES (2, 9);
INSERT INTO incidence_technician VALUES (3, 7);
INSERT INTO incidence_technician VALUES (4, 3);
INSERT INTO incidence_technician VALUES (5, 2);
INSERT INTO incidence_technician VALUES (5, 16);
INSERT INTO incidence_technician VALUES (6, 3);
INSERT INTO incidence_technician VALUES (7, 2);
INSERT INTO incidence_technician VALUES (7, 14);
INSERT INTO incidence_technician VALUES (7, 12);
INSERT INTO incidence_technician VALUES (8, 3);
INSERT INTO incidence_technician VALUES (9, 1);
INSERT INTO incidence_technician VALUES (9, 2);
INSERT INTO incidence_technician VALUES (10, 2);
INSERT INTO incidence_technician VALUES (10, 16);
INSERT INTO incidence_technician VALUES (10, 12);
INSERT INTO incidence_technician VALUES (11, 7);
INSERT INTO incidence_technician VALUES (11, 11);
INSERT INTO incidence_technician VALUES (12, 1);
INSERT INTO incidence_technician VALUES (12, 13);
INSERT INTO incidence_technician VALUES (13, 2);
INSERT INTO incidence_technician VALUES (13, 16);
INSERT INTO incidence_technician VALUES (14, 7);
INSERT INTO incidence_technician VALUES (14, 11);
INSERT INTO incidence_technician VALUES (15, 1);
INSERT INTO incidence_technician VALUES (15, 7);
INSERT INTO incidence_technician VALUES (16, 2);
INSERT INTO incidence_technician VALUES (16, 12);
INSERT INTO incidence_technician VALUES (17, 7);
INSERT INTO incidence_technician VALUES (18, 1);
INSERT INTO incidence_technician VALUES (18, 11);
INSERT INTO incidence_technician VALUES (19, 3);
INSERT INTO incidence_technician VALUES (20, 7);
INSERT INTO incidence_technician VALUES (20, 15);
INSERT INTO incidence_technician VALUES (21, 1);
INSERT INTO incidence_technician VALUES (21, 13);
INSERT INTO incidence_technician VALUES (22, 2);
INSERT INTO incidence_technician VALUES (22, 12);
INSERT INTO incidence_technician VALUES (22, 14);

INSERT INTO salesman VALUE(4);
INSERT INTO salesman VALUE(6);
INSERT INTO salesman VALUE(8);
INSERT INTO salesman VALUE(10);
INSERT INTO salesman VALUE(17);
INSERT INTO salesman VALUE(18);
INSERT INTO salesman VALUE(19);
INSERT INTO salesman VALUE(20);
INSERT INTO salesman VALUE(21);

INSERT INTO country (code,name) VALUE('USA','statuss Unidos');
INSERT INTO country (code,name) VALUE('JEY','Japon');
INSERT INTO country (code,name) VALUE('AUS','Australia');
INSERT INTO country (code,name) VALUE('ES','España');
INSERT INTO country (code,name) VALUE('IE','Irlanda');
INSERT INTO country (code,name) VALUES('CHA','Chad');
INSERT INTO country (code,name) VALUES('MAD','Madagascar');

INSERT INTO supplier (country_id,salesman_id,name,email) VALUE(1,4,'NewEXX Composites','nexxcom.att@int.net');
INSERT INTO supplier (country_id,salesman_id,name,email) VALUE(2,6,'Honne Teshouji','hts.engcontact@yuunji.jp');
INSERT INTO supplier (country_id,salesman_id,name,email) VALUE(3,8,'Malbrand HW International','mbhwint.contact@mbh.com');
INSERT INTO supplier (country_id,salesman_id,name,email) VALUES (4,20,'Juligan An','juan@gmail.com');
INSERT INTO supplier (country_id,salesman_id,name,email) VALUES (5,21,'Permutar drones','pedro@gmail.com');

INSERT INTO brand (code,name) VALUE('XUN','Xiaomsung');
INSERT INTO brand (code,name) VALUE('SAI','SANGOMI');
INSERT INTO brand (code,name) VALUE('XIA','Xiapple');
INSERT INTO brand (code,name) VALUES('SXN','Sanxing');
INSERT INTO brand (code,name) VALUES('ZTE','Zhongguo TeleEn');

INSERT INTO phone (brand_id,model,pvp,stock) VALUE(1,'Xiaomsung32',200.99,0);
INSERT INTO phone (brand_id,model,pvp,stock) VALUE(3,'Xiapple13',700.00,100);
INSERT INTO phone (brand_id,model,pvp,stock) VALUE(1,'XS21',100.00,1);
INSERT INTO phone VALUES (350, 2, 'SangomiA1', 500.00, 20);
INSERT INTO phone VALUES (210, 1, 'XS22', 250.00, 13);
INSERT INTO phone VALUES (340, 1, 'XS25', 1000.00, 20);
INSERT INTO phone VALUES (222, 3, 'APear', 500.00, 21);
INSERT INTO phone VALUES (221, 3, 'xaMaar', 200.00, 30);
INSERT INTO phone VALUES (200, 2, 'SangomiA2', 1500.00, 27);
INSERT INTO phone VALUES (150, 2, 'SangomiALite', 470.00, 43);

INSERT INTO phone VALUES (549, 4, 'movilsan', 700.00, 0);
INSERT INTO phone VALUES (684, 5, 'Ztemovile2', 450.00, 99);
INSERT INTO phone VALUES (468, 3, 'Apear2', 1500.00, 21);
INSERT INTO phone VALUES (879, 1, 'XS34', 500.00, 22);
INSERT INTO phone VALUES (123, 4, 'movilsan24', 250.00, 20);
INSERT INTO phone VALUES (651, 5, 'Ztemov23', 1700.00, 1);
INSERT INTO phone VALUES (135, 5, 'Ztemovile', 300.00, 39);
INSERT INTO phone VALUES (548, 4, 'movilsan4', 800.00, 1);
INSERT INTO phone VALUES (683, 5, 'Ztemovile3', 900.00, 3);

INSERT INTO phone_purchase VALUES (1, 210, 2);
INSERT INTO phone_purchase VALUES (2, 222, 1);
INSERT INTO phone_purchase VALUES (2, 221, 2);
INSERT INTO phone_purchase VALUES (7, 200, 1);
INSERT INTO phone_purchase VALUES (3, 100, 2);
INSERT INTO phone_purchase VALUES (3, 210, 1);
INSERT INTO phone_purchase VALUES (4, 101, 1);
INSERT INTO phone_purchase VALUES (5, 221, 1);
INSERT INTO phone_purchase VALUES (5, 102, 1);
INSERT INTO phone_purchase VALUES (6, 200, 1);
INSERT INTO phone_purchase VALUES (8, 123, 1);
INSERT INTO phone_purchase VALUES (8, 135, 1);
INSERT INTO phone_purchase VALUES (8, 340, 2);
INSERT INTO phone_purchase VALUES (9, 135, 1);
INSERT INTO phone_purchase VALUES (10, 221, 1);
INSERT INTO phone_purchase VALUES (10, 651, 1);
INSERT INTO phone_purchase VALUES (11, 200, 1);
INSERT INTO phone_purchase VALUES (12, 879, 2);
INSERT INTO phone_purchase VALUES (13, 222, 1);
INSERT INTO phone_purchase VALUES (13, 340, 1);
INSERT INTO phone_purchase VALUES (14, 221, 2);
INSERT INTO phone_purchase VALUES (15, 684, 1);
INSERT INTO phone_purchase VALUES (16, 468, 2);
INSERT INTO phone_purchase VALUES (17, 548, 1);
INSERT INTO phone_purchase VALUES (18, 221, 1);
INSERT INTO phone_purchase VALUES (18, 350, 1);
INSERT INTO phone_purchase VALUES (19, 684, 1);
INSERT INTO phone_purchase VALUES (20, 150, 1);
INSERT INTO phone_purchase VALUES (20, 548, 2);
INSERT INTO phone_purchase VALUES (21, 879, 5);

INSERT INTO phone_supplier VALUES (100, 1, 165.95);
INSERT INTO phone_supplier VALUES (101, 1, 624.45);
INSERT INTO phone_supplier VALUES (102, 1, 76.75);
INSERT INTO phone_supplier VALUES (350, 2, 425.50);
INSERT INTO phone_supplier VALUES (210, 3, 210.00);
INSERT INTO phone_supplier VALUES (340, 2, 870.25);
INSERT INTO phone_supplier VALUES (222, 3, 410.65);
INSERT INTO phone_supplier VALUES (221, 3, 165.50);
INSERT INTO phone_supplier VALUES (200, 3, 1350.80);
INSERT INTO phone_supplier VALUES (150, 3, 400.00);
INSERT INTO phone_supplier VALUES (549, 4, 125.95);
INSERT INTO phone_supplier VALUES (683, 5, 90.45);
INSERT INTO phone_supplier VALUES (684, 4, 76.75);
INSERT INTO phone_supplier VALUES (468, 3, 825.50);
INSERT INTO phone_supplier VALUES (210, 5, 510.00);
INSERT INTO phone_supplier VALUES (651, 3, 840.25);
INSERT INTO phone_supplier VALUES (123, 2, 1410.65);
INSERT INTO phone_supplier VALUES (651, 1, 135.50);
INSERT INTO phone_supplier VALUES (879, 4, 140.80);
INSERT INTO phone_supplier VALUES (548, 5, 300.00);
