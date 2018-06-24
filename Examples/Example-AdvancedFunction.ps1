<#
.SYNOPSIS
    Example-AdvancedFunction.ps1
.DESCRIPTION
    This is an example of an advanced function as listed in the
    PowerShell Toolmaking in a month of lunches book, by Don Jones
    and Jeffrey Hicks.

    It get's expanded with every chapter
.EXAMPLE
    Get-SystemInfo -ComputerName Localhost -Errorlog 'C:\Errorlog.txt'
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    Version 1.1
    2018-06-24
    Designed by Don Jones and Jeffrey Hicks
    Written by Marco Janse

    Version History:
    1.1 - Chapter 7, listing 7.8: remove Write-Object in BEGIN block
    1.0 - Chapter 7, listing 7.7
#>

function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [string[]]$ComputerName,

        [string]$ErrorLog
    )
    BEGIN {}

    PROCESS {
        foreach ($Computer in $ComputerName) {
            $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer
            $comp = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer
            $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $Computer

            $props = @{
                'ComputerName'=$Computer;
                'OSVersion'=$os.version;
                'SPVersion'=$os.ServicePackMajorVersion;
                'BIOSSerial'=$bios.serialnumber;
                'Manufacturer'=$comp.Manufacturer;
                'Model'=$comp.Model
            }
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }

    } # PROCESS

    END {}

} # Get-SystemInfo