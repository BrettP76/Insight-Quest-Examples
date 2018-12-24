Connect-PowerBIServiceAccount

#1. Active Premium workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")}

#2. Count of active premium workspaces

$ActivePremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")}
$ActivePremiumWorkspaces.Count

#3. Export of active premium workspaces to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\ActivePremiumWorkspaces.csv"

$ActivePremiumWorkspaces | Export-Csv $ExportFile