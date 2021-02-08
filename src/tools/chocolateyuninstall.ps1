$ErrorActionPreference = 'Stop'

Remove-Item -Path "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Keypirinha.lnk"
