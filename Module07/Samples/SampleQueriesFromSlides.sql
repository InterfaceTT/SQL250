USE AdventureWorks;

-- INSERT with VALUES
INSERT INTO Person.Address
	    (AddressLine1, AddressLine2, City, StateProvinceID
	    		, PostalCode, ModifiedDate)
	VALUES ('1 Elm St',NULL,'Phoenix',6,'85020', DEFAULT)
		   , ('10 Oak St',NULL,'Tempe',6,'85281', DEFAULT); 
GO 
		  
-- INSERT with SELECT/EXECUTE
-- Won't execute 
INSERT INTO Person.Address
		(AddressLine1, AddressLine2, City, StateProvinceID, PostalCode)
	SELECT Address1, Address2, CityName, sp.StateProvinceID, zipcode
		FROM dbo.NewAddresses na
			INNER JOIN Person.StateProvince sp
				ON na.StateCode = sp.StateProvinceCode;
GO
 
INSERT INTO Person.Address
		(AddressLine1, AddressLine2, City, StateProvinceID, PostalCode)
	EXECUTE dbo.usp_NewAddresses;
GO

--Using the OUTPUT Clause with INSERT
INSERT INTO Production.ProductModel (Name, ModifiedDate)
OUTPUT inserted.ProductModelID
, inserted.Name Name
, inserted.ModifiedDate
, suser_sname() UserName 
VALUES ('Racing Bike', getdate());
GO

-- Using SELECT INTO
SELECT AddressLine1 AS Address1
, AddressLine2 AS Address2
, City
, sp.StateProvinceCode StateCode
, PostalCode AS ZipCode
INTO #TempAddresses
FROM Person.Address a
		INNER JOIN Person.StateProvince sp
			ON a.StateProvinceID = sp.StateProvinceID;
GO

-- The DELETE Statement
DELETE FROM Sales.SalesOrderHeader
	WHERE ShipDate < DATEADD(MONTH, -6, GETDATE()); 
GO

-- Using the OUTPUT clause with DELETE
DELETE Production.ProductModel
OUTPUT deleted.ProductModelID, suser_sname() UserName
WHERE ProductModelID = 20;
GO

-- DELETE with JOIN or Subquery
DELETE FROM Sales.SalesOrderDetail
	FROM Sales.SalesOrderDetail sd
		INNER JOIN Sales.SalesOrderHeader sh
		ON sd.SalesOrderID = sh.SalesOrderID
	WHERE ShipDate < DATEADD(MONTH, -6, GETDATE());
GO

DELETE FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN
		(SELECT SalesOrderID
		FROM Sales.SalesOrderHeader
		WHERE ShipDate < DATEADD(MONTH, -6, GETDATE()));
GO

-- The UPDATE Statement
UPDATE Sales.SalesOrderHeader
		SET DueDate = '9/5/2004'
		, ShipDate = '9/1/2004'
		WHERE SalesOrderID = 75119;
GO
		
-- Using OUTPUT Clause with UPDATE
UPDATE Production.ProductModel
SET Name = 'Mountain-200-W'
OUTPUT inserted.ProductModelID
, deleted.Name OldName
, inserted.Name NewName
WHERE ProductModelID = 20;
GO

-- Update with JOIN and Subquery
UPDATE Sales.SalesPerson
	SET salesytd = sumorders
	FROM Sales.SalesPerson sp
	INNER JOIN (SELECT salespersonid, territoryid 
                ,sum(totaldue) sumorders
		        FROM Sales.SalesOrderHeader
		        WHERE orderdate BETWEEN '1/1/2004' AND '12/31/2004'
		        GROUP BY salespersonid, territoryid) sh
		            ON sp.salespersonid = sh.salespersonid 
		               AND sp.territoryid = sh.territoryid;
GO

UPDATE Sales.SalesPerson  
  SET salesytd = (SELECT ISNULL(sum(totaldue), 0)
		FROM sales.salesorderheader sh
		WHERE orderdate BETWEEN '1/1/2004' AND '12/31/2004'
		   AND Sales.SalesPerson.salespersonid = sh.salespersonid 
		   AND Sales.SalesPerson.territoryid = sh.territoryid);
GO

-- The MERGE Statement
MERGE Production.UnitMeasure AS target 
USING (SELECT UnitMeasureCode
	  , Name
	  FROM SourceData) AS source 
ON (target.UnitMeasureCode = source.UnitMeasureCode)
WHEN MATCHED THEN 
	UPDATE SET name = source.Name
WHEN NOT MATCHED THEN 
	INSERT (UnitMeasureCode, Name)
	     VALUES(source.UnitMeasureCode, source.Name);
GO
	    
 -- Using the OUTPUT Clause with MERGE
MERGE Production.UnitMeasure AS target
USING (SELECT UnitMeasureCode, Name
			FROM SourceData) AS source
ON (target.UnitMeasureCode = source.UnitMeasureCode
WHEN MATCHED THEN
	UPDATE SET name = source.Name
WHEN NOT MATCHED THEN
	INSERT (UnitMeasureCode, Name)
			VALUES(source.UnitMeasureCode, source.Name)
OUTPUT $action, Inserted.UnitMeasureCode 
, deleted.Name OldName
, inserted.UnitMeasureCode  NewName;
GO  

