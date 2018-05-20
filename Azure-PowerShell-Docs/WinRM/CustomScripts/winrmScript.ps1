Param(
    [string] $fqdn
)

#[array]$extrarray = 0..1
#$psremoteGitUrl = 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/201-vm-winrm-windows/'
#$psremoteConfigFiles = @('makecert.exe', 'ConfigureWinRM.ps1')

#function Get-PsRemoteModule ($arrayname, $psremoteGitUrl, $psremoteConfigFiles) {
#    foreach ( $index in $arrayname ) {
#        Invoke-WebRequest -Uri ("{0}{1}" -f $psremoteGitUrl, $psremoteConfigFiles[$index]) -OutFile ("{0}{1}" -f 'Scripts\', $psremoteConfigFiles[$index])
#    }    
#}

function Enable-WinRm ($fqdn) {
    Push-Location 
    Set-Location C:\Scripts
    .\ConfigureWinRM.ps1 -HostName $fqdn
    Pop-Location    
}

#Get-PsRemoteModule -arrayname $extrarray -psremoteGitUrl $psremoteGitUrl -psremoteConfigFiles $psremoteConfigFiles
Enable-WinRm -fqdn $fqdn