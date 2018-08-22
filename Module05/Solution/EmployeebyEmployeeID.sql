USE AdventureWorks;

SELECT E.EmployeeID
, C.FirstName + ' ' + C.LastName AS FullName
, CONVERT(VARCHAR, E.HireDate, 101) HireDate
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
WHERE e.EmployeeID = 157;