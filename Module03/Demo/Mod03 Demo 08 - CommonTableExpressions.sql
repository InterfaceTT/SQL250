-- MODULE 3 DEMO 8: Common Table Expressions (CTE)

USE AdventureWorks

/*
A CTE is very useful when a derived table subquery is 
used more than once in the same query. A CTE allows us
to define the subquery up-front and then reference it
by name as many times as needed in the main query. 

In the following query, the same subquery is used to 
play different roles. In one role, it is the contact
names of employees and in the other role it is the
contact names of managers). */

SELECT mgrC.LastName + ', ' + mgrC.FirstName As Manager
, empC.LastName + ', ' + empC.FirstName As Employee 
FROM HumanResources.Employee emp
JOIN HumanResources.Employee mgr
	ON emp.ManagerID = mgr.EmployeeID
JOIN (SELECT *
	  FROM Person.Contact
	  WHERE EmailPromotion = 2) empC
	ON empC.ContactID = emp.ContactID
JOIN (SELECT *
	  FROM Person.Contact
	  WHERE EmailPromotion = 2) mgrC
	ON mgrC.ContactID = mgr.ContactID
ORDER BY Manager

/* It might be easier to read this query if a CTE is used. 

In the following query, the derived table subquery is 
declared up front as a CTE called ContactNames and is used
twice in the query, just like before, aliased accordingly.
*/

;WITH ContactNames AS
(SELECT *
FROM Person.Contact
WHERE EmailPromotion = 2)
SELECT mgrC.LastName + ', ' + mgrC.FirstName As Manager
, empC.LastName + ', ' + empC.FirstName As Employee 
FROM HumanResources.Employee emp
JOIN HumanResources.Employee mgr
	ON emp.ManagerID = mgr.EmployeeID
JOIN ContactNames empC
	ON empC.ContactID = emp.ContactID
JOIN ContactNames mgrC
	ON mgrC.ContactID = mgr.ContactID
ORDER BY Manager

/* CTEs are also useful even when a derived table subquery
is used only once in a query. If the derived table
subquery is very big, using it as a CTE can make the query
more readable. */