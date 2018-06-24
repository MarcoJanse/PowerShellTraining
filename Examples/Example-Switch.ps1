<#
.SYNOPSIS
    switch example
.DESCRIPTION
    Just an example how to use the switch parameter

    More info: help about_switch
.NOTES
    version 1.0
    2018-06-24
    By Marco Janse

    Version History
    1.0 Created example
#>

switch ((Get-CimInstance -ClassName Win32_ComputerSystem).AdminPasswordStatus){
    0 {"Disabled"}
    1 {"Enabled"}
    2 {"Not Implemented"}
    3 {"Unknown"}
}