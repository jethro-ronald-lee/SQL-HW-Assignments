USE sharkdbleej;

-- 1) For each shark (found in the shark table), determine the number of detections for the shark as documented within the database. 
-- Each tuple in the result should contain the shark’s name, shark’s id  and the number of detections. In the result, rename the number of 
-- detections to “sightings”. 
SELECT name, sid, detections AS sightings FROM shark;

-- 2) Determine the number of shark detections for each bay (as documented in the database). Each tuple in the result should contain the bay’s 
-- name and the number of detections.  Sort the result by the number of detections in descending order.
SELECT bayside, SUM(detections) FROM receiver INNER JOIN bay
	ON bayside = name GROUP BY bayside ORDER BY SUM(detections) DESC;
    
-- 3) Return the length of the largest shark. The result should consist of a number and be renamed longest.
SELECT MAX(length) AS longest FROM shark;

-- 4) What receiver has been documented as having the most number of shark  detections? The result should contain the receiver’s area, town, 
-- state, and the number of detections
SELECT area, town, state, detections FROM receiver INNER JOIN township ON location = tid
		WHERE detections = (SELECT MAX(detections) FROM receiver);

-- 5) What receiver has sighted all sharks (sharks documented in the database)? The result should contain all of the receiver fields from the
--  receiver table. 
SELECT * FROM receiver
	WHERE individual_sharks_detected = (SELECT COUNT(DISTINCT sid) FROM shark);

-- 6) Make a separate table from the receiver table – where the records are for the bayside receivers. Name the new table bayside_encounters.

DROP TABLE IF EXISTS bayside_encounters;
CREATE TABLE bayside_encounters AS (SELECT * FROM receiver
		WHERE bayside IS NOT NULL);

-- 7) Which sharks have been documented as part of an attack. The result should contain the shark.id, shark.name, sex, length and number of 
-- detections.
SELECT sid, name, sex, length, detections FROM shark INNER JOIN attack
	ON sid = shark;

-- 8) For each bay (each name in the bay table), create an aggregated field that contains a list of the receivers in that bay 
-- (represented by the field area).  The result set should contain the bay name and the grouped area name for the receivers. Do not duplicate 
-- area names within the grouped list of receivers.
SELECT bayside, GROUP_CONCAT(DISTINCT area) AS receivers FROM receiver INNER JOIN bay
	ON name = bayside GROUP BY bayside;
    
-- 9) Which is the largest shark (by length)? Return the shark’s name in the result.
SELECT name FROM shark
	WHERE length = (SELECT MAX(length) FROM shark);
    
-- 10) How many shark sightings have occurred for the different towns in the database? The result should contain the town name, state, and shark 
-- detections. 
SELECT town, state, SUM(detections) AS shark_sightings FROM township INNER JOIN receiver ON location = tid
	GROUP BY town, state;

-- 11) Which township has had the most shark sightings? The result should contain the town name, state and shark detections. 
SELECT town, state, SUM(detections) AS shark_sightings FROM township INNER JOIN receiver
	ON location = tid GROUP BY town, state ORDER BY SUM(detections) DESC LIMIT 1;

-- 12) Find all sharks that are less than 8 feet. Return all fields from the shark table and order the results by length in ascending order.
SELECT * FROM shark
	WHERE length < 8 
		ORDER BY length ASC; 

-- 13) How many sharks are female? Return a single count. 
SELECT COUNT(DISTINCT sid) AS female_shark_count FROM shark
	WHERE sex = "Female";

-- 14) For each town determine the number of overall shark sightings. The result should contain the town name, the town state and the number 
-- of sightings
SELECT town, state, SUM(detections) AS shark_sightings FROM township LEFT OUTER JOIN receiver
	ON location = tid GROUP BY town, state;
    
-- 15) For each sponsor in the sponsor table, determine the number of receivers they sponsor. The result should contain the sponsor name and 
-- the count. Make sure all sponsors appear in the result. If a sponsor does not appear in the receiver table, then the count for the number of 
-- receivers should be 0. 
SELECT sponsor, COUNT(DISTINCT rid) AS receiver_count FROM receiver RIGHT OUTER JOIN sponsor
	ON sponsor = sponsor_name
		GROUP BY sponsor;
        
-- 16) Determine the total number of shark detections associated with their sponsored receivers. If a receiver is not sponsored the detections 
-- should still be aggregated and assigned to the NULL sponsor. The result should contain the sponsor name and the number of detections.
SELECT sponsor, SUM(detections) AS detections FROM receiver LEFT OUTER JOIN sponsor
	ON sponsor = sponsor_name
		GROUP BY sponsor;
        
-- 17) For each attack, report the shark name, if the attack was fatal, the description of the attack, the date of the attack, the victim’s 
-- activity when attacked, the town where the attacked occurred, the state, the victim’s name, the victim’s age, 
SELECT shark.name, fatal, description, date, activity, town, state, victim.name, age 
	FROM attack LEFT OUTER JOIN shark ON shark = sid INNER JOIN township ON tid = location INNER JOIN victim ON vid = victim;
    
-- 18) Determine the town that first deployed a receiver. The result should contain the town, the state and the date of deployment for the 
-- receiver.
SELECT town, state, deployed FROM receiver INNER JOIN township
	ON location = tid
		ORDER BY deployed ASC
			LIMIT 1;
            
-- 19) How many receivers are deployed for each town? The result should contain the town name, the town state, and the number of receivers 
-- (renamed to num_receivers). All towns in the township table should appear in the result. If a town has no receivers, then the count 
-- num_receivers should be 0. 
SELECT town, state, COUNT(DISTINCT rid) AS num_receivers FROM receiver RIGHT OUTER JOIN township 
	ON tid = location
		GROUP BY town, state;

-- 20) Find the towns that do not have a receiver and not have an attack.  Return the town name and the state. 
SELECT town, state FROM receiver RIGHT OUTER JOIN township  
	ON tid = receiver.location
		LEFT OUTER JOIN attack ON tid = attack.location
			GROUP BY town, state
				HAVING COUNT(rid) = 0 AND COUNT(attack.date) = 0;



 






			
    

