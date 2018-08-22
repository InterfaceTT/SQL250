USE AdventureWorks;

SELECT c.ContactID
, C.LastName
, E.BirthDate
, E.HireDate
FROM  Person.Contact AS C
LEFT JOIN HumanResources.Employee AS E
ON E.ContactID = C.ContactID
WHERE c.LastName LIKE 'Ha%';