Connect-PowerBIServiceAccount

#1. Premium workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.Type -ne "PersonalGroup")}

#2. Count of premium workspaces

$PremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.Type -ne "PersonalGroup")}

$PremiumWorkspaces.Count

#3. Export of premium workspaces to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\PremiumWorkspaces.csv"

$PremiumWorkspaces | Export-Csv $ExportFile