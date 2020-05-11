
SELECT 
	S.[session_id]
,	CASE S.[app_name]
		WHEN 'Microsoft SQL Server Management Studio' THEN 'SSMS'
		WHEN 'Microsoft SQL Server Management Studio - Query' THEN 'SSMS'
		ELSE S.[app_name]
	END AS [Application]
,	S.[status] as [Session Status]
,	S.[request_id] as [Latest Request ID]
,	S.client_id
--,	S.sql_spid
--,	S.[Security_id] 
,	S.[login_name] as [User]
,	S.query_count as [Count of Queries]
,	DATEADD(hour,-4,CAST(S.Login_Time as datetime2(0))) as [Login Time]
,	CASE
		WHEN S.[status] = 'Active' THEN
			DATEDIFF(minute,CAST(S.login_Time as datetime2(0)),CAST(CURRENT_TIMESTAMP as datetime2(0)))
		ELSE 
			NULL
	END AS [Session Minutes]
FROM 
sys.dm_pdw_exec_sessions AS S
WHERE session_id <> session_id() AND
CAST(DATEADD(HOUR,-4,s.login_time) AS date) = CAST(DATEADD(HOUR,-4,CURRENT_TIMESTAMP) AS date)