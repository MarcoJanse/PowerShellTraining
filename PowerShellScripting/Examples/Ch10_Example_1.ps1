<#
.SYNOPSIS
    Get-MachineInfo function example
.DESCRIPTION
    Get-MachineInfo is an example function in chapter 10
    of Learn PowerShell Scripting in a Month of Lunches
.EXAMPLE
    Get-MachineInfo -ComputerName Localhost
.PARAMETER ComputerName
    Enter one or more computernames, seperated by commas
.PARAMETER LogFailuresToPath
    Can be used to specify a path to a logfile to log all 
    failed computer queries
.PARAMETER Protocol
    Can be used to switch between WSMAN (default) or DCOM
    for older Operating Systems
.PARAMETER ProtocolFailback
.NOTES
    Version 0.4
    Last modified on 11-06-2019
    By Marco Janse

    Version History
    0.4 - listing 10.2 - adding output
    0.3 - listing 10.1 --completed--
    0.2 - listing 10.1 - basic functional code --NOT FINISHED--
    0.1 - paragraph 10.1.1
#>

function Get-MachineInfo {
    Param (
        [string[]]$ComputerName,
        [string]$LogFailurersToPath,
        [string]$Protocol = "wsman",
        [switch]$ProtocolFailBack
    )

    foreach ($Computer in $ComputerName) {

        # Establish session protocol
        if ($Protocol -eq 'Dcom') {
            $option = New-CimSessionOption -Protocol Dcom
        }
        else {
            $option = New-CimSessionOption -Protocol Wsman
        }

        # Connect session
        $Session = New-CimSession -ComputerName $Computer -SessionOption $option

        # Query data
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -CimSession $Session

        # Close session
        $Session | Remove-CimSession

        # Output data
        $os | Select-Object -Property @{
                n='ComputerName' ;e={$Computer}},
                Version,
                ServicePackMajorVersion

    } # for each Computer
 
} # Get-MachineInfo
