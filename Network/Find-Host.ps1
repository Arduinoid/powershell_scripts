function Find-Host {

    param (
    $ip
    )
    
    $ping = ping -n 1 $ip
    $bool = $ping | Select-String -Pattern "time" -Quiet
    
    if($bool -eq $true) 
    {Write-Host -ForegroundColor Green "Host found at $ip"}
    else {Write-Host -ForegroundColor Red "Can not find host at $ip"}

}