Connect-PowerBIServiceAccount

#1. Active Office 365 (legacy) read only workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -eq "Group") -and ($_.State -eq "Active") -and ($_.IsReadOnly -eq $true)}

#2. Count of active Office 365 (legacy) read only workspaces

$ActiveReadOnlyOffice365Workspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -eq "Group") -and ($_.State -eq "Active") -and ($_.IsReadOnly -eq $true)}

$ActiveReadOnlyOffice365Workspaces.Count

#3. Export of active Office 365 (legacy) read only workspaces

$ExportFile = "C:\Users\Brett Powell\Desktop\ActiveOffice365ReadOnlyWorkspaces.csv"

$ActiveReadOnlyOffice365Workspaces | Export-Csv $ExportFile