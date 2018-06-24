<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    PowerShell Toolmaking in a Month of Lunches, 7.9.2. LAB B
    Version 1.0
    Last Modified on 24-06-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    Version 1.0 - LAB B, chapter 7.9.2.

#>

function Get-ComputerDriveInfo {
    [CmdletBinding()]

    param (
        # Parameter ComputerName
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName = 'LocalHost',

        # Parameter ErrorLog
        [string]$ErrorLog = 'C:\ErrorLog.txt'
    )

    BEGIN {}

    PROCESS {
        foreach ($Computer in $ComputerName) {
            $Volumes = Get-CimInstance -ClassName Win32_Volume -Filter "DriveType='3'" -ComputerName $Computer
            foreach ($Volume in $Volumes) {
                $hash = @{
                    'ComputerName' = $computer;
                    'Drive'        = $Volume.Caption;
                    'Label'        = $Volume.Label;
                    'Size'         = [math]::Round(($Volume.Capacity / 1GB), 2);
                    'Free Space'   = [math]::Round(($Volume.FreeSpace / 1GB), 2)
                } # $hash
                New-Object -TypeName psobject -Property $hash
            } # foreach Volume

            Remove-Variable Volumes

        } # foreach computer

    } # PROCESS

    END {}
} # Get-ComputerDriveInfo

Get-ComputerDriveInfo -ComputerName localhost,localhost