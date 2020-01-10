TRUNCATE TABLE BIMonitoring.PBIWorkspaces;

Declare @WorkspacesJSON varchar(max)

SELECT @WorkspacesJSON = BulkColumn FROM OPENROWSET (BULK 'C:\Users\Brett Powell\Desktop\PBIAdminFiles\PBIGroupsExpanded.json', SINGLE_NCLOB) as j
INSERT INTO BIMonitoring.PBIWorkspaces
(
	[Workspace ID],IsReadOnly,IsOnDedicatedCapacity,CapacityId,CapacityMigrationStatus,[Workspace Type],[Workspace State],[Workspace Name],
	Dashboards,Reports,Datasets,Users,[Date Loaded]
	)
SELECT 
	W.id AS [Workspace ID]
,	W.isReadOnly AS [IsReadOnly]
,	W.isOnDedicatedCapacity AS [IsOnDedicatedCapacity]
,	W.capacityId as [CapacityId]
,	W.capacityMigrationStatus as [CapacityMigrationStatus]	
,	W.[type] as [Workspace Type]
,	W.[state] as [Workspace State]
,	W.[name] as [Workspace Name]
,	W.[dashboards] as [Dashboards]
,	W.[reports] as [Reports]
,	W.[datasets] as [Datasets]
,	W.[users] as [Users]
,	CURRENT_TIMESTAMP
FROM OPENJSON (@WorkspacesJSON,'$.value')
WITH(
	id NVARCHAR(150),
	isReadOnly NVARCHAR(10),
    isOnDedicatedCapacity NVARCHAR(10),
	capacityId NVARCHAR(75),
	capacityMigrationStatus NVARCHAR(50),
	[type] NVARCHAR(50),
	[state] NVARCHAR(50),
	[name] NVARCHAR(150),
	[dashboards] NVARCHAR(max) AS JSON,
	[reports] NVARCHAR(max) AS JSON,
	[datasets] NVARCHAR(max) AS JSON,
	[users] NVARCHAR(max) AS JSON
	) AS W;