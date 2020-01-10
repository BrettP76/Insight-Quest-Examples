
#1. Export the active V1 (Office 365) Power BI workspaces via the Power BI Management module

#Login as a Power BI admin
Connect-PowerBIServiceAccount

$V1File = "C:\Users\Brett Powell\Desktop\Find V1 Workspace Owners\V1Workspaces.csv"

#Retrieve active V1 workspaces into a variable
$V1ActiveWS = Get-PowerBIWorkspace -Scope Organization -All | Where-Object {$_.Type -eq "Group" -and $_.State -eq "Active"} | Select-Object Name, Id, Type, IsOnDedicatedCapacity

#Export V1 workspaces
$V1ActiveWS | Export-Csv $V1File

#2. Export the group owners of each Azure Active Directory Group (excluding security groups)

#Authenticate to Azure Active Directory (AAD)
Connect-AzureAD

$AADGroupOwnersFile = "C:\Users\Brett Powell\Desktop\Find V1 Workspace Owners\AADGroupOwners.csv"

#Retrieve AAD groups into a variable
$AADGroups = Get-AzureADGroup -All $true | Where-Object {$_.ObjectType -eq "Group"} | Select ObjectId, DisplayName

#Loop over AAD groups to get group owners
$AADGroupOwners = ForEach($Group in $AADGroups)
       {
       $GroupID = $Group.ObjectId
       $GroupName = $Group.DisplayName
       Get-AzureADGroupOwner -ObjectId $GroupId | `
        Select DisplayName, UserPrincipalName, @{Name="GroupObjectId";Expression={$GroupID}},@{Name="Group Name";Expression={$GroupName}}
       } 

#Export AAD Group Owners file
$AADGroupOwners | Export-Csv $AADGroupOwnersFile