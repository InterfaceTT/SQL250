USE Adventureworks;

-- Identifying Columns / Column List
SELECT ContactID
, LastName
, FirstName
, Phone
FROM Person.Contact;
GO

-- Table Aliases

SELECT contact.contactid
, contact.lastname
, employee.employeeid
, employee.contactid
FROM person.contact
	 INNER JOIN humanresources.employee
		ON contact.contactid = employee.contactid;
GO

SELECT c.contactid
, c.lastname
, e.employeeid
, e.contactid
FROM person.contact AS c
	 JOIN humanresources.employee e
	    ON c.contactid = e.contactid;
GO

-- Inner Join
SELECT c.contactid
, firstname
, lastname
, vacationhours
, hiredate
FROM person.contact AS c
	INNER JOIN humanresources.employee AS e
	   ON c.contactid = e.contactid;
GO
	  
-- Outer Join
SELECT c.contactid
, firstname
, lastname
, employeeid
, vacationhours
FROM person.contact AS c
	LEFT OUTER JOIN humanresources.employee AS e
	  ON c.contactid = e.contactid;
GO

-- Self-Join Queries
SELECT mgr.employeeid mgremployeeid
, emp.employeeid employeeid
, emp.managerid empmanagerid
, emp.salariedflag
FROM HumanResources.Employee emp
	INNER JOIN HumanResources.Employee mgr
		ON emp.managerid = mgr.employeeid;
GO
		
-- Multiple Table Joins		
SELECT * 
FROM Person.Contact AS C 
      INNER JOIN HumanResources.Employee AS E 
         ON C.ContactID = E.ContactID 
      INNER JOIN HumanResources.EmployeeAddress AS EA 
         ON E.EmployeeID = EA.EmployeeID 
      INNER JOIN Person.Address AS A 
         ON EA.AddressID = A.AddressID
      INNER JOIN Person.StateProvince AS SP 
         ON A.StateProvinceID = SP.StateProvinceID
      INNER JOIN Person.CountryRegion AS CR
         ON SP.CountryRegionCode  = CR.CountryRegionCode;
GO 
        
-- Using a Derived Table Subquery 
SELECT name
, listprice
, avgunitprice AS average
, listprice - avgunitprice AS difference
FROM production.product pp
    INNER JOIN (SELECT productid
  		                   , AVG(unitprice-unitpricediscount) avgunitprice 
		                   FROM sales.salesorderdetail 
		                   GROUP BY productid) sod 
	ON pp.productid = sod.productid;
GO

-- Common Table Expression
;WITH avgunitpricequery AS
(SELECT productid
, AVG(unitprice-unitpricediscount) avgunitprice 
FROM sales.salesorderdetail 
GROUP BY productid)
SELECT name
, listprice
, avgunitprice AS average
, listprice - avgunitprice AS difference
FROM production.product pp
     INNER JOIN avgunitpricequery sod 
       ON pp.productid = sod.productid;
GO

-- New Form Inner Join
SELECT cont.contactid
, cont.lastname
, emp.contactid
, emp.vacationhours
FROM Person.Contact AS cont
	INNER JOIN HumanResources.Employee AS emp
		ON cont.contactid = emp.contactid;
GO

-- Old Form Inner Join
SELECT cont.contactid
, cont.firstname
, emp.contactid
, emp.vacationhours
FROM Person.Contact AS cont, HumanResources.employee AS emp
WHERE cont.contactid = emp.contactid;
GO

-- New Form Outer Join
SELECT cont.contactid
, cont.firstname
, cont.lastname
, emp.employeeid
, emp.contactid
, emp.hiredate
FROM Person.Contact AS cont 
	LEFT OUTER JOIN HumanResources.Employee AS emp
	      ON cont.contactid = emp.contactid;
GO

-- Old Form Outer Join  ( Will not execute ) 
SELECT cont.contactid
, cont.firstname
, cont.lastname
, emp.employeeid
, emp.contactid
, emp.hiredate
FROM Person.Contact AS cont, HumanResources.Employee AS emp
WHERE contact.contactid *= emp.contactid;
GO




    
