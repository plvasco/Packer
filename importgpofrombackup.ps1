<#
  This script will import all the GPOs from a backup.

  Syntax examples:
    ImportGPOsFromBackup.ps1 -BackupLocation C:\Scripts\GPOs\Backups -MigrationTable AllGPO.migtable -ImportDuplicate False

  It is based on the following script by Microsoft's Manny Murguia:
    - Bulk Import of Group Policy Objects between Different Domains with PowerShell:
      http://blogs.technet.com/b/manny/archive/2012/02/12/bulk-import-of-group-policy-objects-between-different-domains-with-powershell.aspx

  Release 1.1
  Written by Jeremy@jhouseconsulting.com 13th September 2013
  Modified by Jeremy@jhouseconsulting.com 29th January 2014

#>

#-------------------------------------------------------------
param([String]$BackupLocation,[String]$MigrationTable,[String]$ImportDuplicate,[String]$LogFile);

# Get the script path
$ScriptPath = {Split-Path $MyInvocation.ScriptName}

if ([String]::IsNullOrEmpty($BackupLocation))
{
    $BackupLocation = $(&$ScriptPath) + "\GPOs\Backups";
}
$Manifest = $BackupLocation + "\manifest.xml";

if ([String]::IsNullOrEmpty($MigrationTable))
{
    write-host -ForegroundColor Red "MigrationTable switch must be specified";
    write-host -ForegroundColor Red "Exiting Script";
    return;
}
else
{
    $MigrationTable = $(&$ScriptPath) + "\" + $MigrationTable;
}

if ([String]::IsNullOrEmpty($ImportDuplicate)) {
  $ImportDuplicate = "False"
}

if ($ImportDuplicate -eq "False") {
  $ImportDuplicate = [System.Convert]::ToBoolean("$False")
} else {
  $ImportDuplicate = [System.Convert]::ToBoolean("$True")
}

if ([String]::IsNullOrEmpty($LogFile))
{
    $LogFile = $(&$ScriptPath) + "\ImportAllGPOsLog.txt";
}
set-content $LogFile $NULL;

#-------------------------------------------------------------
Write-Host -ForegroundColor Green "Importing the PowerShell modules..."

# Import the Active Directory Module
Import-Module ActiveDirectory -WarningAction SilentlyContinue
if($Error.Count -eq 0) {
   Write-Host "Successfully loaded Active Directory Powershell's module" -ForeGroundColor Green
}else{
   Write-Host "Error while loading Active Directory Powershell's module : $Error" -ForeGroundColor Red
   exit
}

# Import the Group Policy Module
Import-Module GroupPolicy -WarningAction SilentlyContinue
if($Error.Count -eq 0) {
   Write-Host "Successfully loaded Group Policy Powershell's module" -ForeGroundColor Green
}else{
   Write-Host "Error while loading Group Policy Powershell's module : $Error" -ForeGroundColor Red
   exit
}
write-host " "

#-------------------------------------------------------------

[xml]$ManifestData = get-content $Manifest;

foreach ($GPO in $ManifestData.Backups.BackupInst)

{

    $objectExists = get-gpo $GPO.GPODisplayName."#cdata-section" -ea "SilentlyContinue";
    
    if ($ObjectExists -eq $NULL)
    {
        import-gpo -BackupGPOName $GPO.GPODisplayName."#cdata-section" -TargetName $GPO.GPODisplayName."#cdata-section" -CreateIfNeeded -Path $BackupLocation -MigrationTable $MigrationTable | Out-File $LogFile -append;
        write-host -ForeGroundColor Green "Import of GPO" $GPO.GPODisplayName."#cdata-section" "was successful."
    }
    else
    {
      if ($ImportDuplicate -eq $True) {
        $TargetGPOName = "DuplicateGPOonImport - " + $GPO.GPODisplayName."#cdata-section";
        import-gpo -BackupGPOName $GPO.GPODisplayName."#cdata-section" -TargetName $TargetGPOName -CreateIfNeeded -Path $BackupLocation -MigrationTable $MigrationTable | Out-File $LogFile -append;
        write-host -ForeGroundColor Yellow "A GPO named" $GPO.GPODisplayName."#cdata-section" "was to be imported but a duplicate name existed."
        write-host -ForeGroundColor Yellow "A GPO named DuplicateGPOOnImport -" $GPO.GPODisplayName."#cdata-section" "was created instead. Please investigate the neccessity of this GPO."
      }
    }
    
    $ObjectExists = $NULL 

}