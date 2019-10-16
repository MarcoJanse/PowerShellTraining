function Get-TMIPInfo {
    <#
    .SYNOPSIS
        Get-TMIPInfo is a function to query computers and list details of connected network adapters
        
    .DESCRIPTION
        Get-TMIPInfo is a function that uses CIM to query the specified computers for connected
        network adapters and lists details like index, MAC- and IP-addresses

    .PARAMETER ComputerName
        One or more computer names, Using IP addresses will fail with CIM; they will 
        work with WMI. CIM is always attempted first.

    .EXAMPLE
        PS C:\> Get-TMIPInfo -ComputerName localhost,server01
        
        This will query the specified computers using CIM for connected networkadapter

    .NOTES
        Version 1.0
        Last modified on 16-10-2019
        Designed by Don Jones and Jeffrey Hicks
        Lab executed by Marco Janse
        Chapter 16.4.2. of Learn PowerShell Scripting in a Month of Lunches

        The lab assumes that you save the module in \Documents\WindowsPowerShell\Modules\MyTools\MyTools.psm1

        Version History: 
        1.0 - Initial execution of the lab by creating a module manifest and adding the Export-ModuleMember
            - at the end
        
    .LINK
        https://github.com/MarcoJanse/PowerShellTraining/tree/master/PowerShellScripting/Labs/MyTools.psm1

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True)]
        [string[]]$ComputerName
    )
    
    BEGIN {}

    PROCESS {

        ForEach ($comp in $computername) {
            Write-Verbose "Connecting to $comp"
            $s = New-CimSession -ComputerName $comp
            $adapters = Get-NetAdapter -CimSession $s | Where-Object Status -ne 'Disconnected'

            ForEach ($adapter in $adapters) {
                Write-Verbose "  Interface $($adapter.interfaceindex)"
                $addresses = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -CimSession $s

                ForEach ($address in $addresses) {

                    $props = @{'ComputerName'=$Comp
                               'Index'=$adapter.interfaceindex
                               'Name'=$adapter.interfacealias
                               'MAC'=$adapter.macaddress
                               'IPAddress'=$address.ipaddress}
                    New-Object -TypeName PSObject -Property $props

                } #foreach address

            } #adapter

            $s | Remove-CimSession
        } #foreach computer

    } #process

    END {}

} #function

Export-ModuleMember -Function Get-TMIPInfo -Variable ComputerName