-- MODULE 5 DEMO 5: CASE Structure

USE AdventureWorks

/* The CASE structure is similar to a function in that
it also returns a single value, but it does so by evaluating
one or more expressions, with each expression associated
with a value. The value returned will be the one associated
with the first expression found to be True. 

The CASE structure starts with the word CASE, ends with the word
END, and consists of one or more WHEN/THEN pairs that contain an
expression to be evaluated and a value to be returned if that
expression evaluates to TRUE. 

Confused? Let's see it in action.

In this example, and for each row in Production.Product, the
first WHEN clause to be found TRUE will cause the value in
the corresponding THEN clause to be returned. */

SELECT ProductNumber 
, ProductLine
, Category =	CASE  
					WHEN ProductLine = 'R' THEN 'Road' 
					WHEN ProductLine = 'M' THEN 'Mountain' 
					WHEN ProductLine = 'T' THEN 'Touring' 
					WHEN ProductLine = 'S' THEN 'Other sale items' 
					ELSE 'Not for sale' 
				END  
, Name 
FROM Production.Product 
ORDER BY ProductNumber 

/* When the expression being compared in the WHEN clause is 
always the same and the comparisson is an equality comparison, 
the CASE structure can be simplified so that the expression
being compared appears right after the word CASE and the WHEN
clauses contain only the values to which the expression is  
compared. 

These conditions are met in the example above that uses an 
equality comparison of the ProductLine in every WHEN clause so 
it can be written using the simplified version of the CASE 
structure. */

SELECT ProductNumber 
, ProductLine
, Category =	CASE ProductLine
					WHEN 'R' THEN 'Road' 
					WHEN 'M' THEN 'Mountain' 
					WHEN 'T' THEN 'Touring' 
					WHEN 'S' THEN 'Other sale items' 
					ELSE 'Not for sale' 
				END  
, Name 
FROM Production.Product 
ORDER BY ProductNumber  

/* The first example is referred to as a Searched CASE and the 
second example is referred to as a Simple CASE.

Here is another example of a Searched CASE that decides what 
text to display depending on the range of the ListPrice. 
Notice that this cannot be written as a Simple CASE because
equality comparisons are not being used. */

SELECT ProductNumber 
, ProductLine
, ListPrice
, PriceRange =	CASE 
					WHEN ListPrice = 0 THEN 'Mfg item - not for resale' 
					WHEN ListPrice < 50 THEN 'Under $50' 
					WHEN ListPrice >= 50 and ListPrice < 250 THEN 'Under $250' 
					WHEN ListPrice >= 250 and ListPrice < 1000 THEN 'Under $1000' 
					ELSE 'Over $1000'  
				END
, Name 
FROM Production.Product 
ORDER BY ProductNumber  

/* Notice that the last two WHEN clauses in the CASE 
structure above can be simplified to the following. 
(For the 3rd WHEN to be used, the first two must have
failed. If they failed, it's because ListPrice is not 
< 50, so we don't have to check for that in the 3rd
WHEN. Same thing for the 4th WHEN.) */

SELECT ProductNumber 
, ProductLine
, ListPrice
, PriceRange =	CASE 
					WHEN ListPrice = 0 THEN 'Mfg item - not for resale' 
					WHEN ListPrice < 50 THEN 'Under $50' 
					WHEN ListPrice < 250 THEN 'Under $250' 
					WHEN ListPrice < 1000 THEN 'Under $1000' 
					ELSE 'Over $1000'  
				END
, Name 
FROM Production.Product 
ORDER BY ProductNumber 

/* In the following example, the CASE structure is used 
to display output that is more meaningful to human eyes than 
the data values that are actually stored in the table (0 or
1).  */

SELECT EmployeeID
, CASE SalariedFlag
	WHEN 1 THEN 'Salaried Employee'
    WHEN 0 THEN 'Non-Salaried Employee'
  END as Salaried
FROM HumanResources.Employee

/* In the following example, the CASE structure is used to
determine how the XtraHours are calculated based on whether
or not an employee is salaried. */

SELECT EmployeeID
, XtraHours = CASE SalariedFlag
               WHEN 0 THEN SickLeaveHours
               WHEN 1 THEN SickLeaveHours + VacationHours
		      END
FROM HumanResources.Employee

