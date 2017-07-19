﻿Write-Host 'Stopping process...'
Stop-Process -processname keypirinha* -force

$ErrorActionPreference = 'Stop';

$packageName= 'keypirinha'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/Keypirinha/Keypirinha/releases/download/v2.15.3/keypirinha-2.15.3-x86-portable.7z'
$url64      = 'https://github.com/Keypirinha/Keypirinha/releases/download/v2.15.3/keypirinha-2.15.3-x64-portable.7z'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64

  softwareName  = 'keypirinha*'

  checksum      = '85f38e8d5e2b95e7cf7b8611a6ad36552acb4280e8bfde7ead958820a54fd71c'
  checksumType  = 'sha256'
  checksum64    = 'd6541044273036c4d5e4eb4c75ac82bc09dab5684b5287750974c01311e0f30b'
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

if (Get-ProcessorBits 64) {
  Install-ChocolateyZipPackage $packageName $url $toolsDir $url64
} else {
  Install-ChocolateyZipPackage $packageName $url $toolsDir $url
}

$portableDir = "$toolsDir\keypirinha\portable"

if ( $(Try { Test-Path $portableDir } Catch { $false }) ) {
  Write-Host "Deleting `'$portableDir`' so that Keypirinha runs in Install Mode"
  Remove-Item -Recurse -Force $portableDir
}
