-- MODULE 8 DEMO 6A: Stored Procedure with UDT

USE tempdb

/* If the tables exist, the SOD table must be dropped
first due to the referential integrity constraint between
the SOD and SOH tables. The must be created in the 
opposite order for the same reason. */

IF OBJECT_ID('dbo.SalesOrderDetail', 'U') IS NOT NULL  
     DROP TABLE dbo.SalesOrderDetail

IF OBJECT_ID('dbo.SalesOrderHeader', 'U') IS NOT NULL  
     DROP TABLE dbo.SalesOrderHeader
 GO

-- The SOH table will hold order data.

CREATE TABLE dbo.SalesOrderHeader
(
	SalesOrderID	int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	OrderDate		date NOT NULL
		CONSTRAINT DF_OrderDate DEFAULT (GETDATE()),
	Terms			varchar(5) NULL

)
GO

/* The SOD table will hold order line items. */

CREATE TABLE dbo.SalesOrderDetail(
	SalesOrderDetailID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	SalesOrderID int NULL FOREIGN KEY REFERENCES SalesOrderHeader(SalesOrderID) ON DELETE CASCADE,
	ProductID int NOT NULL,
	OrderQty int NOT NULL)
GO

/* The stored procedure must be deleted before the user defined 
type that holds line items. This is because of the proc's 
dependency on the type, but it must also be created after the 
udt for the same reason. */

IF OBJECT_ID('dbo.SaveInvoice', 'P') IS NOT NULL  
     DROP PROCEDURE dbo.SaveInvoice; 

IF TYPE_ID(N'SalesOrderDetailUDT') IS NOT NULL
	DROP TYPE dbo.SalesOrderDetailUDT

CREATE TYPE dbo.SalesOrderDetailUDT AS TABLE
(ProductID int NOT NULL,
OrderQty int NOT NULL)
GO

/* Create the stored procedure that saves to both the SalesOrderHeader
and SalesOrderDetail tables. */

CREATE PROCEDURE dbo.SaveInvoice
@OrderDate date, --SalesOrderHeader parameter
@Terms varchar(5), --SalesOrderHeader parameter
@SODRows dbo.SalesOrderDetailUDT READONLY --SalesOrderDetail parameter
AS
	/*Insert the order header fields and generate a primary
	key (Identity) */

	INSERT INTO dbo.SalesOrderHeader
	(OrderDate, Terms)
	VALUES (@OrderDate, @Terms)

	/*Insert the line items (in @SOD) together with a foreign key value
	for each row (the identity value generated for the primary key in the
	previous insert) */

	INSERT INTO dbo.SalesOrderDetail
	(SalesOrderID, ProductID, OrderQty)

	SELECT SCOPE_IDENTITY() --The last identity generated in the current scope
	, ProductID
	, OrderQty
	FROM @SODRows

GO