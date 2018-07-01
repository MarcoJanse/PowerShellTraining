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
    PowerShell Toolmaking in a Month of Lunches, Lab A
    Version 1.3
    Last Modified on 01-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.3 - Lab A expanded, chapter 8.9.1.
          Added Verbose output and parameter attributes
    1.2 - Changed the file naming to mention Lab name
    1.1 - Changed Error log to default location
    1.0 - Lab A, chapter 7.9.1.

#>

function Get-ComputerInfo {
    [CmdletBinding()]
    param(
        # Parameter ComputerName
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $ComputerName='localhost',

        # Parameter ErrorLog
        [string] $ErrorLog='C:\ErrorLog.txt'
    )

    BEGIN {
        Write-Verbose "Running BEGIN-block.."
        Write-Verbose "Ending BEGIN-block.."
    }

    PROCESS {
        Write-Verbose "Beginning PROCESS-block.."

        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $computer"
            Write-Verbose 'Quering WMI using CIM cmdlets...'
            $comp = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $Computer
            $bios = Get-CimInstance -ClassName Win32_BIOS -ComputerName $Computer
            $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Computer

            $props = @{
                'Workgroup'=$comp.Workgroup;
                'AdminPassword'= switch ($comp.AdminPasswordStatus){
                        0 {"Disabled"}
                        1 {"Enabled"}
                        2 {"Not Implemented"}
                        3 {"Unknown"}
                    };
                'Model'=$comp.Model;
                'Manufacturer'=$comp.Manufacturer;
                'SerialNumber'=$bios.SerialNumber;
                'Version'=$os.Version;
                'ServicePackMajorVersion'=$os.ServicePackMajorVersion
            } # props

            Write-Verbose "adding custom objects to PSObject for $Computer"
            $obj = New-Object -TypeName psobject -Property $props
            Write-Output $obj

        } # for each Computer

        Write-Verbose "Ending PROCESS-block..."
    } # PROCESS

    END {}

} # Get-ComputerInfo

'localhost','maja-lpt-01' | Get-ComputerInfo -Verbose