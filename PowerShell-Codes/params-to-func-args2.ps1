param(
    [Parameter(Mandatory=$True)]
    [string]$resgrname,
    [Parameter(Mandatory=$True)]
    [string]$location,
    [Parameter(Mandatory=$True)]
    [string]$straccountname
)

Function Paramcheck($resgrname, $location, $straccountname)
{
    Write-Host "Resource group name is: $resgrname"
    Write-Host "Location name is: $location"
    Write-Host "Location name is: $straccountname"
}

ParamCheck $resgrname $location $straccountname