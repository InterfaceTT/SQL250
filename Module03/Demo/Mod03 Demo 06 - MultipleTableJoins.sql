-- MODULE 2 DEMO 5: Multiple Table Joins

USE AdventureWorks

/*
The secret to understanding multiple table joins is to 
see every multiple table join as a join between two 
tables. This multiple table join includes 4 tables and
shows salespeople by name and the orders they have
placed. The query also includes their resumes if they
have one. */

SELECT c.LastName
, c.FirstName
, jc.Resume
, soh.SalesOrderNumber
, soh.OrderDate
FROM HumanResources.Employee e
JOIN Person.Contact c
	ON c.ContactID = e.ContactID
LEFT JOIN HumanResources.JobCandidate jc
	ON jc.EmployeeID = e.EmployeeID
JOIN Sales.SalesOrderHeader soh
	ON soh.SalesPersonID = e.EmployeeID

/* The way to read this is one join at a time with each 
join adding an additional table to the table or derived
table created before it:

1. The first join produces a derived table that we'll call
DT1 that includes only matching rows from both the 
Employee and Contact tables.

	HumanResources.Employee [(INNER) JOIN] Person.Contact -> DT1

2. The next join produces a derived table, DT2, that
preserves all the rows in in DT1.

	DT1 [LEFT (OUTER) JOIN] HumanResources.JobCandidate -> DT2

3. The last join produces a derived table, DT3, that includes
only matching rows from DT2 and the SalesOrderHeader tables 
so that we get only those employees who are salespeople.

	DT2 [(INNER) JOIN] Sales.SalesOrderHeader -> DT3 (final result)

Example 2: Write a query that shows only those customers with names 
and also the order numbers of all their orders if they have any. 
Display customers' names, account number, sales order number and 
date. */

SELECT con.LastName
, con.FirstName
, cus.AccountNumber
, soh.SalesOrderNumber
, soh.OrderDate
FROM Sales.Customer cus
LEFT JOIN Sales.SalesOrderHeader soh --OJ for optional sales orders
	ON soh.CustomerID = cus.CustomerID
INNER JOIN Sales.Individual i -- IJ to eliminate custs w/out names
	ON soh.CustomerID = i.customerID
INNER JOIN Person.Contact con -- IJ to eliminate custs w/out names
	ON con.ContactID = i.ContactID

/* Example 3 - Display all the employeeid’s, their address 
information and hours of sick leave for all employees who have
addresses. */

SELECT e.EmployeeID
, a.AddressLine1
, a.AddressLine2
, a.City
, a.StateProvinceID
, a.PostalCode
, e.SickLeaveHours
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeAddress ea -- IJ to eliminate emps w/out addrs
	ON e.EmployeeID = ea.EmployeeID
JOIN Person.Address a  -- IJ to eliminate emps w/out addrs
	ON a.AddressID = ea.AddressID

/* Example 4 - Optionally display the StateProvinceCode in 
the query above if there is one to display. */

SELECT e.EmployeeID
, a.AddressLine1
, a.AddressLine2
, a.City
, a.StateProvinceID
, sp.StateProvinceCode
, a.PostalCode
, e.SickLeaveHours
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeAddress ea -- IJ to eliminate emps w/out addrs
	ON e.EmployeeID = ea.EmployeeID
JOIN Person.Address a -- IJ to eliminate emps w/out addrs
	ON a.AddressID = ea.AddressID
LEFT JOIN Person.StateProvince sp -- OJ for optional StProvCodes
	ON a.StateProvinceID = sp.StateProvinceID

/* Example 5 - Display all stateprovince rows that do not 
have an address assigned to the stateprovinceid. Include 
the stateprovince name. */

SELECT sp.StateProvinceID
, sp.Name
FROM Person.StateProvince sp
LEFT OUTER JOIN Person.Address a -- OJ for exceptions
	ON sp.StateProvinceID = a.StateProvinceID
WHERE a.AddressID IS NULL

/* Example 6 - Display all StateProvince rows that do not 
have an address assigned to the StateProvinceID as above, 
and that are in the country region of ‘US”. Include the 
state province name and country region code. */

SELECT sp.StateProvinceID
, sp.CountryRegionCode
, sp.Name
FROM Person.StateProvince sp
LEFT OUTER JOIN Person.Address a -- OJ for exceptions
	ON sp.StateProvinceID = a.StateProvinceID
WHERE a.AddressID IS NULL 
	AND sp.CountryRegionCode = 'US'

/* Example 7 - Add the country region name in a way
that excludes any state provinces that don't have
a CountryRegion assignment. */

SELECT sp.StateProvinceID
, sp.CountryRegionCode
, sp.Name As StateProvince
, cr.Name As CountryRegion
FROM Person.StateProvince sp
LEFT OUTER JOIN Person.Address a -- OJ for exceptions
	ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN Person.CountryRegion cr -- IJ to eliminate provs w/out cntry rgns
	ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE a.AddressID IS NULL 
	AND sp.CountryRegionCode = 'US'