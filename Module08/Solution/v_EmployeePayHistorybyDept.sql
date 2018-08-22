USE AdventureWorks;
GO
CREATE VIEW dbo.v_EmployeePayHistorybyDept
AS
SELECT d.Name DepartmentName
, e.EmployeeID
, c.FirstName + ' ' + c.LastName EmployeeName
, CONVERT(VARCHAR(20),e.HireDate, 101) Hiredate
, s.Name Shift
, eph.Rate PayRate
, CONVERT(VARCHAR(20), eph.RateChangeDate, 101) RateChangeDate
, CASE eph.PayFrequency
		WHEN 1 THEN 'Weekly'
		WHEN 2 THEN 'Bi-Weekly'
		ELSE 'Unknown'
		END PayFrequency
FROM HumanResources.Employee AS E
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH
	ON E.EmployeeID = EDH.EmployeeID
	INNER JOIN HumanResources.Department AS D
	ON EDH.DepartmentID = D.DepartmentID
	INNER JOIN HumanResources.Shift AS S
	ON edh.ShiftID = s.ShiftID
	INNER JOIN Person.Contact AS C
	ON c.ContactID = e.ContactID
	INNER JOIN HumanResources.EmployeePayHistory AS EPH
	ON E.EmployeeID = EPH.EmployeeID;
GO

SELECT *
FROM dbo.v_EmployeePayHistorybyDept
ORDER BY EmployeeID;