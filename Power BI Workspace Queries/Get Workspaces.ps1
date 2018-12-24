Connect-PowerBIServiceAccount

#1. All tenant workspaces excluding personal workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -ne "PersonalGroup")}

#2. Count of tenant workspaces (excluding personal workspaces)

$OrgWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -ne "PersonalGroup")}

$OrgWorkspaces.Count

#3. Export of tenant workspaces (excluding personal workspaces) to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\OrgWorkspaces.csv"

$OrgWorkspaces | Export-Csv $ExportFile

