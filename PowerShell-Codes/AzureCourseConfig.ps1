configuration AzureCourseConfig
{
    Node WebServer
    {
        WindowsFeature IIS
        {
            Ensure  = 'Present'
            Name = 'Web-Server'
            IncludeAllSubFeature = $true
        }
        Group Developers
        {
            Ensure = 'Present'
            GroupName = 'DevGroup'
        }
        Group Accountants
        {
            Ensure = 'Absent'
            GroupName = 'AcctGroup'
        } 
        File DirectoryCreate
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Users\Public\Documents\MyDemo"
        }
        Log AfterDirectoryCreate
        {
            Message = 'Directory created using DSC'
            DependsOn = '[File]DirectoryCreate'
        }
    }
} 