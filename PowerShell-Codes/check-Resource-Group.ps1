# Exit code 99: It means entered argument count is not right
# Exit code 101: It means Entered Resource Group is already exists

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
