$Admin = Read-Host -Prompt "Please enter your admin username"
$mCred = $Cred + "@DOMAIN"
$bCred = "DOM\" + $Cred
$aPassword = Read-Host -Prompt "Please enter your admin password" -AsSecureString
#$encpassword = convertto-securestring $aPassword -asplaintext -force
$Cred2 = new-object system.management.automation.pscredential($Cred,$apassword)
$Cred3 = new-object system.management.automation.pscredential($mCred,$apassword)
$Cred4 = new-object System.Management.Automation.PSCredential($bCred,$apassword)

Connect-ExchangeOnline -ShowBanner:$false -Credential $Cred3 -ShowProgress $true
$file1 = "c:\users\$Admin\desktop\OUPeople.txt"
$file2 = "c:\users\$Admin\desktop\MissingPicture.txt"

#$findBCCHumans = 
Get-AdUser -SearchBase "OU=...,DC=...,DC=...,DC=..." -Filter * -Properties * | Where-Object {$_.employeeID -ne $null} | Select -Property samAccountName -ExpandProperty samAccountName | Out-file $file1

#$missingPicture = 
Get-Mailbox -ResultSize Unlimited | Where {($_.HasPicture -eq $false)} | Select -Property Alias -ExpandProperty Alias | Out-file $file2

#$m = Compare-Object -IncludeEqual -ExcludeDifferent -passthru -ReferenceObject (Get-Content -Path $file1) -DifferenceObject (Get-Content -Path $file2) #| Out-File -FilePath $list3
Compare-Object -IncludeEqual -ExcludeDifferent -passthru -ReferenceObject (Get-Content -Path $file1) -DifferenceObject (Get-Content -Path $file2) | Out-file -FilePath 'c:\users\$Admin\desktop\OU_NoPic.txt'

$file = "c:\users\$Admin\desktop\FINAL_LIST.txt"
$list = gc 'C:\users\$Admin\desktop\OU_NoPic.txt'

forEach ($i in $list) {
function IsEnabled {
param (
        $i
    )
Get-AdUser -identity $i | Select Enabled -ExpandProperty Enabled
}

if (IsEnabled $i = $True){
    Add-Content $file "$i"
    } 
    else{ #if (IsEnabled $i = $False) 
    write-host "User $i is disabled and therefore excluded from output"
}
}