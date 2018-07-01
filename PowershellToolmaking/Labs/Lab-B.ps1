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
    PowerShell Toolmaking in a Month of Lunches, Lab B
    Version 1.2
    Last Modified on 01-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.2 - Lab B expanded, chapter 8.9.2.
    1.1 - Changed the file naming to mention Lab name
    1.0 - Lab B, chapter 7.9.2.

#>

function Get-ComputerDriveInfo {
    [CmdletBinding()]

    param (
        # Parameter ComputerName
        [Parameter(Mandatory = $true,
        ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName = 'LocalHost',

        # Parameter ErrorLog
        [string]$ErrorLog = 'C:\ErrorLog.txt'
    )

    BEGIN {
        Write-Verbose "Beginning BEGIN-block.."
        Write-Verbose "Ending BEGIN-block.."
    }

    PROCESS {
        Write-Verbose "Beginning PROCESS-block.."
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $Computer"
            $Volumes = Get-CimInstance -ClassName Win32_Volume -Filter "DriveType='3'" -ComputerName $Computer
            foreach ($Volume in $Volumes) {
                $hash = @{
                    'ComputerName' = $computer;
                    'Drive'        = $Volume.Caption;
                    'Label'        = $Volume.Label;
                    'Size'         = [math]::Round(($Volume.Capacity / 1GB), 2);
                    'Free Space'   = [math]::Round(($Volume.FreeSpace / 1GB), 2)
                } # $hash
                Write-Verbose "adding custom objects to PSObject for $computer"
                New-Object -TypeName psobject -Property $hash
            } # foreach Volume

            Remove-Variable Volumes

        } # foreach computer

        Write-Verbose "Ending PROCESS-block.."
    } # PROCESS

    END {}
} # Get-ComputerDriveInfo

'localhost','localhost' | Get-ComputerDriveInfo -Verbose