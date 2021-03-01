<#
Retrieve the users and their access rights for a given workspace.
The workspace must be a modern (v2) workspace, not an O365 or classic (v1) workspace
#>

#1. Authenticate to the Power Service interactively
Connect-PowerBIServiceAccount

#2. Define the workspace name and export path file
$WSName = "EDW BI Datasets"
$CSVFile = "C:\Users\Brett Powell\Desktop\WorkspaceUsers.csv"

#3. Retrieve the workspace, expand the users property and export to a CSV file
$WS = Get-PowerBIWorkspace -Scope Organization -Name $WSName

#4. Export the users property to a CSV file (AccessRight,UserPrincipalName,Identifier,PrincipalType)
$WS | Select-Object Users -ExpandProperty Users | Export-Csv $CSVFile

