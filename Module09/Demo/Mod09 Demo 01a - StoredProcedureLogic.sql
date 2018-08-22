
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

/* Create the SalesOrderHeader table to hold order data. */

CREATE TABLE dbo.SalesOrderHeader
(
	SalesOrderID	int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	OrderDate		date NOT NULL
		CONSTRAINT DF_OrderDate DEFAULT (GETDATE()),
	Terms			varchar(5) NULL
)
GO

/* Create the SalesOrderDetail table to hold order line items. */

CREATE TABLE dbo.SalesOrderDetail(
	SalesOrderDetailID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	SalesOrderID int NULL FOREIGN KEY REFERENCES SalesOrderHeader(SalesOrderID) ON DELETE CASCADE,
	ProductID int NOT NULL,
	OrderQty int NOT NULL)
GO

 /* Create the function to get the text value in the default
 property of a column. */

IF OBJECT_ID('dbo.GetColumnDefault', 'FN') IS NOT NULL  
	DROP FUNCTION dbo.GetColumnDefault
GO

CREATE FUNCTION dbo.GetColumnDefault
(@SchemaDotTableName nvarchar(50)
, @ColumnName varchar(50))
RETURNS nvarchar(50)
AS
BEGIN

	DECLARE @DefText nvarchar(50)

	SELECT @DefText = d.definition 
	FROM sys.default_constraints AS d
	JOIN sys.columns AS c
		ON d.parent_column_id = c.column_id
	WHERE d.parent_object_id = OBJECT_ID(@SchemaDotTableName, N'U')
	  AND c.name = @ColumnName

	RETURN @DefText

END
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

/* Create the stored procedure that will save an order and its
line items. */

CREATE PROCEDURE dbo.SaveInvoice
@OrderDate date, 
@Terms varchar(5), 
@SODRows dbo.SalesOrderDetailUDT READONLY,
@LineItemCount int OUTPUT
AS

	SET NOCOUNT ON

	DECLARE @OrderDateDefaultFlag bit = 0,
		    @TermsDefaultFlag bit = 0

	BEGIN TRY

		-- Exceptions

		---- Inspect SalesOrderHeader prameters

		IF @OrderDate Is Null 
			IF dbo.GetColumnDefault(N'dbo.SalesOrderHeader', 'OrderDate') IS NULL
				BEGIN
					IF COLUMNPROPERTY(OBJECT_ID('dbo.SalesOrderHeader'),'OrderDate','AllowsNull') = 0 
						RAISERROR('OrderDate is required', 16, 1)
				END
			ELSE
				SET @OrderDateDefaultFlag = 1

		IF @Terms Is Null  
			IF dbo.GetColumnDefault(N'dbo.SalesOrderHeader', 'Terms') IS NULL
				BEGIN
					IF COLUMNPROPERTY(OBJECT_ID('dbo.SalesOrderHeader'),'Terms','AllowsNull') = 0 
						RAISERROR('Terms is required', 16, 1)
				END
			ELSE
				SET @TermsDefaultFlag = 1

		---- Inspect @SODRows

		SELECT @LineItemCount = COUNT(*)
		FROM @SODRows

		IF @LineItemCount <= 0 
				RAISERROR('Order detail rows are required', 16, 1)

		BEGIN TRANSACTION

			/*Insert the order header fields and generate a primary
			key (Identity) */

			IF @OrderDateDefaultFlag = 1 AND @TermsDefaultFlag = 1
				INSERT INTO dbo.SalesOrderHeader (OrderDate, Terms)
					VALUES (DEFAULT, DEFAULT)
			ELSE IF @OrderDateDefaultFlag = 1
				INSERT INTO dbo.SalesOrderHeader (OrderDate, Terms)
					VALUES (DEFAULT, @Terms)
			ELSE IF @TermsDefaultFlag = 1
				INSERT INTO dbo.SalesOrderHeader (OrderDate, Terms)
					VALUES (@OrderDate, DEFAULT)
			ELSE
				INSERT INTO dbo.SalesOrderHeader (OrderDate, Terms)
					VALUES (@OrderDate, @Terms)				

			/*Insert the line items (in @SOD) together with a foreign key value
			for each row (the identity value generated for the primary key in the
			previous insert) */

			INSERT INTO dbo.SalesOrderDetail (SalesOrderID, ProductID, OrderQty)
				SELECT SCOPE_IDENTITY()
				, ProductID
				, OrderQty
				FROM @SODRows

		COMMIT TRANSACTION
		RETURN 0

	END TRY

	BEGIN CATCH

		IF @@TranCount > 0 
			ROLLBACK TRANSACTION

		PRINT Error_Message()
        RETURN -1

	END CATCH
GO
