/* MODULE 5 DEMO 3: String Functions

==== START SETUP ==== */

USE tempdb

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Customer')
	DROP TABLE dbo.Customer

SELECT *
INTO dbo.Customer
FROM (SELECT 1 As CustomerID, 'Achong' As LastName, 'Gustavo' As FirstName, '(781)555-1234' As Phone, 'gachong@millerco.com' As EmailAddress
	  UNION
      SELECT 2, 'McGrath', 'Catherine', '(602)555-1701', 'cmcgrath@armstrongspaces.com'
	  UNION
	  SELECT 3, 'Balboa', 'Kim', '(520)555-8943', 'kimbal@Abercrombie.net'
	  UNION
	  SELECT 4, 'Acevedo', 'Humberto', '(415)555-7605', 'humace125@yahoo.com'
	  UNION
	  SELECT 5, 'Nackerman', 'Pilar', '(409)555-2278', 'pilar@nackerman.com') NewData

USE AdventureWorks

/* ==== END SETUP ====

String functions allow the manipulation of string values. 

1. LEFT(), RIGHT(), and LOWER()

Earlier in the course, we saw a few string functions 
in the following query that uses the LEFT(), RIGHT(), 
and LOWER() functions. */

SELECT LastName
, FirstName
, LOWER(LEFT(LastName, 3) + RIGHT(FirstName, 2)) As InitialPassword
FROM Person.Contact

/* 2. SUBSTRING()

The SUBSTRING() function can  extract a substring from 
somewhere in the middle of a larger string. It uses 3 
arguments:
 
ARG 1: The larger string from which a substring will be 
extracted

ARG 2: The starting position in the larger string where the 
substring starts

ARG 3: The number of characters to extract. 

Here's a query from the sample customer table created in the
setup of this demo that extracts the area code of the phone 
number. Note that the SUBSTRING() function extracts 3 characters 
starting at position 2 in the product number.*/

USE tempdb

SELECT CustomerID
, Phone
, SUBSTRING(Phone, 2, 3) As AreaCode
FROM dbo.Customer

/* Below, we'll see an example of how to use SUBSTRING()
when the values in  ARG 2 or ARG 3 are not fixed
like in the example above, but vary from row to row.

3. CHARINDEX() 

The CHARINDEX() function finds the position of a
substring in a larger string. It uses 2 arguments:

ARG 1: The substring
ARG 2: The larger string containing the substring

In the following query, CHARINDEX() is used to find the 
position of the @ symbol in the email address. */

SELECT CustomerID
, EmailAddress
, CHARINDEX('@', EmailAddress) As AtPos
FROM dbo.Customer

/* Now, let's say we want to extract the domain part of the 
email address (the part of the email address after the
@ symbol). SUBSTRING() should do it for us, but the starting
position of the substring to extract (ARG 2) is not fixed; it
varies from row to row. We can use CHARINDEX() to tell 
SUBSTRING() what the starting position is; it will be at one
character position higher than the position of the @ symbol. */

SELECT CustomerID
, EmailAddress
, SUBSTRING(EmailAddress, CHARINDEX('@', EmailAddress) + 1, 100) As EmailDomain
FROM dbo.Customer

/*
4. STUFF()

Have you ever highlighted some text and then pasted 
something form the clipboard over it? The STUFF() 
function does just that. STUFF() arguments:

ARG 1: The text containing the text that will be 
'highlighted'

ARG 2: Starting position of what to highlight

ARG 3: Number of characters to highlight

ARG 4: The text to paste

In the following query, we use CHARINDEX() to determine
the value of ARG 2 in order to change all occurrences of
the word "tire" in the product name column to "fat tire". */

USE AdventureWorks

SELECT Name 
, STUFF(name, CHARINDEX('tire', name), 4, 'fat tire') As NameWFatTire
FROM Production.Product 
WHERE Name LIKE '%tire%'

/* 5. REPLACE()

The STUFF() function is not used all that often, because
there is another function, REPLACE(), that is much easier to
use, though it's not as focused as STUFF(). The REPLACE() 
function can be used to replace all occurrences of a sub-
string inside of another string. It has 3 arguments:

ARG 1: The string containing the substring to be replaced
ARG 2: The substring to be replaced
ARG 3: The substring that replaces the substring in ARG 2
*/

SELECT Name 
, REPLACE(name, 'tire', 'fat tire') As NameWFatTire
FROM Production.Product 
WHERE Name LIKE '%tire%'

-- CLEANUP

USE tempdb
DROP TABLE dbo.customer