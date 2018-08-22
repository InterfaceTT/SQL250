/* MODULE 8 DEMO 6b: Stored Procedure with UDT

Declare and populate a variable of type SalesOrderDetailUDT 
created in the previous demo and pass it to the SaveInvoice
stored procedure along with sales order header data. */

DECLARE @SOD dbo.SalesOrderDetailUDT

--Populate the table-type variable
INSERT @SOD 
(ProductID, OrderQty)
VALUES (43, 10), (25, 5), (3, 15)

/*Execute the stored procedure. Pass the order header values and 
the line items in the @SOD variable */
exec dbo.SaveInvoice '7/11/2013', 'NET30', @SOD