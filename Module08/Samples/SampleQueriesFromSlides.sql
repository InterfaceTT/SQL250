USE AdventureWorks;

-- Creating a User-Defined Scalar Function
GO
CREATE FUNCTION dbo.ufnEmployeeEmail ( @ID int )
RETURNS varchar(50)
AS
BEGIN
      DECLARE @email varchar (50)
      SELECT @email = EmailAddress
      FROM HumanResources.Employee
      WHERE EmployeeID = @ID
RETURN @email
END;
GO

-- Altering and Dropping User-Defined Scalar Functions
ALTER FUNCTION dbo.ufnEmployeeEmail (@ID int )
RETURNS varchar(50)
AS
BEGIN
DECLARE @EMAIL VARCHAR (50)
	SELECT @email = EmailAddress
	FROM HumanResources.Employee
	WHERE EmployeeID = @ID
RETURN @EMAIL
END;
GO

DROP FUNCTION dbo.ufnEmployeeEmail;
GO

-- Using User-Defined Scalar Function
SELECT dbo.ufnEmployeeEmail(345);
GO

SELECT dbo.ufnEmployeeEmail(SalesPersonID) Email
, SalesQuota
, SalesYTD
FROM Sales.SalesPerson;
GO

-- Creating Views
CREATE VIEW Person.vContactList
AS
SELECT LastName
, FirstName
FROM Person.Contact
WHERE EmailPromotion = 1;
GO

-- Altering and Dropping Views
ALTER VIEW Person.vContactList
AS
SELECT ContactID
, LastName
, FirstName
FROM Person.Contact
WHERE EmailPromotion = 1;
GO

DROP VIEW Person.vContactList;
GO

-- Using a View
SELECT FirstName + ', ' + LastName ContactName
FROM Person.vContactList
WHERE LastName LIKE 'b%';
GO

-- Creating a Inline Table-Valued Function
CREATE FUNCTION ufn_EmployeeByGender ( @Gender nchar(1) )
RETURNS TABLE
AS
RETURN (SELECT e.EmployeeID, c.FirstName
        , c.LastName, e.Gender  
		 FROM HumanResources.Employee e
           INNER JOIN Person.Contact c
             ON e.contactid = c.contactid
		 WHERE e.Gender = @Gender);
GO

-- Altering and Deleteing an Inline Table-Valued Function
ALTER FUNCTION ufn_EmployeeByGender ( @Gender nchar(1), @SalariedFlag bit = 1 )
RETURNS TABLE
AS
RETURN (SELECT e.EmployeeID, c.FirstName
        , c.LastName, e.Gender  
		 FROM HumanResources.Employee e
           INNER JOIN Person.Contact c
             ON e.contactid = c.contactid
		 WHERE e.Gender = @Gender
            AND e.SalariedFlag = @SalariedFlag);
 GO

DROP FUNCTION ufn_EmployeeByGender;
GO

-- Using an Inline Table-Valued Function
SELECT * FROM ufn_EmployeeByGender ('F', 0);
GO

SELECT * FROM ufn_EmployeeByGender ('F', DEFAULT);
GO

-- Creating a Stored Procedure
CREATE PROCEDURE Person.usp_GetContactList
AS
SET NOCOUNT ON
SELECT ContactID
, FirstName
, LastName
, EmailAddress
FROM Person.vContactList
ORDER BY FirstName;
GO

-- Altering and Dropping a Stored Procedure
ALTER PROCEDURE Person.usp_GetContactList
AS
SET NOCOUNT ON
SELECT ContactID
, FirstName + ' ' + LastName ContactName
FROM Person.GetContactList
ORDER BY LastName;
GO

DROP PROCEDURE Person.usp_GetContactList;
GO

-- Create and Execute a Procedure with a Table-Valued Parameter
-- Create Table Data Type
CREATE TABLE dbo.Customer
(ID INT
, CustomerName NVARCHAR(50));
GO

CREATE TYPE dbo.CustomerUDT AS TABLE
(ID int
, CustomerName nvarchar(50));
GO

CREATE PROCEDURE dbo.CreateCustomers
@Customer AS dbo.CustomerUDT READONLY
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO dbo.Customer 
(Id, CustomerName)
     SELECT ID, CustomerName 
     FROM @Customer;
 END;
GO 
 
-- Define instance of CustomerUDT
DECLARE @Customer AS CustomerUDT;

INSERT @Customer (ID, CustomerName)
VALUES(1, 'Bill Smith')
	  , (2, 'Mary Jones')
	  , (3, 'John Stenson');

EXEC dbo.CreateCustomers @Customer;
GO


-- Creating a Multi-Statement Table-Valued Function
CREATE FUNCTION dbo.fn_FirstandLastDayofMonth
( @Date date )
RETURNS @TableOut TABLE
(Firstday DATE,
Lastday DATE)
AS
BEGIN
DECLARE @Fday DATE, @Lday DATE
	SET @Fday = DATEADD(day,-DAY(@Date)+1,@Date)
	SET @Lday = DATEADD(day,-1,DATEADD(month,1,@Fday ))
	INSERT @TableOut (FirstDay, LastDay)
	VALUES  (@Fday,@Lday) -- FirstDay,LastDay
	RETURN
END;
GO

-- Altering and Dropping a Multi-Statement Table-Valued Function
ALTER FUNCTION dbo.fn_FirstandLastDayofMonth
( @Date date = '1/1/12' )
RETURNS @TableOut TABLE
(Firstday DATE,
Lastday DATE)
AS
BEGIN
DECLARE @Fday DATE, @Lday DATE
	SET @Fday = DATEADD(day,-DAY(@Date)+1,@Date)
	SET @Lday =  DATEADD(day,-1,DATEADD(month, 1, @Fday ))
	INSERT @TableOut (FirstDay, LastDay)
	VALUES  (@Fday,@Lday)-- FirstDay, LastDay
	RETURN 
END;
GO

DROP FUNCTION dbo.fn_FirstandLastDayofMonth;
GO

-- Using a Multi-Statement Table-Valued Function
SELECT SalesOrderID
, OrderDate
, TotalDue
FROM dbo.fn_FirstandLastDayofMonth('8/15/2002') m
	INNER JOIN Sales.SalesOrderHeader soh
		ON soh.OrderDate >= m.firstday 
			AND soh.OrderDate <= m.lastday;
			
SELECT * 
FROM dbo.fn_FirstandLastDayofMonth(DEFAULT);
GO

-- What is the APPLY Operator?
SELECT *
FROM Sales.SalesOrderHeader soh
	CROSS APPLY (SELECT TOP (2) *
								 FROM Sales.SalesOrderDetail sod
	               			     WHERE soh.SalesOrderID =  sod.SalesOrderID
	               			     ORDER BY sod.LineTotal DESC) t2;
GO

-- Using the APPLY Operator
CREATE FUNCTION dbo.fnGetMostExpensiveProducts
(@ProductSubCatID AS int, @rownum AS INT) 
RETURNS TABLE
AS
RETURN(
SELECT TOP(@rownum) Name
, ListPrice
FROM Production.Product
WHERE ProductSubCategoryID = @ProductSubCatID
ORDER BY ListPrice DESC);
GO

SELECT sc.name, p2.Name, p2.ListPrice
FROM Production.ProductSubcategory sc
   CROSS APPLY dbo.fnGetMostExpensiveProducts
   				                   (sc.productsubcategoryid,3) p2;
GO


			
			









  





