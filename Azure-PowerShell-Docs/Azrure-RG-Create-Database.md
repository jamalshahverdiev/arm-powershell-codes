### Set variables to the Database in Azure:

```powershell
PS C:\PowerShell> $resourcegroupname = "jsRG"
PS C:\PowerShell> $location = "WestEurope"
PS C:\PowerShell> $servername = "server-$(Get-Random)"
PS C:\PowerShell> $adminlogin = "azureDBAdmin"
PS C:\PowerShell> $password = "AzureDat2b@sep!$20rd"
PS C:\PowerShell> $startip = "0.0.0.0"
PS C:\PowerShell> $endip = "0.0.0.0"
PS C:\PowerShell> $databasename = "AzureDBName"
```

### Create new resource group:
```powershell
PS C:\PowerShell> New-AzureRmResourceGroup -Name jsRG -Location "westeurope"
```

### Create new SQL server in the Azure:
```powershell
PS C:\PowerShell> New-AzureRmSqlServer -ResourceGroupName $resourcegroupname -ServerName $servername -Location $location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
ResourceGroupName        : jsRG
ServerName               : server-571612433
Location                 : westeurope
SqlAdministratorLogin    : azureDBAdmin
SqlAdministratorPassword :
ServerVersion            : 12.0
Tags                     :
Identity                 :
```

### Open port in the firewall for our database:
PS C:\PowerShell> New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname -ServerName $servername -FirewallRuleName "AllowSome" -StartIpAddress $startip -EndIpAddress $endip
```powershell
ResourceGroupName : jsRG
ServerName        : server-571612433
StartIpAddress    : 0.0.0.0
EndIpAddress      : 0.0.0.0
FirewallRuleName  : AllowSome
```

### Create new database with sample name "AdventureWorksLT":
```powershell
PS C:\PowerShell> New-AzureRmSqlDatabase -ResourceGroupName $resourcegroupname -ServerName $servername -DatabaseName $databasename -SampleName "AdventureWorksLT" -RequestedServiceObjectiveName "S0"
ResourceGroupName             : jsRG
ServerName                    : server-571612433
DatabaseName                  : AzureDBName
Location                      : West Europe
DatabaseId                    : 0a262bfc-13fd-4b6c-8776-be6efa4821ae
Edition                       : Standard
CollationName                 : SQL_Latin1_General_CP1_CI_AS
CatalogCollation              :
MaxSizeBytes                  : 268435456000
Status                        : Online
CreationDate                  : 12/4/2017 9:57:52 AM
CurrentServiceObjectiveId     : f1173c43-91bd-4aaa-973c-54e79e15235b
CurrentServiceObjectiveName   : S0
RequestedServiceObjectiveId   : f1173c43-91bd-4aaa-973c-54e79e15235b
RequestedServiceObjectiveName :
ElasticPoolName               :
EarliestRestoreDate           : 12/4/2017 10:28:36 AM
Tags                          :
ResourceId                    : /subscriptions/7739e5e8-222a-46c5-b26f-5d7191b4e5b6/resourceGroups/jsRG/providers/Microsoft.
                                Sql/servers/server-571612433/databases/AzureDBName
CreateMode                    :
ReadScale                     : Disabled
ZoneRedundant                 : False
```
