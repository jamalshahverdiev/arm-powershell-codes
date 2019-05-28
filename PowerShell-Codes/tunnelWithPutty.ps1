param (
    [Parameter(Mandatory=$true)][string]$SSHserver,
    [string]$username='cloud_user',
    [Parameter(Mandatory=$true)][string]$password = $( Read-Host "Input password, please" )
 )

#variables
$port=5601
$tunnel = '{0}:localhost:{0}' –f $port 
cd 'C:\Program Files\PuTTY'
echo y | .\putty.exe -ssh $username@$SSHserver -pw $password -L $tunnel
