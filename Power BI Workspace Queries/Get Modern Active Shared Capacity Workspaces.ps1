Connect-PowerBIServiceAccount

#1. Active modern workspaces on shared capacity

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.State -eq "Active") -and ($_.Type -eq "Workspace")}

#2. Count of active modern workspaces on shared capacity

$ActiveSharedCapacityModernWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.State -eq "Active") -and ($_.Type -eq "Workspace")}

$ActiveSharedCapacityModernWorkspaces.Count

#3. Export of active premium modern workspaces to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\ActiveSharedCapacityModernWorkspaces.csv"

$ActiveSharedCapacityModernWorkspaces | Export-Csv $ExportFile