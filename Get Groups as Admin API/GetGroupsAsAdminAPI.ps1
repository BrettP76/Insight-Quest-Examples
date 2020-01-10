
#1. Values for admin credentials stored in remote file 

. C:\BIAdminScripts\AdminCreds.ps1

#2. Authenticate to Power BI

$SecPasswd = ConvertTo-SecureString $PBIAdminPW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($PBIAdminUPN,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#3. Path for JSON file 

$PBIGroupsFile = "C:\Users\Brett Powell\Desktop\PBIAdminFiles\PBIGroupsExpanded.json"

#4. URL string for admin groups API

$ActiveGroupsURLExPersonal = '/admin/groups?$top=5000&' + '$filter=type ne' + " 'PersonalGroup'" + ' and state eq' + " 'Active'" + '&$expand=dashboards,reports,datasets,users'

#5. Retrieve workspace data (with expanded values) and write to the JSON file

Invoke-PowerBIRestMethod -Url $ActiveGroupsURLExPersonal -Method Get | Out-File $PBIGroupsFile


<#
Alternative #1:  Workspaces (active or not) excluding personal workspaces

$GroupsURLExMyWorkspace = '/admin/groups?$top=5000&' + '$filter=type ne' + " 'PersonalGroup'" + '&$expand=dashboards,reports,datasets,users'

Invoke-PowerBIRestMethod -Url $GroupsURLExMyWorkspace -Method Get | Out-File $PBIGroupsFile
#>

<#
Alternative #2: Active workspaces only including personal workspaces

$GroupsURLActiveOnly = '/admin/groups?$top=5000&' + '$filter=state eq' + " 'Active'"  + '&$expand=dashboards,reports,datasets,users'

Invoke-PowerBIRestMethod -Url $GroupsURLActiveOnly -Method Get | Out-File $PBIGroupsFile
#>