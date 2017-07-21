function Check-DBBackups {
    $location = '\\DB-R620-2\B$\'
    $backup_directories = Get-ChildItem $location
    $extensions = @('*.bak', '*.dif','*.trn')

    Write-Host ">>> Most recent backups of databases..." -ForegroundColor Cyan -BackgroundColor DarkGray
    $backup_directories | ForEach-Object {
        Write-Output "`n$($_.Name) backups:`n>>>>>"
        foreach ($ext in $extensions) {
            $path = Join-Path $location $_.Name
            Get-MostRecent $path $ext | `
            Select-Object LastWriteTime,name -OutVariable this_file
            if ($ext -eq '*.dif') {
                $last_dif = $this_file.LastWriteTime
                echo $last_dif
            }
            elseif ($ext -eq '*.trn') {
                Write-Output 'Total log (.trn) files since last dif:'
                # Get-MostRecent $path $ext $last_dif
            }
        }
        
    }
}

function Get-MostRecent ($path='.\', $filter='*') {
    Get-ChildItem $path -Filter $filter | `
    Sort-Object LastWriteTime | `
    Select-Object -Last 1
}

function Make-DBRestoreFile ($path) {
    $back_log = "BACKUP LOG [{0}] TO DISK = N'{0}_LogBackup_{2}{3}' WITH NOFORMAT, NOINT, NAME =N'{0}_LogBackup_{2}]', NOSKIP, NOREWIND, NORECOVERY, STATS = 5"
    $rest_file = "RESTORE {0} [{1}] FROM  DISK = N'{2}' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5"
    $rest_type = @('DATABASE', 'LOG')
    $extensions = @('*.bak', '*.dif','*.trn')
}
    