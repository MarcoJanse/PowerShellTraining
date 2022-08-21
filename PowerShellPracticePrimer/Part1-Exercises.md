# Part 1 - Excersises

- [Part 1 - Excersises](#part-1---excersises)
  - [Introduction](#introduction)
  - [Notes](#notes)
  - [Version History](#version-history)
    - [Version details](#version-details)
  - [Excercises](#excercises)
    - [Exercise 1](#exercise-1)
    - [Exercise 2](#exercise-2)
    - [Exercise 3](#exercise-3)
    - [Exercise 4](#exercise-4)
    - [Exercise 5](#exercise-5)
    - [Exercise 6](#exercise-6)
    - [Exercise 7](#exercise-7)
    - [Exercise 8](#exercise-8)
    - [Exercise 9](#exercise-9)
    - [Exercise 10](#exercise-10)
    - [Exercise 11](#exercise-11)
    - [Exercise 12](#exercise-12)
    - [Exercise 13](#exercise-13)
    - [Exercise 14](#exercise-14)
    - [Exercise 15](#exercise-15)
    - [Exercise 16](#exercise-16)
      - [16 - My solution](#16---my-solution)
      - [16 - Jeff's solution](#16---jeffs-solution)
    - [Exercise 17](#exercise-17)
      - [17 - My solution](#17---my-solution)
    - [Exercise 18](#exercise-18)
      - [18 - My solution](#18---my-solution)
      - [18 - Jeff's solution](#18---jeffs-solution)
    - [Exercise 19](#exercise-19)
    - [Exercise 20](#exercise-20)
      - [20 - My solution](#20---my-solution)
      - [20 - Jeff's Solution](#20---jeffs-solution)
    - [Exercise 21](#exercise-21)
      - [21 - My solution](#21---my-solution)
      - [21 - Jeff's solution 1](#21---jeffs-solution-1)
      - [Jeff's solution 2](#jeffs-solution-2)
    - [Exercise 22](#exercise-22)
      - [22 - My Solution ===NOT QUITE RIGHT===](#22---my-solution-not-quite-right)
      - [21- Jeff's solution](#21--jeffs-solution)
    - [Exercise 23](#exercise-23)
      - [23- My solution](#23--my-solution)
      - [23 - Jeff's solution](#23---jeffs-solution)
    - [Exercise 24](#exercise-24)
      - [24 -My solution](#24--my-solution)
      - [24 - Jeff's solution](#24---jeffs-solution)
    - [Exercise 25](#exercise-25)

## Introduction

This document contains the first part of exercises from [The PowerShell Practce Primer](https://leanpub.com/psprimer) book

## Notes

- Designed by Jeffrey Hicks
- Exercises executed by [Marco Janse](https://github.com/MarcoJanse)

## Version History

### Version details

- Version 2.0
- Sunday, 21 August 2022

- 2.0 - Converted from PowerShell file (.ps1) to Markdown (.md)
- 1.0 - Reviewed with the solutions from the book and corrected/adjusted where necessary
- 0.4 - added final exercises 24 and 25
- 0.3 - exercise 22 and 23 added
- 0.2 - exercise 21 added
- 0.1 - what I did during my holiday in August

## Excercises

### Exercise 1

```powershell
Get-Service -DisplayName Windows*
```

### Exercise 2

```powershell
Get-EventLog -List
```

### Exercise 3

```powershell
Get-Command -Verb remove
```

### Exercise 4

```powershell
Restart-Computer -ComputerName lab1,lab2
```

### Exercise 5

```powershell
Get-Module -ListAvailable
```

### Exercise 6

```powershell
Restart-Service BITS -PassThru
```

### Exercise 7

```powershell
Get-ChildItem -Path $env:TEMP -file -Recurse
```

### Exercise 8

```powershell
Get-Acl -Path C:\Windows\notepad.exe | Format-List
```

### Exercise 9

```powershell
help about_Regular_Expressions
```

### Exercise 10

```powershell
Get-EventLog -LogName System -EntryType Error |
    Select-Object -Last 10

## or better

Get-EventLog -LogName System -Newest 10 -EntryType Error
```

### Exercise 11

```powershell
Get-Command -Module PSReadline -Verb Get
```

### Exercise 12

```powershell
$PSVersionTable
```

### Exercise 13

```powershell
c:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile

## or
powershell -NoProfile
```

### Exercise 14

```powershell
Get-Alias | Measure-Object | Select-Object -ExpandProperty Count
## or
(Get-Alias).count
```

### Exercise 15

```powershell
Get-Process | Where-Object { $_.WorkingSet -ge 50MB } | Sort-Object -Property WorkingSet -Descending
```

### Exercise 16

#### 16 - My solution

```powershell
Get-ChildItem -Path $env:TEMP |
    Where-Object { $_.LastWriteTime -ge ((Get-Date).AddHours(-24)) } |
    Select-Object FullName,Length,LastWriteTime | Sort-Object lastwriteTime
```

#### 16 - Jeff's solution

```powershell
$cut = (Get-Date).AddHours(-24)
Get-ChildItem -Path $env:TEMP -File -Recurse |
    Where-Object ($_.LastWriteTime -ge $cut) |
    Select-Object -Property FullName,Length,LastWriteTime
```

### Exercise 17

#### 17 - My solution

```powershell
Get-ChildItem -Path $Home\Onedrive\Documents -Recurse |
    Where-Object { $_.Length -gt 1MB -and $_.LastWriteTime -le ((Get-Date).AddDays(-90)) } |
    Select-Object FullName,@{Name='Size';Expression={$_.Length/1MB } },CreationTime,LastWriteTime |
    Export-Csv -Path C:\Scripts\Output\PSPrimer_Exercise17.csv -Delimiter ';'
```

### Exercise 18

#### 18 - My solution

```powershell
Get-ChildItem -Path $env:TEMP -Recurse |
    Group-Object -Property Extension |
    Select-Object Count,Name |
    Sort-Object Count -Descending
```

#### 18 - Jeff's solution

```powershell
Get-ChildItem -Path $env:TEMP -file -Recurse |
    Group-Object -Property Extension -NoElement |
    Sort-Object -Property Count -Descending
```

### Exercise 19

```powershell
Get-Process -IncludeUserName | 
    Where-Object { $_.UserName -eq "$($env:USERDOMAIN)\$($env:USERNAME)" } |
    Export-Clixml -Path C:\Scripts\Output\PSPrimer_Exercise19_myprocs.xml
```

### Exercise 20

#### 20 - My solution

```powershell
Import-Clixml -Path C:\Scripts\Output\PSPrimer_Exercise19_myprocs.xml |
    Group-Object -Property Company
```

#### 20 - Jeff's Solution

```powershell
Import-Clixml -Path C:\Scripts\Output\PSPrimer_Exercise19_myprocs.xml |
    Sort-Object -Property Company | Format-Table -Property 
```

### Exercise 21

#### 21 - My solution

```powershell
$x = 1
while($x -le 10){ $x++ ; Get-Random -Minimum 1 -Maximum 50 |
    ForEach-Object { $_ * $_ } }
```

#### 21 - Jeff's solution 1

```powershell
for ($i=1;$i -le 10;$i++) {
    $x = Get-Random -Maximum 50 -Minimum 1
    $x * $x
}
```

#### Jeff's solution 2

```powershell
1..10 | foreach {
    $x = Get-Random -Maximum 50 -Minimum 1
    $x * $x
}
```

### Exercise 22

#### 22 - My Solution ===NOT QUITE RIGHT===

```powershell
Get-WinEvent -ComputerName localhost -ListLog * |
    Select-Object @{Name='ComputerName';Expression={$Env:COMPUTERNAME}},LogName,RecordCount |
    ConvertTo-Html -Title 'Exercise 22' |
    Out-File C:\Scripts\Output\PSPrimer_Exercise22.html
```

#### 21- Jeff's solution

```powershell
Get-EventLog -List |
    Select-Object -Property MaximumKilobytes,MinimumRetentionDays,@{
        Name='Count';Expression={$_.entries.count}
    },LogDisplayName |
    ConvertTo-Html -PreContent "<h1>$($env:COMPUTERNAME)</h1>" |
    Out-File -FilePath C:\Scripts\Output\PSPrimer_Exercise22_solution2_EventLog.html
```

### Exercise 23

#### 23- My solution

```powershell
Find-Module -Filter 'teaching'
```

#### 23 - Jeff's solution

```powershell
Find-Module -Tag teaching -Repository PSGallery
```

### Exercise 24

#### 24 -My solution

```powershell
Get-Service |
    Select-Object -ExcludeProperty RequiredServices, DependentServices,ServicesDependedOn |
    ConvertTo-Json |
    Out-File C:\Scripts\Output\PSPrimer_Exercise24.json

Get-Content C:\Scripts\Output\PSPrimer_Exercise24.json |
    ConvertFrom-Json
```

#### 24 - Jeff's solution

```powershell
Get-Service | 
    Where-Object { $_.Status -eq 'Running'} |
    Select-Object -Property * -ExcludeProperty *Services* |
    ConvertTo-Json | 
    Set-Content -Path C:\Scripts\Output\PSPrimer_Exercise24_solution2_running.json

Get-Content -Path C:\Scripts\Output\PSPrimer_Exercise24_solution2_running.json | ConvertFrom-Json
```

### Exercise 25

```powershell
Test-NetConnection -ComputerName localhost -CommonTCPPort HTTP
```
