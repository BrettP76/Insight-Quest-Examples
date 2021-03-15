<#
Retrieve the refresh history and the refresh schedule for a given dataset and export to json files
Uses the Get Refresh History in Group and Get Refresh Schedule in Group APIs
#>

#1. Authenticate to the Power Service interactively
Connect-PowerBIServiceAccount

#2. Define the names of the workspace and datasets and the export file paths (json files)
$WSName = "EDW BI Datasets"
$DSName = "EDWBIDataset"
$RefreshScheduleFile = "C:\Users\Brett Powell\Desktop\RefreshSchedule.json"
$RefreshHistoryFile = "C:\Users\Brett Powell\Desktop\RefreshHistory.json"

#3. Retrieve the WorkspaceID and DatasetID
$WSID = (Get-PowerBIWorkspace -Scope Organization -Name $WSName).Id
$DSID = (Get-PowerBIDataset -Scope Organization -Name $DSName -WorkspaceId $WSID).Id

#4. Build refresh schedule API URL and refresh history API URL
$RefreshScheduleURL = '/groups/' + $WSID + '/datasets/' + $DSID + '/refreshSchedule'
$RefreshHistoryURL = '/groups/' + $WSID + '/datasets/' + $DSID + '/refreshes'

#5. Retrieve and export refresh schedule and refresh history for the dataset
Invoke-PowerBIRestMethod -Url $RefreshScheduleURL -Method Get -OutFile $RefreshScheduleFile
Invoke-PowerBIRestMethod -Url $RefreshHistoryURL -Method Get -OutFile $RefreshHistoryFile
