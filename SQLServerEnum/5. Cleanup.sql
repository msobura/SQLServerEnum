USE AdventureWorks2008R2
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Enum].[Sales_SalesOrderStatus]'))
    DROP VIEW Enum.Sales_SalesOrderStatus;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Sales.SalesOrderStatus'))
    DROP TABLE Sales.SalesOrderStatus;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Enum].[GenerateView]'))
    DROP PROCEDURE Enum.GenerateView;
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'Enum.vSalesOrderHeader_Status_Failed'))
	DROP VIEW Enum.vSalesOrderHeader_Status_Failed;
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'Enum.vSalesOrderHeader_Status'))
	DROP VIEW Enum.vSalesOrderHeader_Status;
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = N'Enum')
	DROP SCHEMA Enum;
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'Sales.SalesOrderHeader') AND name = N'IX_SalesOrderHeader_Status')
	DROP INDEX IX_SalesOrderHeader_Status ON Sales.SalesOrderHeader;
GO

UPDATE Sales.SalesOrderHeader SET
	Status = 5;