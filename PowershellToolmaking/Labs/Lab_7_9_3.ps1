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
    PowerShell Toolmaking in a Month of Lunches, 7.9.3. LAB C
    Version 0.1
    Last Modified on 24-06-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    Version 0.1 - LAB C, chapter 7.9.3. --IN PROGRESS

#>

function Get-WindowsServiceProcessDetails {
    [CmdletBinding()]
    param (
        # Parameter ComputerName
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName = 'localhost',

        # Parameter ErrorLog
        [string]
        $ErrorLog = 'C:\ErrorLog.txt'
    )

    begin {
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Services = Get-CimInstance -ClassName Win32_Service -ComputerName $Computer -Filter "State='Running'"
            foreach ($Service in $Services) {
                $Process = Get-CimInstance -ClassName Win32_Process -Filter "ProcessID='$Service.ProcessId'"
            } # foreach $Service
            $hash = @{
                'ComputerName' = $Computer;
                'Service Name' = $Service.Name;
                'Process Name' = $Process.Name


            }

        } # foreach $Computer
    }

    end {
    }
}