USE AdventureWorks2008R2
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'Sales.vSalesOrderHeader_Approved'))
	DROP VIEW Sales.vSalesOrderHeader_Approved
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'Sales.vSalesOrderHeader_Rejected'))
	DROP VIEW Sales.vSalesOrderHeader_Rejected
GO

CREATE VIEW Sales.vSalesOrderHeader_Approved
AS
	SELECT * -- presentation only, don't do it in production
	FROM Sales.SalesOrderHeader AS SOH
	WHERE SOH.Status = 2 -- Approved
GO

CREATE VIEW Sales.vSalesOrderHeader_Rejected
AS
	SELECT *
	FROM Sales.SalesOrderHeader AS SOH
	WHERE SOH.Status = 4 -- Rejected
GO

SELECT COUNT(*)
FROM Sales.vSalesOrderHeader_Approved

SELECT COUNT(*)
FROM Sales.vSalesOrderHeader_Rejected

-- pros
-- + Readable
-- + Reusable (whole database)
-- + Good for statistics

-- cons
-- - Require a lot of work to maintain
--     Change needs to be apply to table and view(s)
--     When name of the view changes we have to go through whole database and replace it