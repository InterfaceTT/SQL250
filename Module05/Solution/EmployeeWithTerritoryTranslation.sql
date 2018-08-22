USE AdventureWorks;

SELECT sp.SalesPersonID
, c.LastName
, CASE 
	WHEN ST.[Group] = 'North America' 
				AND ST.NAME = 'Northwest'
				THEN 'NA NW'
	WHEN ST.[Group] = 'North America' 
				AND ST.NAME = 'Northeast'
				THEN 'NA NE'
	WHEN ST.[Group] = 'North America' 
				AND ST.NAME = 'Central'
				THEN 'NA Central'	
	WHEN ST.[Group] = 'North America' 
				AND ST.NAME = 'Southwest'
				THEN 'NA SW'	
	WHEN ST.[Group] = 'North America' 
				AND ST.NAME = 'Southeast'
				THEN 'NA SE'
	WHEN ST.[Group] = 'North America' 
				AND ST.NAME = 'Canada'
				THEN 'NA Canada'	
	ELSE 'Not in NA'
	END TranslatedTerritory	
FROM sales.SalesPerson AS SP
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN sales.SalesTerritory AS ST
ON sp.TerritoryID = st.TerritoryID;

-- OR

SELECT sp.SalesPersonID
, c.LastName
, CASE st.NAME 
	WHEN  'Northwest'
				THEN 'NA NW'
	WHEN 'Northeast'
				THEN 'NA NE'
	WHEN  'Central'
				THEN 'NA Central'	
	WHEN 'Southwest'
				THEN 'NA SW'	
	WHEN  'Southeast'
				THEN 'NA SE'
	WHEN  'Canada'
				THEN 'NA Canada'	
	ELSE 'Not in NA'
	END TranslatedTerritory	
FROM sales.SalesPerson AS SP
INNER JOIN HumanResources.Employee AS E
ON SP.SalesPersonID = E.EmployeeID
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
INNER JOIN sales.SalesTerritory AS ST
ON sp.TerritoryID = st.TerritoryID;