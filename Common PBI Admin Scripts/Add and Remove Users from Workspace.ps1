<#
Add a user and remove a user from a workspace
Identifier parameter of Add-PowerBIWorskspaceUser cmdlet can be used for security groups and apps (service principals)
#>
#1. Authenticate to the Power Service interactively
Connect-PowerBIServiceAccount

#2. Define the workspace name, user principal names (UPNs) to be added and removed, and the object ID of a security group to be added
$WSName = "EDW BI Datasets"
$UPNRemove = "JohnDoe@thebigcompany.com"
$UPNAdd = "JackDoe@thebigcompany.com"

#3. Retrieve the workspace ID
$WSID = (Get-PowerBIWorkspace -Scope Organization -Name $WSName).Id

#4. Remove a user from the given workspace
Remove-PowerBIWorkspaceUser -Scope Organization -Id $WSID -UserPrincipalName $UPNRemove

#Optionally view the updated worksapce users (with the user removed from the workspace)
Get-PowerBIWorkspace -Scope Organization -Id $WSID | Select-Object Users -ExpandProperty Users

#5. Add a user to the given workspace (Member role)
Add-PowerBIWorkspaceUser -Scope Organization -Id $WSID -UserPrincipalName $UPNAdd -AccessRight Member

#Optionally view the updated workspace users (with the user added)
Get-PowerBIWorkspace -Scope Organization -Id $WSID | Select-Object Users -ExpandProperty Users

