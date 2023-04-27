USE cellphones;  
-- Funcio que prepara a partir d'una ciutat introduida la retorna afegint '%...%' per facilitar la cerca.
DELIMITER //
CREATE OR REPLACE FUNCTION CiutatToAddressPrompt(ciutat VARCHAR(20)) RETURNS VARCHAR(20)
BEGIN
	RETURN CONCAT('%',ciutat,'%');
END //
DELIMITER ;
SELECT CiutatToAddressPrompt('Barcelona');

-- Procediment que introduim una ciutat i ens mostra el nom sencer, l'email i el telèfon de tot els clients i empleats que viuen a la ciutat.
-- utilitza la funcio anterior
DELIMITER //
CREATE OR REPLACE PROCEDURE showDataClientsEmployee(IN addressP VARCHAR(50))
BEGIN
	DECLARE sqldata TEXT;
	SET sqldata = 
    'SELECT CONCAT(name,'' '',surname) as full_name, email, phone, ''Client'' as type
	FROM client
	WHERE address LIKE ?
	UNION
	SELECT CONCAT(name,'' '',surname_1,'' '',surname_2), email, phone,''Employee''
	FROM employee
	WHERE address LIKE ? ;';

	SET @SQL = sqldata;
    SELECT CiutatToAddressPrompt(addressP) INTO @adreca;

	PREPARE stmt FROM @SQL;
	EXECUTE stmt USING @adreca,@adreca;
	DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

CALL showDataClientsEmployee ('Barcelona');
CALL showDataClientsEmployee ('Màlaga');
CALL showDataClientsEmployee('Ceuta');


-- Procediment que sense repeticions ens mostra el nom complert dels client que han comprat algun movil d'un pais que introduïm.
DELIMITER //
CREATE OR REPLACE PROCEDURE showFullNameClientsPhoneCountry(IN paisP VARCHAR(15))
BEGIN
	DECLARE sqldata TEXT;
    SET sqldata = '	SELECT DISTINCT CONCAT(c.name,'' '',c.surname) as full_name
					FROM client c
						INNER JOIN purchase p ON c.id_client = p.client_id
						INNER JOIN phone_purchase pp ON p.id_purchase = pp.id_purchase
						INNER JOIN phone ph ON ph.id_phone = pp.id_phone
						INNER JOIN phone_supplier ps ON ps.id_phone = ph.id_phone
						INNER JOIN supplier s ON s.id_supplier = ps.id_supplier
						INNER JOIN country co ON s.country_id = co.id_country
					WHERE co.name = ? ;';
                    
	SET @SQL = sqldata;
    SET @pais = paisP;
    
	PREPARE stmt FROM @SQL;
    EXECUTE stmt USING @pais;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;
CALL showFullNameClientsPhoneCountry('España');
CALL showFullNameClientsPhoneCountry('Japón');

-- Procediment que per a cada client ens mostra el nom complert i quantitat de movils comprats ordenats en quantitat descendent.
DELIMITER //
CREATE OR REPLACE PROCEDURE showFullNameClientsPhonesPurchased()
BEGIN
	DECLARE sqldata TEXT;
    SET sqldata = '	SELECT CONCAT(name,'' '',surname) as full_name, SUM(pp.amount) as amount
					FROM client c
						INNER JOIN purchase p ON c.id_client = p.client_id
						INNER JOIN phone_purchase pp ON p.id_purchase = pp.id_purchase
					GROUP BY c.id_client
					ORDER BY amount DESC;';
                    
	SET @SQL = sqldata;
    
	PREPARE stmt FROM @SQL;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;
CALL showFullNameClientsPhonesPurchased();

-- Procediment mostra columna phones
DELIMITER //
CREATE OR REPLACE PROCEDURE mostraPhones()
BEGIN
	SELECT * FROM phone;
END //
DELIMITER ;
CALL mostraPhones();

-- Funcio que retorna el id_brand rebent el code.
DELIMITER //
CREATE OR REPLACE FUNCTION getBrandIdFromCode(IN codeP VARCHAR(3)) RETURNS SMALLINT(3)
BEGIN
	RETURN (SELECT id_brand FROM brand WHERE code = codeP);
END //
DELIMITER ;

SELECT getBrandIdFromCode('XIA');
SELECT getBrandIdFromCode('SAI');


ALTER TABLE phone ADD preuBlackFriday DECIMAL(7,2);
-- Cursor que modifica el preu de black friday d'una code brand introduida i descompte introduït.
-- utilitza la funcio anterior

DELIMITER //
CREATE OR REPLACE PROCEDURE actualitza_PreusBF(IN brandcodeP VARCHAR(15), IN descompteP INT)
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE var_idphone, var_preuBlackFriday DECIMAL(7,2);
    DECLARE cursor_BlackFriday CURSOR FOR SELECT id_phone ,pvp-(pvp*descompteP/100) as preuBF FROM phone;								
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cursor_BlackFriday;
    bucle: loop
		FETCH FROM cursor_BlackFriday INTO var_idphone, var_preuBlackFriday;
        IF done THEN
			LEAVE bucle;
		END IF;
        UPDATE phone SET preuBlackFriday = var_preuBlackFriday 
        WHERE brand_id = (SELECT getBrandIdFromCode(brandcodeP)) AND id_phone = var_idphone;
    END LOOP;
    CLOSE cursor_BlackFriday;
END //
DELIMITER ;

CALL actualitza_PreusBF('ZTE',10);
CALL mostraPhones();
CALL actualitza_PreusBF('SAI',40);



-- Funcio que retorna el model que més a facturat.
DELIMITER //
CREATE OR REPLACE FUNCTION getModelAmbMesFacturacio()
RETURNS VARCHAR(15)
BEGIN
	RETURN (SELECT ph.model FROM phone AS ph
    INNER JOIN phone_supplier AS ps ON ph.id_phone = ps.id_phone
	INNER JOIN supplier AS su ON ps.id_supplier = su.id_supplier
    INNER JOIN phone_purchase AS pp ON ph.id_phone = pp.id_phone
    GROUP BY ph.model
    ORDER BY pvp*amount DESC
    LIMIT 1);
END //
DELIMITER ;

SELECT getModelAmbMesFacturacio() AS modelAmbMesFacturacio;

-- Procediment que retrona la quantitat de diners que a facturat un model introduït per parametre.
DELIMITER //
CREATE OR REPLACE PROCEDURE getFacturacioModel(IN model VARCHAR(15))
BEGIN
	SET @model = model;
	SET @sql = 'SELECT SUM(pvp*amount) AS facturat FROM phone AS ph 
	INNER JOIN brand AS br ON ph.brand_id = br.id_brand
	INNER JOIN phone_purchase AS pp ON ph.id_phone = pp.id_phone
    WHERE ph.model = (?)
    GROUP BY ph.model
    ORDER BY SUM(pvp*amount)';
    PREPARE instr FROM @sql;
    EXECUTE instr USING @model;
    DEALLOCATE PREPARE instr;
END //
DELIMITER ;
CALL getFacturacioModel('XS21');
CALL getFacturacioModel(getModelAmbMesFacturacio());

-- Procediment que retorna la quantitats de model enviats per més, introduïnt el més per parametre.
DELIMITER //
CREATE OR REPLACE PROCEDURE getQuantitatEnviatsPerMes(IN mes TINYINT(2))
BEGIN
	SET @mes = mes;
	SET @sql = 'SELECT COUNT(ph.model) AS quantitat FROM phone AS ph
	INNER JOIN phone_purchase AS pp ON ph.id_phone = pp.id_phone
    INNER JOIN purchase AS pu ON pp.id_purchase = pu.id_purchase
		WHERE MONTH(pu.sent_date) = ?';
	PREPARE instr FROM @sql;
    EXECUTE instr USING @mes;
    DEALLOCATE PREPARE instr;
END //
DELIMITER ;
CALL getQuantitatEnviatsPerMes(12);

-- Trigger que inserirà a una nova taula l'id del treballador, el percentage del canvi del seu sou,
-- la data_hora de quan s'ha fet l'actualitzacio del sou i l'usuari que l'ha fet.

-- Creació de la nova taula
DROP TABLE IF EXISTS percentatgesous;
CREATE TABLE percentatgesous(
	id_employee	SMALLINT(2),
    percentatge		DECIMAL(4,2),
    data_hora		TIMESTAMP,
	usuari			VARCHAR(30)
)ENGINE = InnoDB;

-- Creació del trigger.
DELIMITER //
CREATE OR REPLACE TRIGGER percentatgeSous AFTER UPDATE ON employee FOR EACH ROW
BEGIN
	DECLARE percentatge DECIMAL(4,2);
	SET percentatge = ((NEW.salary - OLD.salary) / OLD.salary) * 100;
	INSERT INTO percentatgesous (id_employee, percentatge, data_hora, usuari) VALUES (OLD.id_employee, percentatge, NOW(), USER());
END //
DELIMITER ;

-- Procediment per actualitzar els sous del tecnics, hi ha 2 tipus de tecnics, els de Software i els de Hardware.
-- Definexes a quin vols cambiar el sou introduïnt per parametre H o S, el nou sou y la ciutat 
-- (nomes actualitzara el sou als tecnics que viuen en la ciutat introduïda)
DELIMITER //
CREATE OR REPLACE PROCEDURE actualitzarSouTecnics(IN tipus ENUM('H', 'S'), IN sou DECIMAL(6,2), IN ciutat VARCHAR(20))
BEGIN
SET @sou = sou;
SET @ciutat = ciutat;
    IF (tipus = 'S') THEN
		SET @sql = 'UPDATE employee AS em
		JOIN technician AS te ON em.id_employee = te.id_technician
		SET em.salary = ?		
		WHERE te.speciality = ''Software'' AND em.address = ?';
        PREPARE instr FROM @sql;
		EXECUTE instr USING @sou, @ciutat;
		DEALLOCATE PREPARE instr;
        
    ELSEIF (tipus = 'H') THEN
		SET @sql = 'UPDATE employee AS em
		JOIN technician AS te ON em.id_employee = te.id_technician
		SET em.salary = ?		
		WHERE te.speciality = ''Hardware'' AND em.address = ?';
        PREPARE instr FROM @sql;
		EXECUTE instr USING @sou, @ciutat;
		DEALLOCATE PREPARE instr;
    END IF;
END //
DELIMITER ;

-- Demostració procediment:
SELECT * FROM employee AS em
	INNER JOIN technician AS te ON em.id_employee = te.id_technician;
CALL actualitzarSouTecnics('S', 1450.00, 'Barcelona');
CALL actualitzarSouTecnics('H', 1350.00, 'Fuentalbilla');
SELECT * FROM employee AS em
	INNER JOIN technician AS te ON em.id_employee = te.id_technician;
-- Demostració trigger:
SELECT * FROM percentatgesous;


-- Funcio que retorna l'edat introduïnt la data de naixement per parametre.
DELIMITER //
CREATE FUNCTION getEdat(vData DATE)
RETURNS SMALLINT
BEGIN
	RETURN TIMESTAMPDIFF(YEAR, vData, NOW());
END //
DELIMITER ;

SELECT getEdat('2002/09/21');

-- Procediment que donara en una nova columna l'edat i edat de contracte de cada empleat.

-- Es crean les noves columnes.
ALTER TABLE employee ADD (edat INT DEFAULT null, edat_contracte INT DEFAULT null);
-- Es fa el procediment.
DELIMITER //
CREATE OR REPLACE PROCEDURE doDatesEmpleats()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE var_id_empleat, var_edat, var_edat_contracte INT;
    DECLARE cur_dates CURSOR FOR SELECT id_employee, getEdat(birth_date), getEdat(contract_date) FROM employee;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
    OPEN cur_dates;
    read_loop: LOOP
        FETCH FROM cur_dates INTO var_id_empleat, var_edat, var_edat_contracte;
        IF done THEN
            LEAVE read_loop;
        END IF;
        UPDATE employee
        SET edat = var_edat,
            edat_contracte = var_edat_contracte
        WHERE id_employee = var_id_empleat;
    END LOOP;
    CLOSE cur_dates;
END //
DELIMITER ;

SELECT * FROM employee;
CALL doDatesEmpleats();
SELECT * FROM employee;

-- Funcio per saber el stock del model introduït per parametre.
DELIMITER //
CREATE OR REPLACE FUNCTION getModelStock(model VARCHAR(15))
RETURNS SMALLINT
BEGIN
	RETURN (SELECT ph.stock FROM phone AS ph
	WHERE ph.model = model);
END //
DELIMITER ;

SELECT getModelStock('Apear');


-- Funcio per saber si el treballador treballa per a una empresa os es autonòm;
DELIMITER //
CREATE OR REPLACE FUNCTION autonomEmpresa(company VARCHAR(20))
RETURNS VARCHAR(10)
BEGIN
	IF (company IS NULL) THEN
		RETURN 'Autonom';
	ELSE 
		RETURN 'Empresa';
	END IF;
END //
DELIMITER ;

SELECT tr.id_transporter, autonomEmpresa(tr.company) AS tipus, tr.company FROM purchase AS pu
	INNER JOIN transporter AS tr ON pu.transporter_id = id_transporter
    INNER JOIN client AS cl ON pu.client_id = cl.id_client
    GROUP BY tr.id_transporter;
    

-- Funcio que retorna els enviaments que ha fet un repartidor, pasant el id del repartidor per parametre.
DELIMITER //
CREATE OR REPLACE FUNCTION getEnviamentsRepartidoID(id SMALLINT)
RETURNS SMALLINT(2)
BEGIN
    DECLARE envios SMALLINT(2);
    SELECT COUNT(cl.id_client) INTO envios FROM purchase AS pu
    INNER JOIN transporter AS tr ON pu.transporter_id = tr.id_transporter
    INNER JOIN client AS cl ON pu.client_id = cl.id_client
    WHERE tr.id_transporter = id;
    RETURN envios;
END //
DELIMITER ;

SELECT getEnviamentsRepartidoID(3);

-- Funcio que retorna si es o no rendible depenent del valor introduït.
DELIMITER //
CREATE OR REPLACE FUNCTION getRendible(num DECIMAL)
RETURNS VARCHAR(11)
BEGIN
    IF (num < 3000.00) THEN
		RETURN 'No rendible';
	ELSE
		RETURN 'Rendible';
	END IF;
END //
DELIMITER ;
SELECT getRendible(3500.00);

SELECT su.name, SUM(ph.pvp*pp.amount), getRendible(SUM(ph.pvp*pp.amount)) FROM phone AS ph
    INNER JOIN phone_supplier AS ps ON ph.id_phone = ps.id_phone
	INNER JOIN supplier AS su ON ps.id_supplier = su.id_supplier
    INNER JOIN phone_purchase AS pp ON ph.id_phone = pp.id_phone
    GROUP BY su.name;

-- Trigger que insertarà els nous clients inserits en una nova taula nousClients2023.

-- Creació de la taula.
DROP TABLE IF EXISTS nousClients2023;
CREATE TABLE nousClients2023(
	id_client MEDIUMINT,
	dni VARCHAR(9) NOT NULL,
	name VARCHAR (20) NOT NULL,
	surname VARCHAR(20) NOT NULL,
	email VARCHAR(30) NOT NULL,
	phone VARCHAR(15),
	address VARCHAR(50),
    PRIMARY KEY (id_client)
)ENGINE = InnoDB;

-- Creació trigger.
DELIMITER //
CREATE OR REPLACE TRIGGER nous_clients BEFORE INSERT ON client FOR EACH ROW
BEGIN
	INSERT INTO nousClients2023 (id_client, dni, name, surname, email, phone, address) VALUES (NEW.id_client, NEW.dni, NEW.name, NEW.surname, NEW.email, NEW.phone, NEW.address);
END //
DELIMITER ;

-- Procediment per insertar nous clients amb declaració d'errors.
DELIMITER //
CREATE OR REPLACE PROCEDURE insertClients(IN dni VARCHAR(9), IN pName VARCHAR(20), IN surname VARCHAR(20), IN email VARCHAR(30), IN phone VARCHAR(15), IN addres VARCHAR(50))
BEGIN
	DECLARE EXIT HANDLER FOR 1048 SELECT 'Una de las columnes no pot ser NULL!' AS 'Error al inserir!';
    DECLARE EXIT HANDLER FOR 1062 SELECT 'Aquest client ja existeix!' AS 'Error al inserir!';
	SET @dni = dni, @pName=pName, @surname=surname, @email = email, @phone=phone, @addres=addres;
    SET @sql = 'INSERT INTO client (dni, name, surname, email, phone, address) VALUES (?,?,?,?,?,?)';
    PREPARE instr FROM @sql;
    EXECUTE instr USING @dni, @pName, @surname, @email, @phone, @addres;
    DEALLOCATE PREPARE instr;
END //
DELIMITER ;
CALL insertClients('45372989B', 'Albert', 'Nuñez', 'anunez@alumnat.copernic.cat', '435931757', null);
CALL insertClients('54372949B', null, null, 'afernandez@gmail.com', '616543411', null);
CALL insertClients('45372989B', 'Albert', 'Nuñez', 'anunez@alumnat.copernic.cat', '435931757', null);

SELECT * FROM client;
SELECT * FROM nousClients2023;


-- Trigger que inserirà tots els empleats que es borrin de la taula employee a la taula employee_backup.

DROP TABLE IF EXISTS employee_backup;
CREATE TABLE employee_backup (
   id_employee SMALLINT(3),
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
   data_hora_delete DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id_employee, data_hora_delete)
)ENGINE=INNODB;

DELIMITER //
CREATE OR REPLACE TRIGGER employee_backup BEFORE DELETE ON employee FOR EACH ROW
BEGIN
   INSERT INTO employee_backup (id_employee,dni,name,surname_1,surname_2,email,phone,address,salary,birth_date,contract_date)
   VALUES (OLD.id_employee,OLD.dni,OLD.name,OLD.surname_1,OLD.surname_2,OLD.email,OLD.phone,OLD.address,OLD.salary,OLD.birth_date,OLD.contract_date);
END //
DELIMITER ;

ALTER TABLE employee DROP CONSTRAINT fk_employee_employee;
ALTER TABLE technician DROP CONSTRAINT fk_employee_technician;
DELETE FROM employee WHERE id_employee = 2;
DELETE FROM employee WHERE name = 'Matias';
DELETE FROM employee WHERE id_employee = 2;
SELECT * FROM employee_backup;
