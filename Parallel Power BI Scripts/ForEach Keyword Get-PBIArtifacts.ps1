Connect-PowerBIServiceAccount

$RetrieveDate = Get-Date
$DatasetFile = "C:\Users\Brett Powell\Desktop\DatasetFile.csv"
$ReportFile = "C:\Users\Brett Powell\Desktop\ReportFile.csv"
$WorkspaceFile = "C:\Users\Brett Powell\Desktop\Workspaces.csv"


$ActiveWorkspaces = Get-PowerBIWorkspace -Scope Organization -All | Where-Object {$_.Type -ne "PersonalGroup" -and $_.State -eq "Active"} |`
    Select-Object Id,Name,IsReadOnly,IsOnDedicatedCapacity,CapacityId,Description,Type,State,IsOrphaned,Users, `
    @{Name="DateRetrieved";Expression={$RetrieveDate}}


$Datasets = ForEach ($WS in $ActiveWorkspaces)
    {
        $WSID = $WS.Id
        Get-PowerBIDataset -Scope Organization -WorkspaceId $WSID | Where-Object {$_.Name -ne "Report Usage Metrics Model" -and $_.Name -ne "Dashboard Usage Metrics Model"} |`
        Select-Object Id,Name,ConfiguredBy,DefaultRetentionPolicy,AddRowsApiEnabled,Tables,WebUrl,Relationships,Datasources,DefaultMode,IsRefreshable, `
        IsEffectiveIdentityRequired,IsEffectiveIdentityRolesRequired,IsOnPremGatewayRequired,TargetStorageMode,ActualStorage, `
        @{Name="WorkspaceID";Expression={$WSID}},@{Name="DateRetrieved";Expression={$RetrieveDate}}
    }

$Reports = ForEach ($WS in $ActiveWorkspaces)
    {
        $WSID = $WS.Id
        Get-PowerBIReport -Scope Organization -WorkspaceId $WSID | Where-Object {$_.Name -ne "Dashboard Usage Metrics Report" -and $_.Name -ne "Report Usage Metrics Report"} | `
        Select-Object Name,DatasetId,@{Name="WorkspaceID";Expression={$WSID}},@{Name="DateRetrieved";Expression={$RetrieveDate}} | `
        Sort-Object -Property Name,WorkspaceID | Get-Unique -AsString
    }

$Datasets | Export-Csv $DatasetFile
$Reports | Export-Csv $ReportFile
$ActiveWorkspaces | Export-Csv $WorkspaceFile