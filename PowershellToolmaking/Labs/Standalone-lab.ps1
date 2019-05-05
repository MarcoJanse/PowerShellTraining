<#
.SYNOPSIS
    standalone lab of Learn PowerShell Toolmaking
.DESCRIPTION
    standalone lab of Learn PowerShell Toolmaking in a month
    of lunches

    This script will query system information about a computer using 
    WMI.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.PARAMETER ComputerName
    The name of the computer(s) that will be queried
.PARAMETER ErrorLog
    Used to specify a path to a file to log all errors
    Can be used for computers that cannot be queried
.PARAMETER LogErrors
    A switch parameter that controls if error logging should be enabled
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    PowerShell Toolmaking in a Month of Lunches, 7.9.4. Standalone lab
    Version 1.2
    Last Modified on 05-05-2019
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:

    1.2 - added error handling
        - chapter 10.8.4
    1.1 - added parameter attributes and verbose output - lab 8.9.4.
    1.0 - did the lab
#>

function Get-SystemInfo {
    [CmdletBinding()]
    param (
        # Parameter ComputerName
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $ComputerName,

        # Parameter ErrorLog
        [string] $Errorlog = 'C:\Logfiles\Standalone-lab_erorlog.log',

        # Parameter LogErrors
        [switch] $LogErrors
    )

    begin {
    }

    process {
        Write-Verbose -Message "Beginning PROCESS block..."
        foreach ( $Computer in $ComputerName) {

            Write-Verbose -Message "Processing $Computer"
            try {
                $Everything_OK = $true
                $comp = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop
            } # try
            catch {
                $Everything_OK = $false
                Write-Warning -Message "Custom Warning: $($_.Exception.Message)"
                if ($LogErrors) {
                    Write-Verbose -Message "Removing $ErrorLog to clear old entries..."
                    Remove-Item -Path 'C:\Logfiles\Standalone-lab_erorlog.log' -ErrorAction SilentlyContinue
                    Write-Warning -Message "Failed computers will be logged to $ErrorLog"
                    $Computer | Out-File $Errorlog -Append
                }
            }
            if ($Everything_OK) {
                Write-Verbose -Message "Succesfully queried $Computer, proceding with remaining queries..."
                $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer

                Write-Verbose -Message "preparing properties for hash table"
                $props = @{
                    'Computer name'=$Computer;
                    'Model'=$comp.Model;
                    'Manufacturer'=$comp.Manufacturer;
                    'LastBootTime' = $os.ConverttoDateTime($os.LastBootupTime);
                    'OS Version' = $os.Version
                }

                Write-Verbose -Message "creating custom object..."
                New-Object -TypeName psobject -Property $props
                Write-Verbose -Message "Completed $Computer"
            } # if ($Everything_OK)

        } # foreach Computer

        Write-Verbose "End of PROCESS block..."

    } # process

    end {
    }
}

Get-SystemInfo -ComputerName localhost,NOTONLINE -LogErrors -Verbose