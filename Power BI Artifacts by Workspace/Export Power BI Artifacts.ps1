<#
	This script exports CSV files of Power BI artifacts created in a Power BI tenant for use in reporting and analysis. 
#>

#1. Authenticate to Power BI

$User = "123456@bigcompany.com"
$PW = "yourpassword"

$SecPasswd = ConvertTo-SecureString $PW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($User,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

$RetrieveDate = Get-Date 

#2. Define output file paths

$BasePath = "C:\Users\Brett Powell\Desktop\PBI Artifacts to Workspaces\"

#Export Paths: Power BI Artifacts

$DatasetsPath = $BasePath + "Datasets.csv"
$WorkspacesPath = $BasePath + "Workspaces.csv"
$ReportsPath = $BasePath + "Reports.csv"
$DashboardsPath = $BasePath + "Dashboards.csv"
$DatasourcesPath = $BasePath + "DataSources.csv"

#3. Get active workspaces excluding personal workspaces ('My Workspace')
$ActiveWorkspaces = Get-PowerBIWorkspace -Scope Organization -All | Where-Object {$_.Type -ne "PersonalGroup" -and $_.State -eq "Active"} |`
    Select-Object *, @{Name="DateRetrieved";Expression={$RetrieveDate}}

#4. Get datasets in active workspaces including the workspace ID of the dataset
$Datasets = ForEach ($WS in $ActiveWorkspaces)
    {
        $WSID = $WS.Id
        Get-PowerBIDataset -Scope Organization -WorkspaceId $WSID | Where-Object {$_.Name -ne "Report Usage Metrics Model" -and $_.Name -ne "Dashboard Usage Metrics Model"} |`
        Select-Object *,@{Name="WorkspaceID";Expression={$WSID}},@{Name="DateRetrieved";Expression={$RetrieveDate}}
    }

#5. Get reports in active workspaces but avoid duplicate reports (due to apps) and exclude usage metrics reports

$Reports = ForEach ($WS in $ActiveWorkspaces)
    {
        $WSID = $WS.Id
        Get-PowerBIReport -Scope Organization -WorkspaceId $WSID | Where-Object {$_.Name -ne "Dashboard Usage Metrics Report" -and $_.Name -ne "Report Usage Metrics Report"} | `
        Select-Object Name,DatasetId,@{Name="WorkspaceID";Expression={$WSID}},@{Name="DateRetrieved";Expression={$RetrieveDate}} | `
        Sort-Object -Property Name,WorkspaceID | Get-Unique -AsString
    }
 

#6. Get dashboards in active workspaces but avoid duplicate dashboards (due to apps)

$Dashboards = ForEach ($WS in $ActiveWorkspaces)
    {
        $WSID = $WS.Id
        Get-PowerBIDashboard -Scope Organization -WorkspaceId $WSID | Select-Object Name,@{Name="WorkspaceID";Expression={$WSID}},@{Name="DateRetrieved";Expression={$RetrieveDate}} | `
        Sort-Object -Property Name,WorkspaceID | Get-Unique -AsString
    }


#7. Get data sources from datasets in active workspaces

$Datasources = ForEach ($DS in $Datasets)
    {
        $DSID = $DS.Id
        $WSID = $DS.WorkspaceID
        Get-PowerBIDatasource -Scope Organization -DatasetId $DSID -ErrorAction SilentlyContinue | ` 
        Select *,@{Name="WorkspaceID";Expression={$WSID}},@{Name="DatasetId";Expression={$DSID}},@{Name="DateRetrieved";Expression={$RetrieveDate}}
   }

#8. Export out artifact objects to CSV files for reporting

$ActiveWorkspaces | Export-Csv $WorkspacesPath
$Datasets | Export-Csv $DatasetsPath
$Reports | Export-Csv $ReportsPath
$Dashboards | Export-Csv $DashboardsPath
$Datasources | Export-Csv $DatasourcesPath