$paramsjson = (Get-Content "../azuredeploy.parameters.json" -Raw) | ConvertFrom-Json
$secpword = ConvertTo-SecureString -String $paramsjson.parameters.winrmVMAdminPassword.value -AsPlainText -Force
$fqdn = ( "{0}{1}" -f  $paramsjson.parameters.winrmPublicIPDnsName.value, '.westeurope.cloudapp.azure.com' )
$Credential = New-Object System.Management.Automation.PSCredential ($paramsjson.parameters.winrmVMAdminUserName.value, $secpword)

# Create New Session
$SessionOption = New-PSSessionOption -SkipCACheck
$s = New-PSSession -ComputerName $fqdn -Credential $Credential -Port 5986 -UseSSL -SessionOption $SessionOption

# We can execute script already downloaded to inside of VM via DSC
# Invoke-Command -session $s -FilePath .\Scripts\Sync-Data.ps1 -ArgumentList $randomPass, $sqlAdminLogin, $sqlAdminpass, $oldsqlsrvName, $newsqlsrvName, $databaseName

# Connect to the remote PowerShell and create some folder then remote the session
Enter-PSSession -Session $s
Invoke-Command -Session $s -ScriptBlock { New-Item C:\YeniQovluq -ItemType directory }
Remove-PSSession $s
