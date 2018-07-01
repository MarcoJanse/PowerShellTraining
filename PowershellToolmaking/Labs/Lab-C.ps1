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
    Version 1.2
    Last Modified on 01-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.2 - Lab A expanded, chapter 8.9.3.
        - Added Verbose output and parameter attributes
    1.1 - Changed the file naming to mention Lab name
    1.0 - Finished LAB C.
    0.1 - LAB C, chapter 7.9.3. --IN PROGRESS

#>

function Get-WindowsServiceProcessDetails {
    [CmdletBinding()]
    param (
        # Parameter ComputerName
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName = 'localhost',

        # Parameter ErrorLog
        [string]
        $ErrorLog = 'C:\ErrorLog.txt'
    )

    begin {
    }

    process {
        Write-Verbose "Beginning PROCESS-block.."
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $Computer.."
            $Services = Get-CimInstance -ComputerName $Computer -ClassName Win32_Service -Filter "State='Running'"

            foreach ($Service in $Services) {
                Write-Verbose "Processing service $service.."
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
    } # process

    end {
    }
} # Get-WindowsServiceProcessDetails

'localhost','localhost' | Get-WindowsServiceProcessDetails -Verbose