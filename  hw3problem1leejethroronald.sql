-- ********************************************
-- CREATE THE PERFECTPETS DATABASE
-- *******************************************

-- create database
DROP DATABASE IF EXISTS perfect_pets;
CREATE DATABASE perfect_pets;

-- select database
USE perfect_pets;

-- create tables
CREATE TABLE clinic
(
  clinic_no			INT			AUTO_INCREMENT,					
  clinic_name		VARCHAR(50)	NOT NULL UNIQUE,
  CONSTRAINT clinic_pk 
    PRIMARY KEY (clinic_no)
);

CREATE TABLE staff
(
  staff_no       	INT				AUTO_INCREMENT,			
  staff_name     	VARCHAR(50)		NOT NULL UNIQUE,
  staff_position	VARCHAR(50)		NOT NULL,
  staff_tasks		VARCHAR(650)	NOT NULL UNIQUE,
  clinic_no      	INT				NOT NULL,    		
  CONSTRAINT staff_pk 
    PRIMARY KEY (staff_no),
  CONSTRAINT staff_fk_clinic
    FOREIGN KEY (clinic_no) REFERENCES clinic (clinic_no) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE manager
(
manager_salary		INT					NOT NULL,
manager_no			INT					PRIMARY KEY,					
clinic_no			INT					NOT NULL UNIQUE,			
CONSTRAINT manager_fk_staff
	FOREIGN KEY (manager_no) REFERENCES staff (staff_no) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
CONSTRAINT manager_fk_clinic
	FOREIGN KEY (clinic_no) REFERENCES clinic (clinic_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE treatment
(
  treat_no			INT			AUTO_INCREMENT,			
  treat_name       	VARCHAR(50) NOT NULL UNIQUE,
  CONSTRAINT treatment_pk
    PRIMARY KEY (treat_no)
);

CREATE TABLE owner
(
  owner_no			INT			AUTO_INCREMENT,			
  owner_name		VARCHAR(50)	NOT NULL,
  CONSTRAINT owner_pk
	PRIMARY KEY (owner_no)
);

CREATE TABLE pet
(
  pet_no		INT			AUTO_INCREMENT,			
  pet_name		VARCHAR(50)	NOT NULL,
  owner_no		INT			NOT NULL,
  clinic_no		INT			NOT NULL,
  CONSTRAINT pet_pk
	PRIMARY KEY (pet_no),
  CONSTRAINT pet_fk_owner
	FOREIGN KEY (owner_no) REFERENCES owner (owner_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT pet_fk_clinic
	FOREIGN KEY (clinic_no) REFERENCES clinic (clinic_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE examination
(
  exam_no       INT			  AUTO_INCREMENT,		
  exam_date     DATE          NOT NULL,
  pet_no		INT			  NOT NULL,
  treat_no	    INT,		
  examiner_no	INT			  NOT NULL,
  CONSTRAINT examination_pk 
    PRIMARY KEY (exam_no),
  CONSTRAINT examination_fk_pet
    FOREIGN KEY (pet_no) REFERENCES pet (pet_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT examination_fk_treatment
	FOREIGN KEY (treat_no) REFERENCES treatment (treat_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT examination_fk_staff
	FOREIGN KEY (examiner_no) REFERENCES staff (staff_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE prescribed_after
(
  treat_no			INT,			
  exam_no			INT,			
  CONSTRAINT prescribed_after_pk
	PRIMARY KEY (treat_no, exam_no),
  CONSTRAINT prescribed_after_fk_treatment
	FOREIGN KEY (treat_no) REFERENCES treatment (treat_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT prescribed_after_fk_examination
	FOREIGN KEY (exam_no) REFERENCES examination (exam_no)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
