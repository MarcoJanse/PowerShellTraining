<#
.SYNOPSIS
    Get-FolderSize Example

.DESCRIPTION
    Get-FolderSize Example from Learn PowerShell Scripting in a Month of Lunches
    This function lists foldersizes of the folders you specify

.PARAMETER Path
    The folder(s) to run the function. Use comma's to enter multiple folders

.EXAMPLE
    PS C:\> Get-FolderSize - Path C:\Windows

.NOTES
    General notes
    Version 1.0
    Last modified on 17-11-2019
    Uploaded By Marco Janse

    Example by Don Jones and Jeffrey Hicks
    Learn PowerShell Scripting in a Month of Lunches

.LINK
    https://github.com/MarcoJanse/PowerShellTraining/blob/master/PowerShellScripting/Examples/Get-FolderSize.ps1

#>

function Get-FolderSize {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$Path
    )
    BEGIN {}
    PROCESS {
        ForEach ($folder in $path) {
            Write-Verbose "Checking $folder"
            if (Test-Path -Path $folder) {
                Write-Verbose " + Path exists"
                $params = @{'Path'=$folder
                            'Recurse'=$true
                            'File'=$true}
                $measure = Get-ChildItem @params | Measure-Object -Property Length -Sum
                [pscustomobject]@{'Path'=$folder
                                  'Files'=$measure.count
                                  'Bytes'=$measure.sum}
            } else {
                Write-Verbose " - Path does not exist"
                [pscustomobject]@{'Path'=$folder
                                  'Files'=0
                                  'Bytes'=0}
            } #if folder exists
        } #foreach
    } #PROCESS
    END {}
} #function
