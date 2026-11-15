SELECT TOP 50
    rh.restore_date,
    rh.destination_database_name AS Destination,
    bs.database_name AS Source,
    bmf.physical_device_name AS Device,
    rh.[user_name] AS Who,
    CASE rh.restore_type
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Transaction Log'
        ELSE rh.restore_type
    END AS RestoreType,
    rh.[replace],
    rh.[recovery]
FROM msdb.dbo.restorehistory rh
INNER JOIN msdb.dbo.backupset bs ON rh.backup_set_id = bs.backup_set_id
INNER JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
--WHERE rh.destination_database_name = 'dba' -- Uncomment to check one database
ORDER BY rh.restore_date DESC
GO
