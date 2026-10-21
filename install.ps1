$ErrorActionPreference = "Stop"

$LogFile = "C:\Install.log"

$Winget = (Get-Command winget.exe).Source

if (-not $Winget) {
    throw "No se ha encontrado winget.exe"
}

function Write-Log {
    param([string]$Message)

    $Fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    "$Fecha  $Message" | Out-File $LogFile -Append -Encoding utf8

    Write-Host $Message
}
function Install-WingetPackage {

    param(
        [Parameter(Mandatory)]
        [string]$Id
    )

    Write-Log "Instalando $Id..."

    & $Winget install `
        --id $Id `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        throw "Error instalando $Id"
    }

    Write-Log "$Id instalado correctamente."
}

Install-WingetPackage "Git.Git"
Install-WingetPackage "Google.Chrome"
Install-WingetPackage "Notepad++.Notepad++"