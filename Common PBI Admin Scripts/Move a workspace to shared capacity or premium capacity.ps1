#1. Authenticate to Power BI as an admin interactively
Connect-PowerBIServiceAccount

#2. Identify the workspace to be moved to shared capacity and shared capacity ID
$WSNameA = "WorkspaceNameA"
$WSIDA = (Get-PowerBIWorkspace -Scope Organization -Name $WSNameA).Id
$SharedCapacityID = "00000000-0000-0000-0000-000000000000"

#3. Move the workspace to shared capacity
Set-PowerBIWorkspace -Scope Organization -Id $WSIDA -CapacityId $SharedCapacityID

#4. Identify the workspace to be moved to premium capacity and the premium capacity
$WSNameB = "WorkspaceNameB"
$PremiumCapacityName = "PremiumCapacityA"
$WSIDB = (Get-PowerBIWorkspace -Scope Organization -Name $WSNameB).Id
$PremiumCapacityID = (Get-PowerBICapacity -Scope Organization | Where-Object {$_.DisplayName -eq $PremiumCapacityName}).Id

#5. Move the workspace to shared capacity 
Set-PowerBIWorkspace -Scope Organization -Id $WSIDB -CapacityId $PremiumCapacityID
