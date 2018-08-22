/* MODULE 7 DEMO 1a: Transactions

==== START SETUP ==== */

USE tempdb

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'TestData')
	DROP TABLE dbo.TestData

CREATE TABLE dbo.TestTable
(TestTableID int IDENTITY(1,1) PRIMARY KEY,
 TestName nvarchar(20))

INSERT INTO dbo.TestTable (TestName)
  VALUES ('Row 1')
		,('Row 2')
		,('Row 3')
		,('Row 4');

/* ==== END SETUP ====

A transactions is an atomic unit of work that is made up 
of one or more changes to a database. Transactions are 
useful when a group of changes to the database must either
all succeed or all fail.

Imagine you are transferring money from your checking account
to your savings account. Two modifications need to be made to
the database. Your checking account has to be debited and your
savings account has to be credited. If the debit goes through 
but the credit fails, you will have lost money! To prevent this,
both the debit and the credit must take place inside the same 
transaction. 

This demo shows you how to set up a transaction and demonstrates
how data modifications are affected by a transaction. It is 
important to follow all steps carefully. If the demo seems to
skip a step, it is because that step is in the Demo 1b file. 

STEP 1 - Create and populate a test table in tembpb. There is no 
transaction in place at this time. By default, transaction mode
is autocommit. That means that whatever changes you make are 
automatically and immediately committed. */

SELECT * FROM dbo.TestTable

-- STEP 2 - Update the test table

UPDATE dbo.TestTable 
SET TestName = 'Update 1'
WHERE TestTableID = 1;

-- STEP 3 - Switch to DEMO 1b, STEP 4

/* STEP 6 - Back from DEMO 1b. Since we are not in an active 
transaction, the ROLLBACK statemenet will generate an error. */ 

ROLLBACK

-- STEP 7 - Now try the same in a transaction

BEGIN TRANSACTION -- We enter explicit transaction mode

UPDATE dbo.TestTable 
SET TestName = 'Update 2'
WHERE TestTableID = 2;

UPDATE dbo.TestTable 
SET TestName = 'Update 3'
WHERE TestTableID = 3;
GO

/* STEP 8 - Query the table from within this transaction. Do 
the updates appear? */

SELECT * FROM dbo.TestTable

/* STEP 9 - How do things look to another user? Switch to 
DEMO 1b. You'll find step 10 there.
 
STEP 12 - Back from DEMO 1b, rollback the transaction. */ 

ROLLBACK -- This completes the transaction

/* STEP 13 - Now that the transaction has completed, check 
to see that the changes are not in the test table. */

SELECT * FROM dbo.TestTable

/* STEP 14 - continue to STEP 15 in DEMO 1b.

STEP 16 - Clean up  */

DROP TABLE dbo.TestTable