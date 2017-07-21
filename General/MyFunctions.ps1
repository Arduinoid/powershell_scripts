#--------------------------
# Get adapters by speed
#--------------------------

function Get-JNetHighLinkSpeed($Speed = 1) {

$iface = Get-NetAdapter

foreach ($s in $iface)
{ if ([int]($s.linkspeed.Split(" ")[0]) -gt $Speed)
{$s} }
}

#-----------------------
# Service check function
#-----------------------

function Get-JServices() {

param([switch]$Restart)

######### New commands for function ##############
$sixbitSQL = Invoke-Command -ComputerName db-r620 -ScriptBlock {gsv | ? Name -Match sixbit | ? Name -NotMatch sixbitdbserver}
$shipworksSQL = Invoke-Command -ComputerName db-r620 -ScriptBlock {gsv | ? Name -Match shipworks}
$SQLBrowser = Invoke-Command -ComputerName db-r620 -ScriptBlock {gsv | ? Name -Match sqlbrowser}
$ServiceGroup = $sixbitSQL,$shipworksSQL,$SQLBrowser
#########
foreach ($service in $ServiceGroup) {
    foreach ($item in $service) {
        if ($item.status -eq "Running") {
            Write-Host $item.displayname -ForegroundColor Green
        }
        else {
            Write-Host $item.displayname -ForegroundColor Red
            if ($Restart) {
                Write-Host "Attempting restart of service" -ForegroundColor Yellow
                Invoke-Command -ComputerName db-r620 -ScriptBlock {Start-Service $Using:item -Verbose}
            }
        }
    }
}
# Test run on services output
# 
#Write-Host $sixbitSQL -ForegroundColor green
#Write-Host $shipworksSQL -ForegroundColor green
#Write-Host $SQLBrowser -ForegroundColor green

# Old output for services
#(gsv | ? Status -Match run).displayname | sls $findMatch | Write-Host -ForegroundColor green
#(gsv | ? Status -Match stop).displayname | sls $findMatch | Write-Host -ForegroundColor red
}

#----------------------
# Database backup check
#----------------------

function Check-JDBBackups() {

param(
[switch]$sixbit,
[switch]$shipworks
)
# Extra parameter variables for easy editing
$position = -1
# Setting the local path variables
$sixLastLocal = (ls '\\db-r620\B$\SHIPWORKS' | date)[$position]
$shipLastLocal = (ls '\\db-r620\B$\SIXBIT' | date)[$position]
# Setting the offsite path variables
$sixLastOffsite = (ls '\\db-r620\X$\ShipWorks' | date)[$position]
$shipLastOffsite = (ls '\\db-r620\X$\SixBit_V1' | date)[$position]
# Begin backup check logic
# SIXBIT switch
if ($sixbit) {
# Local backup check SIXBIT
 if ($sixLastLocal.DayOfYear -eq (date).DayOfYear) {
 Write-Host "Sixbit local-backup is current for -- $sixLastLocal" -ForegroundColor Green
 }
 else {
 Write-Host "Sixbit local-backup not current as of -- $sixLastLocal" -ForegroundColor Red
 }
 # Offsite backup check SIXBIT
 if ($sixLastOffsite.DayOfYear -eq (date).DayOfYear) {
 Write-Host "Sixbit offsite-backup is current for -- $sixLastOffsite" -ForegroundColor Green
 }
 else {
 Write-Host "Sixbit offsite-backup not current as of -- $sixLastOffsite" -ForegroundColor Red
 }
 }
# SHIPWORKS switch
if ($shipworks) {
# Local backup check SHIPWORKS
 if ($shipLastLocal.DayOfYear -eq (date).DayOfYear) {
 Write-Host "Shipworks local-backup is current for -- $shipLastLocal" -ForegroundColor Green
 }
 else {
 Write-Host "Shipworks local-backup not current as of -- $shipLastLocal" -ForegroundColor Red
 }
 # Offsite backup check SHIPWORKS
 if ($shipLastOffsite.DayOfYear -eq (date).DayOfYear) {
 Write-Host "Shipworks offsite-backup is current for -- $shipLastOffsite" -ForegroundColor Green
 }
 else {
 Write-Host "Shipworks offsite-backup not current as of -- $shipLastOffsite" -ForegroundColor Red
 }
 }
}

# --------------------
# All inclusive report
# --------------------

function Get-JReport() {
    
    Write-Host "Backups Report`n------------" -ForegroundColor Yellow
    Check-JDBBackups -sixbit -shipworks
    Write-Host "`nServices Report`n-------------" -ForegroundColor Yellow
    Get-JServices

}

#--------------------------
# Setting up function alias
#--------------------------

Set-Alias report Get-JReport
Set-Alias cjdb Check-JDBBackups
Set-Alias jgns Get-JNetHighLinkSpeed

cls