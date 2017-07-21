function Get-LastReboot{
    $GetServers = Get-ADComputer -Filter {OperatingSystem -like "*Server*"} 
    ForEach ($Server in $GetServers) {
        $Servers = $Server.Name
            if (Test-Connection -ComputerName $Servers -BufferSize 16 -Count 1 -Quiet)
                {
                $LastBoot = Get-CimInstance -ComputerName $Servers -ClassName Win32_OperatingSystem | select -exp LastBootUpTime -ErrorAction SilentlyContinue
                Write-Host "$Servers was last rebooted on $(if($LastBoot) {$LastBoot} else {'N/A'})" -ForegroundColor Green
                }}
}

Get-LastReboot