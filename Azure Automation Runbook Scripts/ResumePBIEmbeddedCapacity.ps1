#1. Define variables to retrieve parameter values stored as Azure Automation variables or credentials

$PBIEmbeddedResource = Get-AutomationVariable -Name 'PBIEmbeddedResource'
$Tenant = Get-AutomationVariable -Name 'FrontlineTenant'
$ResourceGroup = Get-AutomationVariable -Name 'BIResourceGroupName'

$AzureCred = Get-AutomationPSCredential -Name "AzureASRefreshCred"

#2. Authenticate with stored credential in Azure Automation

Connect-AzureRmAccount -Credential $AzureCred -Tenant $Tenant -ServicePrincipal  

#3. Capture Power BI Embedded state

$CapacityConfig = Get-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroup -Name $PBIEmbeddedResource

$CapacityState = $CapacityConfig.State

#4. Resume (start) capacity if paused

 If($CapacityState -eq "Paused")
        {Resume-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroup -Name $PBIEmbeddedResource}
    Else
        {Write-Host "Capacity is already running"}