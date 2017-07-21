$ipSite = 'www.canihazip.com'

$webRequest = Invoke-WebRequest -Uri $ipSite
$webRequest.AllElements | Where-Object tagName -eq center | `
Select-Object -ExpandProperty innerHTML