/*Create a database with two tables
Persons (id (PK), first name, last name, SSN) and 
Accounts (id (PK), person id (FK), balance). Insert few records for testing. 
Write a stored procedure that selects the full names of all persons.*/

CREATE DATABASE TestDB

CREATE TABLE Persons (
  Id int IDENTITY,
  FirstName nvarchar(100) NOT NULL,
  LastName nvarchar(100) NOT NULL,
  SSN nvarchar(30)
  CONSTRAINT PK_Persons PRIMARY KEY(Id)
)

USE TestDB

CREATE TABLE Accounts (
  Id int IDENTITY,
  PersonId int,
  Balance money,
  CONSTRAINT PK_Accounts PRIMARY KEY(Id)
)

ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Persons
  FOREIGN KEY (PersonId)
  REFERENCES Persons(Id)

INSERT INTO Persons(FirstName, LastName)
VALUES('Pesho', 'Goshev')

INSERT INTO Persons(FirstName, LastName)
VALUES('Tsetso', 'Toshev')

INSERT INTO Persons(FirstName, LastName)
VALUES('Kolyo', 'Moshev')

INSERT INTO Persons(FirstName, LastName)
VALUES('Gutsa', 'Gosheva')

INSERT INTO Accounts(PersonId, Balance)
VALUES(1, 100)

INSERT INTO Accounts(PersonId, Balance)
VALUES(2, 200)

INSERT INTO Accounts(PersonId, Balance)
VALUES(3, 10)

INSERT INTO Accounts(PersonId, Balance)
VALUES(1, 100000)

CREATE PROC usp_SelectPersonsFullNames AS
SELECT FirstName + ' ' + LastName
FROM Persons

ALTER PROC usp_SelectPersonsFullNames AS
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Persons

EXEC usp_SelectPersonsFullNames
---------------------------------------------------------------------
/*Create a stored procedure that accepts a number as a parameter and 
returns all persons who have more money in their accounts than the supplied number.*/

CREATE PROC usp_SelectPersonsWithBalanceEqualOrBiggerThan (@accountBalance money) AS
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Persons p
INNER JOIN Accounts a
ON p.Id = a.PersonId
WHERE a.Balance >= @accountBalance

ALTER PROC usp_SelectPersonsWithBalanceEqualOrBiggerThan (@accountBalance money) AS
SELECT p.FirstName + ' ' + p.LastName AS [Full Name], a.Balance
FROM Persons p
INNER JOIN Accounts a
ON p.Id = a.PersonId
WHERE a.Balance >= @accountBalance

EXEC usp_SelectPersonsWithBalanceEqualOrBiggerThan 100
---------------------------------------------------------------------
/*Create a function that accepts as parameters – 
amount, yearly interest rate and number of months. 
It should calculate and return the new sum. 
Write a SELECT to test whether the function works as expected.*/

CREATE FUNCTION ufn_CalculateInterest(@amount money, 
	@yearlyInterest money, @monthsCount money) RETURNS money AS
BEGIN
  DECLARE @monthlyInterest money
  SET @monthlyInterest = (@yearlyInterest / 100) / 12
  DECLARE @interest money
  SET @interest = @amount + @amount * @monthlyInterest * @monthsCount 
  RETURN @interest
END

SELECT p.FirstName + ' ' + p.LastName AS [Full Name], 
	   a.Balance,
	   dbo.ufn_CalculateInterest(a.Balance, 2, 3) AS [Interest]
FROM Persons p
INNER JOIN Accounts a
ON p.Id = a.PersonId
WHERE p.FirstName = 'Pesho'
---------------------------------------------------------------------
/*Create a stored procedure that uses the function from the previous example 
to give an interest to a person's account for one month. 
It should take the AccountId and the interest rate as parameters.*/

CREATE PROC usp_CalculateInterestForAccount (@yearlyInterest money, 
@monthsCount money, @accountId int) AS
DECLARE @balance money
SELECT @balance = Balance
FROM Accounts
WHERE Id = @accountId
UPDATE Accounts
SET Balance = dbo.ufn_CalculateInterest(@balance, @yearlyInterest, @monthsCount)
WHERE Id = @accountId

EXEC usp_CalculateInterestForAccount 2, 3, 1

SELECT * FROM Accounts
---------------------------------------------------------------------
/*Add two more stored procedures WithdrawMoney (AccountId, money) 
and DepositMoney (AccountId, money) that operate in transactions.*/

CREATE PROC usp_WithdrawFromAccount (@amount money, @accountId int) AS
UPDATE Accounts
SET Balance = Balance - @amount
WHERE Id = @accountId
IF ((SELECT Balance 
	 FROM Accounts
	 WHERE Id = @accountId) < 0)
BEGIN
    UPDATE Accounts
	SET Balance = Balance + @amount
	WHERE Id = @accountId
END

CREATE PROC usp_DepositToAccount (@amount money, @accountId int) AS
UPDATE Accounts
SET Balance = Balance + @amount
WHERE Id = @accountId

EXEC usp_WithdrawFromAccount 100, 1

EXEC usp_DepositToAccount 100, 1

SELECT * 
FROM Accounts
---------------------------------------------------------------------
/*Create another table – Logs (LogID, AccountID, OldSum, NewSum). 
Add a trigger to the Accounts table that enters a 
new entry into the Logs table every time the sum on an account changes.*/

CREATE TABLE Logs (
  Id int IDENTITY,
  AccountID int, 
  OldSum money, 
  NewSum money
  CONSTRAINT PK_Logs PRIMARY KEY(Id)
)

ALTER TABLE Logs
ADD CONSTRAINT FK_Logs_Accounts
  FOREIGN KEY (AccountId)
  REFERENCES Accounts(Id)

CREATE TRIGGER tr_BalanceChange ON Accounts AFTER UPDATE AS
INSERT INTO Logs(AccountID, OldSum, NewSum)
SELECT i.Id, d.Balance, i.Balance
FROM Inserted i
INNER JOIN Deleted d ON i.ID = d.ID

EXEC usp_WithdrawFromAccount 100, 2

EXEC usp_DepositToAccount 100, 2

SELECT *
FROM Accounts

SELECT * 
FROM [TestDB].dbo.Logs
---------------------------------------------------------------------
/*Create another table – Logs (LogID, AccountID, OldSum, NewSum). 
Add a trigger to the Accounts table that enters a 
new entry into the Logs table every time the sum on an account changes.*/

CREATE TABLE Logs (
  Id int IDENTITY,
  AccountID int, 
  OldSum money, 
  NewSum money
  CONSTRAINT PK_Logs PRIMARY KEY(Id)
)

ALTER TABLE Logs
ADD CONSTRAINT FK_Logs_Accounts
  FOREIGN KEY (AccountId)
  REFERENCES Accounts(Id)

CREATE TRIGGER tr_BalanceChange ON Accounts AFTER UPDATE AS
INSERT INTO Logs(AccountID, OldSum, NewSum)
SELECT i.Id, d.Balance, i.Balance
FROM Inserted i
INNER JOIN Deleted d ON i.ID = d.ID

EXEC usp_WithdrawFromAccount 100, 2

EXEC usp_DepositToAccount 100, 2

SELECT *
FROM Accounts

SELECT * 
FROM [TestDB].dbo.Logs
---------------------------------------------------------------------