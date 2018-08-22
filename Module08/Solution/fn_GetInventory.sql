USE AdventureWorks;

GO
CREATE FUNCTION dbo.fn_GetInventory
(@ProductID INT)
RETURNS INT
AS
BEGIN;	
	RETURN (SELECT SUM(Quantity) 
						FROM Production.ProductInventory
						WHERE ProductID = @ProductID);
END;
GO

SELECT dbo.fn_GetInventory(475);