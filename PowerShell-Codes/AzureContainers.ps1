# Example: .\AzureContainers.ps1 myRG3 westeurope "C:\PowerShell" jsfolder jspshstorage Standard_LRS jsblobs uploadedfolder
# Exit code 99: It means entered argument count is not right
# Exit code 101: It means Entered Resource Group is already exists
# Exit code 77: It means folder to upload to the Azure container is empty.
# Example: $currWD=(Resolve-Path .\).Path
$scriptName = split-path -Leaf $MyInvocation.MyCommand.Definition 

Function Usage() {
    write-host "Script Require 8 arguments."
    write-host "1 - resource group name in the Azure."
    write-host "2 - location name (For example: westeurope)."
	write-host "3 - full directory path from will be uploaded folder to the Azure Container."
	write-host "4 - folder name which will be uploaded to the Azure Container."
	write-host "5 - storage account name"
	write-host "6 - storage account type(For example: Standard_LRS)"
	write-host "7 - container name to create in the Azure."
	write-host "8 - folder name which will be created in the Azure container."
	write-host "Usage: .\$scriptName myRG3 westeurope "C:\PowerShell" jsfolder jspshstorage Standard_LRS jsblobs uploadedfolder"
}

if ($($args.Count) -lt 8){
    write-host "Entered argument count to the function is: $($args.Count)"
    Usage
    exit 99
}

Function UploadToContainer($resgrname, $straccountname, $location, $skuname, $containername, $srcfolder, $srcworkdir, $fromfolder)
{ 
    $staccname=(Get-AzureRMStorageAccount -ResourceGroup $resgrname -StorageAccountName $straccountname).StorageAccountName 2>$null 
    if ($staccname -eq $straccountname)
	{
	    write-host "Entered $straccountname storage name is already exists."
		write-host "Please create new Storage Account. Otherwise, script will not continue!!!"
	}
	else 
	{
        $storageAccount = (New-AzureRmStorageAccount -ResourceGroupName $resgrname -AccountName $straccountname -Location $location -SkuName $skuname -Kind Storage -EnableEncryptionService "Blob,File" -AssignIdentity)
        $ctx = $storageAccount.Context
        $localFileDirectory = $srcworkdir + "\" + $fromfolder
        $localFile = $localFileDirectory + "\" + $srcfolder
        New-AzureStorageContainer -Name $arg5 -Context $ctx -Permission blob
		ls -File -Recurse $localFile | Set-AzureStorageBlobContent -Container $containername -Blob $destfolder -Context $ctx
	}
}

Function CheckFolderEmpty($srcworkdir, $srcfolder, $fromfolder)
{
    if ((Test-Path -Path $srcworkdir\$srcfolder) -eq $true)
    {
        Write-Host "Entered $srcworkdir\$srcfolder folder is exists"
        if((Get-ChildItem -LiteralPath $srcworkdir\$srcfolder\$fromfolder -File -Force | Select-Object -First 1 | Measure-Object).Count -eq 0)
        {
            write-host "But, entered $srcworkdir\$srcfolder folder is empty"
			write-host "We cannot upload empty folder to the Azure Container!!!"
			exit 77
        }
		else
		{
			write-host "Folder is not empty. Please be patient Uploading is started!!!"
		}
    }
}

Function CheckResourceGroup($resgrname, $location) {
    Get-AzureRmResourceGroup -Name $resgrname -ev notPresent -ea 0 2>&1>$null
    if ($notPresent)
    {
        write-host "ResourceGroup $resgrname doesn't exist"
        New-AzureRmResourceGroup -Name $resgrname -Location $location 2>&1>$null
    }
    else
    {
        write-host "ResourceGroup $resgrname is already exist"
        exit 101
    }
}

CheckResourceGroup -Arg1 $($args[0]) -Arg2 $($args[1])
CheckFolderEmpty -Arg1 $($args[2]) -Arg2 $($args[3]) -Arg3 $($args[7])
UploadToContainer -Arg1 $($args[0]) -Arg2 $($args[4]) -Arg3 $($args[1]) -Arg4 $($args[5]) -Arg5 $($args[6]) -Arg6 $($args[7]) -Arg7 $($args[2]) -Arg8 $($args[3])