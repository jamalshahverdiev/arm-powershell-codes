[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$computerName,
	
   [Parameter(Mandatory=$True)]
   [string]$filePath
)

Write-Host Entered Computer name is: $computerName
Write-Host Entered file path is: $filePath