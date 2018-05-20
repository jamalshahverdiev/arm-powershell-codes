Login-AzureRmAccount
Get-AzureRmSubscription -SubscriptionId XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

Remove-AzureRmResourceGroup -Name JSRG

$rglist = Get-AzureRmResourceGroup
