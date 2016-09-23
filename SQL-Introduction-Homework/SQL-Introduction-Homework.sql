---------------------------------------------------------------------
/*Write a SQL query to find all information about all departments*/

SELECT * 
FROM Departments

---------------------------------------------------------------------
/*Write a SQL query to find all department names*/

SELECT Name 
FROM Departments

---------------------------------------------------------------------
/*Write a SQL query to find the salary of each employee*/

SELECT FirstName + ' ' + LastName AS [Employee], Salary 
FROM Employees

---------------------------------------------------------------------
/*Write a SQL to find the full name of each employee*/

SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Employees

---------------------------------------------------------------------
/*Write a SQL query to find the address of each employee.*/

SELECT FirstName + ' ' + LastName AS [Full Name],
	   a.AddressText AS [Address]	
FROM Employees e
INNER JOIN Addresses a
ON e.AddressID = a.AddressID

---------------------------------------------------------------------
/*Write a SQL query to find all information about the employees 
whose job title is “Sales Representative“.*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name],
	   e.JobTitle,
	   d.Name AS [Department Name],
	   m.LastName AS [Manager Last Name], 
	   e.HireDate,
	   e.Salary,
	   a.AddressText AS [Address]	
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
INNER JOIN Employees m
ON e.ManagerID = m.EmployeeID
INNER JOIN Addresses a
ON e.AddressID = a.AddressID
WHERE e.JobTitle = 'Sales Representative'

---------------------------------------------------------------------
/*Write a SQL query to find the names of all employees 
whose first name starts with "SA".*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name]
FROM Employees e
WHERE e.FirstName LIKE 'Sa%'

---------------------------------------------------------------------
/*Write a SQL query to find the names of all employees whose last name contains "ei".*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name]
FROM Employees e
WHERE e.LastName LIKE '%ei%'

---------------------------------------------------------------------
/*Write a SQL query to find the salary of all employees 
whose salary is in the range [20000…30000].*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary BETWEEN 20000 AND 30000

---------------------------------------------------------------------
/*Write a SQL query to find the salary of all employees 
whose salary is in the range [20000…30000].*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary BETWEEN 20000 AND 30000

---------------------------------------------------------------------
/*Write a SQL query to find the names of all employees 
whose salary is 25000, 14000, 12500 or 23600*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary IN (25000, 14000, 12500, 23600)

---------------------------------------------------------------------
/*Write a SQL query to find all employees that do not have manager.*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.ManagerID
FROM Employees e
WHERE e.ManagerID IS Null

---------------------------------------------------------------------
/*Write a SQL query to find all employees that have salary more than 50000. 
Order them in decreasing order by salary*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
WHERE e.Salary > 50000
ORDER BY e.Salary DESC

---------------------------------------------------------------------
/*Write a SQL query to find the top 5 best paid employees*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary
FROM Employees e
ORDER BY e.Salary DESC
OFFSET 0 ROWS 
FETCH NEXT 5 ROWS ONLY

---------------------------------------------------------------------
/*Write a SQL query to find all the employees and the manager 
for each of them along with the employees that do not have manager*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name],
	   m.LastName AS [Manager]	
FROM Employees e LEFT OUTER JOIN Employees m
ON e.ManagerID = m.EmployeeID

---------------------------------------------------------------------
/*Write a SQL query to find the names of all employees 
from the departments "Sales" and "Finance" whose hire year is between 1995 and 2005*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name],
	   e.HireDate,
	   d.Name AS [Department Name]	
FROM Employees e INNER JOIN Departments d
ON (e.DepartmentId = d.DepartmentId
  AND e.HireDate > '1/1/1995'
  AND e.HireDate < '12/31/2005'
  AND d.Name IN ('Sales', 'Finance'))

---------------------------------------------------------------------
