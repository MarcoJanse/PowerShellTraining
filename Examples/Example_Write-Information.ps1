<#
.SYNOPSIS
    Write-Information Example
.DESCRIPTION
    Just some examples how to use Write-Information
.NOTES
    version 1.0
    2019-06-29
    By Marco Janse

    Version History:
    1.0 Finished version with 3 examples
    0.1 started writing intial script --UNFINISHED--
#>

function Example1 {
    [CmdletBinding()]
    Param()

    Write-Information "First Message" -Tags 'status'
    Write-Information "Note that this had no parameters" -Tags 'notice'
    Write-Information "Second Message" -Tags 'status'

} # Example1

Example1 -InformationAction SilentlyContinue -InformationVariable x

# next, have a look at the contents of $x with tag 'notice'

$x | Where-Object tags -Contains notice

function Example2 {
    [CmdletBinding()]
    Param()

    Write-Information "Starting $($MyInvocation.MyCommand) " -Tags Process
    Write-Information "PSVersion $($PSVersionTable.PSVersion)" -Tags Meta
    Write-Information "OS = $((Get-CimInstance Win32_OperatingSystem).Caption)" -Tags Meta

    Write-Verbose "Getting top 5 processes by WorkingSet"
    Get-Process | Sort-Object WS -Descending | Select-Object -First 5 -OutVariable s

    Write-Information "($s[0] | Out-String)" -Tags Data

    Write-Information "Ending $($MyInvocation.MyCommand) " -Tags Process

} # Example2

Example2 -InformationAction Continue

Function Example3 {
    [CmdletBinding()]
    param()

    if ($PSBoundParameters.ContainsKey("InformationVariable")) {
        $Info = $true
        $InfVar = $PSBoundParameters["InformationVariable"]
    }

    if ($Info) {
        Write-Host "Starting $($MyInvocation.MyCommand)" -ForegroundColor Green
        (Get-Variable $InfVar).Value[-1].Tags.Add("Process")

        Write-Host "PSVersion = $($PSVersionTable.PSVersion)" -ForegroundColor Green
        (Get-Variable $InfVar).Value[-1].tags.Add("Meta")
        
        Write-Host "OS = $((Get-CimInstance Win32_OperatingSystem).Caption)" -ForegroundColor Green
        (Get-Variable $InfVar).Value[-1].tags.Add("Meta")

        Write-Verbose "Getting top 5 processes by WorkingSet"
        Get-Process | Sort-Object WS -Descending | Select-Object -First 5 -OutVariable s

        if ($info) {
            Write-Host ( $s[0] | Out-String ) -ForegroundColor Green
            (Get-Variable $InfVar).Value[-1].Tags.Add("Data")

            Write-Host " Ending $($MyInvocation.MyCommand) " -ForegroundColor Green
            ( Get-Variable $InfVar ).Value[-1].Tags.Add("Process")
        } # if ($info)

    } # if

    
} # Function Example3

Example3 -InformationVariable inf3