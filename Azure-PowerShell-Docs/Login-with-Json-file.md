### First of all Install AzureRM and Azure module to your windows Desktop Powershell:
```powershell
PS C:\Users\jamal.shahverdiyev> Install-Module AzureRM -AllowClobber -Force
PS C:\Users\jamal.shahverdiyev> Install-Module Azure -Force
```

### Login with credentials to the azure portal:
```powershell
PS C:\Users\jamal.shahverdiyev\sitecoremigration> Login-AzureRmAccount
<p align="center">
  <img width="460" height="300" src="https://github.com/jamalshahverdiev/arm-powershell-codes/blob/master/Azure-PowerShell-Docs/Images/login-to-az1.png/460/300">
</p>
<p align="center">
  <img width="460" height="300" src="https://github.com/jamalshahverdiev/arm-powershell-codes/blob/master/Azure-PowerShell-Docs/Images/login-to-az2.png/460/300">
</p>
![loginPhoto1](https://github.com/jamalshahverdiev/arm-powershell-codes/blob/master/Azure-PowerShell-Docs/Images/login-to-az1.png)
![loginPhoto2](https://github.com/jamalshahverdiev/arm-powershell-codes/blob/master/Azure-PowerShell-Docs/Images/login-to-az2.png) 
```

### Login to the azure and save result to the json file (Execute command inside of "()" symbols and give output as argument to the "-Profile"):
```powershell
PS C:\PowerShell> Save-AzureRmContext -Profile (Add-AzureRmAccount) -Path C:\PowerShell\AvanadeCredentials.json
```

### Get Current Profile information:
```powershell
PS C:\PowerShell> Get-AzureRmContext
Name             : Default
Account          : jamal.shahverdiev@gmail.com
SubscriptionName : Microsoft Azure Enterprise
TenantId         : 8f2ae161-8be5-48e8-99af-d827210c2f1e
Environment      : AzureCloud
```

### Get all resource groups to be sure everything is working:
```powershell
PS C:\PowerShell> Get-AzureRmResourceGroup
ResourceGroupName : cloud-shell-storage-southeastasia
Location          : southeastasia
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/7739e5e8-222a-46c5-b26f-5d7191b4e5b6/resourceGroups/cloud-shell-storage-southeastasia

ResourceGroupName : JSRG
Location          : westeurope
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/7739e5e8-222a-46c5-b26f-5d7191b4e5b6/resourceGroups/JSRG
```

### Remove account and then check resource groups to be sure it is not working:
```powershell
PS C:\PowerShell> Remove-AzureRmAccount
Id                    : jamal.shahverdiev@gmail.com
Type                  : User
Tenants               : {8f2ae161-8be5-48e8-99af-d827210c2f1e, defd874c-de77-4eed-8d0d-2306267e4070}
AccessToken           :
Credential            :
TenantMap             : {}
CertificateThumbprint :
ExtendedProperties    : {[Subscriptions, 7739e5e8-222a-46c5-b26f-5d7191b4e5b6], [Tenants,
                        8f2ae161-8be5-48e8-99af-d827210c2f1e,defd874c-de77-4eed-8d0d-2306267e4070]}


PS C:\PowerShell> Get-AzureRmResourceGroup
Get-AzureRmResourceGroup : Run Login-AzureRmAccount to login.
At line:1 char:1
+ Get-AzureRmResourceGroup
+ ~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [Get-AzureRmResourceGroup], PSInvalidOperationException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.GetAzureResourceGroupCmdlet
```

### Import credentials from Json file and then look at the Resource group list(I have deleted some of resource groups from output 😊):
```powershell
PS C:\PowerShell> Import-AzureRmContext -path C:\PowerShell\AvanadeCredentials.json
Account          : jamal.shahverdiev@gmail.com
SubscriptionName : Microsoft Azure Enterprise
SubscriptionId   : 7739e5e8-222a-46c5-b26f-5d7191b4e5b6
TenantId         : 8f2ae161-8be5-48e8-99af-d827210c2f1e
Environment      : AzureCloud

Or: Import-AzureRmContext -path (Get-ChildItem .\AvanadeCredentials.json).FullName
```

```powershell
PS C:\PowerShell> Get-AzureRmResourceGroup
ResourceGroupName : cloud-shell-storage-southeastasia
Location          : southeastasia
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/7739e5e8-222a-46c5-b26f-5d7191b4e5b6/resourceGroups/cloud-shell-storage-southeastasia

ResourceGroupName : JSRG
Location          : westeurope
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/7739e5e8-222a-46c5-b26f-5d7191b4e5b6/resourceGroups/JSRG
```