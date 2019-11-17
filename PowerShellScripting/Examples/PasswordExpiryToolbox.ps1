<#
.SYNOPSIS
    PasswordExpiryToolbox.ps1 is an example with multiple functions in regards to AD password expiration and notification

.DESCRIPTION
    PasswordExpiryToolbox.ps1 is an example from Learn PowerShell Scripting in a Month of Lunches.
    It is a PowerShell script with multiple functions in regards to AD password expiration and notification    

.EXAMPLE
    Get-EnabledNonExpiringUsers |
        Add-ExpiryDataToUser |
        Where-Object { $_.DaysToExpire -lt 2 } |
        Send-PasswordExpiryMessageToUser |
        Export-Csv report.csv

.EXAMPLE
    Get-EnabledNonExpiringUsers |
        Add-ExpiryDataToUser |
        Where-Object { $_.DaysToExpire -lt 2 } |
        Send-PasswordExpiryMessageToUser |
        Tee-Object -FilePath notificationlog.txt |
        Format-Table -AutoSize

    On screen display as well as a log file

.NOTES
    General notes
    Version 1.0
    Last modified on 17-11-2019
    Uploaded By Marco Janse

    Example by Don Jones and Jeffrey Hicks
    Learn PowerShell Scripting in a Month of Lunches

.LINK
    https://github.com/MarcoJanse/PowerShellTraining/blob/master/PowerShellScripting/Examples/PasswordExpiryToolbox.ps1

#>

Function Get-EnabledNonExpiringUser {
  Get-ADUser -filter {(Enabled -eq $true) -and (PasswordNeverExpires -eq $false)} -properties Name,PasswordNeverExpires,PasswordExpired,PasswordLastSet,EmailAddress |
  Where-Object { $_.passwordexpired -eq $false }
}

Function Add-ExpiryDataToUser {
 [CmdletBinding()]
 Param(
  [Paramter(ValueFromPipeline=$True)]
  [object[]]$InputObject

 )
 BEGIN {
  
  $defaultMaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy -ErrorAction Stop).MaxPasswordAge.Days  
  Write-Verbose "Max password age $defaultMaxPasswordAge"

 }
 PROCESS {
  ForEach ($user in $inputObject) {

   # determine max password age for user
   # this will either be based on their policy or
   # on the domain defaut if no user specific policy exists
   $passPolicy = Get-ADUserResultantPasswordPolicy $user
   if (($passPolicy) –ne $null) {
    $maxAge = ($passPolicy).MaxPasswordAge.Days
   } else {
    $maxAge = $defaultMaxPasswordAge
   }

   # calculate and round days to expire;
   # create and append text message to
   # user object
   $expiresOn = $user.passwordLastSet.AddDays($maxPasswordAge) 
   $daysToExpire = New-TimeSpan -Start $today -End $expiresOn 

   if ( ($daysToExpire.Days -eq "0") -and ($daysToExpire.TotalHours -le $timeToMidnight.TotalHours) ) { 
        $user | Add-Member -Type NoteProperty -Name UserMessage -Value "today." 
    } 
    if ( ($daysToExpire.Days -eq "0") -and ($daysToExpire.TotalHours -gt $timeToMidnight.TotalHours) -or ($daysToExpire.Days -eq "1") -and ($daysToExpire.TotalHours -le $timeToMidnight2.TotalHours) ) { 
        $user | Add-Member -Type NoteProperty -Name UserMessage -Value "tomorrow." 
    } 
    if ( ($daysToExpire.Days -ge "1") -and ($daysToExpire.TotalHours -gt $timeToMidnight2.TotalHours) ) { 
        $days = $daysToExpire.TotalDays 
        $days = [math]::Round($days) 
        $user | Add-Member -Type NoteProperty -Name UserMessage -Value "in $days days." 
    }   

    $user | Add-Member -Type NoteProperty -Name DaysToExpire -Value $daysToExpire
    $user | Add-Member -Type NoteProperty -Name ExpiresOn -value $expiresOn

    Write-Output $user

  } #foreach
 } #process
} #function

function Send-PasswordExpiryMessageToUser {
    [CmdletBinding()]
    Param(
        [Paramter(ValueFromPipeline=$True)]
        [object[]]$InputObject,

        [Parameter(Mandatory=$True)]
        [string]$From,

        [Parameter(Mandatory=$True)]
        [string]$smtpServer
    )
    BEGIN {

    }
    PROCESS {
        ForEach ($user in $InputObject) {
            $subject = "Password expires $($user.UserMessage)"
            $body = @"
                Dear $($user.name),

                Your password will expire $($user.UserMessage).
                Please change it.

                Love, the Help Desk.
"@

            if ($PSCmdlet.ShouldProcess("send expiry notice","$($user.name) who expires $($user.usermessage)")) {
                    Send-MailMessage -smtpServer $smtpServer -from $from -to $user.emailaddress -subject $subject -body $body  -priority High 
            }

            Write-Output $user
        } #foreach
    } #process
} #function