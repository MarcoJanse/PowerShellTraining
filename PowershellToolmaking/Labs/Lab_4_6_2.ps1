<#
.SYNOPSIS
    Lab 4.6.2
.DESCRIPTION
    Lab 4.6.2 from Learn powershell Toolmaking
    An excercise to learn proper formatting and indenting 
        
.EXAMPLE
    PS C:\>
.NOTES
    Version 1.0
    2018-05-20
    Marco Janse

    Version History:
    1.0 - Did the lab
#>

Function Get-DiskInfo {

Param (
    [string] $ComputerName='localhost',

    [int] $MinimumFreePercent=10

)

    $disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"

    foreach ($disk in $disks) {
        $perFree = ($disk.FreeSpace/$disk.Size)*100
        if ($perFree -ge $MinimumFreePercent) {
            $OK=$true
        } #if
        else {
            $OK=$false
        } #else
        
        $disk | Select-Object DeviceID,VolumeName,Size,FreeSpace,@{Name="OK";Expression={$OK}}

    } # foreach

} # Get-DiskInfo

Get-DiskInfo