$check_IPs = @(
    @{name = 'Firewall'; ip = '10.11.0.1'},
    @{name = 'Google'; ip = '8.8.8.8'},
    @{name = 'DB-R620-1'; ip = '10.11.10.200'},
    @{name = 'PDC-2016-VM'; ip = '10.11.203.30'},
    @{name = 'NAS-R510'; ip = '10.11.10.202'},
    @{name = 'WEB-R610'; ip = '10.11.10.201'}

)
function Check-NetworkConnection {
    param(
        $IPAdress
    )
    $IPAdress | ForEach {
        if (Test-Connection $_.ip -BufferSize 8 -Count 1 -Quiet ) {
            Write-Host "$($_.name) accessable" -ForegroundColor Green
        }
        else {
            Write-Host "$($_.name) not reachable" -ForegroundColor Red
        }
    }
}