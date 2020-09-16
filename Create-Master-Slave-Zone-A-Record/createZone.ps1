Param(
    [Parameter(Mandatory=$true)][string] $domainName,
	[Parameter(Mandatory=$true)][string] $adIPorName,
	[Parameter(Mandatory=$true)][string] $adUserName,
	[Parameter(Mandatory=$true)][string] $adPassword,
	[Parameter(Mandatory=$true)][string] $slaveIP,
	[Parameter(Mandatory=$true)][string] $slaveUser,
	[Parameter(Mandatory=$true)][string] $slavePassword
)

function createSession($adIPorName, $adUserName, $adPassword, $domainName) {
	$secpword = ConvertTo-SecureString -String $adPassword -AsPlainText -Force
	$Credential = New-Object System.Management.Automation.PSCredential ($adUserName, $secpword)
	$SessionOption = New-PSSessionOption -SkipCACheck
	$s = New-PSSession -ComputerName $adIPorName -Credential $Credential -Port 5986 -UseSSL -SessionOption $SessionOption
	#Enter-PSSession -Session $s
#Invoke-Command -session $s -FilePath .\createZone.ps1
	Invoke-Command -session $s -ScriptBlock ${function:createZoneOrRecordInWindows} -ArgumentList $domainName, $adIPorName
}

function createZoneOrRecordInWindows($domainName, $adIPorName) {
	if (Get-DnsServerZone -Name $domainName -ErrorAction SilentlyContinue) {
		write-host "This domain is already exists. If you want to add new A record please input A record name and IP address."
		$aRecord = Read-Host -Prompt 'Input your A Record' 
		$ipAddress = Read-Host -Prompt 'Input IP address of your A Record'
		if (!$aRecord -And !$ipAddress) { 
			Write-Host "A record and IP address cannot be empty" 
			exit 100    
		}
		Add-DnsServerResourceRecordA -Name "$aRecord" -ZoneName "$domainName" -AllowUpdateAny -IPv4Address "$ipAddress" -TimeToLive "00:00:10"    
	} else {
		Add-DnsServerPrimaryZone -Name $domainName -ZoneFile "$domainName.dns"
		Set-DNSServerPrimaryZone -ComputerName "$adIPorName" -Name $domainName -SecureSecondaries TransferAnyServer -Notify Notify
		write-host "Added new Domain name: $domainName"
	}
}
# TO remove A record use the following syntax
#Remove-DnsServerResourceRecord -ZoneName tesssss.lan -Name mail -RRType A -Force

function createZoneInSlave($slaveIP, $slaveUser, $slavePassword, $domainName) {
   write-host "Slaves: $slaveIP $slaveUser $slavePassword"
   $secpword = ConvertTo-SecureString -AsPlainText $($slavePassword) -Force
   $Credential = New-Object System.Management.Automation.PSCredential ($slaveUser, $secpword)
   New-SSHSession -ComputerName $slaveIP -Credential $Credential -Force
   Set-SCPFile ("{0}\{1}" -f "$PSScriptRoot", 'createZone.sh') -RemotePath "/root/" -ComputerName $slaveIP -Credential $Credential -Force
   Invoke-SSHCommand -Index 0 -Command "chmod 777 createZone.sh && /root/createZone.sh $domainName" -TimeOut 130
}

createSession "$adIPorName" "$adUserName" "$adPassword" "$domainName"
createZoneInSlave "$slaveIP" "$slaveUser" "$slavePassword" "$domainName"
