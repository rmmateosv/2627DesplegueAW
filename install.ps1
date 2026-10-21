$ErrorActionPreference = "Stop"

$LogFile = "C:\Install.log"
#Start-Sleep 20
$Timeout = 300
$Inicio = Get-Date

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
Install-WingetPackage "Oracle.MySQLWorkbench"

# Visual Studio Code
Install-WingetPackage "Microsoft.VisualStudioCode"
Write-Log "Instalando extensiones de Visual Studio Code..."

$Code = "${env:ProgramFiles}\Microsoft VS Code\bin\code.cmd"

if (!(Test-Path $Code)) {
    $Code = "${env:LocalAppData}\Programs\Microsoft VS Code\bin\code.cmd"
}

if (Test-Path $Code) {

    & $Code --install-extension bmewburn.vscode-intelephense-client --force
    & $Code --install-extension phproberto.vscode-php-getters-setters --force
    & $Code --install-extension xdebug.php-debug --force
    & $Code --install-extension onecentlin.laravel5-snippets --force
    & $Code --install-extension onecentlin.laravel-blade --force

    Write-Log "Extensiones instaladas."

}
else {

    Write-Log "No se encontró code.cmd"

}

# XAMPP 8.2
Install-WingetPackage "ApacheFriends.Xampp.8.2"

# Composer
Install-WingetPackage "Composer.Composer"


#Desactivar el AutoLogon
$Reg = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

Set-ItemProperty $Reg AutoAdminLogon "0"

Remove-ItemProperty $Reg DefaultPassword -ErrorAction SilentlyContinue

#Borrar tarea programada
Unregister-ScheduledTask `
    -TaskName "InstalarSoftware" `
    -Confirm:$false
# Reiniciar
#Restart-Computer -Force