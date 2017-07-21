function Get-ConnectionToComputer ($ComputerName=$null) {
    if ($ComputerName) {
        $TCP = Get-NetTCPConnection -CimSession $ComputerName `
                                    -State Established `
                                    -RemoteAddress 10.11*
    }
    else {
        $TCP = Get-NetTCPConnection -State Established `
                                    -RemoteAddress 10.11*
    }
    $TCP | `
    Select-Object -Unique RemoteAddress | `
    ForEach-Object {
        Resolve-DnsName $_.RemoteAddress -Type PTR -ErrorAction SilentlyContinue
    } | `
    Select-Object -ExpandProperty NameHost
}

function Get-LoggedOnUsers ($ComputerName) {
    Get-CimInstance -ComputerName $ComputerName `
                    -ClassName Win32_ComputerSystem `
                    -ErrorAction 0 | `
                    Select-Object UserName,Name | `
                    Format-Table -auto
}