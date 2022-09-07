# Task Scheduler - Powershell script not firing?

## Original question

> I've created numerous scripts in Powershell that are working as intended if I execute them directly, however, when I try and setup a schedule to run these in Task Scheduler (to run with highest prilavages) it doesn't seem to be running anything at all.
> I'm running the following in my actions:

`powershell.exe -ExecutionPolicy Bypass -File C:\PS\Mailboxes\CheckForwardingList.ps1`

> I'm getting a "Last Run Result" of 0x0 and the particular purpose of the above script is to generate a TXT file from EXO which it then mails out via SMTP and I've yet to receive any emails and I also don't see any TXT being generated in the folder where the script is located.
> I do have two additional scripts setup which aren't running but once I've addressed the issue on the above this should quickly rectify the problems.
> Extremely appreciative if people could point me in the right direction here? feels like I'm going in circles with something that from what I can tell should be working?
> Many thanks

## My Solution

I like to test my PowerShell scripts from a command prompt first.

For example a script called `C:\Tests\Test-PowerShellScriptsRunning.ps1` that only contains the following one liner helps me to test if scripts can run successfully on a machine

```powershell
Write-Host -ForegroundColor Yellow "If you see this, then your script is running"
```

Next, I run this script from a command prompt, to get the syntax right in my scheduled task:

```powershell
powershell.exe -nologo -file c:\Tests\Test-PowerShellScriptsRunning.ps1
```

Of course, you can add the `-Executionpolicy bypass` parameter, but I prefer to test the execution policy first. 

However, as you are running a script that connects to ExchangeOnline, I suspect it has to do with the user you are running this task under. Does the script run if you run this task under your credentials or are the credentials stored on the system or in the script?

You might want to check this article to see how you can register an app and authenticate without storing your credentials on the machine to run the script unattended: [App-only authentication for unattended scripts in the EXO V2 module](https://docs.microsoft.com/en-us/powershell/exchange/app-only-auth-powershell-v2?view=exchange-ps)

## Reference

[Task Scheduler - Powershell script not firing?](https://stackoverflow.com/questions/73635293/task-scheduler-powershell-script-not-firing/73636251#73636251)