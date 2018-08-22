-- Created dbo.Inventory table
SELECT  [ProductID]
      , SUM([Quantity]) InventoryQty
INTO dbo.Inventory 
FROM [Production].[ProductInventory]
GROUP BY ProductID

-- Merge Daily Sales Transactions into the dbo.Inventory table

WITH DailySales AS
(
SELECT SOD.ProductID
, SUM(sod.OrderQty) OrderQty
FROM sales.SalesOrderHeader AS SOH
INNER JOIN sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.OrderDate = '7/1/2001'
GROUP BY ProductID
)
MERGE dbo.inventory AS I
USING DailySales AS DS
ON i.productID = ds.productid
WHEN MATCHED AND I.InventoryQty - ds.OrderQty <> 0
	THEN UPDATE SET I.InventoryQty = I.InventoryQty - ds.OrderQty 
WHEN MATCHED AND I.InventoryQty - ds.OrderQty = 0
	THEN DELETE
WHEN NOT MATCHED 
	THEN INSERT 
		VALUES(DS.ProductID, 0 - OrderQty)
OUTPUT $ACTION
, INSERTED.productid
, DELETED.InventoryQty OldInventoryQty
, INSERTED.InventoryQty NewInventoryQty;
