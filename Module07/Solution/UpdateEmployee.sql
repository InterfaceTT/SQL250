USE Adventureworks;

UPDATE dbo.non_wa_employee
	SET addressline2 = 'Suite 5'
	, city = 'Beaverton'
OUTPUT INSERTED.EmployeeID
, DELETED.addressline2 OldAddressLine2
, INSERTED.addressline2 NewAddressLine2
, DELETED.City OldCity
, INSERTED.City NewCity
WHERE employeeid = 280;