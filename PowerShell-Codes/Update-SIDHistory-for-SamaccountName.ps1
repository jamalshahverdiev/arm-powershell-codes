Import-Module DSInternals
Stop-Service ntds -Force
$countoflines=(Import-Csv vdi-only-true-with-sid-modified.csv | Measure-Object).Count
$samaccountnames=Import-Csv vdi-only-true-with-sid-modified.csv
0..$countoflines | % { 
    Add-ADDBSidHistory -SamAccountName $samaccountnames.SamAccountName[$] -SidHistory $samaccountnames.SID[$] -DBPath C:\Windows\NTDS\ntds.dit
}
Start-Service ntds