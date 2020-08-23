# PowerShell Tips from Jeff Hicks

Copyright Jeff Hicks
[Link to article](https://jdhitsolutions.com/blog/powershell-tips-tricks-and-advice/)

## PowerShell Tweet Tips

* If you can’t run PowerShell effectively in the console, you’ll never be able to write an effective script.
* Always be testing the latest version of PowerShell. It will eventually be a part of your work.
* Using PowerShell interactively at the console to do your job and writing PowerShell scripts and tools are separate tasks each with their own set of best practices and recommendations.
* Consider Get-WmiObject deprecated. Learn to use the CIM cmdlets like `Get-CimInstance`.
* Run `Update-Help` once a month. Better yet, learn how to set it up as a scheduled job.
* Use `Invoke-Item` or its alias ii, to open a folder in Windows Explorer: ii c:\windows
* Expose yourself to PowerShell every day. Even if you do nothing but closely read full help and examples for a few cmdlets or an about topic.
* Those who fail to automate are doomed to repeat their work.
* Don’t forget to look through the PowerShell about topics for help.
* If you don’t do something with PowerShell every day, you’ll never really learn it.
* Enabling PowerShell Remoting is the easy first step. You still need to do your job and properly secure it.
* View the content of any loaded function: `(Get-Item function:prompt).scriptblock` Or `Get-Content function:prompt`
* The forums at PowerShell.org are your best option for accurate and timely help and answers.
* Open the current directory in VSCode. Great when working on a PowerShell module: code .
* Get in the habit of using ***-Full*** when looking at cmdlet help. You could even add a PSDefaultParameterValue.
* Take advantage of the new Is* variables in your PowerShell scripts like `$IsLinux` and `$IsWindows`.
* Is your expression not working the way you expect? Learn how to use `Trace-Command`.
* Do you miss being able to run the PowerShell ISE from a prompt in PowerShell 7 on a Windows platform? All you need to do is define the missing alias in your PowerShell Core profile script: `Set-Alias -Name ise -Value powershell_ise.exe`
* Are you stuck using the PowerShell ISE but want to code with PowerShell 7? Start a remoting session in the ISE. The ISE will then detect and use PowerShell 7 for Intellisense : `Enter-PSSession -ComputerName localhost -ConfigurationName powershell.7`
* Once you understand the object-nature of PowerShell, you can do a lot with object notation. This is a one-line command using the gcim alias of Get-CimInstance:
`(gcim win32_operatingsystem).LastBootUpTime.Date.DayofWeek`

## PowerShell Scripting and Toolmaking

* Know who will use the tool and how they will use it. What will be their expectation?
* Write one type of object to the pipeline.
* Use full cmdlet and parameter names in your scripts. No aliases.
* Be flexible and modular. Always think about re-use.
* Don’t hard code yourself into a corner. Aim for flexibility.
* Documentation is critical and not just internal comments.
* Use the Verb-Noun naming convention for your function and commonly accepted parameter names. Don’t re-invent the wheel.
* Use meaningful variable names that don’t use Hungarian notation. $strComputername is bad. $Computername is good.
* Standardize on script layout with templates and snippets. Especially important in team environments.
* White space and formatting is your friend. VSCode can format your scripts for you. Use it.
* Write your code for the next person. It could be you.
* Include `Write-Verbose` messages from the beginning. They will help you develop your code.
* Learn how to use `Write-Progress` in place of Write-Host to provide execution details.
* Avoid using localhost as a default parameter value. Use `$env:computername` which will always resolve to a “real” name. If you need to script cross-platform you can use `[environment]::machinename`.
* Just because you can use a long, one-line pipelined expression doesn’t mean you should.
* Separate the data you need to run your code from the code itself.
* Avoid using .NET code when a cmdlet will work.
* Recognize that sometimes PowerShell is not the right solution or tool for the task at hand.
* Test your code in a PowerShell session with no profile. Even better, test in a virtual machine of the Windows Sandbox to avoid unintended dependencies.
* Understand the PowerShell paradigm. Don’t write a VBScript using PowerShell commands and think you’re done.
* If you are creating a graphical PowerShell tool, start with a console-based script or function that already works.
* Your first step in creating a new script or function is to read help and examples. Not Google or Bing.
* Leverage splatting to simplify your code.
* Think about how your code will scale. Don’t write a function that only works with one remote computer. How would you write it to work with 10 or 100 or 1000? Think  “managing at scale”.
* If you need credentials in your script or function use a PSCredential type parameter. Never a username and plain text password.
* Learn how to use the Platyps module to create help documentation for commands in your PowerShell module.
