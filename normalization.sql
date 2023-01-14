

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
