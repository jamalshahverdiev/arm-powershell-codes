#### Before use PowerShell script we must reconfgiure winRM (Execute the following commands inside of the **PowerShell** CLI). We must regenerate certificate with the **IP address** of Virtual machine (In my case the IP address of the VM was **10.234.190.45**):
```powershell
PS C:\Users\Administrator> New-SelfSignedCertificate -DnsName 10.234.190.45 -CertStoreLocation Cert:\LocalMachine\My
   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

   Thumbprint                                Subject
   ----------                                -------
   5566FDCB530B2BA407B361B8680D35CDA09834BB  CN=10.234.190.45
```

#### Delete previous WinRM listener:
```powershell
PS C:\Users\Administrator> winrm delete winrm/config/listener?Address=*+Transport=HTTPS
```

#### Reconfigure **WinRM** listener with the copied thubprint **5566FDCB530B2BA407B361B8680D35CDA09834BB** and IP address from first command:
```powershell
PS C:\Users\Administrator> winrm create winrm/config/listener?Address=*+Transport=HTTPS '@{Hostname="10.234.190.45";CertificateThumbprint="5566FDCB530B2BA407B361B8680D35CDA09834BB";port="5986"}'
ResourceCreated
    Address = http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous
        ReferenceParameters
                ResourceURI = http://schemas.microsoft.com/wbem/wsman/1/config/listener
                        SelectorSet
                                    Selector: Address = *, Transport = HTTPS
PS C:\Users\Administrator>
```

#### Use script like as following to join to the Jenkins master server:
```powershell
PS C:\PsScripts> .\JoinToJenkins.ps1 -remoteServerIPorName "10.234.190.45" -remoteServerUserName "Administrator" -remoteServerPassword "Zumrud123" -jenkinsMaster "jenkins.loc" -jenkinsMasterUser "slave" -jenkinsMasterPassword "slave12345"

Directory: C:\

Mode                LastWriteTime         Length Name                            PSComputerName                                                    
----                -------------         ------ ----                            -------------- 
d-----       2019-09-26     13:24         JenkinSlave                            10.234.190.45                    
Id             : 1900
Handles        : 34
CPU            : 0.015625
Name           : java
PSComputerName : 10.234.190.45
```

