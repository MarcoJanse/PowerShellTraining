# Share multiple folders with the same name condition

## Orginal question

>I need everyone's help to get back to the power shell, I currently have a directory tree with a lot of folders you can see the images I borrowed. enter image description here
>I want to share folder "C and F" all directory tree at once with multiple users with view and edit permissions. hope everyone can help. I'm so stupid about this.

## My solution

`New-SmbShare` can be used for creating shared folders.
If I understand correctly, you only want to share folders with a specific name that exist at multiple levels. SMB share names have to be unique, so that will provide a challenge if you want to have a specific sharename
You could partly automate this process by getting prompt for each folder name during the creation:

### Solution 1 - prompt for name

```powershell
$FoldersToShare = Get-ChildItem -Path C:\Tests\ -Recurse | Where-Object { $_.Name -eq 'F' -or $_.Name -eq 'C' } | Select-Object -ExpandProperty FullName

foreach ($folder in $FoldersToShare) { 
    New-SmbShare -Name (Read-Host -Prompt "Enter the sharename for $($folder)") -Path $folder -ChangeAccess "domain\groupname" 
}
```

If there is no pattern in the folders you want to share, but the names are unique, you could make a list of all the folders you want to share like this:

### Solution 2 - create unique folder names

```powershell
Get-ChildItem -Path c:\tests -Directory -Recurse | Select-Object Name, FullName | Export-Csv -NoTypeInformation -NoClobber -Delimiter ';' -Path C:\Tests\Stackoverflow\FoldersToShare.csv
```

Then, modify that list using a text editor or Excel to only contain the folders you want to share and use that to loop through `New-SmbShare`

Finally, use PowerShell to import the contents of the modified csv file and loop through the entries with New-SmbShare to create the shared folders

```powershell
$FoldersToShare = Import-Csv -Path C:\Tests\Stackoverflow\FoldersToShare.csv -Delimiter ';'

foreach ($folder in $FoldersToShare) { 
    New-SmbShare -Name $folder.Name -Path $folder.FullName -ChangeAccess "domain\groupname" 
}
```

For my solution, I created the folder structure from your image under C:\Tests

- C:\Tests\
  - A
    - A1
      - C
      - F
    - A2
      - C
  - B
    - B1
      - C
    - B2
      - C

## Reference

[share multiple folders with the same name condition | Stackoverflow](https://stackoverflow.com/questions/73510155/share-multiple-folders-with-the-same-name-condition/73512281#73512281)