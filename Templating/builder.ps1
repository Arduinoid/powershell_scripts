$template = Get-Content .\template.psml | Out-String
Invoke-EpsTemplate -Template $template -Binding @{title = 'Test page'; heading = 'Here is my test page'} | Out-File .\page-build.html

ii .\page-build.html