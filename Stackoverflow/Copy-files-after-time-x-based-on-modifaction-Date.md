# Copy files after time x based on modifaction Date

## Original question

> I need a script that only copy files after 5 minutes based on the modification date. Does anyone have a solution for this ?
> 
> I couldn't find any script online.

## My solution

The answer from [jdweng](https://stackoverflow.com/users/5015238/jdweng) is a good solution to identify the files in scope.
You could make your script something like this to easily re-use it with other paths or file age.

```powershell
# Customizable variables
$Source = 'C:\Temp\Input'
$Destination = 'C:\Temp\Output'
[int32]$FileAgeInMinutes = 5

# Script Execution
Get-ChildItem -Path $Source | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-$FileAgeInMinutes) } | Copy-Item -Destination $Destination
```

You could then run a scheduled task using this script and schedule it to run in periodically, depending on your need.

## Reference

[Copy files after time x based on modifaction Date](https://stackoverflow.com/questions/74474476/copy-files-after-time-x-based-on-modifaction-date)