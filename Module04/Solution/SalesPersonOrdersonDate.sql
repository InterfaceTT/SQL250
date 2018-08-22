USE AdventureWorks;

SELECT sp.SalesPersonID
, c.LastName
, st.Name
FROM sales.SalesPerson AS SP
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN sales.SalesTerritory AS ST
ON sp.TerritoryID = st.TerritoryID
WHERE EXISTS 
					(SELECT *
					FROM Sales.SalesOrderHeader AS SOH
					WHERE soh.OrderDate = '20011201'
					AND sp.SalesPersonID = soh.SalesPersonID);