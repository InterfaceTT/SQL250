USE AdventureWorks;

WITH GroupRanking AS
(
SELECT [Group]  TerritoryGroup
, [Name] TerritoryName
, SalesYTD TerritoryTotal
, RANK() OVER(PARTITION BY [GROUP] ORDER BY [SalesYTD] DESC) Ranking
FROM sales.SalesTerritory
)
SELECT *
FROM GroupRanking
WHERE Ranking < 3;

-- OR

WITH GroupRanking AS
(
SELECT [Group]  TerritoryGroup
, [Name] TerritoryName
, SalesYTD TerritoryTotal
, ROW_NUMBER() OVER(PARTITION BY [GROUP] ORDER BY [SalesYTD] DESC) Ranking
FROM sales.SalesTerritory
)
SELECT *
FROM GroupRanking
WHERE Ranking < 3;