USE AdventureWorks;

-- Using the GROUP BY Clause
SELECT productid
, salesorderid 
, orderqty
FROM Sales.SalesOrderDetail;
GO

SELECT productid
, SUM(orderqty) totalqty
FROM Sales.SalesOrderDetail
GROUP BY productid;
GO

SELECT productid
, SUM(orderqty) totalqty
FROM Sales.SalesOrderDetail
WHERE productid = 942
GROUP BY productid;
GO

-- GROUP BY with HAVING
SELECT productid
, salesorderid 
, orderqty
FROM Sales.SalesOrderDetail;
GO

SELECT productid
, SUM(orderqty) totalqty
FROM Sales.SalesOrderDetail
GROUP BY productid
HAVING AVG(orderqty) >= 2;
GO

-- Pivoting Data
;WITH ProductSalesByYear
AS
(
SELECT p.Name ProductName,
YEAR(soh.OrderDate) AS OrderYear,
SUM(sod.LineTotal) AS Amount
FROM Production.Product p
  INNER JOIN  Sales.SalesOrderDetail sod
    ON p.ProductID = sod.ProductID
  INNER JOIN Sales.SalesOrderHeader soh 
    ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.Name, YEAR(soh.OrderDate)
)
SELECT ProductName, [2002], [2003], [2004]
FROM ProductSalesByYear
PIVOT(
SUM(Amount)
FOR OrderYear
IN( [2002], [2003], [2004])
) AS P;
GO

-- Combining Aggregate Values with Details
SELECT p.name ProductName
, p.listprice
, sod.avgunitprice AS average
FROM Production.Product p
	INNER JOIN (SELECT productid
      			 , AVG(unitprice-unitpricediscount) avgunitprice
		  	     FROM Sales.SalesOrderDetail
		  	     GROUP BY productid) sod
    	ON p.productid = sod.productid;
GO
	
-- Over Clause with Aggregate Functions
SELECT salesorderid
, orderdate
, totaldue
, totaldue / SUM(totaldue) OVER()*100 per
, totaldue - AVG(totaldue) OVER() diff
, SUM(totaldue) OVER() AS sumtotaldue
FROM Sales.SalesOrderHeader;
GO

SELECT salesorderid
, orderdate
, totaldue
, totaldue / SUM(totaldue) OVER(PARTITION BY YEAR(orderdate))*100 per
, totaldue - AVG(totaldue) OVER(PARTITION BY YEAR(orderdate)) diff
, SUM(totaldue) OVER(PARTITION BY YEAR(orderdate)) sumtotalduebyyear
FROM Sales.SalesOrderHeader;
GO

-- ROW_NUMBER Function
SELECT SalesOrderID
, OrderDate
, ROW_NUMBER() OVER(PARTITION BY YEAR(OrderDate), Month(OrderDate) 
					ORDER BY OrderDate) RowNum
FROM Sales.SalesOrderHeader;
GO

-- RANKING Functions
SELECT ProductID
, Name ProductName
, ListPrice
, RANK() OVER(PARTITION BY ProductSubcategoryID
				ORDER BY ListPrice DESC) [Rank]
, DENSE_RANK() OVER(PARTITION BY ProductSubcategoryID
			   ORDER BY ListPrice DESC) [DenseRank] 		   	  
FROM Production.Product
WHERE ProductSubcategoryid IS NOT NULL;
GO

-- NTILE Function
;WITH TwoTILE
AS
(
SELECT ProductLine
, ListPrice
, NTILE(2) OVER(PARTITION BY ProductLine
				ORDER BY ListPrice) [NTile]
FROM Production.Product
WHERE ProductLine IS NOT NULL
AND ListPrice IS NOT NULL
)
SELECT ProductLine
, MAX(CASE 
     		WHEN [NTile] = 1
     		THEN ListPrice 
     		ELSE 0 END) MedianListPrice
FROM TwoTILE
GROUP BY ProductLine;
GO
