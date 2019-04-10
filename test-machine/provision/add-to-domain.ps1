$ErrorActionPreference = 'Stop'

$domain = 'example.com'
$domainControllerIp = '192.168.56.2'

Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $domainControllerIp

Add-Computer `
    -DomainName $domain `
    -Credential (New-Object `
                    System.Management.Automation.PSCredential(
                        "vagrant@$domain",
                        (ConvertTo-SecureString "vagrant" -AsPlainText -Force)))
