-- To enable the insertion of "invalid" dates, both this script and the INSERT
-- script must be run together (see SET SESSION below).
--
-- $ cat database-create.sql database-insert.sql | mysql

DROP DATABASE nobel;

CREATE DATABASE nobel;

USE nobel;

SET SESSION sql_mode = 'ALLOW_INVALID_DATES';

CREATE TABLE country (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  country           VARCHAR(256)
);

CREATE TABLE location (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  city              VARCHAR(256),
  country_id        INT,
  FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE laureate (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name              VARCHAR(256),
  sex               CHAR(1),
  birth_date        DATE,
  death_date        DATE,
  birth_location_id INT,
  death_location_id INT,
  FOREIGN KEY (birth_location_id) REFERENCES location(id),
  FOREIGN KEY (death_location_id) REFERENCES location(id)
);

CREATE TABLE organisation (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name              VARCHAR(256),
  location_id       INT,
  FOREIGN KEY (location_id) REFERENCES location(id)
);

CREATE TABLE prize (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  year              INT,
  category          VARCHAR(256),
  type              VARCHAR(256),
  share             VARCHAR(256),
  laureate_id       INT,
  organisation_id   INT,
  FOREIGN KEY (laureate_id) REFERENCES laureate(id),
  FOREIGN KEY (organisation_id) REFERENCES organisation(id)
);
