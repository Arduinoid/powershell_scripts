# DSC configuration
$proc = Get-Process w*
[System.Management.Automation.PSCustomObject]@{
    ProcessName = $proc.name
    PID = $proc.id
}