function Get-JNetHighLinkSpeed($Speed = 1) {

$iface = Get-NetAdapter

foreach ($s in $iface) `
{ if ([int]($s.linkspeed.Split(" ")[0]) -gt $Speed) `
{$s} }
}

function Get-JServices() {

param([parameter(Mandatory=$true)]$findMatch
)

(gsv | ? Status -Match run).displayname | sls $findMatch | Write-Host -ForegroundColor green
(gsv | ? Status -Match stop).displayname | sls $findMatch | Write-Host -ForegroundColor red
}

function Check-JDBBackups() {

param(
[switch]$sixbit,
[switch]$shipworks
)

if ($sixbit) {
 if ((ls '\\db-r620\B$\SIXBIT' | date).DayOfYear[-1] -eq (date).DayOfYear) {
 Write-Host "Sixbit backup is current" -ForegroundColor Green
 }
 else {
 Write-Host "Sixbit backup not current" -ForegroundColor Red
 }
 }
if ($shipworks) {
 if ((ls '\\db-r620\B$\SHIPWORKS' | date).DayOfYear[-1] -eq (date).DayOfYear) {
 Write-Host "Shipworks backup is current" -ForegroundColor Green
 }
 else {
 Write-Host "Shipworks backup not current" -ForegroundColor Red
 }
 }
}

Set-Alias cjdb Check-JDBBackups
Set-Alias jgns Get-JNetHighLinkSpeed
cls