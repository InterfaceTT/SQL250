/* MODULE 8 DEMO 4: Stored Procedure Parameters

==== START SETUP ==== */

USE AdventureWorks

IF OBJECT_ID ( 'dbo.upRecallData', 'P' ) IS NOT NULL  
	DROP PROCEDURE dbo.upRecallData	

/* ==== END SETUP ==== 

In the previous demo, you created an inline table valued
function to act as a parameterized view for this query.
In this demo, you will put that function into a stored 
procedure to explore how stored procedure parameters behave. */

GO

CREATE PROCEDURE dbo.upRecallData
(@StartDate datetime
, @EndDate datetime
, @ProdSubCatID int)
AS
SELECT *
FROM dbo.fnRecallData(@StartDate, @EndDate, @ProdSubCatID)

GO

/* The company has just announced another recall of products in
subcategory id 27 except in the states of Washington (WA), Ohio
(OH), and Kansas (KS) that were sold between 5/20/2004 and 2/5/2005. 
Again, you have been asked to provide a list of all the customers to whom 
recall notices need to be sent out. The notices will include the 
customer names, their addresses (street, city, state and zip). 

Notice that right now you have no way to restrict the results to the state 
exceptions and customer address columns unless you hard-code it in the SP.*/	

GO

ALTER PROCEDURE dbo.upRecallData
(@StartDate datetime
, @EndDate datetime
, @ProdSubCatID int)
AS
SELECT Customer
, CusAddr1
, CusAddr2
, CusCity
, CusState
, CusZip
FROM dbo.fnRecallData(@StartDate, @EndDate, @ProdSubCatID)
WHERE ShiptoState IN ('WA', 'OH', 'KS')

GO

EXECUTE dbo.upRecallData '5/20/2004', '2/5/2005', 27

/* Another team is going to be using your stored procedure
but they need you to change it so that it will also return
the count of customers who need to be contacted. */

GO

ALTER PROCEDURE dbo.upRecallData
(@StartDate datetime
, @EndDate datetime
, @ProdSubCatID int
, @CusCount int OUTPUT)
AS
SELECT Customer
, CusAddr1
, CusAddr2
, CusCity
, CusState
, CusZip
FROM dbo.fnRecallData(@StartDate, @EndDate, @ProdSubCatID)
WHERE ShiptoState IN ('WA', 'OH', 'KS')

SELECT @CusCount = COUNT(*)
FROM dbo.fnRecallData(@StartDate, @EndDate, @ProdSubCatID)
WHERE ShiptoState IN ('WA', 'OH', 'KS')

GO

-- Test the changes.

DECLARE @CustomerCount int
EXECUTE dbo.upRecallData '5/20/2004', '2/5/2005', 27, @CustomerCount OUTPUT
SELECT @CustomerCount 


-- Cleanup

--DROP PROCEDURE dbo.upRecallData																																							