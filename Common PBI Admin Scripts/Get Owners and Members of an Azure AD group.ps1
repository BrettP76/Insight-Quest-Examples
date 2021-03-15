#1. Import Azure AD module (if running PowerShell 7+)
Import-Module AzureAD -UseWindowsPowerShell

#2. Authenticate interactively to Azure AD
Connect-AzureAD

#3. Define the group owner and group member files
$GroupOwnersFile = "C:\Users\Brett Powell\Desktop\GroupOwners.csv"
$GroupMembersFile = "C:\Users\Brett Powell\Desktop\GroupMembers.csv"

#4. Provide the name of the group
$GroupName = "TheGroupName"

#5. Retrieve the object ID of the group
$GroupID = (Get-AzureADGroup -SearchString $GroupName).ObjectId

#6. Retrieve group owners
$GroupOwners = Get-AzureADGroupOwner -ObjectId $GroupID | Select-Object ObjectId,DisplayName,UserPrincipalName,UserType,JobTitle,Department,Mail, `
    @{Name="DateRetrieved";Expression={Get-Date}} 

#7. Export group owners to CSV file
$GroupOwners | Export-Csv $GroupOwnersFile

#8. Retrieve group members
$GroupMembers = Get-AzureADGroupMember -ObjectId $GroupID | Select-Object ObjectId,DisplayName,UserPrincipalName,UserType,JobTitle,Department,Mail, `
    @{Name="DateRetrieved";Expression={Get-Date}} 
    
#9. Export group members to CSV file
$GroupMembers | Export-Csv $GroupMembersFile

