SET ECHO ON;

DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Rental CASCADE CONSTRAINTS;
DROP TABLE PropertyForRent CASCADE CONSTRAINTS;
DROP TABLE Owner CASCADE CONSTRAINTS;

REM 1NF

CREATE TABLE ClientRental(
clientNo VARCHAR(10),
propertyNo VARCHAR(10),
cName VARCHAR(20),
pAddress VARCHAR(100),
rentStart VARCHAR(10),
rentFinish VARCHAR(10),
rent INT,
ownerNo VARCHAR(10),
oName VARCHAR(20),
PRIMARY KEY(clientNo, propertyNo)
);

INSERT INTO Clientrental (clientNo, propertyNo, cName, pAddress, rentStart, rentFinish, rent, ownerNo, oName)
VALUES ('CR76', 'PG4', 'John Kay', '6 Lawrence St, Glasgow', '2003-07-01', '2004-08-31', 350, 'CO40', 'Tina Murphy');

INSERT INTO clientrental (clientNo, propertyNo, cName, pAddress, rentStart, rentFinish, rent, ownerNo, oName)
VALUES ('CR76', 'PG16', 'John Kay', '5 Novar Dr., Glasgow', '2004-09-01', '2005-09-01', 450, 'CO93', 'Tony Shaw');

INSERT INTO clientrental (clientNo, propertyNo, cName, pAddress, rentStart, rentFinish, rent, ownerNo, oName)
VALUES ('CR56', 'PG4', 'Aline Stewart', '6 Lawrence St, Glasgow', '2002-09-01', '2003-06-10', 350, 'CO40', 'Tina Murphy');

INSERT INTO clientrental (clientNo, propertyNo, cName, pAddress, rentStart, rentFinish, rent, ownerNo, oName)
VALUES ('CR56', 'PG36', 'Aline Stewart', '2 Manor Rd, Glasgow', '2003-10-10', '2004-12-01', 375, 'CO93', 'Tony Shaw');

INSERT INTO clientrental (clientNo, propertyNo, cName, pAddress, rentStart, rentFinish, rent, ownerNo, oName)
VALUES ('CR56', 'PG16', 'Aline Stewart', '5 Novar Dr, Glasgow', '2005-11-01', '2006-08-10', 450, 'CO93', 'Tony Shaw');

SELECT * FROM ClientRental;

REM 2NF

DROP TABLE ClientRental CASCADE CONSTRAINTS;

CREATE TABLE Client(
clientNo VARCHAR(10) PRIMARY KEY,
cName VARCHAR(20)
);

CREATE TABLE PropertyOwner(
propertyNo VARCHAR(10) PRIMARY KEY,
pAddress VARCHAR(100),
rent INT,
ownerNo VARCHAR(10),
oName VARCHAR(20)
);


CREATE TABLE Rental(
clientNo VARCHAR(10),
propertyNo VARCHAR(10),
rentStart VARCHAR(10),
rentFinish VARCHAR(10),
PRIMARY KEY(clientNo, propertyNo),
FOREIGN KEY(clientNo) REFERENCES Client(clientNo),
FOREIGN KEY(propertyNo) REFERENCES PropertyOwner(propertyNo)
);

INSERT INTO client (clientNo, cName)
VALUES ('CR76', 'John Kay');

INSERT INTO client (clientNo, cName)
VALUES ('CR56', 'Aline Stewart');

INSERT INTO propertyowner (propertyNo, pAddress, rent, ownerNo, oName)
VALUES ('PG4', '6 Lawrence St, Glasgow', 350, 'CO40', 'Tina Murphy');

INSERT INTO propertyowner (propertyNo, pAddress, rent, ownerNo, oName)
VALUES ('PG16', '5 Novar Dr, Glasgow', 450, 'CO93', 'Tony Shaw');

INSERT INTO propertyowner (propertyNo, pAddress, rent, ownerNo, oName)
VALUES ('PG36', '2 Manor Rd, Glasgow', 375, 'CO93', 'Tony Shaw');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR76', 'PG4', '2003-07-01', '2004-08-31');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR76', 'PG16', '2004-09-01', '2005-09-01');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR56', 'PG4', '2002-09-01', '2003-06-10');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR56', 'PG36', '2003-10-10', '2004-12-01');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR56', 'PG16', '2005-11-01', '2006-08-10');

SELECT * FROM Client;
SELECT * FROM PropertyOwner;
SELECT * FROM Rental;

REM 3NF

DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE PropertyOwner CASCADE CONSTRAINTS;
DROP TABLE Rental CASCADE CONSTRAINTS;

CREATE TABLE Client(
clientNo VARCHAR(10) PRIMARY KEY,
cName VARCHAR(20)
);

CREATE TABLE Owner(
ownerNo VARCHAR(10) PRIMARY KEY,
oName VARCHAR(20)
);

CREATE TABLE PropertyForRent(
propertyNo VARCHAR(10) PRIMARY KEY,
pAddress VARCHAR(100),
rent INT,
ownerNo VARCHAR(10),
FOREIGN KEY(ownerNo) REFERENCES Owner(ownerNo)
);

CREATE TABLE Rental(
clientNo VARCHAR(10),
propertyNo VARCHAR(10),
rentStart VARCHAR(10),
rentFinish VARCHAR(10),
PRIMARY KEY(clientNo, propertyNo),
FOREIGN KEY(clientNo) REFERENCES Client(clientNo),
FOREIGN KEY(propertyNo) REFERENCES PropertyForRent(propertyNo)
);

INSERT INTO client (clientNo, cName)
VALUES ('CR76', 'John Kay');

INSERT INTO client (clientNo, cName)
VALUES ('CR56', 'Aline Stewart');

INSERT INTO owner (ownerNo, oName)
VALUES ('CO40', 'Tina Murphy');

INSERT INTO owner (ownerNo, oName)
VALUES ('CO93', 'Tony Shaw');

INSERT INTO propertyforrent (propertyNo, pAddress, rent, ownerNo)
VALUES ('PG4', '6 Lawrence St, Glasgow', 350, 'CO40');

INSERT INTO propertyforrent (propertyNo, pAddress, rent, ownerNo)
VALUES ('PG16', '5 Novar Dr, Glasgow', 450, 'CO93');

INSERT INTO propertyforrent (propertyNo, pAddress, rent, ownerNo)
VALUES ('PG36', '2 Manor Rd, Glasgow', 375, 'CO93');


INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR76', 'PG4', '2003-07-01', '2004-08-31');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR76', 'PG16', '2004-09-01', '2005-09-01');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR56', 'PG4', '2002-09-01', '2003-06-10');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR56', 'PG36', '2003-10-10', '2004-12-01');

INSERT INTO rental (clientNo, propertyNo, rentStart, rentFinish)
VALUES ('CR56', 'PG16', '2005-11-01', '2006-08-10');

SELECT * FROM Client;
SELECT * FROM Owner;
SELECT * FROM PropertyForRent;
SELECT * FROM Rental;
