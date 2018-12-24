Connect-PowerBIServiceAccount

#1. List of unique active modern workspace users

$ActiveModernWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -eq "Workspace") -and ($_.State -eq "Active")}

$ActiveModernWorkspaces | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

#2. Count of unique active modern workspace users

$ActiveModernWorkspaceUsers = $ActiveModernWorkspaces | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

$ActiveModernWorkspaceUsers.Count

#3. Export of unique active modern workspace users

$ExportFile = "C:\Users\Brett Powell\Desktop\ActiveModernWorkspaceUsers.csv"

$ActiveModernWorkspaceUsers | Export-Csv $ExportFile