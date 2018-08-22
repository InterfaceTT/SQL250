USE AdventureWorks;

SELECT soh.SalesPersonID
, sod.ProductID
, SUM(sod.LineTotal) TotalSales
, AVG(sod.LineTotal) AvgSales
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.ShipDate BETWEEN '20020101' AND '20021231'
AND SOD.ProductID IN (757, 778)
AND soh.SalesPersonID IN (275, 280)
GROUP BY soh.SalesPersonID, sod.ProductID;
