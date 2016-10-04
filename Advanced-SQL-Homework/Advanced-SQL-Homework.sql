/*Write a SQL query to find the names and salaries of 
the employees that take the minimal salary in the company.*/

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary = 
  (SELECT MIN(Salary) FROM Employees)
---------------------------------------------------------------------
/*Write a SQL query to find the names and salaries of the employees that 
have a salary that is up to 10% higher than the minimal salary for the company.*/

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary >= (SELECT MIN(Salary) FROM Employees)
	  AND
      Salary <= (SELECT MIN(Salary) * 1.1 FROM Employees)
ORDER BY Salary DESC
---------------------------------------------------------------------
/*Write a SQL query to find the full name, salary and department of 
the employees that take the minimal salary in their department.*/

SELECT e.FirstName, e.LastName, e.Salary, d.Name
FROM Employees e 
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = 
	(SELECT MIN(Salary) FROM Employees 
    WHERE DepartmentID = d.DepartmentID)
---------------------------------------------------------------------
/*Write a SQL query to find the average salary in the department #1*/

SELECT FirstName
FROM Employees
WHERE Salary = 
	(SELECT AVG(Salary)
	FROM Employees
	WHERE DepartmentID = 1)
---------------------------------------------------------------------
/*Write a SQL query to find the average salary in the "Sales" department.*/

SELECT AVG(Salary) AS [Sales Department AVG Salary]
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
---------------------------------------------------------------------
/*Write a SQL query to find the number of employees in the "Sales" department.*/

SELECT Count(*) AS [Sales Department Employees Count]
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
---------------------------------------------------------------------
/*Write a SQL query to find the number of all employees that have manager.*/

SELECT Count(*) AS [Employees Count With Manager]
FROM Employees e
WHERE e.ManagerID IS NOT NULL
---------------------------------------------------------------------
/*Write a SQL query to find the number of all employees that have no manager.*/

SELECT Count(*) AS [Employees Count Without Manager]
FROM Employees e
WHERE e.ManagerID IS NULL
---------------------------------------------------------------------
/*Write a SQL query to find all departments and the average salary for each of them.*/

SELECT d.Name AS [Department Name], AVG(Salary) AS [AVG Salary]
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
---------------------------------------------------------------------
/*Write a SQL query to find the count of all employees 
in each department and for each town*/

SELECT t.Name AS [Town Name], d.Name AS [Department Name], Count(*) AS [Employees Count]
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
INNER JOIN Addresses a
ON e.AddressID = a.AddressID
INNER JOIN Towns t
ON a.TownID = t.TownID
GROUP BY t.Name, d.Name
---------------------------------------------------------------------
/*Write a SQL query to find all managers that have exactly 5 employees.*/

SELECT m.FirstName, m.LastName, COUNT(*) AS [Employees Count]
FROM Employees e
INNER JOIN Employees m
ON e.ManagerID = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(*) = 5
---------------------------------------------------------------------
/*Write a SQL query to find all employees along with their managers.*/

SELECT e.FirstName, 
       e.LastName, 
	   ISNULL(m.FirstName + ' ' + m.LastName, 'No Manager') AS [Manager]
FROM Employees e
LEFt OUTER JOIN Employees m
ON e.ManagerID = m.EmployeeID
---------------------------------------------------------------------
/*Write a SQL query to find the names of all employees 
whose last name is exactly 5 characters long*/

SELECT FirstName, 
       LastName
FROM Employees
WHERE LEN(LastName) = 5
---------------------------------------------------------------------
/*Write a SQL query to display the current date and time in the following format 
"day.month.year hour:minutes:seconds:milliseconds". */

DECLARE @d DATETIME = GETDATE();
SELECT FORMAT( @d, 'dd.MM.yyyy H:mm:ss') AS [DateTime Result]
---------------------------------------------------------------------
/*Write a SQL statement to create a view that displays 
the first 10 persons from Employees table*/

CREATE VIEW [First 10 Persons] AS
SELECT TOP 10 FirstName FROM Employees

SELECT *
FROM [First 10 Persons]
---------------------------------------------------------------------
/*Create Users table.
Write SQL statements to insert in the Users table 
the names of all employees from the Employees table.
Combine the first and last names as a full name. 
For username use the first letter of the first name + the last name (in lowercase).*/

CREATE TABLE Users (
  ID int IDENTITY,
  FullName nvarchar(100) NOT NULL,
  Password nvarchar(100)
  CONSTRAINT PK_Users PRIMARY KEY(ID)
)

INSERT INTO Users(FullName)
SELECT SUBSTRING(FirstName, 1, 1) + LOWER(LastName)
FROM Employees
---------------------------------------------------------------------
/*Write a SQL query to display the average employee salary by department and job title.*/

SELECT d.Name AS [Department Name], 
	   e.JobTitle AS [Job Title], 
	   AVG(Salary) AS [Average Salary]
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle
ORDER BY e.JobTitle
---------------------------------------------------------------------
/*Write a SQL query to display the minimal employee salary by 
department and job title along with the name of some of the employees that take it.*/

SELECT d.Name AS [Department Name], 
	   e.JobTitle AS [Job Title], 
	   e.FirstName AS [Firts Name],
	   Min(Salary) AS [Min Salary]
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle, e.FirstName
---------------------------------------------------------------------
/*Write a SQL query to display the town where maximal number of employees work.*/

SELECT t.Name AS [Town Name], 
	   Count(*) AS [Employees Count]
FROM Employees e
INNER JOIN Addresses a
ON e.AddressID = a.AddressID
INNER JOIN Towns t
ON a.TownID = t.TownID
GROUP BY t.Name
---------------------------------------------------------------------
SELECT CountryName, 
	   CountryCode,
	   CASE
			WHEN CurrencyCode <> 'EUR' THEN 'Not Euro'
			WHEN CurrencyCode IS NULL THEN 'Not Euro'
			ELSE 'Euro'
	   END
	   AS Currency		
FROM Countries
ORDER BY CountryName
---------------------------------------------------------------------