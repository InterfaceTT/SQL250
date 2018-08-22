USE AdventureWorks;

-- The WHERE Clause
SELECT contactid
, lastname
, firstname
, phone
FROM Person.Contact
WHERE lastname = 'Buchanan';
GO

-- String Comparisons
SELECT contactid
, lastname
, firstname
, emailaddress
FROM Person.Contact 
WHERE lastname LIKE 'B%'
GO

--Logical Operators

SELECT employeeid
, gender
, salariedflag
, hiredate
, loginid
FROM HumanResources.Employee
WHERE gender = ‘F’
	AND salariedflag = 1
	AND (hiredate BETWEEN '1/1/2001' AND '12/31/1998'
	OR hiredate BETWEEN '1/1/2001' AND '12/31/1998');
GO
	
-- Retrieving a Range of Values
SELECT employeeid
, title
, birthdate
, vacationhours
FROM HumanResources.Employee
WHERE birthdate BETWEEN '1/1/1950' AND '12/31/1980';
GO

-- Filtering on Unknown Values
SELECT contactid
, firstname
, middlename
, lastname
, emailaddress
FROM Person.Contact
WHERE middlename IS NOT NULL;
GO

-- Using a List of Values
SELECT employeeid
, title
, birthdate
, vacationhours
FROM HumanResources.Employee
WHERE title IN ('Recruiter', 'Buyer', 'Stocker');
GO

--List of values from subquery
SELECT Name ProductName
FROM Production.Product
WHERE ProductSubcategoryID
IN (SELECT ProductSubcategoryID
	FROM Production.ProductSubcategory
	WHERE NAME LIKE '%Bike%');
GO
	
--Search Arguments
SELECT *
FROM Person.Contact 
WHERE LEFT(EmailAddress, 4) = 'Jay1';
GO

SELECT *
FROM Person.Contact 
WHERE EmailAddress LIKE 'Jay1%';
GO