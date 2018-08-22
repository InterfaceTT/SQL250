-- MODULE 5 DEMO 1: NULL Functions

USE AdventureWorks

/*
1. the NULLIF() Function

The NULLIF() function requires two arguments. If the two
arguments are the same value, the function returns a
NULL. If the values are different, it returns the first
argument. Let's see it in action.

The Human Resources Department uses the following 
calculation as part of a bonus calculation:

(SickLeaveHours * 5) / VacationHours

When a query that uses this calculation is run, a 
divide-by-zero error is returned. */

SELECT EmployeeID
, (SickLeaveHours * 5)/VacationHours PartialBonusFormula
FROM HumanResources.Employee
 
/*
Upon closer inspection of the Employee table, we discover
that 3 employees have zero vacation hours, which causes
the entire query to fail! Make a note of their ids (140, 
163, and 232). */

SELECT EmployeeID, VacationHours
FROM HumanResources.Employee
WHERE VacationHours = 0
 
/* The original query is modified to use the NULLIF() 
function to return a NULL if the VacationHours column 
is zero, preventing the error. Notice the NULL on 
employee ids 140, 163, and 232. Any operation that uses
a NULL will return a NULL. */

SELECT EmployeeID
, (SickLeaveHours * 5)/NULLIF(VacationHours, 0) PartialBonusFormula
FROM HumanResources.Employee

/* A NULL is not the same thing as a zero, but sometimes
you might want it to display a zero if its NULL. How can 
the query above be changed to display a zero if that 
result is NULL? The next function will help. 

2. The ISNULL() Function

The ISNULL() function requires two arguments and
returns the first one that is not Null. 

In the following example, the HR Department wants 
to display contact data in the format:

Title FirstName LastName

But when HR runs the following query, NULLs are 
returned in the FullName column for some of the 
contacts (see row 64). */

SELECT Title
, LastName
, FirstName
, FullName = Title + ' ' + FirstName + ' ' + LastName
FROM Person.Contact
 
/* 
On closer inspection of the query results, we
discover that the Title column sometimes 
contains a NULL, resulting in a NULL in the 
FullName calculation.

(When CONCAT_NULL_YIELDS_NULL is set to ON in 
SQL Server, which it is by default and future
versions of SQL Server will not have the option
to set it off, then the results of any
concatenation that includes a NULL always
results in a NULL.)  

In this next example, HR re-writes the query to 
leave out the title and the space that follows 
it if the Title is NULL, which fixes the problem. 
(If Title is NULL, then Title + '' will also be 
NULL. 

The ISNULL() function returns the first 
argument that is not NULL, so when the title is 
NULL, an empty string ('') will be returned 
instead of the title.) */

SELECT Title
, LastName
, FirstName
, FullName = ISNULL(Title + ' ', '') + FirstName + ' ' + LastName
FROM Person.Contact

/* By the way, now that we know about the ISNULL()
function, we can make that previous query return a
zero when the result is NULL */

SELECT EmployeeID
, ISNULL((SickLeaveHours * 5)/NULLIF(VacationHours, 0), 0) PartialBonusFormula
FROM HumanResources.Employee 

/*
3. The COALESCE() function

The ISNULL() function is ANSI-compliant, but 
Microsoft invented their own function called 
COALESCE() that does the samething that ISNULL() 
does but with the added benefit that it is not
restricted to just two arguments. The developer
can use many arguments.

In the following example, the Sales Department 
wants to display the Class of all products. The 
problem is that some products have a NULL in the 
Class column. In those cases, the Sales 
Department would like to display the Color of 
the product. Again, the problem is that some 
products have a NULL in the Color column, too. 
In those cases, the Sales Department would like 
to display the ProductNumber. The COALESCE() 
function is used to display the first column 
that does not contain a NULL. */
 
SELECT Name
, Class
, Color
, ProductNumber
, COALESCE(Class, Color, ProductNumber) FirstNotNull
FROM Production.Product 
 
/* Note: With snapshot isolation levels,
the COALESCE() function can return unexpected
results. If only two arguments are needed, it's
best to use the ISNULL() function. See MSDN for
more information about this. */
