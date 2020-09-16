##### Just clone this repository to the Windows server and go to the folder **Create-Master-Slave-Zone-A-Record**

##### Execute the following script to configure WinRM inside of the server:
```powershell
> .\winrmScript.ps1 -fqdn dc.loc
```

##### At the end execute the following command to configure master/slave zone in Windows and Linux servers:

```powershell
> PS C:\PsScripts> .\createZone.ps1 -domainName teste.loc -adIPorName dc.loc -adUserName adinistrator -adPassword dcPassword -slaveIP 10.234.100.3 -slaveUser root -slavePassword sshpass
```

