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
	& $Code --install-extension rangav.vscode-thunder-client --force

    Write-Log "Extensiones instaladas."
	
	Write-Log "Configurando Visual Studio Code..."

	$SettingsFolder = "C:\Users\Alumno\AppData\Roaming\Code\User"
	$SettingsFile = "$SettingsFolder\settings.json"
	
	New-Item -ItemType Directory -Path $SettingsFolder -Force | Out-Null

@'
{
    "workbench.colorTheme": "Default Light Modern"
}
'@ | Set-Content $SettingsFile -Encoding UTF8

Write-Log "Tema claro configurado."
}
else {

    Write-Log "No se encontró code.cmd"

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
Write-Log "Configurando xdebug..."
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rmmateosv/2627DesplegueAW/refs/heads/master/php_xdebug.dll" -OutFile "C:\xampp\php\ext\php_xdebug.dll"
Write-Log "fin xdebug"

Write-Log "Configurando php.ini..."
(Get-Content $Ini) `
    -replace ';extension=zip','extension=zip' |
Set-Content $Ini
Add-Content $Ini ""

Add-Content $Ini "[Xdebug]"

Add-Content $Ini "zend_extension=xdebug"

Add-Content $Ini "xdebug.mode=debug"

Add-Content $Ini "xdebug.start_with_request=yes"

Write-Log "php.ini actualizado."

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