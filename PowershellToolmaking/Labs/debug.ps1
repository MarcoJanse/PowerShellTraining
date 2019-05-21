<#
.SYNOPSIS
    Debug.ps1 
.DESCRIPTION
    Lab_11 Debug exercise from Learn powershell Toolmaking
    Simple script to learn to debug
        
.EXAMPLE
    PS C:\>debug.ps1
.NOTES
    PowerShell Toolmaking in a Month of Lunches, Debug exercise
    Version 1.0
    Last modified on 2018-05-21
    Designed by Don Jones and Jeffrey Hicks
    Lab executed by Marco Janse
    
    Version History:
    1.2 - Added trace code - listing 11.5
    1.1 - Forgot a bloody line
    1.0 - Did the initial exercise from listing 11.4
#>

[CmdletBinding()]
param()
$data = Import-Csv C:\Scripts\Input\data.csv
Write-Debug -Message "Imported CSV Data"

$totalqty = 0

$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
    if ($line.transaction -eq 'buy') {
        Write-Debug -Message "ENDED BUY transaction (we sold)"
        $totalqty -= $line.qty
        $totalsold = $line.total
    } else {
        $totalqty += $line.qty
        $totalbought = $line.total 
        Write-Debug -Message "ENDED SELL transaction (we bought)"
    }
}

Write-Debug -Message "OUTPUT: $totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)"

"totalqty,totalbought,totalsold,totalamt" | Out-File C:\Scripts\Output\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" | Out-File C:\Scripts\Output\summary.csv -Append