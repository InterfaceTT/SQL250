-- MODULE 7 DEMO 1b: Transactions

/* STEP 4 - Another user can see the changes because
they were auto-committed. */

USE tempdb

SELECT * FROM dbo.TestTable

/* STEP 5 - Continue at STEP 6 in DEMO 1a.

Step 10 - Back from Demo 1a. Query the table as another 
user outside the transaction currently active in DEMO 1a. 
Notice that SQL Server waits for the transaction in
DEMO 1a to complete. */

USE tempdb

SELECT * FROM dbo.TestTable

/* Step 11 - Let SQL Server continue to wait here. Switch 
back to the DEMO 1a and continue at Step 12. 

Step 15 - Back from DEMO 1a. Notice below that the pending 
query has completed now that the transaction in DEMO 1a has 
completed. The changes made in that transaction
never showed up here because they were never committed. 
Return to DEMO 1b and continue at step 16. */
