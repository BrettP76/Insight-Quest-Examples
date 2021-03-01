#1. Authenticate to the Power Service interactively
Connect-PowerBIServiceAccount

#2. Define the workspace name and the export path
$WSName = "EDW BI Datasets"
$WSDatasetsCSV = "C:\Users\Brett Powell\Desktop\WorkspaceDatasets.csv"

#3. Retrieve the datasets for the given workspace
$WorkspaceDatasets = Get-PowerBIWorkspace -Scope Organization -Name $WSName -Include Datasets | Select-Object Datasets -ExpandProperty Datasets

#4. Add the worskspace name and date retrieved to the object and export to a csv
$WorkspaceDatasets | Select-Object *, @{Name="Workspace";Expression={$WSName}},@{Name="DateRetrieved";Expression={Get-Date}} | Export-Csv $WSDatasetsCSV