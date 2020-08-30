<#
.SYNOPSIS
    switch example
.DESCRIPTION
    Just an example how to use the switch parameter

    More info: help about_switch
.NOTES
    version 1.1
    2020-08-39
    By Marco Janse

    Version History
    1.1 added seconds example
    1.0 Created example
#>

# Example 1
switch ((Get-CimInstance -ClassName Win32_ComputerSystem).AdminPasswordStatus){
    0 {"Disabled"}
    1 {"Enabled"}
    2 {"Not Implemented"}
    3 {"Unknown"}
}

# Example 2

$x = "d1234"

switch -Wildcard ($x)
    {
        "*1*" {"Contains 1"}
        "*5*" {"Contains 5"}
        "d*" {"Starts with 'd'"}
        default {"no matches"}
    }

# Example 2.1

$x = "1 of 5 dying worms"

switch -Wildcard ($x)
    {
        "*1*" {"Contains 1"}
        "*5*" {"Contains 5"}
        "d*" {"Starts with 'd'"}
        default {"no matches"}
    }