USE AdventureWorks2008R2
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Enum].[vSalesOrderHeader_Status_Failed]'))
	DROP VIEW [Enum].[vSalesOrderHeader_Status_Failed]
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Enum].[vSalesOrderHeader_Status]'))
	DROP VIEW [Enum].[vSalesOrderHeader_Status]
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = N'Enum')
	DROP SCHEMA [Enum]
GO

CREATE SCHEMA Enum;
GO

CREATE VIEW Enum.vSalesOrderHeader_Status
AS
	SELECT
		InProcess = 1,
		Approved = 2,
		Backordered = 3,
		Rejected = 4,
		Shipped = 5,
		Cancelled = 6
GO

SELECT *
FROM Enum.vSalesOrderHeader_Status AS SOHS

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status IN (
		SELECT
			SOHS.Approved
		FROM Enum.vSalesOrderHeader_Status AS SOHS
	)
GO

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status IN (
		SELECT
			SOHS.Rejected
		FROM Enum.vSalesOrderHeader_Status AS SOHS
	)
GO
	
CREATE VIEW Enum.vSalesOrderHeader_Status_Failed
AS
	SELECT
		SalesOrderHeader.Status
	FROM (
		SELECT SOHS.Backordered FROM Enum.vSalesOrderHeader_Status AS SOHS
		UNION ALL
		SELECT SOHS.Rejected FROM Enum.vSalesOrderHeader_Status AS SOHS
		UNION ALL
		SELECT SOHS.Cancelled FROM Enum.vSalesOrderHeader_Status AS SOHS		
	) AS SalesOrderHeader(Status)
GO

SELECT
    SOHSF.Status
FROM Enum.vSalesOrderHeader_Status_Failed AS SOHSF

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status IN (
		SELECT
			SOHSF.Status
		FROM Enum.vSalesOrderHeader_Status_Failed AS SOHSF
	)
GO

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status IN (3, 4, 6)
GO

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Enum].[vSalesOrderHeader_Status_Failed]'))
	DROP VIEW [Enum].[vSalesOrderHeader_Status_Failed]
GO

CREATE VIEW Enum.vSalesOrderHeader_Status_Failed
AS
    SELECT
        SalesOrderHeader.Status
    FROM (
	    SELECT 3 -- Backordered
	    UNION ALL
	    SELECT 4 -- Rejected
	    UNION ALL
	    SELECT 6 -- Cancelled	
    ) AS SalesOrderHeader(Status)
GO

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status IN (
		SELECT
			SOHSF.Status
		FROM Enum.vSalesOrderHeader_Status_Failed AS SOHSF
	)
GO

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status IN (3, 4, 6)
GO

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

-- pros
-- + Readeable
-- + Reausable (whole database)
-- + Quite good for statistics
-- + Can be easily extended
-- + Easy to mantain

-- cons
-- - Require a change in how the queries are written
-- - Can't be used in indexed views