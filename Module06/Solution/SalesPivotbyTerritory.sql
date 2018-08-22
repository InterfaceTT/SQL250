USE AdventureWorks;

WITH Sales AS
(
SELECT ST.[Group] TerritoryGroup
, ST.Name TerritoryName
, YEAR(SOH.OrderDate) OrderYear
, SOH.TotalDue
FROM sales.SalesOrderHeader AS SOH
INNER JOIN sales.SalesPerson AS SP
ON SOH.SalesPersonID = SP.SalesPersonID
INNER JOIN sales.SalesTerritory AS ST
ON SP.TerritoryID = ST.TerritoryID
)
SELECT *
FROM Sales AS S
PIVOT 
	(SUM(s.TotalDue) FOR S.OrderYear
		IN ([2002], [2003], [2004])
	) AS Pvt
ORDER BY TerritoryGroup;