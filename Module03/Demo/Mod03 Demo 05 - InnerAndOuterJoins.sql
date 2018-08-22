-- MODULE 2 DEMO 4: Inner and Outer Joins

USE AdventureWorks

/*
These two tables (Section and Equipment) will be used in the
following examples. 

Equipment items are assigned to sections. The SID and EID 
columns are the primary keys in their tables. The SecID 
column in the Equipment table is a foreign key that references 
the SID column in the Section table. A Null in the SecID 
column means that the equipment item is not assigned to
any sections.

+-------------------------------------------+
|                 SECTION                   | 
+---+--------+--------+--------+------------+
|SID|CourseID|Location|Schedule|InstructorID|
+---+--------+--------+--------+------------+
|  1|       2|B-245   |MW 1500 |         254|
|  2|       4|A-24    |TH 1400 |         189|
|  3|       9|C-235   |WF 1830 |         122|
|  4|      34|B-156   |WF 1830 |         254|
|  5|       2|D-251   |MW 1500 |         189|
|  6|       9|C-235   |MW 1700 |         254|
+---+--------+--------+--------+------------+


+-------------------------------------------+
|                EQUIPMENT                  | 
+---+---------------------------------+-----+
|EID|Equipment Item                   |SecID|
+---+---------------------------------+-----+
|  1|Projector A                      |    1|
|  2|Projector B                      | NULL|
|  3|Teleportation machine            |    4|
|  4|High-gain antenna                |    4|
|  5|Portable Hadron particle collider|    3|
|  6|Reflection telescope             | NULL|
+---+---------------------------------+-----+


A - INNER JOIN

To build the result of an inner join, we start with the table
containing the foreign key. In our case, that's the Equipment
table.

+-------------------------------------------+
|                EQUIPMENT                  | 
+---+---------------------------------+-----+
|EID|Equipment Item                   |SecID|
+---+---------------------------------+-----+
|  1|Projector A                      |    1|
|  2|Projector B                      | NULL|
|  3|Teleportation machine            |    4|
|  4|High-gain antenna                |    4|
|  5|Portable Hadron particle collider|    3|
|  6|Reflection telescope             | NULL|
+---+---------------------------------+-----+

Next, each value in the foreign key column (SecID) is looked
up in it's corresponding primary key (SID) and the two rows
are lined up.

+-------------------------------------------+-------------------------------------------+
|                EQUIPMENT                  |                 SECTION                   | 
+---+---------------------------------+-----+---+--------+--------+--------+------------+
|EID|Equipment Item                   |SecID|SID|CourseID|Location|Schedule|InstructorID|
+---+---------------------------------+-----+---+--------+--------+--------+------------+
|  1|Projector A                      |    1|  1|       2|B-245   |MW 1500 |         254|
|  2|Projector B                      | NULL|   |        |        |        |            |
|  3|Teleportation machine            |    4|  4|      34|B-156   |WF 1830 |         254|
|  4|High-gain antenna                |    4|  4|      34|B-156   |WF 1830 |         254|
|  5|Portable Hadron particle collider|    3|  3|       9|C-235   |WF 1830 |         122|
|  6|Reflection telescope             | NULL|   |        |        |        |            |
+---+---------------------------------+-----+---+--------+--------+--------+------------+

Finally, rows without matches are excluded. 

+-------------------------------------------+-------------------------------------------+
|                EQUIPMENT                  |                 SECTION                   | 
+---+---------------------------------+-----+---+--------+--------+--------+------------+
|EID|Equipment Item                   |SecID|SID|CourseID|Location|Schedule|InstructorID|
+---+---------------------------------+-----+---+--------+--------+--------+------------+
|  1|Projector A                      |    1|  1|       2|B-245   |MW 1500 |         254|
|  3|Teleportation machine            |    4|  4|      34|B-156   |WF 1830 |         254|
|  4|High-gain antenna                |    4|  4|      34|B-156   |WF 1830 |         254|
|  5|Portable Hadron particle collider|    3|  3|       9|C-235   |WF 1830 |         122|
+---+---------------------------------+-----+---+--------+--------+--------+------------+

Here are a few things worth noting about inner joins:

1. Inner joins show only those rows from both tables that match
each other; they exclude rows from either table that don't match
any rows in the other table. 

2. Because foreign keys are not unique identifiers in one-to-many
and many-to-many relationships, rows from the primary key table 
can appear more than once in the result of a join between two tables
in those relationships. 

3. The number of rows in the result of the inner join will never
excede the number of rows in the table with the foreign key. Notice
in how we assembled the inner join result above that the table 
with the foreign key was the "driver" of the relationship.

The query we ran at the end of the previous demo was an inner
join, because we were not interested in any employees who did
not have a name in the Contact table or in any Contacts that 
did not relate to an employee. The word "INNER" is optional in 
the query. */

SELECT emp.EmployeeID
, con.LastName
, con.FirstName
, emp.HireDate
, con.ContactID
FROM HumanResources.Employee As emp
INNER JOIN Person.Contact As con
	ON emp.ContactID = con.ContactID

/* Here's another example of an inner join from the 
AdventureWorks database: 

Let's say we need to display all sales orders and that, for 
each sales order, we need to also show customer details. The
AdventureWorks database contains the following two tables, 
holding customer and sales order data respectively:

*/ 

SELECT *
FROM Sales.Customer

SELECT *
FROM Sales.SalesOrderHeader

/*

Let's also say that we are not interested in any customers who may
not have any sales orders, and that we are also not interested in 
any sales orders that are not assigned to customers. We can use
an inner join. */

SELECT *
FROM Sales.SalesOrderHeader s
INNER JOIN Sales.Customer c
	ON c.CustomerID = s.CustomerID

/*

B - OUTER JOIN

An outer join preserves one or both of the tables; in other words, 
all rows from the preserved table(s) are included even if they don't 
match any rows in the other table. 

If you look back at the table diagrams, the first one that includes
both of the tables just before non-matching rows are excluded is an 
outer join. All the rows in the Equipment table are preserved. Notice
the NULLs in the non-preserved table (Section). 

(Outer Join 1)
+-------------------------------------------+--------------------------------------------+
|                EQUIPMENT                  |                 SECTION                    | 
+---+---------------------------------+-----+----+--------+--------+--------+------------+
|EID|Equipment Item                   |SecID|SID |CourseID|Location|Schedule|InstructorID|
+---+---------------------------------+-----+----+--------+--------+--------+------------+
|  1|Projector A                      |    1|   1|       2|B-245   |MW 1500 |         254|
|  2|Projector B                      |NULL |NULL|NULL    |NULL    |NULL    |NULL        |
|  3|Teleportation machine            |    4|   4|      34|B-156   |WF 1830 |         254|
|  4|High-gain antenna                |    4|   4|      34|B-156   |WF 1830 |         254|
|  5|Portable Hadron particle collider|    3|   3|       9|C-235   |WF 1830 |         122|
|  6|Reflection telescope             |NULL |NULL|NULL    |NULL    |NULL    |NULL        |
+---+---------------------------------+-----+----+--------+--------+--------+------------+

Because the table on the left side is preserved, this is called
a left outer join. In a left outer join, you might see rows with
NULLs in the columns on the right side. 

A right outer join would preserve the Section table, like this
(notice the NULLs on the left side this time):

(Outer Join 2)
+--------------------------------------------+-------------------------------------------+
|                 EQUIPMENT                  |                 SECTION                   |
+----+---------------------------------+-----+---+--------+--------+--------+------------+
|EID |Equipment Item                   |SecID|SID|CourseID|Location|Schedule|InstructorID|
+----+---------------------------------+-----+---+--------+--------+--------+------------+
|   1|Projector A                      |    1|  1|       2|B-245   |MW 1500 |         254|
|NULL|NULL                             |NULL |  2|       4|A-24    |TH 1400 |         189|
|   5|Portable Hadron particle collider|    3|  3|       9|C-235   |WF 1830 |         122|
|   4|High-gain antenna                |    4|  4|      34|B-156   |WF 1830 |         254|
|   3|Teleportation machine            |    4|  4|      34|B-156   |WF 1830 |         254|
|NULL|NULL                             |NULL |  5|       2|D-251   |MW 1500 |         189|
|NULL|NULL                             |NULL |  6|       9|C-235   |MW 1700 |         254|
+----+---------------------------------+-----+---+--------+--------+--------+------------+

There is also a full outer join, in which both tables are 
preserved, and so NULLs can appear on both sides, though
not on the same row! 

(Outer Join 3)
+--------------------------------------------+--------------------------------------------+
|                 EQUIPMENT                  |                 SECTION                   |
+----+---------------------------------+-----+----+--------+--------+--------+------------+
|EID |Equipment Item                   |SecID|SID |CourseID|Location|Schedule|InstructorID|
+----+---------------------------------+-----+----+--------+--------+--------+------------+
|   1|Projector A                      |    1|   1|       2|B-245   |MW 1500 |         254|
|   2|Projector B                      |NULL |NULL|NULL    |NULL    |NULL    |NULL        |
|NULL|NULL                             |NULL |   2|       4|A-24    |TH 1400 |         189|
|   3|Teleportation machine            |    4|   4|      34|B-156   |WF 1830 |         254|
|   4|High-gain antenna                |    4|   4|      34|B-156   |WF 1830 |         254|
|   5|Portable Hadron particle collider|    3|   3|       9|C-235   |WF 1830 |         122|
|   6|Reflection telescope             |NULL |NULL|NULL    |NULL    |NULL    |NULL        |
|NULL|NULL                             |NULL |   5|       2|D-251   |MW 1500 |         189|
|NULL|NULL                             |NULL |   6|       9|C-235   |MW 1700 |         254|
+----+---------------------------------+-----+----+--------+--------+--------+------------+

Here are a few things worth noting about outer joins:

1. Whether the outer join is a left or right outer join depends only
on the order of the tables. If we swap the order of the tables, 
the right outer join would resemble the left outer join from before
the swap and vice-versa.

2. Full outer joins are rare, because most of the time, the participation
of the table with the foreign key is total. In those cases, preserving
that table has no effect, since every row has a match in the other 
table.

Outer joins are useful in two general use case types:

1. Exception questions. Outer joins can answer questions like,
"Which equipment items are available (not assigned to sections)?",
"Which sections are not assigned any equipment?", "Which sales 
people did NOT place orders?", or "Which courses do NOT have 
sections?"

2. Optional data. Sometimes, we want to include data from another 
table in a query if those data exist. If there are rows that don't have 
matches in the new table, we don't want to lose those rows as a 
result of the join.

Let's have a look at some examples.

1. Outer Joins for Exception Questions 

"Which customers do NOT have sales orders?"

AdventureWorks recently held a sales fair and a number of 
propsective customers put their buisness cards into a jar.
All those were entered into the Customer table. Not all 
rows in the Customer table are for customers who have 
placed orders. Let's see which ones don't have orders. Maybe
we'll send them a coupon. 

We'll start by examining the data. List all customers and sales 
orders */

SELECT *
FROM Sales.Customer

SELECT *
FROM Sales.SalesOrderHeader

/* Verify that there are 19,185 customers and 31,465 sales orders.

Then use Object Explorer to verify that the CustomerID column
in the SalesOrderHeader table is a foreign key that references 
the CustomerID primary key in the Customer table.

Next, write a query that shows the CustomerID, the customer's
account number and type, and that also shows the sales order
number and  order date. The query should include only 
customers who have orders. 

Notice that there are 31,465 rows in the result, or one for
every order. */

SELECT cus.CustomerID
, cus.AccountNumber
, cus.CustomerType
, soh.SalesOrderNumber
, soh.OrderDate
FROM Sales.Customer cus
INNER JOIN Sales.SalesOrderHeader soh
	ON cus.CustomerID = soh.CustomerID

/* Every order has a matching customer, but how about the 
other way around? To find out if there are any customers
who do not have sales orders, we will perform an outer
join that preserves the customer table. In the query below,
the customer table is on the LEFT side of the JOIN 
statement. */

SELECT cus.CustomerID
, cus.AccountNumber
, cus.CustomerType
, soh.SalesOrderNumber
, soh.OrderDate
FROM Sales.Customer cus
LEFT OUTER JOIN Sales.SalesOrderHeader soh
	ON cus.CustomerID = soh.CustomerID

/* Notice in the results above that there are 66 more rows now.
This is because the outer join preserved the customer table and
now includes 66 customers who don't have orders (who don't have
matching rows in the SalesOrderHeader table). To see them, 
scroll to the bottom and notice that 66 rows have NULLs in all 
of the columns belonging to the SalesOrderHeader table. 

To see just those 66 customers, we can look for NULLs in that
table's primary key column. */

SELECT cus.CustomerID
, cus.AccountNumber
, cus.CustomerType
, soh.SalesOrderNumber
, soh.OrderDate
FROM Sales.Customer cus
LEFT OUTER JOIN Sales.SalesOrderHeader soh
	ON cus.CustomerID = soh.CustomerID
WHERE soh.SalesOrderID Is Null

/* 2. Outer Joins for Optional Data

Inner joins eliminate non-matching rows, so if you want
to include additional data from another table in your
query, any rows already in your query that have no 
matching rows in the new table will be eliminated. To
preserve them, use an outer join. In this case, the
additional data is treated as optional; we want to 
display it if it exists, but do nothing if it doesn't.

Let's say we have a query showing employee data. */

SELECT *
FROM HumanResources.Employee

/* ... and now we want to add employees' resumes if they
have them. The resume is optional data. If we use an inner
join, any employees without resumes will be eliminated.
The inner join shows that only two employees have resumes. */

SELECT *
FROM HumanResources.Employee e
JOIN HumanResources.JobCandidate jc
	ON e.EmployeeID = jc.EmployeeID 

/* To treat resumes as optional data, we must preserve the
Employee table. This left outer join does the trick. */

SELECT *
FROM HumanResources.Employee e
LEFT JOIN HumanResources.JobCandidate jc
	ON e.EmployeeID = jc.EmployeeID 


/* Exercise: Write the outer join statements that return the 
results shown in Outer Join 1, Outer Join2, and Outer Join3, 
above (scroll down for the answers):


















































































Outer Join 1:

SELECT *
FROM Equipment e
LEFT JOIN Section s
	ON e.SecID = s.SID

Outer Join 2:

SELECT *
FROM Equipment e
RIGHT JOIN Section s
	ON e.SecID = s.SID

Outer Join 3:

SELECT *
FROM Equipment e
FULL JOIN Section s
	ON e.SecID = s.SID

