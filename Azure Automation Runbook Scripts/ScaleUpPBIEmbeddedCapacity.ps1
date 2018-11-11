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

#4. Determine scale up node size

$ScaleUpSKU = 
    If ($CapacitySKU -eq "A1") {"A2"}
    ElseIf ($CapacitySKU -eq "A2") {"A3"}
    ElseIf ($CapacitySKU -eq "A3") {"A4"}
    ElseIf ($CapacitySKU -eq "A4") {"A5"}
    Else {"A6"}

#5. Scale up one node size if the capacity is running

If ($CapacityState -eq "Succeeded")
        {Update-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroup -Name $PBIEmbeddedResource -Sku $ScaleUpSKU}
        Else {Write-Host "Capacity node isn't running"}