-- MODULE 3 DEMO 2: Database Object Naming

USE AdventureWorks

/*
Database object names have 4 parts: SERVER.DATABASE.SCHEMA.OBJECT

1. SERVER

The server component of the name requires the configuration of 
linked servers, which is beyond the scope of this course. All 
references to database objects in this course will be to objects
in the connected server. When left out of the name, the default
is the server to which the query window is connected.

2. DATABASE

The database name can be specified to access an object in a database
other than the one currently selected as the default database. when
left out of the name, the default database is the one selected in 
the Available Databases dropdown.

Select the tempdb database */

USE tempdb

/* The following query fails because there is no such table in the 
tempdb database */

SELECT *
FROM HumanResources.Employee

/* By including the database name, the query can find the table. 
Now it works. */

SELECT *
FROM AdventureWorks.HumanResources.Employee

/* Let's set the default database for the remainder of this demo. */

USE AdventureWorks

/*
3. SCHEMA

The schema can be omitted only if the referenced object is in the
dbo schema or the user's default schema.

The default schema of the dbo user (us) is also the dbo schema */

SELECT USER_NAME() As MyUserID, SCHEMA_NAME() As MyDefaultSchema

/* The schema is omitted in this query, but it works because the 
table is in the dbo schema. */

SELECT *
FROM DatabaseLog

/* The schama is omitted in this query. It fails because the table
is not in the dbo schema (which is also the user's default schema). */

SELECT *
FROM Employee

-- Here's the same query with the schema. Now it works. 

SELECT *
FROM HumanResources.Employee
																																																									