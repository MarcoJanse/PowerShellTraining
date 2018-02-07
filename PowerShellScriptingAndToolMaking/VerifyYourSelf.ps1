<#
.SYNOPSIS
    VerifyYourself.ps1 is a script to test your scripting knowledge
.DESCRIPTION
    VerifyYourself.ps1 is the first lab in the PowerShell Scripting and Toolmaking
    book that tests your current knowledge of PowerShell scripting by recreating the
    script from the transcript output. The transcript can be found in Part 1, under
    the chapter "Verify Yourself"

    The answers and lab files can also be downloaded using PowerShell Get by saving the
    module PowerShell-Toolmaking to a location on your computer
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    Just my own scribbles of what this script should do

    Function name: Get-XXXSystemInfo
    Parameters:
        -ComputerName (should accept multiple values)
        -Protocol (either WSMAN or DCOM) (validated Parameter!)
    CmdLetBinding required for Verbose output and common parameters

    ErrorAction Preference: Stop



    Verbose output:
    "Attempting localhost on WSMAN"
    "Operation '' Complete"
    "[+] Connected"
    "Perform operation 'Enumerate CimInstances' with following parameters,
    '\ 'namespaceName' = root\cimv2, 'classname' = win32_OperatingSystem' "
    "Operation 'Enumerate CimInstances' complete"
    "Perform operation 'Enumerate CimInstances' with following parameters,
    '\ 'namespaceName' = root\cimv2, 'classname' = win32_BIOS' "
    "Operation 'Enumerate CimInstances' complete"

    Output per computer:
    BIOSSerial
    ComputerName
    OSVersion
#>

function Get-XXXSystemInfo {
    [CmdLetBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("WSMAN","DCOM")]
        [string]$Protocol
    )

    BEGIN{}

    PROCESS{}

    END{}


}