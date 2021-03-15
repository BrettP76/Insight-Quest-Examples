<#
Refresh dataset in group API
https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/refreshdatasetingroup
#>

#1. Authenticate to Power BI as an admin interactively
Connect-PowerBIServiceAccount

#2. Identify the workspace and dataset to be refreshed
$WSName = "EDW BI Workspace Name"
$DSDame = "PBI Admin Dataset"

#3. Retreive the workspace and dataset IDs
$WSID = (Get-PowerBIWorkspace -Scope Organization -Name $WSName).Id
$DSID = (Get-PowerBIDataset -Scope Organization -Name $DSDame -WorkspaceId $WSID).Id

#4. Build refresh API url and request body
$RefreshURL = '/groups/' + $WSID + '/datasets/' + $DSID + '/refreshes'
$ReqBody = @{
    "notifyOption" = "MailOnFailure"
}

#5. Invoke dataset refresh
Invoke-PowerBIRestMethod -Url $RefreshURL -Body $ReqBody -Method Post