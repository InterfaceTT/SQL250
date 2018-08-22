USE AdventureWorks;

SELECT e.EmployeeID
, c.FirstName
, c.LastName
, c.EmailAddress
, e.Gender
FROM person.Contact c
	INNER JOIN HumanResources.Employee e
		ON c.ContactID = e.ContactID;