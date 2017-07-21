$search = "network"
$events = Get-EventLog -LogName System

$events | ForEach-Object -Begin { Clear-Host; $i=0; $out="" } `
-Process {if($_.Message -like "*$search*") { $out=$out + $_.Message }; $i = $i + 1;
Write-Progress -Activity "Searching Events" -Status "Progress:" -PercentComplete ($i / $events.count * 100)} `
-end {$out} 