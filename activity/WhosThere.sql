SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    r.start_time,
    DATEDIFF(SECOND, r.start_time, GETDATE()) AS duration_seconds,
    r.cpu_time,
    r.reads,
    r.writes,
    r.blocking_session_id,
    SUBSTRING(
        t.text,
        (r.statement_start_offset / 2) + 1,
        ((CASE r.statement_end_offset
            WHEN -1 THEN DATALENGTH(t.text)
            ELSE r.statement_end_offset
          END - r.statement_start_offset) / 2) + 1
    ) AS current_statement,
    t.text AS full_batch,
    r.plan_handle
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_exec_requests r
    ON s.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE s.is_user_process = 1
ORDER BY r.start_time ASC
