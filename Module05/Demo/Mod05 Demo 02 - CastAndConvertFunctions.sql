-- MODULE 5 DEMO 2: CAST() and CONVERT() Functions

USE AdventureWorks

/*
Earlier in the course, we saw that SQL Server can 
perform implicit conversions. Sometimes, the conversion
that SQL Server chooses to perform (implicit conversion)
is not the one that is needed. In those cases, we need 
to perform those conversaions ourselves (explicit
conversion). Explicit conversions are performed using the 
CAST() or CONVERT() functions.

1. The Differences between CAST() and CONVERT()

In addition to the fact that CAST() is ANSI-
compliant while CONVERT() is a Microsoft extension,
the two functions are also different in the fact 
that the CONVERT() function uses a standard argument
list like other functions do, and CAST() uses a 
declarative phrase as its argument. 

Other than that, initially, the functions seem to be
the same. In the following query, the current date
and time returned by the GETDATE() function is 
converted from its original datetime data type to 
varchar, first by the CAST() function and then by the
CONVERT() function. */

SELECT GETDATE(), CAST(GETDATE() AS VARCHAR), CONVERT(VARCHAR, GETDATE())

/* 
So, what added value does the CONVERT() function 
provide? Unlike the CAST() function, the CONVERT()
function can also format its output using an optional
third argument to define the output style. 

Here, the second use of the CONVERT() function formats 
its output using the 101 output style. */

SELECT CONVERT(VARCHAR, GETDATE()), CONVERT(VARCHAR, GETDATE(), 101)

/* A complete listing of the format codes can be found
on MSDN (Google search: "Transact SQL convert function")

The CONVERT() function also supports formats for other 
data types in addition to dates. In the following
example, the UnitPrice (data type: MONEY) is converted 
to VARCHAR using an output style of 1. */

SELECT UnitPrice
, '$' + CONVERT(VARCHAR(20), UnitPrice, 1) AS UnitPrice2
FROM Sales.SalesOrderDetail

/*
2. Explicit Conversions

Remember data type precedence? In a comparison between
two values of different data types, SQL Server will 
always convert the value of the lower data type to the
higher one--never the other way around! When the 
conversion needs to be made the other way around, it 
must be done explicitly with either the CAST() or 
CONVERT() functions.

The following query fails because SQL Server tries to
convert the string '/1/' to an integer since that is the
highest data type among the operands (the DAY() and
YEAR() functions both return integers). It fails at the
attempted implicit conversion because the value of the 
string includes non-digit characters. */

SELECT 
DAY(BirthDate) + '/1/' + YEAR(BirthDate) As FirstDayOfBirthMonth
FROM HumanResources.Employee

/* To fix the problem, the query developer must
explicitly convert the results of the two functions to 
string (in this case, VARCHAR is used), instead. */

SELECT 
CAST(DAY(BirthDate) As VARCHAR) + '/1/' + CAST(YEAR(BirthDate) As VARCHAR) As FirstDayOfBirthMonth
FROM HumanResources.Employee