-- MODULE 6 DEMO 1: Introduction to Grouping

USE AdventureWorks

/* Queries that group and aggregate functions produce
one or more scalar values that describe different 
aspects of the data.

The following query displays a few columns from the
SalesOrderDetail table. Notice that there are several
rows for each product id. */

SELECT ProductId
, SalesorderId 
, OrderQty
FROM Sales.SalesOrderDetail
ORDER BY ProductID

/* By grouping by the product id, this next query can
sum the order quantities for each product id by using
the SUM() aggregate function. */

SELECT ProductId
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID

/* The WHERE clause processes before the GROUP BY clause,
so in the query below, all rows having a product id other
than 942 are excluded before the query ever gets to 
creating groups, so the only group that will be created will
be the one for product id 942. */

SELECT ProductId
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
WHERE ProductID = 942
GROUP BY ProductID

/* The HAVING clause is similar to the WHERE clause in that
it also filters data, but while the WHERE clause processes
before the GROUP BY clause, the HAVING clauses processes 
after it, so the filtering it performs is on the results of 
the GROUP BY. 

In the query below, all product ids are processed by the
GROUP BY clause, but all but product id 925 are eliminated 
afterwards by the HAVING clause. Not the most efficient way
to get these results! What do you think might be a better
approach? */

SELECT ProductId
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING ProductID = 925

/* The results of the previous query can more efficiently be 
accomplished by using the WHERE clause instead. The real value 
of the HAVING clause is in its ability to filter the results
of the aggregate functions, which are only put together after
the GROUP BY.

In the following query, after all product id groups have been
created, all product id groups but the ones having a sum
over 500 are eliminated by the HAVING clause. */

SELECT ProductId
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(OrderQty) > 500

/* Because the HAVING clause processes before the SELECT 
clause, it can be used to filter data based even on aggregates  
that are not included in the SELECT clause. */

SELECT ProductId
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(OrderQty) >= 2

/* The GROUP BY clause imposes a limitation on the SELECT 
clause; the only things allowed in the SELECT clause are the 
expresssion in the GROUP BY and aggregate functions.

This query fails because it violates that restriction. */

SELECT ProductId, UnitPrice
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID

/* This query runs without errors. */

SELECT ProductId
, SUM(OrderQty) As TotalOrderQty
, AVG(UnitPrice) As AvgUnitPrice
FROM Sales.SalesOrderDetail
GROUP BY ProductID

