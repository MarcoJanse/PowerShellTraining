function Set-TMServiceLogon {
    <#
    .SYNOPSIS
        Sets service login name and password

    .DESCRIPTION
        This function uses either CIM (default) or WMI to set
        the service password, and optionally the logon user
        name, for a service, which can be running on one or
        more remote machines. You must run this command as a
        user who has permissions to perform this task remotely
        on the computers involved.

    .PARAMETER ServiceName
        The name of the service. Query the Win32_Service class
        to verify that you know the correct name.

    .PARAMETER ComputerName
        Enter one or more computernames, seperated by commas.
        Using IP addresses will fail with CIM; they will work
        with WMI. CIM is always attempted first.

    .PARAMETER NewPassword
        A plain-text string of the new password (That's BAD!!)

    .PARAMETER NewUser
        Optional: The new logon user name, in DOMAIN\USER format.

    .PARAMETER SystemAccount
        Can be used for setting the built-in system accounts that 
        exist, such as LocalSystem, NT AUTHORITY\NetworkService 
        and NT AUTHORITY\LocalService
        
    .PARAMETER ErrorLogFilePath
        If provided, this is a path and filename of a text file
        where failed computer names will be logged.

    .EXAMPLE
        Set-TMServiceLogon -ServiceName OurService -NewPassword `
        'P@ssw0rd' -NewUser "COMPANY\User" -ComputerName SERVER1,
        SERVER2

        This will set the service OurService on SERVER1 and SERVER2
        to run under COMPANY\USER with a password of "P@ssword"

    .EXAMPLE
        Set-TMServiceLogon -ServiceName OurService -NewPassword
        'P@ssword' -ComputerName SERVER1,SERVER2

        This will only change the password service OurService on 
        SERVER1 and SERVER2 to run under "P@ssword"

    .EXAMPLE
        Set-TMServiceLogon -ServiceName BITS -SystemAccount 'NT Authority\LocalSystem'
        -ComputerName SERVER3

        This will set the BITS service on SERVER3 to run under the default LocalSystem
        account, for which a password doesn't need to be set, as Windows takes care 
        of this.

    .NOTES
        Version 1.3
        Last modified on 28-07-2019
        Designed by Don Jones and Jeffrey Hicks
        Lab executed by Marco Janse

        Version History:
        1.3   - Error Handling -- LOOP ISSUE --
              - listing 15.2
        1.2.6 - Error Handling -- IN PROGRESS --
              - My own attempt
        1.2.5 - Added Error Handling  -- In PROGRESS --
              - paragraph 15.8.2 
        1.2 - Updated/added comment based help
            - paragraph 14.6
        1.1 - Added verbose output
        1.0 - First advanced function version in MOLTools module
            - paragraph 11.2.2
            
    .LINK
    https://github.com/MarcoJanse/PowerShellTraining/blob/master/PowerShellScripting/Labs/MolTools.psm1

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

            Do {
                Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Connect to $Computer on WS-MAN"
                $Protocol = "Wsman"

                try {                
                    $Option = New-CimSessionOption -Protocol $Protocol
                    $Session = New-CimSession -SessionOption $option -ComputerName $Computer -ErrorAction Stop
                                        
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

                    Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Setting $ServiceName on $Computer"

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
                    
                    Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Closing CIM session for $Computer"
                    $session | Remove-CimSession
                } # try

                catch {
                    # change protocol - if we've tried both and logging
                    #  was specified, log the computer name
                    Switch ($Protocol) {
                        'Wsman' { $Protocol = 'Dcom'
                            Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Switching to Dcom for $Computer" 
                        } 
                        'Dcom' { 
                            $Protocol = 'Stop'
                            Write-Warning -Message "Unable to connect to $Computer using any protocol"
                            Write-Verbose -Message "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Switching to Stop for $Computer"
                            
                            if ($PSBoundParameters.ContainsKey('ErrorLogFilePath')) {
                                Write-Warning "$Computer failed; logged to $ErrorLogFilePath"
                                Add-Content $ErrorLogFilePath -Value "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - Processing $Computer Failed; Error Message:"
                                Add-Content $ErrorLogFilePath -Value "[PROCESS] - [$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))] - $($_.Exception.Message)"
                            } # if logging
                        } 
                    } # switch 

                } # try/catch

            } Until ($Protocol -eq 'Stop')
         
        } # for each $Computer

    } #PROCESS

    END {}

} # Set-TMServiceLogon

# END OF MODULE