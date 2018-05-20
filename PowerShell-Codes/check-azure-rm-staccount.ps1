Function UploadToContainer($arg1, $arg2)
{ 
	#write-host $arg1 $arg2
    $staccname=(Get-AzureRMStorageAccount -ResourceGroup $arg1 -StorageAccountName $arg2).StorageAccountName
	#write-host $staccname
    if ($staccname -eq $arg2)
	{
	    write-host "Entered $arg2 storage name is already exists."
	}
	else 
	{
		write-host "Something to out!"
	}
}


UploadToContainer -Arg1 $($args[0]) -Arg2 $($args[1])
#jsRG uploadedfolder