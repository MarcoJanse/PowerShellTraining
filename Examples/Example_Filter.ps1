<#
.SYNOPSIS
    Filter examples
.DESCRIPTION
    Just some examples how to use the filter parameter on different CMDlets
.NOTES
    version 1.0
    2018-07-01
    By Marco Janse

    Version History
    1.0 Created intial script
#>


# Example 1: Filtering when using WMI queries
Get-CimInstance -ClassName Win32_Service -Filter "State='Running' AND Name='BITS'" | select Name,ProcessID