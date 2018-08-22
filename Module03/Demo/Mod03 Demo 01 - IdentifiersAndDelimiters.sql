/* MODULE 3 DEMO 1: Identifiers and Delimiters

==== START SETUP ==== */

-- Check to see if a table called dbo.MyProject exists in tempdb. If it does, delete it.
USE tempdb
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'MyProject')
	DROP TABLE dbo.MyProject

-- Create the dbo.MyProject table
CREATE TABLE dbo.MyProject
(ProjectID int IDENTITY(1,1) PRIMARY KEY
, [Project Name] varchar(50) NOT NULL
, [Status] tinyint NOT NULL
, [From] date NULL
, [To] date NULL)

-- Insert two rows into the dbo.MyProject table
INSERT INTO dbo.MyProject
([Project Name], [Status], [From], [To])
VALUES ('Train staff', 8, '3/10/2014', '3/14/2014'),
       ('Bring DW online', 25, '4/7/2014', NULL)

/* ==== END SETUP ====

There are three delimiters that SQL Server recognizes:

1. Single quotes (used for literal string values)
2. Square brackets (used for object names; aka identifiers)
3. Double quotes (used for literal string values or identifiers)

-- 1. SINGLE QUOTES

The following Select statement displays a literal string whose
value is what is inside the single quotes. The single quote
delimiter is used for literal string values. */ 

SELECT 'Hello, world!'

-- 2. SQUARE BRACKETS

/* Identifiers must either adhere to naming rules or must be
delimited. Here are the naming rules:

1. Identifiers must begin with an alphabetic character
2. Identifiers must not contain spaces
3. Identifiers must not be T-SQL reserved words

Now, here is a sample project table. Notice that the column names 
break identifier naming rules. */

USE tempdb
SELECT * FROM dbo.MyProject

/* 3. DOUBLE QUOTES

To refer to column names that break naming rules we use
either square brackets or double quotes for delimiters. */

SELECT "Project Name"
, [Status]
, [From]
, [To]
FROM dbo.MyProject

/* Double-quotes can also be used for literal string values,
just like the single quote as long as you flip a switch in 
SQL Server. Tell SQL Server to use double quotes for literal 
string values instead of identifiers. */

SET QUOTED_IDENTIFIER OFF

/* Run the same query and notice that the double-quotes are now
interpreted by SQL Server as delimiters for literal string values,
just like the single quotes.
*/

SELECT "Project Name"
, [Status]
, [From]
, [To]
FROM dbo.MyProject

-- Turn the switch on to use double quotes for identifiers 

SET QUOTED_IDENTIFIER ON

-- CLEANUP

USE tempdb
DROP TABLE dbo.MyProject

