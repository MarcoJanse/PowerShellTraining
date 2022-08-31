# How to upload a csv to box folder using powershell

## Orginal question

>i'm new to powershell i have a script running on multiple devices to fetch details and i want a single csv to be generated with those details in a box folder . i wanted to know how to upload a csv to box folder using powershell without hard coding any credentials in script.

## My solution

Your question seems more authentication-related than PowerShell syntax-related.

I would first check out the documentation below from Box to get started:

[Automate Box Integration Tasks from PowerShell](https://www.cdata.com/kb/tech/box-ado-powershell.rst)

This link describes how to install the module and use it with these examples:

### PowerShell

#### Install the module

```powershell
Install-Module BoxCmdlets
```

##### Connect

```powershell
$box = Connect-Box  -OAuthClientId "$OAuthClientId" -OAuthClientSecret "$OAuthClientSecret" -CallbackURL "$CallbackURL"
```

##### Search for and retrieve data

```powershell
$id = "123"
$files = Select-Box -Connection $box -Table "Files" -Where "Id = `'$Id`'"
$files
```

There's a whole getting started guide here [Use Box CLI with OAuth 2.0 | developer.box.com](https://developer.box.com/guides/cli/quick-start/) and chapter 5 focuses on [using Powershell scripts with the CLI](https://developer.box.com/guides/cli/quick-start/powershell-script-templates/)

## Reference

[How to upload a csv to box folder using powershell | Stackoverflow](https://stackoverflow.com/questions/73539259/how-to-upload-a-csv-to-box-folder-using-powershell/73553114#73553114)