## WinRM PSRemote installation and configuration

### With these ARM templates and PowerShell codes we will install and configure Windows server with already configured WinRM(PsRemote). Just execute the following command and type your Azure credentials.

```powershell
PS C:\ARMS\WinRM> .\Deploy-AzureResourceGroup.ps1 -UploadArtifacts
```

`ConfigureWinRM.ps1` - script install and configure WinRM to the server.
`makecert.exe` - Generate new SSC for WinRM.
`winrmScript.ps1` - Script calls `ConfigureWinRM.ps1` script to install and configure WinRM on remote server.
`winRMconnect.ps1` - The template script to check WinRM.

### `winRMconnect.ps1` - Script explanation

#### Create credential and DNS name variables to connect to the remote server

```powershell
$paramsjson = (Get-Content "../azuredeploy.parameters.json" -Raw) | ConvertFrom-Json
$secpword = ConvertTo-SecureString -String $paramsjson.parameters.winrmVMAdminPassword.value -AsPlainText -Force
$fqdn = ( "{0}{1}" -f  $paramsjson.parameters.winrmPublicIPDnsName.value, '.westeurope.cloudapp.azure.com' )
$Credential = New-Object System.Management.Automation.PSCredential ($paramsjson.parameters.winrmVMAdminUserName.value, $secpword)
```

#### Create New Session to the remote server

```powershell
$SessionOption = New-PSSessionOption -SkipCACheck
$s = New-PSSession -ComputerName $fqdn -Credential $Credential -Port 5986 -UseSSL -SessionOption $SessionOption
```

#### We can execute script already downloaded to inside of VM via DSC

```powershell
Invoke-Command -session $s -FilePath .\Scripts\Sync-Data.ps1 -ArgumentList $randomPass, $sqlAdminLogin, $sqlAdminpass, $oldsqlsrvName, $newsqlsrvName, $databaseName
```

#### Connect to the remote PowerShell and create some folder then remote the session

```powershell
Enter-PSSession -Session $s
Invoke-Command -Session $s -ScriptBlock { New-Item C:\YeniQovluq -ItemType directory }
Remove-PSSession $s
```