/* MODULE 8 DEMO 1: Scaler User Defined Function

==== START SETUP ==== */

USE AdventureWorks

IF OBJECT_ID ( 'dbo.GetAge', 'FN' ) IS NOT NULL  
	DROP FUNCTION dbo.GetAge

/* ==== END SETUP ==== 

Create a scalar UDF calld dbo.GetAge that calculates 
the age of a person as of a date. The function will 
receive a birth date and the "as-of" date from the 
calling party and will return the age.
 */

GO

CREATE FUNCTION dbo.GetAge -- Function name
(@BirthDate datetime, @AsOfDate datetime) -- Parameters receive argument values from the calling party
RETURNS int	-- Data type of the return value
AS -- Announces the beginning of the body
BEGIN -- Delineates the beginning of the body

	-- Declare a variable @Age that can hold integers
	DECLARE @Age INT 

	/* Assign the value on the right side of the equal sign to the variable
	on the left side of it (@Age) */
	SET @Age = FLOOR(DATEDIFF(DAY, @BirthDate, @AsOfDate)/365.25)

	-- Return the contents of @Age back to the calling party
	RETURN @Age

END	-- Delineates the end of the body
	
GO

/* Use the function to display employee's ages on the 
current date. */

SELECT EmployeeID
, dbo.GetAge(BirthDate, GETDATE())
FROM HumanResources.Employee		

-- Cleanup

DROP FUNCTION dbo.GetAge																																							