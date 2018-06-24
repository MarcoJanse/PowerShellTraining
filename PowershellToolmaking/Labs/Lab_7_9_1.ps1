<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    PowerShell Toolmaking in a Month of Lunches, 7.9.1. LAB A
    Version 1.0
    Last Modified on 24-06-2018
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse

    Version 1.0 - LAB A, chapter 7.9.1.

#>

function Get-ComputerInfo {
    [CmdletBinding()]
    param(
        # Parameter ComputerName
        [Parameter(Mandatory=$true)]
        [string[]] $ComputerName='localhost',

        # Parameter ErrorLog
        [string] $ErrorLog='C:\Scripts\Output\Lab_7_9_1_ErrorLog.txt'
    )

    BEGIN {}

    PROCESS {

        foreach ($Computer in $ComputerName) {
            $comp = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $Computer
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

            $obj = New-Object -TypeName psobject -Property $props
            Write-Output $obj

        } # for each

    } # PROCESS

    END {}

} # Get-ComputerInfo

Get-ComputerInfo -ComputerName localhost,localhost