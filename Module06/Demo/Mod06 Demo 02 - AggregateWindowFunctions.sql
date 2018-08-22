-- MODULE 6 DEMO 2: Aggregate Window Functions

USE AdventureWorks

/* Aggregate window functions were introduced into 
Transact-SQL in order to provide a solution to the 
restriction imposed by the GROUP BY clause that 
does not allow the mixing of detail and summary
data (see MODULE 6 DEMO 1).

Consider the following grouping query used in DEMO 1. */

SELECT ProductID
, SUM(OrderQty) As TotalOrderQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY ProductID

/* Similar results can be obtained by writing the
query as follows, though this query displays detail
rows and not summary rows as the query above does. 
In this approach, the grouping and aggregate are done
"behind the scenes" in the SELECT clause in a type of
"window" that is opened into the data behind the query. 
*/

SELECT ProductID
, SUM(OrderQty) OVER(PARTITION BY ProductID)
FROM Sales.SalesOrderDetail
ORDER BY ProductID

/* This is more useful when there is a need to combine
aggregate summary data with detail data. The following
query uses both summary and detail data on one row. 
Note that if the PARTITION BY clause is not included, 
the aggregates are calculated over the entire table. */

SELECT SalesOrderID
, OrderDate
, TotalDue
, TotalDue / SUM(TotalDue) OVER() * 100 Pcnt
, TotalDue - AVG(TotalDue) OVER() Diff
, SUM(TotalDue) OVER() AS SumTotalDue
FROM Sales.SalesOrderHeader

/* Here is the same query partitioned by the year of the
order date. */

SELECT SalesOrderID
, OrderDate
, TotalDue
, TotalDue / SUM(TotalDue) OVER(PARTITION BY YEAR(orderdate)) * 100 Pcnt
, TotalDue - AVG(TotalDue) OVER(PARTITION BY YEAR(orderdate)) Diff
, SUM(TotalDue) OVER(PARTITION BY YEAR(orderdate)) AS SumTotalDue
FROM Sales.SalesOrderHeader

