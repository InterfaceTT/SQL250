-- MODULE 6 DEMO 1b: Advanced Grouping

USE AdventureWorks

/* This demo shows a step-by-step approach in the development
of two advanced grouping queries.

QUERY 1 - Display, for each sales person, the total 
sales by product for  all orders they took in January 
of 2002.  If the order was not taken by a sales person, 
do not include it in the output.

--Step 1: Join */

SELECT *
FROM Sales.SalesOrderDetail soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID

--Step 2: Add selection	criteria

SELECT *
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
		
--Step 3: Add aggregation		
SELECT 
soh.SalesPersonID
, ProductID
, SUM(LineTotal) TotalSales
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
GROUP BY soh.SalesPersonID, ProductID

--Step 4: Add sort
SELECT 
soh.SalesPersonID
, ProductID
, SUM(LineTotal) TotalSales
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
GROUP BY soh.SalesPersonID, ProductID
ORDER BY soh.SalesPersonID

/*  QUERY 2 - Display, for each sales person, their full name 
(instead of SalesPersonID) and the total sales by product for 
all orders they took in January of 2002. Only display total 
sales if it is less than $100.00. If the order was not taken 
by a sales person, do not include it in the output. */

-- Add additional tables

SELECT 
soh.SalesPersonID
, ProductID
, SUM(LineTotal) TotalSales
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN HumanResources.Employee e
		ON soh.SalesPersonID = EmployeeID
	INNER JOIN Person.Contact c
		ON e.ContactID = c.ContactID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
GROUP BY soh.SalesPersonID, ProductID
ORDER BY soh.SalesPersonID

-- Display the fullname instead of the product id. Observe the error.

SELECT 
FirstName + ' ' + LastName FullName
, ProductID
, SUM(LineTotal) TotalSales
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN HumanResources.Employee e
		ON soh.SalesPersonID = EmployeeID
	INNER JOIN Person.Contact c
		ON e.ContactID = c.ContactID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
GROUP BY soh.SalesPersonID, ProductID
ORDER BY soh.SalesPersonID

-- Add the fullname to the Group By clause to fix the problem.

SELECT 
FirstName + ' ' + LastName FullName
, ProductID
, SUM(LineTotal) TotalSales
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN HumanResources.Employee e
		ON soh.SalesPersonID = EmployeeID
	INNER JOIN Person.Contact c
		ON e.ContactID = c.ContactID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
GROUP BY FirstName + ' ' + LastName, ProductID
ORDER BY soh.SalesPersonID

-- Add the Having clause and change the sorting

SELECT  FirstName + ' ' + LastName FullName
, ProductID
, SUM(LineTotal) TotalSales
FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod
		ON soh.SalesOrderID = sod.SalesOrderID
	INNER JOIN HumanResources.Employee e
		ON soh.SalesPersonID = EmployeeID
	INNER JOIN Person.Contact c
		ON e.ContactID = c.ContactID
WHERE OrderDate BETWEEN '1/1/2002' AND '1/31/2002'
	AND soh.SalesPersonID IS NOT NULL
GROUP BY FirstName + ' ' + LastName, ProductID
HAVING SUM(LineTotal) < $100.00
ORDER BY FullName







