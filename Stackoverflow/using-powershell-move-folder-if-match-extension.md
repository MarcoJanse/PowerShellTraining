# Using powershell move folder if match extension

## Original question

> there is multiple folders with two extensions .zip and .txt files. However, if any folder has only a .zip or only a .txt file, then the move command should not work.
> here is something I found, but how can I do it for two extensions?

> ```powershell
> Move-Item -LiteralPath (Get-ChildItem -File -Path N:\Download\*\*.txt).DirectoryName `
>          -Destination N:\Zip -Force -WhatIf

## My solution

There are probably more efficient ways to do this, but I've used the Where-Object to filter.

```powershell
# Customizable variables
$Source = "N:\Download"
$Destination = "N:\Zip"
$Extension1 = "*.txt"
$Extension2 = "*.zip"

# script
$Folders = Get-ChildItem -Path $Source -Recurse -Directory | Select-Object -ExpandProperty FullName

foreach ($Folder in $Folders) {
    if ((Get-ChildItem -Path $Folder |  Where-Object { $_.Name -like $Extension1}) -and (Get-ChildItem -Path $folder |  Where-Object { $_.Name -like $Extension2})) {
        Move-Item -Path "$Folder\$Extension1" -Destination $Destination -Force -Verbose
        Move-Item -Path "$Folder\$Extension2" -Destination $Destination -Force -Verbose
    }
}
```

Using the variables you can easily customize the script with other source and destination folders or extensions
You could omit the -Verbose output once you've seen it in action.

## Reference

[Using powershell move folder if match extension](https://stackoverflow.com/questions/74428364/using-powershell-move-folder-if-match-extension)