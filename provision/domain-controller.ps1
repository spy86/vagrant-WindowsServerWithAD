$domain = 'example.com'
$netbiosDomain = 'EXAMPLE'
$safeModeAdminstratorPassword = ConvertTo-SecureString 'HeyH0Password' -AsPlainText -Force

echo 'Resetting the Administrator account password and settings...'
Set-LocalUser `
    -Name Administrator `
    -AccountNeverExpires `
    -Password $safeModeAdminstratorPassword `
    -PasswordNeverExpires:$true `
    -UserMayChangePassword:$true

echo 'Disabling the Administrator account (we only use the vagrant account)...'
Disable-LocalUser `
    -Name Administrator

echo 'Installing the AD services and administration tools...'
Install-WindowsFeature AD-Domain-Services,RSAT-AD-AdminCenter,RSAT-ADDS-Tools

echo 'Installing the AD forest (be patient, this will take more than 30m to install)...'
Import-Module ADDSDeployment
Install-ADDSForest `
    -InstallDns `
    -CreateDnsDelegation:$false `
    -ForestMode 'Win2012R2' `
    -DomainMode 'Win2012R2' `
    -DomainName $domain `
    -DomainNetbiosName $netbiosDomain `
    -SafeModeAdministratorPassword $safeModeAdminstratorPassword `
    -NoRebootOnCompletion `
    -Force
