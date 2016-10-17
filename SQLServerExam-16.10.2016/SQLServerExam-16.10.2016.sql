
/*Initial create*/

CREATE DATABASE Airport
GO

USE Airport
GO

CREATE TABLE Towns (
	TownID INT,
	TownName VARCHAR(30) NOT NULL,
	CONSTRAINT PK_Towns PRIMARY KEY(TownID)
)

CREATE TABLE Airports (
	AirportID INT,
	AirportName VARCHAR(50) NOT NULL,
	TownID INT NOT NULL,
	CONSTRAINT PK_Airports PRIMARY KEY(AirportID),
	CONSTRAINT FK_Airports_Towns FOREIGN KEY(TownID) REFERENCES Towns(TownID)
)

CREATE TABLE Airlines (
	AirlineID INT,
	AirlineName VARCHAR(30) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Rating INT DEFAULT(0),
	CONSTRAINT PK_Airlines PRIMARY KEY(AirlineID)
)

CREATE TABLE Customers (
	CustomerID INT,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Gender VARCHAR(1) NOT NULL CHECK (Gender='M' OR Gender='F'),
	HomeTownID INT NOT NULL,
	CONSTRAINT PK_Customers PRIMARY KEY(CustomerID),
	CONSTRAINT FK_Customers_Towns FOREIGN KEY(HomeTownID) REFERENCES Towns(TownID)
)

INSERT INTO Towns(TownID, TownName)
VALUES
(1, 'Sofia'),
(2, 'Moscow'),
(3, 'Los Angeles'),
(4, 'Athene'),
(5, 'New York')

INSERT INTO Airports(AirportID, AirportName, TownID)
VALUES
(1, 'Sofia International Airport', 1),
(2, 'New York Airport', 5),
(3, 'Royals Airport', 1),
(4, 'Moscow Central Airport', 2)

INSERT INTO Airlines(AirlineID, AirlineName, Nationality, Rating)
VALUES
(1, 'Royal Airline', 'Bulgarian', 200),
(2, 'Russia Airlines', 'Russian', 150),
(3, 'USA Airlines', 'American', 100),
(4, 'Dubai Airlines', 'Arabian', 149),
(5, 'South African Airlines', 'African', 50),
(6, 'Sofia Air', 'Bulgarian', 199),
(7, 'Bad Airlines', 'Bad', 10)

INSERT INTO Customers(CustomerID, FirstName, LastName, DateOfBirth, Gender, HomeTownID)
VALUES
(1, 'Cassidy', 'Isacc', '19971020', 'F', 1),
(2, 'Jonathan', 'Half', '19830322', 'M', 2),
(3, 'Zack', 'Cody', '19890808', 'M', 4),
(4, 'Joseph', 'Priboi', '19500101', 'M', 5),
(5, 'Ivy', 'Indigo', '19931231', 'F', 1)

--------------------------------------------------------------------------------------------

--SSection 1 Tasks

CREATE TABLE Flights (
  FlightID int,
  DepartureTime datetime NOT NULL,
  ArrivalTime datetime NOT NULL,
  Status varchar(9) DEFAULT ('Departing'),
  OriginAirportID int,
  DestinationAirportID int,
  AirlineID int,
  CONSTRAINT PK_Flights PRIMARY KEY(FlightID)
)

CREATE TABLE Tickets (
  TicketID int,
  Price decimal(8, 2) NOT NULL,
  Class varchar(6) DEFAULT ('First') NOT NULL,
  Seat varchar(5) NOT NULL,
  CustomerID int,
  FlightID int,
  CONSTRAINT PK_Tickets PRIMARY KEY(TicketID)
)

ALTER TABLE Flights
ADD CONSTRAINT FK_Flights_Airlines
    FOREIGN KEY (AirlineID)
    REFERENCES Airlines(AirlineID)

ALTER TABLE Flights
ADD CONSTRAINT FK_Flights_OriginAirports
    FOREIGN KEY (OriginAirportID)
    REFERENCES Airports(AirportID)

ALTER TABLE Flights
ADD CONSTRAINT FK_Flights_DestinationAirports
    FOREIGN KEY (DestinationAirportID)
    REFERENCES Airports(AirportID)

ALTER TABLE Tickets
ADD CONSTRAINT FK_Tickets_Flights
    FOREIGN KEY (FlightID)
    REFERENCES Flights(FlightID)

ALTER TABLE Tickets
ADD CONSTRAINT FK_Tickets_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

---------------------------------------------------------------------------------------

--Section 2, Task 1

INSERT INTO Flights (FlightID, DepartureTime, 
					 ArrivalTime, Status, OriginAirportID, 
					 DestinationAirportID, AirlineID)
VALUES
 (1, '10-13-2016 06:00 AM', '10-13-2016 10:00 AM', 'Delayed', 1, 4, 1), 
 (2, '10-12-2016 12:00 PM', '10-12-2016 12:01 PM', 'Departing', 1, 3, 2), 
 (3, '10-14-2016 03:00 PM', '10-20-2016 04:00 PM', 'Delayed', 4, 2, 4),
 (4, '10-12-2016 01:24 PM', '10-12-2016 04:31 PM', 'Departing', 3, 1, 3),
 (5, '10-12-2016 08:11 AM', '10-12-2016 11:22 PM', 'Departing', 4, 1, 1),
 (6, '06-21-1995 12:30 PM', '06-22-1995 08:30 PM', 'Arrived', 2, 3, 5),
 (7, '10-12-2016 11:34 PM', '10-13-2016 03:00 AM', 'Departing', 2, 4, 2),
 (8, '11-11-2016 01:00 PM', '11-12-2016 10:00 PM', 'Delayed', 4, 3, 1),
 (9, '10-01-2015 12:00 PM', '12-01-2015 01:00 AM', 'Arrived', 1, 2, 1),
 (10, '10-12-2016 07:30 PM', '10-13-2016 12:30 PM', 'Departing', 2, 1, 7)

INSERT INTO Tickets (TicketID, Price, 
					  Class, Seat, CustomerID, FlightID)
VALUES
 (1, 3000, 'First', '233-A', 3, 8), 
 (2, 1799.90, 'Second', '123-D', 1, 1), 
 (3, 1200.50, 'Second', '12-Z', 2, 5), 
 (4, 410.68, 'Third', '45-Q', 2, 8), 
 (5, 560, 'Third', '201-R', 4, 6),
 (6, 2100, 'Second', '13-T', 1, 9),
 (7, 5500, 'First', '98-O', 2, 7)  

 -----------------------------------------------------------------------------

 --Section 2, Task 2

 UPDATE Flights
 SET AirlineID = 1
 WHERE Status = 'Arrived'

 ------------------------------------------------------------------------------

 --Section 2, Task 3

 UPDATE Tickets
 SET Price = Price * 1.5
 WHERE FlightID IN 
 (SELECT f.FlightID
 FROM Tickets t
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 INNER JOIN (SELECT TOP 1 AirlineID, MAX(Rating) AS MaxRating 
				      FROM Airlines
				      GROUP BY AirlineID) AS a
 ON f.AirlineID = a.AirlineID
 WHERE f.AirlineID = a.AirlineID) 


-------------------------------------------------------------------------------------------------------------------

--Section 2, Task 4

CREATE TABLE CustomerReviews (
  ReviewID int,
  ReviewContent varchar(255) NOT NULL,
  ReviewGrade int,
  AirlineID int,
  CustomerID int,
  CONSTRAINT PK_CustomerReviews PRIMARY KEY(ReviewID)
)

ALTER TABLE CustomerReviews
ADD CONSTRAINT FK_CustomerReviews_Airlines
    FOREIGN KEY (AirlineID)
    REFERENCES Airlines(AirlineID)

ALTER TABLE CustomerReviews
ADD CONSTRAINT FK_CustomerReviews_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

CREATE TABLE CustomerBankAccounts (
  AccountID int,
  AccountNumber varchar(10) UNIQUE NOT NULL,
  Balance decimal(10, 2) NOT NULL,
  CustomerID int,
  CONSTRAINT PK_CustomerBankAccounts PRIMARY KEY(AccountID)
)

ALTER TABLE CustomerBankAccounts
ADD CONSTRAINT FK_CustomerBankAccounts_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

---------------------------------------------------------------------------------------------------------------------
-- Section 2, Task 5

INSERT INTO CustomerReviews(ReviewID, ReviewContent, 
							ReviewGrade, AirlineID, CustomerID)
VALUES
 (1, 'Me is very happy. Me likey this airline. Me good.',  10, 1, 1), 
 (2, 'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4), 
 (3, 'Meh...', 5, 4, 3), 
 (4, 'Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5) 

INSERT INTO CustomerBankAccounts(AccountID, AccountNumber, Balance, CustomerID)
VALUES
 (1, '123456790', 2569.23, 1), 
 (2, '18ABC23672', 14004568.23, 2), 
 (3, 'F0RG0100N3', 19345.20, 5)

 --------------------------------------------------------------------------------------------------------------------

 --Section 3, Task 1
 
 SELECT TicketID, Price, Class, Seat
 FROM Tickets
 ORDER BY TicketID

 ------------------------------------------------------------------------------------------------

  --Section 3, Task 2

 SELECT CustomerID, FirstName + ' ' + LastName AS FullName, Gender
 FROM Customers
 ORDER BY FullName, CustomerID

  ------------------------------------------------------------------------------------------------

  --Section 3, Task 3

 SELECT FlightID, DepartureTime, ArrivalTime
 FROM Flights
 WHERE Status = 'Delayed'
 ORDER BY FlightID

  ------------------------------------------------------------------------------------------------

 --Section 3, Task 4

 SELECT DISTINCT TOP 5 a.AirlineId, a.AirlineName, a.Nationality, a.Rating 
 FROM Airlines a
 INNER JOIN Flights f
 ON a.AirlineID = f.AirlineID
 ORDER BY a.Rating DESC, a.AirlineID

  ------------------------------------------------------------------------------------------------

 --Section 3, Task 5

 SELECT t.TicketID, 
		a.AirportName AS Destination,
		c.FirstName + ' ' + c.LastName AS CustomerName 
 FROM Tickets t
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 INNER JOIN Airports a
 ON f.DestinationAirportID = a.AirportID
 INNER JOIN Customers c
 ON t.CustomerID = c.CustomerID
 WHERE t.Price < 5000 
		AND t.Class = 'First'
ORDER BY t.TicketID 	

  ------------------------------------------------------------------------------------------------

 --Section 3, Task 6

 SELECT c.CustomerID,
		c.FirstName + ' ' + c.LastName AS FullName,
		towns.TownName AS HomeTown
 FROM Tickets t
 INNER JOIN Customers c
 ON t.CustomerID = c.CustomerID
 INNER JOIN Towns towns
 ON c.HomeTownID = towns.TownID
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 INNER JOIN Airports a
 ON f.DestinationAirportID = a.AirportID
 INNER JOIN Towns towns2
 ON a.TownID = towns2.TownID
 WHERE towns2.TownName = towns.TownName
ORDER BY c.CustomerID	

------------------------------------------------------------------------------------------------

 --Section 3, Task 7

SELECT  c.CustomerID,
		c.FirstName + ' ' + c.LastName AS FullName,
		DATEDIFF(YEAR, c.DateOfBirth, '01-01-2016') AS Age
 FROM Tickets t
 INNER JOIN Customers c
 ON t.CustomerID = c.CustomerID
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 WHERE f.Status = 'Departing'
 ORDER BY c.CustomerID

 ------------------------------------------------------------------------------------------------

 --Section 3, Task 8

 SELECT TOP 3 c.CustomerID,
		c.FirstName + ' ' + c.LastName AS FullName,
		t.Price AS TicketPrice, 
		a.AirportName AS Destination
 FROM Tickets t
 INNER JOIN Customers c
 ON t.CustomerID = c.CustomerID
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 INNER JOIN Airports a
 ON f.DestinationAirportID = a.AirportID
 WHERE f.Status = 'Delayed'
ORDER BY t.Price DESC, c.CustomerID	

------------------------------------------------------------------------------------------------

 --Section 3, Task 9

 SELECT TOP 5 *
 FROM
 (SELECT f.FlightID, f.DepartureTime, f.ArrivalTime,
		ori.AirportName AS Origin,
		dest.AirportName AS Destination
 FROM Flights f
 INNER JOIN Airports ori
 ON f.DestinationAirportID = ori.AirportID
 INNER JOIN Airports dest
 ON f.OriginAirportID = dest.AirportID) AS q
 ORDER BY q.DepartureTime DESC, q.FlightID

 ------------------------------------------------------------------------------------------------

 --Section 3, Task 10

 SELECT q.CustomerID, q.FullName, q.Age
 FROM
 (SELECT c.CustomerID,
		c.FirstName + ' ' + c.LastName AS FullName,
		DATEDIFF(YEAR, c.DateOfBirth, '01-01-2016') AS Age
 FROM Tickets t
 INNER JOIN Customers c
 ON t.CustomerID = c.CustomerID
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 WHERE f.Status = 'Arrived') AS q
 WHERE q.Age < 21
 ORDER BY q.CustomerID

 ------------------------------------------------------------------------------------------------

 --Section 3, Task 11

 SELECT q.AirportID, q.AirportName, COUNT(q.AirportName) AS Passengers
 FROM
 (SELECT dest.AirportID, dest.AirportName
 FROM Tickets t
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 INNER JOIN Airports dest
 ON f.DestinationAirportID = dest.AirportID
 WHERE f.Status = 'Departing'
 UNION ALL
 SELECT ori.AirportID,ori.AirportName
 FROM Tickets t
 INNER JOIN Flights f
 ON t.FlightID = f.FlightID
 INNER JOIN Airports ori
 ON f.OriginAirportID = ori.AirportID
 WHERE f.Status = 'Departing') AS q
 GROUP BY q.AirportID, q.AirportName
 ORDER BY q.AirportID

 ------------------------------------------------------------------------------------------------

 --Section 4, Task 1

CREATE PROCEDURE usp_SubmitReview(@customerId int, @content varchar(255), @grade int, @airlineName varchar(30))
AS
BEGIN 
	
	DECLARE @airlineId int
	DECLARE @reviewId INT = ABS(CHECKSUM(NEWID())) % 1000000 + 1

	BEGIN TRAN
	
	SET @airlineId = (SELECT AirlineId
				     FROM Airlines
	                 WHERE AirlineName = @airlineName)

	IF NOT EXISTS (SELECT AirlineId
				   FROM Airlines
	               WHERE AirlineName = @airlineName)
	BEGIN
		RAISERROR('Airline does not exist.', 16, 1)
		ROLLBACK
	END	 
	ELSE
	BEGIN
		INSERT INTO CustomerReviews(ReviewID, ReviewContent, ReviewGrade,
							        AirlineID, CustomerID)
		VALUES (@reviewId, @content, @grade, @airlineId, @customerId)
		COMMIT
	END	   	
END
GO

------------------------------------------------------------------------------------------------

 --Section 4, Task 2

 CREATE PROCEDURE usp_PurchaseTicket(@customerId int, @flightId int, @ticketPrice decimal(8, 2), 
		@class varchar(6), @seat varchar(5))
AS
BEGIN 
	
	DECLARE @customerBalance decimal(10, 2)
	DECLARE @ticketId INT = ABS(CHECKSUM(NEWID())) % 1000000 + 1

	BEGIN TRAN
	
	SET @customerBalance = (SELECT Balance
							FROM CustomerBankAccounts
							WHERE CustomerID = @customerId)

	IF (@ticketPrice > @customerBalance)
	BEGIN
		RAISERROR('Insufficient bank account balance for ticket purchase.', 16, 1)
		ROLLBACK
	END	 
	ELSE
	BEGIN
		INSERT INTO Tickets(TicketID, Price, Class, Seat)
		VALUES (@ticketId, @ticketPrice, @class, @seat, @customerId, @flightId)

		UPDATE CustomerBankAccounts
		SET Balance = Balance - @ticketPrice
		WHERE CustomerID = @customerId

		COMMIT
	END	   	
END
GO