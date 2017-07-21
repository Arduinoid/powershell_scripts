function Wipe-USBDrive ([switch]$Secure){
    $usb_drive = Get-Disk | Sort-Object Number | Select-Object -Last 1
    if($usb_drive.Number -eq 0){
        echo "For protection, disk# 0 is not allowed for this command"
        echo "plug in a USB drive and run again..."
    }
    else {
        $disk_part = Get-Partition -DiskNumber $usb_drive.Number -ErrorAction 0
        echo "$($usb_drive.FriendlyName) disk#: $($usb_drive.Number)"
        echo "Confirm this disk is correct?"
        $input = Read-Host '(y/n) default(N)'
        if ($input -eq $null) {$input = 'n'}
        if($input -eq 'y') {
            echo 'Standby, beginning disk preperations...'
            if($disk_part -ne $null) {
                echo "Removing $($disk_part.length) partition$(if($disk_part.Length -gt 1) {'s'})"
                $disk_part | Remove-Partition -Confirm:$false
                echo "Partitions removed..."
            }
            echo "Creating partition..."
            New-Partition -DiskNumber $usb_drive.Number -UseMaximumSize -AssignDriveLetter | Out-Null
            $letter = Get-Partition -DiskNumber $usb_drive.Number | Select-Object -ExpandProperty DriveLetter
            echo "Partition created and mounted at drive letter: $($letter)"
            echo "Begin drive formating to FAT file system..."
            Format-Volume -DriveLetter $letter -FileSystem FAT | Out-Null
            echo "File system ready to use!"
            if($Secure){
                cipher /w:$($letter)
            }
        }
        else {
            echo "Terminating disk preperations..."
        }
    }
}