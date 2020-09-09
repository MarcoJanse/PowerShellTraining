<#
.SYNOPSIS
    PowerShell Practice Primer - Part 2 Exercises
.DESCRIPTION
    PowerShell Practice Primer - Part 2 Exercises
.NOTES
    Last modified on 9-9-2020
    Designed by Jeffrey Hicks
    Exercises executed by Marco Janse

    Version 0.2

    Version History:
    
    0.2 - until exercise 6
    0.1 - Initial start of the exercises
#>

# Exercise 1
Get-PSProvider -PSProvider Registry
## or
Get-PSDrive -PSProvider Registry

# Exercise 2
(Get-ChildItem -Path Cert:\LocalMachine\Root\).count

# Exercise 3
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' | 
    Select-Object registeredOwner,registeredorganization

# Exercise 4
(Get-ChildItem -Path Function:).count

# Exercise 5
Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | 
    Where-Object { $_.Name -notmatch "{*}" } | 
    Select-Object Name

# Excercise 6

## 1
$var = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' | 
    Select-Object -ExpandProperty registeredOrganization
## 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name 'RegisteredOrganization' -Value 'Acme Inc.'

## 3
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' | 
    Select-Object registeredOrganization

## 4
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -Name 'RegisteredOrganization' -Value $var


