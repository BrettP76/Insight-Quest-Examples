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

#3. Capture server state 

$ServerConfig = Get-AzureRmAnalysisServicesServer -ResourceGroupName $ResourceGroupName -Name $ServerName

$ServerState = $ServerConfig.State

#4. Pause Azure AS Server if paused

If($ServerState -eq "Succeeded")
    {Suspend-AzureRmAnalysisServicesServer -Name $Servername -ResourceGroupName $ResourceGroupName}
    Else {Write-Host "Server is already running"}