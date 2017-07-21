function Check-DBBackups ([switch]$MakeRestoreFile){
    $location = '\\DB-R620-2\B$\'
    $backup_directories = Get-ChildItem $location
    $extensions = @('*.bak', '*.dif','*.trn')

    if (-not $MakeRestoreFile) {
        Write-Host ">>> Most recent backups of databases..." -ForegroundColor Cyan -BackgroundColor DarkGray
        $backup_directories | ForEach-Object {
            Write-Output "`n$($_.Name) backups:`n>>>>>"
            $path = Join-Path $location $_.Name
            foreach ($ext in $extensions) {
                Get-MostRecentItem -path $path -filter $ext | `
                Select-Object LastWriteTime,name -OutVariable this_file
                if ($ext -eq '*.dif') {
                    $last_dif = $this_file.LastWriteTime
                }
                elseif ($ext -eq '*.trn') {
                    Write-Output 'Total log (.trn) files since last dif:'
                    Get-MostRecentItem -path $path -filter $ext -since $last_dif | `
                    Measure-Object | `
                    Select-Object -ExpandProperty Count
                }
            }
        } 
    }
    else {
        Get-ChildItem $location | % {
            Make-DBRestoreFile $_.FullName
        }
    }
}

function Get-MostRecentItem ($path='.\', $filter='*', $since=$null) {
    if (-not $since) {
        Get-ChildItem $path -Filter $filter | `
        Sort-Object LastWriteTime | `
        Select-Object -Last 1
    }
    else {
        Get-ChildItem $path -Filter $filter | `
        Sort-Object LastWriteTime | `
        Where-Object LastWriteTime -gt $since
    }
}

function Make-DBRestoreFile ($path, $outfile='.\',[switch]$move) {
    $rest_file = "RESTORE {0} [{1}] FROM  DISK = N'{2}' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5"
    

    $extensions = @('*.bak', '*.dif','*.trn')
    $date_now = $((date).GetDateTimeFormats()[105].Replace(':','-'))
    $bak_file = $(Get-MostRecentItem $path $extensions[0])
    $dif_file = $(Get-MostRecentItem $path $extensions[1])
    $log_files = $(Get-ChildItem $path $extensions[2] | Sort-Object LastWriteTime | Where-Object LastWriteTime -gt $dif_file.LastWriteTime)
    $db_name = $($bak_file.Name -split '_backup')[0]
    $file = $($outfile+'Restore_'+$db_name+'_database.sql')
    # $file_name = Join-Path $outfile,'Restore_',$db_name,'.sql'

    $template = @"
    USE [master]
    $("BACKUP LOG [{0}] TO DISK = N'{0}_LogBackup_{1}{2}' WITH NOFORMAT, NOINIT, NAME =N'{0}_LogBackup_{1}', NOSKIP, NOREWIND, NORECOVERY, STATS = 5" -f $db_name, $date_now, ($extensions[0] -replace '\*',''))
    $("RESTORE DATABASE [{0}] FROM  DISK = N'{1}' WITH  FILE = 1, $(if($move){" MOVE N'{0}' TO N'D:{3}\Data\{0}.mdf',  MOVE N'{0}_log' TO N'D:{3}\Log\{0}_log.ldf', "})NORECOVERY,  NOUNLOAD,  STATS = 5" -f $db_name, $bak_file.FullName )
    $("RESTORE DATABASE [{0}] FROM  DISK = N'{1}' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5" -f $db_name, $bak_file.FullName)
    $($log_files | foreach {$($rest_file -f 'LOG', $db_name, $_.FullName)+"`n"})

    GO
"@

    Out-File -FilePath $($outfile + "Restore_{0}_database.sql" -f $db_name) -InputObject $($template -f $db_name, $date_now, $extensions[0])
}