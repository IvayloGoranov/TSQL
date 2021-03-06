
/*Create two tables. Insert data.
Alter table customers and make PersonID a primary key. 
Create a foreign key between Persons and Passports by using PassportID column.
*/

CREATE DATABASE TableRelationsExercise 
GO

USE TableRelationsExercise
GO 

CREATE TABLE Persons (
  PersonID int IDENTITY,
  FirstName nvarchar(100) NOT NULL,
  Salary money NOT NULL,
  PassportID int NOT NULL,
  CONSTRAINT PK_Persons PRIMARY KEY(PersonID)
)

CREATE TABLE Passports (
  PassportID int IDENTITY (101, 1),
  PassportNumber nvarchar(50) NOT NULL,
  CONSTRAINT PK_Passports PRIMARY KEY(PassportID)
)

ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports
    FOREIGN KEY (PassportID)
    REFERENCES Passports(PassportID)

INSERT INTO Passports(PassportNumber)
VALUES ('N34FG21B')

INSERT INTO Passports(PassportNumber)
VALUES ('K65LO4R7')

INSERT INTO Passports(PassportNumber)
VALUES ('ZE657QP2')

INSERT INTO Persons(FirstName, Salary, PassportID)
VALUES ('Roberto', 43300, 102)

INSERT INTO Persons(FirstName, Salary, PassportID)
VALUES ('Tom', 56100, 103)

INSERT INTO Persons(FirstName, Salary, PassportID)
VALUES ('Yana', 60200, 101)

---------------------------------------------------------------------
CREATE TABLE Students (
  StudentID int IDENTITY,
  Name nvarchar(200) NOT NULL,
  CONSTRAINT PK_Students PRIMARY KEY(StudentID)
)

CREATE TABLE StudentsExams (
  StudentID int,
  ExamID int,
  CONSTRAINT PK_StudentsEaxms PRIMARY KEY(StudentID, ExamID)
)

CREATE TABLE Exams (
  ExamID int IDENTITY (101, 1),
  Name nvarchar(200) NOT NULL,
  CONSTRAINT PK_Exams PRIMARY KEY(ExamID)
)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentsExams_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentsExams_Exams
    FOREIGN KEY (ExamID)
    REFERENCES Exams(ExamID)

INSERT INTO Students(Name)
VALUES ('Mila')

INSERT INTO Students(Name)
VALUES ('Toni')

INSERT INTO Students(Name)
VALUES ('Ron')

INSERT INTO Exams(Name)
VALUES ('Spring MVC')

INSERT INTO Exams(Name)
VALUES ('Neo4j')

INSERT INTO Exams(Name)
VALUES ('Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (1, 101)

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (1, 102)

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (2, 101)

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (3, 103)

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (2, 102)

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (2, 103)

---------------------------------------------------------------------

CREATE TABLE Teachers (
  TeacherID int IDENTITY (101, 1),
  Name nvarchar(200) NOT NULL,
  ManagerID int
  CONSTRAINT PK_Teachers PRIMARY KEY(TeacherID)
)

ALTER TABLE Teachers
ADD CONSTRAINT FK_Teachers_Teachers
    FOREIGN KEY (ManagerID)
    REFERENCES Teachers(TeacherID)

INSERT INTO Teachers(Name)
VALUES ('John')

INSERT INTO Teachers(Name)
VALUES ('Maya')

INSERT INTO Teachers(Name)
VALUES ('Silvia')

INSERT INTO Teachers(Name)
VALUES ('Ted')

INSERT INTO Teachers(Name)
VALUES ('Mark')

INSERT INTO Teachers(Name)
VALUES ('Greta')

UPDATE Teachers
SET ManagerID = 106
WHERE TeacherID = 102

UPDATE Teachers
SET ManagerID = 106
WHERE TeacherID = 103

UPDATE Teachers
SET ManagerID = 105
WHERE TeacherID = 104

UPDATE Teachers
SET ManagerID = 101
WHERE TeacherID = 105

UPDATE Teachers
SET ManagerID = 101
WHERE TeacherID = 106

---------------------------------------------------------------------
/*Filter the count of the mountain ranges in the USA, Russia and Bulgaria*/

USE Geography
GO

SELECT c.CountryCode, COUNT(*) AS [MountainRanges]
FROM Countries c
INNER JOIN MountainsCountries mc
ON c.CountryCode = mc.CountryCode
INNER JOIN Mountains m
ON mc.MountainId = m.Id
WHERE c.CountryName IN ('Russia', 'United States', 'Bulgaria')
GROUP BY c.CountryCode 

---------------------------------------------------------------------
/*Find the first 5 countries with or without rivers in Africa*/

SELECT TOP 5 c.CountryName, r.RiverName
FROM Countries c
INNER JOIN Continents con
ON c.ContinentCode = con.ContinentCode
LEFT OUTER JOIN CountriesRivers cr
ON c.CountryCode = cr.CountryCode
LEFT OUTER JOIN Rivers r
ON cr.RiverId = r.Id
WHERE con.ContinentName = 'Africa'
ORDER BY c.CountryName

---------------------------------------------------------------------
/*Filter all the projects of employee with id 24. 
If the project has started before 2005 the return value should be NULL
*/

SELECT e.EmployeeId, e.FirstName, 
	   p.Name
FROM Employees AS e
INNER JOIN EmployeesProjects AS ep
ON e.EmployeeId = ep.EmployeeId
LEFT JOIN Projects AS p
ON ep.ProjectId = p.ProjectId
AND YEAR(p.StartDate) < 2005
WHERE e.EmployeeId = 24

---------------------------------------------------------------------

/*For each country, find the name and elevation of the highest peak, 
along with its mountain. When no peaks are available in some country, 
display elevation 0, "(no highest peak)" as peak name and "(no mountain)" 
as mountain name. When multiple peaks in some country have the same elevation, 
display all of them. Sort the results by country name alphabetically, 
then by highest peak name alphabetically. 
Submit for evaluation the result grid with headers. Limit only the first 5 rows
*/

SELECT TOP 5 * FROM(
SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange 
 FROM [dbo].[Countries] AS c
INNER JOIN [dbo].[MountainsCountries] AS mc
   ON c.CountryCode = mc.CountryCode
INNER JOIN [dbo].[Mountains] AS m
   ON mc.MountainId = m.Id
INNER JOIN [dbo].[Peaks] AS p
   ON p.MountainId = m.Id
INNER JOIN (
SELECT c.CountryName, MAX(p.Elevation) AS MaxElevation
 FROM [dbo].[Countries] AS c
INNER JOIN [dbo].[MountainsCountries] AS mc
   ON c.CountryCode = mc.CountryCode
INNER JOIN [dbo].[Mountains] AS m
   ON mc.MountainId = m.Id
INNER JOIN [dbo].[Peaks] AS p
   ON p.MountainId = m.Id
GROUP BY c.CountryName
) AS max_elevation
 ON max_elevation.MaxElevation = p.Elevation
AND max_elevation.CountryName = c.CountryName
UNION ALL
SELECT c.CountryName, '(no highest peak)' AS PeakName,
       0 AS Elevation, '(no mountain)' AS MountainRange
 FROM [dbo].[Countries] AS c
 LEFT JOIN [dbo].[MountainsCountries] AS mc
    ON c.CountryCode = mc.CountryCode
 WHERE mc.MountainId  IS NULL
 ) AS results
 ORDER BY CountryName, PeakName