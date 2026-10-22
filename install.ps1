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

# XAMPP 8.2
Install-WingetPackage "ApacheFriends.Xampp.8.2"

$phpPath = "C:\xampp\php"

$env:Path += ";$phpPath"

[Environment]::SetEnvironmentVariable(
    "Path",
    $env:Path,
    "Machine"
)
#Composer
Write-Log "Instalando Composer..."
New-Item `
    -ItemType Directory `
    -Path "C:\Temp" `
    -Force | Out-Null
	
Write-Log "Instalando Composer..."

New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null
# Composer
Write-Log "Creando carpeta de Composer..."

New-Item `
    -ItemType Directory `
    -Path "C:\Composer" `
    -Force | Out-Null
	
Write-Log "Descargando Composer..."

Invoke-WebRequest `
    -Uri "https://getcomposer.org/download/latest-stable/composer.phar" `
    -OutFile "C:\Composer\composer.phar"

Write-Log "Composer descargado."

Write-Log "Creando composer.bat..."
@'
@echo off
"C:\xampp\php\php.exe" "C:\Composer\composer.phar" %*
'@ | Set-Content "C:\Composer\composer.bat" -Encoding ASCII

Write-Log "Añadiendo Composer al PATH..."

$Path = [Environment]::GetEnvironmentVariable("Path","Machine")

if ($Path -notmatch "C:\\Composer") {

    [Environment]::SetEnvironmentVariable(
        "Path",
        "$Path;C:\Composer",
        "Machine"
    )

}
$env:Path += ";C:\Composer"
Write-Log "Comprobando Composer..."
composer --version | Out-File $LogFile -Append
Set-Alias composer "C:\Composer\composer.bat"


#xdebug
$XdebugZip = "C:\Temp\xdebug.zip"
$XdebugDir = "C:\Temp\xdebug"

New-Item -ItemType Directory -Force -Path "C:\Temp" | Out-Null

Invoke-WebRequest `
    -Uri "https://xdebug.org/files/php_xdebug-3.3.2-8.2-ts-vs16-x86_64.zip" `
    -OutFile $XdebugZip

Expand-Archive `
    -Path $XdebugZip `
    -DestinationPath $XdebugDir `
    -Force

Copy-Item `
    "$XdebugDir\php_xdebug.dll" `
    "C:\xampp\php\ext\" `
    -Force

Write-Log "Xdebug copiado."
$Ini = "C:\xampp\php\php.ini"

Write-Log "Configurando php.ini..."
(Get-Content $Ini) `
    -replace ';extension=zip','extension=zip' |
Set-Content $Ini
Add-Content $Ini ""

Add-Content $Ini "; Xdebug"

Add-Content $Ini "zend_extension=C:\xampp\php\ext\php_xdebug.dll"

Add-Content $Ini "xdebug.mode=debug"

Add-Content $Ini "xdebug.start_with_request=yes"

Add-Content $Ini "xdebug.client_port=9003"

Add-Content $Ini "xdebug.client_host=127.0.0.1"

Write-Log "php.ini actualizado."

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