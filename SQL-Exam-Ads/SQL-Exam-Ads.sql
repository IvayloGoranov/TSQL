/*Find all not published ads, created in the same month and year like 
the earliest ad. Display for each ad its id, 
title, date and status. Sort the results by Id*/

SELECT a.Id, Title, Date, Status
FROM Ads a 
INNER JOIN AdStatuses s 
ON a.StatusId = s.Id
WHERE MONTH(Date) = (SELECT MONTH(MIN(Date)) 
					 FROM Ads)
	  AND YEAR(Date) = (SELECT YEAR(MIN(Date)) 
				  FROM Ads)
      AND Status <> 'Published'
ORDER BY a.Id

---------------------------------------------------------
/*Find the count of ads for each user. Display the username, 
ads count and "yes" or "no" depending on whether the user 
belongs to the role "Administrator". Sort the results by username. Display all users, 
including the users who have no ads. */

SELECT 
  MIN(u.UserName) as UserName, 
  COUNT(a.Id) as AdsCount,
  (CASE WHEN admins.UserName IS NULL THEN 'no' ELSE 'yes' END) AS IsAdministrator
FROM 
  AspNetUsers u
  LEFT JOIN Ads a ON u.Id = a.OwnerId
  LEFT JOIN (
    SELECT DISTINCT u.UserName
	FROM AspNetUsers u
	  LEFT JOIN AspNetUserRoles ur ON ur.UserId = u.Id
	  LEFT JOIN AspNetRoles r ON ur.RoleId = r.Id
	WHERE r.Name = 'Administrator'
  ) AS admins ON u.UserName = admins.UserName
GROUP BY OwnerId, u.UserName, admins.UserName
ORDER BY u.UserName

---------------------------------------------------------
/*Find the count of ads for each town. 
Display the ads count and town name or "(no town)" for the ads without a town. 
Display only the towns, which hold 2 or 3 ads. Sort the results by town name.  */

SELECT
  COUNT(a.Id) as AdsCount,
  ISNULL(t.Name, '(no town)') as Town
FROM
  Ads a
  LEFT JOIN Towns t ON a.TownId = t.Id
GROUP BY t.Name
HAVING COUNT(a.Id) BETWEEN 2 AND 3
ORDER BY t.Name

---------------------------------------------------------
/*Consider the dates of the ads. Find among them all pairs of different dates, 
such that the second date is no later than 12 hours after the first date. 
Sort the dates in increasing order by the first date, then by the second date.*/

SELECT a1.Date AS FirstDate, a2.Date AS SecondDate
FROM Ads a1, Ads a2
WHERE
  a2.Date > a1.Date AND
  a2.Date <= (DATEADD(HOUR, 12, a1.Date))
ORDER BY a1.Date, a2.Date

---------------------------------------------------------
/*Find the count of ads for each town. 
Display the ads count, the town name and the country name. 
Include also the ads without a town and country. Sort the results by town, then by country.*/

SELECT
  t.Name as Town,
  c.Name as Country,
  COUNT(a.Id) as AdsCount
FROM
  Ads a
  FULL OUTER JOIN Towns t ON a.TownId = t.Id
  FULL OUTER JOIN Countries c ON t.CountryId = c.Id
GROUP BY t.Name, c.Name
ORDER BY t.Name, c.Name 

---------------------------------------------------------
/*Create a view "AllAds" in the database that holds information about ads: 
id, title, author (username), date, town name, category name and status, sorted by id.
Using the view above, create a stored function "fn_ListUsersAds" that returns a table, 
holding all users in descending order as first column, 
along with all dates of their ads (in ascending order) in format "yyyyMMdd", separated by "; " as second column
*/

CREATE VIEW AllAds
AS
SELECT 
  a.Id,
  a.Title, 
  u.UserName AS Author,
  a.Date,
  t.Name AS Town, 
  c.Name AS Category,
  s.Status AS Status
FROM
  Ads a
  LEFT JOIN Towns t on a.TownId = t.Id
  LEFT JOIN Categories c on a.CategoryId = c.Id
  LEFT JOIN AdStatuses s on a.StatusId = s.Id
  LEFT JOIN AspNetUsers u on u.Id = a.OwnerId

  SELECT * FROM AllAds

IF (object_id(N'fn_ListUsersAds') IS NOT NULL)
DROP FUNCTION fn_ListUsersAds
GO

CREATE FUNCTION fn_ListUsersAds()
	RETURNS @tbl_UsersAds TABLE(
		UserName NVARCHAR(MAX),
		AdDates NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE UsersCursor CURSOR FOR
		SELECT UserName FROM AspNetUsers
		ORDER BY UserName DESC;
	OPEN UsersCursor;
	DECLARE @username NVARCHAR(MAX);
	FETCH NEXT FROM UsersCursor INTO @username;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ads NVARCHAR(MAX) = NULL;
		SELECT
			@ads = CASE
				WHEN @ads IS NULL THEN CONVERT(NVARCHAR(MAX), Date, 112)
				ELSE @ads + '; ' + CONVERT(NVARCHAR(MAX), Date, 112)
			END
		FROM AllAds
		WHERE Author = @username
		ORDER BY Date;

		INSERT INTO @tbl_UsersAds
		VALUES(@username, @ads)
		
		FETCH NEXT FROM UsersCursor INTO @username;
	END;
	CLOSE UsersCursor;
	DEALLOCATE UsersCursor;
	RETURN;
END
GO

SELECT * FROM fn_ListUsersAds()