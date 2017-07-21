function Set-PSDrives {
    if ( -not $(Get-PSDrive P -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name P `
                    -PSProvider FileSystem `
                    -Root \\NAS-R510\Pictures `
                    -Persist
    }

    if ( -not $(Get-PSDrive Z -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name Z `
                    -PSProvider FileSystem `
                    -Root '\\NAS-R510\Shared Installers' `
                    -Persist `
                    -Scope Global
    }
}
