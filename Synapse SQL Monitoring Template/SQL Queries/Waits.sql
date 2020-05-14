
 SELECT
	s.login_name as [User]
,	W.object_name as [Object Name]
,	CASE S.[app_name]
		WHEN 'Microsoft SQL Server Management Studio' THEN 'SSMS'
		WHEN 'Microsoft SQL Server Management Studio - Query' THEN 'SSMS'
	ELSE S.[app_name]
	END AS [Application]
,	W.wait_id
,	W.session_id 
,	R.request_id
--,	W.type as [WaitType]
,	W.request_time
--,	W.acquire_time
,	W.state as [Wait State]
,	s.client_id
,	R.[status] as [Query Status]
,	DATEADD(hour,-4,CAST(R.submit_time as datetime2(0))) as [Submit Time]
,	DATEADD(hour,-4,CAST(R.start_time as datetime2(0))) as [Start Time]
,	DATEADD(hour,-4,CAST(R.end_compile_time as datetime2(0))) as [End Compile Time]
,	DATEADD(hour,-4,CAST(R.end_time as datetime2(0))) as [End Time]
,	CAST((R.[total_elapsed_time]/1000)/60.0 AS DECIMAL(12,2)) AS [ElapsedMinutes]
,	R.[command] as [Command]
,	R.[resource_class] as [Resource Class]
,	R.[importance] as [Importance]
--,	R.[group_name]
,	R.[resource_allocation_percentage]
--,	R.[result_cache_hit]
FROM
sys.dm_pdw_waits AS W
INNER JOIN 
	SYS.dm_pdw_exec_sessions AS S 
		ON W.[session_id] = S.[session_id] 
INNER JOIN 
	SYS.DM_PDW_EXEC_REQUESTS AS R
		ON W.[request_id] = R.[request_id]
WHERE
S.session_id <> session_id()		