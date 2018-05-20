#$scriptName = split-path -Leaf $MyInvocation.MyCommand.Definition 
#Function Usage()
#{
#   Write-Host "Script requires 2 arguments. Resource group name and location."
#   Write-Host "Usage: .\split-path -Leaf $MyInvocation.MyCommand.Definition resourcegroup location"
#}

#if ($($args.Count) -lt 4)
#{
#    Write-Host "Script requires 3 options with parameters. Otherhise it will quit."
#    exit 100
#}

param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$resgrname,
    [Parameter(Mandatory=$True)]
    [string]$location
)

Function Paramcheck($resgrname, $location)
{
    Write-Host "Resource group name is: $resgrname"
    Write-Host "Location name is: $location"
}

ParamCheck $resgrname $location