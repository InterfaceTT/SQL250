/* MODULE 9 DEMO 1b: Stored Procedure with UDT

Declare and populate a variable of type SalesOrderDetailUDT 
created in the previous demo and pass it to the SaveInvoice
stored procedure along with sales order header data. */

DECLARE @SOD dbo.SalesOrderDetailUDT
DECLARE @RetVal int, @ItemsInserted int, @FinalMsg varchar(50)

SET NOCOUNT ON

--Populate the table-type variable
INSERT @SOD 
(ProductID, OrderQty)
VALUES (43, 10), (25, 5), (3, 15)

/*Execute the stored procedure. Pass the order header values and 
the line items in the @SOD variable */
EXEC @RetVal = dbo.SaveInvoice '7/11/2013', 'NET30', @SOD, @ItemsInserted OUTPUT
	

IF @RetVal = 0
	BEGIN
		SELECT 'Inserted ' + CAST(@ItemsInserted AS varchar) +  ' line items'
	END
ELSE
 	PRINT N'Save failed.'	