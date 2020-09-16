Param(
	[Parameter(Mandatory=$true)][string] $remoteServerIPorName,
	[Parameter(Mandatory=$true)][string] $remoteServerUserName,
    [Parameter(Mandatory=$true)][string] $remoteServerPassword,
    [Parameter(Mandatory=$true)][string] $jenkinsMaster,
	[Parameter(Mandatory=$true)][string] $jenkinsMasterUser,
	[Parameter(Mandatory=$true)][string] $jenkinsMasterPassword
)

$version="3.9"
$pathName="c:\JenkinSlave"
$output = "$pathName\swarm-client-$version.jar"

function downloadSwarmJar($version, $pathName, $output) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	New-Item -Force -Path $pathName -ItemType Directory
	$url = "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$version/swarm-client-$version.jar"
	Invoke-WebRequest -Uri $url -OutFile $output
}
	
function executeCommands($remoteServerIPorName, $remoteServerUserName, $remoteServerPassword, $domainName, $jenkinsMaster, $jenkinsMasterUser, $jenkinsMasterPassword, $version, $pathName, $output) {
	$secpword = ConvertTo-SecureString -String $remoteServerPassword -AsPlainText -Force
	$Credential = New-Object System.Management.Automation.PSCredential ($remoteServerUserName, $secpword)
	$SessionOption = New-PSSessionOption -SkipCACheck
	$s = New-PSSession -ComputerName $remoteServerIPorName -Credential $Credential -Port 5986 -UseSSL -SessionOption $SessionOption
    Invoke-Command -session $s -ScriptBlock ${function:downloadSwarmJar} -ArgumentList $version, $pathName, $output
	Invoke-Command -session $s -ScriptBlock ${function:startSwarmJar} -ArgumentList $jenkinsMaster, $jenkinsMasterUser, $jenkinsMasterPassword, $pathName, $output
}


function startSwarmJar($jenkinsMaster, $jenkinsMasterUser, $jenkinsMasterPassword, $pathName, $output) {
	Start-Process -FilePath java -ArgumentList "-jar $output -master http://$jenkinsMaster -username $jenkinsMasterUser -password $jenkinsMasterPassword -mode normal -name WSRV1 -disableClientsUniqueId -executors 4" -PassThru -RedirectStandardError "$pathName\jslavestderr.txt" 
}

executeCommands "$remoteServerIPorName" "$remoteServerUserName" "$remoteServerPassword" "$domainName" "$jenkinsMaster" "$jenkinsMasterUser" "$jenkinsMasterPassword" "$version" "$pathName" "$output"
