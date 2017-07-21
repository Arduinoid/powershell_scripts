# Practice object creation by pairing process with services

Get-Process -PipelineVariable proc|`
% { get-ciminstance Win32_Service -Filter "ProcessID=$($proc.id)" -PipelineVariable service -ErrorAction SilentlyContinue |`
% {
[PSCustomObject]@{
    ProcessName = $proc.name
    PID = $proc.id
    ServiceName = $service.Name
    ServiceDisplayName = $service.DisplayName
    ServiceStartName = $service.StartName
}
}
} |`
ft -AutoSize