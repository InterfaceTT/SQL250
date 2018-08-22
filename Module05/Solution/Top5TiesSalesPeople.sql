USE AdventureWorks;

SELECT TOP 5 WITH TIES sp.SalesPersonID
, c.LastName
, e.Title
, sp.SalesQuota
FROM sales.SalesPerson AS SP
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
ORDER BY sp.SalesQuota DESC;