$ErrorActionPreference = 'Stop'

$packageName = 'keypirinha'
$packageVersion = '2.15.4'
$targetVersion = '2.15.4'

$url32 = "https://github.com/Keypirinha/Keypirinha/releases/download/v$targetVersion/keypirinha-$targetVersion-x86-portable.7z"
$url64 = "https://github.com/Keypirinha/Keypirinha/releases/download/v$targetVersion/keypirinha-$targetVersion-x64-portable.7z"

$checksum32 = 'eaa111e03b6704345839ca07fd8a36c4531cdf5586190f586fa6fc6810b8d64c'
$checksum64 = 'b5ff35bc4cfc7d4b97b01359290970803fe9ffd6f7906598b2082d391c5df5d0'
$checksumType = 'sha256'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "$toolsDir\keypirinha"
$portableDir = "$toolsDir\keypirinha\portable"

Write-Host 'Stopping Keypirinha...'
Stop-Process -processname keypirinha* -force

# Manually remove shims erroneously created by previous versions of the
# Chocolatey package (2.15.3 and previous).
# We specify their -Path to ensure only Keypirinha's shims are removed.
Uninstall-BinFile -Name "keypirinha-x86" `
                  -Path "$installDir\bin\x86\keypirinha-x86.exe"
Uninstall-BinFile -Name "keypirinha-x64" `
                  -Path "$installDir\bin\x64\keypirinha-x64.exe"
Uninstall-BinFile -Name "Notepad2" `
                  -Path "$installDir\bin\x86\bin\notepad2\Notepad2.exe"
Uninstall-BinFile -Name "Notepad2" `
                  -Path "$installDir\bin\x64\bin\notepad2\Notepad2.exe"

# Note: a "Get-ProcessorBits 64" test would be redundant here since
# Install-ChocolateyZipPackage apparently takes care of choosing the appropriate
# URL
Install-ChocolateyZipPackage -PackageName $packageName `
                             -Url $url32 `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit $url64 `
                             -Checksum $checksum32 `
                             -ChecksumType $checksumType `
                             -Checksum64 $checksum64 `
                             -Checksum64Type $checksumType

# Generate an "*.ignore" file for every executable except keypirinha.exe, so
# Chocolatey creates only one shim for Keypirinha (i.e. "keypirinha.exe" at the
# root of $installDir).
$files = Get-ChildItem $installDir -include *.exe -recurse
foreach ($file in $files) {
  if (!($file.Name.Contains('keypirinha.exe'))) {
    New-Item "$file.ignore" -type file -force | Out-Null
  }
}

# Generate a "keypirinha.exe.gui" file to ensure Chocolatey does not run
# Keypirinha in console mode.
# Note: it did not seem to be necessary during tests...
New-Item "$installDir\keypirinha.exe.gui" -type file -force | Out-Null

# Keypirinha specific: delete the "portable" directory to enable "Install Mode"
if ( $(Try { Test-Path $portableDir } Catch { $false }) ) {
  Write-Host "Deleting `'$portableDir`' so that Keypirinha runs in Install Mode"
  Remove-Item -Recurse -Force $portableDir
}
