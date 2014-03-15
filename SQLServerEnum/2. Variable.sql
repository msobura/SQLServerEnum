USE AdventureWorks2008R2
GO

DECLARE @Approved tinyint = 2;
DECLARE @Rejected tinyint = 4;

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status = @Approved

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status = @Rejected

-- pros
-- + Readable
-- + Reusable (in one scope)

-- cons
-- - Hard to mantaind
-- - Can easily produce bugs
-- - Bad for statistics