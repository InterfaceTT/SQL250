USE AdventureWorks;

SELECT sp.SalesPersonID
, SUM(SOH.TotalDue) TotalDue
FROM sales.SalesOrderHeader AS SOH
INNER JOIN sales.SalesPerson AS SP
ON SOH.SalesPersonID = SP.SalesPersonID
WHERE soh.ShipDate BETWEEN '20020101' AND '20021231'
GROUP BY sp.SalesPersonID
ORDER BY TotalDue DESC;