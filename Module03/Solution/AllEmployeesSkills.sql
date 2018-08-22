USE AdventureWorks;

SELECT *
FROM HumanResources.vJobCandidate;

SELECT E.EmployeeID
, C.LastName
, E.HireDate
, vjc.Skills
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
LEFT JOIN HumanResources.vJobCandidate AS VJC
ON e.EmployeeID = VJC.EmployeeID;

