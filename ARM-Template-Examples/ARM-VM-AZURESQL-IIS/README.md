### Deploy Windows VM with IIS server and 2 sites which will communicate with Azure SQL server databases for each of sites.

##### To deploy just execute the following command. The script *Deploy-AzureResourceGroup.ps1* call template file *azuredeploy.json* with parameters file *azuredeploy.parameters.json*. An argument *-UploadArtifacts* will upload all local files and folder to the Azure storage container.
```powershell
> .\Deploy-AzureResourceGroup.ps1 -UploadArtifacts
```

##### The *azuredeploy.json* ARM template will deploy Windows VM with DSC and PowerShell script extension resource. PowerShell script extension depends on DSC and Windows VM resource. 

##### The *jsDSC.ps1* DSC resource install/configure IIS server with two sites in different ports (10080 and 10081) then, copies *site-artifact.zip* file inside of the new Windows VM.

##### The *jsWebDeploy.ps1* PowerShell script open ports **10080** and **10081** inside of the Windows VM, extract *site-artifact.zip* file to the inside of the sites folder and then configure **web.config** file connection string for each of the sites to the different databases.

##### At the end of the deployment we need to get output as following:
```powershell
OutputsString           :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          vmServerName     String                     jsarmvmdns.westeurope.cloudapp.azure.com
                          sqlServerName    String                     sqldscsitedeployir4qc4tzdq3fq.database.windows.net
```

##### Just open links in your browser:
##### http://jsarmvmdns.westeurope.cloudapp.azure.com:10080 and http://jsarmvmdns.westeurope.cloudapp.azure.com:10081

##### Output must be as: *"TestUser"*
