$ErrorActionPreference = "Stop"

$LogFile = "C:\Install.log"
#Start-Sleep 20
$Timeout = 300
$Inicio = Get-Date

#Configurar winget para descargar programas
do {
    $Winget = Get-Command winget.exe -ErrorAction SilentlyContinue

    if ($Winget) {
        break
    }

    Start-Sleep 5

} until ((Get-Date) -gt $Inicio.AddSeconds($Timeout))

if (-not $Winget) {
    throw "Winget no está disponible."
}

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
try {
	Write-Log " Español (España)..."
	$LangList = New-WinUserLanguageList es-ES

	$LangList[0].InputMethodTips.Clear()

	$LangList[0].InputMethodTips.Add("040A:0000040A")

	Set-WinUserLanguageList $LangList -Force
	Set-WinSystemLocale es-ES
	Set-Culture es-ES
	Set-WinUILanguageOverride es-ES

	$LangList = New-WinUserLanguageList es-ES
	$LangList[0].InputMethodTips.Clear()
	$LangList[0].InputMethodTips.Add("040A:0000040A")
	Set-WinUserLanguageList $LangList -Force

	Copy-UserInternationalSettingsToSystem `
		-WelcomeScreen $true `
		-NewUser $true

	Write-Log "Español configurado."
}
catch {
    Write-Log "ERROR: Configurando español"
    throw
}

#función para instalar
function Install-WingetPackage {

    param(
        [Parameter(Mandatory)]
        [string]$Id,

        [string]$Version
    )

    Write-Log "Instalando $Id..."

    $Argumentos = @(
        "install"
        "--id", $Id
        "--source", "winget"
        "--exact"
        "--silent"
        "--accept-package-agreements"
        "--accept-source-agreements"
    )

    if ($Version) {
        $Argumentos += @("--version", $Version)
    }

    & $Winget @Argumentos

    Write-Log "Código de salida: $LASTEXITCODE"

    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERROR instalando $Id"
        return $false
    }
	
    Write-Log "$Id instalado correctamente."
    return $true
}


try{
#Git
Install-WingetPackage "Git.Git"
# Google Chrome
Install-WingetPackage "Google.Chrome"

# WinRAR
Install-WingetPackage "RARLab.WinRAR"

# Notepad++
Install-WingetPackage "Notepad++.Notepad++"

# MySQL Server
Install-WingetPackage "Oracle.MySQL"

# MySQL Workbench
Install-WingetPackage `
    -Id "Oracle.MySQLWorkbench" `
    -Version "8.0.47"

#Eclipse
# Eclipse Enterprise Java and Web Developers
Install-WingetPackage `
    -Id "EclipseFoundation.Eclipse.JEE" `
    -Version "2026-09"
Write-Log "Eclipse instalado."

#Desactivar el AutoLogon
Write-Log "Desactivar el AutoLogon"
$Reg = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

Set-ItemProperty $Reg AutoAdminLogon "0"

Remove-ItemProperty $Reg DefaultPassword -ErrorAction SilentlyContinue
}
catch {

    Write-Log "ERROR: $($_.Exception.Message)"
    throw

}
finally {

    Write-Log "Eliminando tarea programada..."

    try {
        Unregister-ScheduledTask `
            -TaskName "InstallSoftware" `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }
    catch {
        Write-Log "No se pudo eliminar la tarea: $($_.Exception.Message)"
    }
	 # Borrar el script de instalación
    try {
        Remove-Item "C:\Scripts\install.ps1" `
            -Force `
            -ErrorAction SilentlyContinue

        Write-Log "install.ps1 eliminado."
    }
    catch {
        Write-Log "No se pudo eliminar install.ps1: $($_.Exception.Message)"
    }
	Write-Log "Instalación finalizada."

}
# Reiniciar
Write-Log "Reincio de instancia"
Restart-Computer -Force