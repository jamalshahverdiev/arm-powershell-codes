Param(
    [string] $artifact,
    [string] $sqlUrl,
    [string] $sqlDBname,
    [string] $sqlUsername,
    [string] $sqlDBpass
)

$artifact = 'site-artifact.zip'
$publicHtmlFolders = @("C:\inetpub\site01", "C:\inetpub\site02")
$artifactPath = ('{0}\{1}' -f 'C:\Software', "$artifact")
netsh advfirewall firewall add rule "name=Site01 inside" dir=in action=allow protocol=TCP localport=10080
netsh advfirewall firewall add rule "name=Site02 inside" dir=in action=allow protocol=TCP localport=10081


function Set-WebConfig($count) {
    ForEach ($number in 1..$count ) {
        $webConfigFile = "C:\inetpub\site0$number\web.config" 
        (Get-Content $webConfigFile) | Foreach-Object {
            $_ -replace "databaseDomainName", "$sqlUrl" `
               -replace "sqlDatabaseName", "$sqlDBname$number" `
               -replace "databaseUserName", "$sqlUsername" `
               -replace "databasePassword", "$sqlDBpass"
        } | Set-Content $webConfigFile -Force
    }
}

function Expand-Archives ($artifactPath, $publicHtmlFolders) {
    foreach ( $publichtmlpath in $publicHtmlFolders ) {
        Expand-Archive -Force -Path $artifactPath -DestinationPath $publichtmlpath
    }    
} 

Expand-Archives -artifactPath $artifactPath -publicHtmlFolders $publicHtmlFolders 
Set-WebConfig '2'