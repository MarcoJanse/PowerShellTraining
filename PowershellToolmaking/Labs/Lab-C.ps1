<#
.SYNOPSIS
    Gets info from running Windows services with process details
.DESCRIPTION
    Get-WindowsServiceProcessDetails will query WMI for running
    Windows services and gets the associated process details

    It uses the CimInstance Cmdlets to query WMI, 
    so it requires at least PowerShell version 3
.PARAMETER ComputerName
    The name of the computer(s) that will be queried.
.PARAMETER ErrorLog
    Used to specify a path to a file to log all errors
    Can be used for computers that cannot be queried
.PARAMETER LogErrors
    A switch parameter that controls if error logging should be enabled
.EXAMPLE
    PS C:\>Get-WindowsServiceProcessDetails -ComputerName server01
    Gets running service and process details of server01

    PS C:\> 'localhost','server02' | Get-WindowsServiceProcessDetails -Verbose
    Uses pipelining to query the local computer and server02 for process details
    and gives verbose output
.NOTES
    PowerShell Toolmaking in a Month of Lunches, 7.9.3. LAB C
    Version 1.3
    Last Modified on 08-07-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.3 - added comment based help and switch parameter
        - chapter 9.4.3.
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
        $ErrorLog = 'C:\ErrorLog.txt',

        # Parameter LogErrors
        [switch] $LogErrors
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