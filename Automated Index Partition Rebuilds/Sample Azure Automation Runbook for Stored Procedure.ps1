#1. Retrieve variable values from Azure Automation
$SqlUserName = Get-AutomationVariable -Name 'PBIAdminProdUser'
$SqlPass = Get-AutomationVariable -Name 'PBIAdminProdPW'
$Server = Get-AutomationVariable -Name 'SynapseProdDWServerFull'
$Database = Get-AutomationVariable -Name 'SynapseProdDWDatabase'

#2. Define SQL connection and command objects
$SQLQuery = "EXECUTE BI.spREBUILD_INDEX_PARTITION_TRANSACTIONLOG"

$SQLConn = New-Object System.Data.SqlClient.SqlConnection("Server=tcp:$Server,1433;Initial Catalog=$Database;User ID=$SqlUserName;Password=$SqlPass;Encrypt=True;Connection Timeout = 180;Trusted_Connection=False")

$SQLConn.Open()

$Command = New-Object System.Data.SqlClient.SqlCommand($SQLQuery,$SQLConn)

$Command.CommandTimeout = 0

#3. Execute command and close connection
$Command.ExecuteNonQuery()

$SQLConn.Close()