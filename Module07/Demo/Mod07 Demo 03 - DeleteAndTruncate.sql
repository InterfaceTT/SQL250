/* MODULE 7 DEMO 3: Delete and Truncate

==== START SETUP ==== */

USE tempdb

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Customer')
	DROP TABLE dbo.Customer

CREATE TABLE dbo.Customer
(CustomerID int IDENTITY(1,1) PRIMARY KEY
,CustomerName nvarchar(20) NOT NULL
,Terms tinyint NULL
,CreditLimit decimal(7, 2) NULL
	CONSTRAINT DF_CreditLimit DEFAULT (5000)
,ModifiedDate smalldatetime NOT NULL
	CONSTRAINT DF_ModifiedDate DEFAULT (GETDATE())
 )

INSERT INTO dbo.Customer(CustomerName, Terms, CreditLimit)
  VALUES ('Brenda Harris', 2, 15000)
		,('Robyn Saltaeda', 6, 25000)
		,('Nadju Vengue', 2, NULL)
		,('Oshta Ohda', NULL, DEFAULT)
		,('Ken Barbosa', 3, 18500)

/* ==== END SETUP ==== 

The DELETE command writes all rows it deletes to the
transaction log and does not reset the identity counter.
*/

-- Notice the last CustomerID
SELECT * FROM dbo.Customer

-- Delete all the rows in the Customer table
DELETE FROM dbo.Customer

-- Verify that the table is empty
SELECT * FROM dbo.Customer

-- Insert a new row into the Customer table
INSERT INTO dbo.Customer(CustomerName)
  VALUES ('Brenda Harris')

-- Notice that the identity counter was not reset
SELECT * FROM dbo.Customer

-- Truncate the table
TRUNCATE TABLE dbo.Customer

-- Verify that the table is empty
SELECT * FROM dbo.Customer

-- Insert a new row into the Customer table
INSERT INTO dbo.Customer(CustomerName)
  VALUES ('Brenda Harris')

-- Notice that the identity counter was reset
SELECT * FROM dbo.Customer

-- Cleanup

DROP TABLE dbo.Customer
