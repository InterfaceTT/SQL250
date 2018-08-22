-- MODULE 6 DEMO 3: Ranking Functions

USE AdventureWorks

/* Ranking functions also make use of window functions
to rank results. 

The following query puts rows in descending order by 
subtotal and then assignes a row number to them, 
effectively ranking the rows. */
 
SELECT SalesOrderID
, YEAR(OrderDate) AS OD_Year
, SubTotal
, ROW_NUMBER() OVER(ORDER BY SubTotal DESC) As SubTotalRank
FROM Sales.SalesOrderHeader

/* Notice that if we reorder the query by something other 
than the subtotal in descending order, it jumbles up the
row numbers, because they are still being assigned based
on the subtotal in descending order while the rows
are ordered differently. */

SELECT SalesOrderID
, YEAR(OrderDate) AS OD_Year
, SubTotal
, ROW_NUMBER() OVER(ORDER BY SubTotal DESC) As SubTotalRank
FROM Sales.SalesOrderHeader
ORDER BY OrderDate

/* This next example includes a PARTITION BY clause
forcing the row numbers to restart at 1 with every new
order date year. */

SELECT SalesOrderID
, YEAR(OrderDate) AS OD_Year
, SubTotal
, ROW_NUMBER() OVER(PARTITION BY YEAR(OrderDate) ORDER BY SubTotal DESC) As SubTotalRank
FROM Sales.SalesOrderHeader 

/* This example shows that the ROW_NUMBER() function
doesn't know how to handle ties. */

SELECT ProductID
, Name
, ListPrice
, ROW_NUMBER() OVER(ORDER BY ListPrice DESC) As PriceRank
FROM Production.Product

/* RANK() and DENSE_RANK() can be used instead to solve
that issue. The difference between these two functions is
that RANK() picks up from where the count would have been 
without the ties. */

SELECT ProductID
, Name
, ListPrice
, DENSE_RANK() OVER(ORDER BY ListPrice DESC) As PriceDenseRank
, RANK() OVER(ORDER BY ListPrice DESC) As PriceRank
FROM production.Product

/* Finally, NTILE() can be used to "chop up" the results 
into equal numbers of rows. */

SELECT ProductID
, Name
, ListPrice
, NTILE(3) OVER(ORDER BY ListPrice DESC) As PriceRank
FROM production.Product
