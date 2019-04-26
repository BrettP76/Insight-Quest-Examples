<#
This script retrieves the datasets, reports, and dashboards for a Power BI Premium capacity. 
The aggregate counts of these artifacts and the individual details of each artifact can be viewed within the PowerShell terminal
or optionally exported to CSV files. 
#>

#1. Authenticate to Power BI Service with Power BI Service Administrator credential

$User = "powerbiadmin@bigcompany.com"
$PW = "pbiadminpassword"

$SecPasswd = ConvertTo-SecureString $PW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($User,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#2. Provide the name of the premium capacity and capture the current date

$CapacityName = "Finance P1"

$RetrieveDate = Get-Date

#3. Retrieve the ID of a premium capacity into a variable based on the name of a workspace which is hosted on the premium capacity

$WorkspaceName = "Finance Quarterly Review"

$CapacityId = Get-PowerBIWorkspace -Scope Organization -Name $WorkspaceName | ForEach {$_.CapacityId}

#4. Retrieve the active app workspaces for the premium capacity identified in step #3.

$CapacityWorkspaces = Get-PowerBIWorkspace -Scope Organization -All | Where {$_.CapacityId -eq $CapacityId -and $_.State -eq "Active"}

#5. Retrieve the dashboards, reports, and datasets contained within the app workspaces of the premium capacity identified in step #4. 

$CapacityDashboards = $CapacityWorkspaces | ForEach {$WSID = $_.Id; Get-PowerBIDashboard -Scope Organization -WorkspaceId $WSID}

$CapacityReports = $CapacityWorkspaces | ForEach {$WSID = $_.Id; Get-PowerBIReport -Scope Organization -WorkspaceId $WSID}

$CapacityDatasets = $CapacityWorkspaces | ForEach {$WSID = $_.Id; Get-PowerBIDataset -Scope Organization -WorkspaceId $WSID}

#6. Create an object for capacity artifact count values

$CapacityCountObject = New-Object -TypeName psobject

$CapacityCountObject | Add-Member -MemberType NoteProperty -Name Capacity -Value $CapacityName
$CapacityCountObject | Add-Member -MemberType NoteProperty -Name Workspaces -Value $CapacityWorkspaces.Count
$CapacityCountObject | Add-Member -MemberType NoteProperty -Name Dashboards -Value $CapacityDashboards.Count
$CapacityCountObject | Add-Member -MemberType NoteProperty -Name Reports -Value $CapacityReports.Count
$CapacityCountObject | Add-Member -MemberType NoteProperty -Name Datasets -Value $CapacityDatasets.Count
$CapacityCountObject | Add-Member -MemberType NoteProperty -Name Date -Value $RetrieveDate

#View the object created in this step as a table within the PowerShell terminal window
$CapacityCountObject | Format-Table -AutoSize

#7. Optionally export the capacity content details as CSV files

#Define directory paths for export files
$BasePath = "C:\Users\Brett Powell\Desktop\CapacityContent"

$SummaryObjectPath = $BasePath + "\Capacity Summary.csv"
$CapWorkspacesPath = $BasePath + "\Capacity Workspaces.csv"
$CapDatasetsPath = $BasePath + "\Capacity Datasets.csv"
$CapDashboardsPath = $BasePath + "\Capacity Dashboards.csv"
$CapReportsPath =  $BasePath + "\Capacity Reports.csv"

#Export premium capacity artifact details to files

$CapacityCountObject |  Export-Csv $SummaryObjectPath
$CapacityWorkspaces | Select *, @{Name="Date Retrieved"; Expression={$RetrieveDate}} | Export-Csv $CapWorkspacesPath
$CapacityDatasets | Select *, @{Name="Date Retrieved"; Expression={$RetrieveDate}} | Export-Csv $CapDatasetsPath
$CapacityDashboards | Select *, @{Name="Date Retrieved"; Expression={$RetrieveDate}} | Export-Csv $CapDashboardsPath
$CapacityReports | Select *, @{Name="Date Retrieved"; Expression={$RetrieveDate}} | Export-Csv $CapReportsPath
