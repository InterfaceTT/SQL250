USE AdventureWorks;

-- Identifying Columns
SELECT contactid
, lastname
, firstname
, phone
FROM Person.Contact;
GO

-- Renaming Columns
SELECT contactid AS 'Contact ID:'
, lastname AS Last
, firstname AS First
, phone AS [Phone Number]
FROM Person.Contact;
GO

--Expressions in a column list
SELECT contactid
, lastname + ', ' + firstname AS [Full Name]
, phone
FROM Person.Contact;
GO

-- Operators and Precedence
SELECT salesorderid
, (orderqty * (unitprice - unitpricediscount) ) AmountDisc
, orderqty * unitprice Amount
FROM sales.salesorderdetail
WHERE unitpricediscount <> $0.0;
GO

-- Column List Subquery
SELECT Name storename
, lastname salesperson
, (SELECT name
  FROM  person.contacttype
  WHERE sc.contacttypeid = contacttypeid) contacttype
FROM sales.store ss
	INNER JOIN sales.storecontact sc
	    ON ss.customerid = sc.customerid
	INNER JOIN person.contact pc
	    ON pc.contactid = sc.contactid;
GO

-- Eliminating Duplicate Rows
SELECT DISTINCT title
FROM HumanResources.Employee;
GO

-- Sorting Results
SELECT employeeid
, gender
, salariedflag
, hiredate
, loginid
FROM HumanResources.employee
WHERE gender = 'F'
	AND salariedflag =1
	AND (hiredate BETWEEN '1/1/1998' AND '12/31/1998'
	OR hiredate BETWEEN '1/1/2001' AND '12/31/2001')
ORDER BY hiredate DESC, loginid;
GO

-- TOP Operator
SELECT TOP 3 salesorderid
, productid
, orderqty
 FROM sales.salesorderdetail
 ORDER BY orderqty DESC;
GO

SELECT TOP 3 WITH TIES salesorderid
, productid
, orderqty
 FROM sales.salesorderdetail
 ORDER BY orderqty DESC;
GO
