
SELECT
	S.[login_name] as [User]
,	CASE S.[app_name]
		WHEN 'Microsoft SQL Server Management Studio' THEN 'SSMS'
		WHEN 'Microsoft SQL Server Management Studio - Query' THEN 'SSMS'
	ELSE S.[app_name]
	END AS [Application]
,	S.[status] as [Session Status]
,	S.client_id
,	R.[request_id]
,	R.[session_id]
,	R.[status] as [Query Status]
,	DATEADD(hour,-4,CAST(R.submit_time as datetime2(0))) as [submit_time]
,	DATEADD(hour,-4,CAST(R.start_time as datetime2(0))) as [start_time]
--,	DATEADD(hour,-4,CAST(R.end_compile_time as datetime2(0))) as [send_compile_time]
,	DATEADD(hour,-4,CAST(R.end_time as datetime2(0))) as [end_time]
,	CAST((R.[total_elapsed_time]/1000)/60.0 AS DECIMAL(12,2)) AS [ElapsedMinutes]
,	R.[command] as [Command]
,	R.[resource_class] as [Resource Class]
,	R.[importance] as [Importance]
,	R.[group_name]
,	R.[resource_allocation_percentage] as [Resource Alloc %]
,	R.[result_cache_hit]
,	CAST(DATEADD(HOUR,-4,CURRENT_TIMESTAMP) AS date) as [Query Date]
FROM SYS.DM_PDW_EXEC_REQUESTS AS R
INNER JOIN 
	SYS.dm_pdw_exec_sessions AS S 
		ON R.[session_id] = S.[session_id] 
WHERE
s.session_id <> session_id()
AND
CAST(DATEADD(HOUR,-4,R.submit_time) AS date) = CAST(DATEADD(HOUR,-4,CURRENT_TIMESTAMP) AS date)