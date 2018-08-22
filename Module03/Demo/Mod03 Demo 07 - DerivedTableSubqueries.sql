-- MODULE 3 DEMO 7: Derived Table Subqueries

USE AdventureWorks

/*
The FROM clause does not require tables exclusively.
Any object that returns a table-type object works,
including a Select statement. A Select statement in 
a FROM clause is called a derived table subquery. 

Notice that a derived table subquery must be inside
parenthesis and must have an alias. */

SELECT *
FROM (SELECT EmployeeID
     , c.LastName + c.FirstName As FullName
	 , e.HireDate
	 FROM HumanResources.Employee e
	 JOIN Person.Contact c ON e.ContactID = c.ContactID) emp

/* Derived table subqueries are usefull in many situations.
Here are 2 of the most common:

1. Leverage a large calculation

Queries cannot use the alias of a column in the calculation
of another column. A subquery can solve this problem.

In the following query, the calculation of the 
AdjustedUnitPrice column has to be performed twice because
it is not possible to refer to it by its alias in the 
LineTotal column. */

SELECT SalesOrderID
, ProductID
, UnitPrice
, AdjustedUnitPrice =	 CASE SpecialOfferID
							WHEN 1 THEN UnitPrice * .9 
							WHEN 2 THEN UnitPrice * .8
							WHEN 3 THEN UnitPrice * .75
							ELSE UnitPrice
						END
, OrderQty
, LineTotal = OrderQty * CASE SpecialOfferID
							WHEN 1 THEN UnitPrice * .9 
							WHEN 2 THEN UnitPrice * .8
							WHEN 3 THEN UnitPrice * .75
							ELSE UnitPrice
						 END

FROM Sales.SalesOrderDetail

/* By using a subquery, we can perform the calculation only
once, simplifying the query. */

SELECT *
, LineTotal = OrderQty * AdjustedUnitPrice
FROM (SELECT SalesOrderID
     , ProductID
     , UnitPrice
     , OrderQty
     , AdjustedUnitPrice =	CASE SpecialOfferID
     							WHEN 1 THEN UnitPrice * .9 
     							WHEN 2 THEN UnitPrice * .8
     							WHEN 3 THEN UnitPrice * .75
     							ELSE UnitPrice
     						END
     FROM Sales.SalesOrderDetail) sod

/* 
2 - Link summary data to detail data 

In the following query, we find the contacts that have been modified
most recently: The derived table subquery finds the most recent 
modified date. When that is inner joined to the Contact table, all 
rows are eliminated except the ones where the modified date is the 
most recent one, giving us access to the detail data on those rows. */

SELECT *
FROM Person.Contact con
JOIN (SELECT MAX(ModifiedDate) As MaxMD
      FROM Person.Contact) As conMaxMD
	ON con.ModifiedDate = conMaxMD.MaxMD

/*
Derived table subqueries can be used in other situations, too, but
for many of them, the benefit can be dubious. For example, derived table
subqueries can be used to reduce errors in the WHERE clause.

Sometimes, the WHERE clause fills up with selection criteria that apply
to the individual tables in the query. It can be argued that putting the 
selection ceriteria for a table together with the table will serve to
compartamentalize logic and reduce errors.

It is important to understand that there is no performance gain (or loss)
with this approach. The following queries have the same cost: */

SELECT *
FROM (SELECT EmployeeID, ContactID, SalariedFlag, HireDate
      FROM HumanResources.Employee
	  WHERE SalariedFlag = 1) e
JOIN HumanResources.EmployeeAddress ea
	ON e.EmployeeID = ea.EmployeeID
JOIN (SELECT AddressID, AddressLine1, City, StateProvinceID, PostalCode
      FROM Person.Address
	  WHERE City = 'Baltimore') a 
	ON a.AddressID = ea.AddressID
JOIN (SELECT ContactID, LastName, FirstName
	  FROM Person.Contact 
	  WHERE EmailPromotion = 2) c
	ON c.ContactID = e.ContactID

SELECT *
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeAddress ea
	ON e.EmployeeID = ea.EmployeeID
JOIN Person.Address a 
	ON a.AddressID = ea.AddressID
JOIN Person.Contact c
	ON c.ContactID = e.ContactID
WHERE e.SalariedFlag = 1
  AND a.City = 'Baltimore'
  AND c.EmailPromotion = 2

