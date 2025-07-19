SET ECHO ON

REM Classes Relation
REM ****************

REM Dropping Classes Relation
REM *********************

DROP TABLE Classes CASCADE CONSTRAINTS;

REM Creating Classes Relation
REM *************************

CREATE TABLE Classes(
Class VARCHAR(50) PRIMARY KEY,
Type CHAR(2),
Country VARCHAR(50),
NumGuns INT,
Bore INT,
Displacement INT
);

REM 1. Populate the relation using INSERT clause.
REM *********************************************

INSERT INTO Classes 
VALUES ('Bismark', 'bb', 'Germany', 8, 14, 32000);

INSERT INTO Classes
VALUES ('Iowa', 'bb', 'USA', 9, 16, 46000);

INSERT INTO Classes
VALUES ('Kongo', 'bc', 'Japan', 8, 15, 42000);

INSERT INTO Classes
VALUES ('North Carolina', 'bb', 'USA', 9, 16, 37000);

INSERT INTO Classes
VALUES ('Revenge', 'bb', 'Gt. Britain', 8, 15, 29000);

INSERT INTO Classes
VALUES ('Renown', 'bc', 'Gt. Britain', 6, 15, 32000);

REM 2. Display the populated relation.
REM **********************************

SELECT * FROM Classes;

REM 3. Mark an intermediate point in this transaction.
REM **************************************************

COMMIT;
SAVEPOINT after_insert;

REM 4. For the battleships having at least 9 number of guns or the ships with at least 15 inch bore, increase the displacement by 10%.
REM **********************************************************************************************************************************

UPDATE Classes SET Displacement = (Displacement * 0.10) WHERE ((NumGuns >= 9 AND Type = 'bb' ) OR (BORE >= 15));

REM 5. Delete Kongo class of ship from Classes table.
REM *************************************************

DELETE FROM Classes WHERE Class = 'Kongo';

REM 6. Display your changes to the table
REM ************************************

SELECT * FROM Classes;

REM 7. Discard the recent updates to the relation without discarding the earlier INSERT operation(s).
REM *************************************************************************************************

ROLLBACK TO SAVEPOINT after_insert;

REM 8. Commit the changes.
REM **********************

COMMIT;
