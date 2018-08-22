-- MODULE 4 DEMO 2: Data Type Precedence

USE AdventureWorks

/*
There is a hierarchy among data types in SQL Server; some
data types take precedence over others. While a comprehensive
listing of the hierarchy can be easily found on Google
(search: "Transact SQL data type precedence"), it is useful 
to remember at least this much:

Datetime data types are high in the hierarchy
Numeric data types are in the middle
Character data types are low in the hierarchy

As a rule of thumb, the more complex the data type, the higher
it is in the hierarchy. Among the numeric data types, for 
example, decimals are higher than integers.

Data type precedence can have a significant impact on query
results in two main areas.

1. Expressions with Different Data Types

Consider this example: We all know that 1/2 is 0.5.
Let's see what SQL Server does with this simple calculation: */

SELECT 1/2

/* Notice that the result is 0! What happened? 

The result of an expression also has a data type. SQL Server 
sets the data type of the result to the highest data type among 
the operands of the expression. In the expression we just ran, 
the two operands, 1 and 2, are both integers, so the highest 
data type among the operands is integer, and so that is the data 
type SQL Server use for the result.

If we want the result to be a decimal type, we have to "coerce"
one of the operands to that higher data type. */

SELECT 1.0/2

/* And now the result is the 0.5 we had expected because the 
highest data types among the operands is decimal (1.0).

2. Comparissons and Implicit Conversions

SQL Server can only compare values of the same data type. If the
values are of different data types, SQL Server will try to convert
one value to the data type of the other. This is called an 
"implicit conversion." Which value does SQL Server try to convert?
Always the value with the lowest precedence data type.

This query works because SQL Server succeeds in the implicit
conversion of the literal string value to the higher datetime data
type. */

SELECT *
FROM Person.Contact
WHERE ModifiedDate > '1/1/2004'

/* This query fails because SQL Server cannot convert the literal
string value to datetime. Notice that SQL Server never tries to
implicitly convert a value of a higher data type to a lower data 
type. */

SELECT *
FROM Person.Contact
WHERE ModifiedDate > 'Hello'

