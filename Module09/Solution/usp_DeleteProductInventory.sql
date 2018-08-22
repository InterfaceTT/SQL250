USE AdventureWorks;
GO

CREATE PROCEDURE usp_DeleteProductInventory
@ProductID INT
, @LocationID INT
AS
SET NOCOUNT ON;
DECLARE @Ret INT = 0;

BEGIN TRY;

	BEGIN TRANSACTION;
	
	DELETE Production.ProductInventory
	WHERE ProductID = @ProductID
	AND LocationID = @LocationID
	AND Quantity <= 0;
	
	IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR('Either row does not exist or the Quantity was greater than 0, no row deleted', 16, 1)
			SET @Ret = -1
		END;
	
	COMMIT TRANSACTION;
END TRY

BEGIN CATCH;
	
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		
	DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
	RAISERROR(@ErrorMessage, 16, 1);
	RETURN -1;

END CATCH;
GO

-- Test deleting where the quantity is greater than 0
DECLARE @Ret INT;
EXECUTE @Ret = dbo.usp_DeleteProductInventory
@ProductID = 4
, @LocationID = 50;

SELECT @Ret ReturnCode;
GO

-- Test deleting where the row does not exist
DECLARE @Ret INT;
EXECUTE @Ret = dbo.usp_DeleteProductInventory
@ProductID = 2
, @LocationID = 51;

SELECT @Ret ReturnCode;
GO


-- Test deleting where it's successful
-- Use SSMS and edit the Production.ProductInventory table 
-- Change the quantity to 0 for the row with ProductID = 2 and LocationID = 50
-- Then run the statements below
DECLARE @Ret INT;
EXECUTE @Ret = dbo.usp_DeleteProductInventory
@ProductID = 2
, @LocationID = 50;

SELECT @Ret ReturnCode;
GO