
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