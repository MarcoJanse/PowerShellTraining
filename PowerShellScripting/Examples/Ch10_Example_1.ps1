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
    Version 0.1
    Last modified on 10-06-2019
    By Marco Janse

    Version History
    0.1 - paragraph 10.1.1
#>

function Get-MachineInfo {
    Param (
        [string[]]$ComputerName,
        [string]$LogFailurersToPath,
        [string]$Protocol = "wsman",
        [switch]$ProtocolFailBack
    )
}
