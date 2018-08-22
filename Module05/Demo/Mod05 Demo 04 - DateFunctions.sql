-- MODULE 5 DEMO 4: Date Functions

USE AdventureWorks

/* Date functions are heavily used in SQL Server to perform all
kinds of date calculations, including adding dates, getting
the difference between dates, extracting parts of dates, and
others.

MONTH(), DAY(), and YEAR()

These three functions extract different parts of a date as
integers. They have one argument which is the date from which 
to extract the part.

The following query extracts the month, day, and year of each
birthdate. */

SELECT CONVERT(VARCHAR, BirthDate, 101) As BirthDate
, MONTH(BirthDate) BDMonth
, DAY(BirthDate) DBDay
, YEAR(BirthDate) DBYear
FROM HumanResources.Employee

/* DATEPART()

DATEPART() performs the same kinds of extractions that the previous
3 functions do as well as other extractions. It has 2 arguments:

ARG 1: The part of the date to extract
ARG 2: The date from which to extract

This query also extracts the month, day, and year of the 
birthdate. */

SELECT BirthDate
, DATEPART(MONTH, BirthDate) BDMonth
, DATEPART(DAY, BirthDate) BDDay
, DATEPART(YEAR, BirthDate) BDYear
FROM HumanResources.Employee

/* This query uses DATEPART() to get the day of the week on which
employees were born. */

SELECT BirthDate
, DATEPART(WEEKDAY, BirthDate) BDDOW
FROM HumanResources.Employee

/* This statement displays the day of the year of the current date. */

SELECT GETDATE(), DATEPART(DY, GETDATE())

/* DATENAME()

DATENAME is similar to DATEPART() but it returns string values,
instead. 

This statement returns the current day of the week in string format. */

SELECT DATENAME(WEEKDAY, GETDATE())
 
/* In the following query, the sales manager wants to order all 
sales by month name. Notice that while the query displays the name 
of the month, it orders the results by the number of the month. */

SELECT SalesOrderID
, OrderDate
, DATENAME(MONTH, OrderDate) OrderMonth
FROM Sales.SalesOrderHeader
ORDER BY MONTH(OrderDate)
 
/* DATEADD()

The DATEADD() function allows us to add time to a date. It 
has 3 arguments:

ARG 1: The unit of time to be added
ARG 2: The number to add of that unit
ARG 3: The date to which time will be added

The following statement adds 30 days to the current date. */

SELECT DATEADD(DAY, 30, GETDATE())
 
/* In this example, HR needs to send a records renewal form 
to employees 30 days before the first aniversary of their 
hire dates. The following query displays the employee id, 
hire date, the one-year anniversary of their hire date, and 
the date on which the form needs to go out. */

SELECT EmployeeID
, HireDate
, DATEADD(YEAR, 1, HireDate) Anniversary
, DATEADD(DAY, -30, DATEADD(YEAR, 1, HireDate)) SendDate
FROM HumanResources.Employee
 
/* As seen earlier in the course, a 
derived table subquery can be used to avoid having to repeat 
the calculation of the Anniversary column, though in this 
case that might be an overkill. */

SELECT EmployeeID
, HireDate
, Anniversary
, DATEADD(DAY, -30, Anniversary) SendDate
FROM 
	(SELECT EmployeeID
	, HireDate
	, DATEADD(YEAR, 1, HireDate) Anniversary
	FROM HumanResources.Employee) Emp
	
/* To determine the last day of the month, we add one month 
to the first date of the month and then subtract one day 
from that. */

SELECT DATEADD(d, -1, DATEADD(m, 1, '6/1/2012'))
 

/* In this example, HR wants to give employees a small 
birthday gift, but Accounting requires that such gifts be 
made on the last day of the month. Notice that
the last day of the month has to be assembled from the 
birthdate and the current date. The following query will 
generate an error, can you explain why? */

SELECT BirthDate
, LastDayOfBirthMonth = DATEADD(d, -1, DATEADD(m, 1, MONTH(BirthDate) + '/1/' + YEAR(GETDATE())))
FROM HumanResources.Employee

/* In the previous query, the MONTH() and YEAR() functions return
integer data types. The query also attempts an operation on those
return values and the string '/1/', so SQL Server attempts an 
implicit conversion. As you already know, when SQL Server tries to 
do an implicit conversion, it is always the value of the lowest
data type in the hierarchy of data types that it tries to convert 
to the highest data type in the operation. The highest data type 
in the operation is an integer, so it tries to convert the string
'/1/' to an integer, which can't be done. 

The way to solve this is to explicitly convert the results of the
two functions to strings. */

SELECT BirthDate
, LastDayOfBirthMonth = DATEADD(d, -1, DATEADD(m, 1, CAST(MONTH(BirthDate) As VARCHAR) + '/1/' + CAST(YEAR(GETDATE()) As VARCHAR)))
FROM HumanResources.Employee 

/* ... and while we're at it, let's format the dates properly, too, 
using the style argument of the CONVERT() function. */

SELECT CONVERT(VARCHAR, BirthDate, 101)
, LastDayOfBirthMonth = CONVERT(VARCHAR, DATEADD(d, -1, DATEADD(m, 1, CAST(MONTH(BirthDate) As VARCHAR) + '/1/' + CAST(YEAR(GETDATE()) As VARCHAR))), 101)
FROM HumanResources.Employee 

/* DATEDIFF()

DATEDIFF calculates the difference between two dates and 
returns the difference in the time unit specified. It has
3 arguments:

ARG 1: The unit of time in which the difference will be
expressed

ARG 2: The earliest date in the difference

ARG 3: The latest date in the difference 

This statement will show the number of days between 1/1/1900 
and the current date. */

SELECT DATEDIFF(DAY, '1/1/1900', GETDATE())

/*
DATEDIFF() QUERY 2: Display the number of days between today 
and the first day of the current year. Notice how the first 
day of the year is “assembled” as a string value first and 
then cast as a datetime. */

SELECT DATEDIFF(dd, CAST('01/01/' + DATENAME(yyyy, GETDATE()) as datetime), GETDATE())
 
/* Employees who are 55 or over are eligible for a complimentary 
enrollment in an aggressive retirement savings plan. Write a 
query that finds all employees who are 55 or over. Display the 
employees’ ids, birthdates, and ages. */

SELECT EmployeeID
, BirthDate
, DATEDIFF(YEAR, BirthDate, GETDATE()) Age
FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) >= 55
 
/* (More accurate age calculation). Note that we divide the number 
of days between the birthdate and the current date (6/1/2012) by 
365.25 to account for leap years. The FLOOR function returns the 
largest integer less than or equal to the numeric expression 
specified as its argument. If you read that carefully, it just 
means that, for positive numbers, the Floor function truncates the 
decimal portion and returns only the integer portion. */

SELECT EmployeeID
, BirthDate
, FLOOR(DATEDIFF(DAY, BirthDate, GETDATE())/365.25) Age
FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) >= 55

/* This next set of queries illustrates an issue working
with equality comparisons on datetime values. 

You have developed a query that pulls all contact records 
that were modified on 5/16/2005, but you get no results. */

SELECT ContactID
, FirstName
, LastName
, ModifiedDate
FROM Person.Contact
WHERE ModifiedDate = '5/16/2005'
 
/* You believe that there are contacts that were modified on 
that date, so you verify this by running the query again with
the WHERE clause commented out and notice that there are indeed 
contacts that were modified on that date, but you also notice 
that they have a time portion that is interfering with your 
original query: */

SELECT ContactID
, FirstName
, LastName
, ModifiedDate
FROM Person.Contact
--WHERE ModifiedDate = '5/16/2005'

/* You re-write your original query so that the time portion is not 
used in your filter. There are a few ways to do that. Probably the
easiest is to convert the data in the database to DATE, which drops
and time components. */

SELECT ContactID
, FirstName
, LastName
, ModifiedDate
FROM Person.Contact
WHERE CONVERT(DATE, ModifiedDate) = '5/16/2005'

/* If you want to use an approach that doesn't use functions, you 
can specify a range that starts on and includes the date you're
looking for and goes up to but does not include the next day (notice
the >= and the < operators). */

SELECT ContactID
, FirstName
, LastName
, ModifiedDate
FROM Person.Contact
WHERE ModifiedDate >= '5/16/2005' AND ModifiedDate < '5/17/2005'