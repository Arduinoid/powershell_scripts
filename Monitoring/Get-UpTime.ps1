<# 
.DESCRIPTION
This function will will output how many days the server has
been running.
#>

function Get-UpTime ($ComputerName) {
    if($ComputerName -eq $null) {
        $bootdate = Get-CimInstance -ClassName Win32_OperatingSystem |`
        Select-Object -ExpandProperty LastBootUpTime

        $currentDate = get-Date
        return (New-TimeSpan -Start $bootdate -End $currentDate).Days
    }
    else {
        $bootdate = Get-CimInstance -ComputerName $ComputerName `
        -ClassName Win32_OperatingSystem |`
        Select-Object -ExpandProperty LastBootUpTime

        $currentDate = get-Date
        return (New-TimeSpan -Start $bootdate -End $currentDate).Days
    }
}