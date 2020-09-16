#!/usr/bin/env pwsh

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers -ParticipateInCEIP $false -Confirm:$false | Out-null
[string[]]$fileContent = Get-Content 'credentials.yml'
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$yaml = ConvertFrom-YAML $content
$password = ConvertTo-SecureString $yaml.vcVars.passString -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($yaml.vcVars.username, $password)
(Connect-VIServer -Server $yaml.vcVars.vcenterHost -Credential $creds -Force) | out-null

$VMHost = (Get-VMHost |? Parent -like $yaml.vcVars.clusterName | Sort-Object MemoryUsageGB | Select -First 1).Name 
(New-VM -Name $yaml.vcVars.vmName -Template $yaml.vcVars.templateName -VMHost $VMHost -Datastore $yaml.vcVars.dataStoreName -NetworkName $yaml.vcVars.vSwitchName -Confirm:$false -RunAsync) | out-null
Start-Sleep -s 20
Start-VM -VM $yaml.vcVars.vmName -Confirm:$false -RunAsync

Start-Sleep -s 60
write-Host ""
Write-Host IP address of $yaml.vcVars.vmName VM is:  (Get-VM | where-object {$_.PowerState –eq "PoweredOn"} | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}} | Where-Object { $_.Name -eq $yaml.vcVars.vmName}).'IP Address'
