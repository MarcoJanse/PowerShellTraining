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
    Version 1.1
    Last Modified on 08-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:

    1.1 - added parameter attributes and verbose output - lab 8.9.4.
    1.0 - did the lab
#>

function Get-SystemInfo {
    [CmdletBinding()]
    param (
        # Parameter ComputerName
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName
    )

    begin {
    }

    process {
        Write-Verbose "Beginning PROCESS block..."
        foreach ( $Computer in $ComputerName) {

            Write-Verbose "Processing $Computer"
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
            Write-Verbose "Completed $Computer"

        } # foreach Computer

        Write-Verbose "End of PROCESS block..."

    } # process

    end {
    }
}

Get-SystemInfo -ComputerName localhost,localhost -Verbose