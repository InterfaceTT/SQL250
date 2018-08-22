-- MODULE 8 DEMO 5: Table Type Parameters

USE AdventureWorks

/* To resolve the issue with having to hard code the
states, you are going to introduce a table-type
parameter. Start by creating a table type that will 
serve as a template for the creation of parameters 
and variables of this type. */

CREATE TYPE dbo.udtStateCode AS table
(StateCode char(2))

GO

/* Now you can use the type in the inline table valued
function you created earlier. */

ALTER FUNCTION dbo.fnRecallData
(@StartDate datetime
, @EndDate datetime
, @ProdSubCatID int
, @StateCodes dbo.udtStateCode READONLY -- A parameter using the new type
)
RETURNS TABLE
AS
RETURN (
SELECT DISTINCT P.ProductID
, p.Name ProductName
, p.ProductSubcategoryID SubCatID
, soh.OrderDate
, soh.SalesOrderNumber SON
, sp.StateProvinceCode ShiptoState
, soh.CustomerID
, c.FirstName + ' ' + c.LastName Customer
, caddr.AddressLine1 CusAddr1
, caddr.AddressLine2 CusAddr2
, caddr.City CusCity
, csp.StateProvinceCode CusState
, caddr.PostalCode CusZip
FROM Production.product p
JOIN Sales.SalesOrderDetail sod
	ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh
	ON soh.SalesOrderID = sod.SalesOrderID
JOIN person.[Address] addr
	ON addr.AddressID = soh.ShipToAddressID
JOIN person.StateProvince sp
	ON sp.StateProvinceID = addr.StateProvinceID
JOIN sales.Individual i
	ON i.CustomerID = soh.CustomerID
JOIN Person.Contact c
	ON c.ContactID = i.ContactID
JOIN Sales.CustomerAddress ca
	ON ca.CustomerID = soh.CustomerID
JOIN Person.[Address] caddr
	ON caddr.AddressID = ca.AddressID
JOIN person.StateProvince csp
	ON csp.StateProvinceID = caddr.StateProvinceID
WHERE soh.OrderDate BETWEEN @StartDate and @EndDate
  AND sp.StateProvinceCode NOT IN (SELECT StateCode FROM @StateCodes) -- The new table type parameter is used here
  AND p.ProductSubcategoryID = @ProdSubCatID
)

GO

/* Use the modified function to get the same data  you got for
the second recall. Here is the description again:

The company has just announced another recall of products in
subcategory id 26 except in the states of Texas (TX) and Florida
(FL) that were sold between 6/2/2004 and 8/31/2005. Again, you 
have been asked to provide a list of all the customers to whom 
recall notices need to be sent out. The notices will include the 
customer names, their addresses (street, city, state and zip). */

DECLARE @States dbo.udtStateCode
INSERT INTO @States VALUES ('TX'), ('FL')

SELECT Customer
, CusAddr1
, CusAddr2
, CusCity
, CusState
, CusZip
FROM dbo.fnRecallData('6/2/2004', '8/31/2005', 26, @States)

GO

-- Now update the procedure, too.

ALTER PROCEDURE dbo.upRecallData
(@StartDate datetime
, @EndDate datetime
, @ProdSubCatID int
, @StateCodes dbo.udtStateCode READONLY)
AS
SELECT *
FROM dbo.fnRecallData(@StartDate, @EndDate, @ProdSubCatID, @StateCodes)

GO

-- Test the changes to the stored procedure.

DECLARE @States dbo.udtStateCode
INSERT INTO @States VALUES ('TX'), ('FL')
EXECUTE dbo.upRecallData '5/20/2004', '2/5/2005', 26, @States

-- Cleanup

DROP PROCEDURE dbo.upRecallData
DROP FUNCTION dbo.fnRecallData
DROP TYPE dbo.udtStateCode																																							