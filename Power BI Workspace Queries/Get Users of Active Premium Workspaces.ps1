Connect-PowerBIServiceAccount

#1. List of unique active Premium workspace users

$ActivePremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")}

$ActivePremiumWorkspaces | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

#2. Count of unique active Premium workspace users

$ActivePremiumWorkspaceUsers = $ActivePremiumWorkspaces | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

$ActivePremiumWorkspaceUsers.Count

#3. Export of unique active premium workspace users

$ExportFile = "C:\Users\Brett Powell\Desktop\ActivePremiumWorkspaceUsers.csv"

$ActivePremiumWorkspaceUsers | Export-Csv $ExportFile