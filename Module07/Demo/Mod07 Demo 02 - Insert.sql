/* MODULE 7 DEMO 2: Insert

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

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'SalesOrder')
	DROP TABLE dbo.SalesOrder

SELECT *
INTO dbo.SalesOrder
FROM AdventureWorks.Sales.SalesOrderHeader
WHERE 1=0

/* ==== END SETUP ==== 

This insert statement attempts to insert 5 rows into the 
Customer table, but it will generate an error because of
the attempt to insert a value into an identity column. */

INSERT INTO dbo.Customer (CustomerID, CustomerName, Terms, CreditLimit, ModifiedDate)
  VALUES (1, 'Brenda Harris', 2, 15000, DEFAULT)
		,(2, 'Robyn Saltaeda', 6, 25000, DEFAULT)
		,(3, 'Nadju Vengue', 2, NULL, DEFAULT)
		,(4, 'Oshta Ohda', NULL, DEFAULT, DEFAULT)
		,(5, 'Ken Barbosa', 3, 18500, DEFAULT)

/* There are two ways to solve this problem. One option is to
flip a switch in SQL Server called IDENTITY_INSERT that will 
tell SQL Server to allow values to be inserted into identity 
columns. Here's what that would look like:

SET IDENTITY_INSERT <table> ON

By default, that switch is off. The other option is to "back 
off" and let SQL Server handle those inserts. 

The statement below no longer includes the customer ids. We've 
also removed the ModifiedDate column since we were just 
inserting the default value into all the rows. SQL Server will 
do that automatically, too. */

INSERT INTO dbo.Customer(CustomerName, Terms, CreditLimit)
  VALUES ('Brenda Harris', 2, 15000)
		,('Robyn Saltaeda', 6, 25000)
		,('Nadju Vengue', 2, NULL)
		,('Oshta Ohda', NULL, DEFAULT)
		,('Ken Barbosa', 3, 18500)

SELECT * FROM dbo.Customer

/* This next statement inserts a single row into the Customer
table but supplies only a customer name. Can you guess what will 
go into each of the other columns? */
		
INSERT INTO dbo.Customer(CustomerName)
  VALUES ('Nick Johnson')

SELECT * FROM dbo.Customer

/* This statement will insert all rows from the sales order table
in the AdventureWorks database into the SalesOrder table as long
as they are one of the customers already in the Customer table. */

SET IDENTITY_INSERT dbo.SalesOrder ON

INSERT INTO dbo.SalesOrder ([SalesOrderID]
      ,[RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[SalesOrderNumber]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[ContactID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[TotalDue]
      ,[Comment]
      ,[rowguid]
      ,[ModifiedDate])
OUTPUT INSERTED.*
SELECT * FROM AdventureWorks.Sales.SalesOrderHeader
WHERE CustomerID IN (SELECT CustomerID
                     FROM dbo.Customer)

-- Cleanup

DROP TABLE dbo.Customer
DROP TABLE dbo.SalesOrder