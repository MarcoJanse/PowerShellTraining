<#
.SYNOPSIS
    PowerShell Practice Primer - Part 1 Exercises
.DESCRIPTION
    PowerShell Practice Primer - Part 1 Exercises
.NOTES
    Last modified on 6-9-2020
    Designed by Jeffrey Hicks
    Exercises executed by Marco Janse

    Version 1.0

    Version History:
    
    1.0 - Reviewed with the solutions from the book and corrected/adjusted where necessary
    0.4 - added final exercises 24 and 25
    0.3 - exercise 22 and 23 added
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
Get-ChildItem -Path $env:TEMP -file -Recurse

# Exercise 8
Get-Acl -Path C:\Windows\notepad.exe | 
    Format-List

# Exercise 9
help about_Regular_Expressions

# Exercise 10
Get-EventLog -LogName System -EntryType Error | 
    Select-Object -Last 10
##or better
Get-EventLog -LogName System -Newest 10 -EntryType Error

# Exercise 11
Get-Command -Module PSReadline -Verb Get

# Exercise 12
$PSVersionTable

# Exercise 13
c:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile
##or
powershell -NoProfile


# Exercise 14
Get-Alias | Measure-Object | Select-Object -ExpandProperty Count
## or
(Get-Alias).count

# Exercise 15
Get-Process | Where-Object { $_.WorkingSet -ge 50MB } | 
    Sort-Object -Property WorkingSet -Descending

# Exercise 16

## My solution
Get-ChildItem -Path $env:TEMP | 
    Where-Object { $_.LastWriteTime -ge ((Get-Date).AddHours(-24)) } | 
    Select-Object FullName,Length,LastWriteTime | Sort-Object lastwriteTime

## Jeff's solution
$cut = (Get-Date).AddHours(-24)
Get-ChildItem -Path $env:TEMP -File -Recurse |
    Where-Object ($_.LastWriteTime -ge $cut) | 
    Select-Object -Property FullName,Length,LastWriteTime

# Exercise 17

## My solution:
Get-ChildItem -Path $Home\Onedrive\Documents -Recurse | 
    Where-Object { $_.Length -gt 1MB -and $_.LastWriteTime -le ((Get-Date).AddDays(-90)) } | 
    Select-Object FullName,@{Name='Size';Expression={$_.Length/1MB } },CreationTime,LastWriteTime | 
    Export-Csv -Path C:\Scripts\Output\PSPrimer_Exercise17.csv -Delimiter ';'

## Jeff's solution:


# Exercise 18
Get-ChildItem -Path $env:TEMP -Recurse | 
    Group-Object -Property Extension | 
    Select-Object Count,Name | 
    Sort-Object Count -Descending

## Jeff's solution:
Get-ChildItem -Path $env:TEMP -file -Recurse |
    Group-Object -Property Extension -NoElement |
    Sort-Object -Property Count -Descending

# Exercise 19
Get-Process -IncludeUserName | 
    Where-Object { $_.UserName -eq "$($env:USERDOMAIN)\$($env:USERNAME)" } | 
    Export-Clixml -Path C:\Scripts\Output\PSPrimer_Exercise19_myprocs.xml

# Exercise 20

## My solution
Import-Clixml -Path C:\Scripts\Output\PSPrimer_Exercise19_myprocs.xml | 
    Group-Object -Property Company

## Jeff's Solution
Import-Clixml -Path C:\Scripts\Output\PSPrimer_Exercise19_myprocs.xml |
    Sort-Object -Property Company | Format-Table -Property 

# Exercise 21

## my solution
$x = 1
while($x -le 10){ $x++ ; Get-Random -Minimum 1 -Maximum 50 | 
    ForEach-Object { $_ * $_ } }

## Jeff's solution 1
for ($i=1;$i -le 10;$i++) {
    $x = Get-Random -Maximum 50 -Minimum 1
    $x * $x
}

## Jeff's solution 2
1..10 | foreach {
    $x = Get-Random -Maximum 50 -Minimum 1
    $x * $x
}

# Exercise 22

## My Solution ..NOT QUITE RIGHT...
Get-WinEvent -ComputerName localhost -ListLog * | 
    Select-Object @{Name='ComputerName';Expression={$Env:COMPUTERNAME}},LogName,RecordCount | 
    ConvertTo-Html -Title 'Exercise 22' | 
    Out-File C:\Scripts\Output\PSPrimer_Exercise22.html

## Jeff's solution
Get-EventLog -List | 
    Select-Object -Property MaximumKilobytes,MinimumRetentionDays,@{
        Name='Count';Expression={$_.entries.count}
    },LogDisplayName |
    ConvertTo-Html -PreContent "<h1>$($env:COMPUTERNAME)</h1>" | 
    Out-File -FilePath C:\Scripts\Output\PSPrimer_Exercise22_solution2_EventLog.html

# Exercise 23

## My solution
Find-Module -Filter 'teaching'

## Jeff's solution
Find-Module -Tag teaching -Repository PSGallery

# Exercise 24

## My solution
Get-Service | 
    Select-Object -ExcludeProperty RequiredServices, DependentServices,ServicesDependedOn | 
    ConvertTo-Json | 
    Out-File C:\Scripts\Output\PSPrimer_Exercise24.json

Get-Content C:\Scripts\Output\PSPrimer_Exercise24.json | 
    ConvertFrom-Json

# Jeff's solution
Get-Service | 
    Where-Object { $_.Status -eq 'Running'} | 
    Select-Object -Property * -ExcludeProperty *Services* |
    ConvertTo-Json | 
    Set-Content -Path C:\Scripts\Output\PSPrimer_Exercise24_solution2_running.json

Get-Content -Path C:\Scripts\Output\PSPrimer_Exercise24_solution2_running.json | ConvertFrom-Json

# Exercise 25
Test-NetConnection -ComputerName localhost -CommonTCPPort HTTP