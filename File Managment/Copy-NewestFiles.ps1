function Copy-NewestFiles($Source, $Destination) {
    # Setting up some variables
    $dirs = Get-ChildItem $Source -Directory
    $divider = "#--------------------------------------`n"

    # Loop through each directory
    $dirs | ForEach-Object {
        $current_dir = $_
        echo "`n#>> CURRENT WORKING PATHS"
        echo " >> Source path: $Source\$current_dir\"
        echo " >> Destination path: $Destination\$current_dir\"

        # Get the date of the newest file in the destination directory
        $last_file = Get-ChildItem "$Destination\$_" | sort lastwritetime | select -last 1
        # Get all files from source directory that are newer than the above file
        $newest_files = Get-ChildItem "$Source\$_" | ? lastwritetime -gt $last_file.lastwritetime

        # Check if there are any new files
        if ($newest_files -ne $null) {
            # Copy files from source to destination
            echo "  | $divider$($newest_files.count) | items to copy from $current_dir`n$divider"
            $newest_files | % {
                Copy-Item -Path "$Source\$current_dir\$_" `
                          -Destination "$Destination\$current_dir\$_"
            }
        }

        else {
            # If no new files then echo message to console
            echo "$divider***NO NEW FILES TO COPY FROM $current_dir***`n$divider"
        }
    }
}