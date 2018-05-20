# Exit code 99: It means entered argument count is not right
# Exit code 101: It means Entered Resource Group is already exists
#$currWD=(Resolve-Path .\).Path
$workDir="C:\PowerShell"

Function Usage() {
    write-host "Script Require 2 arguments."
    write-host "1 - argument parent directory."
    write-host "2 - argument is directory to upload to the Azure Container."
}

if ($($args.Count) -lt 2){
    write-host "Entered argument count to the function is: $($args.Count)"
    write-host "Function usage: $scriptName ResourceGroupName Location"
    exit 99
}

Function CheckResourceGroup([string]$arg1) {
    Get-AzureRmResourceGroup -Name $arg1 -ev notPresent -ea 0 2>&1>$null
    if ($notPresent)
    {
        write-host "ResourceGroup $arg1 doesn't exist"
        New-AzureRmResourceGroup -Name $resourceGroup -Location $location
    }
    else
    {
        write-host "ResourceGroup $arg1 is already exist"
        exit 101
    }
}

#CheckArgs -Arg1 $($args[0]) -Arg2 $($args[1])
CheckResourceGroup -Arg1 $($args[0])


Function CheckFolderEmpty([string]$arg1, [string]$arg2)
{
    if ((Test-Path -Path $arg1\$arg2) -eq "True")
    {
        Write-Host "Entered $arg1\$arg2 folder is exists"
        if((Get-ChildItem -LiteralPath $arg1\$arg2 -File -Force | Select-Object -First 1 | Measure-Object).Count -eq 0)
        {
            write-host "But, entered $arg1\$arg2 folder is empty"
        }
    }
}

CheckFolderEmpty "C:\PowerShell" "jsfolder"

