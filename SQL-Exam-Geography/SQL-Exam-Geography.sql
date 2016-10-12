/*Find all rivers that pass through to 3 or more countries. 
Display the river name and the number of countries. 
Sort the results by river name. */

SELECT RiverName AS River,
	   COUNT(cr.CountryCode) AS [Countries Count]
FROM Rivers r
INNER JOIN CountriesRivers cr
ON cr.RiverId = r.Id
GROUP BY RiverName
HAVING COUNT(cr.CountryCode) >= 3
ORDER BY RiverName

---------------------------------------------------------------------------
/*For each country in the database, display the number of rivers passing through 
that country and the total length of these rivers. When a country does not have any river, 
display 0 as rivers count and as total length. 
Sort the results by rivers count (from largest to smallest), 
then by total length (from largest to smallest), then by country alphabetically. 
*/

SELECT
  c.CountryName, ct.ContinentName,
  COUNT(r.RiverName) AS RiversCount,
  ISNULL(SUM(r.Length), 0) AS TotalLength
FROM
  Countries c
  LEFT JOIN Continents ct ON ct.ContinentCode = c.ContinentCode
  LEFT JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers r ON r.Id = cr.RiverId
GROUP BY c.CountryName, ct.ContinentName
ORDER BY RiversCount DESC, TotalLength DESC, CountryName

---------------------------------------------------------------------------
/*For each continent, display the total area and total population of all its countries. 
Sort the results by population from highest to lowest. */

SELECT
  ct.ContinentName,
  SUM(CONVERT(bigint, c.AreaInSqKm)) AS CountriesArea,
  SUM(CONVERT(bigint, c.Population)) AS CountriesPopulation
FROM
  Countries c
  LEFT JOIN Continents ct ON ct.ContinentCode = c.ContinentCode
GROUP BY ct.ContinentName
ORDER BY CountriesPopulation DESC

---------------------------------------------------------------------------
/*Combine all peak names with all river names, so that the last letter of each peak name 
is the same like the first letter of its corresponding river name. 
Display the peak names, river names, and the obtained mix. 
Sort the results by the obtained mix. 
*/

SELECT 
  p.PeakName, 
  r.RiverName, 
  LOWER(p.PeakName + SUBSTRING(r.RiverName, 2, LEN(r.RiverName))) AS Mix
FROM Peaks p, Rivers r
WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY Mix

---------------------------------------------------------------------------
/*For each country, find the name and elevation of the highest peak, along with its mountain. 
When no peaks are available in some country, display elevation 0, 
"(no highest peak)" as peak name and "(no mountain)" as mountain name. 
When multiple peaks in some country have the same elevation, display all of them. 
Sort the results by country name alphabetically, then by highest peak name alphabetically.
*/

SELECT
  c.CountryName AS [Country],
  p.PeakName AS [Highest Peak Name],
  p.Elevation AS [Highest Peak Elevation],
  m.MountainRange AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE p.Elevation =
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode)
UNION
SELECT
  c.CountryName AS [Country],
  '(no highest peak)' AS [Highest Peak Name],
  0 AS [Highest Peak Elevation],
  '(no mountain)' AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE 
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode) IS NULL
ORDER BY c.CountryName, [Highest Peak Name]

---------------------------------------------------------------------------
/*Create a stored function fn_MountainsPeaksJSON that lists all mountains alphabetically along with 
all its peaks alphabetically. Format the output as JSON string without any whitespace
*/

IF OBJECT_ID('fn_MountainsPeaksJSON') IS NOT NULL
  DROP FUNCTION fn_MountainsPeaksJSON
GO

CREATE FUNCTION fn_MountainsPeaksJSON()
	RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @json NVARCHAR(MAX) = '{"mountains":['

	DECLARE montainsCursor CURSOR FOR
	SELECT Id, MountainRange FROM Mountains

	OPEN montainsCursor
	DECLARE @mountainName NVARCHAR(MAX)
	DECLARE @mountainId INT
	FETCH NEXT FROM montainsCursor INTO @mountainId, @mountainName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @json = @json + '{"name":"' + @mountainName + '","peaks":['

		DECLARE peaksCursor CURSOR FOR
		SELECT PeakName, Elevation FROM Peaks
		WHERE MountainId = @mountainId

		OPEN peaksCursor
		DECLARE @peakName NVARCHAR(MAX)
		DECLARE @elevation INT
		FETCH NEXT FROM peaksCursor INTO @peakName, @elevation
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @json = @json + '{"name":"' + @peakName + '",' +
				'"elevation":' + CONVERT(NVARCHAR(MAX), @elevation) + '}'
			FETCH NEXT FROM peaksCursor INTO @peakName, @elevation
			IF @@FETCH_STATUS = 0
				SET @json = @json + ','
		END
		CLOSE peaksCursor
		DEALLOCATE peaksCursor
		SET @json = @json + ']}'

		FETCH NEXT FROM montainsCursor INTO @mountainId, @mountainName
		IF @@FETCH_STATUS = 0
			SET @json = @json + ','
	END
	CLOSE montainsCursor
	DEALLOCATE montainsCursor

	SET @json = @json + ']}'
	RETURN @json
END
GO