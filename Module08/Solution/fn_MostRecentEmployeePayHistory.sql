USE AdventureWorks;

GO
CREATE FUNCTION dbo.fn_MostRecentEmployeePayHistory
(@employeeID INT
, @TopRows INT)
RETURNS TABLE
AS
RETURN
	(WITH Emps
	AS
	(
	SELECT  *
	      , ROW_NUMBER() OVER(PARTITION BY e.EmployeeID ORDER BY e.RateChangeDate DESC) RowNum
	FROM dbo.v_EmployeePayHistorybyDept AS e
	)
	SELECT  e.DepartmentName
	      , e.EmployeeID	    	     
	      , e.EmployeeName  
	      , e.Hiredate	 
	      , e.Shift
	      , e.RateChangeDate
	      , e.PayRate
	      , e.PayFrequency
	FROM Emps AS e
	WHERE e.EmployeeID = @employeeID
	AND e.rownum <= @TopRows
	);
	GO
	
	SELECT *
	FROM dbo.fn_MostRecentEmployeePayHistory (6, 3);
	