### Login to the Azure subscribe:
```powershell
PS C:\Users\jamal.shahverdiyev\azure-quickstart-templates\201-2-vms-internal-load-balancer> Import-AzureRmContext -path (Get-ChildItem .\AvanadeCredentials.json).FullName
```

### Create new Resource Group:
```powershell
PS C:\Users\jamal.shahverdiyev\azure-quickstart-templates\201-2-vms-internal-load-balancer> New-AzureRmResourceGroup -Name MvaModule3ResourceGroup -Location "westeurope"
```

### Deploy new template:
```powershell
PS > New-AzureRmResourceGroupDeployment -Name MvaModule3Deployment -ResourceGroupName MvaModule3ResourceGroup -TemplateFile ".\azuredeploy.json" -TemplateParameterFile ".\azuredeploy.parameters.json"
DeploymentName          : MvaModule3Deployment
ResourceGroupName       : MvaModule3ResourceGroup
ProvisioningState       : Succeeded
Timestamp               : 1/6/2018 9:35:03 PM
Mode                    : Incremental
TemplateLink            :
Parameters              :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          virtualNetworkName  String                     ContosoVnet
                          networkInterfaceName  String                     Contoso-Nic-BE
                          loadBalancerName  String                     contosoILB
                          adminUsername    String                     admin123
                          adminPassword    SecureString
                          imagePublisher   String                     MicrosoftWindowsServer
                          vmNamePrefix     String                     BackendVM
                          imageOffer       String                     WindowsServer
                          imageSKU         String                     2012-R2-Datacenter
                          vmStorageAccountContainerName  String                     vhds
                          vmName           String                     BackendVM
                          storageAccountName  String                     qashqaldaq
                          vmSize           String                     Standard_D1

Outputs                 :
DeploymentDebugLogLevel :
```


### Delete new deployment:
```powershell
PS > Remove-AzureRMResourceGroup -Name MvaModule3ResourceGroup -Force
```

### Workspace path in the Azure where will be downloaded all code files:
```powershell
C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.9\Downloads\0\Scripts
```

### Workspace for the DSC:
```powershell
C:\Packages\Plugins\Microsoft.Powershell.DSC\2.75.0.0\DSCWork\
```

### Log files path in the Virtual machine:
```powershell
C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\1.9
```
