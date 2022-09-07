# PowerShell script to check for VM snapshots and send Email report

## Original question

> I have this Powershell script to check for VM snapshots and send an Email report.

```powershell
#Variables
$vCenter = "Your VSphere address"
$vCenterUser = "Domain\adm-yourusername"
$vCenterPass = "Your Password"

#HTML
$style = @'
<style>
    body {font-family: Arial; font-size: 10pt;}
    table {border: 1px solid red; border-collapse: collapse;}
    th {border: 1px solid; background-color: #4CAF50; color: white; padding: 5px;}
    td {border: 1px solid; padding: 5px;}
</style>
'@

#Connect to vCenter"
CLS
Write-Host "Connecting to $vCenter" -ForegroundColor Blue
Connect-VIServer -Server $vCenter -User $vCenterUser -Password $vCenterPass -Force | Out-Null
Write-Host " Connected to $vCenter" -ForegroundColor Green

#snapshot report
$SnapshotReport = Get-Vm | Get-Snapshot | Select-Object VM,Description,PowerState,SizeGB | 
                  Sort-Object SizeGB | ConvertTo-Html -Head $style | Out-String

#Sending email report
Write-Host "Sending VM snapshot report" -ForegroundColor Blue

# code is nicer/better maintainable if you use splatting
$params = @{
    SmtpServer = "Your SMTP server address"
    From       = "your email address"
    To         = "your email address"
    Subject    = "Snapshot Email Report for $Date"
    Body       = $SnapshotReport
    BodyAsHtml = $true
    # more parameters can go here
}
Send-MailMessage @params
Write-Host " Completed" -ForegroundColor Green
```

> I need to add two more columns to this report, the first one is the username of the person who runs the backup, and the second one is the date.

> I have updated my script (the below script), the problem with the new script is just showing my name (the person who generates the report) instead of the person who created the snapshot, the same issue with the date.

```powershell
$SnapshotReport = Get-Vm | Get-Snapshot | Select-Object 'VM','Description','PowerState','SizeGB', @{N='UserName';E={$env:USERNAME}},@{N='Date';E={Get-Date -Format F}} | Sort-Object 'SizeGB' | ConvertTo-Html -Head $style | Out-String
```

> can someone help me with that? Thanks

## My solution

`$Env:USERNAME` just lists the logged on user that's executing the script. The same goes for Get-Date, your just retrieving the local datetime on your script machine.
For the date you can just add the created property like this:

```powershell
Get-Snapshot | Select-Object VM,Description,PowerState,SizeGB,Created
```

However, you cannot use the Get-Snapshot cmdlet to list the creator. This has to be retrieved from the task history in vCenter, so it also relies on how long your task history retention has been set.

The PowerCli cmdlet you can use for this is `Get-View TaskManager` Then you have to filter the snapshot tasks out of the retrieved tasks and match that with your snapshot create date from the `created` propery of `Get-Snapshot`

The script listed in this blog should give you a good start: [https://p0wershell.com/wp-content/uploads/2014/07/Get-VMSnapshotInformation.ps1_.txt](https://p0wershell.com/wp-content/uploads/2014/07/Get-VMSnapshotInformation.ps1_.txt)

## Reference

[PowerShell script to check for VM snapshots and send Email report](https://stackoverflow.com/questions/73548103/powershell-script-to-check-for-vm-snapshots-and-send-email-report/73548417#73548417)