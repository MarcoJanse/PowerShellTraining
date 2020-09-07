<#
.SYNOPSIS
    PowerShell Practice Primer - Part 2 Exercises
.DESCRIPTION
    PowerShell Practice Primer - Part 2 Exercises
.NOTES
    Last modified on 6-9-2020
    Designed by Jeffrey Hicks
    Exercises executed by Marco Janse

    Version 0.1

    Version History:
    
    0.1 - Initial start of the exercises
#>

# Exercise 1
Get-PSProvider -PSProvider Registry
## or
Get-PSDrive -PSProvider Registry

# Exercise 2
(Get-ChildItem -Path Cert:\LocalMachine\Root\).count

