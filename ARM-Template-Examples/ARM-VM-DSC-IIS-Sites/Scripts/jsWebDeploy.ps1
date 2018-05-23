Param(
    [string] $firstZipPack,
    [string] $secondZipPack
)

[array]$ziparray = 0..1
$zipFilesPath = @("C:\Software\$firstZipPack", "C:\Software\$secondZipPack")
$pubHtmlFolders = @("C:\inetpub\firstwebapp", "C:\inetpub\secondwebapp")
$extractPaths = @("C:\Software\firstwebapp\", "C:\Software\secondwebapp\")

function Expand-Archives ($arrayname, $zipFiles, $extractedPaths) {
    foreach ( $index in $arrayname ) {
        Expand-Archive -Force -Path $zipFiles[$index] -DestinationPath $extractedPaths[$index] 
    }    
} 

function Copy-ToPubHtml ($arrayname, $extractedPaths, $pubhtmlpaths) {
    foreach ( $index in $arrayname ) {
        Get-ChildItem -Path ("{0}{1}" -f $extractedPaths[$index], "*") -Recurse | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $pubhtmlpaths[$index] -Recurse -Force
        }    
    }    
}

Expand-Archives -arrayname $ziparray -zipFiles $zipFilesPath -extractedPaths $extractPaths 
Copy-ToPubHtml -arrayname $ziparray -extractedPaths $extractPaths -pubhtmlpaths $pubHtmlFolders
