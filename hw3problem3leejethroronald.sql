-- ********************************************
-- CREATE THE BUSYBEE DATABASE
-- *******************************************

-- create database
DROP DATABASE IF EXISTS busy_bee;
CREATE DATABASE busy_bee;

-- select database
USE busy_bee;

-- create tables
CREATE TABLE client
(
  client_no			INT         AUTO_INCREMENT,			
  client_name		VARCHAR(50) NOT NULL,
  CONSTRAINT client_pk
	PRIMARY KEY (client_no)
);

CREATE TABLE administrative
(
  admin_salary		INT				NOT NULL,
  staff_no			INT				PRIMARY KEY,
  admin_daily_tasks	VARCHAR(650)	NOT NULL UNIQUE
);

CREATE TABLE cleaning_squad
(
  squad_no			INT					AUTO_INCREMENT,		
  supervisor_name	VARCHAR(50)			NOT NULL,
  CONSTRAINT cleaning_squad_pk
	PRIMARY KEY (squad_no)
);

CREATE TABLE cleaning_job
(
  job_no			    	INT				AUTO_INCREMENT,			 
  start_time	    		TIME	    	NOT NULL,
  end_time					TIME			NOT NULL,
  cleaning_requirements		TEXT			NOT NULL,
  cleaning_dates			VARCHAR(350)	NOT NULL,
  client_no					INT				NOT NULL,
  admin_no					INT				NOT NULL,
  squad_no					INT				NOT NULL,
  cleaning_hours_required	INT				NOT NULL,
  CONSTRAINT cleaning_job_pk
	PRIMARY KEY (job_no),
  CONSTRAINT cleaning_job_fk_client
	FOREIGN KEY (client_no) REFERENCES client (client_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT cleaning_job_fk_administrative
    FOREIGN KEY (admin_no) REFERENCES administrative (staff_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT cleaning_job_fk_cleaning_squad
    FOREIGN KEY (squad_no) REFERENCES cleaning_squad (squad_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE cleaning_equipment
(
  equipment_id		INT			AUTO_INCREMENT,	
  CONSTRAINT cleaning_equipment_pk
	PRIMARY KEY (equipment_id)
);

CREATE TABLE special_equip
(
  special_equip_name	VARCHAR(50)			NOT NULL,
  equipment_id			INT					PRIMARY KEY,
  CONSTRAINT special_equip_fk_cleaning_equipment
	FOREIGN KEY (equipment_id) REFERENCES cleaning_equipment (equipment_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE needed_for
(
  job_no			INT,		
  equipment_id		INT,		
  CONSTRAINT needed_for_pk
	PRIMARY KEY (job_no, equipment_id),
  CONSTRAINT needed_for_fk_cleaning_job
	FOREIGN KEY (job_no) REFERENCES cleaning_job (job_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT needed_for_fk_equipment
	FOREIGN KEY (equipment_id) REFERENCES cleaning_equipment (equipment_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
  
CREATE TABLE cleaning
(
  cleaner_salary			INT					NOT NULL,
  staff_no					INT					PRIMARY KEY,
  cleaner_daily_tasks		VARCHAR(650)		NOT NULL UNIQUE
);

CREATE TABLE works_in
(
  cleaner_no			INT					NOT NULL,
  squad_no				INT					NOT NULL,
  CONSTRAINT works_in_pk
    PRIMARY KEY (cleaner_no, squad_no),
  CONSTRAINT works_in_fk_cleaning
    FOREIGN KEY (cleaner_no) REFERENCES cleaning (staff_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT works_in_fk_cleaningSquad
    FOREIGN KEY (squad_no) REFERENCES cleaning_squad (squad_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);