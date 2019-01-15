
$Username = "Admin123"
$Password = "Smooch1991"

$group = "Administrators"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE





# New-LocalUser -Name "Admin123" -Description "Aws admin" -NoPassword

# Set-ExecutionPolicy RemoteSigned

# Set-PSRepository -name "PSGallery" -InstallationPolicy Trusted

# Set-PSRepository -name "PSGallery" -SourceLocation 'https://www.powershellgallery.com/api/v2'

# Install-Module PSWindowsUpdate  

# Get-Command –module PSWindowsUpdate
# Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d

# Get-WUInstall –MicrosoftUpdate

# Get-WUInstall –MicrosoftUpdate –AcceptAll –AutoReboot


# wget "https://s3-us-west-2.amazonaws.com/mrssoftware/StudioCOM_3_8_0_4.exe" -outfile "c:\StudioCOM_3_8_0_4.exe"
# wget "https://s3-us-west-2.amazonaws.com/mrssoftware/KcsSetup.exe" -outfile "c:\KcsSetup.exe"


