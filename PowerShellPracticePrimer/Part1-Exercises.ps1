<#
.SYNOPSIS
    PowerShell Practice Primer - Part 1 Exercises
.DESCRIPTION
    PowerShell Practice Primer - Part 1 Exercises
.NOTES
    Last modified on 21-8-20920
    Designed by Jeffrey Hicks
    Exercises executed by Marco Janse

    Version 0.1

    Version History:
    
    0.2 - exercise 21 added
    0.1 - what I did during my holiday in August
#>

# Exercise 1
Get-Service -DisplayName Windows*

# Exercise 2
Get-EventLog -List

# Exercise 3
Get-Command -Verb remove

# Exercise 4
Restart-Computer -ComputerName lab1,lab2

# Exercise 5
Get-Module -ListAvailable

# Exercise 6
Restart-Service BITS -PassThru

# Exercise 7
Get-ChildItem -Recurse -Path $env:TEMP

# Exercise 8
Get-Acl -Path C:\Windows\System32\notepad.exe | Format-List

# Exercise 9
help about_Regular_Expressions

# Exercise 10
Get-EventLog -LogName System -EntryType Error | Select-Object -Last 10

# Exercise 11
Get-Command -Module PSReadline -Verb Get

# Exercise 12
$PSVersionTable

# Exercise 13
c:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile

# Exercise 14
Get-Alias | Measure-Object | Select-Object Count
## or
(Get-Alias).count

# Exercise 15
Get-Process | Where-Object { $_.WorkingSet -ge 50MB } | Sort-Object WorkingSet -Descending

# Exercise 16
Get-ChildItem -Path $env:TEMP | Where-Object { $_.LastWriteTime -ge ((Get-Date).AddHours(-24)) } | Select-Object FullName,Length,LastWriteTime | Sort-Object lastwriteTime

# Exercise 17
Get-ChildItem -Path C:\Users\marco\OneDrive\Documents\ -Recurse | Where-Object { $_.Length -gt 1MB } | Select-Object FullName,@{Name='Size';Expression={$_.Length/1MB } },CreationTime,LastWriteTime | Export-Csv -Path C:\Users\marco\OneDrive\Documents\Export.csv -Delimiter ';'

# Exercise 18
Get-ChildItem -Path $env:TEMP -Recurse | Group-Object -Property Extension | Select-Object Count,Name | Sort-Object Count -Descending

# Exercise 19
Get-Process -IncludeUserName | Where-Object { $_.UserName -eq 'SMURFACE\marco' } | Export-Clixml -Path C:\Scripts\Output\UserProcesses.xml

# Exercise 20
Import-Clixml -Path C:\Scripts\Output\UserProcesses.xml | Group-Object -Property Company

# Exercise 21
$x = 1

while($x -le 10){ $x++ ; Get-Random -Minimum 1 -Maximum 50 | ForEach-Object { $_ * $_ } }

# Exercise 22
