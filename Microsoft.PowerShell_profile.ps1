# TIP: Changing the color values in the powershell window properties will
# change the color represented by the color names. So you can change 'Gray'
# to actually be purple if needed
# set Gray = 100 and DarkGray = 175 otherwise cmdlet properties will disappear

# Change window colors and text
#$host.UI.RawUI.BackgroundColor = 'Gray'
$host.UI.RawUI.WindowTitle = '* Aperture Science Center [Administrator]'

# Add python virtual environment paths here for ease of access
$vDash = 'C:\Users\Jon\Documents\Code\Python\dashboard\Dashboard\venv\Scripts\activate.ps1'

# Customize prompt 
function Prompt {"PoSh: " + "\" + (pwd).path.Split('\')[-1] + " > "}

# Setting up PS Drives
Set-PSDrives | Out-Null

# Changing starting directory and initial greating
cd ~\Documents\Code
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
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

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
    $source = '\\JON-T3600\C$\Deployment\Slack_Bot'
    $destination = '\\NAS-R510\C$\User\Jon\Documents\Slack'
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
        $process = (Get-Process -ComputerName $server -Name pythonw).id
        Write-Host "Slack Bot should now be running on the following process: $process" -ForegroundColor Green
        
    }
}

function Check-DBBackups {
    $location = '\\DB-R620-2\B$\'
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
}

function Check-SlackBot ($LogLength=5) {
    $log_size = icm nas-r510 {ls C:\Scripts\slack_bot_log.txt | select name, @{label='Size';e={"{0:N2}kb" -f  ($_.length / 1kb)}}}
    $last_20 = icm nas-r510 { cat C:\Scripts\slack_bot_log.txt -tail $Using:LogLength | sort -Descending }
    $slack_bot_process = Get-Process -ComputerName nas-r510 pythonw -ErrorAction SilentlyContinue | `
    Format-Table ProcessName, `
                 ID, `
                 @{label='App';e={'Slack Bot'}}
    
    echo $(if ($slack_bot_process) {$slack_bot_process} else {Write-Host 'Python process not running' -ForegroundColor Red})
    echo $log_size | Format-list @{label='Log File';e={$_.name}}, `
                                 Size, `
                                 @{label='Server';e={$_.pscomputername}}
    echo $last_20
}

function Check-ActionTV () {
    Invoke-WebRequest http://action.techvitality.com | `
    Format-List StatusCode, StatusDescription
}