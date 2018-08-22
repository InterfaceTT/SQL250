USE AdventureWorks;

SELECT emp.EmployeeID
, empcontact.LastName
, mgr.EmployeeID
, mgrcontact.LastName
FROM HumanResources.Employee AS Emp
INNER JOIN HumanResources.Employee AS Mgr
ON emp.ManagerID = mgr.EmployeeID
INNER JOIN Person.Contact AS EmpContact
ON Emp.ContactID = EmpContact.ContactID
INNER JOIN person.Contact AS MgrContact
ON mgr.ContactID = MgrContact.ContactID;