USE AdventureWorks;

SELECT E.EmployeeID
, C.FirstName
, C.LastName
, E.HireDate
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID;

