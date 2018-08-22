USE AdventureWorks;

SELECT e.employeeid employeeid
, a.addressid addressid
, firstname
, lastname
, CONVERT(NVARCHAR(50), NULL) title
, addressline1
, addressline2
, city
, sp.stateprovincecode statecode
, postalcode
, countryregioncode country
FROM person.contact c
	INNER JOIN humanresources.employee e
		ON c.contactid = e.employeeid
	INNER JOIN humanresources.employeeaddress ea
		ON e.employeeid = ea.employeeid
	INNER JOIN person.address a
		ON ea.addressid = a.addressid
	INNER JOIN person.stateprovince sp
		ON a.stateprovinceid = sp.stateprovinceid
WHERE sp.stateprovincecode <> 'WA';
GO
