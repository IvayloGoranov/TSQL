---------------------------------------------------------------------

INSERT INTO Buildings (BuildingName)
VALUES ('Metal mine'), ('Crystal mine'), ('Fusion reactor')

---------------------------------------------------------------------

INSERT INTO BuildingLevels (BuildingId, Id, Metal, Crystal)
SELECT Id, 1, 1000, 500 
FROM Buildings 

---------------------------------------------------------------------

DECLARE @I int = 1
WHILE @I < 10 BEGIN
	SET @I = @I + 1
	INSERT INTO BuildingLevels (BuildingId, Id, Metal, Crystal)
	SELECT 1, MAX(Id) + 1, MAX(Metal) * 1.2, MAX(Crystal) * 1.2
	FROM BuildingLevels
	WHERE BuildingId = 1
END
GO
