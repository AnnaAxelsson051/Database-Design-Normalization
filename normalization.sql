

/********** UNF **********/

USE iths;

DROP TABLE IF EXISTS UNF;

CREATE TABLE `UNF` (
    `Id` DECIMAL(38, 0) NOT NULL,
    `Name` VARCHAR(26) NOT NULL,
    `Grade` VARCHAR(11) NOT NULL,
    `Hobbies` VARCHAR(25),
    `City` VARCHAR(10) NOT NULL,
    `School` VARCHAR(30) NOT NULL,
    `HomePhone` VARCHAR(15),
    `JobPhone` VARCHAR(15),
    `MobilePhone1` VARCHAR(15),
    `MobilePhone2` VARCHAR(15)
)  ENGINE=INNODB;

LOAD DATA INFILE '/var/lib/mysql-files/denormalized-data.csv'
INTO TABLE UNF
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/********** Student **********/

DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
    StudentId INT NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Grade VARCHAR(255) NOT NULL,
    Hobby VARCHAR(255) NOT NULL,
    CONSTRAINT PRIMARY KEY (StudentId)
)  ENGINE=INNODB;

INSERT INTO Student (StudentID, FirstName, LastName, Grade, Hobby)
SELECT DISTINCT Id, SUBSTRING_INDEX(Name, ' ', 1), SUBSTRING_INDEX(Name, ' ', -1), Grade, Hobbies
FROM UNF;

/********** Phone **********/

DROP TABLE IF EXISTS Phone;
CREATE TABLE Phone (
    PhoneId INT NOT NULL AUTO_INCREMENT,
    StudentId INT NOT NULL,
    Type VARCHAR(32),
    Number VARCHAR(32) NOT NULL,
    CONSTRAINT PRIMARY KEY(PhoneId)
);

INSERT INTO Phone(StudentId, Type, Number)
SELECT ID As StudentId, "Home" AS Type, HomePhone as Number FROM UNF
WHERE HomePhone IS NOT NULL AND HomePhone != ''
UNION SELECT ID As StudentId, "Job" AS Type, JobPhone as Number FROM UNF
WHERE JobPhone IS NOT NULL AND JobPhone != ''
UNION SELECT ID As StudentId, "Mobile" AS Type, MobilePhone1 as Number FROM UNF
WHERE MobilePhone1 IS NOT NULL AND MobilePhone1 != ''
UNION SELECT ID As StudentId, "Mobile" AS Type, MobilePhone2 as Number FROM UNF
WHERE MobilePhone2 IS NOT NULL AND MobilePhone2 != '';

/********** PhoneList **********/

DROP VIEW IF EXISTS PhoneList;

CREATE VIEW PhoneList AS SELECT StudentId, group_concat(Number) AS Numbers FROM Phone GROUP BY StudentId;

SELECT FirstName, LastName, Numbers from Student JOIN PhoneList USING (StudentId);

/********** School **********/

DROP TABLE IF EXISTS School;
CREATE TABLE School AS SELECT DISTINCT 0 As SchoolId, School As SchoolName, City FROM UNF;

SET @id = 0;
UPDATE School SET SchoolId =  (SELECT @id := @id + 1);

ALTER TABLE School ADD PRIMARY KEY(SchoolId);

/********** StudentSchool **********/

DROP TABLE IF EXISTS StudentSchool;
CREATE TABLE StudentSchool AS SELECT DISTINCT UNF.Id AS StudentId, School.SchoolId
FROM UNF INNER JOIN School ON UNF.School = School.SchoolName;
ALTER TABLE StudentSchool MODIFY COLUMN StudentId INT;
ALTER TABLE StudentSchool MODIFY COLUMN SchoolId INT;
ALTER TABLE StudentSchool ADD PRIMARY KEY(StudentId, SchoolId);

SELECT StudentId, FirstName, LastName, SchoolName, City FROM Student
JOIN StudentSchool USING (StudentId)
JOIN School USING (SchoolId);

/********** StudentNameSchool **********/

DROP TABLE IF EXISTS StudentNameSchool;

CREATE TABLE StudentNameSchool AS SELECT DISTINCT 0 As SchoolId, School As School, group_concat(Name) AS Name FROM UNF GROUP BY School;

SET @id = 0;

UPDATE StudentNameSchool SET SchoolId =  (SELECT @id := @id + 1);


ALTER TABLE StudentNameSchool ADD PRIMARY KEY(SchoolId);

/********** HobbiesTemp **********/

DROP VIEW IF EXISTS HobbiesTemp;
CREATE VIEW HobbiesTemp AS SELECT Id as StudentId, trim(SUBSTRING_INDEX(Hobbies, ",", 1)) AS Hobby FROM UNF UNION SELECT Id as StudentId, trim(substring_index(substring_index(Hobbies, ",", -2),"," ,1)) AS Hobby FROM UNF UNION SELECT Id as StudentId, trim(substring_index(Hobbies, ",", -1)) AS Hobby FROM UNF ORDER BY StudentId;

/********** Hobby **********/ 

DROP TABLE IF EXISTS Hobby;
CREATE TABLE Hobby (
    HobbyId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(26) NOT NULL,
    CONSTRAINT PRIMARY KEY(HobbyId)
)  ENGINE=INNODB;

INSERT INTO Hobby(Name) SELECT DISTINCT Hobby from HobbiesTemp;
