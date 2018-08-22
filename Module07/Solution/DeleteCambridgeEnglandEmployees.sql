USE Adventureworks;

DELETE FROM dbo.non_wa_employee
OUTPUT DELETED.employeeid
	WHERE city = 'cambridge' 
			AND statecode = 'ENG';