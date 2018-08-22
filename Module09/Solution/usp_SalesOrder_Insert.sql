-- Create table data type definition for line items
CREATE TYPE OrderLineItems AS TABLE 
(OrderQty smallint
,CarrierTrackingNumber nvarchar(25)
,ProductID int
,SpecialOfferID int
,UnitPrice money
,UnitPriceDiscount money)
GO

-- Create procedure to insert anOrder and all its line items in a single call.
CREATE PROCEDURE dbo.usp_SalesOrder_Insert
@LineItems OrderLineItems READONLY 
, @SalesOrderID int OUTPUT
, @RevisionNumber int
, @OrderDate datetime 
, @DueDate datetime
, @ShipDate datetime
, @Status tinyint = 1
, @OnlineOrderFlag bit 
, @CustomerID int
, @ContactID int
, @SalesPersonID int 
, @TerritoryID int
, @BillToAddressID int   
, @ShipToAddressID int
, @ShipMethodID int
, @SubTotal money
, @TaxAmt money
, @Freight money
AS
SET NOCOUNT ON

BEGIN TRY
	
	BEGIN TRANSACTION
		INSERT INTO [Sales].[SalesOrderHeader]
           ([RevisionNumber]
           ,[OrderDate]
           ,[DueDate]
           ,[ShipDate]
           ,[Status]
           ,[OnlineOrderFlag]
           ,[CustomerID]
           ,[ContactID]
           ,[SalesPersonID]
           ,[TerritoryID]
           ,[BillToAddressID]
           ,[ShipToAddressID]
           ,[ShipMethodID]
           ,[SubTotal]
           ,[TaxAmt]
           ,[Freight]
           )
     VALUES
           (@RevisionNumber
           ,@OrderDate
           ,@DueDate
           ,@ShipDate
           ,@Status
           ,@OnlineOrderFlag
           ,@CustomerID
           ,@ContactID
           ,@SalesPersonID
           ,@TerritoryID
           ,@BillToAddressID
           ,@ShipToAddressID
           ,@ShipMethodID
           ,@SubTotal
           ,@TaxAmt
           ,@Freight
           )
	
	SELECT @SalesOrderID = SCOPE_IDENTITY()
		
	INSERT INTO [Sales].[SalesOrderDetail]
		   ([SalesOrderID]
		   ,[OrderQty]
		   ,[ProductID]
		   ,[SpecialOfferID] 
		   ,[UnitPrice]
		   ,[UnitPriceDiscount])
	 SELECT @SalesOrderID
		   ,OrderQty
		   ,ProductID
		   ,SpecialOfferID 
		   ,UnitPrice
		   ,UnitPriceDiscount
	 FROM @LineItems  

	COMMIT TRANSACTION
	RETURN

END TRY
BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION
        END

        PRINT Error_Message() 
        RETURN -2
 END CATCH
		

GO

