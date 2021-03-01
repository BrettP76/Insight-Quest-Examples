<#
Retrieve the app workspaces assigned to a specific premium capacity
#>

#1. Authenticate to the Power Service interactively
Connect-PowerBIServiceAccount

#2. Define premium capacity name and export path
$CapacityName = "BigCompanyPremiumCapacity"
$PremiumWorkspacesCSV = "C:\Users\Brett Powell\Desktop\PremiumCapacityWorkspaces.csv"

#3. Get capacity ID of the given premium capacity
$CapID = (Get-PowerBICapacity -Scope Organization | Where-Object {$_.DisplayName -eq $CapacityName}).Id

#4. Retrieve the workspaces filtered by the Capacity ID
$PremiumCapWorkspaces = Get-PowerBIWorkspace -Scope Organization -All | Where-Object {$_.CapacityID -eq $CapID}

#5. Add the capacity name and date retrieved to the object and export to csv
$PremiumCapWorkspaces | Select-Object *,@{Name="CapacityName";Expression={$CapacityName}},@{Name="DateRetrieved";Expression={Get-Date}} | `
    Export-Csv $PremiumWorkspacesCSV