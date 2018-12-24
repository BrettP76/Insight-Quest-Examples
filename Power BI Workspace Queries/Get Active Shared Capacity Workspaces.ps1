Connect-PowerBIServiceAccount

#1. Active shared capacity workspaces excluding personal workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.Type -ne "PersonalGroup") -and ($_.State -eq "Active")}

#2. Count of active shared capacity workspaces excluding personal workspaces

$ActiveSharedCapacityWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.Type -ne "PersonalGroup") -and ($_.State -eq "Active")}

$ActiveSharedCapacityWorkspaces.Count

#3. Export of shared capacity workspaces (excluding personal workspaces) to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\ActiveSharedCapacityWorkspaces.csv"

$ActiveSharedCapacityWorkspaces | Export-Csv $ExportFile

