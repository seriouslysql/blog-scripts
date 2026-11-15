SELECT 
    @@Servername AS instance_name,
    sd.name AS db_name, 
    sd.recovery_model_desc AS recovery_model,
    sdf.physical_name AS filename,
    sdf.name AS logical_name,
    (FILEPROPERTY(sdf.name, 'IsPrimaryFile')) AS primary_file,
    (FILEPROPERTY(sdf.name, 'IsLogFile')) AS is_log_file,
    CONVERT(DECIMAL(10,2), size/128.0/1024) AS size_GB,
    CONVERT(DECIMAL(10,2), FILEPROPERTY(sdf.name, 'SpaceUsed')/128.0/1024) AS space_used,
    CONVERT(DECIMAL(10,2), size/128.0/1024-(FILEPROPERTY(sdf.name, 'SpaceUsed')/128.0/1024)) AS space_available,
    CONVERT(DECIMAL(10,2), (FILEPROPERTY(sdf.name, 'SpaceUsed')/(size/128.0))/128.0*100) AS pct_used,
    sd.log_reuse_wait_desc
FROM sys.database_files AS sdf
CROSS APPLY
(
    SELECT * FROM sys.databases AS sdf
    WHERE name = DB_NAME()
) AS sd
-- Uncomment to show log files only
--WHERE (FILEPROPERTY(sdf.name, 'IsLogFile')) = 1
