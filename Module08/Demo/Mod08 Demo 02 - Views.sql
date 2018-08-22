/* MODULE 8 DEMO 2: Views

==== START SETUP ==== */

USE AdventureWorks

IF OBJECT_ID ( 'dbo.vRecallData', 'V' ) IS NOT NULL  
	DROP VIEW dbo.vRecallData

/* ==== END SETUP ==== 

AdventureWorks is recalling all bike racks sold between 1/1/2004 
and 4/30/2005 except those sold in the states of Wyoming (WY), 
California (CA), Massachusetts (MA) and Vermont (VT). 

You have developed the following query to accesses all the data 
related to this recall and that you will use as a basis for 
several requests for data from management. 

SELECT DISTINCT P.ProductID
, p.Name ProductName
, p.ProductSubcategoryID
, soh.OrderDate
, soh.SalesOrderNumber
, sp.StateProvinceCode [ShiptoState]
, soh.CustomerID
, c.FirstName + ' ' + c.LastName Customer
, caddr.AddressLine1
, caddr.AddressLine2
, caddr.City
, csp.StateProvinceCode [CusState]
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

Create a view for the query so that you will be
ready to respond to data requests. */

GO

CREATE VIEW dbo.vRecallData
(ProductID, ProductName, SubCatID, OrderDate, SON, ShiptoState,
CustomerID, Customer, CusAddr1, CusAddr2, CusCity, CusState,
CusZip)
AS
SELECT DISTINCT P.ProductID
, p.Name ProductName
, p.ProductSubcategoryID
, soh.OrderDate
, soh.SalesOrderNumber
, sp.StateProvinceCode
, soh.CustomerID
, c.FirstName + ' ' + c.LastName
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

GO

/* The first data request has arrived. You have been asked to
provide a list of all the customers to whom recall notices need 
to be sent out. The notices will include the customer names, 
their addresses (street, city, state and zip). */	

SELECT Customer
, CusAddr1
, CusAddr2
, CusCity
, CusState
, CusZip
FROM dbo.vRecallData

-- Cleanup

DROP VIEW dbo.vRecallData																																							