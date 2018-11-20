#1. Define parameters

param(
    [Parameter(Mandatory=$True,Position=0)]
    [string]$AppID,
    [Parameter(Mandatory=$true,Position=1)]
    [string]$AppIDKey,
    [Parameter(Mandatory=$true,Position=2)]
    [string]$TenantID,
    [Parameter(Mandatory=$true,Position=3)]
    [string]$ServerName,
    [Parameter(Mandatory=$true,Position=4)]
    [string]$ResourceGroupName
    )

#2. Authenticate

$SecurePassword = $AppIDKey | ConvertTo-SecureString -AsPlainText -Force
$Cred = new-object -typename System.Management.Automation.PSCredential `
     -argumentlist $AppID, $SecurePassword

Connect-AzureRmAccount -Credential $Cred -Tenant $TenantID -ServicePrincipal 

#3. Capture Azure AS server state ("Paused" or Succeeded") and server instance size ("S0", "S1", "S2", "S4")

$ServerConfig = Get-AzureRmAnalysisServicesServer -ResourceGroupName $ResourceGroupName -Name $ServerName

$ServerState = $ServerConfig.State
$ServerSKU = $ServerConfig.Sku.Name


#4. Determine scale down instance size (one level lower to a min of "S0")

$ScaleDownSKU = 
    If ($ServerSKU -eq "S4") {"S2"}
    ElseIf ($ServerSKU -eq "S2") {"S1"}
    Else {"S0"}

#5. Decrease instance size one level

If ($ServerState -eq "Succeeded") `
    {Set-AzureRmAnalysisServicesServer -ResourceGroupName $ResourceGroupName -Name $ServerName -Sku $ScaleDownSKU }
        Else {Write-Host "Server instance isn't running"}