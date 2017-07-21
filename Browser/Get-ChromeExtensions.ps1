##: What server UNC path do you want to store audit files in
$auditfolderpath = "\\server\share\audit"

##: This is the file we will write the extension list to
$auditfilepath = "$($auditfolderpath)\$($env:USERNAME)-$($env:COMPUTERNAME).txt"
Clear-Content $auditfilepath

##: The extensions folder is in local appdata 
$extension_folders = Get-ChildItem -Path "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default\Extensions"

##: Loop through each extension folder
foreach ($extension_folder in $extension_folders ) {

    ##: Get the version specific folder within this extension folder
    $version_folders = Get-ChildItem -Path "$($extension_folder.FullName)"

    ##: Loop through the version folders found
    foreach ($version_folder in $version_folders) {
        ##: The extension folder name is the app id in the Chrome web store
        $appid = $extension_folder.BaseName

        ##: First check the manifest for a name
        $json = Get-Content -Raw -Path "$($version_folder.FullName)\manifest.json" | ConvertFrom-Json
        $name = $json.name

        ##: If we find _MSG_ in the manifest it's probably an app
        if( $name -like "*MSG*" ) {
            ##: Sometimes the folder is en
            if( Test-Path -Path "$($version_folder.FullName)\_locales\en\messages.json" ) {
                $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en\messages.json" | ConvertFrom-Json
                $name = $json.appName.message
                if(!$name) {
                    $name = $json.extName.message
                }
                if(!$name) {
                    $name = $json.app_name.message
                }
            }
            ##: Sometimes the folder is en_US
            if( Test-Path -Path "$($version_folder.FullName)\_locales\en_US\messages.json" ) {
                $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en_US\messages.json" | ConvertFrom-Json
                $name = $json.appName.message
                if(!$name) {
                    $name = $json.extName.message
                }
                if(!$name) {
                    $name = $json.app_name.message
                }
            }
        }

        ##: If we can't get a name from the extension use the app id instead
        if( !$name ) {
            $name = "[$($appid)]"
        }

        ##: Dump to a file
        echo "$name - $appid" | Out-File -Append $auditfilepath
    }

}