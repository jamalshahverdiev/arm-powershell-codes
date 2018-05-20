Configuration Main
{

Param ( [string] $nodeName, 
        [string] $winrmScriptUrl,
        [string] $makeCertExeUrl
)

Import-DscResource -ModuleName xPSDesiredStateConfiguration
Import-DscResource -ModuleName PSDesiredStateConfiguration

Node $nodeName
  {
    File CreateScriptsFolder {
          Type = 'Directory'
          DestinationPath = 'C:\Scripts'
          Ensure = "Present"
    }
    xRemoteFile loadwinRMScript {
          Uri = "$winrmScriptUrl"
          DestinationPath = "C:\Scripts\ConfigureWinRM.ps1"
          MatchSource = $true
    }
    xRemoteFile loadExeFile {
        Uri = "$makeCertExeUrl"
        DestinationPath = "C:\Scripts\makecert.exe"
        MatchSource = $true
    }
  }
}