USE AdventureWorks;

WITH AggrSales AS
(
SELECT soh.SalesPersonID
, sod.ProductID
, SUM(sod.LineTotal) TotalSales
, AVG(sod.LineTotal) AvgSales
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.ShipDate BETWEEN '20020101' AND '20021231'
AND SOD.ProductID IN (757, 778)
AND SOH.SalesPersonID IN (275, 280)
GROUP BY soh.SalesPersonID, sod.ProductID
)
SELECT c.Firstname + ' ' + c.LastName SalesPersonName
, p.Name ProductName
, agg.TotalSales
, agg.AvgSales
FROM AggrSales AS Agg
INNER JOIN Sales.SalesPerson AS SP 
ON Agg.SalesPersonID = SP.SalesPersonID
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID
INNER JOIN person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN production.Product AS P
ON agg.ProductID = p.ProductID
ORDER BY SalesPersonName, ProductName;

-- OR


SELECT c.Firstname + ' ' + c.LastName SalesPersonName
, p.Name ProductName
, SUM(sod.LineTotal) TotalSales
, AVG(sod.LineTotal) AvgSales
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesPerson AS SP 
ON soh.SalesPersonID = SP.SalesPersonID
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID
INNER JOIN person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN production.Product AS P
ON sod.ProductID = p.ProductID
WHERE SOH.ShipDate BETWEEN '20020101' AND '20021231'
AND SOD.ProductID IN (757, 778)
AND SOH.SalesPersonID IN (275, 280)
GROUP BY c.Firstname + ' ' + c.LastName, p.Name
ORDER BY SalesPersonName, ProductName;