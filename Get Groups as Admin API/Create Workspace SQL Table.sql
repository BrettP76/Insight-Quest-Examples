DROP TABLE IF EXISTS BIMonitoring.PBIWorkspaces;
CREATE TABLE BIMonitoring.PBIWorkspaces
(
	[Workspace ID] NVARCHAR(150) NOT NULL
,	[IsReadOnly] NVARCHAR(50) NULL
,	[IsOnDedicatedCapacity] NVARCHAR(10) NULL
,	[CapacityId] NVARCHAR(75) NULL
,	[CapacityMigrationStatus] NVARCHAR(50) NULL
,	[Workspace Type] NVARCHAR(50) NOT NULL
,	[Workspace State] NVARCHAR(50) NOT NULL
,	[Workspace Name] NVARCHAR(150) NULL
,	[Dashboards] NVARCHAR(MAX) NULL
,	[Reports] NVARCHAR(MAX) NULL
,	[Datasets] NVARCHAR(MAX) NULL
,	[Users] NVARCHAR(MAX) NULL
,	[Date Loaded] datetime2(0) NOT NULL
CONSTRAINT PK_BIM_WSID PRIMARY KEY ([Workspace ID])
);