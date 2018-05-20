$resourcegroupname = "jsRG"
$location = "WestEurope"
$servername = "server-$(Get-Random)"
$adminlogin = "azureDBAdmin"
$password = 'AzureDat2b@sep!$20rd'
$startip = "0.0.0.0"
$endip = "0.0.0.0"
$databasename = "AzureDBName"

New-AzureRmResourceGroup -Name jsRG -Location "westeurope"
New-AzureRmSqlServer -ResourceGroupName $resourcegroupname -ServerName $servername -Location $location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname -ServerName $servername -FirewallRuleName "AllowSome" -StartIpAddress $startip -EndIpAddress $endip
New-AzureRmSqlDatabase -ResourceGroupName $resourcegroupname -ServerName $servername -DatabaseName $databasename -SampleName "AdventureWorksLT" -RequestedServiceObjectiveName "S0"
