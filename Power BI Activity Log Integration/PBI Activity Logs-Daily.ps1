<#
	This script produces a CSV file containing Power BI activity log events for one day
#>

#1. Retrieve credentials from Admin File

. C:\BIAdminScripts\AdminCreds.ps1

#2. Authenticate to Power BI

$SecPasswd = ConvertTo-SecureString $PBIAdminPW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($PBIAdminUPN,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#3. Define export path and current date to retrieve

$ActivityLogsPath = "C:\Users\Brett Powell\Desktop\ActivityLogs.csv"

$RetrieveDate = Get-Date 

$RetrieveYearStr = $RetrieveDate.ToString('yyyy')
$RetrieveMonthStr = $RetrieveDate.ToString('MM')
$RetrieveDayStr = $RetrieveDate.ToString('dd')

$StartDT = $RetrieveYearStr + '-' + $RetrieveMonthStr + '-' + $RetrieveDayStr + 'T00:00:00.000'
$EndDT = $RetrieveYearStr + '-' + $RetrieveMonthStr + '-' + $RetrieveDayStr + 'T23:59:59.999'

#4. Export out current date activity log events to CSV file

$ActivityLogs = Get-PowerBIActivityEvent -StartDateTime $StartDt -EndDateTime $EndDT | ConvertFrom-Json

$ActivityLogSchema = $ActivityLogs | `
    Select-Object Id,RecordType,CreationTime,Operation,OrganizationId,UserType,UserKey,Workload, `
        UserId,ClientIP,UserAgent,Activity,ItemName,WorkspaceName,DatasetName,ReportName, `
        WorkspaceId,CapacityId,CapacityName,AppName,ObjectId,DatasetId,ReportId,IsSuccess, `
        ReportType,RequestId,ActivityId,AppReportId,DistributionMethod,ConsumptionMethod, `
        @{Name="RetrieveDate";Expression={$RetrieveDate}}

$ActivityLogSchema | Export-Csv $ActivityLogsPath 


