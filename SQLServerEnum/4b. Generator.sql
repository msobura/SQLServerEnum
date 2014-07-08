USE AdventureWorks2008R2
GO

/*
    The goal of the below stored procedure is to generate the view automatically from the system dictionary (which has specific columns: SalesOrderStatusID and ViewName).
    In real project the table (Sales.SalesOrderStatus) should be referenced in table Sales.SalesOrderHeader by FK (foreign key).

    1 = In process
    2 = Approved
    3 = Backordered
    4 = Rejected
    5 = Shipped
    6 = Cancelled
*/

CREATE PROCEDURE Enum.GenerateView
(
	@schemaName sysname,
	@tableName sysname,
	@primaryKeyColumnName sysname = NULL,
	@columnName sysname = N'ViewName'
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@primaryKeyColumnName IS NULL)
		SET @primaryKeyColumnName = @tableName + 'ID';
	
	DECLARE @sql nvarchar(max);
	
	SET @sql =
		N'SELECT '
		+ @primaryKeyColumnName
		+ ', ' + @columnName
		+ ' FROM ' + @schemaName + N'.' + @tableName;
	
	CREATE TABLE #Values
	(
		ID int,
		Value nvarchar(max)
	);

	INSERT #Values
	EXEC (@sql);

	DECLARE @viewName sysname
	SET @viewName = @schemaName + N'_' + @tableName;

	IF EXISTS (SELECT * FROM sys.objects AS O WHERE O.name = @viewName)
		SET @sql = 'ALTER ';
	ELSE
		SET @sql = 'CREATE ';

	SET @viewName = N'Enum.' + @viewName;

	SELECT
		@sql = 
		    @sql
			+ 'VIEW ' + @viewName
			+ ' AS '
			+ 'SELECT ' + STUFF(Pom.PlainText.value('(./text())[1]', 'nvarchar(max)'), 1, 2, '')
	FROM (
		SELECT
			N', ' + V.Value + N' = ' + CAST(V.ID AS nvarchar(max))
		FROM #Values AS V
		FOR XML PATH(''),
		TYPE
	) AS Pom(PlainText);

	EXEC (@sql);

	DROP TABLE #Values;
END
GO

CREATE TABLE Sales.SalesOrderStatus
(
	SalesOrderStatusID int NOT NULL,
	Name nvarchar(100) NOT NULL,
	ViewName nvarchar(100) NOT NULL
	CONSTRAINT PK_SalesOrderStatus PRIMARY KEY CLUSTERED (SalesOrderStatusID)
)
GO

CREATE TRIGGER Sales.iduSalesOrderStatus 
    ON Sales.SalesOrderStatus 
    AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
    SET NOCOUNT ON;

    EXEC Enum.GenerateView 'Sales', 'SalesOrderStatus';
END
GO

-- After insert the trigger will execute the porcedure that generates the corresponding view
INSERT INTO Sales.SalesOrderStatus (
	SalesOrderStatusID,
	Name,
	ViewName
)
VALUES
	(1, N'In process', N'InProcess'),
	(2, N'Approved', N'Approved'),
	(3, N'Backordered', N'Backordered'),
	(4, N'Rejected', N'Rejected'),
	(5, N'Shipped', N'Shipped'),
	(6, N'Cancelled', N'Cancelled');

SELECT *
FROM Enum.Sales_SalesOrderStatus;