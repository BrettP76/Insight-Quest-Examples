Connect-PowerBIServiceAccount

#1. Active Premium modern workspaces

Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -eq "Workspace")}

#2. Count of active premium modern workspaces

$ActivePremiumModernWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -eq "Workspace")}

$ActivePremiumModernWorkspaces.Count

#3. Export of active premium modern workspaces to CSV file

$ExportFile = "C:\Users\Brett Powell\Desktop\ActivePremiumModernWorkspaces.csv"

$ActivePremiumModernWorkspaces | Export-Csv $ExportFile