# install the AD services and administration tools.
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools

$caCommonName = 'Example Enterprise Root CA'

Install-AdcsCertificationAuthority `
    -CAType EnterpriseRootCa `
    -CACommonName $caCommonName `
    -HashAlgorithmName SHA256 `
    -KeyLength 4096 `
    -ValidityPeriodUnits 8 `
    -ValidityPeriod Years `
    -Force

mkdir -Force C:\vagrant\tmp | Out-Null
dir Cert:\LocalMachine\My -DnsName $caCommonName `
    | Export-Certificate -FilePath "C:\vagrant\tmp\$($caCommonName -replace ' ','').der" `
    | Out-Null

(Get-Content c:/vagrant/provision/rdpauth-certificate-template.ldif) `
    -replace 'when(Created|Changed):.+','' `
    -replace 'uSN(Created|Changed):.+','' `
    -replace 'objectGUID:.+','' `
    -notmatch '^$' `
    | Set-Content c:/tmp/rdpauth-certificate-template.ldif

$domainDn = (Get-ADDomain).DistinguishedName
$certificateTemplatesDn = "CN=Certificate Templates,CN=Public Key Services,CN=Services,CN=Configuration,$domainDn"
ldifde -f c:/tmp/machine-certificate-template-sd.ldif -d "CN=Machine,$certificateTemplatesDn" -l nTSecurityDescriptor
Get-Content c:/tmp/machine-certificate-template-sd.ldif `
    | Select -Skip 2 `
    | Add-Content c:/tmp/rdpauth-certificate-template.ldif
ldifde -f c:/tmp/rdpauth-certificate-template.ldif -i


echo 'Adding the Certificate Template to the CA'
while ($true) {
    try {
        Add-CATemplate -Name 'RDPAuth' -Force
        break
    } catch {
    
        Sleep 10
    }
}


Get-GPOReport -All -ReportType Xml -Path c:/tmp/gpo-initial.xml



$gpoName = 'Default Domain Policy'

Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
    -ValueName 'CertTemplateName' `
    -Type 'String' `
    -Value 'RDPAuth' `
    | Out-Null

Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
    -ValueName 'SecurityLayer' `
    -Type 'DWORD' `
    -Value 2 `
    | Out-Null

Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
    -ValueName 'AuthenticationLevel' `
    -Type 'DWORD' `
    -Value 2 `
    | Out-Null

Set-GPRegistryValue `
    -Name $gpoName `
    -Key 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
    -ValueName 'fDenyTSConnections' `
    -Type 'DWORD' `
    -Value 0 `
    | Out-Null

Get-GPOReport -All -ReportType Xml -Path c:/tmp/gpo-final.xml