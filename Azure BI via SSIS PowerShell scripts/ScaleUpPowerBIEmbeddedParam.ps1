#1. Define parameters

param(
    [Parameter(Mandatory=$True,Position=0)]
    [string]$AppID,
    [Parameter(Mandatory=$true,Position=1)]
    [string]$AppIDKey,
    [Parameter(Mandatory=$true,Position=2)]
    [string]$TenantID,
    [Parameter(Mandatory=$true,Position=3)]
    [string]$EmbeddedResource,
    [Parameter(Mandatory=$true,Position=4)]
    [string]$ResourceGroupName
    )

#2. Authenticate

$SecurePassword = $AppIDKey | ConvertTo-SecureString -AsPlainText -Force
$Cred = new-object -typename System.Management.Automation.PSCredential `
     -argumentlist $AppID, $SecurePassword

Connect-AzureRmAccount -Credential $Cred -Tenant $TenantID -ServicePrincipal  

#3. Capture PBI Embedded capacity state ("Paused" or Succeeded") and node size ("A1"...."A6")

$CapacityConfig = Get-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroupName -Name $EmbeddedResource

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
        {Update-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroupName -Name $EmbeddedResource -Sku $ScaleUpSKU}
    Else {Write-Host "Capacity node isn't running"}
