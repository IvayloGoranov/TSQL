/*Select all deposit groups and its total deposit sum but only 
for the wizards who has their magic wand crafted by Ollivander family. 
After this filter total deposit amounts lower than 150000. 
Order by total deposit amount in descending order.*/

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits 
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY SUM(DepositAmount) DESC
---------------------------------------------------------------------
/*Write down a query that creates 7 different groups based on their age. 
The query should return Age groups and Count of wizards in it.*/

SELECT w.RANGE AS [AgeGroup], COUNT(*) AS [WizardCount]
FROM (SELECT 
	  CASE  
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]' 
	  END 
	  AS RANGE
      FROM WizzardDeposits) w
GROUP BY w.RANGE
---------------------------------------------------------------------
/*Find the max salary for each department. 
Filter those which have total salaries between 30000 and 70000;*/

SELECT DepartmentId, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) BETWEEN 30000 AND 70000
---------------------------------------------------------------------
/*Third Highest Salary*/

SELECT DepartmentID, 
	(SELECT DISTINCT Salary FROM Employees WHERE DepartmentID = e.DepartmentID 
	 ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY)AS ThirdHighestSalary
FROM Employees e
WHERE (SELECT DISTINCT Salary FROM Employees WHERE DepartmentID = e.DepartmentID 
       ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) IS NOT NULL
GROUP BY DepartmentID