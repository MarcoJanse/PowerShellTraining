<#
.SYNOPSIS
    Get-MachineInfo function example
.DESCRIPTION
    Get-MachineInfo is an example function in the
    Learn PowerShell Scripting in a Month of Lunches book

    During the chapters in the book, it gets expanded from
    a simple function to an advanced function
.EXAMPLE
    Get-MachineInfo -ComputerName Localhost
.PARAMETER ComputerName
    Enter one or more computernames, seperated by commas
.PARAMETER LogFailuresToPath
    Can be used to specify a path to a logfile to log all 
    failed computer queries
.PARAMETER Protocol
    Can be used to switch between WSMAN (default) or DCOM
    for older Operating Systems
.PARAMETER ProtocolFailback
.NOTES
    Version 1.0
    Last modified on 25-06-2019
    By Marco Janse

    Version History
    1.0 - fixed version. Brain was overheated yesterday...
    0.6 - renamed to Get-MachineInfo, now with parameter splatting
        - listing 12.1.
        - --IN PROGRESS--NOT WORKING YET--
    0.5 - listing 11.1.4 - advanced function with parameter validation
    0.4 - listing 10.2 - adding output
    0.3 - listing 10.1 --completed--
    0.2 - listing 10.1 - basic functional code --NOT FINISHED--
    0.1 - paragraph 10.1.1
#>

function Get-MachineInfo {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true,
                   Mandatory=$true)]
        [Alias('CN','MachineName','Name')]
        [string[]]$ComputerName,

        [string]$LogFailurersToPath,

        [ValidateSet('Wsman','Dcom')]
        [string]$Protocol = "Wsman",

        [switch]$ProtocolFallBack
    )

    BEGIN {}
    
    PROCESS {

        foreach ($Computer in $ComputerName) {

            # Establish session protocol
            if ($Protocol -eq 'Dcom') {
                $option = New-CimSessionOption -Protocol Dcom
            }
            else {
                $option = New-CimSessionOption -Protocol Wsman
            }

            # Connect session
            $Session = New-CimSession -ComputerName $Computer -SessionOption $option

            # Query data
            $os_params = @{
                            'ClassName'='Win32_OperatingSystem';
                            'CimSession'=$Session
                          }
            $os = Get-CimInstance @os_params

            $cs_params = @{
                            'ClassName'='Win32_ComputerSystem';
                            'CimSession'=$session
                          }
            $cs = Get-CimInstance @cs_params
            
            $sysdrive = $os.SystemDrive
            $drive_params = @{
                                'ClassName'='Win32_LogicalDisk';
                                'Filter'="DeviceId='$sysdrive'";
                                'CimSession'=$Session
                             }
            $drive = Get-CimInstance @drive_params

            $proc_params = @{
                                'ClassName'='Win32_Processor';
                                'CimSession'=$Session
                            }
            $proc = Get-CimInstance @proc_params | Select-Object -First 1

            # Close session
            $Session | Remove-CimSession

            # Output data
            $props = @{
                        ComputerName = $Computer;
                        OSVersion = $os.Version;
                        SPVersion = $os.ServicePackMajorVersion;
                        OSBuild = $os.Buildnumber;
                        Manufacturer = $cs.Manufacturer;
                        Procs = $cs.NumberOfProcessors;
                        Cores = $cs.NumberOfLogicalProcessors;
                        RAM = ($cs.TotalPhysicalMemory / 1GB);
                        Arch = $proc.AddressWidth;
                        SysDriveFreeSpace = $drive.FreeSpace
            } # props

            $obj = New-Object -TypeName psobject -Property $props
            Write-Output $obj

        } # for each Computer

    } # PROCESS
 
    END {}

} # Get-MachineInfo