Connect-PowerBIServiceAccount

#1. Shared capacity workspaces excluding personal workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.Type -ne "PersonalGroup")}

#2. Count of shared capacity workspaces excluding personal workspaces

$SharedCapacityWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.Type -ne "PersonalGroup")}

$SharedCapacityWorkspaces.Count

#3. Export of shared capacity workspaces (excluding personal workspaces) to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\SharedCapacityWorkspaces.csv"

$SharedCapacityWorkspaces | Export-Csv $ExportFile