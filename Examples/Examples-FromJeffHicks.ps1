<#
.SYNOPSIS
    PowerShell Examples from Jeff Hicks
.DESCRIPTION
    PowerShell Examples from Jeff Hicks
.NOTES
    Copyright Jeff Hicks - 2020
    Copied for training purposes by Marco Janse
    
    Version 1.0
    2020-08-28
    By Jeff Hicks

    Version History

    1.0 - copied from website Jeff Hick on end of August 2020
.LINK
    https://jdhitsolutions.com/blog/powershell-tips-tricks-and-advice/
#>

# Get the scriptblock content of a loaded function. Substitute the name of a function.
(get-item Function:\prompt).scriptblock

# Copy a function to a remote computer using a PSSession.
$f = $(get-item function:\Get-Foo).scriptblock
Invoke-Command { New-Item -Name Get-Foo -Path Function: -Value $($using:f)} -session $s

# Get running scheduled tasks on a Windows system.
(get-scheduledtask).where({$_.state -eq 'running'})

# Get system uptime from multiple computers where $computers is an array of computer names running PowerShell v3 or later.
Get-CimInstance Win32_operatingsystem -ComputerName $computers |
Select-Object PSComputername,LastBootUpTime,
@{Name="Uptime";Expression = {(Get-Date) - $_.LastBootUptime}}

# Another way to get drive utilization using PSDrives.
Get-PSDrive -PSProvider filesystem | where-object {$_.used -gt 0} |
select-Object -property Root,@{name="SizeGB";expression={($_.used+$_.free)/1GB -as [int]}},
@{name="UsedGB";expression={($_.used/1GB) -as [int]}},
@{name="FreeGB";expression={($_.free/1GB) -as [int]}},
@{name="PctFree";expression={[math]::round(($_.free/($_.used+$_.free))*100,2)}}

# List installed applications and a few details.
gcim win32_product -computername $env:computername | 
Sort-Object -property Vendor,Name |
Select-Object -property Vendor,Name,
@{Name="Installed";Expression = {($_.InstallDate.Insert(4,"-").insert(7,"-") -as [datetime]).ToShortDateString()}},
InstallLocation,InstallSource,PackageName,Version

# Get details about all external scripts in your %PATH%.
gcm -commandtype externalscript | Get-Item | 
Select-Object Directory,Name,Length,CreationTime,LastwriteTime,
@{name="Signature";Expression={(Get-AuthenticodeSignature $_.fullname).Status }}

# Get folder utilization for a given directory.
dir -path C:\Scripts -file -recurse -force | 
measure-object length -sum -max -average | 
Select-Object @{name="Total Files";Expression={$_.count}},
@{name="Largest File(MB)";Expression={"{0:F2}" -f ($_.maximum/1MB)}},
@{name="Average Size(MB)";Expression={"{0:F2}" -f ($_.average/1MB)}},
@{name="Total Size(MB)";Expression={"{0:F2}" -f ($_.sum/1MB)}}

# Get event log utilization for remote computers defined in $computers. The remote computers must be running PowerShell v3 or later.
gcim Win32_NTEventLogFile -computer $computers -filter  "NumberOfRecords > 0" | 
Select-Object @{Name="Computername";Expression={$_.CSName}},
LogFileName,
NumberOfRecords,
@{Name="Size(KB)";Expression={$_.FileSize/1kb}},
@{Name="MaxSize(KB)";Expression={($_.MaxFileSize/1KB) -as [int]}}, 
@{name="PercentUsed";Expression={[math]::round(($_.filesize/$_.maxFileSize)*100,2)}} |  
Sort Computername,PercentUsed  | 
Format-Table -GroupBy Computername -property LogFileName,NumberOfRecords,*Size*,PercentUsed

# Get free space for drive C on the local computer formatted in GB
(gcim win32_logicaldisk -filter "deviceid = 'C:'").FreeSpace/1gb
 #or use the PSDrive
(gdr c).Free/1gb

# Get a date string in the format year-month-day-hour-min-second. The abbreviations in the format string are case-sensitive.
get-date -format yyyyMMddhhmmss

# Get the last time your computer booted. Can be modified to query remote computers.
(gcim win32_operatingsystem).LastBootUpTime
 #or modify to get uptime
(get-date) - ((gcim win32_operatingsystem).LastBootUpTime)

# Get configured TrustedHosts.
(get-wsmaninstance wsman/config/client).trustedhosts

# Get all drives identified by a standard drive letter. I’m suppressing errors to ignore non-existent drive letters.
get-volume -driveletter (97..122) -ErrorAction SilentlyContinue`

# Get total physical memory formatted as GB.
gcim win32_computersystem -computer SRV1,SRV2 | Select PSComputername,@{N="Memory";E={$_.TotalPhysicalMemory/1GB -as [int]}}

# Get IPv4 addresses on your local adapters.
Get-NetIPAddress -AddressFamily IPv4 | where-object IPAddress -notmatch "^(169)|(127)" | Sort-Object IPAddress | select IPaddress,Interface*

# Find all processes that use a given module (dll). You can filter by the dll name or use part of a path.
Find all processes that use a given module (dll). You can filter by the dll name or use part of a path.

# Since PowerShell Core and PowerShell 7 do not include the Get-Eventlog cmdlet, 
#  here’s a one-liner to list the last 10 errors in the System event log. A level value of 3 will give you warnings.
get-winevent -FilterHashtable @{Logname = 'System';Level=2} -MaxEvents 10 | sort-Object ProviderName,TimeCreated

# List all PowerShell profile script settings. You will see different values for different hosts, like the PowerShell ISE, as well as between Windows PowerShell and PowerShell 7.
$profile | select *host* | fl

# Get the current date and time formatted as UTC time.
(get-date).ToUniversalTime()
 #or pretty it up
"$((get-date).ToUniversalTime()) UTC"

"$((get-date).ToUniversalTime().tolongdatestring()) UTC"

# Get a formatted report of all commands with a synopsis.
(Get-Command).where( { $_.source }) | Sort-Object Source, CommandType, Name | Format-Table -GroupBy Source -Property CommandType, Name, @{Name = "Synopsis"; Expression = { (Get-Help $_.name).Synopsis}}