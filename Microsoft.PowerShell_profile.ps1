# TIP: Changing the color values in the powershell window properties will
# change the color represented by the color names. So you can change 'Gray'
# to actually be purple if needed
# set Gray = 100 and DarkGray = 175 otherwise cmdlet properties will disappear

# Change window colors and text
#$host.UI.RawUI.BackgroundColor = 'Gray'
$ENV:PSModulePath += ";$ENV:MY_MODULES"
$host.UI.RawUI.WindowTitle = '* Aperture Science Center [Administrator]'

# Add python virtual environment paths here for ease of access
# $vDash = 'C:\Users\Jon\Documents\Code\Python\dashboard\Dashboard\venv\Scripts\activate.ps1'
# Start in home directory
cd ~\
# Customize prompt 
function Prompt {
    Write-Host "PoSh:\$((pwd).path.Split('\')[-1]) $(Write-VcsStatus)"
    "$('>' * ($nestedPromptLevel + 1))"
}
# Import posh-git to have better support with Git version control system
Import-Module posh-git

# Setting up PS Drives
Set-PSDrives | Out-Null

# Changing starting directory and initial greating
Clear-Host
$host.UI.RawUI.ForegroundColor = 'Cyan'
echo '   ________  ________  _____ ______   ___  ________      '
echo '  |\   __  \|\   ___ \|\   _ \  _   \|\  \|\   ___  \    '
echo '  \ \  \|\  \ \  \_|\ \ \  \\\__\ \  \ \  \ \  \\ \  \   '
echo '   \ \   __  \ \  \ \\ \ \  \\|__| \  \ \  \ \  \\ \  \  '
echo '    \ \  \ \  \ \  \_\\ \ \  \    \ \  \ \  \ \  \\ \  \ '
echo '     \ \__\ \__\ \_______\ \__\    \ \__\ \__\ \__\\ \__\'
echo '      \|__|\|__|\|_______|\|__|     \|__|\|__|\|__| \|__|'
echo ''
echo '..::Welcome.:back.:TechVitality.:test:.subject::..'
echo ">> Session begins at: $(Get-Date)"
echo ''
$host.UI.RawUI.ForegroundColor = 'White'                         
# Chocolatey profile
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#     Import-Module "$ChocolateyProfile"
# }

function Import-Exchange {
    $cred = Get-Credential
    $Session = New-PSSession `
    -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential $cred `
    -Authentication Basic `
    -AllowRedirection | `
    Write-Output -OutVariable exchange_info
    Import-PSSession $Session
    echo "`nDon't forget to remove the session when done`n"
    # return $exchange_info
}

function Set-PSDrives {
    if ( -not $(Get-PSDrive P -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name P `
                    -PSProvider FileSystem `
                    -Root \\NAS-R510\Pictures `
                    -Persist `
                    -Scope Global
    }

    if ( -not $(Get-PSDrive Z -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name Z `
                    -PSProvider FileSystem `
                    -Root '\\NAS-R510\Shared Installers' `
                    -Persist `
                    -Scope Global
    }
}

function Deploy-SlackBot ([switch]$Start, [switch]$NoCopy) {
    $source = '\\JON-T3600\C$\Deployment\watermark_slack_bot'
    $destination = '\\NAS-R510\C$\Users\Jon\Documents\watermark_slack_bot'
    if (Test-Path $destination) {
        $destination = '\\NAS-R510\C$\Users\Jon\Documents'
    }
    $server = 'NAS-R510'
    if ((Test-Path $source) -and -not $NoCopy) {
        Write-Host "Beginning to copy files to server..." -ForegroundColor Cyan
        Copy-Item -Path $source -Destination $destination -Force -Recurse -Confirm
        Write-Host "Finished copy process" -ForegroundColor Cyan
    }
    if ($Start) {
        if ((Get-Process -ComputerName $server -Name pythonw -ErrorAction SilentlyContinue)) {
            Write-Host 'Slack Bot was running and will now be stopped...' -ForegroundColor Yellow
            Invoke-Command $server {
                Stop-Process -Name pythonw
                Start-Sleep -Seconds 1
                Start-ScheduledTask -TaskPath \ -TaskName 'Slack Bot'
            }
        }
        else {
            Invoke-Command $server {
                Start-ScheduledTask -TaskPath \ -TaskName 'Slack Bot'
            }
        }
        if (Test-Path "$destination\pid.txt") {
            $process = Get-Content "$destination\pid.txt"
            Write-Host "Slack Bot should now be running on the following process: $process" -ForegroundColor Green
        }
        
    }
}


function Check-DBBackups {
    $location = '\\DB-R620-2\D$\Backup\'
    $log = 'backup_copy_log.txt'
    $backup_directories = Get-ChildItem $location
    $extensions = @('*.bak', '*.dif','*.trn')

    Write-Host ">>> Most recent backups of databases..." -ForegroundColor Cyan -BackgroundColor DarkGray
    $backup_directories | ForEach-Object {
        Write-Output "`n$($_.Name) backups:`n>>>>>"
        foreach ($ext in $extensions) {
            $path = Join-Path $location $_.Name
            Get-ChildItem $path -Filter $ext | `
            Sort-Object LastWriteTime | `
            Select-Object -Last 1 | `
            Select-Object LastWriteTime,name -OutVariable this_file
            if ($ext -eq '*.dif') {
                $last_dif = $this_file.LastWriteTime
            }
            elseif ($ext -eq '*.trn') {
                Write-Output 'Total log (.trn) files since last dif:'
                Get-ChildItem $path -Filter $ext | `
                Sort-Object LastWriteTime | `
                Where-Object LastWriteTime -gt $last_dif | `
                Measure-Object | `
                Select-Object -ExpandProperty Count
            }
        }
        
    }
    Write-Output "`n"
    Write-Output '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    Write-Output 'Off Server backup copy report'
    Write-Output '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    Get-Content '\\db-r620-2\D$\backup_copy_log.txt' -Tail 14
}

function Check-SlackBot ($LogLength=5, $server='NAS-R510') {
    $path = "\\$server\c$"
    $log_size = ls "$path\Scripts\slack_bot_log.txt" | select name, @{label='Size';e={"{0:N2}kb" -f  ($_.length / 1kb)}}
    $log_tail = Get-Content -Path "$path\Scripts\slack_bot_log.txt" | sls restarted | select -Last 5
    $bot_pid = cat "$path\watermark_slack_bot\pid.txt"
    $slack_bot_process = "Slack Bot running on PID: $bot_pid"
    
    echo $(if (Get-Process -ComputerName $server -Id $bot_pid -ErrorAction SilentlyContinue) {">>>>`n$slack_bot_process"} else {Write-Host 'Python process not running' -ForegroundColor Red})
    echo $log_size | Format-list @{label='Log File';e={$_.name}}, `
                                 Size, `
                                 @{label='Server';e={$server}}
    
    echo ">>> Last $LogLength restart events recorded in the log`n"
    echo $log_tail
}

function Check-ActionTV () {
    Invoke-WebRequest http://action.techvitality.com | `
    Format-List StatusCode, StatusDescription
}


# This is used to test network connectivity in case someone says "THE INTERNET IS OUT!"
$check_IPs = @(
    @{name = 'Firewall'; ip = '10.11.0.1'},
    @{name = 'Google'; ip = '8.8.8.8'},
    @{name = 'DB-R620-2'; ip = '10.11.10.200'},
    @{name = 'PDC-2016-VM'; ip = '10.11.203.30'},
    @{name = 'NAS-R510'; ip = '10.11.10.202'},
    @{name = 'WEB-R610'; ip = '10.11.10.201'}

)
function Check-NetworkConnection {
    param(
        $IPAdress=$check_IPs
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

function Get-ClockOutTime ($ClockIn, $LunchTime=30, $WorkDay=8, [switch]$WithOutLunch) {
    $t = [datetime]$ClockIn
    if ($WithOutLunch) {
        return "{0:t}" -f $t.addHours($WorkDay)
    }
    else {
        return "{0:t}" -f $t.addHours($WorkDay).AddMinutes($LunchTime)
    }
}

Set-Alias -Name punchout -Value Get-ClockOutTime

function Get-PublicIP {
    (iwr 'http://canihazip.com').AllElements | ? tagName -eq center | select -exp innerText
}

Set-Alias -Name ip -Value Get-PublicIP

function Get-BurnDayStatus {
    param(
        $URL = 'https://www.gwinnettcounty.com/portal/gwinnett/Departments/FireandEmergencyServices/OutdoorBurningInformation',
        $Regex = "^(\w+,.\w+.\d+,.\d+.is.[NnOoTt]*a.[NnOo]*.[BbUuRrNn]+.[DdAaYy]+)"
    )
    $r = Invoke-WebRequest $URL
    return ($r.AllElements.innertext | ? {$_ -match $Regex})[0]
}

function Push-Scripts {
    $SRC = "C:\Users\Jon\Documents\Code\inventory_audit\scripts\bash\*"
    $DEST = '\\10.11.203.100\nfs\scripts\'

    echo "Begin push to NFS server..."
    Copy-Item -Path $SRC -Destination $DEST -Force -Verbose
    echo "Done pushing files to NFS server"
}

Set-Alias -Name BurnDay -Value Get-BurnDayStatus
Set-Alias -Name push -Value Push-Scripts