SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    STATS_DATE(i.object_id, i.index_id) AS StatsUpdated,
    DATEDIFF(DAY, STATS_DATE(i.object_id, i.index_id), GETDATE()) AS DaysOld
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL -- Skips heaps
ORDER BY DaysOld DESC
GO
