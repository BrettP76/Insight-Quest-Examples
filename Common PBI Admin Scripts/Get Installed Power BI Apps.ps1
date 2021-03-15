#1. Authenticate to Power BI as an admin interactively
Connect-PowerBIServiceAccount

#2. Define CSV file to store output of apps
$OrgAppsFile = "C:\Users\Brett Powell\Desktop\OrgPBIApps.csv"

#2. Retrieve installed apps in the organization
$OrgApps = Invoke-PowerBIRestMethod -Url 'apps' -Method Get

#3. Convert JSON to PowerShell object and retrieve value
$OrgAppsObject = $OrgApps | ConvertFrom-Json | Select-Object -ExpandProperty value | Select-Object *,@{Name="DateRetrieved";Expression={Get-Date}}

#4. Export object to CSV file
$OrgAppsObject | Export-Csv $OrgAppsFile