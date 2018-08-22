/* MODULE 7 DEMO 4b: Advanced Merge with Stored Procedure

==== START SETUP ==== */

USE AdventureWorks2008

IF OBJECT_ID('Production.InventoryOrder', 'U') IS NOT NULL
  DROP TABLE Production.InventoryOrder;

CREATE TABLE Production.InventoryOrder
(
	ProductID int NOT NULL,
	Quantity int NOT NULL,
	OrderDate date NOT NULL
)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
	   WHERE SPECIFIC_SCHEMA = N'Production'
		 AND SPECIFIC_NAME = N'dkUpdateInventory')
   DROP PROCEDURE Production.dkUpdateInventory
   
/* ==== END SETUP ==== 

Verify the table to be used by the Merge. */

SELECT * FROM Production.InventoryOrder

/* Create a stored procedure that performs the merge.   
CREATE PROCEDURE command must be the only command in its
batch, so we will use GO to delineate the end of the 
previous batch. */

GO

CREATE PROCEDURE Production.dkUpdateInventory
@OrderDate DATETIME
AS
	MERGE Production.InventoryOrder AS Target
	USING (SELECT ProductID, SUM(OrderQty), OrderDate 
	       FROM Sales.SalesOrderDetail AS d
		   JOIN Sales.SalesOrderHeader AS h 
				ON d.SalesOrderID = h.SalesOrderID
				AND h.OrderDate = @OrderDate
		   GROUP BY ProductID, OrderDate) AS Source (ProductID, OrderQty, OrderDate)
	ON (Target.ProductID = Source.ProductID)

	WHEN MATCHED AND Target.OrderDate <> Source.OrderDate THEN 
		DELETE

	WHEN MATCHED THEN 
		UPDATE SET target.Quantity = Source.OrderQty,
			Target.OrderDate = Source.OrderDate

	WHEN NOT MATCHED BY TARGET THEN
		INSERT (ProductID, Quantity, OrderDate)
		VALUES (Source.ProductID, Source.OrderQty, Source.OrderDate)

	WHEN NOT MATCHED BY SOURCE THEN
		DELETE

	OUTPUT $action, Inserted.*, Deleted.*;

	SELECT * FROM Production.InventoryOrder
GO

-- Initial run, only insertions of a few orders
EXEC Production.dkUpdateInventory '07/14/2001'

-- Run again, only updates (but no data changes)
EXEC Production.dkUpdateInventory '07/14/2001'

-- Now a mix of inserts and deletes
EXEC Production.dkUpdateInventory '07/01/2001'

-- Run again. Notice there are some inserts. Bug!
EXEC Production.dkUpdateInventory '07/01/2001'

-- Change the stored procedure:
GO
ALTER PROCEDURE Production.dkUpdateInventory(@OrderDate DATETIME)
AS
	MERGE Production.InventoryOrder AS Target
	USING (SELECT ProductID, SUM(OrderQty), OrderDate 
	       FROM Sales.SalesOrderDetail AS d
		   JOIN Sales.SalesOrderHeader AS h 
				ON d.SalesOrderID = h.SalesOrderID
				AND h.OrderDate = @OrderDate
		   GROUP BY ProductID, OrderDate) AS Source (ProductID, OrderQty, OrderDate)
	ON (Target.ProductID = Source.ProductID 
	    AND Target.OrderDate = Source.OrderDate) -- Insert second criterion

	--WHEN MATCHED AND Target.OrderDate <> Source.OrderDate THEN 
		--DELETE

	WHEN MATCHED THEN 
		UPDATE SET target.Quantity = Source.OrderQty,
			Target.OrderDate = Source.OrderDate

	WHEN NOT MATCHED BY TARGET THEN
		INSERT (ProductID, Quantity, OrderDate)
		VALUES (Source.ProductID, Source.OrderQty, Source.OrderDate)

	WHEN NOT MATCHED BY SOURCE THEN
		DELETE

	OUTPUT $action, Inserted.*, Deleted.*;

	SELECT * FROM Production.InventoryOrder
GO	

-- Try again
TRUNCATE TABLE Production.InventoryOrder


-- Initial run, inserts
EXEC Production.dkUpdateInventory '07/14/2001'

/* Run with other date. Notice that products 749 and 753 
are both inserted and deleted. */
EXEC Production.dkUpdateInventory '07/01/2001'

-- Run again. This time everything is updated
EXEC Production.dkUpdateInventory '07/01/2001'


-- *** MERGE statement with Common Table Expression (CTE)
-- Same as previous example, rewritten as CTE

GO
ALTER PROCEDURE Production.dkUpdateInventory(@OrderDate DATETIME)
AS
	WITH InventoryOrdersForDate(ProductID, OrderQty, OrderDate)
	AS
	(
		SELECT ProductID
		, SUM(OrderQty)
		, OrderDate 
		FROM Sales.SalesOrderDetail AS d
			JOIN Sales.SalesOrderHeader AS h 
				ON d.SalesOrderID = h.SalesOrderID
						AND h.OrderDate = @OrderDate
		GROUP BY ProductID, OrderDate
	)
	MERGE Production.InventoryOrder AS Target
	USING InventoryOrdersForDate AS Source -- (ProductID, OrderQty, OrderDate)
	ON (Target.ProductID = Source.ProductID 
		AND Target.OrderDate = Source.OrderDate) -- Insert second clause
	-- WHEN MATCHED AND Target.OrderDate <> Source.OrderDate THEN 
	--	DELETE
	WHEN MATCHED THEN 
		UPDATE SET target.Quantity = Source.OrderQty,
			Target.OrderDate = Source.OrderDate
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (ProductID, Quantity, OrderDate)
		VALUES (Source.ProductID, Source.OrderQty, Source.OrderDate)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE
	OUTPUT $action, Inserted.*, Deleted.*;
	SELECT * FROM Production.InventoryOrder
GO

-- Test it
-- Try again
TRUNCATE TABLE Production.InventoryOrder

-- Run once
EXEC Production.dkUpdateInventory '07/14/2001'
-- Run twice
EXEC Production.dkUpdateInventory '07/01/2001'
-- Same results as previously

-- Clean up
USE AdventureWorks2008
DROP TABLE Production.InventoryOrder
DROP PROCEDURE Production.dkUpdateInventory