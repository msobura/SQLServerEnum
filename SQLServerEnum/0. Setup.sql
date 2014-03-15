USE AdventureWorks2008R2
GO

DECLARE @Count int;

SELECT
	@Count = COUNT(*)
FROM Sales.SalesOrderHeader AS SOH

DECLARE
	@inprocess int,
	@approved int,
	--@backordered int,
	@rejected int,
	@shipped int,
	@cancelled int;
	
SELECT
	@shipped = FLOOR(@Count * 0.5),
	@approved = FLOOR(@Count * 0.7),
	@inprocess = FLOOR(@Count * 0.8),
	@cancelled = FLOOR(@Count * 0.88),
	@rejected = FLOOR(@Count * 0.95);

WITH cteSOH AS (
	SELECT
		RowNumber = ROW_NUMBER() OVER (ORDER BY NEWID()),
		SOH.SalesOrderID,
		OrderStatus = SOH.Status
	FROM Sales.SalesOrderHeader AS SOH
)

UPDATE cteSOH SET
	OrderStatus =
		CASE
			WHEN RowNumber <= @shipped THEN 5 -- shipped
			WHEN RowNumber <= @approved THEN 2 -- approved
			WHEN RowNumber <= @inprocess THEN 1 -- in process
			WHEN RowNumber <= @cancelled THEN 6 -- cancelled
			WHEN RowNumber <= @rejected THEN 4 -- rejected
			ELSE 3 -- backordered
		END

SELECT
	SOH.Status,
	COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
GROUP BY SOH.Status

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]') AND name = N'IX_SalesOrderHeader_Status')
	DROP INDEX [IX_SalesOrderHeader_Status] ON [Sales].[SalesOrderHeader]
GO

CREATE INDEX IX_SalesOrderHeader_Status ON Sales.SalesOrderHeader (Status)
GO