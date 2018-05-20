if ($($args.Count) -lt 2){
    write-host "Entered argument count to the function is: $($args.Count)"
    write-host "Function usage: $scriptName ResourceGroupName Location"
    exit 99
}


Function CheckArgs([string]$arg1, [string]$arg2) {
#    if ($($args.Count) -lt 2){
#        write-host "Entered argument count to the function is: $($args.Count)"
#        write-host "Function usage: $scriptName ResourceGroupName Location"
#    }
    write-host "$arg1 is ResourceGroupName and $arg2 is Location"
}

CheckArgs -Arg1 $($args[0]) -Arg2 $($args[1])