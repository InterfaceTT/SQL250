USE AdventureWorks;

SELECT  E.EmployeeID
      , C.FirstName + ISNULL(' ' + C.MiddleName + ' ', ' ') + C.LastName FullName
      , CONVERT(VARCHAR(20), edh.StartDate, 107) StartDate
      , ISNULL(CONVERT(VARCHAR(20), edh.EndDate, 107), 'Current') EndDate
      , D.Name Department
FROM    HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
        ON E.ContactID = C.ContactID
INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH
        ON e.EmployeeID = edh.EmployeeID
INNER JOIN HumanResources.Department AS D
        ON EDH.DepartmentID = D.DepartmentID
WHERE   E.HireDate BETWEEN '19980101' AND '19981231';
