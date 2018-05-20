Function UploadToContainer([string]$arg1, [string]$arg2, [string]$arg3)
{
	$localFileDirectory = $arg1 + "\" + $arg2
	$localFile = $localFileDirectory + "\" + $arg3
	write-host $localFile
}

UploadToContainer -Arg1 $($args[0]) -Arg2 $($args[1]) -Arg3 $($args[2])
