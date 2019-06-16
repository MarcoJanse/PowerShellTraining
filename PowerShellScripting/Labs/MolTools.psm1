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
.NOTES
    Version 2.0
    Last modified on 16-06-2019
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version History:
    2.0 - Changed to PS Module
        - Changed Set-TMServicePassowrd to and advanced function
        - paragraph 11.2.2
        - + additional elseif statement for systemaccounts
    1.1 - added credits to the notes
    1.0 - Lab from paragraph 10.5 (your turn)
.LINK
    https://github.com/MarcoJanse/PowerShellTraining/tree/master/PowerShellScripting/Labs
#>

function Set-TMServicePassword {
    <#
    .SYNOPSIS
        Set-TMServicePassword can change a the user and password
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

        Set-TMServiceLogon 
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
        Version 1.0
        Last modified on 16-06-2019
        Designed by Don Jones and Jeffrey Hicks
        Lab executed by Marco Janse

        Version History:
        1.0 - First advanced function version in MOLTools module
            - paragraph 11.2.2

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

            $Option = New-CimSessionOption -Protocol Wsman
            $Session = New-CimSession -SessionOption $option -ComputerName $Computer

            If ( $PSBoundParameters.ContainsKey('NewUser') ) {
                $args = @{'StartName' = $NewUser; 'StartPassword' = $NewPassword }
            }
            elseif ($PSBoundParameters.ContainsKey('$SystemAccount') ) {
                $args = @{'StartName' = $Systemaccount}
            }
            Else {
                $args = @{'StartPassword' = $NewPassword }
            }

            Invoke-CimMethod -ComputerName $Computer -Query "Select * FROM Win32_Service WHERE Name='$ServiceName'" -MethodName change -Arguments $args |
                Select-Object -Property @{n='ComputerName';e={$Computer}},
                                        @{n='Result';e={$_.ReturnValue}}
            
            $session | Remove-CimSession

        } # for each $Computer

    } #PROCESS

    END {}

} # Set-TMServicePassword

# END OF MODULE