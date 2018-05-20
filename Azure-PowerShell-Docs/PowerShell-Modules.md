## In this article I will describe how to use PowerShell modules inside of PowerShell scripts.

#### Open PowerShell console and change directory for user WindowsPowerShell folder(If windowsPowerShell folder doesn’t exists just create this one too):
```powershell
PS C:\Users\jamal.shahverdiyev> cd $HOME\Documents\WindowsPowerShell
> mkdir WindowsPowerShell\Modules\Tools
```

#### Create 'Tools.psm1' file with the following content:
```powershell
> Get-Content .\Tools.psm1
Function Get-IPAddress {
    Param([string]$name)
    (Get-NetIPConfiguration $name | findstr IPv4Address).split(":")[1]
}

Function GetInfo {
    Param([string]$disk)
    if ( $disk -eq 'HDD') { Get-Disk }
    else { Write-Host 'Paramter' $disk 'is not right'}
}
```

#### Then from root folder try to import new module:
```powershell
> cd C:\
PS C:\> Import-Module Tools

List all methods in this module:
> Get-Module Tools -ListAvailable

Directory: C:\Users\jamal.shahverdiyev\Documents\WindowsPowerShell\Modules
ModuleType Version    Name      ExportedCommands                                                                                              
---------- -------    ----      ----------------                                                                                              
Script     0.0        Tools     {GetInfo, Get-IPAddress}       
```

#### In the different script try to import created 'Tools' module and execute methods to see the output:
```powershell
PS C:\PowerShell-Codes\Module-Test> cat .\mainCode.ps1
Import-Module Tools

Get-IPAddress -name 'Wi-Fi'
GetInfo -disk 'HDD'
```

#### Then just execute this script to see the output:
```powershell
PS C:\PowerShell-Codes\Module-Test> .\mainCode.ps1
This is the IP address of the Wi-Fi adapter:  192.168.106.33

Number Friendly Name Serial Number         HealthStatus  OperationalStatus   Total Size Partition Style
------ ------------- -------------         ------------  -----------------   ---------- ----------
0      NVMe PC300... 6B96_0790_712E_E4AC.  Healthy       Online              476.94 GB 	GPT
```

#### Go to the same folder as I showed in the previous module and create 'Watch' folder:
```powershell
PS C:\Users\jamal.shahverdiyev> cd $HOME\Documents\WindowsPowerShell
> mkdir WindowsPowerShell\Modules\Watch
```
