# Search local DNS for ip and convert to host name
function Get-JHostNameUsingIP($IP) {
    
    $dns = ipconfig /displaydns

    foreach ($item in $dns) {
        if ($item.contains($IP)) {
            echo $($dns[$dns.indexof($item) - 5]).split(":")[1]
        }
    }
}