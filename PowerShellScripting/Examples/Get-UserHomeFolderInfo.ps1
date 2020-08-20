<#
.SYNOPSIS
    Get-UserHomeFolderInfo Example

.DESCRIPTION
    Get-UserHomeFolder Example from Learn PowerShell Scripting in a Month of Lunches
    It 

.PARAMETER HomeRootPath
    The folder(s) to run the function. Use comma's to enter multiple folders

.EXAMPLE
    PS C:\> Get-UserHomeFolderInfo - HomeRootPath C:\Windows

.NOTES
    General notes
    Version 1.0
    Last modified on 17-11-2019
    Uploaded By Marco Janse

    Example by Don Jones and Jeffrey Hicks
    Learn PowerShell Scripting in a Month of Lunches

.LINK
    https://github.com/MarcoJanse/PowerShellTraining/blob/master/PowerShellScripting/Examples/Get-UserHomeFolder.ps1
    
#>

function Get-UserHomeFolderInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [string]$HomeRootPath
    )
    BEGIN {}
    PROCESS {
        Write-Verbose "Enumerating $HomeRootPath"
        $params = @{'Path'=$HomeRootPath
                    'Directory'=$True}
        ForEach ($folder in (Get-ChildItem @params)) {
            
            Write-Verbose "Checking $($folder.name)"
            $params = @{'Identity'=$folder.name
                        'ErrorAction'='SilentlyContinue'}
            $user = Get-ADUser @params

            if ($user) {
                Write-Verbose " + User exists"
                #The Get-FolderSize function must exist in the current session
                $result = Get-FolderSize -Path $folder.fullname
                [pscustomobject]@{'User'=$folder.name
                                  'Path'=$folder.fullname
                                  'Files'=$result.files
                                  'Bytes'=$result.bytes
                                  'Status'='OK'}
            } else {
                Write-Verbose " - User does not exist"
                [pscustomobject]@{'User'=$folder.name
                                  'Path'=$folder.fullname
                                  'Files'=0
                                  'Bytes'=0
                                  'Status'="Orphan"}
            } #if user exists

        } #foreach
    } #PROCESS
    END {}
}
