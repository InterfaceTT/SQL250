USE AdventureWorks;

GO
CREATE PROCEDURE usp_InsertProductInventory
 @ProductID INT
, @LocationID INT
, @Shelf	NVARCHAR(10)
, @Bin TINYINT
, @Quantity SMALLINT
AS
SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM Production.Product AS P  -- Test ProductID 
								WHERE P.ProductID = @ProductID)
	BEGIN
		RAISERROR( 'ProductID does not Exist', 16, 1)
		RETURN -1
	END;
	
IF NOT EXISTS (SELECT * FROM Production.Location AS L  -- Test LocationID
								WHERE l.LocationID = @LocationID)
	BEGIN
		RAISERROR( 'LocationID does not Exist', 16, 1)
		RETURN -1
	END;

BEGIN TRY;
	BEGIN TRANSACTION;
	
	INSERT production.ProductInventory
	        (
	         ProductID
	       , LocationID
	       , Shelf
	       , Bin
	       , Quantity
	        )
	VALUES  (
	         @ProductID -- ProductID - int
	       , @LocationID -- LocationID - smallint	         
	       , @Shelf -- Shelf - nvarchar(10)
	       , @Bin -- Bin - tinyint
	       , @Quantity -- Quantity - smallint
	        );
	 
	 COMMIT TRANSACTION;
END TRY

BEGIN CATCH
	
	IF @@TRANCOUNT = 1  -- Make sure a transaction is still active
		ROLLBACK TRANSACTION;

	IF ERROR_NUMBER() = 2627
		BEGIN
			RAISERROR('Duplicate ProductID and LocationID were detected on Insert', 16, 1)
			RETURN -1
		END;

	DECLARE @ErrorMessage sysname = ERROR_MESSAGE();
	RAISERROR(@ErrorMessage, 16, 1);
	RETURN -1;

END CATCH;
GO

-- Test Invalid Product ID
DECLARE @Ret INT;	
EXECUTE @Ret = dbo.usp_InsertProductInventory 
    @ProductID = 5
  , @LocationID = 8
  , @Shelf = N'A'
  , @Bin = 1
  , @Quantity = 100;
  
 SELECT @Ret ReturnCode;
GO

-- Test Invalid Location ID
DECLARE @Ret INT;
EXECUTE @Ret = dbo.usp_InsertProductInventory 
    @ProductID = 3
  , @LocationID = 8
  , @Shelf = N'A'
  , @Bin = 1
  , @Quantity = 100;
  
 SELECT @Ret ReturnCode;
GO

-- Test Duplicate Product ID and Location ID combination
DECLARE @Ret INT;	
EXECUTE @Ret = dbo.usp_InsertProductInventory 
    @ProductID = 3
  , @LocationID = 6
  , @Shelf = N'A'
  , @Bin = 1
  , @Quantity = 100;
  
 SELECT @Ret ReturnCode;
GO

-- Test Successful Insert
DECLARE @Ret INT;	
EXECUTE @Ret = dbo.usp_InsertProductInventory 
    @ProductID = 3
  , @LocationID = 5
  , @Shelf = N'A'
  , @Bin = 1
  , @Quantity = 100;
  
 SELECT @Ret ReturnCode; 
GO 