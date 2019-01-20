-- CREATE WINDOWS DIRECTORY FOR DB FILES
USE Master;
GO
SET NOCOUNT ON

-- 1 - Variable declaration
DECLARE @DBName sysname
DECLARE @DataPath nvarchar(500)
DECLARE @LogPath nvarchar(500)
DECLARE @DirTree TABLE (subdirectory nvarchar(255), depth INT)

-- 2 - Initialize variables
SET @DBName = 'PADemos'
SET @DataPath = 'C:\PADemos\' + @DBName

-- 3 - @DataPath values
INSERT INTO @DirTree(subdirectory, depth)
EXEC master.sys.xp_dirtree @DataPath

-- 4 - Create the @DataPath directory
IF NOT EXISTS (SELECT 1 FROM @DirTree WHERE subdirectory = @DBName)
EXEC master.dbo.xp_create_subdir @DataPath

GO

-- CREATE THE DATABASE

CREATE DATABASE PADemos
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PADemos', FILENAME = N'C:\PADemos\PADemos.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PADemos_log', FILENAME = N'C:\PADemos\PADemos_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

-- CREATE THE SCHEMA

USE PADemos
GO

CREATE SCHEMA [Profiles] AUTHORIZATION [dbo]
GO

-- CREATE THE TABLE

CREATE TABLE [Profiles].[ProfileRecordLab](
	[LineNumber] [int] IDENTITY(1,1) PRIMARY KEY,
	[Profile] [int] NOT NULL,
	[Record] [char](1) NOT NULL,
	[LabNumber] [tinyint] NOT NULL,
	[DT_Specimen] [date] NOT NULL,
)
GO

-- CREATE THE VIEW

CREATE VIEW [Profiles].[vMinMaxGap]
AS
WITH 
MinMaxPerProfileAndRecord AS
(SELECT [Profile], Record, MIN(DT_Specimen) MinDT, MAX(DT_Specimen) MaxDT
 FROM [Profiles].[ProfileRecordLab]
 GROUP BY [Profile], Record)
,
TwoRecsPerProfile AS
(SELECT TOP 100 PERCENT
 ROW_NUMBER() OVER(PARTITION BY [Profile] ORDER BY MinDT, MaxDT) AS RowNum
 , *
 FROM MinMaxPerProfileAndRecord tA
 WHERE MinDT = (SELECT MIN(MinDT)
                FROM MinMaxPerProfileAndRecord
				WHERE [Profile] = tA.[Profile])
   OR  MaxDT = (SELECT MAX(MaxDT)
                FROM MinMaxPerProfileAndRecord
				WHERE [Profile] = tA.[Profile])
 ORDER BY [Profile], RowNum
)
 SELECT EvenRows.[Profile]
 , OddRows.Record [MinDT Record]
 , OddRows.MinDT MinDT
 , EvenRows.Record [MaxDT Record]
 , EvenRows.MaxDT MaxDT
 , DATEDIFF(DAY, OddRows.MinDT, EvenRows.MaxDT) DaysApart 
 FROM (SELECT * FROM TwoRecsPerProfile WHERE RowNum%2 = 0) EvenRows
 JOIN (SELECT * FROM TwoRecsPerProfile WHERE RowNum%2 = 1) OddRows
   ON EvenRows.[Profile] = OddRows.[Profile]
      AND EvenRows.RowNum = OddRows.RowNum + 1
	  AND EvenRows.Record <> Oddrows.Record
GO

-- POPULATE THE TABLE

SET IDENTITY_INSERT [Profiles].[ProfileRecordLab] ON 

INSERT [Profiles].[ProfileRecordLab] ([LineNumber], [Profile], [Record], [LabNumber], [DT_Specimen]) 
  VALUES (1, 5240, N'A', 1, CAST(N'2018-05-01' AS Date))
       , (2, 5240, N'A', 2, CAST(N'2018-05-15' AS Date))
	   , (3, 5240, N'B', 1, CAST(N'2018-05-20' AS Date))
	   , (4, 5240, N'B', 2, CAST(N'2018-05-25' AS Date))
	   , (5, 5240, N'C', 1, CAST(N'2018-06-01' AS Date))
	   , (6, 5240, N'C', 2, CAST(N'2018-06-15' AS Date))
	   , (7, 5241, N'A', 1, CAST(N'2018-06-01' AS Date))
	   , (8, 5241, N'B', 1, CAST(N'2018-06-05' AS Date))

SET IDENTITY_INSERT [Profiles].[ProfileRecordLab] OFF
GO


