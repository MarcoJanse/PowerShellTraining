<#
.SYNOPSIS
    Retrieved specific information about one or more
    computers, using WMI or CIM.
.DESCRIPTION
    This command uses either WMI or CIM to retrieve
    specific information about one or more computers.
    You must run this command as a user who has permission
    to remotely query CO+IM or WMI on the machines
    involved. You can specify a starting protocol (CIM by
    default), and specify that, in the event of a failure,
    the other protocol be used on a per-machine basis.
.PARAMETER ComputerName
    One or more computer names, seperated by commas
    When using WMI, this can also be IP addresses.
    IP addresses may not work for CIM.
.PARAMETER LogFailuresToPath
    A path and filename to write failed computer names to.
    If omitted, no log will be written.
.PARAMETER Protocol
    Valid values: Wsman (uses CIM) or Dcom (uses WMI).
    Will be used for all machines. "Wsman" is the default.
.PARAMETER ProtocolFailback
    Specify this to automatically try the other protocol
    if a machine fails.
.EXAMPLE
    Get-MachineInfo -ComputerName ONE,TWO,THREE
    This example will query three machines
.EXAMPLE
    Get-ADUser -Filter * | Select -Expand Name | Get-MachineInfo
    This example will try to query all machines in AD
.NOTES
    Version 1.3
    Last modified on 09-07-2019
    By Marco Janse
.LINK
    https://github.com/MarcoJanse/PowerShellTraining/blob/master/PowerShellScripting/Examples/Get-MachineInfo.ps1

    Version History:
    1.3 - added error handling
        - removed semicolon in parameter splatting tables
        - paragraph 15.4
    1.2 - added new command based help
        - listing 14.1
    1.1 - adding verbose output
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

        [string]$LogFailuresToPath,

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

            try {
                Write-Verbose -Message "Connecting to $computer over $protocol"
                $params = @{
                            'ComputerName' = $Computer
                            'SessionOption' = $option
                            'ErrorAction' = 'Stop'
                            'ErrorVariable' = 'CimError'
                }
                $Session = New-CimSession @params

                Write-Verbose -Message "Querying from $computer"
                $os_params = @{
                                'ClassName' = 'Win32_OperatingSystem'
                                'CimSession' = $Session}
                $os = Get-CimInstance @os_params

                $cs_params = @{
                                'ClassName' = 'Win32_ComputerSystem'
                                'CimSession' = $session}
                $cs = Get-CimInstance @cs_params
                
                $sysdrive = $os.SystemDrive
                $drive_params = @{
                                    'ClassName' = 'Win32_LogicalDisk'
                                    'Filter' = "DeviceId='$sysdrive'"
                                    'CimSession' = $Session}
                $drive = Get-CimInstance @drive_params

                $proc_params = @{
                                    'ClassName'='Win32_Processor'
                                    'CimSession'=$Session}
                $proc = Get-CimInstance @proc_params | Select-Object -First 1

                Write-Verbose -Message "Closing session to $computer"
                $Session | Remove-CimSession

                Write-Verbose -Message "Outputting for $computer"
                $obj = [PSCustomObject]@{
                            ComputerName = $Computer
                            OSVersion = $os.Version
                            SPVersion = $os.ServicePackMajorVersion
                            OSBuild = $os.Buildnumber
                            Manufacturer = $cs.Manufacturer
                            Procs = $cs.NumberOfProcessors
                            Cores = $cs.NumberOfLogicalProcessors
                            RAM = ($cs.TotalPhysicalMemory / 1GB)
                            Arch = $proc.AddressWidth
                            SysDriveFreeSpace = $drive.FreeSpace} # $obj
                
                Write-Output $obj
            } # try New-CimSession
            catch {
                Write-Warning -Message "FAILED $computer on $protocol"
                # Did we specify protocol failback?
                # If so, try again. If we specified logging, we won't
                #  log a problem here - we'll let the logging occur
                #  if this fallback also fails
                if ($ProtocolFallBack) {
                    If ($Protocol -eq 'Dcom') {
                        $NewProtocol = 'Wsman'
                    }
                    else {
                        $NewProtocol = 'Dcom'
                    } # if protocol
                    Write-Verbose -Message "Trying again with $NewProtocol"
                    $params = @{'ComputerName'=$Computer
                                'Protocol'=$NewProtocol
                                'ProtocolFallBack'=$false}
                
                    if ($PSBoundParameters.ContainsKey('LogFailuresToPath')) {
                        $params += @{'LogFailuresToPath'=$LogFailuresToPath}
                    } # if LogFailuresToPath
                
                    Get-MachineInfo @params

                } # if ($ProtocolFallBack)

                # If we didn't specify fallback, but we did specify
                #  logging, then log the error, because we won't
                #  be trying again
                if (-not $ProtocolFallBack -and $PSBoundParameters.ContainsKey('LogFailuresToPath')) {
                    Write-Verbose -Message "Logging to $LogFailuresToPath"
                    $computer | Out-File $LogFailuresToPath -Append
                    $CimError | Out-File $LogFailuresToPath -Append
                }  # if LogFailureToPath

            } # try/catch New-CimSession

        } # for each Computer

    } # PROCESS
 
    END {}

} # Get-MachineInfo