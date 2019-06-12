<#
.SYNOPSIS
    MolTools with function Set-TMServiceLogon
.DESCRIPTION
    MolTools can be used as a PowerShell Module and
    contains a function created as a lab in chapter 10 
    of Learn PowerShell Scripting in a Month of Lunches

    Currently it contains one function: Set-TMServiceLogon
    to change the user and (optionally) the password for a
    Windows service to run under.
.EXAMPLE
    Set-TMServiceLogon -ServiceName OurService -NewPassword `
    'P@ssw0rd' -NewUser "COMPANY\User" -ComputerName SERVER1,
    SERVER2

    Set-TMServiceLogon -ServiceName OurService -NewPassword
    'P@ssword' -ComputerName SERVER1,SERVER2

.PARAMETER ComputerName
    Enter one or more computernames, seperated by commas
.PARAMETER ServiceName
    Can be used to specify the Windows Service Name. This
    parameter is required
.PARAMETER NewPassword
    The new password for the account the service runs under
.PARAMETER NewUser
    The user account the service should run under.
.NOTES
    Version 1.0
    Last modified on 12-06-2019
    By Marco Janse

    Version History
    1.0 - Lab from paragraph 10.5 (your turn)
#>

function Set-TMServicePassword {
    param (
        [string]$ServiceName,
        [string[]]$ComputerName,
        [string]$NewPassword,
        [string]$NewUser,
        [string]$ErrorLogFilePath
    )
    
    foreach ($Computer in $ComputerName) {

        $Option = New-CimSessionOption -Protocol Wsman
        $Session = New-CimSession -SessionOption $option -ComputerName $Computer

        If ( $PSBoundParameters.ContainsKey('NewUser') ) {
            $args = @{'StartName' = $NewUser; 'StartPassword' = $NewPassword }
        }
        Else {
            $args = @{'StartPassword' = $NewPassword }
        }

        Invoke-CimMethod -ComputerName $Computer -Query "Select * FROM Win32_Service WHERE Name='$ServiceName'" -MethodName change -Arguments $args |
            Select-Object -Property @{n='ComputerName';e={$Computer}},
                                    @{n='Result';e={$_.ReturnValue}}
        
        $session | Remove-CimSession

    } # for each $Computer

} # Set-TMServicePassword