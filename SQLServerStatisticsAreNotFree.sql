/* Let's setup our environment */
-- STEP 1:
USE master
GO
IF DB_ID('DemoStatistics') IS NOT NULL
DROP DATABASE [DemoStatistics];
GO
USE master
GO
CREATE DATABASE [DemoStatistics]
GO
USE DemoStatistics
GO
IF OBJECT_ID('dbo.Address') IS NOT NULL
DROP TABLE [dbo].[Address];
GO
CREATE TABLE [dbo].[Address](
[AddressLine1] [VARCHAR](512) NOT NULL,
[City] [VARCHAR](50) NOT NULL,
[StateProvinceID] [INT] NOT NULL,
[PostalCode] [VARCHAR](20) NOT NULL
)
GO
INSERT INTO [dbo].[Address]
([AddressLine1],[City],[StateProvinceID],[PostalCode])
SELECT '15 Pear Dr.' AS [AddressLine1],'New York' AS [City],10 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '150 Pear Dr.' AS [AddressLine1],'New York' AS [City],10 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '4460 Newport Center Drive' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '8238 D Crane Ct.' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '4915 Pear Dr.' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '9106 Edwards Ave.' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '2061 Matchstick Drive' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '6920 Merriewood Drive' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '1113 Catherine Way' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '9089 San Jose Ave' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '1144 Paradise Ct.' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode] UNION ALL
SELECT '9211 Holiday Hills Drive' AS [AddressLine1],'Newport Beach' AS [City],9 AS [StateProvinceID],'92625' AS [PostalCode]
GO 10
-- Verify is create and update statistics are enabled
SELECT name
,is_auto_create_stats_on
,is_auto_update_stats_on
FROM sys.databases
WHERE name = 'DemoStatistics'
GO
SELECT COUNT(1) AS TotalRows FROM [dbo].[Address] WITH (NOLOCK)
GO
/* CHECK IF AUTO CREATE STATISTICS TAKE PLACE */
-- STEP 2:
SELECT
	OBJECT_NAME([sp].[object_id]) AS "Table",
	[sp].[stats_id] AS "Statistic ID",
	[s].[name] AS "Statistic",
	[sp].[last_updated] AS "Last Updated",
	[sp].[rows],
	[sp].[rows_sampled],
	[sp].[unfiltered_rows],
	[sp].[modification_counter] AS "Modifications"
FROM [sys].[stats] AS [s]
OUTER APPLY sys.dm_db_stats_properties ([s].[object_id],[s].[stats_id]) AS [sp]
WHERE [s].[object_id] = OBJECT_ID(N'[dbo].[Address]');
GO
/* SET STATISTICS IO, TIME ON AND FLUSH THE BUFFER CACHE */
-- STEP 3:
SET STATISTICS IO, TIME ON
GO
-- STEP 4:
DECLARE @dbid int = DB_ID() 
DBCC FLUSHPROCINDB(@dbid)
GO
/* BELOW QUERY WILL FORCE AUTO CREATE STATISTICS TO TAKE PLACE */
-- STEP 5:
SELECT * 
FROM [dbo].[Address]
WHERE City = 'Newport Beach'
GO
/* CHECK IF STATISTICS CREATED */
-- STEP 6:
SELECT
	OBJECT_NAME([sp].[object_id]) AS "Table",
	[sp].[stats_id] AS "Statistic ID",
	[s].[name] AS "Statistic",
	[sp].[last_updated] AS "Last Updated",
	[sp].[rows],
	[sp].[rows_sampled],
	[sp].[unfiltered_rows],
	[sp].[modification_counter] AS "Modifications"
FROM [sys].[stats] AS [s]
OUTER APPLY sys.dm_db_stats_properties ([s].[object_id],[s].[stats_id]) AS [sp]
WHERE [s].[object_id] = OBJECT_ID(N'[dbo].[Address]');
GO
-- STEP 7:
DECLARE @dbid int = DB_ID() 
DBCC FLUSHPROCINDB(@dbid)
GO
-- STEP 8:
SELECT * 
FROM [dbo].[Address]
WHERE City = 'Newport Beach'
GO

/* AUTO UPDATE STATISTICS */
-- STEP 9:
INSERT INTO [dbo].[Address]
([AddressLine1],[City],[StateProvinceID],[PostalCode])
SELECT * FROM [dbo].[Address] WITH (NOLOCK)
GO 10
SELECT COUNT(1) AS TotalRows FROM [dbo].[Address] WITH (NOLOCK)
GO
/* CHECK IF STATISTICS UPDATED OR OUTDATED */
SELECT
	OBJECT_NAME([sp].[object_id]) AS "Table",
	[sp].[stats_id] AS "Statistic ID",
	[s].[name] AS "Statistic",
	[sp].[last_updated] AS "Last Updated",
	[sp].[rows],
	[sp].[rows_sampled],
	[sp].[unfiltered_rows],
	[sp].[modification_counter] AS "Modifications"
FROM [sys].[stats] AS [s]
OUTER APPLY sys.dm_db_stats_properties ([s].[object_id],[s].[stats_id]) AS [sp]
WHERE [s].[object_id] = OBJECT_ID(N'[dbo].[Address]');
GO
/* FLUSH THE BUFFER CACHE */
-- STEP 10:
DECLARE @dbid int = DB_ID() 
DBCC FLUSHPROCINDB(@dbid)
GO
-- STEP 11:
SELECT * 
FROM [dbo].[Address]
WHERE City = 'Newport Beach'
GO
/* CHECK IF STATISTICS UPDATED OR OUTDATED */
-- STEP 12:
SELECT
	OBJECT_NAME([sp].[object_id]) AS "Table",
	[sp].[stats_id] AS "Statistic ID",
	[s].[name] AS "Statistic",
	[sp].[last_updated] AS "Last Updated",
	[sp].[rows],
	[sp].[rows_sampled],
	[sp].[unfiltered_rows],
	[sp].[modification_counter] AS "Modifications"
FROM [sys].[stats] AS [s]
OUTER APPLY sys.dm_db_stats_properties ([s].[object_id],[s].[stats_id]) AS [sp]
WHERE [s].[object_id] = OBJECT_ID(N'[dbo].[Address]');
GO
/* FLUSH THE BUFFER CACHE */
-- STEP 13:
DECLARE @dbid int = DB_ID() 
DBCC FLUSHPROCINDB(@dbid)
GO
-- STEP 14:
SELECT * 
FROM [dbo].[Address]
WHERE City = 'Newport Beach'
GO
-- STEP 15:
SET STATISTICS IO, TIME OFF
GO