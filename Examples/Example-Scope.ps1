<#
.SYNOPSIS
    Scope example
.DESCRIPTION
    Just an example how scope works
.NOTES
    version 1.0
    2018-05-20
    By Marco Janse

    Version History
    1.0 - Initial version
#>

$var = 'hello!'

function My-Function {
    Write-Host "In the function; var contains '$var'"
    $var='goodbye!'
    Write-Host "In the function; var is now '$var'"
} # My-Function

Write-Host "In the script; var is '$var'"
Write-Host "Running the function"
My-Function
Write-Host "Function is done"
Write-Host "In the script; var is now '$var'"