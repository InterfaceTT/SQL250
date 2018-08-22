-- MODULE 4 DEMO 3: Logical Operators and Shortcuts

USE AdventureWorks

/* 
A logical expression is one that evaluates to a value of 
True or False. Here are some examples that, when used in a 
WHERE clause, evaluate to True or False for each row:

Birthdate >= '1/1/1950'
Title = 'Recruiter'
Color = 'Blue'

Logical operators allow us to combine multiple logical
expressions into a larger one using the logical operators
AND and OR. When using the AND operator, both logical
expressions must evaluate to True for the entire expression
to evaluate to True. When using OR, only one of the logical
expressions must evaluate to True for the entire expression
to also evaluate to True.

For a row to be selected in the following query, both logical 
expressions must evaluate to True. In other words, its 
ModifiedDate must be BOTH greater than or equal to 1/1/1950 
and less than or equal to 12/31/1980. */

SELECT EmployeeID
, Title
, BirthDate
, VacationHours
FROM HumanResources.Employee
WHERE BirthDate >= '1/1/1950' 
  AND BirthDate <= '12/31/1980'

/* As you can see, the AND operator can be used to define a 
range of values, but be careful not to fall into a common trap! 

When defining a range of values for a column, both expressions 
use the same column (in this case Birthdate). It is tempting to
write the expression like this, which is wrong:

Birthdate >= '1/1/1950' AND '12/31/1980'

This will generate an error, because the part on the right side
of the AND is not a complete logical expression!

Ranges can also be defined using the BETWEEN operator. The 
following query is equivalent to the one above. There is no 
performance gain or loss using this approach, it's just easier 
to read. (The AND in this expression is not a logical operator;
it is just part of the syntax of the BETWEEN operator.) */

SELECT EmployeeID
, Title
, BirthDate
, VacationHours
FROM HumanResources.Employee
WHERE BirthDate BETWEEN '1/1/1950' AND '12/31/1980'

/* For a row to be selected in the following query, at least
one of the logical expressions has to evaluate to True. In 
other words, the title has to be either Recruiter, Buyer, or
Stocker. */

SELECT EmployeeID
, Title
, BirthDate
, VacationHours
FROM HumanResources.Employee
WHERE Title = 'Recruiter'
   OR Title = 'Buyer'
   OR Title = 'Stocker'

/* In the previous query, the same column--Title--is checked
against a list of possibile values using the OR operator. 
Lists can also be defined using the IN operator. The following 
query is equivalent to the one above. there is no performance 
gain or loss using this approach, it's just easier to read 
(and write). */

SELECT EmployeeID
, Title
, BirthDate
, VacationHours
FROM HumanResources.Employee
WHERE Title IN ('Recruiter', 'Buyer', 'Stocker')

