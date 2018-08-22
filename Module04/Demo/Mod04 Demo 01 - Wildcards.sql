-- MODULE 4 DEMO 1: WildCards

USE AdventureWorks

/*
Wildcards allow fuzzy searches.

In this query, we list all the titles in the Employee
table. The word DISTINCT removes duplicates. */

SELECT DISTINCT Title
FROM HumanResources.Employee

/* If we want to find all titles that start with Engineer, 
we can use the % wildcard that represents any number of 
characters from none to any number. When using wildcards, 
we must use the LIKE operator. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE 'Engineer%'

/*This next query will show all titles that end with 
Engineer. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%Engineer'

/* And this one shows all titles that contain the word 
Engineer either in the beginning, the end, or somewhere 
in the middle. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%Engineer%'

/* Scroll down and notice the WC codes in the titles 
starting on row 35. The following query shows all
titles with WC codes ending in 5. The underscore is a 
wildcard that represents only one character position. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%WC_5'

/* The following query shows all titles that contain the
numbers 1, 3 or 5 in the third position of the WC code.
The square brackets represent a single character position
and all the possible values that the query should find. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%WC[135]_'

/* This next query shows all titles except those with the
numbers 1, 3 or 5 in the third position of the WC code. The 
carrat symbol at the beginning of the square brackets tells
SQL Server to exclude those numbers from the result. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%WC[^135]_'

/* Square brackets can also define ranges. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%WC[1-4]_'

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%WC[^1-4]_'

/* What if we want to look for characters in the data that 
are also used as wildcards?

The following SQL commands will modify the titles of two
employee records to include underscores and square brackets. */

UPDATE HumanResources.Employee
SET Title = 'Design_Engineer'
WHERE EmployeeID = 9

UPDATE HumanResources.Employee
SET Title = 'Marketing_Manager'
WHERE EmployeeID = 6

UPDATE HumanResources.Employee
SET Title = 'Marketing Assistant [1]'
WHERE EmployeeID = 2

UPDATE HumanResources.Employee
SET Title = 'Marketing Specialist [4]'
WHERE EmployeeID = 119

/* One way to find the underscore is to use square brackets. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%[_]%'

/* Another approach is to use an "escape character" 
defined in the WHERE clause. Any letter following the escape 
character in the search string will be treated as a literal and not 
as a wildcard. 

In the following query, the exclamation is declared as the 
escape character and is used in the search string to precede the 
underscore. This tells SQL Server that the square bracket will not 
be treated as a wildcard. This approach can be used for any of the
wildcard characters, including the underscore. */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%![%' ESCAPE '!'

/* Try the same query with different escape characters. Here it is
with a slash: */

SELECT DISTINCT Title
FROM HumanResources.Employee
WHERE Title LIKE '%/[%' ESCAPE '/'
