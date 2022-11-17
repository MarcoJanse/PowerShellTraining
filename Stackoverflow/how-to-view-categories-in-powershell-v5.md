# How to view categories in Powershell v5?

## Original question

> im running powershell v5 on my machine and i can't seem to run the command
>  
> `GET-HELP -Category Provider.`
>
> Is there an alternative to this command which can be used in v5 or is it a command that's avilable to v3 Powershell?

## My answer

Using Windows Powershell 5.1. when I look at `help Get-Help -full`, I read the following:

> Parameters
>
> -Category <System.String[]>
>
> Displays help only for items in the specified category and their aliases. Conceptual articles are in the HelpFile category.
>
>
>        Required?                    false
>        Position?                    named
>        Default value                None
>        Accept pipeline input?       False
>        Accept wildcard characters?  false

If I do a `Get-Help * | Group-Object Category | Select-Object Name`, I only see the following categories:

- Alias
- Function
- ExternalScript
- Cmdlet
- HelpFile

I get the same categories in PowerShell v7.2

## Reference

[How to view categories in Powershell v5? | Stackoverflow](https://stackoverflow.com/questions/73963720/how-to-view-categories-in-powershell-v5/73965282#73965282)