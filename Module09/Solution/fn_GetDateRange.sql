USE AdventureWorks;

GO
CREATE FUNCTION dbo.fn_GetDateRange
(@StartDate date, @NumofDays int)
RETURNS @DateOutput TABLE (DayCount int, DateValue date)
AS
BEGIN;
DECLARE @Cnt int = 0;
WHILE (@Cnt < @NumofDays)
	BEGIN 
	    INSERT @DateOutput  VALUES(@Cnt + 1 , DATEADD(day, @cnt, @StartDate))
	    SET @Cnt += 1
	END;
	RETURN;
END;
GO

SELECT * FROM dbo.fn_GetDateRange('1/1/2010', 10);