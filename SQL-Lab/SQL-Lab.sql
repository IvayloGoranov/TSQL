
/*Create a view "AllQuestions" in the database that holds 
information about questions and users. Using the view, 
create a stored function "fn_ListUsersQuestions" 
that returns a table, holding all users in descending order as first column, 
along with all titles of their questions (in ascending order), separated by ", " 
as second column */

USE Forum
GO

CREATE VIEW vw_AllQuestions 
AS
SELECT u.Id, u.UserName, u.FirstName, u.LastName, 
	   u.Email, u.PhoneNumber, u.RegistrationDate,
	   q.Title, q.Content, q.CategoryID, q.CreatedOn
FROM Users u
INNER JOIN Questions q
ON u.Id = q.UserId
GO

CREATE FUNCTION fn_ListUsersQuestions() RETURNS TABLE
AS
RETURN (
  SELECT a.UserName, Questions
  FROM (SELECT UserName, 
		 COALESCE(Title + ', ', '') + ISNULL(Title, NULL) AS Questions
  FROM vw_AllQuestions
  GROUP BY UserName, Title) AS a
  GROUP BY a.UserName
  ORDER BY a.UserName
)
GO

---------------------------------------------------------------------

CREATE TABLE Towns (
  Id int IDENTITY,
  Name nvarchar(100) NOT NULL,
  CONSTRAINT PK_Towns PRIMARY KEY(Id)
)

ALTER TABLE Users
ADD TownId int

ALTER TABLE Users
ADD CONSTRAINT FK_Users_Towns
    FOREIGN KEY (TownId)
    REFERENCES Towns(Id)

INSERT INTO Towns(Name) 
VALUES ('Sofia'), ('Berlin'), ('Lyon')

UPDATE Users 
SET TownId = (SELECT Id 
			  FROM Towns 
			  WHERE Name='Sofia')

INSERT INTO Towns 
VALUES ('Munich'), ('Frankfurt'), ('Varna'), ('Hamburg'), 
	   ('Paris'), ('Lom'), ('Nantes')

UPDATE Users 
SET TownId = (SELECT Id
			  FROM Towns
			  WHERE Name = 'Paris')
WHERE TownId IN (SELECT TownId 
			  FROM Users 
			  WHERE DATEPART(DAY, RegistrationDate) = 5)

UPDATE Questions
SET Title = 'Java += operator'
WHERE Id = (SELECT a.QuestionId
		    FROM Answers a
			INNER JOIN Questions q
			ON a.QuestionId = q.Id
			WHERE (DATEPART(DAY, a.CreatedOn) = 1
				   OR DATEPART(DAY, a.CreatedOn) = 7)
	               AND DATEPART(MONTH, a.CreatedOn) = 2)	

DECLARE @userId INT
SET @userId = (SELECT Id
              FROM Users
              WHERE Username = 'darkcat')

DECLARE @categoryId INT
SET @categoryId = (SELECT Id
		          FROM Categories
		          WHERE Name = 'Databases')
 
INSERT INTO Questions(Title, Content, CreatedOn, UserId, CategoryId) 
VALUES (('Fetch NULL values in PDO query'), 
	   ('When I run the snippet, NULL values are converted to empty strings. How can fetch NULL values?", '), 
	   GETDATE(), @userId, @categoryId)

SELECT t.Name, ua.Username, ua.AnswersCount
FROM Towns t
INNER JOIN (SELECT u.Username, a.UserId, u.TownId, COUNT(*) AS AnswersCount
			FROM Users u
			JOIN Answers a
			ON u.Id = a.UserId
			GROUP BY u.Username, a.UserId, u.TownId) ua
ON ua.TownId = t.Id





			      