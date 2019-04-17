#1. Connect to Power BI with credential of Power BI Service Administrator

$User = "somebody@bigcompany.com"
$PW = "abcdef"

$SecPasswd = ConvertTo-SecureString $PW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($User,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#2. Declare variables for export paths and date data was retrieved

$RetrieveDate = Get-Date 
$BasePath = "C:\Users\Brett Powell\PowerShell Scripts\ArtifactExport\"

#ExportPaths
$DatasetsPath = $BasePath + "Datasets.csv"
$WorkspacesPath = $BasePath + "Workspaces.csv"
$ReportsPath = $BasePath + "Reports.csv"
$DashboardsPath = $BasePath + "Dashboards.csv"
$DatasourcesPath = $BasePath + "DataSources.csv"
$CapacitiesPath = $BasePath + "Capacities.json"
$CapacityAWorkloadPath = $BasePath + "CapacityAWorkloads.json"
$CapacityBWorkloadPath = $BasePath + "CapacityBWorkloads.json"
$CapacityCWorkloadPath = $BasePath + "CapacityCWorkloads.json"
$CapacityDWorkloadPath = $BasePath + "CapacityDWorkloads.json"
$CapacityEWorkloadPath = $BasePath + "CapacityEWorkloads.json"
$CapacityFWorkloadPath = $BasePath + "CapacityFWorkloads.json"

#3. Export Power BI Premium capacities and capacity workloads

#Premium Capacity ID variables
$CapacityA = "The Capacity ID for Premium Capacity A"
$CapacityB = "The Capacity ID for Premium Capacity B"
$CapacityC = "The Capacity ID for Premium Capacity C"
$CapacityD = "The Capacity ID for Premium Capacity D"
$CapacityE = "The Capacity ID for Premium Capacity E"
$CapacityF = "The Capacity ID for Premium Capacity F"

#Premium Capacity Workload URL variables
$CapacityAURL = 'capacities/' + $CapacityA + '/Workloads'
$CapacityBURL = 'capacities/' + $CapacityB + '/Workloads'
$CapacityCURL = 'capacities/' + $CapacityC + '/Workloads'
$CapacityDURL = 'capacities/' + $CapacityD + '/Workloads'
$CapacityEURL = 'capacities/' + $CapacityE + '/Workloads'
$CapacityFURL = 'capacities/' + $CapacityF + '/Workloads'

#Export Premium capacities
Invoke-PowerBIRestMethod -Url 'capacities' -Method Get | Out-File $CapacitiesPath

#Export EA Prod Capacity Workloads
Invoke-PowerBIRestMethod -Url $CapacityAURL -Method Get | Out-File $CapacityAWorkloadPath

Invoke-PowerBIRestMethod -Url $CapacityBURL -Method Get | Out-File $CapacityBWorkloadPath

Invoke-PowerBIRestMethod -Url $CapacityCURL  -Method Get | Out-File $CapacityCWorkloadPath

Invoke-PowerBIRestMethod -Url $CapacityDURL  -Method Get | Out-File $CapacityDWorkloadPath

Invoke-PowerBIRestMethod -Url $CapacityEURL   -Method Get | Out-File $CapacityEWorkloadPath

Invoke-PowerBIRestMethod -Url $CapacityFURL -Method Get | Out-File $CapacityFWorkloadPath

#4. Export Power BI Artifacts

Get-PowerBIDataset -Scope Organization | Select *, @{Name="Date Retrieved";Expression={$RetrieveDate}} | Export-Csv -Path $DatasetsPath

Get-PowerBIReport -Scope Organization |  Select *, @{Name="Date Retrieved";Expression={$RetrieveDate}} | Export-Csv -Path $ReportsPath

Get-PowerBIDashboard -Scope Organization |  Select *, @{Name="Date Retrieved";Expression={$RetrieveDate}} | Export-Csv -Path $DashboardsPath

Get-PowerBIWorkspace -Scope Organization -All |  Select *, @{Name="Date Retrieved";Expression={$RetrieveDate}} | Export-Csv -Path $WorkspacesPath

Get-PowerBIDataset -Scope Organization | Foreach {$dsID = $_.Id; Get-PowerBIDatasource -DatasetId $dsID -Scope Organization} | `
    Select *, @{Name = "DatasetID"; Expression={$dsID}}, @{Name = "Date Retrieved"; Expression={$RetrieveDate}} | `
    Export-Csv -Path $DatasourcesPath