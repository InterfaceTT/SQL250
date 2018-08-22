/* MODULE 8 DEMO 3: Inline Table Valued Function (TVF)

==== START SETUP ==== */

USE AdventureWorks

IF OBJECT_ID ( 'dbo.fnRecallData', 'IF' ) IS NOT NULL  
	DROP FUNCTION dbo.fnRecallData

/* ==== END SETUP ==== 

In the previous demo, you created a view containing the
following query. 

SELECT DISTINCT P.ProductID
, p.Name ProductName
, p.ProductSubcategoryID
, soh.OrderDate
, soh.SalesOrderNumber
, sp.StateProvinceCode [State]
, soh.CustomerID
, c.FirstName + ' ' + c.LastName Customer
, caddr.AddressLine1
, caddr.AddressLine2
, caddr.City
, csp.StateProvinceCode
, caddr.PostalCode
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
WHERE soh.OrderDate BETWEEN '1/1/2004' and '4/30/2005'
  AND sp.StateProvinceCode NOT IN ('WY', 'MA', 'CA', 'VT')
  AND p.ProductSubcategoryID = 26
ORDER BY soh.customerid DESC

Now you'd like to parameterize the view so that
you can use it for any future recalls. All items in the
WHERE clause need to be parmeterized with the exception of
the state codes. You will handle parameterization of that 
later. For now, it will be handled by the calling party, 
so you can just comment it out.  */

GO

CREATE FUNCTION dbo.fnRecallData
(@StartDate datetime
, @EndDate datetime
, @ProdSubCatID int)
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
  --AND sp.StateProvinceCode NOT IN ('WY', 'MA', 'CA', 'VT')
  AND p.ProductSubcategoryID = @ProdSubCatID
)

GO

/* The company has just announced another recall of products in
subcategory id 26 except in the states of Texas (TX) and Florida
(FL) that were sold between 6/2/2004 and 8/31/2005. Again, you 
have been asked to provide a list of all the customers to whom 
recall notices need to be sent out. The notices will include the 
customer names, their addresses (street, city, state and zip). */	

SELECT Customer
, CusAddr1
, CusAddr2
, CusCity
, CusState
, CusZip
, ShipToState
FROM dbo.fnRecallData('6/2/2004', '8/31/2005', 26)
WHERE ShiptoState NOT IN ('TX', 'FL')

-- Cleanup

--DROP FUNCTION dbo.fnRecallData																																							