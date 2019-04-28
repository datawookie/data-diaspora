DROP DATABASE pets;

CREATE DATABASE pets;

USE pets;

CREATE TABLE pet_owner (
    owner           VARCHAR(64),
    address         VARCHAR(256),
    pet             VARCHAR(64),
    animal          VARCHAR(32),
    sex             CHAR(1),
    birth           DATE
);
INSERT INTO pet_owner VALUES
('Bob', '12 St Charles Steet, Springfield', 'Fido', 'cat', 'M', '2017-06-03'),
('Bob', '12 St Charles Steet, Springfield', 'Neon', 'dog', 'F', '2016-09-17'),
('Alice', '23 Burleigh Bend, Elmore', 'Coco', 'cat', 'F', '2016-11-02'),
('Alice', '23 Burleigh Bend, Elmore', 'Molly', 'cat', 'F', '2012-03-27'),
('Alice', '23 Burleigh Bend, Elmore', 'Lulu', 'fish', 'F', '2014-07-19'),
('Craig', '72 Ferngrove Lane, Riverdale', 'Jack', 'bird', 'M', '2016-09-12'),
('Wendy', '12 St Charles Steet, Springfield', 'Darcy', 'dog', 'M', '2015-02-10'),
('Wendy', '12 St Charles Steet, Springfield', 'Bella', 'cat', 'F', '2013-04-11');

CREATE TABLE address (
    id              INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    number          INT,
    street          VARCHAR(128),
    town            VARCHAR(128)
);
INSERT INTO address VALUES
(1, 12, 'St Charles Steet', 'Springfield'),
(2, 23, 'Burleigh Bend', 'Elmore'),
(3, 72, 'Ferngrove Lane', 'Riverdale');
CREATE TABLE owner (
    id              INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(64)
);
INSERT INTO owner VALUES
(1, 'Bob'),
(2, 'Alice'),
(3, 'Craig'),
(4, 'Wendy'),
(5, 'Grace');
CREATE TABLE owner_address (
    owner_id        INT,
    address_id      INT,
    FOREIGN KEY (owner_id) REFERENCES owner(id),
    FOREIGN KEY (address_id) REFERENCES address(id)
);
INSERT INTO owner_address VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1);
CREATE TABLE animal (
    id              INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    animal          VARCHAR(32)
);
INSERT INTO animal VALUES
(1, 'cat'),
(2, 'dog'),
(3, 'fish'),
(4, 'bird');

CREATE TABLE pet (
    id              INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(64),
    owner_id        INT,
    animal_id         INT NOT NULL,
    sex             CHAR(1),
    birth           DATE,
    FOREIGN KEY (owner_id) REFERENCES owner(id),
    FOREIGN KEY (animal_id) REFERENCES animal(id)
);
INSERT INTO pet VALUES
(1, 'Fido', 1, 1, 'M', '2017-06-03'),
(2, 'Neon', 1, 2, 'F', '2016-09-17'),
(3, 'Coco', 2, 1, 'F', '2016-11-02'),
(4, 'Molly', 2, 1, 'F', '2012-03-27'),
(5, 'Lulu', 2, 3, 'F', '2014-07-19'),
(6, 'Jack', 3, 4, 'M', '2016-09-12'),
(7, 'Darcy', 4, 2, 'M', '2015-02-10'),
(8, 'Bella', 4, 1, 'F', '2013-04-11');
