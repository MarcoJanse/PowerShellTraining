<#
.SYNOPSIS
    Date/Time conversion examples
.DESCRIPTION
    Just some examples how to use convert date/time to readable output
.NOTES
    version 1.0
    2018-07-01
    By Marco Janse

    Version History:
    1.0 Created intial script
#>

# Example 1 - Convert string to date/time object

$os = Get-WmiObject -Class Win32_OperatingSystem
$os.lastbootuptime # this will show you the LastBootupTime in a long string value, which is hard to read
$os.ConvertToDateTime($os.LastBootUpTime) # this will convert the string to a readable date/time object

# Example 2: Convert date/time object to different types of strings

$Date = Get-Date
$Date # will display the date in a nice readable format
$Date | Get-Member # shows that this is a system.datetime object
$date.ToString("yyyy-MM-dd") # Will convert the date to a string
$date.ToString("yyyy-MM-dd HH:mm:ss") # Will convert the date to string and also list the time in 2 decimals