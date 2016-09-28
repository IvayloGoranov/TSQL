/*Write a SQL query to find the first names 
of all employees in the departments with ID 3 or 10 and 
whose hire year is between 1995 and 2005 inclusive. */

SELECT FirstName
FROM Employees
WHERE (DepartmentId = 3 OR
  	  DepartmentId = 10) AND
      YEAR(HireDate) BETWEEN 1995 AND 2005
	  
---------------------------------------------------------------------
/*Write a SQL query to find the first and last names of all 
employees whose job titles does not contain “engineer”. */

SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'
	  
---------------------------------------------------------------------
/*Write a SQL query to find town names that are 5 or 6 symbols 
long and order them alphabetically by town name.  */

SELECT Name
FROM Towns
WHERE Len(Name) = 5 OR Len(Name) = 6
ORDER BY Name
	  
---------------------------------------------------------------------
/*Write a SQL query to find town names that are 5 or 6 symbols 
long and order them alphabetically by town name.  */

CREATE VIEW V_EmployeesHiredAfter2000  AS
SELECT FirstName, LastName 
FROM Employees
WHERE Year(HireDate) > 2000
	  
---------------------------------------------------------------------
/*Find the top 50 games ordered by start date, then by name of the game. 
Display only games from 2011 and 2012 year. 
Display start date in the format “YYYY-MM-DD”. */

SELECT TOP 50 Name AS [Game], FORMAT(Start, 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE Year(Start) BETWEEN 2011 AND 2012
ORDER BY Start 
---------------------------------------------------------------------
/*You are given a table Orders(Id, ProductName, OrderDate) 
filled with data. Consider that the payment for that order must be accomplished 
within 3 days after the order date. Also the delivery date is up to 1 month. 
Write a query to show each product’s name, order date, pay and deliver due dates. */

SELECT ProductName, 
	   OrderDate, 
       DATEADD(day, 3, OrderDate) AS[Pay Due]
       DATEADD(day, 30, OrderDate) AS[Deliver Due]
FROM Orders    
---------------------------------------------------------------------