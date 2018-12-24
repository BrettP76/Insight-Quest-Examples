Connect-PowerBIServiceAccount

#1. List of unique active shared capacity workspace users

$ActiveSharedCapacityWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")}

$ActiveSharedCapacityWorkspaces | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

#2. Count of unique active shared capacity workspace users

$ActiveSharedCapacityWorkspaceUsers = $ActiveSharedCapacityWorkspaces | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

$ActiveSharedCapacityWorkspaceUsers.Count

#3. Export of unique active shared capacity workspace users

$ExportFile = "C:\Users\Brett Powell\Desktop\ActiveSharedCapacityWorkspaceUsers.csv"

$ActiveSharedCapacityWorkspaceUsers | Export-Csv $ExportFile