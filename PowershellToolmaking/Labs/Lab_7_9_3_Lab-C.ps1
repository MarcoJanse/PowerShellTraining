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
    Version 1.0
    Last Modified on 01-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.1 - Changed the file naming to mention Lab name
    1.0 - Finished LAB C.
    0.1 - LAB C, chapter 7.9.3. --IN PROGRESS

#>

function Get-WindowsServiceProcessDetails {
    [CmdletBinding()]
    param (
        # Parameter ComputerName
        [Parameter(Mandatory=$true)]
        [string[]]
        $ComputerName = 'localhost',

        # Parameter ErrorLog
        [string]
        $ErrorLog = 'C:\ErrorLog.txt'
    )

    begin {
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Services = Get-CimInstance -ComputerName $Computer -ClassName Win32_Service -Filter "State='Running'"

            foreach ($Service in $Services) {
                $Process = Get-CimInstance -ComputerName $Computer -ClassName Win32_Process | Where-Object { $_.ProcessID -eq $service.ProcessId }

                $hash = @{
                    'ComputerName' = $Computer;
                    'Displayname' = $Service.DisplayName;
                    'Service Name' = $Service.Name;
                    'Process Name' = $Process.Name;
                    'Process ID' = $process.ProcessId;
                    'VM Size' = $Process.VirtualSize;
                    'Peak Page File' = $Process.PeakPageFileUsage;
                    'Thread Count' = $Process.ThreadCount
                } # $hash

                New-Object -TypeName psobject -Property $hash

            } # foreach $Service

        } # foreach $Computer
    }

    end {
    }
}

Get-WindowsServiceProcessDetails -ComputerName 'localhost'