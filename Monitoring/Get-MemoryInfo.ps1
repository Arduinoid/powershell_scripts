function Get-MemoryInfo($ComputerName=$env:COMPUTERNAME) {
    $mem = gwmi win32_operatingsystem -ComputerName $ComputerName | select *memory*
    $total = $mem.TotalVisibleMemorySize / (1024*1024)
    $free = $mem.FreePhysicalMemory / (1024*1024)
    $used = $total - $free
    $percUsed = ($used / $total)*100
    $percFree = ($free / $total)*100

    if ($percFree -ge 45) {
        $status = 'OK'
    }
    elseif ($percFree -ge 15) {
        $status = 'Warning'
    }
    else {
        $status = 'Critical'
    }
    echo " >>>> Memory Report for $ComputerName >>>>`n"

    $mem | ft @{n='Status';e={$status}}, `
              @{n='Used';e={"{0:N2}GB ({1:N1}%)" -f ($used,$percUsed)}}, `
              @{n='Free';e={"{0:N2}GB ({1:N1}%)" -f ($free,$percFree)}}, `
              @{n='Total Physical Memory';e={"{0:N2}(GB)" -f $total}} `
              -AutoSize
}