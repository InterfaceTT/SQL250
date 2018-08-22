-- MODULE 8 DEMO 6: Cross Apply

USE AdventureWorks

/* The cross apply is a useful operation when you need
something that behaves like a correlated join. 

Create an inline table valued function that returns the top
parameterized number of products that have the highest list
price for a paramterized subcategory id. */

GO

CREATE FUNCTION dbo.fnGetMostExpensiveProducts(@ProductSubCatID AS int,
@rownum AS INT) RETURNS TABLE
AS
RETURN
SELECT TOP(@rownum) *
FROM Production.Product
WHERE ProductSubCategoryID = @ProductSubCatID
ORDER BY ListPrice DESC

GO

/* Use the new function to display the top 3 products by list 
price for each subcategory. */

SELECT sc.name, p2.Name, p2.ListPrice
FROM Production.ProductSubcategory sc
CROSS APPLY dbo.fnGetMostExpensiveProducts
(sc.productsubcategoryid,3) p2