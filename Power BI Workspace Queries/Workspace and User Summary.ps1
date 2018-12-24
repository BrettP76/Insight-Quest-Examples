Connect-PowerBIServiceAccount

#1. App workspace segments

$TotalWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -ne "PersonalGroup")}

$PremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.Type -ne "PersonalGroup")}

$ActivePremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")}

$SharedCapacityWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.Type -ne "PersonalGroup")}

$ActiveSharedCapacityWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.Type -ne "PersonalGroup") -and ($_.State -eq "Active")}

$ActivePremiumModernWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -eq "Workspace")}

$ActiveOffice365PremiumWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -eq "Group")}

$ActiveReadOnlyOffice365Workspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -eq "Group") -and ($_.State -eq "Active") -and ($_.IsReadOnly -eq $true)}

$ActiveSharedCapacityModernWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.State -eq "Active") -and ($_.Type -eq "Workspace")}

$DeletedAndRemovingWorkspaces = Get-PowerBIWorkspace -Scope Organization | Where {($_.State -eq "Deleted") -or ($_.State -eq "Removing")}

Write-Host "Total Workspaces:" $TotalWorkspaces.Count `n"Premium Workspaces:" `
$PremiumWorkspaces.Count `n"Active Premium Workspaces:" $ActivePremiumWorkspaces.Count `
`n"Shared Capacity Workspaces:" $SharedCapacityWorkspaces.Count `n"Active Shared Capacity Workspaces:" `
$ActiveSharedCapacityWorkspaces.Count `n"Active Premium Modern Workspaces:" $ActivePremiumModernWorkspaces.Count `n"Active Office 365 Premium Workspaces:" `
$ActiveOffice365PremiumWorkspaces.Count `n"Active Read Only Office 365 Workspaces:" $ActiveReadOnlyOffice365Workspaces.Count `n"Active Shared Capacity Modern Workspaces:" `
$ActiveSharedCapacityModernWorkspaces.Count `n"Deleted Workspaces:" $DeletedAndRemovingWorkspaces.Count -ForegroundColor White -BackgroundColor Red
 
#2. Workspace user segments

$ActivePremiumWorkspaceUsers = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $true) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")} `
| Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString


$ActiveSharedCapacityWorkspaceUsers = Get-PowerBIWorkspace -Scope Organization | Where {($_.IsOnDedicatedCapacity -eq $false) -and ($_.State -eq "Active") -and ($_.Type -ne "PersonalGroup")} `
| Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

$ActiveModernWorkspaceUsers = Get-PowerBIWorkspace -Scope Organization | Where {($_.Type -eq "Workspace") -and ($_.State -eq "Active")} | Foreach {$_.Users} | Select UserPrincipalName | Get-Unique -AsString

Write-Host "Active Premium Workspace Users:" $ActivePremiumWorkspaceUsers.Count `n"Active Shared Capacity Workspace Users:" `
$ActiveSharedCapacityWorkspaceUsers.Count `n"Active Modern Workspace Users:" $ActiveModernWorkspaceUsers.Count `
-ForegroundColor White -BackgroundColor Red