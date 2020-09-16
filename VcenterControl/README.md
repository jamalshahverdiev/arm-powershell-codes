#### First of all we must install PowerShell Core to the Debian 9 OS:
```bash
$ wget https://github.com/PowerShell/PowerShell/releases/download/v6.2.3/powershell_6.2.3-1.debian.9_amd64.deb
$ apt install -y liblttng-ust0
$ dpkg -i powershell_6.2.3-1.debian.9_amd64.deb
```

#### Install PowerCLI:
```powershell
PS /root> Install-Module -Name VMware.PowerCLI -Scope CurrentUser
```

#### Ignore Self Sign Certificate error:
```powershell
PS /root> Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
```

#### Write credentials to login to the vCenter (Change values of the variables):
```powershell
PS /root> $clusterName = "Cluster_Name"
PS /root> $username = "administrator@vsphere.local"
PS /root> $password = ConvertTo-SecureString "SomePassword" -AsPlainText -Force
PS /root> $creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
PS /root> $server = 'vcenterIpOrDomain'
```

#### Connect to the Vcenter server:
```powershell
PS /root> Connect-VIServer -Server $server -Credential $creds
```

#### Get Esxi Host with the low Memory usage from `Cluster`:
```powershell
PS /root> Get-VMHost |? Parent -like $clusterName | Sort-Object MemoryUsageGB
Name                 ConnectionState PowerState NumCpu CpuUsageMhz CpuTotalMhz   MemoryUsageGB   MemoryTotalGB Version
----                 --------------- ---------- ------ ----------- -----------   -------------   ------------- -------
esxi03.dc.loc        Connected       PoweredOn      40        4771       95880          39.159         511.990   6.0.0
esxi01.dc.loc        Connected       PoweredOn      40        5867       95880          76.780         511.990   6.0.0
esxi02.dc.loc        Connected       PoweredOn      40        3197       95880         106.147         511.990   6.0.0

PS /root> $VMHost = (Get-VMHost |? Parent -like $clusterName | Sort-Object MemoryUsageGB | Select -First 1).Name
```

#### Get Esxi Host from `Cluster` and then create new VM in this cluster(Datastore name `Datastote06`, Vlan name `VLAN 190`, Template name `CentOS7Temp`, VM name `KubeWorkerNode1`):
```powershell
PS /root> New-VM -Name KubeWorkerNode1 -Template CentOS7Temp -VMHost $VMHost -Datastore Datastote06 -NetworkName 'VLAN 190' | start-vm
```

#### Stop and remove VM with name `KubeWorkerNode1`:
```powershell
PS /root> Stop-VM -VM KubeWorkerNode1 -Kill -Confirm:$false
PS /root> Remove-VM -VM KubeWorkerNode1 -DeleteFromDisk -Confirm:$false -RunAsync
```

#### Get all Virtual Machines with PoweredOff State:
```powershell
PS /root> Get-VM | where-object {$_.PowerState –eq "PoweredOff"}
```

#### Get all Virtual Machines with PoweredOn State:
```powershell
PS /root> Get-VM | where-object {$_.PowerState –eq "PoweredOn"}
```

#### Get All VMs with powered on state servers and their IP addresses:
```powershell
PS /root> Get-VM | where-object {$_.PowerState –eq "PoweredOn"} | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}
```

#### Get list of templates and print NetAdapter objects of the VM with name `KubeWorkerNode1`:
```powershell
PS /root> Get-Template
PS /root> Get-NetworkAdapter -vm KubeWorkerNode1 | select *
```

#### Export list of IP to the CSV file:
```powershell
PS /root> Get-VM | where-object {$_.PowerState –eq "PoweredOn"} | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}} | Export-Csv serverandip.csv
```

#### Get all VMs with install vmware-tools version:
```powershell
PS /root> get-vm |% { get-view $_.id } | select Name, @{ Name=";ToolsVersion";; Expression={$_.config.tools.toolsVersion}}
```

#### Print all VMs with data usage and in which Datastoresthe are provisioned:
```powershell
PS /root> Get-Cluster "Cluster" | Get-VM | Select Name, @{N="Datastore";E={Get-Datastore -vm $_}}, UsedSpaceGB, ProvisionedSpaceGB
```
