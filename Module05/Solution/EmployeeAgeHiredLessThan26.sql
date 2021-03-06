USE AdventureWorks;

SELECT E.EmployeeID
, C.FirstName + ' ' + C.LastName FullName
, CONVERT(VARCHAR(20), E.BirthDate, 101) BirthDate
, CONVERT(VARCHAR(20), E.HireDate, 101) HireDate
, FLOOR(DATEDIFF(day, E.BirthDate, e.HireDate) / 365.25) AgeatHire
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
WHERE FLOOR(DATEDIFF(day, E.BirthDate, e.HireDate) / 365.25) < 26
ORDER BY AgeatHire DESC;

-- OR

;WITH EmployeeList AS
(
SELECT E.EmployeeID
, C.FirstName + ' ' + C.LastName FullName
, CONVERT(VARCHAR(20), E.BirthDate, 101) BirthDate
, CONVERT(VARCHAR(20), E.HireDate, 101) HireDate
, FLOOR(DATEDIFF(day, E.BirthDate, e.HireDate) / 365.25) AgeatHire
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
)
SELECT *
FROM EmployeeList
WHERE AgeatHire < 26
ORDER BY AgeatHire DESC;