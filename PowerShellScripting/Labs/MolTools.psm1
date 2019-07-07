function Set-TMServiceLogon {
    <#
    .SYNOPSIS
        Set-TMServiceLogon can change a the user and password
        for a service to run under
    .DESCRIPTION
        Set-TMServiceLogon is an advanced function to change the
        user and (optionally) the password for a Windows service 
        to run under.
    .EXAMPLE
        Set-TMServiceLogon -ServiceName OurService -NewPassword `
        'P@ssw0rd' -NewUser "COMPANY\User" -ComputerName SERVER1,
        SERVER2

        Set-TMServiceLogon -ServiceName OurService -NewPassword
        'P@ssword' -ComputerName SERVER1,SERVER2

        Set-TMServiceLogon -ServiceName BITS -SystemAccount 'NT Authority\LocalSystem'
        -ComputerName SERVER3
    .PARAMETER ComputerName
        Enter one or more computernames, seperated by commas
    .PARAMETER ServiceName
        Can be used to specify the Windows Service Name. This
        parameter is required
    .PARAMETER NewPassword
        The new password for the account the service runs under
    .PARAMETER NewUser
        The user account the service should run under.
    .PARAMETER SystemAccount
        Can be used for setting the built-in system accounts that 
        exist, such as LocalSystem, NT AUTHORITY\NetworkService 
        and NT AUTHORITY\LocalService
    .NOTES
        Version 1.1
        Last modified on 07-07-2019
        Designed by Don Jones and Jeffrey Hicks
        Lab executed by Marco Janse

        Version History:
        1.1 - Added verbose output
        1.0 - First advanced function version in MOLTools module
            - paragraph 11.2.2
    .LINK
    https://github.com/MarcoJanse/PowerShellTraining/tree/master/PowerShellScripting/Labs

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$ServiceName,

        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)
                   ]
        [string[]]$ComputerName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$NewPassword,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$NewUser,

        [ValidateSet('LocalSystem','NT AUTHORITY\NetworkService','NT AUTHORITY\LocalService')]
        [string]$SystemAccount,

        [string]$ErrorLogFilePath
    )

    BEGIN {}
    
    PROCESS {

        foreach ($Computer in $ComputerName) {
            
            Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Creating CIM session for $Computer using WS-MAN"
            $Option = New-CimSessionOption -Protocol Wsman
            $Session = New-CimSession -SessionOption $option -ComputerName $Computer

            If ( $PSBoundParameters.ContainsKey('NewUser') ) {
                $args = @{'StartName' = $NewUser; 'StartPassword' = $NewPassword }
                Write-Warning "Setting a new user name "
            }
            elseif ($PSBoundParameters.ContainsKey('$SystemAccount') ) {
                $args = @{'StartName' = $Systemaccount}
                Write-Warning "Setting System Account"
            }
            Else {
                $args = @{'StartPassword' = $NewPassword }
                Write-Warning "Not setting a new user name"
            }

            $Params = @{
                            CimSession = $Session;
                            Query = "Select * FROM Win32_Service WHERE Name='$ServiceName'";
                            MethodName = 'Change';
                            Arguments = $args
                          }
            Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Invoking CimMethod" 
            $ret = Invoke-CimMethod @Params 

            switch ($ret.ReturnValue) {
                0 { $status = "Success" }
                22 { $status = "Invalid Account" }
                Default { $status = "Failed:$($ret.ReturnValue)"}
            } # switch
            
            $props = @{
                        ComputerName = $computer;
                        Status = $status;
                      }
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
            
            Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] -Cleaning up CIM session for $Computer"
            $session | Remove-CimSession

        } # for each $Computer

    } #PROCESS

    END {}

} # Set-TMServiceLogon

# END OF MODULE