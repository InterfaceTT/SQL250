USE AdventureWorks;
GO

-- Create procedure to insert a row Sales Order Detail 
CREATE PROCEDURE dbo.usp_SalesOrderDetail_Insert
@SalesOrderID int
, @CarrierTrackingNumber nvarchar(25)
, @OrderQty smallint
, @ProductID int
, @SpecialOfferID
, @UnitPrice money
, @UnitPriceDiscount money
AS
SET NOCOUNT ON

BEGIN TRY
	
	BEGIN TRANSACTION
		
		INSERT INTO [Sales].[SalesOrderDetail]
           ([SalesOrderID]
           ,[CarrierTrackingNumber]
           ,[OrderQty]
           ,[ProductID]
           ,[SpecialOfferID]
           ,[UnitPrice]
           ,[UnitPriceDiscount]
           )
     VALUES (@SalesOrderID
           , @CarrierTrackinNumber 
		   ,@OrderQty
		   ,@ProductID
		  , @SpecialOfferID 
		   ,@UnitPrice
		  , @UnitPriceDiscount 
		   )
        
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