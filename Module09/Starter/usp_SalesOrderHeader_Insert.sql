USE AdventureWorks;
GO

-- Insert an Order row 
CREATE PROCEDURE dbo.usp_SalesOrderHeader_Insert
@SalesOrderID int OUTPUT
, @RevisionNumber tinyint
, @OrderDate datetime
, @DueDate datetime 
, @ShipDate datetime = NULL
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