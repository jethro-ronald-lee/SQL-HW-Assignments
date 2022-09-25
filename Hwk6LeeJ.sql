USE sharkdbleej;

-- 1) Write a function mostAttacks() that returns the township id of the township that had the most number of attacks. The function 
-- accepts no arguments. If there are more than 1 town with the maximum value, return any town with the maximum value.

DROP FUNCTION IF EXISTS most_attacks;

DELIMITER $$

CREATE FUNCTION most_attacks() RETURNS INT
	NOT DETERMINISTIC READS SQL DATA
    BEGIN
    DECLARE most_attacked_town_v INT;
    SELECT location INTO most_attacked_town_v FROM
    (SELECT location, COUNT(*) FROM township 
		INNER JOIN attack
			ON location = tid
				GROUP BY location
					ORDER BY COUNT(*) DESC
						LIMIT 1) AS attack_counts;
	RETURN most_attacked_town_v;
    END $$

DELIMITER ;

SELECT most_attacks();

-- 2) Write a procedure allReceivers(town, state) that accepts a town name and a state abbreviation and returns a result set of all 
-- receivers in that town. The result should contain all the fields in the receiver table as well as the provided town and state. 

DROP PROCEDURE IF EXISTS all_receivers;

DELIMITER //

CREATE PROCEDURE all_receivers(
IN town_p VARCHAR(64),
IN state_p CHAR(2))
BEGIN
	DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
        
	SELECT receiver.*, town, state FROM receiver INNER JOIN township ON tid = location
				WHERE tid = (SELECT tid FROM township WHERE town_p = town AND state_p = state);
        
END //

DELIMITER ;

CALL all_receivers("Chatham", "MA");
CALL all_receivers ('Eastport', 'ME');
CALL all_receivers ('Saratoga Springs', 'NY');

-- 3) Write a procedure named sharkLenGTE(length_p)  that accepts a length for a shark and returns a result set that contains the 
-- shark id, shark name, shark length, shark sex, and the number of detections for that shark for all sharks with a length 
-- greater than or equal to the passed length. 

DROP PROCEDURE IF EXISTS shark_len_gte;

DELIMITER //

CREATE PROCEDURE shark_len_gte(
IN length_p DOUBLE)

BEGIN

	DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
        
	SELECT sid, name, length, sex, detections FROM shark
				WHERE length >= length_p;
        
END //

DELIMITER ;

CALL shark_len_gte(8);
CALL shark_len_gte(150);

-- 4) Write a function named numSharkWithLen(length_p) that accepts a shark length and returns the number of sharks with that 
-- length
DROP FUNCTION IF EXISTS num_shark_with_len;

DELIMITER $$

CREATE FUNCTION num_shark_with_len(length_p DOUBLE) RETURNS INT
	DETERMINISTIC READS SQL DATA
    BEGIN
    DECLARE shark_count_v INT;
    SELECT COUNT(*) INTO shark_count_v FROM shark
		WHERE length = length_p;
   
	RETURN shark_count_v;
    END $$

DELIMITER ;

SELECT num_shark_with_len(11);
SELECT num_shark_with_len(5);

-- 5) Write a procedure named sightingsByTown( ) that accepts no arguments and returns a row for each township tuple in the 
-- township table. The result contains the number of sightings per town, the town name and the state abbreviation. 

DROP PROCEDURE IF EXISTS sightings_by_town;

DELIMITER //

CREATE PROCEDURE sightings_by_town()

BEGIN

	DECLARE sql_error INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
        
	SELECT town, state, SUM(detections)
		FROM township LEFT OUTER JOIN receiver
			ON tid = location
				GROUP BY town, state;
        
END //

DELIMITER ;

CALL sightings_by_town();

-- 6) Write a function named moreDetections(shark1,shark2). It accepts 2 shark names and returns 1 if shark1 has had more detections 
-- than shark2, 0 if they have had the same number of detections , and -1 if shark2 has had more detections than shark1. 

DROP FUNCTION IF EXISTS more_detections;

DELIMITER $$

CREATE FUNCTION more_detections(shark1 VARCHAR(64), shark2 VARCHAR(64)) RETURNS INT
	DETERMINISTIC READS SQL DATA
    BEGIN
    DECLARE comparison_value INT;
    DECLARE shark_1_detections INT;
    DECLARE shark_2_detections INT;
    
    SELECT detections INTO shark_1_detections FROM shark
		WHERE name = shark1;
	SELECT detections INTO shark_2_detections FROM shark
		WHERE name = shark2;
        
	IF shark_1_detections > shark_2_detections THEN
		SET comparison_value = 1;
	ELSEIF shark_2_detections > shark_1_detections THEN
		SET comparison_value = -1;
	ELSE
		SET comparison_value = 0;
	END IF;
   
	RETURN comparison_value;
    END $$

DELIMITER ;

SELECT more_detections('Jack', 'Annie');
SELECT more_detections('Elephant', 'Turbo');
SELECT more_detections('Bou', 'Bertie');

-- 7) Create a procedure named createAttack( sname_p , vname_p , vage_p , fatal_p, attack_date,  activity_p,  description_p ,town_p, 
-- state_p ) that inserts an attack into the database. Make sure you create the appropriate tuples in the victim, shark and 
-- township table as well. Insert another attack into the attack table. victim name = “Ace Ventura”, age = 35, town = “Wellfleet”, 
-- state = “MA”,  shark_name = NULL, fatal = 0, date = ‘2021-08-11’, description = “right foot”, activity = “surfing”. 

DROP PROCEDURE IF EXISTS create_attack;

DELIMITER //

CREATE PROCEDURE create_attack(
IN sname_p VARCHAR(64),
IN vname_p VARCHAR(45),
IN vage_p INT,
IN fatal_p CHAR(1),
IN attack_date DATE,
IN activity_p VARCHAR(64),
IN description_p VARCHAR(64),
IN town_p VARCHAR(64),
IN state_p CHAR(2))

BEGIN

	DECLARE v_count INT;
    DECLARE s_count INT;
    DECLARE t_count INT;
    DECLARE a_count INT;
    DECLARE victim_id INT;
    DECLARE town_id INT;
    DECLARE shark_id INT;
	DECLARE sql_error INT DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    SELECT COUNT(*) INTO v_count FROM victim WHERE age = vage_p AND name = vname_p;
    SELECT COUNT(*) INTO s_count FROM shark WHERE name = sname_p;
    SELECT COUNT(*) INTO t_count FROM township WHERE town = town_p AND state = state_p;
    SELECT COUNT(*) INTO a_count FROM attack WHERE fatal = fatal_p AND date = attack_date AND
    activity = activity_p AND description = description_p;
	
	IF v_count = 0 THEN 
	INSERT INTO victim (vid, name, age) VALUES 
    (NULL, vname_p, vage_p);
    END IF;
    SELECT vid INTO victim_id FROM victim WHERE age = vage_p AND name = vname_p;
     
	IF s_count = 0 THEN
	INSERT INTO shark (sid, name, sex)
		VALUES (NULL, sname_p, 'Unknown');
	END IF;
	SELECT sid INTO shark_id FROM shark WHERE name = sname_p;
    
   IF t_count = 0 THEN
   INSERT INTO township (town, state) VALUES (town_p, state_p);
   END IF;
   SELECT tid INTO town_id FROM township WHERE town = town_p AND state = state_p;
    
    IF a_count = 0 THEN
	INSERT INTO attack (shark, victim, fatal, date, activity, description, location)
		VALUES (shark_id, victim_id, fatal_p, attack_date, activity_p, description_p,town_id);
	END IF;
        
END //

DELIMITER ;

CALL create_attack(NULL, 'Ace Ventura', '35', '0', '2021-08-11', 'surfing', 'right foot', 'Wellfleet','MA');
CALL create_attack('Vincent', 'Jeff Hummingbird', '19', '1', '2021-05-14', 'swimming', 'left ankle', 'Loudonville','NY');
CALL create_attack('Tristna', 'Racism', '81', '1', '2018-04-08', 'drowning', 'chest', 'Tampa Bay','FL');

-- 8) Modify the township table to track the number of shark attacks for that town. Call the new field numAttacks. 
-- Write a procedure named initialize_num_attack(townid) that initializes the field for a specific township. Call the procedure 
-- for each town in the attack table.

ALTER TABLE township ADD num_attacks INT;

DROP PROCEDURE IF EXISTS initialize_num_attack;

DELIMITER //

CREATE PROCEDURE initialize_num_attack(
IN townid INT)

BEGIN
	
    DECLARE num_attacks_var INT;
	DECLARE sql_error INT DEFAULT FALSE;
    
    SELECT COUNT(*) INTO num_attacks_var FROM attack INNER JOIN township
		ON location = tid
			WHERE tid = townid;
	UPDATE township
		SET num_attacks = num_attacks_var WHERE tid = townid;
        
END //

DELIMITER ;
  
DROP PROCEDURE IF EXISTS update_each_town;
    
DELIMITER //

CREATE PROCEDURE update_each_town()

BEGIN
	
    DECLARE tid_var INT;
    DECLARE action_completed INT;
    DECLARE sql_error INT DEFAULT FALSE;
    DECLARE update_num_attacks CURSOR FOR
		SELECT tid FROM township;
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET action_completed = 1;
    
    OPEN update_num_attacks;
    retrieve_attacks: LOOP
		FETCH update_num_attacks INTO tid_var;
IF action_completed = 1
	THEN LEAVE retrieve_attacks;
END IF;

CALL initialize_num_attack(tid_var);
END LOOP retrieve_attacks;
CLOSE update_num_attacks;
END //

DELIMITER ;

CALL initialize_num_attack(3);
CALL initialize_num_attack(7);
CALL initialize_num_attack(4);
CALL update_each_town();

-- 9) Write a trigger that updates township.numAttacks whenever an attack is added to the attack table. Name the 
-- trigger attack_after_insert(). Insert an attack into the attack table to verify your trigger is working;  
-- victim name = “Jennifer Jones”, age = 25, town = “Truro”, state = “MA”,  sharkid = NULL, fatal = 0, date = ‘2021-11-11’, 
-- description = “left foot”, activity = “surfing”. 

DROP TRIGGER IF EXISTS attack_after_insert;

DELIMITER //

CREATE TRIGGER attack_after_insert
	AFTER INSERT ON attack
    FOR EACH ROW 
BEGIN
CALL initialize_num_attack(new.location);
    
END //

DELIMITER ;
INSERT INTO victim (vid, name, age) VALUES (NULL, 'Jennifer Jones', 25);
INSERT INTO attack VALUES (NULL, 13, 0, '2021-11-11','surfing', 'left foot', 1);

INSERT INTO victim (vid, name, age) VALUES (NULL, 'Eliza Pancakes', 26);
INSERT INTO attack VALUES (6, 14, 1, '2019-06-27','eating pancakes in the ocean', 'hair', 27);

CALL create_attack('Pazu', 'Bob Pancakes', '70', '0', '2017-05-04', 'fighting a shark', 'shoulder', 'Cohasset','MA');

-- 10) Write a trigger that updates township.numAttacks whenever an attack is deleted from the attack table. Call the trigger 
-- attack_after_delete().  Delete the attack from the attack table to verify your trigger is working;  victim name = “Jennifer Jones”, 
-- age = 25, town = “Truro”, state = “MA”,  sharkid = NULL, fatal = 0, date = ‘2021-11-11’, description = “left foot”, activity = “surfing”.

DROP TRIGGER IF EXISTS attack_after_delete;

DELIMITER //

CREATE TRIGGER attack_after_delete
	AFTER DELETE ON attack
    FOR EACH ROW 
BEGIN
CALL initialize_num_attack(old.location);
    
END //

DELIMITER ; 

DELETE FROM attack WHERE victim = 13 AND date = '2021-11-11';
DELETE FROM attack WHERE victim = 14 AND date = '2019-06-27';
DELETE FROM attack WHERE victim = 15 AND date = '2017-05-04';

-- 11) Create and execute a prepared statement from the SQL workbench that calls the function moreDetections(shark1, shark2). 
-- Use 2 user session variables to pass the two arguments to the function. Pass the values “Amy” and “Alex” as the shark variables 

SET @s = "SELECT more_detections(?, ?)";
SET @shark1 = "Amy";
SET @shark2 = "Alex";

PREPARE stmt FROM @s;
EXECUTE stmt USING @shark1, @shark2;
DEALLOCATE PREPARE stmt;

-- 12) Create and execute a prepared statement from the SQL workbench that calls the function numSharkWithLen(length_p). 
-- Use a user session variable to pass the length to the function. Pass the value 14 as the length  

SET @s = "SELECT num_shark_with_len(?)";
SET @length = "14";

PREPARE stmt FROM @s;
EXECUTE stmt USING @length;
DEALLOCATE PREPARE stmt;