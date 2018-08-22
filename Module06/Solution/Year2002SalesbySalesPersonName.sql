USE AdventureWorks;

SELECT sp.SalesPersonID
, C.FirstName + ' ' + c.LastName FullName
, SUM(soh.TotalDue) TotalDue
FROM sales.SalesOrderHeader AS SOH
INNER JOIN sales.SalesPerson AS SP
ON SOH.SalesPersonID = SP.SalesPersonID
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID 
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
WHERE soh.ShipDate BETWEEN '20020101' AND '20021231'
GROUP BY sp.SalesPersonID, C.FirstName + ' ' + c.LastName
HAVING SUM(soh.TotalDue) > 4000000;