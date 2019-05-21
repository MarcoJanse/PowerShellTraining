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
    1.0 - Did the initial exercise
#>

$data = Import-Csv C:\Scripts\Input\data.csv
$totalqty = 0
$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
    if ($line.transaction -eq 'buy') {
        # buy transaction (we sold)
        $totalqty -= $line.qty
        $totalsold = $line.total 
    } 
    else {
        #sell transaction (we bought)
        $totalqty += $line.qty
        $totalbought = $line.total 
    }
}
"totalqty,totalbought,totalsold,totalamt" | Out-File C:\Scripts\Output\summary.csv