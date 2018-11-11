#1. Define variables to retrieve parameter values stored as Azure Automation variables or credentials

$PBIEmbeddedResource = Get-AutomationVariable -Name 'PBIEmbeddedResource'
$Tenant = Get-AutomationVariable -Name 'FrontlineTenant'
$ResourceGroup = Get-AutomationVariable -Name 'BIResourceGroupName'

$AzureCred = Get-AutomationPSCredential -Name "AzureASRefreshCred"

#2. Authenticate with stored credential in Azure Automation

Connect-AzureRmAccount -Credential $AzureCred -Tenant $Tenant -ServicePrincipal  

#3. Capture PBI Embedded capacity state ("Paused" or Succeeded") and node size ("A1"...."A6")

$CapacityConfig = Get-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroup -Name $PBIEmbeddedResource
$CapacityState = $CapacityConfig.State
$CapacitySKU = $CapacityConfig.Sku

#4. Determine scale down node size

$ScaleDownSKU = 
    If ($CapacitySKU -eq "A6") {"A5"}
    ElseIf ($CapacitySKU -eq "A5") {"A4"}
    ElseIf ($CapacitySKU -eq "A4") {"A3"}
    ElseIf ($CapacitySKU -eq "A3") {"A2"}
    Else {"A1"}

#5. Scale down one node size if the capacity is running

If ($CapacityState -eq "Succeeded")
        {Update-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroup -Name $PBIEmbeddedResource -Sku $ScaleDownSKU}
        Else {Write-Host "Capacity node isn't running"}