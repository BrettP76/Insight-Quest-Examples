#1. Authenticate to Power BI as an admin interactively
Connect-PowerBIServiceAccount

#2. Identify the workspace containing the datasets and the export file
$WSName = "EDW BI Datasets"
$DataSourceFile = "C:\Users\Brett Powell\Desktop\WSDataSources.csv"

#3. Retrieve the workspace ID
$WSID = (Get-PowerBIWorkspace -Scope Organization -Name $WSName).Id

#4. Retrieve datasets within workspaces
$WSDatasets = Get-PowerBIDataset -Scope Organization -WorkspaceId $WSID | Select-Object *, @{Name="Workspace";Expression={$WSName}}

#5. Loop over datasets within the workspace to retrieve data sources
$WSDataSources = ForEach($DS in $WSDatasets)
    {
        $DSID = $DS.Id
        $DSName = $DS.Name
        $WSName = $DS.Workspace
        Get-PowerBIDatasource -Scope Organization -DatasetId $DSID | `
        Select-Object *,@{Name="Dataset";Expression={$DSName}},@{Name="Workspace";Expression={$WSName}},@{Name="DateRetrieved";Expression={Get-Date}}
    }

#6. Export data sources of workspace datasets to CSV
$WSDataSources | Export-Csv $DataSourceFile