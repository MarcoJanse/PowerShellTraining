# Part 2 - Exercises

## Table of Contents

- [Part 2 - Exercises](#part-2---exercises)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Notes](#notes)
  - [Version History](#version-history)
    - [Version Details](#version-details)
    - [Revisions](#revisions)
  - [Exercises](#exercises)
    - [Exercise 1](#exercise-1)
    - [Exercise 2](#exercise-2)
    - [Exercise 3](#exercise-3)
    - [Exercise 4](#exercise-4)
    - [Exercise 5](#exercise-5)
    - [Excercise 6](#excercise-6)
    - [Exercise 7](#exercise-7)
      - [07 - My solution](#07---my-solution)
    - [Exercise 8](#exercise-8)
      - [Answer in helpfile](#answer-in-helpfile)
    - [Exercise 9](#exercise-9)

## Introduction

This document contains the second part of exercises from [The PowerShell Practce Primer](https://leanpub.com/psprimer) book

## Notes

- Designed by Jeffrey Hicks
- Exercises executed by [Marco Janse](https://github.com/MarcoJanse)

## Version History

### Version Details

- Version 0.5
- Sunday, 21 August 2022

### Revisions

    0.5 - Solved exercise 7
    0.2 - Until exercise 6
    0.1 - Initial start of the exercises

## Exercises

### Exercise 1

```powershell
Get-PSProvider -PSProvider Registry

## or

Get-PSDrive -PSProvider Registry
```

### Exercise 2

```powershell
(Get-ChildItem -Path Cert:\LocalMachine\Root\).count
```

### Exercise 3

```powershell
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' |
    Select-Object registeredOwner,registeredorganization
```

### Exercise 4

```powershell
(Get-ChildItem -Path Function:).count
```

### Exercise 5

```powershell
Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall |
    Where-Object { $_.Name -notmatch "{*}" } |
    Select-Object Name
```

### Excercise 6

```powershell
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
```

### Exercise 7

#### 07 - My solution

```powershell
$HelpFiles = help about_*provider* | Select-Object -ExpandProperty Name

foreach ($HelpFile in $HelpFiles) {
    Get-Help $helpfile | Select-String -Pattern 'transaction'
}
```

### Exercise 8

```powershell
help *certificate* | Select-String 'codesigning'

help about_certificate_provider -ShowWindow
```

#### Answer in helpfile

```powershell
Get-ChildItem -Path cert: -CodeSigningCert -Recurse
```

### Exercise 9

```powershell
($env:Path).Split(";")
```
