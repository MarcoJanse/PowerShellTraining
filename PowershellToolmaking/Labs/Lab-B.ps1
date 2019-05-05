<#
.SYNOPSIS
    Gets information of fixed logical drives
.DESCRIPTION
    Get-ComputerDriveInfo gets logical drive information from
    one or more specified computers using WMI

    It used the CIM Cmdlets to use WS-Management protocol for
    querying remote computers
.PARAMETER ComputerName
    The name of the computer(s) that will be queried.
.PARAMETER ErrorLog
    Used to specify a path to a file to log all errors
    Can be used for computers that cannot be queried
.PARAMETER LogErrors
    A switch parameter that controls if error logging should be enabled
.EXAMPLE
    PS C:\> Get-ComputerDriveInfo -ComputerName localhost,server02
    Gets the logical drive information of localhost and server02

    PS C:\> 'localhost','server02' | Get-ComputerDriveInfo -Verbose
    Uses Pipelining to query localhost and server02 for logical drive info
    with Verbose output
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    PowerShell Toolmaking in a Month of Lunches, Lab B
    Version 1.4
    Last Modified on 05-05-2019
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.4 - added error handling
        - chapter 10.8.2.
    1.3 - added comment based help and switch parameter
        - chapter 9.4.2.
    1.2 - Lab B expanded, chapter 8.9.2.
        - Added Verbose output and parameter attributes
    1.1 - Changed the file naming to mention Lab name
    1.0 - Lab B, chapter 7.9.2.

#>

function Get-ComputerDriveInfo {
    [CmdletBinding()]

    param (
        # Parameter ComputerName
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName = 'LocalHost',

        # Parameter ErrorLog
        [string]$ErrorLog = 'C:\Logfiles\Lab-B_ErrorLog.log',

        # Parameter LogErrors
        [switch] $LogErrors
    )

    BEGIN {
        Write-Verbose "Beginning BEGIN-block.."
        Write-Verbose "Ending BEGIN-block.."
    }

    PROCESS {
        Write-Verbose "Beginning PROCESS-block.."
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $Computer"
            try {
                $Everything_OK = $true
                $Volumes = Get-CimInstance -ClassName Win32_Volume -Filter "DriveType='3'" -ComputerName $Computer -ErrorAction Stop
            } # try
            catch {
                $Everything_OK = $false
                Write-Warning "Custom Warning: $($_.Exception.Message)"
                if ($LogErrors) {
                    $Computer | Out-File $ErrorLog -Append
                } # if ($LogErrors)
            } # catch
            if ($Everything_OK) {
                Write-Verbose "Successfully contacted $Computer, querying Volumes..."    
                foreach ($Volume in $Volumes) {
                    Write-Verbose "Processing volume $Volume"
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
            } # if ($Everything_OK)

        } # foreach computer

        Write-Verbose "Ending PROCESS-block.."
    } # PROCESS

    END { }
} # Get-ComputerDriveInfo

Get-ComputerDriveInfo -ComputerName localhost, NOTONLINE -LogErrors