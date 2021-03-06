#requires -version 3.0
#requires -module Hyper-V

Function Get-MyVM {
<#
.Synopsis
Get VM by state
.Description
This command is a proxy function for Get-VM. The parameters are identical to that command with the addition of a parameter to filter virtual machines by their state. The default is to only show running virtual machines. Use * to see all virtual machines.
.Example
PS C:\> get-myvm -computername chi-hvr2


Name       State   CPUUsage(%) MemoryAssigned(M) Uptime     Status            
----       -----   ----------- ----------------- ------     ------            
CHI-CORE01 Running 0           512               2.01:47:42 Operating normally
CHI-DC04   Running 0           1024              2.01:48:10 Operating normally
CHI-FP02   Running 0           512               2.01:47:40 Operating normally
CHI-Win81  Running 0           1226              2.01:47:11 Operating normally

Get all running virtual machines on server CHI-HVR2.
.Example
PS C:\scripts> get-myvm -State saved -computername chi-hvr2

Name     State CPUUsage(%) MemoryAssigned(M) Uptime   Status            
----     ----- ----------- ----------------- ------   ------            
CHI-FP01 Saved 0           0                 00:00:00 Operating normally
CHI-Win8 Saved 0           0                 00:00:00 Operating normally

Get saved virtual machines on server CHI-HVR2.
.Notes
Last Updated: June 20, 2014
Version     : 2.0

.Link
Get-VM
#>
[CmdletBinding(DefaultParameterSetName='Name')]
param(
    [Parameter(ParameterSetName='Id', Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [System.Nullable[guid]]$Id,

    [Parameter(ParameterSetName='Name', Position=0, ValueFromPipeline=$true)]
    [Alias('VMName')]
    [ValidateNotNullOrEmpty()]
    [string[]]$Name="*",

    [Parameter(ParameterSetName='ClusterObject', Mandatory=$true, Position=0, ValueFromPipeline=$true)]
    [ValidateNotNullOrEmpty()]
    [PSTypeName('Microsoft.FailoverClusters.PowerShell.ClusterObject')]
    [psobject]$ClusterObject,

    [Parameter(ParameterSetName='Id')]
    [Parameter(ParameterSetName='Name')]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName = $env:computername,
    
    [Microsoft.HyperV.PowerShell.VMState]$State="Running"
    )
    

begin
{
Write-Verbose "Getting virtual machines on $($computername.ToUpper()) with a state of $state"
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Get-VM', [System.Management.Automation.CommandTypes]::Cmdlet)
        #remove my custom parameter because Get-VM won't recognize it.
        $PSBoundParameters.Remove('State') | Out-Null

        $scriptCmd = {& $wrappedCmd @PSBoundParameters | Where {$_.state -like "$state"} }
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{
    try {
        $steppablePipeline.Process($_) 
    } catch {
        throw
    }
}

end
{
    try {
        $steppablePipeline.End() 
    } catch {
        throw
    }
}

} #end function