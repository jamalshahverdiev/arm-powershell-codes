Configuration Main
{

Param ( [string] $nodeName, 
  [string] $artifact
  )

Import-DscResource -ModuleName xWebAdministration
Import-DscResource -ModuleName xPSDesiredStateConfiguration
Import-DscResource -ModuleName PSDesiredStateConfiguration

Node $nodeName
  {
    File FirstWebAppFolder {
        Type = 'Directory'
        DestinationPath = 'C:\inetpub\site01'
        Ensure = "Present"
    }
    File SecondWebAppFolder {
        Type = 'Directory'
        DestinationPath = 'C:\inetpub\site02'
        Ensure = "Present"
    }
    xRemoteFile ArtifactDownload {
        Uri = "$artifact"
        DestinationPath = "C:\Software\site-artifact.zip"
        MatchSource = $true
    }
    WindowsFeature WebServerRole
    {
      Name = "Web-Server"
      Ensure = "Present"
    }
    xWebsite DefaultSite
    {
        Ensure          = "Present"
        Name            = "Default Web Site"
        State           = "Stopped"
        PhysicalPath    = "C:\inetpub\wwwroot"
        DependsOn       = "[WindowsFeature]WebServerRole"
    }
    WindowsFeature WebManagementConsole
    {
      Name = "Web-Mgmt-Console"
      Ensure = "Present"
    }
    WindowsFeature ASPNet45
    {
      Name = "Web-Asp-Net45"
      Ensure = "Present"
    }
    xWebAppPool firstWebAppPool 
    { 
        Name            = "firstwebpool"
        Ensure          = "Present"
        State           = "Started"
    } 
    xWebsite firstWebSite
    {
        Ensure          = "Present"
        Name            = "First Web Site"
        State           = "Started"
        PhysicalPath    = "C:\inetpub\site01"
        ApplicationPool = "firstwebpool"
        BindingInfo = MSFT_xWebBindingInformation
        {
                Protocol = "http"
                Port = 10080
        }
        DependsOn       = "[xWebAppPool]firstWebAppPool"
    }
    xWebAppPool secondWebAppPool 
    { 
        Name            = "secondwebpool"
        Ensure          = "Present"
        State           = "Started"
    } 
    xWebsite secondWebSite
    {
        Ensure          = "Present"
        Name            = "Second Web Site"
        State           = "Started"
        PhysicalPath    = "C:\inetpub\site02"
        ApplicationPool = "secondwebpool"
        BindingInfo = MSFT_xWebBindingInformation
        {
                Protocol = "http"
                Port = 10081
        }
        DependsOn       = "[xWebAppPool]secondWebAppPool"
    }
  }
}
