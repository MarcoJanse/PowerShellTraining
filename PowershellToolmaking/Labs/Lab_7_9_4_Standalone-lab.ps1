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
    PowerShell Toolmaking in a Month of Lunches, 7.9.4. Standalone lab
    Version 1.0
    Last Modified on 01-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:

    1.0 - did the lab
#>

function Get-SystemInfo {
    [CmdletBinding()]
    param (
        # Parameter ComputerName
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName
    )

    begin {
    }

    process {
        foreach ( $Computer in $ComputerName) {

            $comp = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer
            $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer

            $props = @{
                'Computer name'=$Computer;
                'Model'=$comp.Model;
                'Manufacturer'=$comp.Manufacturer;
                'LastBootTime' = $os.ConverttoDateTime($os.LastBootupTime);
                'OS Version' = $os.Version
            }

            New-Object -TypeName psobject -Property $props

        } # foreach Computer
    }

    end {
    }
}

Get-SystemInfo -ComputerName localhost