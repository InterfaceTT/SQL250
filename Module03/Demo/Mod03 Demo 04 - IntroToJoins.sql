/* MODULE 2 DEMO 3: Introduction to Joins

*/

USE AdventureWorks

-- List all employees and contacts

SELECT *
FROM HumanResources.Employee

SELECT *
FROM Person.Contact

/* Make a note of a few things:
1. There are 290 rows in the Employee table
2. There are 19,972 rows in the Contact table
3. The last three columns of the Employee
table are CurrentFlag, rowguid, and ModifiedDate.

Also notice that the Employee table does not include any 
columns that hold employees' names, but it does include
a column called ContactID. Using Object Explorer, you 
can verify that this column is a foreign key that references 
the ContactID primary key in the Person.Contact table, where 
names are stored. 

So, to find the name of an employee, look up the employee's
ContactID in the Contact table. EmployeeID 2 has ContactID
1030. Let's look that up in the Contact table. */

SELECT FirstName, LastName
FROM Person.Contact
WHERE ContactID = 1030

/* That's fine if you just need to find someone's name, but 
what if you are developing a report that must show columns
from both tables? A join operation performs the same kind of
lookup, but it does it for all rows. Notice that all columns  
from both tables are included in the result and that the 
number of rows in the result is 290, the same number of rows
in the table with the foreign key. */

SELECT *
FROM HumanResources.Employee
JOIN Person.Contact 
	ON Employee.ContactID = Contact.ContactID

/* The result of a join is a derived table that includes 
all columns from both tables. 

Table aliases will simplify this query. Notice that once an 
alias is created for a table, the query will no longer 
recognize the table's name--only the alias, so all references 
to the table must be changed to the alias. 
*/

SELECT *
FROM HumanResources.Employee As emp
JOIN Person.Contact As con
	ON emp.ContactID = con.ContactID

/* The following query displays only some of the columns from
the derived table. */

SELECT EmployeeID
, LastName
, FirstName
, HireDate
FROM HumanResources.Employee As emp
JOIN Person.Contact As con
	ON emp.ContactID = con.ContactID

/* Both tables have a column called ContactID. If the query 
is asked to display the ContactID, it complains about the 
ambiguity. */

SELECT EmployeeID
, LastName
, FirstName
, HireDate
, ContactID
FROM HumanResources.Employee As emp
JOIN Person.Contact As con
	ON emp.ContactID = con.ContactID

/* To resolve the ambiguity, include a reference to the 
originating table. Though only ambiguous column names require 
this, it is good practice to identify the table of origin 
of every column. */

SELECT emp.EmployeeID
, con.LastName
, con.FirstName
, emp.HireDate
, con.ContactID
FROM HumanResources.Employee As emp
JOIN Person.Contact As con
	ON emp.ContactID = con.ContactID
