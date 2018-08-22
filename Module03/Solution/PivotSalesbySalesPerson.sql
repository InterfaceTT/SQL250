USE AdventureWorks;

SELECT sp.SalesPersonID
, c.LastName
, e.Title
, Sales.[2002]
, Sales.[2003]
, Sales.[2004]
FROM sales.SalesPerson AS SP
INNER JOIN HumanResources.Employee AS E
ON sp.SalesPersonID = E.EmployeeID
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN (SELECT 
    pvt.[SalesPersonID]
    ,pvt.[2002]
    ,pvt.[2003]
    ,pvt.[2004] 
FROM (SELECT 
        sp.[SalesPersonID]
        ,soh.[SubTotal]
        ,YEAR([OrderDate]) AS [Year] 
    FROM [Sales].[SalesPerson] sp 
        INNER JOIN [Sales].[SalesOrderHeader] soh 
        ON sp.[SalesPersonID] = soh.[SalesPersonID]
   ) AS soh 
PIVOT 
     (SUM([SubTotal]) 
          FOR [Year] 
          IN ([2002], [2003], [2004])
     ) AS pvt
) Sales
ON sp.SalesPersonID = sales.SalesPersonID;