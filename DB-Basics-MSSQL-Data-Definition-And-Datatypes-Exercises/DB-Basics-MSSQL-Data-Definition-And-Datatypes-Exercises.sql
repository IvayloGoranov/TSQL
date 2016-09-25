---------------------------------------------------------------------
/*Create Tables. Add table Minions (Id, Name, Age). 
Then add new table Towns (Id, Name). 
Set Id columns of both tables to be primary key as constraint.*/

CREATE TABLE Towns (
  ID int IDENTITY,
  TownName nvarchar(100) NOT NULL,
  CONSTRAINT PK_Towns PRIMARY KEY(ID)
)
---------------------------------------------------------------------
/*Alter Minions Table
Change the structure of the Minions table to have new column TownId 
that would be of the same type as the Id column of Towns table. 
Add new constraint that makes TownId foreign key and references to Id column of Towns table.
*/

ALTER TABLE Minions ADD TownId int

ALTER TABLE Minions
ADD CONSTRAINT FK_Minions_Towns
	FOREIGN KEY (TownID)
	REFERENCES Towns(ID)
---------------------------------------------------------------------
/*Insert Records in Both Tables*/

INSERT INTO Towns(Name)
VALUES ('Sofia')

INSERT INTO Towns(Name)
VALUES ('Plovdiv')

INSERT INTO Towns(Name)
VALUES ('Varna')

INSERT INTO Minions(Name, Age, TownId)
VALUES ('Kevin', 22, 1)

INSERT INTO Minions(Name, Age, TownId)
VALUES ('Bob', 15, 3)

INSERT INTO Minions(Name, Age, TownId)
VALUES ('Steward', Null, 2)
---------------------------------------------------------------------
/*Create Table People*/

CREATE TABLE Users (
  Id bigint IDENTITY,
  Name nvarchar(200) NOT NULL,
  Picture image,
  Height float(2),
  Weight float(2),
  Gender char(1) NOT NULL,
  Birthdate datetime NOT NULL,
  Biography nvarchar(MAX)
  CONSTRAINT PK_Users PRIMARY KEY(Id)
)

INSERT INTO Users(Name, Gender, Birthdate)
VALUES ('Kevin', 'm','2002-12-31' )

INSERT INTO Users(Name, Gender, Birthdate)
VALUES ('Pesho', 'm','1990-12-31' )

INSERT INTO Users(Name, Gender, Birthdate)
VALUES ('Gosho', 'm','2001-12-31' )

INSERT INTO Users(Name, Gender, Birthdate)
VALUES ('Tsetso', 'm','2002-12-31' )

INSERT INTO Users(Name, Gender, Birthdate)
VALUES ('Petranka', 'f','2002-12-31' )
---------------------------------------------------------------------
/*Change Primary Key*/

ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users 
	PRIMARY KEY(Id, Name)
---------------------------------------------------------------------
/*Using SQL queries modify table Users. 
Add check constraint to ensure that the values in the Name field 
are at least 5 symbols long.*/

ALTER TABLE Users
ADD CONSTRAINT CK_Users_MinLengthName CHECK (DATALENGTH(Name) >= 5)
---------------------------------------------------------------------
/*Using SQL queries modify table Users. 
Make the default value of Birthdare field to be the current time.
It's obviously nonsense, but who cares.:))*/

ALTER TABLE Users 
ADD CONSTRAINT DF_Users_DedaultBirthdate 
DEFAULT GETDATE() FOR Birthdate 
---------------------------------------------------------------------
/*Using SQL queries modify table Users. 
Remove Name field from the primary key so only the field Id would be primary key.*/

ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users 
PRIMARY KEY(Id)
---------------------------------------------------------------------
/*Using SQL queries create Movies database.*/

CREATE DATABASE Movies

CREATE TABLE Directors (
  Id int IDENTITY,
  DirectorName nvarchar(100) NOT NULL,
  Notes nvarchar(MAX),
  CONSTRAINT PK_Directors PRIMARY KEY(Id)
)

CREATE TABLE Genres (
  Id int IDENTITY,
  GenreName nvarchar(100) NOT NULL,
  Notes nvarchar(MAX),
  CONSTRAINT PK_Genres PRIMARY KEY(Id)
)

CREATE TABLE Categories (
  Id int IDENTITY,
  CategoryName nvarchar(100) NOT NULL,
  Notes nvarchar(MAX),
  CONSTRAINT PK_Categories PRIMARY KEY(Id)
)

CREATE TABLE Movies (
  Id int IDENTITY,
  Title nvarchar(100) NOT NULL,
  DirectorId int,
  CopyrightYear datetime,
  Length int NOT NULL,
  GenreId int,
  CategoryId int,
  Rating int,
  Notes nvarchar(MAX),
  CONSTRAINT PK_Movies PRIMARY KEY(Id)
)

ALTER TABLE Movies
ADD CONSTRAINT FK_Movies_Directors
	FOREIGN KEY (DirectorId)
	REFERENCES Directors(ID)

ALTER TABLE Movies
ADD CONSTRAINT FK_Movies_Genres
	FOREIGN KEY (GenreId)
	REFERENCES Genres(ID)

ALTER TABLE Movies
ADD CONSTRAINT FK_Movies_Categories
	FOREIGN KEY (CategoryId)
	REFERENCES Categories(ID)

INSERT INTO Directors(DirectorName)
VALUES ('Pesho')

INSERT INTO Directors(DirectorName)
VALUES ('Gosho')

INSERT INTO Directors(DirectorName)
VALUES ('Tsetso')

INSERT INTO Directors(DirectorName)
VALUES ('Rado')

INSERT INTO Directors(DirectorName)
VALUES ('Drago')

INSERT INTO Genres(GenreName)
VALUES ('Horror')

INSERT INTO Genres(GenreName)
VALUES ('Sci-Fi')

INSERT INTO Genres(GenreName)
VALUES ('Action')

INSERT INTO Genres(GenreName)
VALUES ('Drama')

INSERT INTO Genres(GenreName)
VALUES ('Comedy')

INSERT INTO Categories(CategoryName)
VALUES ('Porno')

INSERT INTO Categories(CategoryName)
VALUES ('Lorno')

INSERT INTO Categories(CategoryName)
VALUES ('Softcore')

INSERT INTO Categories(CategoryName)
VALUES ('Children')

INSERT INTO Categories(CategoryName)
VALUES ('Over 12')

INSERT INTO Movies(Title, Length)
VALUES ('The Fifth Element', 134)

INSERT INTO Movies(Title, Length)
VALUES ('I Am Legend', 132)

INSERT INTO Movies(Title, Length)
VALUES ('North And South', 550)

INSERT INTO Movies(Title, Length)
VALUES ('Dazed And Confused', 126)

INSERT INTO Movies(Title, Notes, Length)
VALUES ('Under Sandet', 'Best movie I''ve seen this year', 131)
---------------------------------------------------------------------
/*Using SQL queries create CarRental database.*/

CREATE DATABASE CarRental

CREATE TABLE Categories (
  Id int IDENTITY,
  Category nvarchar(100) NOT NULL,
  DailyRate money,
  WeeklyRate money,
  MonthlyRate money,
  WeekendRate money,
  CONSTRAINT PK_Categories PRIMARY KEY(Id)
)

CREATE TABLE Cars (
  Id int IDENTITY,
  PlateNumber nvarchar(10) NOT NULL,
  Make nvarchar(30) NOT NULL,
  Model nvarchar(30) NOT NULL,
  CarYear datetime,
  CategoryId int,
  Doors bit,
  Picture varbinary(MAX),
  Condition nvarchar(20),
  Available bit,
  CONSTRAINT PK_Cars PRIMARY KEY(Id)
)

CREATE TABLE Employees (
  Id int IDENTITY,
  FirstName nvarchar(50) NOT NULL,
  LastName nvarchar(50) NOT NULL,
  Title nvarchar(20),
  Notes nvarchar(MAX),
  CONSTRAINT PK_Employees PRIMARY KEY(Id)
)

CREATE TABLE Customers (
  Id int IDENTITY,
  DriverLicenseNumber nvarchar(100) NOT NULL,
  FullName nvarchar(200) NOT NULL,
  Address nvarchar(MAX),
  City nvarchar(100),
  ZipCode nvarchar(50),
  Notes nvarchar(MAX),
  CONSTRAINT PK_Customers PRIMARY KEY(Id)
)

CREATE TABLE RentalOrders (
  Id int IDENTITY,
  EmployeeId int,
  CustomerId int,
  CarId int,
  CarCondition nvarchar(20),
  TankLevel int,
  KilometrageStart int,
  TotalKilometrage int,
  KilometrageEnd int,
  StartDate datetime,
  EndDate datetime,
  TotalDays int NOT NULL,
  RateApplied money NOT NULL,
  TaxRate money,
  OrderStatus nvarchar(50),
  Notes nvarchar(MAX),
  CONSTRAINT PK_RentalOrders PRIMARY KEY(Id)
)

ALTER TABLE Cars
ADD CONSTRAINT FK_Cars_Categories
	FOREIGN KEY (CategoryId)
	REFERENCES Categories(ID)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_RentalOrders_Customers
	FOREIGN KEY (CustomerId)
	REFERENCES Customers(ID)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_RentalOrders_Employees
	FOREIGN KEY (EmployeeId)
	REFERENCES Employees(ID)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_RentalOrders_Cars
	FOREIGN KEY (CarId)
	REFERENCES Cars(ID)
---------------------------------------------------------------------
/*Increase the salary of all employees by 10%. 
Select only Salary column from the Employees table.*/

UPDATE Employees
SET Salary = Salary * 1.1
FROM Employees

SELECT Salary
FROM Employees