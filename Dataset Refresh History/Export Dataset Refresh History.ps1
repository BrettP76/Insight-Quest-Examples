#1. Authenticate to Power BI with Power BI Service Administrator Account

$User = "123456@abc.com"
$PW = "abcdefgh"

$SecPasswd = ConvertTo-SecureString $PW -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($User,$SecPasswd)

Connect-PowerBIServiceAccount -Credential $myCred

#2. Export paths 

$RefreshExportPath = "C:\Users\Brett Powell\ArtifactExport\RefreshHistory\"

$Dataset1path = $RefreshExportPath + "Dataset1.json"

$Dataset2Path = $RefreshExportPath + "Dataset2.json"

$Dataset3Path = $RefreshExportPath + "Dataset3.json"

#3. Get Dataset IDs based on workspace

#Dataset ID for Dataset 1
$DS1WorkspaceID = Get-PowerBIWorkspace -Scope Organization -Name "Workspace Name of Dataset 1" | Where {$_.State -eq "Active"} | ForEach {$_.Id}

$DS1ID = Get-PowerBIDataset -Scope Organization -WorkspaceId $DS1WorkspaceID | ` 
    Where {($_.IsRefreshable -eq $True) -and ($_.Name -eq "Dataset 1 Name")} | ForEach {$_.Id} | Get-Unique -AsString

#Dataset ID for Dataset 2
$DS2WorkspaceID = Get-PowerBIWorkspace -Scope Organization -Name "Workspace Name of Dataset 2" | Where {$_.State -eq "Active"} | ForEach {$_.Id}

$DS2ID = Get-PowerBIDataset -Scope Organization -WorkspaceId $DS2WorkspaceID | ` 
    Where {($_.IsRefreshable -eq $True) -and ($_.Name -eq "Dataset 2 Name")} | ForEach {$_.Id} | Get-Unique -AsString

#Dataset ID for Dataset 3
$DS3WorkspaceID = Get-PowerBIWorkspace -Scope Organization -Name "Workspace Name of Dataset 3" | Where {$_.State -eq "Active"} | ForEach {$_.Id}

$DS3ID = Get-PowerBIDataset -Scope Organization -WorkspaceId $DS3WorkspaceID | ` 
    Where {($_.IsRefreshable -eq $True) -and ($_.Name -eq "Dataset 3 Name")} | ForEach {$_.Id} | Get-Unique -AsString

#4. Refresh API URLs 

$URLStart = 'admin/datasets/'

$URLEnd = '/refreshes'

$DS1URL = $URLStart + $DS1ID + $URLEnd

$DS2URL = $URLStart + $DS2ID + $URLEnd

$DS3URL = $URLStart + $DS3ID + $URLEnd

#5. Export Refresh History files

Invoke-PowerBIRestMethod -Url $DS1URL -Method Get | Out-File $Dataset1Path

Invoke-PowerBIRestMethod -Url $DS2URL -Method Get | Out-File $Dataset2Path

Invoke-PowerBIRestMethod -Url $DS3URL -Method Get | Out-File $Dataset3Path