# Wait until we can access the AD. this is needed to prevent errors like:
while ($true) {
    try {
        Get-ADDomain | Out-Null
        break
    } catch {
        Start-Sleep -Seconds 10
    }
}


$adDomain = Get-ADDomain
$domain = $adDomain.DNSRoot
$domainDn = $adDomain.DistinguishedName
$usersAdPath = "CN=Users,$domainDn"
$password = ConvertTo-SecureString -AsPlainText 'HeyH0Password' -Force

Add-ADGroupMember `
    -Identity 'Enterprise Admins' `
    -Members "CN=vagrant,$usersAdPath"

$enabledAccounts = @(

    'vagrant',
    'Administrator'
)
Get-ADUser -Filter {Enabled -eq $true} `
    | Where-Object {$enabledAccounts -notcontains $_.Name} `
    | Disable-ADAccount

Set-ADAccountPassword `
    -Identity "CN=Administrator,$usersAdPath" `
    -Reset `
    -NewPassword $password
Set-ADUser `
    -Identity "CN=Administrator,$usersAdPath" `
    -PasswordNeverExpires $true



$name = 'tom.bereen'
New-ADUser `
    -Path $usersAdPath `
    -Name $name `
    -UserPrincipalName "$name@$domain" `
    -EmailAddress "$name@$domain" `
    -GivenName 'Tom' `
    -Surname 'Bereen' `
    -DisplayName 'Tom Bereen' `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true
# we can also set properties.
Set-ADUser `
    -Identity "CN=$name,$usersAdPath" `
    -HomePage "https://$domain/~$name"
# add user to the Domain Admins group.
Add-ADGroupMember `
    -Identity 'Domain Admins' `
    -Members "CN=$name,$usersAdPath"


# add kate Bereen.
$name = 'kate.Bereen'
New-ADUser `
    -Path $usersAdPath `
    -Name $name `
    -UserPrincipalName "$name@$domain" `
    -EmailAddress "$name@$domain" `
    -GivenName 'kate' `
    -Surname 'Bereen' `
    -DisplayName 'kate Bereen' `
    -AccountPassword $password `
    -Enabled $true `
    -PasswordNeverExpires $true


echo 'tom.bereen Group Membership'
Get-ADPrincipalGroupMembership -Identity 'tom.bereen' `
    | Select-Object Name,DistinguishedName,SID `
    | Format-Table -AutoSize | Out-String -Width 2000

echo 'kate.Bereen Group Membership'
Get-ADPrincipalGroupMembership -Identity 'kate.Bereen' `
    | Select-Object Name,DistinguishedName,SID `
    | Format-Table -AutoSize | Out-String -Width 2000

echo 'vagrant Group Membership'
Get-ADPrincipalGroupMembership -Identity 'vagrant' `
    | Select-Object Name,DistinguishedName,SID `
    | Format-Table -AutoSize | Out-String -Width 2000


echo 'Enterprise Administrators'
Get-ADGroupMember `
    -Identity 'Enterprise Admins' `
    | Select-Object Name,DistinguishedName,SID `
    | Format-Table -AutoSize | Out-String -Width 2000

echo 'Domain Administrators'
Get-ADGroupMember `
    -Identity 'Domain Admins' `
    | Select-Object Name,DistinguishedName,SID `
    | Format-Table -AutoSize | Out-String -Width 2000


echo 'Enabled Domain User Accounts'
Get-ADUser -Filter {Enabled -eq $true} `
    | Select-Object Name,DistinguishedName,SID `
    | Format-Table -AutoSize | Out-String -Width 2000
