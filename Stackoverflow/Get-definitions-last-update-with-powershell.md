# Get definitions last update with powershell

## Original question

> Does anyone know how to get the definition last update date? (16/11/2022 7:51)
> This command does not give me the information I need. It give date of "version created" (15/11/2022 23:58)
> 
> `Get-MpComputerStatus`
> Or does anyone know how to check if the definition version is the latest? I'm looking for a way to check that it updates correctly every day.

## My solution

You can use the `*SignatureLastUpdated` and `*SignatureAge` parameters to check this

```powershell
Get-MpComputerStatus | select *SignatureLastupdated*,*SignatureAge*

AntispywareSignatureLastUpdated : 11/17/2022 2:48:34 AM
AntivirusSignatureLastUpdated   : 11/17/2022 2:48:34 AM
NISSignatureLastUpdated         : 11/17/2022 2:48:34 AM
AntispywareSignatureAge         : 0
AntivirusSignatureAge           : 0
NISSignatureAge                 : 0
```

You could use the SignatureAge parameter and alert on it if it greater than zero or greater than 1, depending on your need. 

If you look at the helpfile of [MSFT_MpComputerStatus class](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/defender/msft-mpcomputerstatus#properties) you can read te following about the Signature age

> Antivirus Signature age in days- if signatures have never been updated you will see an age of 65535 days

So for example to check for the AntiVirus Signatures are older than a day:

```powershell

(Get-MpComputerStatus).AntispywareSignatureAge -gt 0
False
```

To update signatures when they're older than a day:

```powershell
if ((Get-MpComputerStatus).AntispywareSignatureAge -gt 0) { Update-MpSignature -Verbose }
```

## Reference

[Get definitions last update with powershell | Stackoverflow](https://stackoverflow.com/questions/74472571/get-definitions-last-update-with-powershell/74473508#74473508)