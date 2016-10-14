/*The bank is about to start offering deposits. That is why we need few tables. 
Every customer has 1, 0 or many deposits. Every deposit has 0 or 1 one deposit types. 
Many employees will be responsible for the maintenance of the deposits. That’s why we would need a mapping table. 
Customers now have credit history. Every customer can have many different credit marks. 
Our customers have started to pay their loans. Therefore, we need a table Payments. 
Every loan can have 0, 1 or many payments. KTB has a new web site and we would need another table for users. 
Every customer has exactly one user. Here are some details about the tables we need.
*/

USE Bank
GO

CREATE TABLE Deposits (
  DepositID int IDENTITY,
  Amount decimal(10, 2) NOT NULL,
  StartDate date NOT NULL,
  EndDate date,
  DepositTypeID int,
  CustomerID int NOT NULL 
  CONSTRAINT PK_Deposits PRIMARY KEY(DepositID)
)

ALTER TABLE Deposits
ADD CONSTRAINT FK_Deposits_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

CREATE TABLE DepositTypes (
  DepositTypeID int NOT  NULL,
  Name nvarchar(20) NOT NULL 
  CONSTRAINT PK_DepositTypes PRIMARY KEY(DepositTypeID)
)

ALTER TABLE Deposits
ADD CONSTRAINT FK_Deposits_DepositTypes
    FOREIGN KEY (DepositTypeID)
    REFERENCES DepositTypes(DepositTypeID)

CREATE TABLE EmployeesDeposits (
  EmployeeID int NOT  NULL,
  DepositID int NOT  NULL 
  CONSTRAINT PK_EmployeesDeposits PRIMARY KEY(EmployeeID, DepositID)
)

ALTER TABLE EmployeesDeposits
ADD CONSTRAINT FK_EmployeesDeposits_Deposits
    FOREIGN KEY (DepositID)
    REFERENCES Deposits(DepositID)

ALTER TABLE EmployeesDeposits
ADD CONSTRAINT FK_EmployeesDeposits_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees(EmployeeID)

CREATE TABLE CreditHistory (
  CreditHistoryID int NOT  NULL,
  Mark char NOT  NULL,
  StartDate date NOT NULL,
  EndDate date NOT NULL,
  CustomerID int NOT NULL 
  CONSTRAINT PK_CreditHistory PRIMARY KEY(CreditHistoryID)
)

ALTER TABLE CreditHistory
ADD CONSTRAINT FK_CreditHistory_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

CREATE TABLE Payments (
  PaymentID int NOT  NULL,
  Date date NOT NULL,
  Amount decimal(10, 2) NOT NULL,
  LoanID int NOT NULL 
  CONSTRAINT PK_Payments PRIMARY KEY(PaymentID)
)

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_Loans
    FOREIGN KEY (LoanID)
    REFERENCES Loans(LoanID)

CREATE TABLE Users (
  UserID int PRIMARY KEY NOT  NULL,
  UserName varchar(20) NOT NULL,
  Password varchar(20) NOT NULL,
  CustomerID int UNIQUE NOT NULL 
)

ALTER TABLE Users
ADD CONSTRAINT FK_Users_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

ALTER TABLE Employees 
ADD ManagerID int

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Employees
    FOREIGN KEY (ManagerID)
    REFERENCES Employees(EmployeeID)

---------------------------------------------------------------------
/*Insert values.*/

DECLARE custCursor CURSOR READ_ONLY FOR
  SELECT CustomerID, Gender, DateOfBirth 
  FROM Customers
  WHERE CustomerID < 20
OPEN custCursor
DECLARE @customerId int, @gender char, @dateOfBirth date
FETCH NEXT FROM custCursor INTO @customerId, @gender, @dateOfBirth
WHILE @@FETCH_STATUS = 0
  BEGIN
    DECLARE @amount decimal(10, 2) = 0
	
	IF(@dateOfBirth > '01-01-1980')
		BEGIN
			SET @amount = @amount + 1000 
		END
    ELSE
		BEGIN
			SET @amount = @amount + 1500 
		END

	IF(@gender = 'M')
		BEGIN
			SET @amount = @amount + 100 
		END
    ELSE
		BEGIN
			SET @amount = @amount + 200 
		END

	DECLARE @depositTypeId int = CASE
									WHEN @customerId % 2 = 0 AND @customerId <= 15 THEN 2
									WHEN @customerId % 2 <> 0 AND @customerId <= 15 THEN 1
									WHEN @customerId > 15 THEN 3
								 END

	INSERT INTO Deposits(Amount, StartDate, DepositTypeId, CustomerID)
    VALUES(@amount, GETDATE(), @depositTypeId, @customerId)

	FETCH NEXT FROM custCursor INTO @customerId, @gender, @dateOfBirth
  END
CLOSE custCursor
DEALLOCATE custCursor
GO


INSERT INTO EmployeesDeposits VALUES
 (15, 4), 
 (20, 15), 
 (8, 7),
 (4, 8),
 (3, 13),
 (3, 8),
 (4, 10),
 (10, 1),
 (13, 4),
 (14, 9)

 INSERT INTO DepositTypes(DepositTypeID, Name)
 VALUES (1, 'Time Deposit')

 INSERT INTO DepositTypes(DepositTypeID, Name)
 VALUES (2, 'Call Deposit')

 INSERT INTO DepositTypes(DepositTypeID, Name)
 VALUES (3, 'Free Deposit')

 ---------------------------------------------------------------------
  /*Write a query that returns all customers who are between 40 and 50 years old. 
  The range is inclusive. Consider that today is 01-10-2016.*/

  SELECT FirstName, DateOfBirth, DATEDIFF(Year, DateOfBirth, '10-1-2016') AS Age
  FROM Customers
  WHERE DATEDIFF(Year, DateOfBirth, '10-1-2016') BETWEEN 40 AND 50

  ---------------------------------------------------------------------
  /*Write a query that returns the count of all employees grouped by city name and branch name. 
  Exclude cities with id 4 and 5. Don’t show groups with less than 3 employees. */

  SELECT c.CityName, b.Name, COUNT(*)
  FROM Employees e
  INNER JOIN Branches b
  ON e.BranchID = b.BranchID
  INNER JOIN Cities c
  ON b.CityId = c.CityID
  WHERE b.CityID NOT IN (4, 5)
  GROUP BY c.CityName, b.Name
  HAVING COUNT(*) >= 3

  ---------------------------------------------------------------------
/*Write a function with name udf_ConcatString that reverses two strings, 
joins them and returns the concatenation. 
The function should have two input parameters of type VARCHAR.*/

CREATE FUNCTION udf_ConcatString (@firstString nvarchar(MAX), @secondString nvarchar(MAX))
RETURNS nvarchar(MAX)
AS
BEGIN
  SET @firstString = REVERSE(@firstString)
  SET @secondString = REVERSE(@secondString)
  RETURN @firstString + @secondString
END
GO

---------------------------------------------------------------------
/*Write a procedure that returns a customer if it has unexpired loan. 
The function should have one parameter for CustomerID of type integer. 
Name the function usp_CustomersWithUnexpiredLoans. 
If the id of the customer doesn’t have unexpired loans return an empty result set.
*/

CREATE PROCEDURE usp_CustomersWithUnexpiredLoans(@customerId INT)
AS
BEGIN 
	SELECT c.CustomerID, c.FirstName, l.LoanID
	FROM Customers c
	INNER JOIN Loans l
	ON c.CustomerID = l.CustomerID
	WHERE (l.ExpirationDate > GETDATE()
		  OR l.ExpirationDate IS NULL)
		  AND c.CustomerID = @customerId
		   	
END
 
EXEC usp_CustomersWithUnexpiredLoans 9

---------------------------------------------------------------------
/*Write a procedure that adds a loan to an existing customer. 
The procedure should have the following input parameters:
If the loan amount is not between 0.01 AND 100000 raise an error ‘Invalid Loan Amount.’ And rollback the transaction.
If no error is raised insert the loan into table Loans. 
The column LoanID has an identity property so there is no need to specify a value for it. 
Name the procedure usp_TakeLoan.
*/

CREATE PROCEDURE usp_TakeLoan(@customerId int, @loanAmount decimal(18, 2), 
	@interest decimal(4, 2), @startDate date)
AS
BEGIN 
	
	BEGIN TRAN
	
	IF(@loanAmount > 0.01 AND @loanAmount < 100000)
	BEGIN
		INSERT INTO Loans(CustomerID, StartDate, Amount, Interest)
		VALUES (@customerId, @startDate, @loanAmount, @interest)
		COMMIT
	END
	ELSE
	BEGIN
		RAISERROR('Invalid Loan Amount', 16, 1)
		ROLLBACK
	END	   	
END
GO

EXEC usp_TakeLoan @CustomerID = 1, @LoanAmount = 500, @Interest = 1, @StartDate='20160915'

---------------------------------------------------------------------
/*Write a trigger on table Employees. After an insert of a new employee 
the new employee takes the loan maintenance of the previous employee.
*/

CREATE TRIGGER tr_HireEmployee 
ON Employees 
AFTER INSERT
AS
  DECLARE @employeeID INT = (SELECT EmployeeID
							 FROM inserted)
  
  INSERT INTO EmployeesLoans (EmployeeID, LoanID)
  SELECT @employeeID, LoanID
  FROM EmployeesLoans
  WHERE EmployeeID = @employeeID

GO

INSERT INTO Employees (EmployeeID, FirstName, HireDate, Salary, BranchID)
VALUES (31, 'Jake', '20161212', 500, 2)

---------------------------------------------------------------------
/*Create a table with the same structure as table Accounts and name it AccountLogs. 
Then create a trigger that logs the deleted records from table Accounts into table AccountLogs.
*/

CREATE TRIGGER tr_DeleteAccount 
ON Accounts 
INSTEAD OF DELETE
AS
  IF OBJECT_ID('AccountLogs') IS NULL
	BEGIN
		CREATE TABLE AccountLogs(
			AccountID int,
			AccountNumber char(12),
			StartDate date,
			CustomerID int
			)
	END
  
  DELETE FROM EmployeesAccounts
  WHERE AccountID IN (SELECT AccountID
					  FROM deleted)

  INSERT INTO AccountLogs(AccountID, AccountNumber, StartDate, CustomerID)
  SELECT AccountID, AccountNumber, StartDate, CustomerID 
  FROM deleted

  DELETE FROM Accounts
  WHERE AccountID IN (SELECT AccountID
					  FROM deleted)
GO

DELETE FROM [dbo].[Accounts] 
WHERE CustomerID = 4