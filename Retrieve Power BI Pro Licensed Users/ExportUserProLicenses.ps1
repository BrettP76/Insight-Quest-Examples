#1. Retrieve authentication credentials from admin script
. C:\BIAdminScripts\AdminCreds.ps1

#2. Authenticate to Azure AD with user account and tenant ID
$SecPasswd = ConvertTo-SecureString $PBIAdminPW -AsPlainText -Force

$myCred = New-Object System.Management.Automation.PSCredential($PBIAdminUPN,$SecPasswd)

Connect-AzureAD -TenantId $TenantID -Credential $myCred

<#
    Alternative authentication to Azure AD via service principal application: 

Connect-AzureAD -TenantId $MyOrgTenantID -ApplicationId $MyOrgBIAppID -CertificateThumbprint $MyOrgBIThumbPrint

https://docs.microsoft.com/en-us/powershell/azure/active-directory/signing-in-service-principal?view=azureadps-2.0
#>

#3. Declare variables for export file paths, Power BI Pro service plan GUID, and current date

$RetrieveDate = Get-Date 
$BasePath = "C:\BIAdminArtifacts\"
$AzureADUsersCSV = $BasePath + "Users.csv"
$OrgO365LicensesCSV = $BasePath + "OrgO365Licenses.csv"
$UserPBIProLicensesCSV = $BasePath + "UserPBIProLicenses.csv"

<#
See MS Licensing Service Plan reference: 
https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference
#>
$PBIProServicePlanID = "70d33638-9c74-4d01-bfd3-562de28bd4ba"

#4. Retrieve and export users

$ADUsers = Get-AzureADUser -All $true | Select-Object ObjectId, ObjectType, CompanyName, Department, DisplayName, JobTitle, Mail, Mobile, `
            SipProxyAddress, TelephoneNumber, UserPrincipalName, UserType, @{Name="Date Retrieved";Expression={$RetrieveDate}}

$ADUsers | Export-Csv $AzureADUsersCSV

#5. Retrieve and export organizational licenses 

#https://docs.microsoft.com/en-us/office365/enterprise/powershell/view-licenses-and-services-with-office-365-powershell
$OrgO365Licenses = Get-AzureADSubscribedSku | Select-Object SkuID, SkuPartNumber,CapabilityStatus, ConsumedUnits -ExpandProperty PrepaidUnits | `
    Select-Object SkuID,SkuPartNumber,CapabilityStatus,ConsumedUnits,Enabled,Suspended,Warning, @{Name="Retrieve Date";Expression={$RetrieveDate}} 
     
$OrgO365Licenses | Export-Csv $OrgO365LicensesCSV

#6. Retrieve and export users with pro licenses based on Power BI Pro service plan ID ($PBIProServicePlanID)
#Each row represents a service plan for a particular user. This license detail is filtered to only the Power BI Pro service plan ID.

$UserLicenseDetail = ForEach ($ADUser in $ADUsers)
    {
        $UserObjectID = $ADUser.ObjectId
        $UPN = $ADUser.UserPrincipalName
        $UserName = $ADUser.DisplayName
        $UserDept = $ADUser.Department
        Get-AzureADUserLicenseDetail -ObjectId $UserObjectID -ErrorAction SilentlyContinue | `
        Select-Object ObjectID, @{Name="User Name";Expression={$UserName}},@{Name="UserPrincipalName";Expression={$UPN}}, `
        @{Name="Department";Expression={$UserDept}},@{Name="Retrieve Date";Expression={$RetrieveDate}} -ExpandProperty ServicePlans
    }

$ProUsers = $UserLicenseDetail | Where-Object {$_.ServicePlanId -eq $PBIProServicePlanID}

$ProUsers | Export-Csv $UserPBIProLicensesCSV