SELECT TOP 50 restore_date, Destination_database_name as Destination, database_name as Source,
Physical_device_name as Device, rh.User_Name as Who,
CASE restore_type
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Transaction Log'
END AS BackupType,
restore_type, replace, recovery
FROM msdb.dbo.restorehistory rh 
INNER JOIN msdb.dbo.backupset bs 
	ON rh.backup_set_id=bs.backup_set_id
INNER JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id =bmf.media_set_id
--WHERE destination_database_name = 'dba'
ORDER BY [rh].[restore_date] desc
