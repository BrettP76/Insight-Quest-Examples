/*
Create five views based on workspace table:
	1) workspace users
	2) workspaces
	3) workspace reports
	4) workspace datasets
	5) workspace dashboards
*/

--1. Create workspace users view
CREATE VIEW BIMonitoring.vDim_PBIWorkspaceUsers
AS
SELECT
	P.[Workspace ID]
,	P.[Workspace Name]
,	U.[emailAddress] AS [Email Address]
,	U.[groupUserAccessRight] AS [Workspace Role]
,	U.[identifier] AS [Identifier]
,	U.[principalType] AS [Principal Type]
FROM
BIMonitoring.PBIWorkspaces AS P 
CROSS APPLY 
	OPENJSON(P.Users) 
		WITH 
		(	emailAddress NVARCHAR(150)
		,	groupUserAccessRight NVARCHAR(100)
		,	identifier NVARCHAR(100)
		,   principalType NVARCHAR(75)
		) AS U;

GO

--2. Create workspace view
CREATE VIEW BIMonitoring.vDim_PBIWorkspaces
AS
SELECT
	P.[Workspace ID]
,	P.[Workspace Name]
,	P.IsReadOnly
,	P.IsOnDedicatedCapacity
,	P.CapacityId AS [Premium Capacity ID]
,	P.CapacityMigrationStatus
,	P.[Workspace Type]
,	P.[Workspace State]
FROM
BIMonitoring.PBIWorkspaces AS P;

GO

--3. Create Workspace reports view
CREATE VIEW BIMonitoring.vDim_PBIWorkspaceReports
AS
SELECT
	P.[Workspace ID]
,	P.[Workspace Name]
,	R.ID AS [Report ID]
,	R.reportType AS [Report Type]
,	R.[name] as [Report Name]
,	R.[datasetId] as [Dataset ID]
FROM
BIMonitoring.PBIWorkspaces AS P
CROSS APPLY 
	OPENJSON(P.Reports)
		WITH
		(
			id NVARCHAR(150)
		,	reportType NVARCHAR(25)
		,	[name] NVARCHAR(200)
		,	datasetId NVARCHAR(150)
		) AS R;
GO

--4. Create workspace datasets view
CREATE VIEW BIMonitoring.vDim_PBIWorkspaceDatasets
AS
SELECT
	P.[Workspace ID]
,	P.[Workspace Name]
,	D.ID AS [Dataset ID]
,	D.[name] as [Dataset Name]
,	D.addRowsAPIEnabled
,	D.configuredBy
,	D.isRefreshable
,	D.isEffectiveIdentityRolesRequired
,	D.isOnPremGatewayRequired
,	D.targetStorageMode
FROM
BIMonitoring.PBIWorkspaces AS P
CROSS APPLY 
	OPENJSON(P.Datasets)
		WITH
		(
			id NVARCHAR(150)
		,	[name] NVARCHAR(200)
		,	addRowsAPIEnabled NVARCHAR(10)
		,	configuredBy NVARCHAR(200)
		,	isRefreshable NVARCHAR(10)
		,	isEffectiveIdentityRolesRequired NVARCHAR(10)
		,	isOnPremGatewayRequired NVARCHAR(10)
		,	targetStorageMode NVARCHAR(50)
		) AS D;

GO

--5. Create workspace dashboards view
CREATE VIEW BIMonitoring.vDim_PBIWorkspaceDashboards
AS
SELECT
	P.[Workspace ID]
,	P.[Workspace Name]
,	D.id AS [Dashboard ID]
,	D.displayName as [Dashboard Name]
,	D.isReadOnly
FROM
BIMonitoring.PBIWorkspaces AS P
CROSS APPLY 
	OPENJSON(P.Dashboards)
		WITH
		(
			id NVARCHAR(150)
		,	[displayName] NVARCHAR(200)
		,	[isReadOnly] NVARCHAR(10)
		) AS D;

