#1. Define variables to retrieve parameter values stored as Azure Automation variables or credentials

$AzureASResource = Get-AutomationVariable -Name 'AzureASResource'
$Tenant = Get-AutomationVariable -Name 'FrontlineTenant'
$ResourceGroup = Get-AutomationVariable -Name 'BIResourceGroupName'

$AzureCred = Get-AutomationPSCredential -Name "AzureASRefreshCred"

#2. Authenticate to Azure Analysis Services with stored credential in Azure Automation

Connect-AzureRmAccount -Credential $AzureCred -Tenant $Tenant -ServicePrincipal  

#3. Capture server state and server instance size ("S0","S1","S2","S4")

$ServerConfig = Get-AzureRmAnalysisServicesServer -ResourceGroupName $ResourceGroup -Name $AzureASResource
$ServerSKU = $ServerConfig.Sku.Name
$ServerState = $ServerConfig.State

#4. Determine scale down instance size (one level lower to a min of "S0")

$ScaleDownSKU = 
    If ($ServerSKU -eq "S4") {"S2"}
    ElseIf ($ServerSKU -eq "S2") {"S1"}
    Else {"S0"}

#5. Scale up Azure AS resource if running

If($ServerState -eq "Succeeded")
    {Set-AzureRmAnalysisServicesServer -Name $AzureASResource -ResourceGroupName $ResourceGroup -Sku $ScaleDownSKU}
    Else {Write-Host "Server instance isn't running"}