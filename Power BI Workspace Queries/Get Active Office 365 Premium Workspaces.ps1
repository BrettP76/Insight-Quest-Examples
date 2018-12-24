Connect-PowerBIServiceAccount

#1. Active Office 365 (legacy) premium workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -eq "Group")}

#2. Count of active Office 365 (legacy) premium workspaces

$ActiveOffice365PremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -eq "Group")}

$ActiveOffice365PremiumWorkspaces.Count

#3. Export of active Office 365 (legacy) premium workspaces to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\ActiveOffice365PremiumWorkspaces.csv"

$ActiveOffice365PremiumWorkspaces | Export-Csv $ExportFile