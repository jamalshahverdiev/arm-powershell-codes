### Create variables for first database and VM:
```powershell
> $resourcegroupname = "jsRG"
> $location = "WestEurope"
> $servername = "server-$(Get-Random)"
> $adminlogin = "azureDBAdmin"
> $password = 'AzureDat2b@sep!$20rd'
> $startip = "0.0.0.0"
> $endip = "0.0.0.0"
> $databasename = "AzureDBName"
```

### This variables for second database and VM:
```powershell
> $servername1 = "dbsrvrestfrombacktst"
> $adminlogin1 = "azureDBAdmin"
> $password1 = 'AzureDat2b@sep!$20rd'
```

### Create new resource group:
```powershell
> New-AzureRmResourceGroup -Name jsRG -Location "westeurope"
```

### Create new VM for first SQL server:
```powershell
> New-AzureRmSqlServer -ResourceGroupName $resourcegroupname -ServerName $servername -Location $location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
```

### Give firewall access to first VM:
```powershell
> New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname -ServerName $servername -FirewallRuleName "AllowSome" -StartIpAddress $startip -EndIpAddress $endip
```

### Create new SQL database:
```powershell
> New-AzureRmSqlDatabase -ResourceGroupName $resourcegroupname -ServerName $servername -DatabaseName $databasename -SampleName "AdventureWorksLT" -RequestedServiceObjectiveName "S0"
```


### Create second VM for second SQL server and give firewall access to this VM:
```powershell
> New-AzureRmSqlServer -ResourceGroupName $resourcegroupname -ServerName $servername1 -Location $location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin1, $(ConvertTo-SecureString -String $password1 -AsPlainText -Force))
```

### Give firewall access to second VM:
```powershell
> New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname -ServerName $servername1 -FirewallRuleName "AllowSome" -StartIpAddress $startip -EndIpAddress $endip
```

### Create storage variables and storageaccount to store bacpac files and import from there:
```powershell
> $storageName = "artemsaidtocreatestr"
> $container_name = "sitecorecontainer"
> New-AzureRmStorageAccount -ResourceGroupName $resourcegroupname -AccountName $storageName -Location $location  -SkuName "Standard_LRS" -Kind Storage
```

### Get account key and context from our storage account:
```powershell
> $accountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourcegroupname -Name $storageName).Value[0]
> $context = New-AzureStorageContext -StorageAccountName $storageName -StorageAccountKey $accountKey 
```

### Create new container in our storage:
```powershell
> New-AzureStorageContainer -Name "$container_name" -Context $context -Permission Container
```

### Get storage name from our variable to be more dynamically:
```powershell
> $getstoragename = (Get-AzureRMStorageAccount | Select StorageAccountName) | findstr ^$storageName
```

### Convert password to string and export database:
```powershell
> $pwd = ConvertTo-SecureString "$($password)" -AsPlainText -Force
> New-AzureRmSqlDatabaseExport -ResourceGroupName $resourcegroupname -ServerName $servername -DatabaseName $databasename -StorageKeyType "StorageAccessKey" -StorageKey $accountKey -StorageUri "https://$getstoragename.blob.core.windows.net/$container_name/$databasename.bacpac" -AdministratorLogin $adminlogin -AdministratorLoginPassword $pwd
```

## Import database from bacpac file:
### Set variables:
```powershell
> $servername1 = "dbsrvrestfrombacktst"
> $adminlogin1 = "azureDBAdmin"
> $pwd1 = ConvertTo-SecureString "$($password1)" -AsPlainText -Force
```

### Import from bacpac:
```powershell
> New-AzureRmSqlDatabaseImport -ResourceGroupName $resourcegroupname -ServerName $servername1 -DatabaseName $databasename -StorageKeyType "StorageAccessKey" -StorageKey $accountKey -StorageUri "https://$getstoragename.blob.core.windows.net/$container_name/$databasename.bacpac" -AdministratorLogin $adminlogin1 -AdministratorLoginPassword $pwd1 -Edition Standard -ServiceObjectiveName S0 -DatabaseMaxSizeBytes 5000000
```

