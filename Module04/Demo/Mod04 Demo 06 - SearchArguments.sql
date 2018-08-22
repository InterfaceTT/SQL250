-- MODULE 4 DEMO 6: Search Arguments

USE AdventureWorks

/*
"Search argument" is a term that refers to the contents
of the WHERE clause and are best written in the COV
format (Column Operator Value) to allow it to take 
advantage of any indexes on the column specified.

Have a look at these two queries. Notice that both
will show all rows where the email address begins
with "Jay1". Which one is more efficient? */

SELECT *
FROM Person.Contact 
WHERE LEFT(EmailAddress, 4) = 'Jay1'

SELECT *
FROM Person.Contact 
WHERE EmailAddress LIKE 'Jay1%'

/* The second query is the better choice for a 
couple of reasons:

	1.	Functions are "heavy." If you can write your 
	    query without a function, you'll usually
		get faster results.

	2.	If there is an index on EmailAddress (and
		there is), the first query won't be able to 
		use it because the search argument is not in
		COV format.