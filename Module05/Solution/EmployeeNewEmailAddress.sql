USE AdventureWorks;

SELECT E.EmployeeID
, C.FirstName + ISNULL(' ' + C.MiddleName + ' ', '') + C.LastName FullName
, C.FirstName + ISNULL('.' + LEFT(C.MiddleName, 1) + '.', '.') + C.LastName + '@adventure-works.com' NewEmailAddress
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID;
