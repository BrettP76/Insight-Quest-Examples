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

#3. Capture capacity state

$CapacityConfig = Get-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroupName -Name $EmbeddedResource

$CapacityState = $CapacityConfig.State

#4. Suspend capacity if running

    If($CapacityState -eq "Succeeded")
        {Suspend-AzureRmPowerBIEmbeddedCapacity -ResourceGroupName $ResourceGroupName -Name $EmbeddedResource}
    Else
        {Write-Host "Capacity is already paused"}