USE AdventureWorks;

SELECT soh. SalesOrderID
, soh.OrderDate
, st.Name TerritoryName
, soh.TotalDue USDTotalDue
, soh.TotalDue *
		(SELECT cr.AverageRate 
			FROM Sales.CurrencyRate AS CR
			WHERE soh.orderdate = cr.CurrencyRateDate
			AND cr.ToCurrencyCode = 'CAD') CADTotalDue
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesPerson AS SP
ON SOH.SalesPersonID = SP.SalesPersonID
INNER JOIN Sales.SalesTerritory AS ST
ON SP.TerritoryID = ST.TerritoryID
WHERE st.name = 'Canada';