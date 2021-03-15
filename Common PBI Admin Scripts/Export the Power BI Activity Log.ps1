<#
Retrieve the Power BI Activity log for a particular day (timespace is limited to one day)
User must be assigned the Power BI service admin role
#>

#1. Interactively login with a Power BI service admin account
Connect-PowerBIServiceAccount

#2. Define the date to retrieve (YYYY-MM-DD) and the file path for the exported data
$LogDate = "2021-02-24"
$ActivityLogsPath = "C:\Users\Brett Powell\Desktop\PBIActivityLog.csv"

#3. Produce starting and ending date parameter values
$StartDT = $LogDate + 'T00:00:00.000'
$EndDT = $LogDate + 'T23:59:59.999'

#4. Retrieve Power BI Activity log, convert from JSON and export to CSV
Get-PowerBIActivityEvent -StartDateTime $StartDt -EndDateTime $EndDT | ConvertFrom-Json | Export-Csv $ActivityLogsPath