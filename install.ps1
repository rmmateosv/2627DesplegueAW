$ErrorActionPreference = "Stop"

$LogFile = "C:\Install.log"

function Write-Log {
    param([string]$Message)

    $Fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Fecha  $Message" | Out-File $LogFile -Append -Encoding utf8
}

Write-Log "Inicio del script"

try {
    $Winget = (Get-Command winget.exe -ErrorAction Stop).Source
    Write-Log "Winget encontrado en: $Winget"
}
catch {
    Write-Log "ERROR: winget.exe no encontrado."
    throw
}

function Install-WingetPackage {

    param(
        [Parameter(Mandatory)]
        [string]$Id
    )

    Write-Log "Instalando $Id..."

    & $Winget install `
        --id $Id `
		--source winget `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements
	
	Write-Log "Código de salida: $LASTEXITCODE"

    if ($LASTEXITCODE -ne 0) {
        throw "Error instalando $Id"
    }

    Write-Log "$Id instalado correctamente."
}

Install-WingetPackage "Git.Git"
