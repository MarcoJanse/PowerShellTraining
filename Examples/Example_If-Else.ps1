<#
.SYNOPSIS
    If-Else example
.DESCRIPTION
    Just an example how to use If-Else and ElseIf
.NOTES
    version 1.0
    2018-05-06
    By Marco Janse

    Version History
    1.0 Created intial script
#>

[int]$x = Read-Host -Prompt "Enter the value for the If statement testing"
Write-Host -ForegroundColor Magenta "The value of `$x = $x"
Write-Host -ForegroundColor Cyan "Beginning If Statement"
if ($x -eq 1) {
    Write-Host "This is the first If statement"
} elseif ($x -eq 2) {
    Write-Host "This is the first ElseIf statement"
} elseif ($x -eq 3) {
    Write-Host "This is the second ElseIf statement"
} else { Write-Host "This is the Else statement"
}