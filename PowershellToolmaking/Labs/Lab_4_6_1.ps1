<#
.SYNOPSIS
    Lab 4.6.1
.DESCRIPTION
    Lab 4.6.1 from Learn powershell Toolmaking
    Simple function to learn to parameterize 
        
.EXAMPLE
    PS C:\>Get-ServiceInfo -ComputerName localhost -StartupType 'manual'
.NOTES
    Version 1.0
    2018-05-06
    Marco Janse

    Version History:
    1.0 - Did the lab
#>

function Get-ServiceInfo {
    param (
        [string[]] $ComputerName = 'localhost',

        [parameter(Mandatory=$true)]
        [ValidateSet("Auto","Manual","Disabled")]
        [string] $StartupType
    )

    Get-CimInstance -ClassName Win32_Service -ComputerName $ComputerName -Filter "StartMode = '$StartupType'"
    
} # Get-ServiceInfo