function Get-Inventory {
    Param
    (
        [parameter(Position=0,
        ValueFromPipelineByPropertyName=$true)]
        $Name=$env:COMPUTERNAME
    )
    begin {
        $inventory = @()
    }
    process {
        $inventory += [psobject]@{
            'Server' = $Name
            'System' = gwmi win32_computersystem -ComputerName $Name
            'OS' = gwmi win32_OperatingSystem -ComputerName $Name
            'BIOS' = gwmi Win32_BIOS -ComputerName $Name
            'Processor' = gwmi Win32_Processor -ComputerName $Name
            'Memory' = gwmi Win32_PhysicalMemory -ComputerName $Name
            'MemoryArray' = gwmi Win32_PhysicalMemoryArray -ComputerName $Name
            'Disk' = gwmi Win32_LogicalDisk -ComputerName $Name
            'Network' = gwmi Win32_NetworkAdapterConfiguration -ComputerName $Name
            'Features' = Get-WindowsFeature -ComputerName $Name | ? InstallStatus -eq Installed
        }
    }

    end {
        return $inventory
    }
}