/* MODULE 7 DEMO 4: Merge

==== START SETUP ==== */

USE tempdb

IF OBJECT_ID('dbo.Dog', 'U') IS NOT NULL
  DROP TABLE dbo.Dog;

CREATE TABLE dbo.Dog
(
	dogID INT NOT NULL PRIMARY KEY,
	Name NVARCHAR(25) NOT NULL,
	BirthDate DATE NULL,
	DeathDate DATE NULL,
	Weight INT NULL,
	HarnessSize NVARCHAR(10)
);

INSERT INTO dbo.Dog
(dogID, Name, BirthDate, DeathDate, Weight, HarnessSize)
OUTPUT inserted.*
VALUES
	(1, 'Jewel', NULL, NULL, 42, 'RedGreen'),
	(2, 'Mardy', '19970630', NULL, 62, 'Yellow'),
	(3, 'Izzi', '6/30/2001', NULL, 44, 'Red'),
	(4, 'Topaz', '5/1/2006', '5/21/2006', 53, 'BlueYellow');
	
IF OBJECT_ID('dbo.DogUpdate', 'U') IS NOT NULL
  DROP Table dbo.DogUpdate;

CREATE TABLE dbo.DogUpdate  (
	dogID INT NOT NULL,
	Name NVARCHAR(25) NOT NULL,
	BirthDate DATE NULL,
	DeathDate DATE NULL,
	Weight INT NULL,
	HarnessSize NVARCHAR(10)
)

INSERT INTO dbo.DogUpdate
(dogID, Name, BirthDate, DeathDate, Weight, HarnessSize)
OUTPUT inserted.*
VALUES
	(2, 'Mardy', '6/30/1997', NULL, 62, 'Yellow'),
	(3, 'Izzi', '6/30/2001', NULL, 39, 'RedGreen'),
	(5, 'Raja', NULL, NULL, 42, 'RedGreen');

/* ==== END SETUP ==== 

Verify the tables to be used by the upcoming MERGE */

USE tempdb

SELECT * FROM dbo.Dog
SELECT * FROM dbo.DogUpdate

-- Merge the updates into the Dog table 

MERGE dbo.Dog AS Target

USING  dbo.DogUpdate AS Source
	ON (Target.dogID = Source.dogID)
	
WHEN MATCHED THEN
	UPDATE 
		SET Target.Name = Source.Name, 
			Target.BirthDate = Source.BirthDate, 
			Target.DeathDate = Source.DeathDate,
			Target.Weight = Source.Weight,
			Target.HarnessSize = Source.HarnessSize
			
WHEN NOT MATCHED THEN
	INSERT (dogID, Name, Birthdate, DeathDate, Weight, HarnessSize)
	VALUES (Source.dogID, Source.Name, Source.Birthdate, Source.DeathDate, 
		Source.Weight, Source.HarnessSize)
		
OUTPUT $action, Inserted.*, Deleted.*; -- A MERGE statement must be
                                       -- terminated by a semi-colon

-- Observe the results in the Dog table

SELECT * FROM dbo.Dog
GO

/* Notice that Mardy didn't actually have any changes 
but was updated anyway.

Cleanup */

USE tempdb

DROP TABLE dbo.Dog
DROP TABLE dbo.DogUpdate

