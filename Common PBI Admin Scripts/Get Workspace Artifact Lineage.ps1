<#
Retrive Power BI workspaces as an admin API
https://docs.microsoft.com/en-us/rest/api/power-bi/admin/groups_getgroupsasadmin
#>

#1. Authenticate to Power BI as an admin interactively
Connect-PowerBIServiceAccount

#2. Define URL with filters for active worksapces and export file (JSON)
$ActiveGroupsURLExPersonal = '/admin/groups?$top=5000&' + '$filter=type eq' + " 'Workspace'" + ' and state eq' + " 'Active'" + `
 '&$expand=dashboards,reports,datasets,dataflows,workbooks,users'

$WSArtifactFile = "C:\Users\Brett Powell\Desktop\WSArtifacts.json"

#3. Retrieve worksapces with expanded artifacts
$WorkspaceArtifacts = Invoke-PowerBIRestMethod -Url $ActiveGroupsURLExPersonal -Method Get 

#4. Export out JSON file
$WorkspaceArtifacts | Out-File $WSArtifactFile
