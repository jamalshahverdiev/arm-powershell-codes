### In the Azure Windows virtual machine in the some folder create some script file and add the following content to this file:
```powershell
PS C:\> mkdir DSCtest
PS C:\> cd DSCtest
```

### Look at the script file content. Our configuration function name is "IIScheck". This function takes 3 arguments ($nodeName, $oldSitecore, $newSitecore). At the end of script we need call this function with this arguments.
```powershell
PS C:\DSCtest> cat .\setup.ps1
Configuration IIScheck
{

Param ( [string] $nodeName, 
	[string] $oldSitecore, 
	[string] $newSitecore )

Import-DscResource -ModuleName xWebAdministration
Import-DscResource -ModuleName xPSDesiredStateConfiguration
Import-DscResource -ModuleName PSDesiredStateConfiguration

Node $nodeName
  {
    File stnewWebAppFolder {
        Type = 'Directory'
        DestinationPath = 'C:\inetpub\sitecorenew'
        Ensure = "Present"
    }
    File stoldWebAppFolder {
        Type = 'Directory'
        DestinationPath = 'C:\inetpub\sitecoreold'
        Ensure = "Present"
    }
    xRemoteFile stcoreoldFileDownload {
        Uri = "https://stcoremigst.blob.core.windows.net/sites/$oldSitecore"
        DestinationPath = "C:\inetpub\sitecoreold"
        MatchSource = $true
        DependsOn = "[File]stoldWebAppFolder"
    }
    xRemoteFile stcorenewFileDownload {
        Uri = "https://stcoremigst.blob.core.windows.net/sites/$newSitecore"
        DestinationPath = "C:\inetpub\sitecorenew"
        MatchSource = $true
        DependsOn = "[File]stnewWebAppFolder"
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
    WindowsFeature WebManagementService
    {
      Name = "Web-Mgmt-Service"
      Ensure = "Present"
    }
    WindowsFeature ASPNet45
    {
      Name = "Web-Asp-Net45"
      Ensure = "Present"
    }
    WindowsFeature HTTPRedirection
    {
      Name = "Web-Http-Redirect"
      Ensure = "Present"
    }
    WindowsFeature CustomLogging
    {
      Name = "Web-Custom-Logging"
      Ensure = "Present"
    }
    WindowsFeature LogginTools
    {
      Name = "Web-Log-Libraries"
      Ensure = "Present"
    }
    WindowsFeature RequestMonitor
    {
      Name = "Web-Request-Monitor"
      Ensure = "Present"
    }
    WindowsFeature Tracing
    {
      Name = "Web-Http-Tracing"
      Ensure = "Present"
    }
    WindowsFeature BasicAuthentication
    {
      Name = "Web-Basic-Auth"
      Ensure = "Present"
    }
    WindowsFeature WindowsAuthentication
    {
      Name = "Web-Windows-Auth"
      Ensure = "Present"
    }
    WindowsFeature ApplicationInitialization
    {
      Name = "Web-AppInit"
      Ensure = "Present"
    }
    xWebAppPool stnewWebAppPool 
    { 
        Name            = "stnewwebpool"
        Ensure          = "Present"
        State           = "Started"
    } 
    xWebsite stnewWebSite
    {
        Ensure          = "Present"
        Name            = "Sitecore new Web Site"
        State           = "Started"
        PhysicalPath    = "C:\inetpub\sitecorenew"
        BindingInfo = MSFT_xWebBindingInformation
        {
                Protocol = "http"
                Port = 10080
        }
        DependsOn       = "[xWebAppPool]stnewWebAppPool"
    }
    xWebAppPool stoldWebAppPool 
    { 
        Name            = "stoldwebpool"
        Ensure          = "Present"
        State           = "Started"
    } 
    xWebsite stoldWebSite
    {
        Ensure          = "Present"
        Name            = "Sitecore old Web Site"
        State           = "Started"
        PhysicalPath    = "C:\inetpub\sitecoreold"
        BindingInfo = MSFT_xWebBindingInformation
        {
                Protocol = "http"
                Port = 10081
        }
        DependsOn       = "[xWebAppPool]stoldWebAppPool"
    }
  }
}
IIScheck -nodeName "sitecoreWVM" -oldSitecore "Sitecore.old.8.1rev.160302.zip" -newSitecore "Sitecore.new.8.2rev.170728.zip" 
```

### Then execute this script (It will create new folder with our configuration name "IIScheck" and inside of this folder will create "mof" file with name of VM sitecoreWVM.mof). 
```powershell
PS C:\DSCtest> .\setup.ps1
PS C:\DSCtest> gci .\IIScheck
    Directory: C:\DSCtest\IIScheck
Mode                LastWriteTime         Length Name                                                                                                                  
----                -------------         ------ ----                                                                                                                  
-a----       12/21/2017   3:48 PM          17582 sitecoreWVM.mof
```

### Then call this folder with the following command:
```powershell
PS C:\DSCtest> Start-DscConfiguration -Path .\IIScheck -Force -wait -Verbose
```
