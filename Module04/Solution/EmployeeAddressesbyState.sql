USE AdventureWorks;

SELECT E.EmployeeID
, C.LastName
, E.BirthDate
, a.AddressLine1
, a.City
, sp.StateProvinceCode
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN HumanResources.EmployeeAddress AS EA
ON E.EmployeeID = ea.EmployeeID
INNER JOIN person.Address AS A
ON EA.AddressID = A.AddressID
INNER JOIN Person.StateProvince AS SP
ON A.StateProvinceID = SP.StateProvinceID
WHERE sp.StateProvinceCode IN ('MN', 'WA', 'CA');