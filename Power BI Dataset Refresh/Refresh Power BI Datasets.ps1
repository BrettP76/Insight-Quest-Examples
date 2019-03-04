#1. Authenticate to Power BI with Power BI Service Admin account

$User = "123456@thebigcompany.com"
$PW = "theuserpw"

$SecPasswd = ConvertTo-SecureString $PW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($User,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#2. Get the workspace ID of the dataset(s) to be refreshed

$WSIDAdmin = Get-PowerBIWorkspace -Scope Organization -Name 'BI Administration and Monitoring' | `
    Where {$_.Type -eq "Workspace"} | ForEach {$_.Id}

#3. Get the dataset ID(s) of the datasets to be refreshed 

#Refresh History Dataset
$DSIDRefresh = Get-PowerBIDataset -Scope Organization -WorkspaceId $WSIDAdmin | ` 
    Where {$_.Name -eq "Refresh History"} | ForEach {$_.Id}

#PBI Tenant Wide Monitoring dataset
$DSIDMonitor = Get-PowerBIDataset -Scope Organization -WorkspaceId $WSIDAdmin | ` 
    Where {$_.Name -eq "PBI Tenant-Wide Deployment"} | ForEach {$_.Id}

#Gateway Analysis dataset
$DSIDGateway = Get-PowerBIDataset -Scope Organization -WorkspaceId $WSIDAdmin | ` 
    Where {$_.Name -eq "Gateway Analysis"} | ForEach {$_.Id}

#4. Build dataset refresh URLs

$RefreshDSURL = 'groups/' + $WSIDAdmin + '/datasets/' + $DSIDRefresh + '/refreshes'

$MonitorDSURL = 'groups/' + $WSIDAdmin + '/datasets/' + $DSIDMonitor + '/refreshes'

$GatewayDSURL = 'groups/' + $WSIDAdmin + '/datasets/' + $DSIDGateway + '/refreshes'

#5. Execute refreshes with mail on failure

$MailFailureNotify = @{"notifyOption"="MailOnFailure"}

Invoke-PowerBIRestMethod -Url $RefreshDSURL -Method Post -Body $MailFailureNotify

Invoke-PowerBIRestMethod -Url $MonitorDSURL -Method Post -Body $MailFailureNotify

Invoke-PowerBIRestMethod -Url $GatewayDSURL -Method Post -Body $MailFailureNotify
