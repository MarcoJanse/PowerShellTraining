<#
.SYNOPSIS
    Lab 5
.DESCRIPTION
    This script is supposed to create some new PSDrives
    based on environmental variables like %APPDATA% and
    %USERPROFILE%\DOCUMENTS. However, after the script 
    runs the drives don't exist. Why? What changes would you
    make?

    Answer: adding the scope parameter to the Get-ChidItem cmdlets with the 'global' value
        
.EXAMPLE
    PS C:\>
.NOTES
    Version 1.0
    2018-05-20
    Marco Janse

    Version History:
    1.0 - Did the lab
#>

Function New-Drives {

    Param()
    
    New-PSDrive -Name AppData -PSProvider FileSystem -Root $env:Appdata -Scope global
    New-PSDrive -Name Temp -PSProvider FileSystem -Root $env:TEMP -Scope global
    
    $mydocs=Join-Path -Path $env:userprofile -ChildPath Documents
    New-PSDrive -Name Docs -PSProvider FileSystem -Root $mydocs
    
    }
    
    New-Drives
    Get-ChildItem Temp: | Measure-Object -Property length -Sum