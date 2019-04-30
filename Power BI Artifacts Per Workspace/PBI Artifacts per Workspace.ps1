#1. Authenticate to Power BI Service with credential of Power BI Service Admin

$User = "abcdefg@bigcompany.com"
$PW = "yourpassword"

$SecPasswd = ConvertTo-SecureString $PW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($User,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#2. Required Variables
$CapacityWorkspace = "Name of Workspace"
$CapacityName = "My Capacity"
$ExportPath = "C:\Users\Brett Powell\Desktop\Power BI Artifacts per Workspace\"
$DateRetrieved = Get-Date

#3. Retrieve Capacity ID and workspaces in the premium capacity for the given workspace
$CapacityID = Get-PowerBIWorkspace -Scope Organization -Name $CapacityWorkspace | ForEach {$_.CapacityId}

$CapWorkspaces = Get-PowerBIWorkspace -Scope Organization -All | Where {$_.CapacityId -eq $CapacityID -and $_.State -eq "Active"}

#4. Get distinct list of datasets, reports, and dashboard objects per workspace of capacity workspaces from Step #3 
$CapacityDatasets = ForEach ($Workspace in $CapWorkspaces) 
    {
       $WSID = $Workspace.Id
       $WSName = $Workspace.Name
        Get-PowerBIDataset -Scope Organization -WorkspaceId $WSID | `
        Select *,@{Name="Workspace";Expression={$WSName}}, @{Name="Date"; Expression={$DateRetrieved}}, `
        @{Name="Capacity";Expression={$CapacityName}} | `
        Select Name,Workspace,Capacity,Date | Sort-Object -Property Name | Get-Unique -AsString
    }
   
$CapacityReports = ForEach ($Workspace in $CapWorkspaces)
   {
       $WSID = $Workspace.Id
       $WSName = $Workspace.Name
        Get-PowerBIReport -Scope Organization -WorkspaceId $WSID | `
        Select *,@{Name="Workspace";Expression={$WSName}}, @{Name="Date"; Expression={$DateRetrieved}}, `
        @{Name="Capacity";Expression={$CapacityName}} | `
        Select Name,Workspace,Capacity,Date | Sort-Object -Property Name | Get-Unique -AsString
    }

$CapacityDashboards = ForEach ($Workspace in $CapWorkspaces)
   {
       $WSID = $Workspace.Id
       $WSName = $Workspace.Name
        Get-PowerBIDashboard -Scope Organization -WorkspaceId $WSID | `
        Select *,@{Name="Workspace";Expression={$WSName}}, @{Name="Date"; Expression={$DateRetrieved}}, `
        @{Name="Capacity";Expression={$CapacityName}} | `
        Select Name,Workspace,Capacity,Date | Sort-Object -Property Name | Get-Unique -AsString
    }

#5. Export custom objects from Step #4 to CSV files

$DashboardPath = $ExportPath + "Dashboards.csv"
$ReportPath = $ExportPath + "Reports.csv"
$DatasetsPath = $ExportPath + "Datasets.csv"

$CapacityDashboards | Export-Csv -Path $DashboardPath
$CapacityReports | Export-Csv -Path $ReportPath
$CapacityDatasets | Export-Csv -Path $DatasetsPath
