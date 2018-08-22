USE AdventureWorks;

SELECT [Group]  TerritoryGroup
, [Name] TerritoryName
, SalesYTD TerritoryTotal
, SUM(SalesYTD) OVER(PARTITION BY [GROUP]) TerritoryGroupTotal
FROM sales.SalesTerritory
ORDER BY TerritoryGroup;

-- Extra Credit
SELECT [Group]  TerritoryGroup
, [Name] TerritoryName
, SalesYTD TerritoryTotal
, SUM(SalesYTD) OVER(PARTITION BY [GROUP]) TerritoryGroupTotal
, SalesYTD / SUM(SalesYTD) OVER(PARTITION BY [GROUP]) * 100 [Percent]
FROM sales.SalesTerritory
ORDER BY TerritoryGroup, [Percent] DESC;