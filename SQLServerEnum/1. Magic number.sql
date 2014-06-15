USE AdventureWorks2008R2
GO

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status = 2 -- Approved
OPTION (RECOMPILE)

SELECT COUNT(*)
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.Status = 4 -- Rejected
OPTION (RECOMPILE)

-- pros
-- + Quite good for query plan (statistics)

-- cons
-- - Completely unreadable
-- - Extremely hard/impossible to maintain
-- - Can easily produce bugs or misunderstandings