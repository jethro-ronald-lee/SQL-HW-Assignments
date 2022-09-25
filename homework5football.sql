DROP DATABASE IF EXISTS premierleej;
CREATE DATABASE IF NOT EXISTS premierleej;
USE premierleej;

DROP TABLE IF EXISTS stadium;
CREATE TABLE stadium (
  team VARCHAR(50) NOT NULL UNIQUE,
  venue VARCHAR(50) NOT NULL,
  PRIMARY KEY (team)
);

DROP TABLE IF EXISTS manager;
CREATE TABLE manager (
  manager VARCHAR(50),
  team VARCHAR(50) NOT NULL,
  nationality VARCHAR(50) NOT NULL,
  status ENUM('Active','Sacked') NOT NULL,
  PRIMARY KEY (manager, team),
  FOREIGN KEY (team) REFERENCES stadium (team) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS soccer_match;
CREATE TABLE soccer_match (
  match_num INT NOT NULL,
  match_day INT NOT NULL,
  date date NOT NULL,
  team_1 VARCHAR(50) NOT NULL,
  team_2 VARCHAR(50) NOT NULL,
  half_time_score_team_1 INT NOT NULL,
  half_time_score_team_2 INT NOT NULL,
  full_time_score_team_1 INT NOT NULL,
  full_time_score_team_2 INT NOT NULL,
  PRIMARY KEY (match_num),
  FOREIGN KEY (team_1) REFERENCES stadium (team) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (team_2) REFERENCES stadium (team) ON DELETE CASCADE ON UPDATE CASCADE
);