-- ********************************************
-- CREATE THE SCHOOLS DATABASE
-- *******************************************

-- create database
DROP DATABASE IF EXISTS schools;
CREATE DATABASE schools;

-- select database
USE schools;

-- create tables
CREATE TABLE school
(
  school_id			INT			AUTO_INCREMENT,			
  school_name		VARCHAR(50)	NOT NULL UNIQUE,
  town				VARCHAR(50)	NOT NULL,
  street			VARCHAR(50)	NOT NULL,
  zip_code			CHAR(5)		NOT NULL,
  phone				INT			NOT NULL UNIQUE,
  CONSTRAINT school_pk
	PRIMARY KEY (school_id)
);

CREATE TABLE teacher
(
	nin				INT,				
    teacher_f_name	VARCHAR(50)		NOT NULL,
    teacher_l_name	VARCHAR(50)		NOT NULL,
    teacher_sex		VARCHAR(20),    
    qualifications	VARCHAR(650)	NOT NULL UNIQUE,
    school_id		INT				NOT NULL,
    CONSTRAINT teacher_pk
		PRIMARY KEY (nin),
	CONSTRAINT teacher_fk_school
		FOREIGN KEY (school_id) REFERENCES school (school_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE manager
(
  management_start_date			DATE		NOT NULL,
  manager_nin					INT			PRIMARY KEY,
  school_id						INT			NOT NULL UNIQUE,
  CONSTRAINT manager_fk_teacher
	FOREIGN KEY (manager_nin) REFERENCES teacher (nin)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT manager_fk_school
	FOREIGN KEY (school_id) REFERENCES school (school_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE subject
(
  subject_title			VARCHAR(50),			
  subject_type			VARCHAR(50)			NOT NULL,
  CONSTRAINT subject_pk
	PRIMARY KEY (subject_title)
  );
  
CREATE TABLE pupil
(
  pupil_id			INT			AUTO_INCREMENT,			
  pupil_f_name		VARCHAR(50)	NOT NULL,
  pupil_l_name		VARCHAR(50)	NOT NULL,
  pupil_sex			VARCHAR(20),
  date_of_birth		DATE		NOT NULL,
  school_id			INT			NOT NULL,
  CONSTRAINT pupil_pk
	PRIMARY KEY (pupil_id),
  CONSTRAINT  pupil_fk_school
	FOREIGN KEY (school_id) REFERENCES school (school_id)
      ON DELETE CASCADE
	  ON UPDATE CASCADE
);

CREATE TABLE teaches
(
  teacher_nin	INT			NOT NULL,
  subject_title	VARCHAR(50)	NOT NULL,
  hours_spent	INT			NOT NULL,
  CONSTRAINT teaches_pk
	PRIMARY KEY (teacher_nin, subject_title),
  CONSTRAINT teaches_fk_teacher
	FOREIGN KEY (teacher_nin) REFERENCES teacher (nin)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT teaches_fk_subject
	FOREIGN KEY (subject_title) REFERENCES subject (subject_title)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);
    
CREATE TABLE studies
(
  pupil_id			INT			NOT NULL,
  subject_title		VARCHAR(50)	NOT NULL,
  CONSTRAINT studies_pk
	PRIMARY KEY (pupil_id, subject_title),
  CONSTRAINT studies_fk_pupil
	FOREIGN KEY (pupil_id) REFERENCES pupil (pupil_id)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT studies_fk_subject
	FOREIGN KEY (subject_title) REFERENCES subject (subject_title)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

