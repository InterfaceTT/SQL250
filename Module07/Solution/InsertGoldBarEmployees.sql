USE Adventureworks;

INSERT dbo.non_wa_employee
OUTPUT INSERTED.*
	SELECT e.employeeid 
	, a.addressid
	, firstname
	, lastname
	, NULL
	, addressline1
	, addressline2
	, city
	, sp.stateprovincecode
	, postalcode
	, countryregioncode
	FROM person.contact c
		INNER JOIN humanresources.employee e
			ON c.contactid = e.contactid
		INNER JOIN humanresources.employeeaddress ea
			ON e.employeeid = ea.employeeid
		INNER JOIN person.address a
			ON ea.addressid = a.addressid
		INNER JOIN person.stateprovince sp
			ON a.stateprovinceid = sp.stateprovinceid
	WHERE city = 'Gold Bar';