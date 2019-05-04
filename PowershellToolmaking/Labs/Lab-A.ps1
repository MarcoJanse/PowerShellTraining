<#
.SYNOPSIS
    Gets details about computers using WMI
.DESCRIPTION
    Get ComputerDetails will query one or more computers
    using WMI and list details like serialnumber, model
    and OS version.

    The script uses the CIM Cmdlets to query remote
    computers using PowerShell Remoting
.PARAMETER ComputerName
    The name of the computer(s) that will be queried.
.PARAMETER ErrorLog
    Used to specify a path to a file to log all errors
    Can be used for computers that cannot be queried
.PARAMETER LogErrors
    A switch parameter that controls if error logging should be enabled
.EXAMPLE
    PS C:\> Get-ComputerInfo -ComputerName localhost,server02 -Verbose
    Gets the Computer Info from localhost and server02 with verbose output
.NOTES
    PowerShell Toolmaking in a Month of Lunches, Lab A
    Version 1.5
    Last Modified on 04-05-2019
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    1.5 - added errorhandling
        - chapter 10.8.1
    1.4 - added comment based help and switch parameter
        - chapter 9.4.1.
        - also renamed function as there was already a
        - Cmdlet called Get-ComputerInfo
    1.3 - Lab A expanded, chapter 8.9.1.
          Added Verbose output and parameter attributes
    1.2 - Changed the file naming to mention Lab name
    1.1 - Changed Error log to default location
    1.0 - Lab A, chapter 7.9.1.

#>

function Get-ComputerDetails {
    [CmdletBinding()]
    param(
        # Parameter ComputerName
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $ComputerName='localhost',

        # Parameter ErrorLog
        [string] $ErrorLog='C:\Logfiles\Lab-A_ErrorLog.log',

        # Parameter LogErrors
        [switch] $LogErrors
    )

    BEGIN {
        Write-Verbose "Running BEGIN-block.."
        Write-Verbose "Ending BEGIN-block.."
    }

    PROCESS {
        Write-Verbose "Beginning PROCESS-block.."

        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $computer"
            Write-Verbose "Quering WMI using CIM cmdlets..."
            try {
                $Everything_Ok = $true
                $comp = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $Computer -ErrorAction stop
            } # try
            catch {
                $Everything_Ok = $false
                Write-Warning "Custom warning: $($_.Exception.Message)"
                if ($LogErrors) {
                    $Computer | Out-File $ErrorLog -Append
                } # if $LogErrors
            } # catch
            if ($Everything_Ok) {
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
            } #if $Everything_Ok

        } # for each Computer

        Write-Verbose "Ending PROCESS-block..."
    } # PROCESS

    END {}

} # Get-ComputerDetails

Get-ComputerDetails -ComputerName NOTONLINE,localhost -LogErrors -Verbose