Connect-PowerBIServiceAccount

#1. Get deleted and removing workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.State -eq "Deleted") -or ($_.State -eq "Removing")}

#2. Count of deleted and removing workspaces

$DeletedAndRemovingWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.State -eq "Deleted") -or ($_.State -eq "Removing")}

$DeletedAndRemovingWorkspaces.Count

#3. Export of deleted and removing workspaces to a CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\DeletedWorkspaces.csv"

$DeletedAndRemovingWorkspaces | Export-Csv $ExportFile