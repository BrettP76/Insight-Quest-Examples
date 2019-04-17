#1. Authenticate to Azure AD with service principal and certificate thumbprint

$tenant = "abcdef"
$application = "ghijkl"
$thumb = "mnopqrs"

Connect-AzureAD -TenantId $tenant -ApplicationId $application -CertificateThumbprint $thumb

#2. Define variables for users, groups, export paths and date retrieved

$RetrieveDate = Get-Date 

$ADGroups = Get-AzureADGroup -All $true

$ADUsers = Get-AzureADUser -All $true 

$BasePath = "C:\Users\Brett Powell\PowerShell Scripts\ArtifactExport\"

$AzureADUserPath = $BasePath + "Users.csv"

$AzureADGroupPath = $BasePath + "Groups.csv"

$AzureADGroupOwners = $BasePath + "GroupOwners.csv" 

$AzureADGroupMembers = $BasePath + "GroupMembers.csv"

#3. Export Azure AD Users and Groups

$ADUsers |  Select *, @{Name="Date Retrieved";Expression={$RetrieveDate}} | Export-Csv -Path $AzureADUserPath

$ADGroups |  Select *, @{Name="Date Retrieved";Expression={$RetrieveDate}} | Export-Csv -Path $AzureADGroupPath

#4. Export Azure AD Group Owners and Group Members

#Group Owners
$ADGroups | ForEach {$GroupID = $_.ObjectId; Get-AzureADGroupOwner -ObjectId $GroupID} | ` 
    Select DisplayName, UserPrincipalName, @{Name="GroupMembershipType";Expression={"Owner"}}, `
    @{Name="GroupObjectID";Expression={$GroupID}}, @{Name="Date Retrieved";Expression={$RetrieveDate}} | `
    Export-Csv $AzureADGroupOwners

#Group Members
$ADGroups | ForEach {$GroupID = $_.ObjectId; Get-AzureADGroupMember -ObjectId $GroupID -All $true} | ` 
    Select DisplayName, UserPrincipalName, @{Name="GroupMembershipType";Expression={"Member"}}, `
    @{Name="GroupObjectID";Expression={$GroupID}}, @{Name="Date Retrieved";Expression={$RetrieveDate}} | `
    Export-Csv $AzureADGroupMembers