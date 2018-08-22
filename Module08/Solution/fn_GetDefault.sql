USE Adventureworks;

GO
CREATE FUNCTION dbo.fn_GetDefault
(@Schema sysname
, @Table sysname
, @Column sysname)

RETURNS nvarchar(4000)
AS 

BEGIN;
	DECLARE @retdefault nvarchar(4000);
	SELECT TOP 1 
	        @retdefault =  REPLACE(REPLACE(REPLACE(COLUMN_DEFAULT, '(', ''), ')', ''), '''', '')
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = @Schema
	AND TABLE_NAME = @Table
	AND COLUMN_NAME = @Column;
    
    RETURN @retdefault;
END;
GO

SELECT dbo.fn_GetDefault('sales', 'salesorderheader', 'status');