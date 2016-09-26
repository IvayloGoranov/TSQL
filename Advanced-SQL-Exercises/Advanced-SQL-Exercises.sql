---------------------------------------------------------------------
/*Write a SQL query to find the full name of the employee, 
his manager full name and the JobTitle from Sales department. 
Use nested select statement.*/

SELECT e.FirstName + ' ' + e.LastName AS [Full Name],
	   m.FirstName + ' ' + m.LastName AS [Manager Full Name],
	   e.JobTitle
FROM Employees e
INNER JOIN Employees m
ON e.ManagerID = m.EmployeeID
WHERE e.DepartmentId = 
	(SELECT DepartmentID FROM Departments
	 WHERE Name='Sales')

---------------------------------------------------------------------
/*Display all project with the sum of their employee’s salaries.*/

SELECT p.Name, SUM(e.Salary) AS [Employee Salaries]
FROM Projects p
INNER JOIN EmployeesProjects ep
ON  p.ProjectID = ep.ProjectID
INNER JOIN Employees e
ON ep.EmployeeID = e.EmployeeID
GROUP BY p.Name
ORDER BY p.Name