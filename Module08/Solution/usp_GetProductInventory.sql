USE AdventureWorks;
GO
CREATE PROCEDURE dbo.usp_GetProductInventory 
@ProductID INT
AS
SET NOCOUNT ON;

SELECT  PI.ProductID
      , P.Name ProductName
      , L.Name LocationName
      , PI.Shelf
      , PI.Bin
      , PI.Quantity
FROM production.ProductInventory AS PI
	INNER JOIN production.Location AS L
	ON PI.LocationID = L.LocationID
	INNER JOIN production.Product AS P
	ON pi.ProductID = p.ProductID
WHERE pi.ProductID = @ProductID;
GO

EXECUTE dbo.usp_GetProductInventory 475;