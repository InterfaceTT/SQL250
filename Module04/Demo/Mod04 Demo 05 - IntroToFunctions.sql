-- MODULE 4 DEMO 5: Intro to Functions

USE AdventureWorks

/* Functions are "machines" that do something and then
return a value. Because all functions return values,
we can use a function anywhere we'd use a value. Here's
an example that uses the GETDATE() function to get the 
current data and time: */

SELECT GETDATE()

/* All functions must include the parenthesis. The 
parenthesis holds any inputs that the function requires.
We call the inputs of a function its "arguments." Not 
all functions require arguments, such as the GETDATE()
function that you saw above.

Here is an example of a function that does require 
arguments. The LEFT() function extracts the specified 
number of characters from the left side of a string. The
first argument is the string from which characters will
be extracted, and the second argument is the number of
characters to extract. In the following example, the 
LEFT() function is used to extract the first 3 characters
of the LastName. */

SELECT FirstName
, LastName
, LEFT(LastName, 3)
FROM Person.Contact

/* Let's also concatenate (string together) the last 2 
characters of the first name to that in order to form an 
initial password. The following example uses the RIGHT() 
function to do that. */

SELECT FirstName
, LastName
, LEFT(LastName, 3) + RIGHT(FirstName, 2) As InitPwd
FROM Person.Contact

/* Because a function always returns a value, and because 
arguments are also values, a function can be used as an 
argument of another function. When a function is used this
way, we say that the function is nested. 

In the following example, we nest the functions in the 
concatenation above in the LOWER() function to convert all 
characters of the initial password to lower case. */

SELECT FirstName
, LastName
, LOWER(LEFT(LastName, 3) + RIGHT(FirstName, 2)) As InitPwd
FROM Person.Contact
