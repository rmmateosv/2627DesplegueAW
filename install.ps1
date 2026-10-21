$LogFile = "C:\Install.log"

"Inicio instalación $(Get-Date)" | Out-File $LogFile

"El script funciona correctamente" |
    Out-File C:\Scripts\resultado.txt

"Fin instalación $(Get-Date)" |
    Add-Content $LogFile