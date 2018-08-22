-- MODULE 3 DEMO 3: Processing Order

USE AdventureWorks

/* Here's a query that uses a calculated column. Notice
that it has no name in the result. */

SELECT FirstName
, LastName
, FirstName + ' ' + LastName -- Calculated column
FROM Person.Contact
 
/* To give the column a name, we create an alias for it 
(any column can be aliased, whether or not it is calculated).
We'll call it FullName. Notice the column name in the 
result. */

SELECT FirstName
, LastName
, FirstName + ' ' + LastName As FullName -- "FullName" is the alias of this calculated column
FROM Person.Contact

-- What happens when we try to use the alias in the WHERE clause?

SELECT FirstName
, LastName
, FirstName + ' ' + LastName As FullName
FROM Person.Contact 
WHERE FullName = 'Jay Adams'

/* The alias, defined in the SELECT clause, is not recognized 
in the WHERE clause because the WHERE clause is processed
before the SELECT clause. To make this query work, we would have
to repeat the calculation in the WHERE clause. */

SELECT FirstName
, LastName
, FirstName + ' ' + LastName As FullName
FROM Person.Contact 
WHERE FirstName + ' ' + LastName = 'Jay Adams' /* Repeat the 
calculation in the WHERE clause. */

/* All clauses of the Select statement are processed before
the SELECT clause with the exception of the ORDER BY clause;
aliases defined in the SELECT clause will be recognized in
the ORDER BY clause. */

SELECT FirstName
, LastName
, FirstName + ' ' + LastName As FullName
FROM Person.Contact 
ORDER BY FullName /* An alias created in the SELECT clause 
is recognized in the ORDER BY clause. */