USE AdventureWorks;

-- Local Variables
DECLARE @vcontactid int
		,@vIName char(50);
SET @vIname = 'Adams';

SELECT @vcontactid = contactid
FROM person.contact
WHERE lastname = @vIname;

SELECT @vcontactid AS ContactID;
GO

-- Conditional Processing
DECLARE @compareprice money, @cost money;
SELECT @COST = 5.00, @compareprice = 6.00;
IF @cost <= @compareprice
	BEGIN 
		PRINT 'These products can be purchased for less than $'
		+ RTRIM(CAST(@compareprice AS varchar(20)));
		RETURN;
	END
ELSE
		PRINT 'The prices for all products in this category exceed $'
		+ RTRIM(CAST(@compareprice AS varchar(20)));
GO

IF EXISTS (SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'HumanResources].[Department]')
			AND type in (N'U'))
DROP TABLE [HumanResources].[Department]
GO

-- Iterative Processing
WHILE (SELECT AVG(ListPrice) FROM Production.Product) < $300
BEGIN 
	UPDATE Production.Product
		SET ListPrice = ListPrice * 2
	SELECT MAX(ListPrice), AVG(ListPrice) 
	FROM Production.Product 
	IF (SELECT MAX(ListPrice) FROM Production.Product) > $500
	  	BREAK 
	ELSE 
		CONTINUE 
END 
PRINT 'Too much for the market to bear';
GO

-- Branching
LOOP:
	IF (SELECT AVG(ListPrice) FROM Production.Product) >=$300
		GOTO ENDLOOP
		UPDATE Production.Product
			SET ListPrice = ListPrice * 1.2
		SELECT MAX (ListPrice), AVG(ListPrice) 
		FROM Production.Product
	IF (SELECT MAX (ListPrice) FROM Production.Product) > $500
		GOTO ENDLOOP
		ELSE
		GOTO LOOP
ENDLOOP:
		PRINT 'Too much for the market to bear';
GO

-- Structured Exception Handling

DECLARE @AddressLine1 NVARCHAR(60) = '1 N. Pine Ave.'
, @City NVARCHAR(30) = 'Phoenix'
, @StateProvinceID INT = 60000
, @PostalCode NVARCHAR(15) = '85020'
, @EmployeeID INT = 10 
, @AddressID INT 
 
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Person.Address
			 (AddressLine1, City, StateProvinceID, PostalCode) 
		VALUES (@AddressLine1, @City, @StateProvinceID, @PostalCode);
		SET @AddressID = @@IDENTITY
		INSERT INTO HumanResources.EmployeeAddress
			(EmployeeID, AddressID)
			 VALUES (@EmployeeID, @AddressID);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() ErrorNumber,
		ERROR_MESSAGE() [Message];
	ROLLBACK TRANSACTION
END CATCH;
GO

-- PRINT and RAISERROR Statements
PRINT 'Message to Display'

DECLARE @Msg VARCHAR(100)
SET @Msg = 'Error'
PRINT @MSG
	
RAISERROR ('This is message %s %d.' -- Message text.
   , 10       -- Severity,
   , 1        -- State,
   , 'number' -- First argument.
   , 6);      -- Second argument
GO