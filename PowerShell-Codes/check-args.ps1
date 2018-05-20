if ($($args.Count) -lt 2)
{
    write-host "Entered argument count to the function is: $($args.Count)"
    exit 99
}

Function Test($arg1, $arg2)
{
    Write-Host "`$arg1 value: $arg1"
    Write-Host "`$arg2 value: $arg2"
}

Test -Arg1 $($args[0]) -Arg2 $($args[1])