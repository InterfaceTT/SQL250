USE AdventureWorks;

GO
CREATE PROCEDURE dbo.usp_UpdateProductInventoryQuantity
@ProductID INT
, @LocationID INT
, @Shelf NVARCHAR(10)
, @Bin TINYINT
, @Quantity SMALLINT
AS
SET NOCOUNT ON;

UPDATE production.ProductInventory
SET Quantity = Quantity + @Quantity
OUTPUT INSERTED.ProductID
				, INSERTED.LocationID
				, INSERTED.Shelf
				, INSERTED.Bin
				, DELETED.Quantity OldQuantity
				, INSERTED.Quantity NewQuantity
WHERE ProductID = @ProductID
AND LocationID = @LocationID
AND Shelf = @Shelf
AND Bin = @Bin;
GO

EXECUTE dbo.usp_UpdateProductInventoryQuantity 
@ProductID = 1
, @LocationID = 50
, @Shelf = 'A'
, @Bin	= 5
, @Quantity = -100;