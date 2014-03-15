USE AdventureWorks2008R2
GO

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status = 2 -- Approved

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status = 4 -- Rejected

-- pros
-- + Quite good for query plan (statistics)

-- cons
-- - Extremly hard/impossible to mantain
-- - Can easily produce bugs
-- - Completly unreadable